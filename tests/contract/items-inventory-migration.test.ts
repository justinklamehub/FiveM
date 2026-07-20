import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716000700_items_inventory_foundation.sql',
  'utf8',
);

describe('items and inventory foundation migration', () => {
  it.each([
    'cnr_item_definitions',
    'cnr_item_instances',
    'cnr_inventories',
    'cnr_inventory_items',
    'cnr_item_transactions',
  ])('owns %s', (table) => expect(migration).toContain(`CREATE TABLE ${table}`));

  it('uses binary UUIDs and prevents duplicated operations, starter packages, slots, stacks, and instances', () => {
    expect(migration).toContain('public_uuid BINARY(16)');
    expect(migration).toContain('operation_uuid BINARY(16)');
    expect(migration).toContain('uq_cnr_item_transactions_operation_uuid');
    expect(migration).toContain('uq_cnr_item_transactions_starter_character');
    expect(migration).toContain('uq_cnr_inventory_items_slot');
    expect(migration).toContain('uq_cnr_inventory_items_stack');
    expect(migration).toContain('uq_cnr_inventory_items_instance');
  });

  it('constrains positive quantities, unique instances, capacities, and transaction versions', () => {
    expect(migration).toContain('ck_cnr_inventory_items_quantity');
    expect(migration).toContain('ck_cnr_inventory_items_unique_quantity');
    expect(migration).toContain('ck_cnr_inventories_capacity');
    expect(migration).toContain('ck_cnr_item_transactions_versions');
  });

  it('seeds only English technical starter definitions', () => {
    for (const code of ['water_bottle', 'sandwich', 'state_id']) {
      expect(migration).toContain(`'${code}'`);
    }
  });

  it('rolls back in dependency order', () => {
    const down = migration.slice(migration.indexOf('-- migrate:down'));
    expect(down.indexOf('cnr_item_transactions')).toBeLessThan(down.indexOf('cnr_inventories'));
    expect(down.indexOf('cnr_item_instances')).toBeLessThan(down.indexOf('cnr_item_definitions'));
  });
});
