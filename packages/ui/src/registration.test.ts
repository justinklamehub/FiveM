import { describe, expect, it } from 'vitest';
import { postNui } from './nui';
import type { CurrentRuleset, RegistrationOutcome, Result } from '@cnr/contracts';

Object.defineProperty(globalThis, 'window', { value: {}, configurable: true });

describe('registration browser mock', () => {
  it('acknowledges the browser readiness handshake', async () => {
    const result = await postNui<{ ok: boolean }>('uiReady', {});
    expect(result.ok).toBe(true);
  });

  it('delivers the English current ruleset without FiveM', async () => {
    const result = await postNui<Result<CurrentRuleset>>('registrationRuleset', { locale: 'en' });
    expect(result.ok).toBe(true);
    if (result.ok) expect(result.data.locale).toBe('en');
  });
  it('returns the submitted idempotency key in the outcome', async () => {
    const operation_uuid = '0190b7a0-0000-7000-8000-000000000002';
    const result = await postNui<Result<RegistrationOutcome>>('registrationSubmit', {
      operation_uuid,
    });
    expect(result.ok).toBe(true);
    if (result.ok) expect(result.data.operation_uuid).toBe(operation_uuid);
  });
});
