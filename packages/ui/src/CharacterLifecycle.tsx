/** Character selection orchestrator for one server-authoritative session binding. */
import { useCallback, useEffect, useRef, useState } from 'react';
import {
  characterContractVersion,
  characterSelectionContractVersion,
  type CharacterList,
  type CharacterSelectionOutcome,
  type CharacterSelectionStatus,
  type CharacterSummary,
  type PlayerLifecyclePhase,
  type Result,
} from '@cnr/contracts';
import { AppearanceEditor } from './AppearanceEditor';
import { CharacterCreation } from './CharacterCreation';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();
type LifecycleView = 'loading' | 'selection' | 'creation' | 'appearance' | 'spawning';

export function activeCharacters(characters: readonly CharacterSummary[]): CharacterSummary[] {
  return characters.filter((character) => character.status === 'ACTIVE');
}

export function CharacterLifecycle({
  initialPhase,
}: {
  initialPhase?: PlayerLifecyclePhase | undefined;
}) {
  const operations = useRef(new Map<string, string>());
  const [characters, setCharacters] = useState<readonly CharacterSummary[]>([]);
  const [view, setView] = useState<LifecycleView>('loading');
  const [busyCharacter, setBusyCharacter] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);

  const load = useCallback(async () => {
    setView('loading');
    setMessage(null);
    try {
      const [listResult, statusResult] = await Promise.all([
        postNui<Result<CharacterList>>('characters.list', {
          request_id: newId(),
          contract_version: characterContractVersion,
        }),
        postNui<Result<CharacterSelectionStatus>>('characters.selectionStatus', {
          request_id: newId(),
          contract_version: characterSelectionContractVersion,
        }),
      ]);
      if (!listResult.ok || !statusResult.ok) throw new Error('load_failed');
      setCharacters(listResult.data.characters);
      if (statusResult.data.selected) {
        if (statusResult.data.next_state === 'APPEARANCE_REQUIRED') setView('appearance');
        else if (statusResult.data.next_state === 'SPAWN_PENDING') setView('spawning');
        else {
          setView('spawning');
        }
      } else {
        setView(
          initialPhase === 'CHARACTER_CREATION_REQUIRED' ||
            activeCharacters(listResult.data.characters).length === 0
            ? 'creation'
            : 'selection',
        );
      }
    } catch {
      setMessage('Character selection is currently unavailable. Please try again.');
      setView('selection');
    }
  }, [initialPhase]);

  useEffect(() => {
    void load();
  }, [load]);

  const select = async (character: CharacterSummary) => {
    if (busyCharacter) return;
    setBusyCharacter(character.character_uuid);
    setMessage(null);
    const operation = operations.current.get(character.character_uuid) ?? newId();
    operations.current.set(character.character_uuid, operation);
    try {
      const result = await postNui<Result<CharacterSelectionOutcome>>('characters.select', {
        character_uuid: character.character_uuid,
        request_id: newId(),
        operation_uuid: operation,
        contract_version: characterSelectionContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setView(result.data.next_state === 'APPEARANCE_REQUIRED' ? 'appearance' : 'spawning');
    } catch {
      setMessage('The character could not be selected. The same operation is safe to retry.');
      setBusyCharacter(null);
    }
  };

  if (view === 'loading') return <p role="status">Loading character lifecycle…</p>;
  if (view === 'appearance') return <AppearanceEditor onSpawning={() => setView('spawning')} />;
  if (view === 'spawning')
    return (
      <section className="lifecycle-state" role="status">
        <div className="spinner" aria-hidden="true" />
        <h1>Entering the City</h1>
        <p>The server is preparing your character and validating the controlled spawn.</p>
      </section>
    );
  if (view === 'creation')
    return (
      <CharacterCreation
        onActivated={(character) => {
          setCharacters((current) => [
            ...current.filter((item) => item.character_uuid !== character.character_uuid),
            character,
          ]);
          setView('selection');
        }}
      />
    );

  const selectable = activeCharacters(characters);
  const hasDraft = characters.some((character) => character.status === 'DRAFT');
  return (
    <section className="character-selection">
      <div className="shell-card__topline">
        <span>City Administration</span>
        <span className="status-pill">Secure Session</span>
      </div>
      <h1>Select Character</h1>
      <p>Your selection is bound to this active session before the server permits a spawn.</p>
      <div className="character-list">
        {selectable.map((character) => (
          <article key={character.character_uuid}>
            <div>
              <h2>
                {character.first_name} {character.last_name}
              </h2>
              <span>
                Slot {character.slot_number} · {character.background_code.replaceAll('_', ' ')}
              </span>
            </div>
            <button
              type="button"
              disabled={busyCharacter !== null}
              onClick={() => void select(character)}
            >
              {busyCharacter === character.character_uuid ? 'Selecting…' : 'Select'}
            </button>
          </article>
        ))}
      </div>
      {message && <p role="alert">{message}</p>}
      <div className="selection-actions">
        {hasDraft && (
          <button type="button" className="secondary-button" onClick={() => setView('creation')}>
            Continue Draft
          </button>
        )}
        {!hasDraft && characters.length < 3 && (
          <button type="button" className="secondary-button" onClick={() => setView('creation')}>
            Create Another Character
          </button>
        )}
        {message && (
          <button type="button" className="secondary-button" onClick={() => void load()}>
            Reload
          </button>
        )}
      </div>
    </section>
  );
}
