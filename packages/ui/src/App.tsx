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

const newId = () => crypto.randomUUID();

export function App() {
  const mock = useMemo(isBrowserMock, []);
  const operationUuid = useRef(newId());
  const [locale, setLocale] = useState<Locale>('de');
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
      setMessage(translate(selectedLocale, 'registration.error'));
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
    } catch {
      setMessage(translate(locale, 'registration.error'));
    } finally {
      setSubmitting(false);
    }
  }, [accepted, locale, ruleset, submitting]);

  useEffect(() => {
    if (mock) void loadRuleset('de');
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
        const nextLocale = event.data.payload.locale === 'en' ? 'en' : 'de';
        setLocale(nextLocale);
        setFocus((current) => claimFocus(current, 'registration'));
        setVisible(true);
        void loadRuleset(nextLocale);
      }
    };
    window.addEventListener('message', listener);
    window.addEventListener('keydown', onEscape);
    return () => {
      window.removeEventListener('message', listener);
      window.removeEventListener('keydown', onEscape);
    };
  }, [close, loadRuleset, mock, visible]);

  if (!visible) return null;
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
          <button
            type="button"
            disabled={!accepted || !ruleset || submitting}
            onClick={() => void submit()}
          >
            {translate(locale, submitting ? 'registration.submitting' : 'registration.submit')}
          </button>
        </div>
        <button className="close-link" type="button" onClick={() => void close()}>
          {translate(locale, 'shell.close')}
        </button>
        <output className="sr-only">Focus owner: {focus.owner ?? 'none'}</output>
      </section>
    </main>
  );
}
