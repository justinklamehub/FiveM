import { describe, expect, it } from 'vitest';
import { translate } from './i18n';

describe('localization', () => {
  it('provides German and English shell text', () => {
    expect(translate('de', 'shell.close')).toBe('Schließen');
    expect(translate('en', 'shell.close')).toBe('Close');
  });
});
