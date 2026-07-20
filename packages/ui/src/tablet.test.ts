import { describe, expect, it } from 'vitest';
import {
  inventoryContractVersion,
  type InventoryUseOutcome,
  type PersonalInventorySnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';
import { tabletApps } from './TabletPanel';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

describe('City Tablet browser surface', () => {
  it('exposes Banking as the first enabled app and labels future apps honestly', () => {
    expect(tabletApps.map((app) => app.title)).toEqual([
      'Banking',
      'Documents',
      'City Services',
      'Settings',
    ]);
    expect(tabletApps.filter((app) => app.enabled).map((app) => app.id)).toEqual(['banking']);
    expect(tabletApps.map((app) => app.tone)).toEqual(['gold', 'blue', 'teal', 'graphite']);
  });

  it('opens from the server-shaped Tablet item without consuming it', async () => {
    const snapshot = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
      request_id: 'tablet-snapshot-1',
      contract_version: inventoryContractVersion,
    });
    expect(snapshot.ok).toBe(true);
    if (!snapshot.ok) return;
    const tablet = snapshot.data.entries.find((entry) => entry.definition.code === 'city_tablet');
    expect(tablet?.definition.actions).toEqual(['USE']);
    if (!tablet) return;
    const result = await postNui<Result<InventoryUseOutcome>>('inventory.use', {
      inventory_uuid: snapshot.data.inventory_uuid,
      source_slot: tablet.slot_number,
      intent: 'USE',
      request_id: 'tablet-use-1',
      operation_uuid: '0190b7a0-6000-7000-8000-000000000099',
      contract_version: inventoryContractVersion,
    });
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data).toMatchObject({ effect: 'OPEN_TABLET', quantity_consumed: 0 });
    expect(result.data.inventory_version).toBe(snapshot.data.version);
  });
});
