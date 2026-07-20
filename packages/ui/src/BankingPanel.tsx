import { useCallback, useEffect, useState } from 'react';
import {
  bankingContractVersion,
  type BankingSnapshot,
  type FinancialAccountType,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();

export function formatMoney(amountMinor: number, currency: 'USD' = 'USD'): string {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency }).format(amountMinor / 100);
}

export function accountLabel(type: FinancialAccountType): string {
  return type === 'CASH_WALLET' ? 'Cash Wallet' : 'Personal Checking';
}

export function BankingPanel({ onClose }: { onClose: () => void }) {
  const [snapshot, setSnapshot] = useState<BankingSnapshot | null>(null);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setMessage(null);
    try {
      const result = await postNui<Result<BankingSnapshot>>('banking.snapshot', {
        request_id: newId(),
        contract_version: bankingContractVersion,
      });
      if (!result.ok) throw new Error(result.error.code);
      setSnapshot(result.data);
    } catch {
      setSnapshot(null);
      setMessage('Banking information is currently unavailable. Please try again.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => void load(), [load]);

  const close = () => {
    void postNui<{ ok: boolean }>('close', {}).catch(() => undefined);
    onClose();
  };

  return (
    <main className="nui-stage banking-stage" aria-label="Personal banking">
      <section className="shell-card banking-card">
        <div className="shell-card__topline">
          <span>San Andreas Financial Network</span>
          <span className="status-pill">Read Only</span>
        </div>
        <div className="banking-heading">
          <div>
            <h1>Personal Banking</h1>
            <p>Balances and transactions are calculated from the secure server ledger.</p>
          </div>
          <span className="banking-security">Server Verified</span>
        </div>

        <div className="banking-content" aria-busy={loading}>
          {loading && (
            <div className="banking-loading" role="status">
              <div className="spinner" aria-hidden="true" />
              <span>Loading financial accounts…</span>
            </div>
          )}
          {!loading && snapshot && (
            <>
              <div className="banking-accounts">
                {snapshot.accounts.map((account) => (
                  <article className="banking-account" key={account.account_uuid}>
                    <div>
                      <span>{accountLabel(account.account_type)}</span>
                      <small>{account.account_number}</small>
                    </div>
                    <strong>{formatMoney(account.balance_minor, account.currency)}</strong>
                    <span className="banking-account__status">{account.status}</span>
                  </article>
                ))}
              </div>
              <section className="banking-history" aria-label="Recent transactions">
                <div className="banking-history__heading">
                  <h2>Recent Activity</h2>
                  <span>{snapshot.recent_transactions.length} entries</span>
                </div>
                {snapshot.recent_transactions.length === 0 ? (
                  <p>No transactions have been posted yet.</p>
                ) : (
                  <div className="banking-transactions">
                    {snapshot.recent_transactions.map((transaction) => (
                      <article key={transaction.transaction_uuid}>
                        <div>
                          <strong>{transaction.purpose}</strong>
                          <span>{transaction.transaction_number}</span>
                        </div>
                        <div>
                          <strong>+{formatMoney(transaction.amount_minor)}</strong>
                          <span>{new Date(transaction.posted_at).toLocaleString('en-US')}</span>
                        </div>
                      </article>
                    ))}
                  </div>
                )}
              </section>
            </>
          )}
          {message && <p role="alert">{message}</p>}
        </div>

        <div className="shell-card__footer">
          <span className="runtime-badge">Immutable double-entry ledger</span>
          <div className="banking-actions">
            {message && (
              <button type="button" className="secondary-button" onClick={() => void load()}>
                Retry
              </button>
            )}
            <button type="button" onClick={close}>
              Close
            </button>
          </div>
        </div>
      </section>
    </main>
  );
}
