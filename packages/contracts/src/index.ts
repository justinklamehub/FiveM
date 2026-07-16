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
  | { version: 1; type: 'ui.resource.status'; payload: ResourceReadiness };

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
  if (candidate.type !== 'ui.shell.open') return false;
  const payload = candidate.payload as { view?: unknown; locale?: unknown };
  return typeof payload.view === 'string' && typeof payload.locale === 'string';
}
