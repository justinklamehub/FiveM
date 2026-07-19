import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716000900_personal_storage_workspace.sql',
  'utf8',
);

describe('personal storage workspace migration', () => {
  it('stores replayable server-selected transfer placement and mode', () => {
    expect(migration).toContain('transfer_mode VARCHAR(24)');
    expect(migration).toContain("transfer_mode IN ('MOVE_INSTANCE', 'STACK', 'CREATE_STACK')");
    expect(migration).toContain('source_slot IS NOT NULL');
    expect(migration).toContain('target_slot IS NOT NULL');
  });

  it('retains legacy transfer rows while constraining new detailed results', () => {
    expect(migration).toContain('source_slot IS NULL');
    expect(migration).toContain('target_slot IS NULL');
    expect(migration).toContain('source_inventory_id <> target_inventory_id');
    expect(migration).toContain("action = 'REPOSITION'");
  });

  it('restores the version-two transaction shape on rollback', () => {
    const down = migration.slice(migration.indexOf('-- migrate:down'));
    expect(down).toContain("WHERE action='TRANSFER'");
    expect(down).toContain('DROP COLUMN transfer_mode');
    expect(down).toContain('source_slot IS NULL');
    expect(down).toContain('target_slot IS NULL');
  });
});
