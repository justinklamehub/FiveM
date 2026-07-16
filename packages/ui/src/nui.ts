/** FiveM NUI transport with correlated asynchronous server responses and browser mocks. */
import { isNuiMessage } from '@cnr/contracts';

export const isBrowserMock = (): boolean => typeof window.GetParentResourceName !== 'function';

const bridgedEvents = new Set([
  'registrationStatus',
  'registrationRuleset',
  'registrationSubmit',
  'characters.configuration',
  'characters.list',
  'characters.createDraft',
  'characters.activate',
]);
const responseTimeoutMs = 10_000;

interface NuiAcknowledgement {
  ok: boolean;
  queued?: boolean;
  request_id?: string;
}

async function invokeNuiCallback(event: string, body: unknown): Promise<unknown> {
  const resource = window.GetParentResourceName?.() ?? 'cnr_ui';
  const response = await fetch(`https://${resource}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body),
  });
  if (!response.ok) throw new Error(`NUI callback failed with HTTP ${String(response.status)}`);
  return response.json();
}

export async function postNui<TResponse>(event: string, body: unknown): Promise<TResponse> {
  if (isBrowserMock()) return browserMock(event, body) as TResponse;
  if (!bridgedEvents.has(event)) return (await invokeNuiCallback(event, body)) as TResponse;

  const requestId = (body as { request_id?: unknown } | null)?.request_id;
  if (typeof requestId !== 'string' || requestId === '') {
    throw new Error('A request ID is required for a bridged NUI request.');
  }

  let resolveResponse: (result: TResponse) => void = () => undefined;
  const responsePromise = new Promise<TResponse>((resolve) => {
    resolveResponse = resolve;
  });
  const listener = (message: MessageEvent<unknown>) => {
    if (!isNuiMessage(message.data) || message.data.type !== 'ui.request.response') return;
    if (message.data.payload.event === event && message.data.payload.request_id === requestId) {
      resolveResponse(message.data.payload.result as TResponse);
    }
  };
  window.addEventListener('message', listener);
  let timeout: ReturnType<typeof setTimeout> | undefined;

  try {
    const acknowledgement = (await invokeNuiCallback(event, body)) as NuiAcknowledgement;
    if (
      !acknowledgement.ok ||
      acknowledgement.queued !== true ||
      acknowledgement.request_id !== requestId
    ) {
      throw new Error('The NUI request was not queued.');
    }
    const timeoutPromise = new Promise<never>((_, reject) => {
      timeout = setTimeout(
        () => reject(new Error('The NUI server response timed out.')),
        responseTimeoutMs,
      );
    });
    return await Promise.race([responsePromise, timeoutPromise]);
  } finally {
    if (timeout) clearTimeout(timeout);
    window.removeEventListener('message', listener);
  }
}

const mockRuleset = {
  ruleset_uuid: '0190b7a0-0000-7000-8000-000000000001',
  version: 1,
  locale: 'en',
  content: 'Treat others respectfully. Cheating, exploits, and harassment are prohibited.',
  published_at: '2026-07-16T00:00:00Z',
};
function browserMock(event: string, body: unknown): unknown {
  const request = body as { locale?: 'de' | 'en'; operation_uuid?: string };
  if (event === 'registrationRuleset')
    return {
      ok: true,
      data: { ...mockRuleset, locale: 'en' },
      correlation_id: 'mock-ruleset',
    };
  if (event === 'registrationStatus')
    return {
      ok: true,
      data: {
        registered: false,
        account_status: 'PENDING_REGISTRATION',
        access_state: 'ONBOARDING',
        ruleset_uuid: mockRuleset.ruleset_uuid,
        ruleset_version: 1,
      },
      correlation_id: 'mock-status',
    };
  if (event === 'registrationSubmit')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        account_status: 'ACTIVE',
        access_state: 'FULL',
      },
      correlation_id: 'mock-submit',
    };
  if (event === 'characters.configuration')
    return {
      ok: true,
      data: {
        slot_limit: 3,
        minimum_age: 18,
        maximum_age: 85,
        backgrounds: [
          {
            code: 'local',
            label: 'San Andreas Local',
            description: 'Born and raised in San Andreas.',
          },
        ],
      },
      correlation_id: 'mock-character-config',
    };
  if (event === 'characters.list')
    return {
      ok: true,
      data: { slot_limit: 3, characters: [] },
      correlation_id: 'mock-character-list',
    };
  if (event === 'characters.createDraft')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        character: {
          character_uuid: '0190b7a0-2000-7000-8000-000000000001',
          slot_number: 1,
          status: 'DRAFT',
          first_name: 'Alex',
          last_name: 'Morgan',
          date_of_birth: '1995-05-20',
          background_code: 'local',
        },
      },
      correlation_id: 'mock-character-draft',
    };
  if (event === 'characters.activate')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        character: {
          character_uuid: '0190b7a0-2000-7000-8000-000000000001',
          slot_number: 1,
          status: 'ACTIVE',
          first_name: 'Alex',
          last_name: 'Morgan',
          date_of_birth: '1995-05-20',
          background_code: 'local',
        },
      },
      correlation_id: 'mock-character-activate',
    };
  return { ok: true };
}

declare global {
  interface Window {
    GetParentResourceName?: () => string;
  }
}
