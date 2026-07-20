/** Reusable in-game tablet shell. Banking is the first server-backed application. */
import { useState } from 'react';
import { BankingPanel } from './BankingPanel';
import { postNui } from './nui';

export type TabletApp = 'home' | 'banking';

interface TabletAppTile {
  id: string;
  title: string;
  description: string;
  symbol: string;
  tone: 'gold' | 'blue' | 'teal' | 'graphite';
  enabled: boolean;
}

export const tabletApps: readonly TabletAppTile[] = [
  {
    id: 'banking',
    title: 'Banking',
    description: 'Accounts and recent activity',
    symbol: '$',
    tone: 'gold',
    enabled: true,
  },
  {
    id: 'documents',
    title: 'Documents',
    description: 'Digital identity and permits',
    symbol: 'ID',
    tone: 'blue',
    enabled: false,
  },
  {
    id: 'city-services',
    title: 'City Services',
    description: 'Requests and public services',
    symbol: 'SA',
    tone: 'teal',
    enabled: false,
  },
  {
    id: 'settings',
    title: 'Settings',
    description: 'Device preferences',
    symbol: 'SET',
    tone: 'graphite',
    enabled: false,
  },
];

export function TabletPanel({
  initialApp = 'home',
  onClose,
}: {
  initialApp?: TabletApp;
  onClose: () => void;
}) {
  const [activeApp, setActiveApp] = useState<TabletApp>(initialApp);

  const close = () => {
    void postNui<{ ok: boolean }>('close', {}).catch(() => undefined);
    onClose();
  };

  return (
    <main className="nui-stage tablet-stage" aria-label="City Tablet">
      <section className="tablet-device">
        <div className="tablet-camera" aria-hidden="true" />
        <div className="tablet-screen">
          <header className="tablet-statusbar">
            <div>
              <span className="tablet-mark">CNR</span>
              <span>City Tablet</span>
            </div>
            <div>
              <span>Secure</span>
              <button type="button" onClick={close} aria-label="Close City Tablet">
                Close
              </button>
            </div>
          </header>

          {activeApp === 'banking' ? (
            <div className="tablet-app-surface" data-app="banking">
              <BankingPanel embedded onClose={() => setActiveApp('home')} />
            </div>
          ) : (
            <div className="tablet-home">
              <div className="tablet-home__heading">
                <div>
                  <span>San Andreas Civic Network</span>
                  <h1>City Tablet</h1>
                  <p>Authorized applications for your active character.</p>
                </div>
                <div className="tablet-home__security">
                  <strong>Protected Session</strong>
                  <span>Character-bound device</span>
                </div>
              </div>
              <div className="tablet-app-grid" aria-label="Tablet applications">
                {tabletApps.map((app) => (
                  <button
                    type="button"
                    className="tablet-app-icon"
                    key={app.id}
                    disabled={!app.enabled}
                    onClick={() => app.id === 'banking' && setActiveApp('banking')}
                    aria-label={app.enabled ? `Open ${app.title}` : `${app.title} — coming soon`}
                    title={app.description}
                  >
                    <span
                      className={`tablet-app-icon__glyph tablet-app-icon__glyph--${app.tone}`}
                      aria-hidden="true"
                    >
                      {app.symbol}
                      {!app.enabled && <span className="tablet-app-icon__lock">LOCKED</span>}
                    </span>
                    <strong>{app.title}</strong>
                    {!app.enabled && <small>Coming Soon</small>}
                  </button>
                ))}
              </div>
              <div className="tablet-dock" aria-label="Tablet dock">
                <button
                  type="button"
                  onClick={() => setActiveApp('banking')}
                  aria-label="Open Banking"
                >
                  <span
                    className="tablet-app-icon__glyph tablet-app-icon__glyph--gold"
                    aria-hidden="true"
                  >
                    $
                  </span>
                  <strong>Banking</strong>
                </button>
                <div className="tablet-dock__status">
                  <span className="tablet-dock__status-dot" aria-hidden="true" />
                  Secure connection
                </div>
              </div>
            </div>
          )}
        </div>
        <div className="tablet-homebar" aria-hidden="true" />
      </section>
    </main>
  );
}
