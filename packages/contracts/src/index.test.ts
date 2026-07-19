import { describe, expect, it } from 'vitest';
import {
  accountStatuses,
  errorCodes,
  isNuiMessage,
  isPlayerLifecyclePhase,
  isPlayerLifecycleSnapshot,
  isResourceStatus,
  resourceStatuses,
  playerLifecycleContractVersion,
  playerLifecyclePhases,
  sessionAccessStates,
  registrationContractVersion,
  characterContractVersion,
  characterAppearanceContractVersion,
  characterSelectionContractVersion,
  inventoryContractVersion,
  type SaveCharacterAppearance,
  type SelectCharacter,
  type CreateCharacterDraft,
  type PlayerLifecycleRefresh,
  type InventorySnapshotRequest,
  type InventoryRepositionRequest,
  type InventoryTransferRequest,
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

  it('keeps character selection and appearance free of session and spawn authority', () => {
    const selection: SelectCharacter = {
      character_uuid: '0190b7a0-2000-7000-8000-000000000001',
      request_id: 'selection-1',
      operation_uuid: '0190b7a0-2000-7000-8000-000000000002',
      contract_version: characterSelectionContractVersion,
    };
    const appearance: SaveCharacterAppearance = {
      model: 'mp_m_freemode_01',
      shape_first: 0,
      shape_second: 21,
      shape_mix: 50,
      skin_mix: 50,
      face_features: Array.from({ length: 20 }, () => 0),
      hair_style: 0,
      hair_texture: 0,
      hair_color: 0,
      hair_highlight: 0,
      eye_color: 0,
      outfit_code: 'starter_casual',
      request_id: 'appearance-1',
      operation_uuid: '0190b7a0-2000-7000-8000-000000000003',
      contract_version: characterAppearanceContractVersion,
    };
    for (const payload of [selection, appearance]) {
      expect(Object.keys(payload)).not.toEqual(
        expect.arrayContaining([
          'account_uuid',
          'session_uuid',
          'binding_uuid',
          'spawn_uuid',
          'spawn_x',
          'status',
        ]),
      );
    }
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

  it('validates every server-driven player lifecycle phase', () => {
    for (const phase of playerLifecyclePhases) expect(isPlayerLifecyclePhase(phase)).toBe(true);
    expect(isPlayerLifecyclePhase('CLIENT_SELECTED_ACCOUNT')).toBe(false);
  });

  it('requires a narrow versioned lifecycle snapshot', () => {
    const snapshot = {
      contract_version: playerLifecycleContractVersion,
      phase: 'CHARACTER_SELECTION_REQUIRED',
      retryable: false,
      correlation_id: 'correlation-lifecycle-1',
    } as const;
    expect(isPlayerLifecycleSnapshot(snapshot)).toBe(true);
    expect(isNuiMessage({ version: 1, type: 'ui.lifecycle.open', payload: snapshot })).toBe(true);
    expect(isPlayerLifecycleSnapshot({ ...snapshot, account_uuid: 'forbidden' })).toBe(false);
    expect(isPlayerLifecycleSnapshot({ ...snapshot, contract_version: 2 })).toBe(false);
  });

  it('keeps lifecycle refresh free of account, session, character, and destination authority', () => {
    const refresh: PlayerLifecycleRefresh = {
      contract_version: playerLifecycleContractVersion,
    };
    expect(Object.keys(refresh)).toEqual(['contract_version']);
  });

  it('keeps inventory reads and transfers free of character, item, metadata, and capacity authority', () => {
    const snapshot: InventorySnapshotRequest = {
      request_id: 'inventory-read-1',
      contract_version: inventoryContractVersion,
    };
    const transfer: InventoryTransferRequest = {
      source_inventory_uuid: '0190b7a0-6000-7000-8000-000000000010',
      target_inventory_uuid: '0190b7a0-6000-7000-8000-000000000011',
      source_slot: 1,
      target_slot: 4,
      quantity: 1,
      request_id: 'inventory-transfer-1',
      operation_uuid: '0190b7a0-6000-7000-8000-000000000012',
      contract_version: inventoryContractVersion,
    };
    expect(Object.keys(snapshot).sort()).toEqual(['contract_version', 'request_id']);
    expect(Object.keys(transfer).sort()).toEqual([
      'contract_version',
      'operation_uuid',
      'quantity',
      'request_id',
      'source_inventory_uuid',
      'source_slot',
      'target_inventory_uuid',
      'target_slot',
    ]);
    expect(Object.keys(transfer)).not.toEqual(
      expect.arrayContaining([
        'account_uuid',
        'session_uuid',
        'character_uuid',
        'definition_uuid',
        'item_instance_uuid',
        'metadata',
        'weight',
        'inventory_version',
      ]),
    );
    expect(
      isNuiMessage({
        version: 1,
        type: 'ui.inventory.open',
        payload: { contract_version: inventoryContractVersion, view: 'personal' },
      }),
    ).toBe(true);
    expect(
      isNuiMessage({
        version: 1,
        type: 'ui.inventory.open',
        payload: { contract_version: inventoryContractVersion, view: 'storage' },
      }),
    ).toBe(true);
    expect(
      isNuiMessage({
        version: 1,
        type: 'ui.inventory.open',
        payload: { contract_version: inventoryContractVersion },
      }),
    ).toBe(false);

    const reposition: InventoryRepositionRequest = {
      inventory_uuid: '0190b7a0-6000-7000-8000-000000000010',
      source_slot: 1,
      target_slot: 4,
      request_id: 'inventory-reposition-1',
      operation_uuid: '0190b7a0-6000-7000-8000-000000000013',
      contract_version: inventoryContractVersion,
    };
    expect(Object.keys(reposition).sort()).toEqual([
      'contract_version',
      'inventory_uuid',
      'operation_uuid',
      'request_id',
      'source_slot',
      'target_slot',
    ]);
    expect(Object.keys(reposition)).not.toEqual(
      expect.arrayContaining([
        'account_uuid',
        'session_uuid',
        'character_uuid',
        'entry_uuid',
        'definition_uuid',
        'item_instance_uuid',
        'inventory_version',
      ]),
    );
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
