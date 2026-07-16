/** English-only character draft, preview, and activation workflow. */
import { useCallback, useEffect, useRef, useState } from 'react';
import {
  characterContractVersion,
  type CharacterConfiguration,
  type CharacterList,
  type CharacterMutationOutcome,
  type CharacterSummary,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();

export const findRecoverableDraft = (
  characters: readonly CharacterSummary[],
): CharacterSummary | null => characters.find((character) => character.status === 'DRAFT') ?? null;

export function CharacterCreation() {
  const createOperation = useRef(newId());
  const activateOperation = useRef(newId());
  const [configuration, setConfiguration] = useState<CharacterConfiguration | null>(null);
  const [characters, setCharacters] = useState<readonly CharacterSummary[]>([]);
  const [draft, setDraft] = useState<CharacterSummary | null>(null);
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [birthDate, setBirthDate] = useState('');
  const [background, setBackground] = useState('');
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  const load = useCallback(async () => {
    setBusy(true);
    try {
      const request_id = newId();
      const [configurationResult, listResult] = await Promise.all([
        postNui<Result<CharacterConfiguration>>('characters.configuration', {
          request_id,
          contract_version: characterContractVersion,
        }),
        postNui<Result<CharacterList>>('characters.list', {
          request_id: newId(),
          contract_version: characterContractVersion,
        }),
      ]);
      if (!configurationResult.ok || !listResult.ok) throw new Error('load_failed');
      setConfiguration(configurationResult.data);
      setCharacters(listResult.data.characters);
      setDraft(findRecoverableDraft(listResult.data.characters));
      setBackground(configurationResult.data.backgrounds[0]?.code ?? '');
    } catch {
      setMessage('Character creation is currently unavailable. Please try again.');
    } finally {
      setBusy(false);
    }
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  const createDraft = async () => {
    if (busy || !firstName || !lastName || !birthDate || !background) return;
    setBusy(true);
    setMessage(null);
    try {
      const result = await postNui<Result<CharacterMutationOutcome>>('characters.createDraft', {
        first_name: firstName,
        last_name: lastName,
        date_of_birth: birthDate,
        background_code: background,
        request_id: newId(),
        operation_uuid: createOperation.current,
        contract_version: characterContractVersion,
      });
      if (!result.ok || !result.data.character) throw new Error('draft_failed');
      const created = result.data.character;
      setDraft(created);
      setCharacters((current) => [...current, created]);
    } catch {
      setMessage(
        'The character draft could not be created. Check the entered identity and try again.',
      );
    } finally {
      setBusy(false);
    }
  };

  const activate = async () => {
    if (busy || !draft) return;
    setBusy(true);
    setMessage(null);
    try {
      const result = await postNui<Result<CharacterMutationOutcome>>('characters.activate', {
        character_uuid: draft.character_uuid,
        request_id: newId(),
        operation_uuid: activateOperation.current,
        contract_version: characterContractVersion,
      });
      if (!result.ok) throw new Error('activation_failed');
      setMessage(
        'Character activated. Selection and spawning will be added in the next development slice.',
      );
      if (result.data.character) {
        const activated = result.data.character;
        setDraft(activated);
        setCharacters((current) =>
          current.map((character) =>
            character.character_uuid === activated.character_uuid ? activated : character,
          ),
        );
      }
    } catch {
      setMessage('The character could not be activated. Please try again.');
    } finally {
      setBusy(false);
    }
  };

  if (!configuration) return <p role="status">Loading character configuration…</p>;
  return (
    <section className="character-creation">
      <div className="shell-card__topline">
        <span>City Administration</span>
        <span className="status-pill">Character Lifecycle</span>
      </div>
      <h1>Create Character</h1>
      <p>Create a roleplay identity. The server assigns the next available character slot.</p>
      <div className="slot-summary">
        {characters.length} of {configuration.slot_limit} slots used
      </div>
      {!draft ? (
        <div className="identity-grid">
          <label>
            First name
            <input
              value={firstName}
              maxLength={48}
              onChange={(event) => setFirstName(event.target.value)}
            />
          </label>
          <label>
            Last name
            <input
              value={lastName}
              maxLength={48}
              onChange={(event) => setLastName(event.target.value)}
            />
          </label>
          <label>
            Date of birth
            <input
              type="date"
              value={birthDate}
              onChange={(event) => setBirthDate(event.target.value)}
            />
          </label>
          <label>
            Background
            <select value={background} onChange={(event) => setBackground(event.target.value)}>
              {configuration.backgrounds.map((item) => (
                <option key={item.code} value={item.code}>
                  {item.label}
                </option>
              ))}
            </select>
          </label>
          <button
            type="button"
            disabled={busy || characters.length >= configuration.slot_limit}
            onClick={() => void createDraft()}
          >
            Create Draft
          </button>
        </div>
      ) : (
        <div className="character-preview">
          <h2>Confirm Character</h2>
          <dl>
            <dt>Name</dt>
            <dd>
              {draft.first_name} {draft.last_name}
            </dd>
            <dt>Date of birth</dt>
            <dd>{draft.date_of_birth}</dd>
            <dt>Background</dt>
            <dd>{draft.background_code}</dd>
            <dt>Slot</dt>
            <dd>{draft.slot_number}</dd>
            <dt>Status</dt>
            <dd>{draft.status}</dd>
          </dl>
          <button
            type="button"
            disabled={busy || draft.status !== 'DRAFT'}
            onClick={() => void activate()}
          >
            Confirm and Activate
          </button>
        </div>
      )}
      {message && <p role="alert">{message}</p>}
    </section>
  );
}
