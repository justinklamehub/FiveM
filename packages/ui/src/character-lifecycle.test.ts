import { describe, expect, it } from 'vitest';
import type {
  CharacterAppearanceConfiguration,
  CharacterSelectionOutcome,
  CharacterSummary,
  Result,
} from '@cnr/contracts';
import { updateFaceFeature } from './AppearanceEditor';
import { activeCharacters } from './CharacterLifecycle';
import { postNui } from './nui';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

const active = {
  character_uuid: '0190b7a0-2000-7000-8000-000000000001',
  slot_number: 1,
  status: 'ACTIVE',
  first_name: 'Alex',
  last_name: 'Morgan',
  date_of_birth: '1995-05-20',
  background_code: 'local',
} satisfies CharacterSummary;

describe('character lifecycle browser mock', () => {
  it('offers only active characters for selection', () => {
    expect(activeCharacters([active, { ...active, status: 'DRAFT' }])).toEqual([active]);
  });

  it('preserves the selection operation and enters appearance customization', async () => {
    const operation_uuid = '0190b7a0-2000-7000-8000-000000000010';
    const result = await postNui<Result<CharacterSelectionOutcome>>('characters.select', {
      operation_uuid,
    });
    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.data.operation_uuid).toBe(operation_uuid);
      expect(result.data.next_state).toBe('APPEARANCE_REQUIRED');
    }
  });

  it('provides 20 face features and updates one without mutating the source', async () => {
    const result = await postNui<Result<CharacterAppearanceConfiguration>>(
      'characters.appearanceConfiguration',
      {},
    );
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    const updated = updateFaceFeature(result.data.defaults, 3, 42);
    expect(updated.face_features).toHaveLength(20);
    expect(updated.face_features[3]).toBe(42);
    expect(result.data.defaults.face_features[3]).toBe(0);
  });
});
