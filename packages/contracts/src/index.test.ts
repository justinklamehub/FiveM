import { describe, expect, it } from 'vitest';
import {
  accountStatuses,
  errorCodes,
  isResourceStatus,
  resourceStatuses,
  sessionAccessStates,
  type TechnicalPermissionDecision,
  type TechnicalPermissionSnapshot,
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

  it('keeps technical permission contracts role-agnostic', () => {
    const snapshot: TechnicalPermissionSnapshot = {
      account_uuid: '018f0000-0000-7000-8000-000000000001',
      roles: [
        {
          code: 'custom_operator',
          priority: 450,
          starts_at: '2026-07-16T00:00:00Z',
          ends_at: null,
        },
      ],
      permissions: ['system.status.read'],
    };
    const decision: TechnicalPermissionDecision = {
      account_uuid: snapshot.account_uuid,
      permission: snapshot.permissions[0],
      allowed: true,
    };

    expect(snapshot.roles[0].code).toBe('custom_operator');
    expect(decision.allowed).toBe(true);
  });
});
