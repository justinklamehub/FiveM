import { describe, expect, it } from 'vitest';
import { playerLifecyclePhases } from '@cnr/contracts';
import { combinedLoadProgress, initialLoadscreenSnapshot } from './Loadscreen';
import { browserLifecycleSnapshot, lifecycleProgress, lifecycleViewForPhase } from './lifecycle';

describe('player lifecycle orchestration', () => {
  it('routes every server phase to one deterministic UI destination', () => {
    const views = new Map(
      playerLifecyclePhases.map((phase) => [phase, lifecycleViewForPhase(phase)]),
    );
    expect(views.get('REGISTRATION_REQUIRED')).toBe('registration');
    expect(views.get('ACCESS_PENDING')).toBe('accessPending');
    expect(views.get('CHARACTER_CREATION_REQUIRED')).toBe('characterLifecycle');
    expect(views.get('CHARACTER_SELECTION_REQUIRED')).toBe('characterLifecycle');
    expect(views.get('APPEARANCE_REQUIRED')).toBe('characterLifecycle');
    expect(views.get('SPAWN_PENDING')).toBe('characterLifecycle');
    expect(views.get('READY')).toBe('ready');
    expect(views.get('RECOVERABLE_ERROR')).toBe('error');
  });

  it('provides browser scenarios for every interactive lifecycle state', () => {
    expect(browserLifecycleSnapshot('?phase=registration').phase).toBe('REGISTRATION_REQUIRED');
    expect(browserLifecycleSnapshot('?phase=access').phase).toBe('ACCESS_PENDING');
    expect(browserLifecycleSnapshot('?phase=creation').phase).toBe('CHARACTER_CREATION_REQUIRED');
    expect(browserLifecycleSnapshot('?phase=selection').phase).toBe('CHARACTER_SELECTION_REQUIRED');
    expect(browserLifecycleSnapshot('?phase=appearance').phase).toBe('APPEARANCE_REQUIRED');
    expect(browserLifecycleSnapshot('?phase=spawn').phase).toBe('SPAWN_PENDING');
    expect(browserLifecycleSnapshot('?phase=error').phase).toBe('RECOVERABLE_ERROR');
    expect(browserLifecycleSnapshot('?phase=not-authoritative').phase).toBe(
      'REGISTRATION_REQUIRED',
    );
  });

  it('never lets resource progress move a server lifecycle phase backwards', () => {
    const snapshot = browserLifecycleSnapshot('?phase=spawn');
    expect(combinedLoadProgress(0.2, snapshot)).toBe(lifecycleProgress.SPAWN_PENDING);
    expect(combinedLoadProgress(2, snapshot)).toBe(lifecycleProgress.SPAWN_PENDING);
    expect(combinedLoadProgress(-1, browserLifecycleSnapshot('?phase=connecting'))).toBe(8);
  });

  it('keeps the production loadscreen in connection mode unless a browser scenario is explicit', () => {
    expect(initialLoadscreenSnapshot().phase).toBe('CONNECTING');
    expect(initialLoadscreenSnapshot('?phase=spawn').phase).toBe('SPAWN_PENDING');
  });
});
