/** FiveM NUI transport with a deterministic browser-development fallback. */
export const isBrowserMock = (): boolean => typeof window.GetParentResourceName !== 'function';

export async function postNui<TResponse>(event: string, body: unknown): Promise<TResponse> {
  if (isBrowserMock()) return browserMock(event, body) as TResponse;
  const resource = window.GetParentResourceName?.() ?? 'cnr_ui';
  const response = await fetch(`https://${resource}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body),
  });
  if (!response.ok) throw new Error(`NUI callback failed with HTTP ${String(response.status)}`);
  return (await response.json()) as TResponse;
}

const mockRuleset = {
  ruleset_uuid: '0190b7a0-0000-7000-8000-000000000001',
  version: 1,
  locale: 'de',
  content: 'Behandle andere respektvoll. Cheating, Exploits und Belästigung sind verboten.',
  published_at: '2026-07-16T00:00:00Z',
};
function browserMock(event: string, body: unknown): unknown {
  const request = body as { locale?: 'de' | 'en'; operation_uuid?: string };
  if (event === 'registrationRuleset')
    return {
      ok: true,
      data: { ...mockRuleset, locale: request.locale ?? 'de' },
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
  return { ok: true };
}

declare global {
  interface Window {
    GetParentResourceName?: () => string;
  }
}
