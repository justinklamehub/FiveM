import { describe, expect, it } from 'vitest';
import { translate } from './i18n';

describe('localization', () => {
  it('keeps every visual locale in English', () => {
    expect(translate('de', 'shell.close')).toBe('Close');
    expect(translate('en', 'shell.close')).toBe('Close');
  });
});
