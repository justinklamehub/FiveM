/** Minimal localizable copy registry for the Wave 0 browser shell. */
export type Locale = 'de' | 'en';

const dictionaries = {
  de: {
    'shell.eyebrow': 'Technische Basis',
    'shell.title': "Cops'N'Robbers",
    'shell.description': 'Die gemeinsame NUI-Shell ist bereit für spätere Fachansichten.',
    'shell.browserMock': 'Browser-Mock aktiv',
    'shell.fivem': 'FiveM-NUI aktiv',
    'shell.close': 'Schließen',
    'status.ready': 'Bereit',
  },
  en: {
    'shell.eyebrow': 'Technical foundation',
    'shell.title': "Cops'N'Robbers",
    'shell.description': 'The shared NUI shell is ready for future feature views.',
    'shell.browserMock': 'Browser mock active',
    'shell.fivem': 'FiveM NUI active',
    'shell.close': 'Close',
    'status.ready': 'Ready',
  },
} as const;

type TranslationKey = keyof (typeof dictionaries)['de'];
export function translate(locale: Locale, key: TranslationKey): string {
  return dictionaries[locale][key];
}
