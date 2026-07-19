/** Minimal localizable copy registry for the Wave 0 browser shell. */
export type Locale = 'de' | 'en';

const dictionaries = {
  de: {
    'shell.eyebrow': 'Technical foundation',
    'shell.title': "Cops'N'Robbers",
    'shell.description': 'The shared NUI shell is ready for future feature views.',
    'shell.browserMock': 'Browser mock active',
    'shell.fivem': 'FiveM NUI active',
    'shell.close': 'Close',
    'status.ready': 'Ready',
    'registration.eyebrow': 'City administration',
    'registration.title': 'Registration',
    'registration.description': 'Read the current ruleset and explicitly accept it.',
    'registration.version': 'Ruleset version',
    'registration.accept': 'I have read and accept the ruleset.',
    'registration.submit': 'Complete registration',
    'registration.loading': 'Loading ruleset …',
    'registration.submitting': 'Securely processing registration …',
    'registration.success': 'Registration saved successfully.',
    'registration.error': 'Registration could not be completed. Please try again.',
    'registration.loadError':
      'The ruleset could not be loaded. Check the server connection and try again.',
    'registration.retry': 'Retry',
  },
  en: {
    'shell.eyebrow': 'Technical foundation',
    'shell.title': "Cops'N'Robbers",
    'shell.description': 'The shared NUI shell is ready for future feature views.',
    'shell.browserMock': 'Browser mock active',
    'shell.fivem': 'FiveM NUI active',
    'shell.close': 'Close',
    'status.ready': 'Ready',
    'registration.eyebrow': 'City administration',
    'registration.title': 'Registration',
    'registration.description': 'Read the current ruleset and explicitly accept it.',
    'registration.version': 'Ruleset version',
    'registration.accept': 'I have read and accept the ruleset.',
    'registration.submit': 'Complete registration',
    'registration.loading': 'Loading ruleset …',
    'registration.submitting': 'Securely processing registration …',
    'registration.success': 'Registration saved successfully.',
    'registration.error': 'Registration could not be completed. Please try again.',
    'registration.loadError':
      'The ruleset could not be loaded. Check the server connection and try again.',
    'registration.retry': 'Retry',
  },
} as const;

type TranslationKey = keyof (typeof dictionaries)['de'];
export function translate(locale: Locale, key: TranslationKey): string {
  return dictionaries[locale][key];
}
