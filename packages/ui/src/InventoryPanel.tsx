/** Displays the source-owned personal inventory without accepting item authority from the browser. */
import { useCallback, useEffect, useState } from 'react';
import {
  inventoryContractVersion,
  type PersonalInventorySnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();
const kilograms = (grams: number) => `${(grams / 1000).toFixed(2)} kg`;

export function InventoryPanel({ onClose }: { onClose: () => void }) {
  const [snapshot, setSnapshot] = useState<PersonalInventorySnapshot | null>(null);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setMessage(null);
    try {
      const result = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
        request_id: newId(),
        contract_version: inventoryContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setSnapshot(result.data);
    } catch {
      setSnapshot(null);
      setMessage('Your personal inventory is currently unavailable. Please try again.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

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
            <p>Items and capacity are validated and stored by the server.</p>
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
          <div className="inventory-grid">
            {snapshot.entries.map((entry) => (
              <article className="inventory-entry" key={entry.entry_uuid}>
                <span className="inventory-slot">Slot {entry.slot_number}</span>
                <div>
                  <h2>{entry.definition.label}</h2>
                  <p>{entry.definition.description}</p>
                </div>
                <div className="inventory-entry__meta">
                  <strong>×{entry.quantity}</strong>
                  <span>{kilograms(entry.total_weight_grams)}</span>
                </div>
              </article>
            ))}
          </div>
        )}

        {message && <p role="alert">{message}</p>}
        <div className="shell-card__footer">
          <span className="runtime-badge">
            {snapshot?.starter_provisioned ? 'Starter package secured' : 'Server inventory'}
          </span>
          <div className="inventory-actions">
            {message && (
              <button type="button" className="secondary-button" onClick={() => void load()}>
                Retry
              </button>
            )}
            <button type="button" onClick={() => void close()}>
              Close
            </button>
          </div>
        </div>
      </section>
    </main>
  );
}
