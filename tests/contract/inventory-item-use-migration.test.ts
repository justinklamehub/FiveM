import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716001000_inventory_item_use.sql',
  'utf8',
);

describe('inventory item-use migration', () => {
  it('adds a constrained replayable action without client-selected effects', () => {
    expect(migration).toContain(
      "action IN ('PROVISION_STARTER', 'TRANSFER', 'REPOSITION', 'USE_ITEM')",
    );
    expect(migration).toContain("item_action IN ('DRINK', 'EAT', 'INSPECT_ID', 'SHOW_ID')");
    expect(migration).toContain('quantity = 1');
    expect(migration).toContain("use_handler='state_id_document'");
  });

  it('requires same-inventory source ownership and restores the previous shape on rollback', () => {
    expect(migration).toContain('source_inventory_id = target_inventory_id');
    expect(migration).toContain("DELETE FROM cnr_item_transactions WHERE action='USE_ITEM'");
    expect(migration).toContain('DROP COLUMN item_action');
  });
});
