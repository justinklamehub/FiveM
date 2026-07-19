/** Pure routing and browser-scenario helpers for the server-driven player lifecycle. */
import {
  playerLifecycleContractVersion,
  type PlayerLifecyclePhase,
  type PlayerLifecycleSnapshot,
} from '@cnr/contracts';

export type PlayerLifecycleView =
  'loading' | 'registration' | 'accessPending' | 'characterLifecycle' | 'ready' | 'error';

export function lifecycleViewForPhase(phase: PlayerLifecyclePhase): PlayerLifecycleView {
  if (phase === 'CONNECTING' || phase === 'SESSION_PENDING') return 'loading';
  if (phase === 'REGISTRATION_REQUIRED') return 'registration';
  if (phase === 'ACCESS_PENDING') return 'accessPending';
  if (phase === 'READY') return 'ready';
  if (phase === 'RECOVERABLE_ERROR') return 'error';
  return 'characterLifecycle';
}

const browserScenarios: Readonly<Record<string, PlayerLifecyclePhase>> = {
  connecting: 'CONNECTING',
  session: 'SESSION_PENDING',
  registration: 'REGISTRATION_REQUIRED',
  access: 'ACCESS_PENDING',
  creation: 'CHARACTER_CREATION_REQUIRED',
  selection: 'CHARACTER_SELECTION_REQUIRED',
  appearance: 'APPEARANCE_REQUIRED',
  spawn: 'SPAWN_PENDING',
  ready: 'READY',
  error: 'RECOVERABLE_ERROR',
};

export function browserLifecycleSnapshot(search = ''): PlayerLifecycleSnapshot {
  const scenario = new URLSearchParams(search).get('phase') ?? 'registration';
  const phase = browserScenarios[scenario] ?? 'REGISTRATION_REQUIRED';
  return {
    contract_version: playerLifecycleContractVersion,
    phase,
    retryable: phase === 'ACCESS_PENDING' || phase === 'RECOVERABLE_ERROR',
    correlation_id: `browser-${scenario}`,
  };
}

export function currentBrowserSearch(): string {
  const location = (window as unknown as { location?: { search?: unknown } }).location;
  return typeof location?.search === 'string' ? location.search : '';
}

export const lifecycleProgress: Readonly<Record<PlayerLifecyclePhase, number>> = {
  CONNECTING: 8,
  SESSION_PENDING: 76,
  REGISTRATION_REQUIRED: 82,
  ACCESS_PENDING: 82,
  CHARACTER_CREATION_REQUIRED: 87,
  CHARACTER_SELECTION_REQUIRED: 87,
  APPEARANCE_REQUIRED: 91,
  SPAWN_PENDING: 96,
  READY: 100,
  RECOVERABLE_ERROR: 82,
};

export const lifecycleCopy: Readonly<
  Record<PlayerLifecyclePhase, { eyebrow: string; title: string; description: string }>
> = {
  CONNECTING: {
    eyebrow: 'Secure connection',
    title: 'Connecting to the City',
    description: 'Downloading required resources and establishing a protected connection.',
  },
  SESSION_PENDING: {
    eyebrow: 'Session authority',
    title: 'Securing Your Session',
    description: 'The server is resolving your account and current access state.',
  },
  REGISTRATION_REQUIRED: {
    eyebrow: 'City administration',
    title: 'Preparing Registration',
    description: 'Your secure onboarding session is ready for ruleset acceptance.',
  },
  ACCESS_PENDING: {
    eyebrow: 'Access review',
    title: 'Checking City Access',
    description: 'Registration is complete while the current whitelist policy is evaluated.',
  },
  CHARACTER_CREATION_REQUIRED: {
    eyebrow: 'Character lifecycle',
    title: 'Preparing Character Creation',
    description: 'The server is loading character configuration for your active session.',
  },
  CHARACTER_SELECTION_REQUIRED: {
    eyebrow: 'Character lifecycle',
    title: 'Loading Your Characters',
    description: 'Only active characters owned by this secure session will be available.',
  },
  APPEARANCE_REQUIRED: {
    eyebrow: 'Identity studio',
    title: 'Preparing Appearance',
    description: 'The server is isolating your first-time customization preview.',
  },
  SPAWN_PENDING: {
    eyebrow: 'Controlled spawn',
    title: 'Preparing the City',
    description: 'The server is validating your character and authorized spawn instruction.',
  },
  READY: {
    eyebrow: 'Lifecycle complete',
    title: 'Entering the City',
    description: 'Your controlled spawn has been confirmed.',
  },
  RECOVERABLE_ERROR: {
    eyebrow: 'Connection recovery',
    title: 'Lifecycle Unavailable',
    description: 'The server could not resolve the next lifecycle step safely.',
  },
};
