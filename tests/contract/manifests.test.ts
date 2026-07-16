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
  ];
  it.each(resources)('%s uses the approved manifest runtime', (resource) => {
    const manifest = fs.readFileSync(`resources/[cnr]/${resource}/fxmanifest.lua`, 'utf8');
    expect(manifest).toMatch(/fx_version\s*\(?['"]cerulean['"]\)?/);
    expect(manifest).toMatch(/game\s*\(?['"]gta5['"]\)?/);
    expect(manifest).not.toMatch(/lua54\s*\(?['"]yes['"]\)?/);
  });
});
