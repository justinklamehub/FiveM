import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716001100_banking_ledger_foundation.sql',
  'utf8',
);

describe('banking ledger migration', () => {
  it.each([
    'cnr_banking_settings',
    'cnr_financial_accounts',
    'cnr_financial_transactions',
    'cnr_financial_entries',
  ])('owns %s', (table) => expect(migration).toContain(`CREATE TABLE ${table}`));

  it('uses binary UUIDs, integer money, and immutable entry rows', () => {
    expect(migration).toContain('public_uuid BINARY(16)');
    expect(migration).toContain('operation_uuid BINARY(16)');
    expect(migration).toContain('signed_amount_minor BIGINT NOT NULL');
    expect(migration).not.toMatch(/balance\s+(BIGINT|DECIMAL|DOUBLE)/);
  });

  it('enforces one starter transaction and one account of each type per character', () => {
    expect(migration).toContain('uq_cnr_financial_accounts_character_type');
    expect(migration).toContain('uq_cnr_financial_transactions_starter');
    expect(migration).toContain("account_type='SYSTEM_SOURCE'");
  });
});
