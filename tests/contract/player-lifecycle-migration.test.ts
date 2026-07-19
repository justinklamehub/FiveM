import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716000200_accounts_connection_foundation.sql',
  'utf8',
);

describe('Wave 1 connection migration', () => {
  it.each([
    'cnr_accounts',
    'cnr_account_identifiers',
    'cnr_account_restrictions',
    'cnr_whitelist_entries',
    'cnr_account_sessions',
  ])('owns the %s table', (table) => {
    expect(migration).toContain(`CREATE TABLE ${table}`);
  });

  it('enforces one connecting or active session per account', () => {
    expect(migration).toContain('GENERATED ALWAYS AS');
    expect(migration).toContain('uq_cnr_account_sessions_one_active');
    expect(migration).toContain("status IN ('CONNECTING', 'ACTIVE')");
  });

  it('stores hashed identifiers rather than raw identifier values', () => {
    expect(migration).toContain('identifier_hash BINARY(32)');
    expect(migration).not.toContain('identifier_value');
  });
});
