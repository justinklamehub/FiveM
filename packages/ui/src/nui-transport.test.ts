import { afterEach, describe, expect, it, vi } from 'vitest';
import { postNui } from './nui';

const originalWindow = globalThis.window;

afterEach(() => {
  Object.defineProperty(globalThis, 'window', { value: originalWindow, configurable: true });
  vi.unstubAllGlobals();
});

describe('FiveM NUI transport', () => {
  it('acknowledges immediately and resolves only the correlated server response', async () => {
    const eventTarget = new EventTarget();
    const fakeWindow = Object.assign(eventTarget, {
      GetParentResourceName: () => 'cnr_ui',
    });
    Object.defineProperty(globalThis, 'window', { value: fakeWindow, configurable: true });
    vi.stubGlobal(
      'fetch',
      vi.fn(() =>
        Promise.resolve({
          ok: true,
          status: 200,
          json: () => Promise.resolve({ ok: true, queued: true, request_id: 'request-1' }),
        }),
      ),
    );

    const response = postNui<{ ok: boolean }>('registrationRuleset', {
      request_id: 'request-1',
    });
    fakeWindow.dispatchEvent(
      new MessageEvent('message', {
        data: {
          version: 1,
          type: 'ui.request.response',
          payload: {
            event: 'registrationRuleset',
            request_id: 'unrelated-request',
            result: { ok: false },
          },
        },
      }),
    );
    fakeWindow.dispatchEvent(
      new MessageEvent('message', {
        data: {
          version: 1,
          type: 'ui.request.response',
          payload: {
            event: 'registrationRuleset',
            request_id: 'request-1',
            result: { ok: true },
          },
        },
      }),
    );

    await expect(response).resolves.toEqual({ ok: true });
  });
});
