import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716001300_banking_transfers.sql',
  'utf8',
);

describe('banking transfer migration', () => {
  it('adds account operation guards and both financial account references', () => {
    expect(migration).toContain('last_operation_uuid BINARY(16)');
    expect(migration).toContain('source_financial_account_uuid BINARY(16)');
    expect(migration).toContain('destination_financial_account_uuid BINARY(16)');
    expect(migration).toContain('fk_cnr_financial_transactions_source');
    expect(migration).toContain('fk_cnr_financial_transactions_destination');
  });

  it('separates starter and bank-transfer shapes and contract versions', () => {
    expect(migration).toContain("transaction_type='BANK_TRANSFER'");
    expect(migration).toContain("transaction_type='BANK_TRANSFER' AND contract_version=2");
    expect(migration).toContain(
      'source_financial_account_uuid <> destination_financial_account_uuid',
    );
    expect(migration).toContain("VALUES ('maximum_transfer_minor', 100000000)");
  });

  it('removes transfer rows before restoring the original constraints on rollback', () => {
    const down = migration.slice(migration.indexOf('-- migrate:down'));
    expect(down.indexOf("transaction_type='BANK_TRANSFER'")).toBeLessThan(
      down.indexOf('DROP COLUMN destination_financial_account_uuid'),
    );
    expect(down).toContain("transaction_type='STARTER_ALLOCATION'");
    expect(down).toContain('contract_version=1');
  });
});
