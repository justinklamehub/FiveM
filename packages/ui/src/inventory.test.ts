import { describe, expect, it } from 'vitest';
import {
  inventoryContractVersion,
  type PersonalInventorySnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

describe('inventory browser mock', () => {
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
    expect(result.data.entries.reduce((sum, entry) => sum + entry.total_weight_grams, 0)).toBe(
      result.data.current_weight_grams,
    );
  });
});
