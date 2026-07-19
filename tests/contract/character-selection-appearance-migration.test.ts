import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const migration = fs.readFileSync(
  'database/migrations/20260716000600_character_selection_appearance.sql',
  'utf8',
);

describe('character selection and appearance migration', () => {
  it.each([
    'cnr_character_session_bindings',
    'cnr_character_appearances',
    'cnr_character_appearance_operations',
    'cnr_character_locations',
  ])('owns %s', (table) => expect(migration).toContain(`CREATE TABLE ${table}`));

  it('uses binary UUIDs and prevents duplicate session, operation, and active-character bindings', () => {
    expect(migration).toContain('public_uuid BINARY(16)');
    expect(migration).toContain('operation_uuid BINARY(16)');
    expect(migration).toContain('uq_cnr_character_bindings_session');
    expect(migration).toContain('uq_cnr_character_bindings_operation_uuid');
    expect(migration).toContain('uq_cnr_character_bindings_active_character');
  });

  it('constrains appearance and controlled spawn state', () => {
    expect(migration).toContain('JSON_VALID(face_features)');
    expect(migration).toContain("model IN ('mp_m_freemode_01', 'mp_f_freemode_01')");
    expect(migration).toContain(
      "spawn_state IN ('APPEARANCE_REQUIRED', 'PENDING', 'SPAWNED', 'ENDED')",
    );
    expect(migration).toContain('ck_cnr_character_bindings_spawn_coordinates');
  });

  it('rolls back tables in dependency order', () => {
    const down = migration.slice(migration.indexOf('-- migrate:down'));
    expect(down.indexOf('cnr_character_locations')).toBeLessThan(
      down.indexOf('cnr_character_session_bindings'),
    );
  });
});
