import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716000800_inventory_interactions.sql',
  'utf8',
);

describe('inventory interaction migration', () => {
  it('adds stable definition image keys and reposition slot evidence', () => {
    expect(migration).toContain('icon_key VARCHAR(96)');
    expect(migration).toContain('ck_cnr_item_definitions_icon_key');
    expect(migration).toContain('source_slot SMALLINT UNSIGNED');
    expect(migration).toContain('target_slot SMALLINT UNSIGNED');
  });

  it('allows same-inventory repositioning without weakening cross-inventory transfer shape', () => {
    expect(migration).toContain("action IN ('PROVISION_STARTER', 'TRANSFER', 'REPOSITION')");
    expect(migration).toContain("action = 'REPOSITION'");
    expect(migration).toContain('source_inventory_id = target_inventory_id');
    expect(migration).toContain('source_inventory_id <> target_inventory_id');
    expect(migration).toContain('source_slot <> target_slot');
  });

  it('restores the previous constraints and removes added columns on rollback', () => {
    const down = migration.slice(migration.indexOf('-- migrate:down'));
    expect(down).toContain("action IN ('PROVISION_STARTER', 'TRANSFER')");
    expect(down).toContain('DROP COLUMN target_slot');
    expect(down).toContain('DROP COLUMN source_slot');
    expect(down).toContain('DROP COLUMN icon_key');
  });
});
