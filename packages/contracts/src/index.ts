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

export type NuiMessage =
  | { version: 1; type: 'ui.shell.open'; payload: { view: string; locale: string } }
  | { version: 1; type: 'ui.shell.close'; payload: Record<string, never> }
  | { version: 1; type: 'ui.resource.status'; payload: ResourceReadiness }
  | { version: 1; type: 'ui.registration.open'; payload: { locale: 'en' } }
  | { version: 1; type: 'ui.character_creation.open'; payload: Record<string, never> };

export function isResourceStatus(value: unknown): value is ResourceStatus {
  return typeof value === 'string' && resourceStatuses.includes(value as ResourceStatus);
}

export function isNuiMessage(value: unknown): value is NuiMessage {
  if (typeof value !== 'object' || value === null) return false;
  const candidate = value as { version?: unknown; type?: unknown; payload?: unknown };
  if (candidate.version !== 1 || typeof candidate.type !== 'string') return false;
  if (typeof candidate.payload !== 'object' || candidate.payload === null) return false;
  if (candidate.type === 'ui.shell.close') return true;
  if (candidate.type === 'ui.resource.status') return true;
  if (candidate.type === 'ui.registration.open') {
    const payload = candidate.payload as { locale?: unknown };
    return payload.locale === 'en';
  }
  if (candidate.type === 'ui.character_creation.open') return true;
  if (candidate.type !== 'ui.shell.open') return false;
  const payload = candidate.payload as { view?: unknown; locale?: unknown };
  return typeof payload.view === 'string' && typeof payload.locale === 'string';
}
