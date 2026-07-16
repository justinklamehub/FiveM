import { describe, expect, it } from 'vitest';
import {
  accountStatuses,
  errorCodes,
  isResourceStatus,
  resourceStatuses,
  sessionAccessStates,
} from './index';

describe('core contracts', () => {
  it('accepts only the documented readiness states', () => {
    for (const status of resourceStatuses) expect(isResourceStatus(status)).toBe(true);
    expect(isResourceStatus('booted')).toBe(false);
  });

  it('keeps stable baseline error codes', () => {
    expect(errorCodes).toContain('DEPENDENCY_UNAVAILABLE');
    expect(errorCodes).toContain('INTERNAL_ERROR');
  });

  it('exports the Wave 1 lifecycle states', () => {
    expect(accountStatuses).toContain('PENDING_REGISTRATION');
    expect(sessionAccessStates).toEqual(['ONBOARDING', 'LIMITED', 'FULL']);
    expect(errorCodes).toContain('SESSION_ALREADY_ACTIVE');
  });
});
