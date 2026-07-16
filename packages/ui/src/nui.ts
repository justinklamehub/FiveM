/** FiveM NUI transport with a deterministic browser-development fallback. */
export const isBrowserMock = (): boolean => typeof window.GetParentResourceName !== 'function';

export async function postNui<TResponse>(event: string, body: unknown): Promise<TResponse> {
  if (isBrowserMock()) return { ok: true } as TResponse;
  const resource = window.GetParentResourceName?.() ?? 'cnr_ui';
  const response = await fetch(`https://${resource}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body),
  });
  if (!response.ok) throw new Error(`NUI callback failed with HTTP ${String(response.status)}`);
  return (await response.json()) as TResponse;
}

declare global {
  interface Window {
    GetParentResourceName?: () => string;
  }
}
