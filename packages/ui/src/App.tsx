/** Renders the minimal shared NUI shell and reacts only to validated versioned messages. */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { isNuiMessage } from '@cnr/contracts';
import { claimFocus, initialFocusState, releaseFocus } from './focus';
import { translate, type Locale } from './i18n';
import { isBrowserMock, postNui } from './nui';

export function App() {
  const mock = useMemo(isBrowserMock, []);
  const [locale, setLocale] = useState<Locale>('de');
  const [visible, setVisible] = useState(mock);
  const [focus, setFocus] = useState(initialFocusState);

  const close = useCallback(async () => {
    setFocus((current) => releaseFocus(current, current.owner ?? 'cnr_ui'));
    setVisible(false);
    await postNui<{ ok: boolean }>('close', {});
  }, []);

  useEffect(() => {
    const onEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape' && visible) void close();
    };
    window.addEventListener('keydown', onEscape);

    const listener = (event: MessageEvent<unknown>) => {
      const message = event.data;
      if (!isNuiMessage(message)) return;
      if (message.type === 'ui.shell.open') {
        setLocale(message.payload.locale === 'en' ? 'en' : 'de');
        setFocus((current) => claimFocus(current, message.payload.view));
        setVisible(true);
      }
      if (message.type === 'ui.shell.close') {
        setFocus(initialFocusState);
        setVisible(false);
      }
    };
    window.addEventListener('message', listener);
    return () => {
      window.removeEventListener('message', listener);
      window.removeEventListener('keydown', onEscape);
    };
  }, [close, visible]);

  if (!visible) return null;
  return (
    <main className="nui-stage" aria-label={translate(locale, 'shell.title')}>
      <section className="shell-card">
        <div className="shell-card__topline">
          <span>{translate(locale, 'shell.eyebrow')}</span>
          <span className="status-pill">{translate(locale, 'status.ready')}</span>
        </div>
        <h1>{translate(locale, 'shell.title')}</h1>
        <p>{translate(locale, 'shell.description')}</p>
        <div className="shell-card__footer">
          <span className="runtime-badge">
            {translate(locale, mock ? 'shell.browserMock' : 'shell.fivem')}
          </span>
          <button type="button" onClick={() => void close()}>
            {translate(locale, 'shell.close')}
          </button>
        </div>
        <output className="sr-only">Focus owner: {focus.owner ?? 'none'}</output>
      </section>
    </main>
  );
}
