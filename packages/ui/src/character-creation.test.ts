import { describe, expect, it } from 'vitest';
import { postNui } from './nui';
import { findRecoverableDraft } from './CharacterCreation';
import type {
  CharacterConfiguration,
  CharacterMutationOutcome,
  CharacterSummary,
  Result,
} from '@cnr/contracts';
Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });
describe('character creation browser mock', () => {
  it('returns English dynamic character configuration', async () => {
    const result = await postNui<Result<CharacterConfiguration>>('characters.configuration', {});
    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.data.slot_limit).toBe(3);
      expect(result.data.backgrounds[0]?.label).toBe('San Andreas Local');
    }
  });
  it('preserves operation UUIDs for draft retries', async () => {
    const operation_uuid = '0190b7a0-2000-7000-8000-000000000002';
    const result = await postNui<Result<CharacterMutationOutcome>>('characters.createDraft', {
      operation_uuid,
    });
    expect(result.ok).toBe(true);
    if (result.ok) expect(result.data.operation_uuid).toBe(operation_uuid);
  });
  it('recovers an existing draft after reconnecting', () => {
    const active = {
      character_uuid: '0190b7a0-2000-7000-8000-000000000001',
      slot_number: 1,
      status: 'ACTIVE',
      first_name: 'Alex',
      last_name: 'Morgan',
      date_of_birth: '1995-05-20',
      background_code: 'local',
    } satisfies CharacterSummary;
    const draft = {
      ...active,
      character_uuid: '0190b7a0-2000-7000-8000-000000000002',
      slot_number: 2,
      status: 'DRAFT',
    } satisfies CharacterSummary;
    expect(findRecoverableDraft([active, draft])).toEqual(draft);
    expect(findRecoverableDraft([active])).toBeNull();
  });
});
