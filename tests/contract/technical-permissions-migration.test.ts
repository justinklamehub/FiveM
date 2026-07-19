import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716000300_technical_roles_permissions.sql',
  'utf8',
);

describe('technical permissions migration', () => {
  it.each([
    'cnr_technical_permissions',
    'cnr_technical_roles',
    'cnr_technical_role_permissions',
    'cnr_account_technical_roles',
  ])('owns the %s table', (table) => {
    expect(migration).toContain(`CREATE TABLE ${table}`);
  });

  it('seeds the initial technical roles', () => {
    expect(migration).toContain("'owner'");
    expect(migration).toContain("'administrator'");
    expect(migration).toContain("'moderator'");
    expect(migration).toContain("'support'");
  });

  it('prevents duplicate active account role assignments', () => {
    expect(migration).toContain('GENERATED ALWAYS AS');
    expect(migration).toContain('uq_cnr_account_technical_roles_active');
    expect(migration).toContain("CASE WHEN status = 'ACTIVE' THEN role_id ELSE NULL END");
  });

  it('keeps technical permissions separate from roleplay jobs', () => {
    expect(migration).not.toContain('character_job');
    expect(migration).not.toContain('police_rank');
    expect(migration).not.toContain('business_employee');
  });
});
