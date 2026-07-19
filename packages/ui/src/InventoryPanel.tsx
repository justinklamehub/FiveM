/** Displays source-owned inventory slots and proximity-gated personal storage. */
import { useCallback, useEffect, useMemo, useState, type DragEvent } from 'react';
import {
  inventoryContractVersion,
  type InventoryEntry,
  type InventoryOpenView,
  type InventoryRepositionOutcome,
  type InventoryRepositionRequest,
  type InventorySnapshot,
  type InventoryTransferOutcome,
  type InventoryTransferRequest,
  type InventoryWorkspaceSnapshot,
  type PersonalInventorySnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();
const kilograms = (grams: number) => `${(grams / 1000).toFixed(2)} kg`;
export const inventoryIconFallback = (iconKey: string) =>
  iconKey
    .split('_')
    .map((part) => part[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();
export const inventorySlotNumbers = (capacity: number) =>
  Array.from({ length: capacity }, (_, index) => index + 1);

interface InventoryViewState {
  character: InventoryWorkspaceSnapshot['character'];
  storage: InventoryWorkspaceSnapshot['storage'] | null;
  access_label: string | null;
}

interface SlotReference {
  inventory_uuid: string;
  slot: number;
}

type RetryOperation =
  | { event: 'inventory.reposition'; payload: InventoryRepositionRequest }
  | { event: 'inventory.transfer'; payload: InventoryTransferRequest };

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

export function InventoryPanel({
  view,
  onClose,
}: {
  view: InventoryOpenView;
  onClose: () => void;
}) {
  const [workspace, setWorkspace] = useState<InventoryViewState | null>(null);
  const [loading, setLoading] = useState(true);
  const [snapshotError, setSnapshotError] = useState<string | null>(null);
  const [operationError, setOperationError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [selected, setSelected] = useState<SlotReference | null>(null);
  const [dragging, setDragging] = useState<SlotReference | null>(null);
  const [retryOperation, setRetryOperation] = useState<RetryOperation | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setSnapshotError(null);
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

  const inventories = useMemo(
    () =>
      workspace ? [workspace.character, ...(workspace.storage ? [workspace.storage] : [])] : [],
    [workspace],
  );
  const selectedInventory = selected
    ? inventories.find((inventory) => inventory.inventory_uuid === selected.inventory_uuid)
    : undefined;
  const selectedEntry = selectedInventory?.entries.find(
    (entry) => entry.slot_number === selected?.slot,
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
      if (!result.ok) throw new Error(result.error.code);
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
      setSelected(null);
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
      if (!result.ok) throw new Error(result.error.code);
      if (
        result.data.source_inventory_uuid !== payload.source_inventory_uuid ||
        result.data.target_inventory_uuid !== payload.target_inventory_uuid ||
        result.data.source_slot !== payload.source_slot ||
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
      setSelected(null);
    } catch {
      setOperationError('The item could not be transferred. Retry or reopen the locker.');
    } finally {
      setBusy(false);
    }
  }, []);

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
      void performTransfer({
        source_inventory_uuid: source.inventory_uuid,
        target_inventory_uuid: target.inventory_uuid,
        source_slot: source.slot,
        quantity: sourceEntry.quantity,
        request_id: newId(),
        operation_uuid: newId(),
        contract_version: inventoryContractVersion,
      });
    },
    [busy, inventories, performReposition, performTransfer, workspace],
  );

  const activateSlot = (reference: SlotReference, entry?: InventoryEntry) => {
    if (busy) return;
    if (!selected) {
      if (entry) setSelected(reference);
      return;
    }
    if (selected.inventory_uuid === reference.inventory_uuid && selected.slot === reference.slot) {
      setSelected(null);
      return;
    }
    requestMove(selected, reference);
  };

  const startDrag = (
    event: DragEvent<HTMLButtonElement>,
    reference: SlotReference,
    occupied: boolean,
  ) => {
    if (busy || !occupied) return;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', JSON.stringify(reference));
    setDragging(reference);
    setSelected(reference);
  };

  const drop = (event: DragEvent<HTMLButtonElement>, target: SlotReference) => {
    event.preventDefault();
    setDragging(null);
    try {
      const source = JSON.parse(event.dataTransfer.getData('text/plain')) as SlotReference;
      if (typeof source.inventory_uuid === 'string' && Number.isInteger(source.slot))
        requestMove(source, target);
    } catch {
      setOperationError('The drag operation was invalid. Select the source slot and try again.');
    }
  };

  const close = () => {
    void postNui<{ ok: boolean }>('close', {}).catch(() => ({ ok: false }));
    onClose();
  };

  const renderInventory = (inventory: InventorySnapshot) => {
    const entriesBySlot = new Map<number, InventoryEntry>();
    for (const entry of inventory.entries) entriesBySlot.set(entry.slot_number, entry);
    const title = inventory.inventory_type === 'CHARACTER' ? 'Pockets' : 'Personal Locker';
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
            const isSelected =
              selected?.inventory_uuid === reference.inventory_uuid && selected.slot === slot;
            const isDragging =
              dragging?.inventory_uuid === reference.inventory_uuid && dragging.slot === slot;
            return (
              <button
                type="button"
                className={`inventory-slot-tile${entry ? ' inventory-slot-tile--occupied' : ''}${isSelected ? ' inventory-slot-tile--selected' : ''}${isDragging ? ' inventory-slot-tile--dragging' : ''}`}
                key={slot}
                draggable={Boolean(entry) && !busy}
                disabled={busy}
                aria-label={
                  entry
                    ? `${title} slot ${String(slot)}: ${entry.definition.label}`
                    : `Empty ${title.toLowerCase()} slot ${String(slot)}`
                }
                aria-pressed={isSelected}
                title={entry?.definition.description ?? `Empty slot ${String(slot)}`}
                onClick={() => activateSlot(reference, entry)}
                onDragStart={(event) => startDrag(event, reference, Boolean(entry))}
                onDragEnd={() => setDragging(null)}
                onDragOver={(event) => {
                  if (dragging) event.preventDefault();
                }}
                onDrop={(event) => drop(event, reference)}
              >
                <span className="inventory-slot-number">{slot}</span>
                {entry ? (
                  <>
                    <span
                      className="inventory-item-icon"
                      data-icon-key={entry.definition.icon_key}
                      aria-hidden="true"
                    >
                      {inventoryIconFallback(entry.definition.icon_key)}
                    </span>
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
          <span className="status-pill">{view === 'storage' ? 'Secure Storage' : 'Inventory'}</span>
        </div>
        <div className="inventory-heading">
          <div>
            <h1>{view === 'storage' ? 'Inventory & Locker' : 'Personal Inventory'}</h1>
            <p>
              {view === 'storage'
                ? 'Drag complete stacks between your pockets and nearby personal locker.'
                : 'Drag an item or select it and then choose a destination slot.'}
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
                {!busy && selectedEntry && (
                  <span>
                    <strong>{selectedEntry.definition.label}</strong> selected. Choose a slot in
                    either available inventory.
                  </span>
                )}
                {!busy && !selectedEntry && (
                  <span>
                    Select or drag an occupied slot. Cross-inventory placement is server selected.
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
                  else void performTransfer({ ...retryOperation.payload, request_id: newId() });
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
    </main>
  );
}
