import fs from 'node:fs';
import { describe, expect, it } from 'vitest';
const migration = fs.readFileSync(
  'database/migrations/20260716000500_character_lifecycle.sql',
  'utf8',
);
describe('character lifecycle migration', () => {
  it.each([
    'cnr_character_settings',
    'cnr_character_backgrounds',
    'cnr_characters',
    'cnr_character_identities',
    'cnr_document_types',
    'cnr_character_documents',
    'cnr_character_operations',
  ])('owns %s', (table) => expect(migration).toContain(`CREATE TABLE ${table}`));
  it('uses BINARY(16) UUIDs and unique account slots', () => {
    expect(migration).toContain('public_uuid BINARY(16)');
    expect(migration).toContain('uq_cnr_characters_account_slot');
  });
  it('seeds three dynamic slots and an English state ID definition', () => {
    expect(migration).toContain("('slot_limit', 3");
    expect(migration).toContain("'State Identification Card'");
  });
  it('keeps selection and spawn outside the schema', () => {
    expect(migration).not.toContain('selected_character');
    expect(migration).not.toContain('spawn_point');
  });
});
