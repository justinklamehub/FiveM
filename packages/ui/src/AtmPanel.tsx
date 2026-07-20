import { useMemo, useState } from 'react';
import {
  atmContractVersion,
  type AtmCashDirection,
  type AtmCashReceipt,
  type AtmSessionSnapshot,
  type FinancialAccountType,
  type Result,
} from '@cnr/contracts';
import { formatMoney, parseAmountMinor } from './BankingPanel';
import { postNui } from './nui';

const newId = () => crypto.randomUUID();

function accountBalance(snapshot: AtmSessionSnapshot, type: FinancialAccountType): number {
  return (
    snapshot.banking.accounts.find((account) => account.account_type === type)?.balance_minor ?? 0
  );
}

function actionError(code: string, correlationId?: string): string {
  const reference = correlationId ? ` Reference: ${correlationId}` : '';
  if (code === 'CONFLICT')
    return `This operation ID was already used with different cash transaction details.${reference}`;
  if (code === 'PRECONDITION_FAILED')
    return `The transaction could not be posted. Check your balance and remain near the ATM.${reference}`;
  if (code === 'RATE_LIMITED')
    return `Too many ATM attempts. Please wait before trying again.${reference}`;
  return `The ATM transaction is currently unavailable. No funds were moved.${reference}`;
}

export function AtmPanel({
  initialSnapshot,
  onClose,
}: {
  initialSnapshot: AtmSessionSnapshot;
  onClose: () => void;
}) {
  const [snapshot, setSnapshot] = useState(initialSnapshot);
  const [direction, setDirection] = useState<AtmCashDirection>('DEPOSIT');
  const [amount, setAmount] = useState('');
  const [reviewing, setReviewing] = useState(false);
  const [operationUuid, setOperationUuid] = useState<string | null>(null);
  const [sending, setSending] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  const cashBalance = useMemo(() => accountBalance(snapshot, 'CASH_WALLET'), [snapshot]);
  const checkingBalance = useMemo(() => accountBalance(snapshot, 'PERSONAL_CHECKING'), [snapshot]);
  const amountMinor = parseAmountMinor(amount);
  const sourceBalance = direction === 'DEPOSIT' ? cashBalance : checkingBalance;

  const edit = (nextDirection = direction) => {
    setDirection(nextDirection);
    setReviewing(false);
    setOperationUuid(null);
    setMessage(null);
  };

  const review = () => {
    if (!amountMinor) {
      setMessage('Enter a positive amount with no more than two decimal places.');
      return;
    }
    if (amountMinor > sourceBalance) {
      setMessage(
        direction === 'DEPOSIT'
          ? 'Your Cash Wallet does not contain that amount.'
          : 'Your Personal Checking account does not contain that amount.',
      );
      return;
    }
    setMessage(null);
    setOperationUuid(newId());
    setReviewing(true);
  };

  const submit = async () => {
    if (!amountMinor || !operationUuid || sending) return;
    setSending(true);
    setMessage(null);
    try {
      const result = await postNui<Result<AtmCashReceipt>>('banking.atmCash', {
        atm_uuid: snapshot.atm.atm_uuid,
        direction,
        amount_minor: amountMinor,
        request_id: newId(),
        operation_uuid: operationUuid,
        contract_version: atmContractVersion,
      });
      if (!result.ok) {
        setMessage(actionError(result.error.code, result.error.correlation_id));
        return;
      }
      setSnapshot((current) => ({ ...current, banking: result.data.snapshot }));
      setMessage(
        `${result.data.repeated ? 'Transaction confirmed again' : 'Transaction posted'}. Reference: ${result.data.transaction_number}`,
      );
      setAmount('');
      setReviewing(false);
      setOperationUuid(null);
    } catch {
      setMessage(
        'The network response was interrupted. Retry this operation to safely check its result.',
      );
    } finally {
      setSending(false);
    }
  };

  const close = () => {
    void postNui<{ ok: boolean }>('close', {}).catch(() => undefined);
    onClose();
  };

  return (
    <main className="nui-stage atm-stage" aria-label="Automated teller machine">
      <section className="atm-shell">
        <header className="atm-header">
          <div>
            <span>San Andreas Financial Network</span>
            <h1>Secure ATM</h1>
          </div>
          <span className="status-pill">Server Connected</span>
        </header>

        <div className="atm-location">
          <span>Terminal</span>
          <strong>{snapshot.atm.label}</strong>
          <small>{snapshot.atm.code}</small>
        </div>

        <div className="atm-balances">
          <article>
            <span>Cash Wallet</span>
            <strong>{formatMoney(cashBalance)}</strong>
          </article>
          <article>
            <span>Personal Checking</span>
            <strong>{formatMoney(checkingBalance)}</strong>
          </article>
        </div>

        <div className="atm-direction" role="group" aria-label="Transaction type">
          <button
            type="button"
            className={direction === 'DEPOSIT' ? 'active' : ''}
            onClick={() => edit('DEPOSIT')}
          >
            Deposit Cash
            <span>Cash Wallet → Checking</span>
          </button>
          <button
            type="button"
            className={direction === 'WITHDRAW' ? 'active' : ''}
            onClick={() => edit('WITHDRAW')}
          >
            Withdraw Cash
            <span>Checking → Cash Wallet</span>
          </button>
        </div>

        {!reviewing ? (
          <section className="atm-entry" aria-label="ATM amount">
            <label>
              Amount (USD)
              <input
                value={amount}
                onChange={(event) => {
                  setAmount(event.target.value);
                  edit();
                }}
                placeholder="0.00"
                inputMode="decimal"
                autoComplete="off"
                autoFocus
              />
            </label>
            <div className="atm-presets" aria-label="Quick amounts">
              {[20, 50, 100, 500].map((value) => (
                <button
                  key={value}
                  type="button"
                  className="secondary-button"
                  onClick={() => {
                    setAmount(String(value));
                    edit();
                  }}
                >
                  ${value}
                </button>
              ))}
            </div>
            <button type="button" onClick={review}>
              Review {direction === 'DEPOSIT' ? 'Deposit' : 'Withdrawal'}
            </button>
          </section>
        ) : (
          <section className="atm-review" aria-label="Confirm ATM transaction">
            <span>Confirm {direction === 'DEPOSIT' ? 'cash deposit' : 'cash withdrawal'}</span>
            <strong>{formatMoney(amountMinor ?? 0)}</strong>
            <p>
              The server will atomically move this amount from{' '}
              {direction === 'DEPOSIT'
                ? 'Cash Wallet to Personal Checking'
                : 'Personal Checking to Cash Wallet'}
              .
            </p>
            <div>
              <button type="button" className="secondary-button" onClick={() => edit()}>
                Edit
              </button>
              <button type="button" disabled={sending} onClick={() => void submit()}>
                {sending ? 'Posting…' : 'Confirm Transaction'}
              </button>
            </div>
          </section>
        )}

        {message && (
          <p className="atm-message" role="status">
            {message}
          </p>
        )}

        <footer className="atm-footer">
          <span>Proximity and balances verified by server</span>
          <button type="button" className="secondary-button" onClick={close}>
            Close ATM
          </button>
        </footer>
      </section>
    </main>
  );
}
