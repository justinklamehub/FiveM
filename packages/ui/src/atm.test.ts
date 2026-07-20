import { describe, expect, it } from 'vitest';
import {
  atmContractVersion,
  isNuiMessage,
  type AtmCashReceipt,
  type AtmSessionSnapshot,
  type Result,
} from '@cnr/contracts';
import { postNui } from './nui';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

const atm: AtmSessionSnapshot['atm'] = {
  atm_uuid: '0190b7a0-7400-7000-8000-000000000010',
  code: 'ATM-LEGION-PARKING',
  label: 'Legion Square Parking ATM',
  x: 215.76,
  y: -810.12,
  z: 30.73,
  heading: 157,
  interaction_radius: 3,
  status: 'ACTIVE',
  version: 1,
};

describe('ATM browser surface', () => {
  it('validates the server-opened terminal message', () => {
    expect(
      isNuiMessage({
        version: 1,
        type: 'ui.atm.open',
        payload: {
          contract_version: atmContractVersion,
          atm,
          banking: { accounts: [], recent_transactions: [] },
        },
      }),
    ).toBe(true);
    expect(
      isNuiMessage({
        version: 1,
        type: 'ui.atm.open',
        payload: {
          contract_version: atmContractVersion,
          atm: { ...atm, status: 'INACTIVE' },
          banking: { accounts: [], recent_transactions: [] },
        },
      }),
    ).toBe(false);
  });

  it('posts and safely replays a cash deposit', async () => {
    const request = {
      atm_uuid: atm.atm_uuid,
      direction: 'DEPOSIT' as const,
      amount_minor: 2000,
      request_id: 'atm-browser-1',
      operation_uuid: '0190b7a0-7400-7000-8000-000000000020',
      contract_version: atmContractVersion,
    };
    const result = await postNui<Result<AtmCashReceipt>>('banking.atmCash', request);
    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.data).toMatchObject({
      repeated: false,
      direction: 'DEPOSIT',
      amount_minor: 2000,
      atm_uuid: atm.atm_uuid,
    });
    expect(
      result.data.snapshot.accounts.find((account) => account.account_type === 'CASH_WALLET')
        ?.balance_minor,
    ).toBe(3000);
    expect(
      result.data.snapshot.accounts.find((account) => account.account_type === 'PERSONAL_CHECKING')
        ?.balance_minor,
    ).toBe(27000);

    const replay = await postNui<Result<AtmCashReceipt>>('banking.atmCash', {
      ...request,
      request_id: 'atm-browser-2',
    });
    expect(replay.ok && replay.data.repeated).toBe(true);

    const conflict = await postNui<Result<AtmCashReceipt>>('banking.atmCash', {
      ...request,
      amount_minor: 2500,
      request_id: 'atm-browser-3',
    });
    expect(conflict.ok).toBe(false);
    if (!conflict.ok) expect(conflict.error.code).toBe('CONFLICT');
  });
});
