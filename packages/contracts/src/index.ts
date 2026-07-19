/** Shared versioned contracts used by the NUI and future resource-facing adapters. */
export const resourceStatuses = [
  'starting',
  'ready',
  'degraded',
  'unavailable',
  'stopping',
] as const;
export type ResourceStatus = (typeof resourceStatuses)[number];

export const errorCodes = [
  'VALIDATION_ERROR',
  'AUTHENTICATION_REQUIRED',
  'IDENTIFIER_REQUIRED',
  'IDENTIFIER_CONFLICT',
  'REGISTRATION_DISABLED',
  'ACCOUNT_BANNED',
  'ACCOUNT_RESTRICTED',
  'WHITELIST_REQUIRED',
  'SESSION_ALREADY_ACTIVE',
  'CHARACTER_REQUIRED',
  'PERMISSION_DENIED',
  'RATE_LIMITED',
  'NOT_FOUND',
  'CONFLICT',
  'PRECONDITION_FAILED',
  'INSUFFICIENT_FUNDS',
  'INSUFFICIENT_CAPACITY',
  'DEPENDENCY_UNAVAILABLE',
  'MAINTENANCE_MODE',
  'INTERNAL_ERROR',
] as const;
export type ErrorCode = (typeof errorCodes)[number];

export const accountStatuses = [
  'PENDING_REGISTRATION',
  'PENDING_WHITELIST',
  'ACTIVE',
  'SUSPENDED',
  'BANNED',
  'RESTRICTED',
  'ARCHIVED',
] as const;
export type AccountStatus = (typeof accountStatuses)[number];

export const sessionAccessStates = ['ONBOARDING', 'LIMITED', 'FULL'] as const;
export type SessionAccessState = (typeof sessionAccessStates)[number];

export const registrationContractVersion = 1 as const;
export interface RegistrationStatus {
  registered: boolean;
  account_status: AccountStatus;
  access_state: SessionAccessState;
  ruleset_uuid: string | null;
  ruleset_version: number | null;
}
export interface CurrentRuleset {
  ruleset_uuid: string;
  version: number;
  locale: 'en';
  content: string;
  published_at: string;
}
export interface RegistrationSubmission {
  ruleset_uuid: string;
  ruleset_version: number;
  acceptance: true;
  locale: 'en';
  request_id: string;
  operation_uuid: string;
  contract_version: typeof registrationContractVersion;
}
export interface RegistrationOutcome {
  repeated: boolean;
  operation_uuid: string;
  account_status: 'PENDING_WHITELIST' | 'ACTIVE';
  access_state: 'LIMITED' | 'FULL';
}
export const characterContractVersion = 1 as const;
export type CharacterStatus =
  | 'DRAFT'
  | 'ACTIVE'
  | 'INJURED'
  | 'JAILED'
  | 'RESTRICTED'
  | 'ARCHIVED'
  | 'DECEASED'
  | 'PENDING_DELETION';
export interface CharacterBackground {
  code: string;
  label: string;
  description: string;
}
export interface CharacterConfiguration {
  slot_limit: number;
  minimum_age: number;
  maximum_age: number;
  backgrounds: readonly CharacterBackground[];
}
export interface CharacterSummary {
  character_uuid: string;
  slot_number: number;
  status: CharacterStatus;
  first_name: string;
  last_name: string;
  date_of_birth: string;
  background_code: string;
}
export interface CharacterList {
  slot_limit: number;
  characters: readonly CharacterSummary[];
}
export interface CreateCharacterDraft {
  first_name: string;
  last_name: string;
  date_of_birth: string;
  background_code: string;
  request_id: string;
  operation_uuid: string;
  contract_version: typeof characterContractVersion;
}
export interface ActivateCharacterDraft {
  character_uuid: string;
  request_id: string;
  operation_uuid: string;
  contract_version: typeof characterContractVersion;
}
export interface CharacterMutationOutcome {
  repeated: boolean;
  operation_uuid: string;
  character?: CharacterSummary;
  character_uuid?: string;
  status?: 'DRAFT' | 'ACTIVE';
}

export const characterSelectionContractVersion = 1 as const;
export const characterAppearanceContractVersion = 1 as const;
export type CharacterSelectionNextState = 'APPEARANCE_REQUIRED' | 'SPAWN_PENDING' | 'SPAWNED';
export interface CharacterSelectionStatus {
  selected: boolean;
  binding_uuid: string | null;
  character: CharacterSummary | null;
  next_state: CharacterSelectionNextState | null;
}
export interface SelectCharacter {
  character_uuid: string;
  request_id: string;
  operation_uuid: string;
  contract_version: typeof characterSelectionContractVersion;
}
export interface CharacterSelectionOutcome {
  repeated: boolean;
  operation_uuid: string;
  binding_uuid: string;
  character: CharacterSummary;
  next_state: CharacterSelectionNextState;
}
export type FreemodeModel = 'mp_m_freemode_01' | 'mp_f_freemode_01';
export interface CharacterAppearance {
  model: FreemodeModel;
  shape_first: number;
  shape_second: number;
  shape_mix: number;
  skin_mix: number;
  face_features: readonly number[];
  hair_style: number;
  hair_texture: number;
  hair_color: number;
  hair_highlight: number;
  eye_color: number;
  outfit_code: 'starter_casual';
}
export interface CharacterAppearanceConfiguration {
  models: readonly FreemodeModel[];
  parent_minimum: number;
  parent_maximum: number;
  face_feature_count: 20;
  face_feature_minimum: number;
  face_feature_maximum: number;
  hair_style_maximum: number;
  hair_texture_maximum: number;
  hair_color_maximum: number;
  eye_color_maximum: number;
  outfit_codes: readonly ['starter_casual'];
  defaults: CharacterAppearance;
}
export interface SaveCharacterAppearance extends CharacterAppearance {
  request_id: string;
  operation_uuid: string;
  contract_version: typeof characterAppearanceContractVersion;
}
export interface CharacterAppearanceOutcome {
  repeated: boolean;
  operation_uuid: string;
  appearance_version: number;
  next_state: 'SPAWN_PENDING';
}
export interface CharacterSpawnInstruction {
  spawn_uuid: string;
  binding_uuid: string;
  reason: 'CENTRAL_DEFAULT' | 'LAST_SAFE';
  x: number;
  y: number;
  z: number;
  heading: number;
  appearance: CharacterAppearance;
}

export const playerLifecycleContractVersion = 1 as const;
export const playerLifecyclePhases = [
  'CONNECTING',
  'SESSION_PENDING',
  'REGISTRATION_REQUIRED',
  'ACCESS_PENDING',
  'CHARACTER_CREATION_REQUIRED',
  'CHARACTER_SELECTION_REQUIRED',
  'APPEARANCE_REQUIRED',
  'SPAWN_PENDING',
  'READY',
  'RECOVERABLE_ERROR',
] as const;
export type PlayerLifecyclePhase = (typeof playerLifecyclePhases)[number];
export interface PlayerLifecycleRefresh {
  contract_version: typeof playerLifecycleContractVersion;
}
export interface PlayerLifecycleSnapshot {
  contract_version: typeof playerLifecycleContractVersion;
  phase: PlayerLifecyclePhase;
  retryable: boolean;
  correlation_id: string;
}

export interface ConnectionSession {
  session_uuid: string;
  account_uuid: string;
  access_state: SessionAccessState;
}

export interface TechnicalRoleAssignment {
  code: string;
  priority: number;
  starts_at: string;
  ends_at: string | null;
}

export interface TechnicalPermissionSnapshot {
  account_uuid: string;
  roles: readonly TechnicalRoleAssignment[];
  permissions: readonly string[];
}

export interface TechnicalPermissionDecision {
  account_uuid: string;
  permission: string;
  allowed: boolean;
}

export interface RequestEnvelope<TPayload> {
  request_id: string;
  operation_uuid?: string;
  contract_version: number;
  payload: TPayload;
}

export interface RequestContext {
  source: number;
  request_id: string;
  operation_uuid?: string;
  contract_version: number;
  correlation_id: string;
  server_time: string;
  account_id: string | null;
  session_id: string | null;
  character_id: string | null;
  routing_bucket: number | null;
}

export interface SuccessResult<T> {
  ok: true;
  data: T;
  correlation_id: string;
}

export interface ErrorResult {
  ok: false;
  error: {
    code: ErrorCode;
    message_key: string;
    safe_details: Readonly<Record<string, unknown>>;
    correlation_id: string;
  };
}

export type Result<T> = SuccessResult<T> | ErrorResult;

export interface ResourceReadiness {
  resource: string;
  version: string;
  status: ResourceStatus;
  changed_at: string;
  details: Readonly<Record<string, unknown>>;
}

export interface NuiRequestResponse {
  version: 1;
  type: 'ui.request.response';
  payload: {
    event: string;
    request_id: string;
    result: unknown;
  };
}

export type NuiMessage =
  | { version: 1; type: 'ui.shell.close'; payload: Record<string, never> }
  | { version: 1; type: 'ui.resource.status'; payload: ResourceReadiness }
  | { version: 1; type: 'ui.lifecycle.open'; payload: PlayerLifecycleSnapshot }
  | { version: 1; type: 'ui.lifecycle.phase'; payload: PlayerLifecycleSnapshot }
  | {
      version: 1;
      type: 'ui.character.spawn_failed';
      payload: { correlation_id: string };
    }
  | NuiRequestResponse;

export function isResourceStatus(value: unknown): value is ResourceStatus {
  return typeof value === 'string' && resourceStatuses.includes(value as ResourceStatus);
}

export function isPlayerLifecyclePhase(value: unknown): value is PlayerLifecyclePhase {
  return typeof value === 'string' && playerLifecyclePhases.includes(value as PlayerLifecyclePhase);
}

export function isPlayerLifecycleSnapshot(value: unknown): value is PlayerLifecycleSnapshot {
  if (typeof value !== 'object' || value === null) return false;
  const candidate = value as {
    contract_version?: unknown;
    phase?: unknown;
    retryable?: unknown;
    correlation_id?: unknown;
  };
  const keys = Object.keys(value).sort();
  return (
    keys.join(',') === 'contract_version,correlation_id,phase,retryable' &&
    candidate.contract_version === playerLifecycleContractVersion &&
    isPlayerLifecyclePhase(candidate.phase) &&
    typeof candidate.retryable === 'boolean' &&
    typeof candidate.correlation_id === 'string' &&
    candidate.correlation_id.length > 0
  );
}

export function isNuiMessage(value: unknown): value is NuiMessage {
  if (typeof value !== 'object' || value === null) return false;
  const candidate = value as { version?: unknown; type?: unknown; payload?: unknown };
  if (candidate.version !== 1 || typeof candidate.type !== 'string') return false;
  if (typeof candidate.payload !== 'object' || candidate.payload === null) return false;
  if (candidate.type === 'ui.shell.close') return true;
  if (candidate.type === 'ui.resource.status') return true;
  if (candidate.type === 'ui.lifecycle.open' || candidate.type === 'ui.lifecycle.phase') {
    return isPlayerLifecycleSnapshot(candidate.payload);
  }
  if (candidate.type === 'ui.character.spawn_failed') {
    const payload = candidate.payload as { correlation_id?: unknown };
    return typeof payload.correlation_id === 'string';
  }
  if (candidate.type === 'ui.request.response') {
    const payload = candidate.payload as {
      event?: unknown;
      request_id?: unknown;
      result?: unknown;
    };
    return (
      typeof payload.event === 'string' &&
      typeof payload.request_id === 'string' &&
      Object.hasOwn(payload, 'result')
    );
  }
  return false;
}
