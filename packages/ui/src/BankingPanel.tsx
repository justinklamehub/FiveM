import { useCallback, useEffect, useState } from 'react';
import {
  bankingContractVersion,
  type BankingSnapshot,
  type BankingTransferReceipt,
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

export function parseAmountMinor(value: string): number | null {
  const normalized = value.trim();
  if (!/^\d+(\.\d{1,2})?$/.test(normalized)) return null;
  const [dollars, cents = ''] = normalized.split('.');
  const amount = Number(dollars) * 100 + Number(cents.padEnd(2, '0'));
  return Number.isSafeInteger(amount) && amount > 0 ? amount : null;
}

function transferError(code: string, correlationId?: string): string {
  const reference = correlationId ? ` Reference: ${correlationId}` : '';
  if (code === 'CONFLICT')
    return `This operation ID was already used for different transfer details.${reference}`;
  if (code === 'PRECONDITION_FAILED')
    return `The transfer could not be posted. Check the recipient and available balance.${reference}`;
  if (code === 'RATE_LIMITED')
    return `Too many transfer attempts. Please wait and try again.${reference}`;
  return `The transfer is currently unavailable. No funds were moved.${reference}`;
}

export function BankingPanel({
  onClose,
  embedded = false,
}: {
  onClose: () => void;
  embedded?: boolean;
}) {
  const [snapshot, setSnapshot] = useState<BankingSnapshot | null>(null);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState<string | null>(null);
  const [transferOpen, setTransferOpen] = useState(false);
  const [reviewing, setReviewing] = useState(false);
  const [recipient, setRecipient] = useState('');
  const [amount, setAmount] = useState('');
  const [purpose, setPurpose] = useState('');
  const [operationUuid, setOperationUuid] = useState<string | null>(null);
  const [sending, setSending] = useState(false);
  const [transferMessage, setTransferMessage] = useState<string | null>(null);

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
    if (!embedded) void postNui<{ ok: boolean }>('close', {}).catch(() => undefined);
    onClose();
  };

  const editTransfer = () => {
    setReviewing(false);
    setOperationUuid(null);
    setTransferMessage(null);
  };

  const reviewTransfer = () => {
    const amountMinor = parseAmountMinor(amount);
    if (!/^SA-[A-Fa-f0-9]{16}$/.test(recipient.trim())) {
      setTransferMessage('Enter a valid Personal Checking account number.');
      return;
    }
    if (!amountMinor) {
      setTransferMessage('Enter a positive amount with no more than two decimal places.');
      return;
    }
    if (purpose.trim().length < 1 || purpose.trim().length > 120) {
      setTransferMessage('Enter a transfer purpose of up to 120 characters.');
      return;
    }
    setTransferMessage(null);
    setOperationUuid(newId());
    setReviewing(true);
  };

  const submitTransfer = async () => {
    const amountMinor = parseAmountMinor(amount);
    if (!amountMinor || !operationUuid) return;
    setSending(true);
    setTransferMessage(null);
    try {
      const result = await postNui<Result<BankingTransferReceipt>>('banking.transfer', {
        recipient_account_number: recipient.trim().toUpperCase(),
        amount_minor: amountMinor,
        purpose: purpose.trim(),
        request_id: newId(),
        operation_uuid: operationUuid,
        contract_version: bankingContractVersion,
      });
      if (!result.ok) {
        setTransferMessage(transferError(result.error.code, result.error.correlation_id));
        return;
      }
      setSnapshot(result.data.snapshot);
      setTransferMessage(
        `${result.data.repeated ? 'Transfer confirmed again' : 'Transfer posted'}. Reference: ${result.data.transaction_number}`,
      );
      setReviewing(false);
      setOperationUuid(null);
      setRecipient('');
      setAmount('');
      setPurpose('');
    } catch {
      setTransferMessage(
        'The network response was interrupted. Retry this operation to safely check its result.',
      );
    } finally {
      setSending(false);
    }
  };

  const panel = (
    <section className={`shell-card banking-card${embedded ? ' banking-card--embedded' : ''}`}>
      <div className="shell-card__topline">
        <span>San Andreas Financial Network</span>
        <span className="status-pill">Transfers Enabled</span>
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
            <div className="banking-transfer-launcher">
              <div>
                <strong>Send from Personal Checking</strong>
                <span>The server validates the recipient, balance, and final ledger entries.</span>
              </div>
              <button
                type="button"
                onClick={() => {
                  setTransferOpen((open) => !open);
                  editTransfer();
                }}
              >
                {transferOpen ? 'Cancel Transfer' : 'New Transfer'}
              </button>
            </div>
            {transferOpen && (
              <section className="banking-transfer" aria-label="New bank transfer">
                {!reviewing ? (
                  <div className="banking-transfer__form">
                    <label>
                      Recipient Account
                      <input
                        value={recipient}
                        onChange={(event) => {
                          setRecipient(event.target.value);
                          editTransfer();
                        }}
                        placeholder="SA-0000000000000000"
                        autoComplete="off"
                        maxLength={19}
                      />
                    </label>
                    <label>
                      Amount (USD)
                      <input
                        value={amount}
                        onChange={(event) => {
                          setAmount(event.target.value);
                          editTransfer();
                        }}
                        placeholder="0.00"
                        inputMode="decimal"
                        autoComplete="off"
                      />
                    </label>
                    <label className="banking-transfer__purpose">
                      Purpose
                      <input
                        value={purpose}
                        onChange={(event) => {
                          setPurpose(event.target.value);
                          editTransfer();
                        }}
                        placeholder="What is this transfer for?"
                        autoComplete="off"
                        maxLength={120}
                      />
                    </label>
                    <button type="button" onClick={reviewTransfer}>
                      Review Transfer
                    </button>
                  </div>
                ) : (
                  <div className="banking-transfer__review">
                    <span>Confirm transfer</span>
                    <strong>{formatMoney(parseAmountMinor(amount) ?? 0)}</strong>
                    <dl>
                      <div>
                        <dt>Recipient</dt>
                        <dd>{recipient.trim().toUpperCase()}</dd>
                      </div>
                      <div>
                        <dt>Purpose</dt>
                        <dd>{purpose.trim()}</dd>
                      </div>
                    </dl>
                    <div>
                      <button type="button" className="secondary-button" onClick={editTransfer}>
                        Edit
                      </button>
                      <button
                        type="button"
                        disabled={sending}
                        onClick={() => void submitTransfer()}
                      >
                        {sending ? 'Posting…' : 'Confirm and Send'}
                      </button>
                    </div>
                  </div>
                )}
                {transferMessage && <p role="status">{transferMessage}</p>}
              </section>
            )}
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
                        <strong
                          className={`banking-transaction--${transaction.direction.toLowerCase()}`}
                        >
                          {transaction.direction === 'CREDIT' ? '+' : '−'}
                          {formatMoney(transaction.amount_minor)}
                        </strong>
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
            {embedded ? 'Back to Apps' : 'Close'}
          </button>
        </div>
      </div>
    </section>
  );

  if (embedded) return panel;
  return (
    <main className="nui-stage banking-stage" aria-label="Personal banking">
      {panel}
    </main>
  );
}
