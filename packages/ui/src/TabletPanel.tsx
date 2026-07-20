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
  enabled: boolean;
}

export const tabletApps: readonly TabletAppTile[] = [
  {
    id: 'banking',
    title: 'Banking',
    description: 'Accounts and recent activity',
    symbol: '$',
    enabled: true,
  },
  {
    id: 'documents',
    title: 'Documents',
    description: 'Digital identity and permits',
    symbol: 'ID',
    enabled: false,
  },
  {
    id: 'city-services',
    title: 'City Services',
    description: 'Requests and public services',
    symbol: 'SA',
    enabled: false,
  },
  {
    id: 'settings',
    title: 'Settings',
    description: 'Device preferences',
    symbol: '⚙',
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
            <div className="tablet-app-surface">
              <BankingPanel embedded onClose={() => setActiveApp('home')} />
            </div>
          ) : (
            <div className="tablet-home">
              <div className="tablet-home__heading">
                <div>
                  <span>San Andreas Civic Network</span>
                  <h1>Good day, Citizen.</h1>
                  <p>Select an authorized application.</p>
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
                    className="tablet-app-tile"
                    key={app.id}
                    disabled={!app.enabled}
                    onClick={() => app.id === 'banking' && setActiveApp('banking')}
                  >
                    <span className="tablet-app-tile__icon" aria-hidden="true">
                      {app.symbol}
                    </span>
                    <strong>{app.title}</strong>
                    <small>{app.description}</small>
                    <span className="tablet-app-tile__state">
                      {app.enabled ? 'Open App' : 'Coming Soon'}
                    </span>
                  </button>
                ))}
              </div>
            </div>
          )}
        </div>
        <div className="tablet-homebar" aria-hidden="true" />
      </section>
    </main>
  );
}
