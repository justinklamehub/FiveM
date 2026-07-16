/** Renders the shared shell and server-authoritative registration view. */
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  isNuiMessage,
  registrationContractVersion,
  type CurrentRuleset,
  type RegistrationOutcome,
  type Result,
} from '@cnr/contracts';
import { claimFocus, initialFocusState, releaseFocus } from './focus';
import { translate, type Locale } from './i18n';
import { isBrowserMock, postNui } from './nui';
import { CharacterCreation } from './CharacterCreation';

const newId = () => crypto.randomUUID();

export function App() {
  const mock = useMemo(isBrowserMock, []);
  const operationUuid = useRef(newId());
  const browserReadySent = useRef(false);
  const [locale, setLocale] = useState<Locale>('en');
  const [view, setView] = useState<'registration' | 'characterCreation'>('registration');
  const [visible, setVisible] = useState(mock);
  const [focus, setFocus] = useState(initialFocusState);
  const [ruleset, setRuleset] = useState<CurrentRuleset | null>(null);
  const [accepted, setAccepted] = useState(false);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  const loadRuleset = useCallback(async (selectedLocale: Locale) => {
    setLoading(true);
    setMessage(null);
    try {
      const result = await postNui<Result<CurrentRuleset>>('registrationRuleset', {
        request_id: newId(),
        locale: selectedLocale,
        contract_version: registrationContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setRuleset(result.data);
    } catch {
      setMessage(translate(selectedLocale, 'registration.loadError'));
    } finally {
      setLoading(false);
    }
  }, []);

  const close = useCallback(async () => {
    setFocus((current) => releaseFocus(current, current.owner ?? 'cnr_ui'));
    setVisible(false);
    await postNui<{ ok: boolean }>('close', {});
  }, []);

  const submit = useCallback(async () => {
    if (!ruleset || !accepted || submitting) return;
    setSubmitting(true);
    setMessage(null);
    try {
      const result = await postNui<Result<RegistrationOutcome>>('registrationSubmit', {
        ruleset_uuid: ruleset.ruleset_uuid,
        ruleset_version: ruleset.version,
        acceptance: true,
        locale,
        request_id: newId(),
        operation_uuid: operationUuid.current,
        contract_version: registrationContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setMessage(translate(locale, 'registration.success'));
      setView('characterCreation');
    } catch {
      setMessage(translate(locale, 'registration.error'));
    } finally {
      setSubmitting(false);
    }
  }, [accepted, locale, ruleset, submitting]);

  useEffect(() => {
    if (mock) void loadRuleset('en');
    const onEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape' && visible) void close();
    };
    const listener = (event: MessageEvent<unknown>) => {
      if (!isNuiMessage(event.data)) return;
      if (event.data.type === 'ui.shell.close') {
        setFocus(initialFocusState);
        setVisible(false);
      }
      if (event.data.type === 'ui.shell.open' || event.data.type === 'ui.registration.open') {
        const requestedView =
          event.data.type === 'ui.shell.open' && event.data.payload.view === 'characterCreation'
            ? 'characterCreation'
            : 'registration';
        setLocale('en');
        setView(requestedView);
        setFocus((current) => claimFocus(current, requestedView));
        setVisible(true);
        if (requestedView === 'registration') void loadRuleset('en');
      }
      if (event.data.type === 'ui.character_creation.open') {
        setLocale('en');
        setView('characterCreation');
        setVisible(true);
      }
    };
    window.addEventListener('message', listener);
    window.addEventListener('keydown', onEscape);
    if (!mock && !browserReadySent.current) {
      browserReadySent.current = true;
      void postNui<{ ok: boolean }>('uiReady', {}).catch(() => {
        browserReadySent.current = false;
      });
    }
    return () => {
      window.removeEventListener('message', listener);
      window.removeEventListener('keydown', onEscape);
    };
  }, [close, loadRuleset, mock, visible]);

  if (!visible) return null;
  if (view === 'characterCreation')
    return (
      <main className="nui-stage" aria-label="Create Character">
        <section className="shell-card">
          <CharacterCreation />
          <output className="sr-only">Focus owner: {focus.owner ?? 'none'}</output>
        </section>
      </main>
    );
  return (
    <main className="nui-stage" aria-label={translate(locale, 'registration.title')}>
      <section className="shell-card registration-card">
        <div className="shell-card__topline">
          <span>{translate(locale, 'registration.eyebrow')}</span>
          <span className="status-pill">{translate(locale, 'status.ready')}</span>
        </div>
        <h1>{translate(locale, 'registration.title')}</h1>
        <p>{translate(locale, 'registration.description')}</p>
        {loading ? (
          <p role="status">{translate(locale, 'registration.loading')}</p>
        ) : (
          ruleset && (
            <>
              <div className="ruleset-meta">
                {translate(locale, 'registration.version')}: {ruleset.version}
              </div>
              <article className="ruleset-copy">{ruleset.content}</article>
              <label className="acceptance">
                <input
                  type="checkbox"
                  checked={accepted}
                  onChange={(event) => setAccepted(event.target.checked)}
                />
                <span>{translate(locale, 'registration.accept')}</span>
              </label>
            </>
          )
        )}
        {message && <p role="alert">{message}</p>}
        <div className="shell-card__footer">
          <span className="runtime-badge">
            {translate(locale, mock ? 'shell.browserMock' : 'shell.fivem')}
          </span>
          {!loading && !ruleset ? (
            <button type="button" onClick={() => void loadRuleset(locale)}>
              {translate(locale, 'registration.retry')}
            </button>
          ) : (
            <button
              type="button"
              disabled={!accepted || !ruleset || submitting}
              onClick={() => void submit()}
            >
              {translate(locale, submitting ? 'registration.submitting' : 'registration.submit')}
            </button>
          )}
        </div>
        <button className="close-link" type="button" onClick={() => void close()}>
          {translate(locale, 'shell.close')}
        </button>
        <output className="sr-only">Focus owner: {focus.owner ?? 'none'}</output>
      </section>
    </main>
  );
}
