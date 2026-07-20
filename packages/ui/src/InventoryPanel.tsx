/** Displays source-owned inventory slots and proximity-gated personal storage. */
import {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
  type PointerEvent as ReactPointerEvent,
} from 'react';
import {
  inventoryContractVersion,
  type InventoryEntry,
  type InventoryOpenView,
  type InventoryRepositionOutcome,
  type InventoryRepositionRequest,
  type InventorySnapshot,
  type InventoryTransferOutcome,
  type InventoryTransferRequest,
  type InventoryUseIntent,
  type InventoryUseEffect,
  type InventoryUseOutcome,
  type InventoryUseRequest,
  type InventoryWorkspaceSnapshot,
  type PersonalInventorySnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();
const kilograms = (grams: number) => `${(grams / 1000).toFixed(2)} kg`;
const inventoryIconSources: Readonly<Record<string, string>> = {
  water_bottle: './assets/items/water_bottle.png',
  sandwich: './assets/items/sandwich.png',
  state_id: './assets/items/state_id.png',
};

export const inventoryIconSource = (iconKey: string) => inventoryIconSources[iconKey] ?? null;
export const inventoryIconFallback = (iconKey: string) =>
  iconKey
    .split('_')
    .map((part) => part[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();
export const inventorySlotNumbers = (capacity: number) =>
  Array.from({ length: capacity }, (_, index) => index + 1);
export const clampTransferQuantity = (value: number, maximum: number) =>
  Math.min(Math.max(Math.trunc(Number.isFinite(value) ? value : 1), 1), maximum);

function InventoryIcon({ iconKey, className }: { iconKey: string; className: string }) {
  const source = inventoryIconSource(iconKey);
  const [failed, setFailed] = useState(false);

  useEffect(() => setFailed(false), [source]);

  return (
    <span className={className} data-icon-key={iconKey} aria-hidden="true">
      {source && !failed ? (
        <img src={source} alt="" draggable={false} onError={() => setFailed(true)} />
      ) : (
        inventoryIconFallback(iconKey)
      )}
    </span>
  );
}

interface InventoryViewState {
  character: InventoryWorkspaceSnapshot['character'];
  storage: InventoryWorkspaceSnapshot['storage'] | null;
  access_label: string | null;
}

interface SlotReference {
  inventory_uuid: string;
  slot: number;
}

interface DragSession {
  source: SlotReference;
  entry: InventoryEntry;
  pointerId: number;
  startX: number;
  startY: number;
  started: boolean;
}

interface DragVisual {
  source: SlotReference;
  entry: InventoryEntry;
  x: number;
  y: number;
  phase: 'dragging' | 'dropping';
}

interface PendingQuantityTransfer {
  source: SlotReference;
  target: SlotReference;
  entry: InventoryEntry;
}

interface PendingItemActions {
  inventory_uuid: string;
  entry: InventoryEntry;
}

type RetryOperation =
  | { event: 'inventory.reposition'; payload: InventoryRepositionRequest }
  | { event: 'inventory.transfer'; payload: InventoryTransferRequest }
  | { event: 'inventory.use'; payload: InventoryUseRequest };

export function applyConfirmedInventoryReposition(
  snapshot: InventorySnapshot,
  outcome: InventoryRepositionOutcome,
): InventorySnapshot {
  const sourceEntry = snapshot.entries.find((entry) => entry.slot_number === outcome.source_slot);
  const targetEntry = snapshot.entries.find((entry) => entry.slot_number === outcome.target_slot);
  if (!sourceEntry) throw new Error('The confirmed source slot is not present in the snapshot.');
  if (outcome.mode === 'MOVE' && targetEntry)
    throw new Error('The confirmed move destination is occupied in the snapshot.');
  if (outcome.mode === 'SWAP' && !targetEntry)
    throw new Error('The confirmed swap destination is empty in the snapshot.');

  const entries = snapshot.entries
    .map((entry) => {
      if (entry.entry_uuid === sourceEntry.entry_uuid)
        return { ...entry, slot_number: outcome.target_slot };
      if (entry.entry_uuid === targetEntry?.entry_uuid)
        return { ...entry, slot_number: outcome.source_slot };
      return entry;
    })
    .sort((left, right) => left.slot_number - right.slot_number);

  return { ...snapshot, version: outcome.inventory_version, entries };
}

export function applyConfirmedInventoryTransfer(
  workspace: InventoryWorkspaceSnapshot,
  outcome: InventoryTransferOutcome,
): InventoryWorkspaceSnapshot {
  const inventories: InventorySnapshot[] = [workspace.character, workspace.storage];
  const source = inventories.find(
    (inventory) => inventory.inventory_uuid === outcome.source_inventory_uuid,
  );
  const target = inventories.find(
    (inventory) => inventory.inventory_uuid === outcome.target_inventory_uuid,
  );
  if (!source || !target || source.inventory_type === target.inventory_type)
    throw new Error('The confirmed transfer inventories do not match the workspace.');
  const sourceEntry = source.entries.find((entry) => entry.slot_number === outcome.source_slot);
  const targetEntry = target.entries.find((entry) => entry.slot_number === outcome.target_slot);
  if (!sourceEntry || outcome.quantity < 1 || outcome.quantity > sourceEntry.quantity)
    throw new Error('The confirmed transfer source is not present in the workspace.');
  if (outcome.mode === 'STACK' && targetEntry?.entry_uuid !== outcome.target_entry_uuid)
    throw new Error('The confirmed target stack does not match the workspace.');
  if (outcome.mode !== 'STACK' && targetEntry)
    throw new Error('The confirmed transfer destination is occupied in the workspace.');

  const movedWeight = outcome.quantity * sourceEntry.definition.unit_weight_grams;
  const sourceEntries = source.entries
    .flatMap((entry) => {
      if (entry.entry_uuid !== sourceEntry.entry_uuid) return [entry];
      if (entry.quantity === outcome.quantity) return [];
      return [
        {
          ...entry,
          quantity: entry.quantity - outcome.quantity,
          total_weight_grams: entry.total_weight_grams - movedWeight,
        },
      ];
    })
    .sort((left, right) => left.slot_number - right.slot_number);
  let targetEntries: readonly InventoryEntry[];
  if (outcome.mode === 'STACK' && targetEntry) {
    targetEntries = target.entries.map((entry) =>
      entry.entry_uuid === targetEntry.entry_uuid
        ? {
            ...entry,
            quantity: entry.quantity + outcome.quantity,
            total_weight_grams: entry.total_weight_grams + movedWeight,
          }
        : entry,
    );
  } else {
    targetEntries = [
      ...target.entries,
      {
        ...sourceEntry,
        entry_uuid: outcome.target_entry_uuid,
        slot_number: outcome.target_slot,
        quantity: outcome.quantity,
        total_weight_grams: movedWeight,
      },
    ];
  }
  targetEntries = [...targetEntries].sort((left, right) => left.slot_number - right.slot_number);

  const updatedSource: InventorySnapshot = {
    ...source,
    entries: sourceEntries,
    current_weight_grams: source.current_weight_grams - movedWeight,
    version: outcome.source_version,
  };
  const updatedTarget: InventorySnapshot = {
    ...target,
    entries: targetEntries,
    current_weight_grams: target.current_weight_grams + movedWeight,
    version: outcome.target_version,
  };
  const updated = [updatedSource, updatedTarget];
  const character = updated.find((inventory) => inventory.inventory_type === 'CHARACTER');
  const storage = updated.find((inventory) => inventory.inventory_type === 'PERSONAL_STORAGE');
  if (!character || !storage) throw new Error('The confirmed workspace types are incomplete.');
  return {
    ...workspace,
    character: character as InventoryWorkspaceSnapshot['character'],
    storage: storage as InventoryWorkspaceSnapshot['storage'],
  };
}

export function applyConfirmedInventoryUse(
  snapshot: InventorySnapshot,
  outcome: InventoryUseOutcome,
): InventorySnapshot {
  if (snapshot.inventory_uuid !== outcome.inventory_uuid)
    throw new Error('The confirmed use inventory does not match the snapshot.');
  const sourceEntry = snapshot.entries.find((entry) => entry.slot_number === outcome.source_slot);
  if (!sourceEntry) throw new Error('The confirmed use source is not present in the snapshot.');
  if (outcome.quantity_consumed === 0) return { ...snapshot, version: outcome.inventory_version };
  const consumedWeight = sourceEntry.definition.unit_weight_grams;
  const entries = snapshot.entries.flatMap((entry) => {
    if (entry.entry_uuid !== sourceEntry.entry_uuid) return [entry];
    if (entry.quantity === 1) return [];
    return [
      {
        ...entry,
        quantity: entry.quantity - 1,
        total_weight_grams: entry.total_weight_grams - consumedWeight,
      },
    ];
  });
  return {
    ...snapshot,
    entries,
    current_weight_grams: snapshot.current_weight_grams - consumedWeight,
    version: outcome.inventory_version,
  };
}

export function InventoryPanel({
  view,
  onClose,
  onItemAction,
}: {
  view: InventoryOpenView;
  onClose: () => void;
  onItemAction: (effect: InventoryUseEffect) => void;
}) {
  const [workspace, setWorkspace] = useState<InventoryViewState | null>(null);
  const [loading, setLoading] = useState(true);
  const [snapshotError, setSnapshotError] = useState<string | null>(null);
  const [operationError, setOperationError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [dragVisual, setDragVisual] = useState<DragVisual | null>(null);
  const [dropTarget, setDropTarget] = useState<SlotReference | null>(null);
  const [retryOperation, setRetryOperation] = useState<RetryOperation | null>(null);
  const [pendingQuantityTransfer, setPendingQuantityTransfer] =
    useState<PendingQuantityTransfer | null>(null);
  const [pendingItemActions, setPendingItemActions] = useState<PendingItemActions | null>(null);
  const [transferQuantity, setTransferQuantity] = useState(1);
  const dragSession = useRef<DragSession | null>(null);
  const dropAnimationTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setSnapshotError(null);
    setPendingQuantityTransfer(null);
    setPendingItemActions(null);
    try {
      if (view === 'storage') {
        const result = await postNui<Result<InventoryWorkspaceSnapshot>>('inventory.workspace', {
          request_id: newId(),
          contract_version: inventoryContractVersion,
        });
        if (!result.ok) throw new Error(result.error.code);
        setWorkspace(result.data);
      } else {
        const result = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
          request_id: newId(),
          contract_version: inventoryContractVersion,
        });
        if (!result.ok) throw new Error(result.error.code);
        setWorkspace({ character: result.data, storage: null, access_label: null });
      }
    } catch {
      setWorkspace(null);
      setSnapshotError(
        view === 'storage'
          ? 'The personal locker is unavailable. Move to the configured locker and try again.'
          : 'Your personal inventory is currently unavailable. Please try again.',
      );
    } finally {
      setLoading(false);
    }
  }, [view]);

  useEffect(() => {
    void load();
  }, [load]);

  useEffect(
    () => () => {
      if (dropAnimationTimer.current) clearTimeout(dropAnimationTimer.current);
    },
    [],
  );

  useEffect(() => {
    if (!pendingQuantityTransfer && !pendingItemActions) return;
    const cancel = (event: KeyboardEvent) => {
      if (event.key === 'Escape' && !busy) {
        setPendingQuantityTransfer(null);
        setPendingItemActions(null);
      }
    };
    window.addEventListener('keydown', cancel);
    return () => window.removeEventListener('keydown', cancel);
  }, [busy, pendingItemActions, pendingQuantityTransfer]);

  const inventories = useMemo(
    () =>
      workspace ? [workspace.character, ...(workspace.storage ? [workspace.storage] : [])] : [],
    [workspace],
  );
  const updateInventory = (
    state: InventoryViewState,
    inventoryUuid: string,
    update: (inventory: InventorySnapshot) => InventorySnapshot,
  ): InventoryViewState => {
    if (state.character.inventory_uuid === inventoryUuid)
      return {
        ...state,
        character: update(state.character) as InventoryViewState['character'],
      };
    if (state.storage?.inventory_uuid === inventoryUuid)
      return {
        ...state,
        storage: update(state.storage) as InventoryWorkspaceSnapshot['storage'],
      };
    throw new Error('The inventory is no longer open.');
  };

  const performReposition = useCallback(async (payload: InventoryRepositionRequest) => {
    setBusy(true);
    setOperationError(null);
    setRetryOperation({ event: 'inventory.reposition', payload });
    try {
      const result = await postNui<Result<InventoryRepositionOutcome>>(
        'inventory.reposition',
        payload,
      );
      if (!result.ok) {
        setOperationError(
          `The move was rejected (${result.error.code}). Reference: ${result.error.correlation_id}`,
        );
        return;
      }
      if (
        result.data.source_slot !== payload.source_slot ||
        result.data.target_slot !== payload.target_slot
      )
        throw new Error('The confirmed reposition result does not match the request.');
      setWorkspace((current) =>
        current
          ? updateInventory(current, payload.inventory_uuid, (inventory) =>
              applyConfirmedInventoryReposition(inventory, result.data),
            )
          : current,
      );
      setRetryOperation(null);
    } catch {
      setOperationError('The item could not be moved. Retry the operation or reopen the view.');
    } finally {
      setBusy(false);
    }
  }, []);

  const performTransfer = useCallback(async (payload: InventoryTransferRequest) => {
    setBusy(true);
    setOperationError(null);
    setRetryOperation({ event: 'inventory.transfer', payload });
    try {
      const result = await postNui<Result<InventoryTransferOutcome>>('inventory.transfer', payload);
      if (!result.ok) {
        setOperationError(
          `The transfer was rejected (${result.error.code}). Reference: ${result.error.correlation_id}`,
        );
        return;
      }
      if (
        result.data.source_inventory_uuid !== payload.source_inventory_uuid ||
        result.data.target_inventory_uuid !== payload.target_inventory_uuid ||
        result.data.source_slot !== payload.source_slot ||
        result.data.target_slot !== payload.target_slot ||
        result.data.quantity !== payload.quantity
      )
        throw new Error('The confirmed transfer result does not match the request.');
      setWorkspace((current) => {
        if (!current?.storage) return current;
        return applyConfirmedInventoryTransfer(
          {
            character: current.character,
            storage: current.storage,
            access_label: current.access_label ?? 'Personal Locker',
          },
          result.data,
        );
      });
      setRetryOperation(null);
    } catch {
      setOperationError('The item could not be transferred. Retry or reopen the locker.');
    } finally {
      setBusy(false);
    }
  }, []);

  const performUse = useCallback(
    async (payload: InventoryUseRequest) => {
      setBusy(true);
      setOperationError(null);
      setRetryOperation({ event: 'inventory.use', payload });
      try {
        const result = await postNui<Result<InventoryUseOutcome>>('inventory.use', payload);
        if (!result.ok) {
          setOperationError(
            `The item action was rejected (${result.error.code}). Reference: ${result.error.correlation_id}`,
          );
          return;
        }
        if (
          result.data.inventory_uuid !== payload.inventory_uuid ||
          result.data.source_slot !== payload.source_slot
        )
          throw new Error('The confirmed item action does not match the request.');
        setWorkspace((current) =>
          current
            ? updateInventory(current, payload.inventory_uuid, (inventory) =>
                applyConfirmedInventoryUse(inventory, result.data),
              )
            : current,
        );
        setRetryOperation(null);
        onItemAction(result.data.effect);
      } catch {
        setOperationError('The item action could not be completed. Retry or reopen the inventory.');
      } finally {
        setBusy(false);
      }
    },
    [onItemAction],
  );

  const requestUse = (intent: InventoryUseIntent) => {
    if (!pendingItemActions || busy) return;
    const payload: InventoryUseRequest = {
      inventory_uuid: pendingItemActions.inventory_uuid,
      source_slot: pendingItemActions.entry.slot_number,
      intent,
      request_id: newId(),
      operation_uuid: newId(),
      contract_version: inventoryContractVersion,
    };
    setPendingItemActions(null);
    void performUse(payload);
  };

  const requestMove = useCallback(
    (source: SlotReference, target: SlotReference) => {
      if (!workspace || busy) return;
      const sourceInventory = inventories.find(
        (inventory) => inventory.inventory_uuid === source.inventory_uuid,
      );
      const sourceEntry = sourceInventory?.entries.find(
        (entry) => entry.slot_number === source.slot,
      );
      if (!sourceEntry) return;
      if (source.inventory_uuid === target.inventory_uuid) {
        if (source.slot === target.slot) return;
        void performReposition({
          inventory_uuid: source.inventory_uuid,
          source_slot: source.slot,
          target_slot: target.slot,
          request_id: newId(),
          operation_uuid: newId(),
          contract_version: inventoryContractVersion,
        });
        return;
      }
      if (!workspace.storage) return;
      if (sourceEntry.quantity > 1) {
        setTransferQuantity(sourceEntry.quantity);
        setPendingQuantityTransfer({ source, target, entry: sourceEntry });
        return;
      }
      void performTransfer({
        source_inventory_uuid: source.inventory_uuid,
        target_inventory_uuid: target.inventory_uuid,
        source_slot: source.slot,
        target_slot: target.slot,
        quantity: sourceEntry.quantity,
        request_id: newId(),
        operation_uuid: newId(),
        contract_version: inventoryContractVersion,
      });
    },
    [busy, inventories, performReposition, performTransfer, workspace],
  );

  const confirmQuantityTransfer = () => {
    if (!pendingQuantityTransfer || busy) return;
    const quantity = clampTransferQuantity(
      transferQuantity,
      pendingQuantityTransfer.entry.quantity,
    );
    const { source, target } = pendingQuantityTransfer;
    setPendingQuantityTransfer(null);
    void performTransfer({
      source_inventory_uuid: source.inventory_uuid,
      target_inventory_uuid: target.inventory_uuid,
      source_slot: source.slot,
      target_slot: target.slot,
      quantity,
      request_id: newId(),
      operation_uuid: newId(),
      contract_version: inventoryContractVersion,
    });
  };

  const slotAt = (x: number, y: number) => {
    const element = document
      .elementFromPoint(x, y)
      ?.closest<HTMLElement>('[data-inventory-uuid][data-slot]');
    const inventoryUuid = element?.dataset.inventoryUuid;
    const slot = Number(element?.dataset.slot);
    if (!inventoryUuid || !Number.isInteger(slot) || slot < 1) return null;
    return { reference: { inventory_uuid: inventoryUuid, slot }, element };
  };

  const startPointerDrag = (
    event: ReactPointerEvent<HTMLButtonElement>,
    reference: SlotReference,
    entry: InventoryEntry,
  ) => {
    if (busy || event.button !== 0) return;
    event.preventDefault();
    event.currentTarget.setPointerCapture(event.pointerId);
    dragSession.current = {
      source: reference,
      entry,
      pointerId: event.pointerId,
      startX: event.clientX,
      startY: event.clientY,
      started: false,
    };
  };

  const movePointerDrag = (event: ReactPointerEvent<HTMLButtonElement>) => {
    const session = dragSession.current;
    if (session?.pointerId !== event.pointerId) return;
    event.preventDefault();
    if (!session.started) {
      const distance = Math.hypot(event.clientX - session.startX, event.clientY - session.startY);
      if (distance < 6) return;
      session.started = true;
    }
    const target = slotAt(event.clientX, event.clientY)?.reference ?? null;
    setDropTarget(
      target &&
        (target.inventory_uuid !== session.source.inventory_uuid ||
          target.slot !== session.source.slot)
        ? target
        : null,
    );
    setDragVisual({
      source: session.source,
      entry: session.entry,
      x: event.clientX,
      y: event.clientY,
      phase: 'dragging',
    });
  };

  const finishPointerDrag = (event: ReactPointerEvent<HTMLButtonElement>) => {
    const session = dragSession.current;
    if (session?.pointerId !== event.pointerId) return;
    if (event.currentTarget.hasPointerCapture(event.pointerId))
      event.currentTarget.releasePointerCapture(event.pointerId);
    dragSession.current = null;
    setDropTarget(null);
    if (!session.started) {
      setDragVisual(null);
      return;
    }
    const targetAtPointer = slotAt(event.clientX, event.clientY);
    const target = targetAtPointer?.reference;
    if (
      !target ||
      (target.inventory_uuid === session.source.inventory_uuid &&
        target.slot === session.source.slot)
    ) {
      setDragVisual(null);
      return;
    }
    const bounds = targetAtPointer.element.getBoundingClientRect();
    setDragVisual({
      source: session.source,
      entry: session.entry,
      x: bounds.left + bounds.width / 2,
      y: bounds.top + bounds.height / 2,
      phase: 'dropping',
    });
    if (dropAnimationTimer.current) clearTimeout(dropAnimationTimer.current);
    dropAnimationTimer.current = setTimeout(() => setDragVisual(null), 180);
    requestMove(session.source, target);
  };

  const cancelPointerDrag = (event: ReactPointerEvent<HTMLButtonElement>) => {
    if (dragSession.current?.pointerId !== event.pointerId) return;
    dragSession.current = null;
    setDropTarget(null);
    setDragVisual(null);
  };

  const close = () => {
    setPendingQuantityTransfer(null);
    setPendingItemActions(null);
    void postNui<{ ok: boolean }>('close', {}).catch(() => ({ ok: false }));
    onClose();
  };

  const renderInventory = (inventory: InventorySnapshot) => {
    const entriesBySlot = new Map<number, InventoryEntry>();
    for (const entry of inventory.entries) entriesBySlot.set(entry.slot_number, entry);
    const title = inventory.inventory_type === 'CHARACTER' ? 'Inventory' : 'Container';
    return (
      <section className="inventory-pane" key={inventory.inventory_uuid}>
        <div className="inventory-pane__heading">
          <div>
            <span>{title}</span>
            <small>
              {inventory.entries.length} / {inventory.slot_capacity} slots
            </small>
          </div>
          <strong>
            {kilograms(inventory.current_weight_grams)} /{' '}
            {kilograms(inventory.weight_capacity_grams)}
          </strong>
        </div>
        <div className="inventory-slot-grid" aria-label={`${title} slots`}>
          {inventorySlotNumbers(inventory.slot_capacity).map((slot) => {
            const entry = entriesBySlot.get(slot);
            const reference = { inventory_uuid: inventory.inventory_uuid, slot };
            const isDragging =
              dragVisual?.source.inventory_uuid === reference.inventory_uuid &&
              dragVisual.source.slot === slot;
            const isDropTarget =
              dropTarget?.inventory_uuid === reference.inventory_uuid && dropTarget.slot === slot;
            return (
              <button
                type="button"
                className={`inventory-slot-tile${entry ? ' inventory-slot-tile--occupied' : ''}${isDragging ? ' inventory-slot-tile--dragging' : ''}${isDropTarget ? ' inventory-slot-tile--drop-target' : ''}`}
                key={slot}
                disabled={busy}
                data-inventory-uuid={inventory.inventory_uuid}
                data-slot={slot}
                aria-label={
                  entry
                    ? `Drag ${entry.definition.label} from ${title.toLowerCase()} slot ${String(slot)}`
                    : `Empty ${title.toLowerCase()} slot ${String(slot)}`
                }
                title={entry?.definition.description ?? `Empty slot ${String(slot)}`}
                onClick={(event) => event.preventDefault()}
                onDoubleClick={() => {
                  if (inventory.inventory_type === 'CHARACTER' && entry?.definition.actions.length)
                    setPendingItemActions({ inventory_uuid: inventory.inventory_uuid, entry });
                }}
                onContextMenu={(event) => {
                  event.preventDefault();
                  if (inventory.inventory_type === 'CHARACTER' && entry?.definition.actions.length)
                    setPendingItemActions({ inventory_uuid: inventory.inventory_uuid, entry });
                }}
                onPointerDown={(event) => entry && startPointerDrag(event, reference, entry)}
                onPointerMove={movePointerDrag}
                onPointerUp={finishPointerDrag}
                onPointerCancel={cancelPointerDrag}
              >
                <span className="inventory-slot-number">{slot}</span>
                {entry ? (
                  <>
                    <InventoryIcon
                      className="inventory-item-icon"
                      iconKey={entry.definition.icon_key}
                    />
                    <span className="inventory-item-label">{entry.definition.label}</span>
                    <span className="inventory-item-quantity">×{entry.quantity}</span>
                  </>
                ) : (
                  <span className="inventory-empty-slot" aria-hidden="true" />
                )}
              </button>
            );
          })}
        </div>
      </section>
    );
  };

  return (
    <main className="nui-stage inventory-stage" aria-label="Inventory Workspace">
      <section
        className={`shell-card inventory-card${workspace?.storage ? ' inventory-card--workspace' : ''}`}
      >
        <div className="shell-card__topline">
          <span>{workspace?.access_label ?? 'Personal Equipment'}</span>
          <span className="status-pill">{view === 'storage' ? 'Item Transfer' : 'Inventory'}</span>
        </div>
        <div className="inventory-heading">
          <div>
            <h1>{view === 'storage' ? 'Item Transfer' : 'Personal Inventory'}</h1>
            <p>
              {view === 'storage'
                ? 'Drag items directly between Inventory and Container slots. Stack quantities are selected after drop.'
                : 'Drag items between slots. Double-click or right-click an item to use it.'}
            </p>
          </div>
        </div>

        <div className="inventory-content" aria-busy={loading || busy}>
          {loading && (
            <div className="inventory-loading" role="status">
              <div className="spinner" aria-hidden="true" />
              <span>Loading server inventory…</span>
            </div>
          )}
          {!loading && workspace && (
            <>
              <div className="inventory-workspace">{inventories.map(renderInventory)}</div>
              <div className="inventory-selection" aria-live="polite">
                {busy && <span>Confirming inventory operation…</span>}
                {!busy && (
                  <span>
                    Drag to move. Double-click or right-click an item for available actions.
                  </span>
                )}
              </div>
            </>
          )}
          {snapshotError && <p role="alert">{snapshotError}</p>}
          {operationError && <p role="alert">{operationError}</p>}
        </div>

        <div className="shell-card__footer">
          <span className="runtime-badge">
            {workspace?.storage ? 'Proximity verified by server' : 'Server inventory'}
          </span>
          <div className="inventory-actions">
            {snapshotError && (
              <button type="button" className="secondary-button" onClick={() => void load()}>
                Retry
              </button>
            )}
            {operationError && retryOperation && (
              <button
                type="button"
                className="secondary-button"
                disabled={busy}
                onClick={() => {
                  if (retryOperation.event === 'inventory.reposition')
                    void performReposition({ ...retryOperation.payload, request_id: newId() });
                  else if (retryOperation.event === 'inventory.transfer')
                    void performTransfer({ ...retryOperation.payload, request_id: newId() });
                  else void performUse({ ...retryOperation.payload, request_id: newId() });
                }}
              >
                Retry Operation
              </button>
            )}
            <button type="button" disabled={busy} onClick={close}>
              Close
            </button>
          </div>
        </div>
      </section>
      {pendingQuantityTransfer && (
        <div className="inventory-dialog-backdrop">
          <section
            className="inventory-dialog"
            role="dialog"
            aria-modal="true"
            aria-labelledby="inventory-quantity-title"
          >
            <div className="inventory-dialog__item">
              <InventoryIcon
                className="inventory-item-icon"
                iconKey={pendingQuantityTransfer.entry.definition.icon_key}
              />
              <div>
                <span>Transfer Stack</span>
                <h2 id="inventory-quantity-title">
                  {pendingQuantityTransfer.entry.definition.label}
                </h2>
                <p>Choose how many items to move into the destination slot.</p>
              </div>
            </div>
            <div className="inventory-quantity-stepper">
              <button
                type="button"
                className="secondary-button"
                aria-label="Decrease transfer quantity"
                disabled={busy || transferQuantity <= 1}
                onClick={() => setTransferQuantity((quantity) => Math.max(1, quantity - 1))}
              >
                −
              </button>
              <label>
                <span>Quantity</span>
                <input
                  type="number"
                  min={1}
                  max={pendingQuantityTransfer.entry.quantity}
                  step={1}
                  value={transferQuantity}
                  disabled={busy}
                  onChange={(event) =>
                    setTransferQuantity(
                      clampTransferQuantity(
                        event.currentTarget.valueAsNumber,
                        pendingQuantityTransfer.entry.quantity,
                      ),
                    )
                  }
                />
                <small>of {pendingQuantityTransfer.entry.quantity}</small>
              </label>
              <button
                type="button"
                className="secondary-button"
                aria-label="Increase transfer quantity"
                disabled={busy || transferQuantity >= pendingQuantityTransfer.entry.quantity}
                onClick={() =>
                  setTransferQuantity((quantity) =>
                    Math.min(pendingQuantityTransfer.entry.quantity, quantity + 1),
                  )
                }
              >
                +
              </button>
            </div>
            <div className="inventory-dialog__actions">
              <button
                type="button"
                className="secondary-button"
                disabled={busy}
                onClick={() => setTransferQuantity(pendingQuantityTransfer.entry.quantity)}
              >
                All
              </button>
              <button
                type="button"
                className="secondary-button"
                disabled={busy}
                onClick={() => setPendingQuantityTransfer(null)}
              >
                Cancel
              </button>
              <button type="button" disabled={busy} onClick={confirmQuantityTransfer}>
                Transfer
              </button>
            </div>
          </section>
        </div>
      )}
      {pendingItemActions && (
        <div className="inventory-dialog-backdrop">
          <section
            className="inventory-dialog"
            role="dialog"
            aria-modal="true"
            aria-labelledby="inventory-actions-title"
          >
            <div className="inventory-dialog__item">
              <InventoryIcon
                className="inventory-item-icon"
                iconKey={pendingItemActions.entry.definition.icon_key}
              />
              <div>
                <span>Item Actions</span>
                <h2 id="inventory-actions-title">{pendingItemActions.entry.definition.label}</h2>
                <p>{pendingItemActions.entry.definition.description}</p>
              </div>
            </div>
            <div className="inventory-item-actions">
              {pendingItemActions.entry.definition.actions.includes('USE') && (
                <button type="button" disabled={busy} onClick={() => requestUse('USE')}>
                  Use Item
                </button>
              )}
              {pendingItemActions.entry.definition.actions.includes('INSPECT') && (
                <button type="button" disabled={busy} onClick={() => requestUse('INSPECT')}>
                  Inspect ID
                </button>
              )}
              {pendingItemActions.entry.definition.actions.includes('SHOW') && (
                <button type="button" disabled={busy} onClick={() => requestUse('SHOW')}>
                  Show to Nearest Player
                </button>
              )}
              <button
                type="button"
                className="secondary-button"
                disabled={busy}
                onClick={() => setPendingItemActions(null)}
              >
                Cancel
              </button>
            </div>
          </section>
        </div>
      )}
      {dragVisual && (
        <div
          className={`inventory-drag-ghost inventory-drag-ghost--${dragVisual.phase}`}
          style={{ left: dragVisual.x, top: dragVisual.y }}
          aria-hidden="true"
        >
          <InventoryIcon
            className="inventory-drag-ghost__icon"
            iconKey={dragVisual.entry.definition.icon_key}
          />
          <span>{dragVisual.entry.definition.label}</span>
          <strong>×{dragVisual.entry.quantity}</strong>
        </div>
      )}
    </main>
  );
}
