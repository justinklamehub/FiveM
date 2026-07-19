/** Displays and repositions source-owned personal-inventory slots. */
import { useCallback, useEffect, useMemo, useState, type DragEvent } from 'react';
import {
  inventoryContractVersion,
  type InventoryEntry,
  type InventoryRepositionOutcome,
  type InventoryRepositionRequest,
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

export function InventoryPanel({ onClose }: { onClose: () => void }) {
  const [snapshot, setSnapshot] = useState<PersonalInventorySnapshot | null>(null);
  const [loading, setLoading] = useState(true);
  const [snapshotError, setSnapshotError] = useState<string | null>(null);
  const [moveError, setMoveError] = useState<string | null>(null);
  const [moving, setMoving] = useState(false);
  const [selectedSlot, setSelectedSlot] = useState<number | null>(null);
  const [draggingSlot, setDraggingSlot] = useState<number | null>(null);
  const [retryMove, setRetryMove] = useState<InventoryRepositionRequest | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setSnapshotError(null);
    try {
      const result = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
        request_id: newId(),
        contract_version: inventoryContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setSnapshot(result.data);
    } catch {
      setSnapshot(null);
      setSnapshotError('Your personal inventory is currently unavailable. Please try again.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  const entriesBySlot = useMemo(() => {
    const entries = new Map<number, InventoryEntry>();
    for (const entry of snapshot?.entries ?? []) entries.set(entry.slot_number, entry);
    return entries;
  }, [snapshot]);
  const slots = useMemo(
    () => inventorySlotNumbers(snapshot?.slot_capacity ?? 0),
    [snapshot?.slot_capacity],
  );
  const selectedEntry = selectedSlot ? entriesBySlot.get(selectedSlot) : undefined;

  const performMove = useCallback(
    async (payload: InventoryRepositionRequest) => {
      setMoving(true);
      setMoveError(null);
      setRetryMove(payload);
      try {
        const result = await postNui<Result<InventoryRepositionOutcome>>(
          'inventory.reposition',
          payload,
        );
        if (!result.ok) throw new Error(result.error.code);
        setRetryMove(null);
        setSelectedSlot(null);
        await load();
      } catch {
        setMoveError('The item could not be moved. Retry the operation or refresh the inventory.');
      } finally {
        setMoving(false);
      }
    },
    [load],
  );

  const requestMove = useCallback(
    (sourceSlot: number, targetSlot: number) => {
      if (!snapshot || moving || sourceSlot === targetSlot || !entriesBySlot.has(sourceSlot))
        return;
      void performMove({
        inventory_uuid: snapshot.inventory_uuid,
        source_slot: sourceSlot,
        target_slot: targetSlot,
        request_id: newId(),
        operation_uuid: newId(),
        contract_version: inventoryContractVersion,
      });
    },
    [entriesBySlot, moving, performMove, snapshot],
  );

  const activateSlot = (slot: number, entry?: InventoryEntry) => {
    if (moving) return;
    if (selectedSlot === null) {
      if (entry) setSelectedSlot(slot);
      return;
    }
    if (selectedSlot === slot) {
      setSelectedSlot(null);
      return;
    }
    requestMove(selectedSlot, slot);
  };

  const startDrag = (event: DragEvent<HTMLButtonElement>, slot: number) => {
    if (moving || !entriesBySlot.has(slot)) return;
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', String(slot));
    setDraggingSlot(slot);
    setSelectedSlot(slot);
  };

  const drop = (event: DragEvent<HTMLButtonElement>, targetSlot: number) => {
    event.preventDefault();
    const sourceSlot = Number(event.dataTransfer.getData('text/plain'));
    setDraggingSlot(null);
    if (Number.isInteger(sourceSlot)) requestMove(sourceSlot, targetSlot);
  };

  const close = async () => {
    await postNui<{ ok: boolean }>('close', {}).catch(() => ({ ok: false }));
    onClose();
  };

  return (
    <main className="nui-stage inventory-stage" aria-label="Personal Inventory">
      <section className="shell-card inventory-card">
        <div className="shell-card__topline">
          <span>Personal Equipment</span>
          <span className="status-pill">Inventory</span>
        </div>
        <div className="inventory-heading">
          <div>
            <h1>Personal Inventory</h1>
            <p>Drag an item or select it and then choose a destination slot.</p>
          </div>
          {snapshot && (
            <div className="inventory-capacity" aria-label="Inventory capacity">
              <strong>
                {kilograms(snapshot.current_weight_grams)} /{' '}
                {kilograms(snapshot.weight_capacity_grams)}
              </strong>
              <span>
                {snapshot.entries.length} / {snapshot.slot_capacity} slots
              </span>
            </div>
          )}
        </div>

        {loading && (
          <div className="inventory-loading" role="status">
            <div className="spinner" aria-hidden="true" />
            <span>Loading personal inventory…</span>
          </div>
        )}

        {!loading && snapshot && (
          <>
            <div className="inventory-slot-grid" aria-label="Inventory slots">
              {slots.map((slot) => {
                const entry = entriesBySlot.get(slot);
                const selected = selectedSlot === slot;
                return (
                  <button
                    type="button"
                    className={`inventory-slot-tile${entry ? ' inventory-slot-tile--occupied' : ''}${selected ? ' inventory-slot-tile--selected' : ''}${draggingSlot === slot ? ' inventory-slot-tile--dragging' : ''}`}
                    key={slot}
                    draggable={Boolean(entry) && !moving}
                    disabled={moving}
                    aria-label={
                      entry
                        ? `Slot ${String(slot)}: ${entry.definition.label}`
                        : `Empty slot ${String(slot)}`
                    }
                    aria-pressed={selected}
                    title={entry?.definition.description ?? `Empty slot ${String(slot)}`}
                    onClick={() => activateSlot(slot, entry)}
                    onDragStart={(event) => startDrag(event, slot)}
                    onDragEnd={() => setDraggingSlot(null)}
                    onDragOver={(event) => {
                      if (draggingSlot !== null && draggingSlot !== slot) event.preventDefault();
                    }}
                    onDrop={(event) => drop(event, slot)}
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
            <div className="inventory-selection" aria-live="polite">
              {moving && <span>Moving item…</span>}
              {!moving && selectedEntry && (
                <span>
                  <strong>{selectedEntry.definition.label}</strong> selected from slot{' '}
                  {selectedSlot}. Choose another slot to move or swap it.
                </span>
              )}
              {!moving && !selectedEntry && <span>Select or drag an occupied slot.</span>}
            </div>
          </>
        )}

        {snapshotError && <p role="alert">{snapshotError}</p>}
        {moveError && <p role="alert">{moveError}</p>}
        <div className="shell-card__footer">
          <span className="runtime-badge">
            {snapshot?.starter_provisioned ? 'Starter package secured' : 'Server inventory'}
          </span>
          <div className="inventory-actions">
            {snapshotError && (
              <button type="button" className="secondary-button" onClick={() => void load()}>
                Retry
              </button>
            )}
            {moveError && retryMove && (
              <button
                type="button"
                className="secondary-button"
                disabled={moving}
                onClick={() => void performMove({ ...retryMove, request_id: newId() })}
              >
                Retry Move
              </button>
            )}
            <button type="button" disabled={moving} onClick={() => void close()}>
              Close
            </button>
          </div>
        </div>
      </section>
    </main>
  );
}
