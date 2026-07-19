/** Lightweight FiveM loadscreen that hands off to the interactive lifecycle NUI. */
import { useEffect, useMemo, useState } from 'react';
import {
  isNuiMessage,
  playerLifecycleContractVersion,
  type PlayerLifecycleSnapshot,
} from '@cnr/contracts';
import {
  browserLifecycleSnapshot,
  currentBrowserSearch,
  lifecycleCopy,
  lifecycleProgress,
} from './lifecycle';

const initialSnapshot: PlayerLifecycleSnapshot = {
  contract_version: playerLifecycleContractVersion,
  phase: 'CONNECTING',
  retryable: false,
  correlation_id: 'loadscreen-bootstrap',
};

export function initialLoadscreenSnapshot(search = ''): PlayerLifecycleSnapshot {
  return new URLSearchParams(search).has('phase')
    ? browserLifecycleSnapshot(search)
    : initialSnapshot;
}

export function combinedLoadProgress(loadFraction: number, snapshot: PlayerLifecycleSnapshot) {
  const resourceProgress = Math.max(0, Math.min(1, loadFraction)) * 75;
  return Math.round(Math.max(resourceProgress, lifecycleProgress[snapshot.phase]));
}

export function Loadscreen() {
  const [snapshot, setSnapshot] = useState(() => initialLoadscreenSnapshot(currentBrowserSearch()));
  const [loadFraction, setLoadFraction] = useState(0);
  const copy = lifecycleCopy[snapshot.phase];
  const progress = useMemo(
    () => combinedLoadProgress(loadFraction, snapshot),
    [loadFraction, snapshot],
  );

  useEffect(() => {
    const listener = (event: MessageEvent<unknown>) => {
      if (isNuiMessage(event.data) && event.data.type === 'ui.lifecycle.phase') {
        setSnapshot(event.data.payload);
        return;
      }
      const message = event.data as { eventName?: unknown; loadFraction?: unknown } | null;
      if (message?.eventName === 'loadProgress' && typeof message.loadFraction === 'number') {
        setLoadFraction(message.loadFraction);
      }
    };
    window.addEventListener('message', listener);
    return () => window.removeEventListener('message', listener);
  }, []);

  return (
    <main className="loadscreen" aria-label="Cops'N'Robbers connection progress">
      <div className="loadscreen__glow" aria-hidden="true" />
      <section className="loadscreen__content">
        <div className="brand-mark" aria-hidden="true">
          CNR
        </div>
        <p className="loadscreen__brand">Cops'N'Robbers RP</p>
        <div className="loadscreen__copy" aria-live="polite">
          <span>{copy.eyebrow}</span>
          <h1>{copy.title}</h1>
          <p>{copy.description}</p>
        </div>
        <div className="loadscreen__progress">
          <div className="loadscreen__progress-meta">
            <span>{snapshot.phase === 'RECOVERABLE_ERROR' ? 'Attention required' : 'Loading'}</span>
            <output>{progress}%</output>
          </div>
          <progress value={progress} max={100} aria-label="Connection progress" />
        </div>
        {snapshot.phase === 'RECOVERABLE_ERROR' && (
          <p className="loadscreen__reference">
            Reconnect if the issue continues. Reference: {snapshot.correlation_id}
          </p>
        )}
      </section>
      <p className="loadscreen__security">Server-authoritative player lifecycle</p>
    </main>
  );
}
