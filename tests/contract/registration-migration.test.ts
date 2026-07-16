import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716000400_registration_activation.sql',
  'utf8',
);

describe('registration migration', () => {
  it.each(['cnr_rulesets', 'cnr_registration_operations', 'cnr_ruleset_acceptances'])(
    'owns %s',
    (table) => expect(migration).toContain(`CREATE TABLE ${table}`),
  );
  it('uses binary UUIDs and one current ruleset', () => {
    expect(migration).toContain('public_uuid BINARY(16)');
    expect(migration).toContain('operation_uuid BINARY(16)');
    expect(migration).toContain('uq_cnr_rulesets_one_current');
  });
  it('enforces one operation per account and one acceptance per ruleset', () => {
    expect(migration).toContain('uq_cnr_registration_operations_account');
    expect(migration).toContain('uq_cnr_ruleset_acceptances_account_ruleset');
    expect(migration).toContain('payload_sha256 BINARY(32)');
  });
});
