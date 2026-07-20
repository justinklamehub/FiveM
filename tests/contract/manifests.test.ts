import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

describe('FiveM manifest contract', () => {
  const resources = [
    'cnr_database',
    'cnr_logs',
    'cnr_locales',
    'cnr_config',
    'cnr_core',
    'cnr_ui',
    'cnr_accounts',
    'cnr_permissions',
    'cnr_whitelist',
    'cnr_sessions',
    'cnr_items',
    'cnr_inventory',
    'cnr_banking',
  ];
  it.each(resources)('%s uses the approved manifest runtime', (resource) => {
    const manifest = fs.readFileSync(`resources/[cnr]/${resource}/fxmanifest.lua`, 'utf8');
    expect(manifest).toMatch(/fx_version\s*\(?['"]cerulean['"]\)?/);
    expect(manifest).toMatch(/game\s*\(?['"]gta5['"]\)?/);
    expect(manifest).not.toMatch(/lua54\s*\(?['"]yes['"]\)?/);
  });

  it('does not expose server-only CNR dependencies to the client UI resolver', () => {
    const manifest = fs.readFileSync('resources/[cnr]/cnr_ui/fxmanifest.lua', 'utf8');
    for (const dependency of [
      'cnr_core',
      'cnr_logs',
      'cnr_locales',
      'cnr_config',
      'cnr_registration',
      'cnr_sessions',
      'cnr_characters',
      'cnr_banking',
    ]) {
      expect(manifest).not.toMatch(new RegExp(`['"]${dependency}['"]`));
    }
  });
});
