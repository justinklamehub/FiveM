/** Curated freemode appearance editor; persistence remains server-authoritative. */
import { useCallback, useEffect, useRef, useState } from 'react';
import {
  characterAppearanceContractVersion,
  type CharacterAppearance,
  type CharacterAppearanceConfiguration,
  type CharacterAppearanceOutcome,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();
const featureLabels = [
  'Nose width',
  'Nose height',
  'Nose length',
  'Nose bridge',
  'Nose tip',
  'Nose shift',
  'Brow height',
  'Brow width',
  'Cheekbone height',
  'Cheekbone width',
  'Cheek width',
  'Eye opening',
  'Lip thickness',
  'Jaw width',
  'Jaw height',
  'Chin length',
  'Chin position',
  'Chin width',
  'Chin shape',
  'Neck width',
] as const;

export function updateFaceFeature(
  appearance: CharacterAppearance,
  index: number,
  value: number,
): CharacterAppearance {
  const faceFeatures = [...appearance.face_features];
  faceFeatures[index] = value;
  return { ...appearance, face_features: faceFeatures };
}

export function stepAppearanceValue(
  value: number,
  minimum: number,
  maximum: number,
  direction: -1 | 1,
  step = 1,
): number {
  return Math.min(maximum, Math.max(minimum, value + direction * step));
}

function AppearanceRange({
  id,
  label,
  value,
  minimum,
  maximum,
  step = 1,
  onChange,
}: {
  id: string;
  label: string;
  value: number;
  minimum: number;
  maximum: number;
  step?: number;
  onChange: (value: number) => void;
}) {
  const changeBy = (direction: -1 | 1) =>
    onChange(stepAppearanceValue(value, minimum, maximum, direction, step));

  return (
    <div className="appearance-field">
      <div className="appearance-field__label">
        <label htmlFor={id}>{label}</label>
        <output htmlFor={id}>{value}</output>
      </div>
      <div className="appearance-stepper">
        <button
          type="button"
          aria-label={`Decrease ${label}`}
          disabled={value <= minimum}
          onClick={() => changeBy(-1)}
        >
          −
        </button>
        <input
          id={id}
          type="range"
          min={minimum}
          max={maximum}
          step={step}
          value={value}
          onChange={(event) => onChange(Number(event.target.value))}
        />
        <button
          type="button"
          aria-label={`Increase ${label}`}
          disabled={value >= maximum}
          onClick={() => changeBy(1)}
        >
          +
        </button>
      </div>
    </div>
  );
}

export function AppearanceEditor({ onSpawning }: { onSpawning: () => void }) {
  const operationUuid = useRef(newId());
  const [configuration, setConfiguration] = useState<CharacterAppearanceConfiguration | null>(null);
  const [appearance, setAppearance] = useState<CharacterAppearance | null>(null);
  const [busy, setBusy] = useState(true);
  const [message, setMessage] = useState<string | null>(null);

  const load = useCallback(async () => {
    setBusy(true);
    setMessage(null);
    try {
      const result = await postNui<Result<CharacterAppearanceConfiguration>>(
        'characters.appearanceConfiguration',
        { request_id: newId(), contract_version: characterAppearanceContractVersion },
      );
      if (!result.ok) throw new Error(result.error.code);
      setConfiguration(result.data);
      setAppearance(result.data.defaults);
      await postNui<{ ok: boolean }>('characters.appearanceBegin', result.data.defaults);
    } catch {
      setMessage('The appearance editor is currently unavailable. Please try again.');
    } finally {
      setBusy(false);
    }
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  useEffect(() => {
    if (!appearance) return;
    const timeout = window.setTimeout(() => {
      void postNui<{ ok: boolean }>('characters.appearancePreview', appearance);
    }, 100);
    return () => window.clearTimeout(timeout);
  }, [appearance]);

  const save = async () => {
    if (!appearance || busy) return;
    setBusy(true);
    setMessage(null);
    try {
      const result = await postNui<Result<CharacterAppearanceOutcome>>(
        'characters.appearanceSave',
        {
          ...appearance,
          request_id: newId(),
          operation_uuid: operationUuid.current,
          contract_version: characterAppearanceContractVersion,
        },
      );
      if (!result.ok) throw new Error(result.error.code);
      onSpawning();
    } catch {
      setMessage('Your appearance could not be saved. Your operation is safe to retry.');
      setBusy(false);
    }
  };

  if (!configuration || !appearance) {
    return (
      <section className="appearance-editor">
        <p role="status">{message ?? 'Loading appearance editor…'}</p>
        {message && (
          <button type="button" onClick={() => void load()}>
            Retry
          </button>
        )}
      </section>
    );
  }

  const numberField = (
    label: string,
    key: keyof Pick<
      CharacterAppearance,
      | 'shape_first'
      | 'shape_second'
      | 'shape_mix'
      | 'skin_mix'
      | 'hair_style'
      | 'hair_texture'
      | 'hair_color'
      | 'hair_highlight'
      | 'eye_color'
    >,
    minimum: number,
    maximum: number,
    step = 1,
  ) => {
    const id = `appearance-${key}`;
    return (
      <AppearanceRange
        id={id}
        label={label}
        value={appearance[key]}
        minimum={minimum}
        maximum={maximum}
        step={step}
        onChange={(value) =>
          setAppearance((current) => (current ? { ...current, [key]: value } : current))
        }
      />
    );
  };

  return (
    <section className="appearance-editor">
      <div className="shell-card__topline">
        <span>Identity Studio</span>
        <span className="status-pill">Appearance</span>
      </div>
      <h1>Customize Appearance</h1>
      <p>Build your persistent character appearance before entering the city.</p>
      <div className="appearance-scroll">
        <fieldset>
          <legend>Base model</legend>
          <label>
            Body type
            <select
              value={appearance.model}
              onChange={(event) =>
                setAppearance({
                  ...appearance,
                  model: event.target.value as CharacterAppearance['model'],
                })
              }
            >
              <option value="mp_m_freemode_01">Masculine</option>
              <option value="mp_f_freemode_01">Feminine</option>
            </select>
          </label>
          {numberField(
            'First parent',
            'shape_first',
            configuration.parent_minimum,
            configuration.parent_maximum,
          )}
          {numberField(
            'Second parent',
            'shape_second',
            configuration.parent_minimum,
            configuration.parent_maximum,
          )}
          {numberField('Face blend', 'shape_mix', 0, 100, 5)}
          {numberField('Skin blend', 'skin_mix', 0, 100, 5)}
        </fieldset>
        <fieldset>
          <legend>Hair and eyes</legend>
          {numberField('Hair style', 'hair_style', 0, configuration.hair_style_maximum)}
          {numberField('Hair texture', 'hair_texture', 0, configuration.hair_texture_maximum)}
          {numberField('Hair color', 'hair_color', 0, configuration.hair_color_maximum)}
          {numberField('Hair highlight', 'hair_highlight', 0, configuration.hair_color_maximum)}
          {numberField('Eye color', 'eye_color', 0, configuration.eye_color_maximum)}
        </fieldset>
        <fieldset className="face-grid">
          <legend>Face shape</legend>
          {featureLabels.map((label, index) => (
            <AppearanceRange
              key={label}
              id={`appearance-face-${String(index)}`}
              label={label}
              value={appearance.face_features[index] ?? 0}
              minimum={configuration.face_feature_minimum}
              maximum={configuration.face_feature_maximum}
              step={5}
              onChange={(value) =>
                setAppearance((current) =>
                  current ? updateFaceFeature(current, index, value) : current,
                )
              }
            />
          ))}
        </fieldset>
      </div>
      {message && <p role="alert">{message}</p>}
      <div className="shell-card__footer">
        <span>Starter outfit included</span>
        <button type="button" disabled={busy} onClick={() => void save()}>
          {busy ? 'Saving…' : 'Save and Enter City'}
        </button>
      </div>
    </section>
  );
}
