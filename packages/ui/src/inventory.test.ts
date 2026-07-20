import { describe, expect, it } from 'vitest';
import {
  inventoryContractVersion,
  type InventoryRepositionOutcome,
  type InventoryRepositionRequest,
  type InventoryTransferOutcome,
  type InventoryTransferRequest,
  type InventoryWorkspaceSnapshot,
  type PersonalInventorySnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';
import {
  applyConfirmedInventoryReposition,
  applyConfirmedInventoryTransfer,
  applyConfirmedInventoryUse,
  clampTransferQuantity,
  inventoryIconFallback,
  inventoryIconSource,
  inventorySlotNumbers,
} from './InventoryPanel';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

describe('inventory browser mock', () => {
  it('builds every configured slot and stable image-key fallback', () => {
    expect(inventorySlotNumbers(24)).toEqual(Array.from({ length: 24 }, (_, index) => index + 1));
    expect(inventoryIconFallback('water_bottle')).toBe('WB');
    expect(inventoryIconFallback('state_id')).toBe('SI');
    expect(inventoryIconSource('water_bottle')).toBe('./assets/items/water_bottle.png');
    expect(inventoryIconSource('sandwich')).toBe('./assets/items/sandwich.png');
    expect(inventoryIconSource('state_id')).toBe('./assets/items/state_id.png');
    expect(inventoryIconSource('future_item')).toBeNull();
  });

  it('clamps a selected transfer quantity to one complete source stack', () => {
    expect(clampTransferQuantity(2, 5)).toBe(2);
    expect(clampTransferQuantity(0, 5)).toBe(1);
    expect(clampTransferQuantity(12, 5)).toBe(5);
    expect(clampTransferQuantity(2.9, 5)).toBe(2);
    expect(clampTransferQuantity(Number.NaN, 5)).toBe(1);
  });

  it('applies one server-confirmed consumable use without refreshing the snapshot', async () => {
    const snapshot = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
      request_id: 'inventory-use-snapshot',
      contract_version: inventoryContractVersion,
    });
    expect(snapshot.ok).toBe(true);
    if (!snapshot.ok) return;
    const water = snapshot.data.entries.find((entry) => entry.definition.code === 'water_bottle');
    expect(water).toBeDefined();
    if (!water) return;
    const outcome = {
      repeated: false,
      operation_uuid: '0190b7a0-6000-7000-8000-000000000090',
      inventory_uuid: snapshot.data.inventory_uuid,
      source_slot: water.slot_number,
      quantity_consumed: 1 as const,
      inventory_version: snapshot.data.version + 1,
      effect: 'DRINK_WATER' as const,
    };
    const updated = applyConfirmedInventoryUse(snapshot.data, outcome);
    expect(updated.entries.find((entry) => entry.entry_uuid === water.entry_uuid)?.quantity).toBe(
      water.quantity - 1,
    );
    expect(updated.current_weight_grams).toBe(
      snapshot.data.current_weight_grams - water.definition.unit_weight_grams,
    );
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

  it('applies confirmed moves and swaps directly without requesting another snapshot', async () => {
    const result = await postNui<Result<PersonalInventorySnapshot>>('inventory.snapshot', {
      request_id: 'inventory-browser-immediate-1',
      contract_version: inventoryContractVersion,
    });
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    const waterSlot = result.data.entries.find(
      (entry) => entry.definition.code === 'water_bottle',
    )?.slot_number;
    const stateIdSlot = result.data.entries.find(
      (entry) => entry.definition.code === 'state_id',
    )?.slot_number;
    expect(waterSlot).toBeTypeOf('number');
    expect(stateIdSlot).toBeTypeOf('number');
    if (waterSlot === undefined || stateIdSlot === undefined) return;

    const moved = applyConfirmedInventoryReposition(result.data, {
      repeated: false,
      operation_uuid: '0190b7a0-6000-7000-8000-000000000091',
      inventory_version: result.data.version + 1,
      source_slot: waterSlot,
      target_slot: 24,
      mode: 'MOVE',
    });
    expect(moved.version).toBe(result.data.version + 1);
    expect(
      moved.entries.find((entry) => entry.definition.code === 'water_bottle')?.slot_number,
    ).toBe(24);

    const swapped = applyConfirmedInventoryReposition(moved, {
      repeated: false,
      operation_uuid: '0190b7a0-6000-7000-8000-000000000092',
      inventory_version: moved.version + 1,
      source_slot: 24,
      target_slot: stateIdSlot,
      mode: 'SWAP',
    });
    expect(
      swapped.entries.find((entry) => entry.definition.code === 'water_bottle')?.slot_number,
    ).toBe(stateIdSlot);
    expect(swapped.entries.find((entry) => entry.definition.code === 'state_id')?.slot_number).toBe(
      24,
    );
  });

  it('builds the personal-locker workspace and applies a server-confirmed transfer', async () => {
    const result = await postNui<Result<InventoryWorkspaceSnapshot>>('inventory.workspace', {
      request_id: 'inventory-browser-workspace-1',
      contract_version: inventoryContractVersion,
    });
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data.storage.inventory_type).toBe('PERSONAL_STORAGE');
    expect(result.data.storage.slot_capacity).toBe(48);
    const water = result.data.character.entries.find(
      (entry) => entry.definition.code === 'water_bottle',
    );
    expect(water).toBeDefined();
    if (!water) return;

    const outcome: InventoryTransferOutcome = {
      repeated: false,
      operation_uuid: '0190b7a0-6000-7000-8000-000000000093',
      source_inventory_uuid: result.data.character.inventory_uuid,
      target_inventory_uuid: result.data.storage.inventory_uuid,
      source_slot: water.slot_number,
      target_slot: 1,
      target_entry_uuid: '0190b7a0-6000-7000-8000-000000000094',
      quantity: water.quantity,
      mode: 'CREATE_STACK',
      source_version: result.data.character.version + 1,
      target_version: result.data.storage.version + 1,
    };
    const transferred = applyConfirmedInventoryTransfer(result.data, outcome);
    expect(
      transferred.character.entries.some((entry) => entry.definition.code === 'water_bottle'),
    ).toBe(false);
    expect(transferred.storage.entries[0]).toMatchObject({
      entry_uuid: outcome.target_entry_uuid,
      slot_number: 1,
      quantity: water.quantity,
    });
    expect(transferred.character.current_weight_grams).toBe(
      result.data.character.current_weight_grams - water.total_weight_grams,
    );
    expect(transferred.storage.current_weight_grams).toBe(water.total_weight_grams);
  });

  it('retains the exact destination slot expressed by a direct cross-panel drop', async () => {
    const transfer: InventoryTransferRequest = {
      source_inventory_uuid: '0190b7a0-6000-7000-8000-000000000010',
      target_inventory_uuid: '0190b7a0-6000-7000-8000-000000000020',
      source_slot: 2,
      target_slot: 17,
      quantity: 2,
      request_id: 'inventory-browser-transfer-1',
      operation_uuid: '0190b7a0-6000-7000-8000-000000000095',
      contract_version: inventoryContractVersion,
    };
    const result = await postNui<Result<InventoryTransferOutcome>>('inventory.transfer', transfer);
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data.target_slot).toBe(17);
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
