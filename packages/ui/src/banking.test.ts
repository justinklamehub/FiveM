import { describe, expect, it } from 'vitest';
import {
  bankingContractVersion,
  type BankingSnapshot,
  type BankingTransferReceipt,
  type Result,
} from '@cnr/contracts';
import { accountLabel, formatMoney, parseAmountMinor } from './BankingPanel';
import { postNui } from './nui';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

describe('banking browser surface', () => {
  it('formats integer minor-unit balances and account labels', () => {
    expect(formatMoney(5000)).toBe('$50.00');
    expect(formatMoney(25000)).toBe('$250.00');
    expect(accountLabel('CASH_WALLET')).toBe('Cash Wallet');
    expect(accountLabel('PERSONAL_CHECKING')).toBe('Personal Checking');
    expect(parseAmountMinor('12.50')).toBe(1250);
    expect(parseAmountMinor('12.5')).toBe(1250);
    expect(parseAmountMinor('0')).toBeNull();
    expect(parseAmountMinor('12.345')).toBeNull();
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
      direction: 'CREDIT',
      currency: 'USD',
    });
  });

  it('posts and safely replays a transfer intent without client sender authority', async () => {
    const request = {
      recipient_account_number: 'SA-800000000012',
      amount_minor: 1250,
      purpose: 'Shared fuel cost',
      request_id: 'banking-transfer-browser-1',
      operation_uuid: '0190b7a0-7000-7000-8000-000000000098',
      contract_version: bankingContractVersion,
    };
    const result = await postNui<Result<BankingTransferReceipt>>('banking.transfer', request);
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data).toMatchObject({
      repeated: false,
      recipient_account_number: request.recipient_account_number,
      amount_minor: 1250,
    });
    expect(
      result.data.snapshot.accounts.find((account) => account.account_type === 'PERSONAL_CHECKING')
        ?.balance_minor,
    ).toBe(23750);
    expect(result.data.snapshot.recent_transactions[0]).toMatchObject({
      transaction_type: 'BANK_TRANSFER',
      direction: 'DEBIT',
      amount_minor: 1250,
    });

    const replay = await postNui<Result<BankingTransferReceipt>>('banking.transfer', {
      ...request,
      request_id: 'banking-transfer-browser-2',
    });
    expect(replay.ok && replay.data.repeated).toBe(true);

    const conflict = await postNui<Result<BankingTransferReceipt>>('banking.transfer', {
      ...request,
      amount_minor: 1300,
      request_id: 'banking-transfer-browser-3',
    });
    expect(conflict.ok).toBe(false);
    if (!conflict.ok) expect(conflict.error.code).toBe('CONFLICT');
  });
});
