import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716001400_dynamic_atms_cash_operations.sql',
  'utf8',
);

describe('dynamic ATM banking migration', () => {
  it('stores ATM identity, position, status, and audit actors with binary UUIDs', () => {
    expect(migration).toContain('CREATE TABLE cnr_atms');
    expect(migration).toContain('public_uuid BINARY(16)');
    expect(migration).toContain('created_by_account_uuid BINARY(16)');
    expect(migration).toContain('deactivated_by_account_uuid BINARY(16)');
    expect(migration).toContain('interaction_radius DECIMAL(5, 2)');
    expect(migration).toContain("status IN ('ACTIVE', 'INACTIVE')");
  });

  it('adds a dedicated management permission for owner and administrator roles', () => {
    expect(migration).toContain("'banking.atms.manage'");
    expect(migration).toContain("role_row.code IN ('owner', 'administrator')");
  });

  it('constrains ATM ledger movements to a referenced terminal and contract version', () => {
    expect(migration).toContain('atm_uuid BINARY(16)');
    expect(migration).toContain('fk_cnr_financial_transactions_atm');
    expect(migration).toContain("transaction_type IN ('ATM_DEPOSIT', 'ATM_WITHDRAWAL')");
    expect(migration).toContain('contract_version = 1');
    expect(migration).toContain("VALUES ('maximum_atm_operation_minor', 10000000)");
  });

  it('removes ATM ledger rows before dropping their foreign key and table on rollback', () => {
    const down = migration.slice(migration.indexOf('-- migrate:down'));
    expect(down.indexOf("transaction_type IN ('ATM_DEPOSIT', 'ATM_WITHDRAWAL')")).toBeLessThan(
      down.indexOf('DROP FOREIGN KEY fk_cnr_financial_transactions_atm'),
    );
    expect(down.indexOf('DROP FOREIGN KEY fk_cnr_financial_transactions_atm')).toBeLessThan(
      down.indexOf('DROP TABLE IF EXISTS cnr_atms'),
    );
    expect(down).toContain(
      "DELETE FROM cnr_technical_permissions WHERE code = 'banking.atms.manage'",
    );
  });
});
