import { describe, expect, it } from 'vitest';
import { bankingContractVersion, type BankingSnapshot, type Result } from '@cnr/contracts';
import { accountLabel, formatMoney } from './BankingPanel';
import { postNui } from './nui';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

describe('banking browser surface', () => {
  it('formats integer minor-unit balances and account labels', () => {
    expect(formatMoney(5000)).toBe('$50.00');
    expect(formatMoney(25000)).toBe('$250.00');
    expect(accountLabel('CASH_WALLET')).toBe('Cash Wallet');
    expect(accountLabel('PERSONAL_CHECKING')).toBe('Personal Checking');
  });

  it('returns only server-shaped accounts and balanced starter history', async () => {
    const result = await postNui<Result<BankingSnapshot>>('banking.snapshot', {
      request_id: 'banking-browser-1',
      contract_version: bankingContractVersion,
    });
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data.accounts).toHaveLength(2);
    expect(result.data.accounts.map((account) => account.account_type)).toEqual([
      'CASH_WALLET',
      'PERSONAL_CHECKING',
    ]);
    expect(result.data.accounts.reduce((sum, account) => sum + account.balance_minor, 0)).toBe(
      30000,
    );
    expect(result.data.recent_transactions[0]).toMatchObject({
      transaction_type: 'STARTER_ALLOCATION',
      status: 'POSTED',
      amount_minor: 30000,
      currency: 'USD',
    });
  });
});
