import { describe, expect, it } from 'vitest';
import {
  accountStatuses,
  errorCodes,
  isNuiMessage,
  isResourceStatus,
  resourceStatuses,
  sessionAccessStates,
  registrationContractVersion,
  characterContractVersion,
  type CreateCharacterDraft,
  type RegistrationSubmission,
  type TechnicalPermissionDecision,
  type TechnicalPermissionSnapshot,
  type TechnicalRoleAssignment,
} from './index';

describe('core contracts', () => {
  it('accepts only the documented readiness states', () => {
    for (const status of resourceStatuses) expect(isResourceStatus(status)).toBe(true);
    expect(isResourceStatus('booted')).toBe(false);
  });
  it('keeps character draft input free of account, session, slot, status, and document authority', () => {
    const draft: CreateCharacterDraft = {
      first_name: 'Alex',
      last_name: 'Morgan',
      date_of_birth: '1995-05-20',
      background_code: 'local',
      request_id: 'request-2',
      operation_uuid: '0190b7a0-2000-7000-8000-000000000001',
      contract_version: characterContractVersion,
    };
    expect(Object.keys(draft)).not.toEqual(
      expect.arrayContaining([
        'account_uuid',
        'session_uuid',
        'slot_number',
        'status',
        'document_number',
      ]),
    );
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

  it('exposes a narrow versioned registration submission contract', () => {
    const request: RegistrationSubmission = {
      ruleset_uuid: '0190b7a0-0000-7000-8000-000000000001',
      ruleset_version: 1,
      acceptance: true,
      locale: 'en',
      request_id: 'request-1',
      operation_uuid: '0190b7a0-0000-7000-8000-000000000002',
      contract_version: registrationContractVersion,
    };
    expect(Object.keys(request).sort()).toEqual([
      'acceptance',
      'contract_version',
      'locale',
      'operation_uuid',
      'request_id',
      'ruleset_uuid',
      'ruleset_version',
    ]);
  });

  it('validates request-correlated NUI response messages', () => {
    expect(
      isNuiMessage({
        version: 1,
        type: 'ui.request.response',
        payload: {
          event: 'registrationRuleset',
          request_id: 'request-1',
          result: { ok: true },
        },
      }),
    ).toBe(true);
    expect(
      isNuiMessage({
        version: 1,
        type: 'ui.request.response',
        payload: { event: 'registrationRuleset', request_id: 'request-1' },
      }),
    ).toBe(false);
  });
});
