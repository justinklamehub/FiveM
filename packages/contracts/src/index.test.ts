import { describe, expect, it } from 'vitest';
import {
  accountStatuses,
  errorCodes,
  isResourceStatus,
  resourceStatuses,
  sessionAccessStates,
  type TechnicalPermissionDecision,
  type TechnicalPermissionSnapshot,
  type TechnicalRoleAssignment,
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
    const customRole: TechnicalRoleAssignment = {
      code: 'custom_operator',
      priority: 450,
      starts_at: '2026-07-16T00:00:00Z',
      ends_at: null,
    };
    const permission = 'system.status.read';
    const snapshot: TechnicalPermissionSnapshot = {
      account_uuid: '018f0000-0000-7000-8000-000000000001',
      roles: [customRole],
      permissions: [permission],
    };
    const decision: TechnicalPermissionDecision = {
      account_uuid: snapshot.account_uuid,
      permission,
      allowed: true,
    };

    expect(snapshot.roles).toContainEqual(customRole);
    expect(decision.allowed).toBe(true);
  });
});
