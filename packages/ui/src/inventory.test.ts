import { describe, expect, it } from 'vitest';
import {
  inventoryContractVersion,
  type InventoryRepositionOutcome,
  type InventoryRepositionRequest,
  type PersonalInventorySnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';
import { inventoryIconFallback, inventorySlotNumbers } from './InventoryPanel';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

describe('inventory browser mock', () => {
  it('builds every configured slot and stable image-key fallback', () => {
    expect(inventorySlotNumbers(24)).toEqual(Array.from({ length: 24 }, (_, index) => index + 1));
    expect(inventoryIconFallback('water_bottle')).toBe('WB');
    expect(inventoryIconFallback('state_id')).toBe('SI');
  });

  it('returns the server-shaped starter inventory without authoritative request fields', async () => {
    const result = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
      request_id: 'inventory-browser-1',
      contract_version: inventoryContractVersion,
    });
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data.inventory_type).toBe('CHARACTER');
    expect(result.data.starter_provisioned).toBe(true);
    expect(result.data.entries.map((entry) => entry.definition.code)).toEqual([
      'water_bottle',
      'sandwich',
      'state_id',
    ]);
    expect(result.data.entries.map((entry) => entry.definition.icon_key)).toEqual([
      'water_bottle',
      'sandwich',
      'state_id',
    ]);
    expect(result.data.entries.reduce((sum, entry) => sum + entry.total_weight_grams, 0)).toBe(
      result.data.current_weight_grams,
    );
  });

  it('moves browser-mock entries with the same narrow idempotent intent contract', async () => {
    const move: InventoryRepositionRequest = {
      inventory_uuid: '0190b7a0-6000-7000-8000-000000000010',
      source_slot: 1,
      target_slot: 4,
      request_id: 'inventory-browser-move-1',
      operation_uuid: '0190b7a0-6000-7000-8000-000000000099',
      contract_version: inventoryContractVersion,
    };
    const result = await postNui<Result<InventoryRepositionOutcome>>('inventory.reposition', move);
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data.mode).toBe('MOVE');
    const snapshot = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
      request_id: 'inventory-browser-2',
      contract_version: inventoryContractVersion,
    });
    expect(snapshot.ok).toBe(true);
    if (!snapshot.ok) return;
    expect(
      snapshot.data.entries.find((entry) => entry.definition.code === 'water_bottle')?.slot_number,
    ).toBe(4);
  });
});
