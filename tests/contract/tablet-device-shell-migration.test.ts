import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716001200_tablet_device_shell.sql',
  'utf8',
);

describe('character Tablet migration', () => {
  it('defines one unique, non-transferable character device with an English item record', () => {
    expect(migration).toContain("'city_tablet'");
    expect(migration).toContain("'City Tablet'");
    expect(migration).toContain("'TOOL'");
    expect(migration).toContain("'city_tablet',\n0, 1, 1, 650, 0, 0, 'open_tablet'");
  });

  it('enforces one idempotent Tablet provisioning transaction per character', () => {
    expect(migration).toContain("CASE WHEN action = 'PROVISION_TABLET'");
    expect(migration).toContain('uq_cnr_item_transactions_tablet_character');
    expect(migration).toContain("action IN ('PROVISION_STARTER', 'PROVISION_TABLET'");
    expect(migration).toContain(
      "item_action IN ('DRINK', 'EAT', 'INSPECT_ID', 'SHOW_ID', 'OPEN_TABLET')",
    );
  });

  it('removes Tablet operations and restores the previous constraints on rollback', () => {
    const down = migration.split('-- migrate:down')[1];
    expect(down).toContain("DELETE FROM cnr_item_transactions WHERE action='PROVISION_TABLET'");
    expect(down).toContain('DROP COLUMN tablet_character_uuid');
    expect(down).toContain("action IN ('PROVISION_STARTER', 'TRANSFER', 'REPOSITION', 'USE_ITEM')");
  });
});
