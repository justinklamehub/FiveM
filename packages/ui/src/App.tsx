/** Renders the interactive server-authoritative Wave 1 player lifecycle. */
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  inventoryContractVersion,
  isNuiMessage,
  playerLifecycleContractVersion,
  registrationContractVersion,
  type CurrentRuleset,
  type InventoryOpenView,
  type PlayerLifecycleSnapshot,
  type RegistrationOutcome,
  type Result,
  type StateIdentificationPresentation,
} from '@cnr/contracts';
import { CharacterLifecycle } from './CharacterLifecycle';
import { claimFocus, initialFocusState } from './focus';
import { translate } from './i18n';
import { InventoryPanel } from './InventoryPanel';
import { browserLifecycleSnapshot, currentBrowserSearch, lifecycleViewForPhase } from './lifecycle';
import { isBrowserMock, postNui } from './nui';
import { StateIdentificationCard } from './StateIdentificationCard';

const newId = () => crypto.randomUUID();

export function App() {
  const mock = useMemo(isBrowserMock, []);
  const browserInventory = useMemo(() => {
    const view = new URLSearchParams(currentBrowserSearch()).get('view');
    return mock && (view === 'inventory' || view === 'storage');
  }, [mock]);
  const browserInventoryView = useMemo<InventoryOpenView>(
    () =>
      new URLSearchParams(currentBrowserSearch()).get('view') === 'storage'
        ? 'storage'
        : 'personal',
    [],
  );
  const browserIdentification = useMemo<StateIdentificationPresentation | null>(() => {
    if (!mock || new URLSearchParams(currentBrowserSearch()).get('view') !== 'document')
      return null;
    return {
      contract_version: inventoryContractVersion,
      mode: 'PRESENTED',
      document: {
        document_type: 'STATE_ID',
        document_number: 'SA-000000000001',
        first_name: 'Alex',
        last_name: 'Morgan',
        date_of_birth: '1995-05-20',
        issued_at: '2026-07-16',
      },
    };
  }, [mock]);
  const operationUuid = useRef(newId());
  const browserReadySent = useRef(false);
  const [snapshot, setSnapshot] = useState<PlayerLifecycleSnapshot | null>(() =>
    mock ? browserLifecycleSnapshot(currentBrowserSearch()) : null,
  );
  const [visible, setVisible] = useState(mock);
  const [focus, setFocus] = useState(initialFocusState);
  const [ruleset, setRuleset] = useState<CurrentRuleset | null>(null);
  const [accepted, setAccepted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [inventoryOpen, setInventoryOpen] = useState(browserInventory);
  const [inventoryView, setInventoryView] = useState<InventoryOpenView>(browserInventoryView);
  const [identification, setIdentification] = useState<StateIdentificationPresentation | null>(
    browserIdentification,
  );

  const loadRuleset = useCallback(async () => {
    setLoading(true);
    setMessage(null);
    try {
      const result = await postNui<Result<CurrentRuleset>>('registrationRuleset', {
        request_id: newId(),
        locale: 'en',
        contract_version: registrationContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setRuleset(result.data);
    } catch {
      setRuleset(null);
      setMessage(translate('en', 'registration.loadError'));
    } finally {
      setLoading(false);
    }
  }, []);

  const applySnapshot = useCallback(
    (next: PlayerLifecycleSnapshot) => {
      setSnapshot(next);
      setRefreshing(false);
      setMessage(null);
      if (next.phase === 'READY') {
        setVisible(false);
        setFocus(initialFocusState);
        return;
      }
      setVisible(true);
      setFocus((current) => claimFocus(current, 'playerLifecycle'));
      if (next.phase === 'REGISTRATION_REQUIRED') void loadRuleset();
    },
    [loadRuleset],
  );

  const refreshLifecycle = useCallback(async () => {
    if (refreshing) return;
    setRefreshing(true);
    setMessage(null);
    try {
      const acknowledgement = await postNui<{ ok: boolean }>('lifecycleRefresh', {
        contract_version: playerLifecycleContractVersion,
      });
      if (!acknowledgement.ok) throw new Error('refresh_rejected');
      if (mock) applySnapshot(browserLifecycleSnapshot(currentBrowserSearch()));
    } catch {
      setRefreshing(false);
      setMessage('The lifecycle status could not be refreshed. Please try again.');
    }
  }, [applySnapshot, mock, refreshing]);

  const submit = useCallback(async () => {
    if (!ruleset || !accepted || submitting) return;
    setSubmitting(true);
    setMessage(null);
    try {
      const result = await postNui<Result<RegistrationOutcome>>('registrationSubmit', {
        ruleset_uuid: ruleset.ruleset_uuid,
        ruleset_version: ruleset.version,
        acceptance: true,
        locale: 'en',
        request_id: newId(),
        operation_uuid: operationUuid.current,
        contract_version: registrationContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setRefreshing(true);
      if (mock) {
        applySnapshot({
          contract_version: playerLifecycleContractVersion,
          phase: 'CHARACTER_SELECTION_REQUIRED',
          retryable: false,
          correlation_id: 'browser-registration-complete',
        });
      } else {
        const acknowledgement = await postNui<{ ok: boolean }>('lifecycleRefresh', {
          contract_version: playerLifecycleContractVersion,
        });
        if (!acknowledgement.ok) throw new Error('refresh_rejected');
      }
    } catch {
      setRefreshing(false);
      setMessage(translate('en', 'registration.error'));
    } finally {
      setSubmitting(false);
    }
  }, [accepted, applySnapshot, mock, ruleset, submitting]);

  useEffect(() => {
    if (
      mock &&
      browserLifecycleSnapshot(currentBrowserSearch()).phase === 'REGISTRATION_REQUIRED'
    ) {
      void loadRuleset();
    }
  }, [loadRuleset, mock]);

  useEffect(() => {
    const listener = (event: MessageEvent<unknown>) => {
      if (!isNuiMessage(event.data)) return;
      if (event.data.type === 'ui.shell.close') {
        setFocus(initialFocusState);
        setVisible(false);
      } else if (event.data.type === 'ui.lifecycle.open') {
        setInventoryOpen(false);
        applySnapshot(event.data.payload);
      } else if (event.data.type === 'ui.inventory.open') {
        setInventoryView(event.data.payload.view);
        setInventoryOpen(true);
        setVisible(true);
        setFocus((current) => claimFocus(current, 'inventory'));
      } else if (event.data.type === 'ui.inventory.document') {
        setIdentification(event.data.payload);
      } else if (event.data.type === 'ui.character.spawn_failed') {
        applySnapshot({
          contract_version: playerLifecycleContractVersion,
          phase: 'RECOVERABLE_ERROR',
          retryable: true,
          correlation_id: event.data.payload.correlation_id,
        });
      }
    };
    window.addEventListener('message', listener);
    if (!mock && !browserReadySent.current) {
      browserReadySent.current = true;
      void postNui<{ ok: boolean }>('uiReady', {}).catch(() => {
        browserReadySent.current = false;
      });
    }
    return () => window.removeEventListener('message', listener);
  }, [applySnapshot, mock]);

  const closeIdentification = () => {
    setIdentification(null);
    void postNui<{ ok: boolean }>('inventory.documentClose', {}).catch(() => undefined);
  };

  if (inventoryOpen) {
    return (
      <>
        <InventoryPanel
          view={inventoryView}
          onClose={() => {
            setInventoryOpen(false);
            setVisible(false);
            setFocus(initialFocusState);
          }}
        />
        {identification && (
          <StateIdentificationCard presentation={identification} onClose={closeIdentification} />
        )}
      </>
    );
  }
  if (identification)
    return <StateIdentificationCard presentation={identification} onClose={closeIdentification} />;
  if (!visible) return null;
  const view = snapshot ? lifecycleViewForPhase(snapshot.phase) : 'loading';
  if (refreshing || view === 'loading') {
    return (
      <main className="nui-stage" aria-label="Player lifecycle">
        <section className="shell-card lifecycle-state" role="status">
          <div className="spinner" aria-hidden="true" />
          <h1>Authorizing Session</h1>
          <p>The server is resolving the next safe player lifecycle step.</p>
          {message && <p role="alert">{message}</p>}
        </section>
      </main>
    );
  }
  if (view === 'accessPending') {
    return (
      <main className="nui-stage" aria-label="Access review pending">
        <section className="shell-card access-card">
          <div className="shell-card__topline">
            <span>City Administration</span>
            <span className="status-pill">Limited Access</span>
          </div>
          <h1>Access Review Pending</h1>
          <p>
            Registration is complete, but this session has limited access under the current
            whitelist policy. Character and world access remain locked until the server grants full
            access.
          </p>
          <div className="shell-card__footer">
            <span className="runtime-badge">Server status</span>
            <button type="button" onClick={() => void refreshLifecycle()}>
              Check Again
            </button>
          </div>
          {message && <p role="alert">{message}</p>}
        </section>
      </main>
    );
  }
  if (view === 'error') {
    return (
      <main className="nui-stage" aria-label="Lifecycle unavailable">
        <section className="shell-card error-card">
          <div className="shell-card__topline">
            <span>Connection Recovery</span>
            <span className="status-pill">Attention</span>
          </div>
          <h1>Lifecycle Unavailable</h1>
          <p>
            The server could not determine the next player lifecycle step without weakening its
            security checks. Retry when the required resources are ready.
          </p>
          <p className="correlation-reference">Reference: {snapshot?.correlation_id}</p>
          <div className="shell-card__footer">
            <span className="runtime-badge">Safe recovery</span>
            <button type="button" onClick={() => void refreshLifecycle()}>
              Retry
            </button>
          </div>
          {message && <p role="alert">{message}</p>}
        </section>
      </main>
    );
  }
  if (view === 'characterLifecycle') {
    return (
      <main className="nui-stage nui-stage--lifecycle" aria-label="Character Lifecycle">
        <section className="shell-card lifecycle-card">
          <CharacterLifecycle initialPhase={snapshot?.phase} />
          {message && <p role="alert">{message}</p>}
          <output className="sr-only">Focus owner: {focus.owner ?? 'none'}</output>
        </section>
      </main>
    );
  }
  if (view === 'ready') return null;
  return (
    <main className="nui-stage" aria-label={translate('en', 'registration.title')}>
      <section className="shell-card registration-card">
        <div className="shell-card__topline">
          <span>{translate('en', 'registration.eyebrow')}</span>
          <span className="status-pill">Secure Onboarding</span>
        </div>
        <h1>{translate('en', 'registration.title')}</h1>
        <p>{translate('en', 'registration.description')}</p>
        {loading ? (
          <p role="status">{translate('en', 'registration.loading')}</p>
        ) : (
          ruleset && (
            <>
              <div className="ruleset-meta">
                {translate('en', 'registration.version')}: {ruleset.version}
              </div>
              <article className="ruleset-copy">{ruleset.content}</article>
              <label className="acceptance">
                <input
                  type="checkbox"
                  checked={accepted}
                  onChange={(event) => setAccepted(event.target.checked)}
                />
                <span>{translate('en', 'registration.accept')}</span>
              </label>
            </>
          )
        )}
        {message && <p role="alert">{message}</p>}
        <div className="shell-card__footer">
          <span className="runtime-badge">
            {translate('en', mock ? 'shell.browserMock' : 'shell.fivem')}
          </span>
          {!loading && !ruleset ? (
            <button type="button" onClick={() => void loadRuleset()}>
              {translate('en', 'registration.retry')}
            </button>
          ) : (
            <button
              type="button"
              disabled={!accepted || !ruleset || submitting}
              onClick={() => void submit()}
            >
              {translate('en', submitting ? 'registration.submitting' : 'registration.submit')}
            </button>
          )}
        </div>
        <output className="sr-only">Focus owner: {focus.owner ?? 'none'}</output>
      </section>
    </main>
  );
}
