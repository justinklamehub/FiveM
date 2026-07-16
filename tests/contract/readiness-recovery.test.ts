import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const resources = [
  'cnr_accounts',
  'cnr_permissions',
  'cnr_whitelist',
  'cnr_sessions',
  'cnr_registration',
  'cnr_characters',
  'cnr_ui',
];

describe('runtime readiness recovery', () => {
  it.each(resources)('%s retries core readiness instead of permanently degrading', (resource) => {
    const main = fs.readFileSync(`resources/[cnr]/${resource}/server/main.lua`, 'utf8');
    expect(main).toContain('for _ = 1, 300 do');
    expect(main).toContain("reason = 'core_readiness_timeout'");
  });

  it('refreshes core readiness when the asynchronous database status changes', () => {
    const core = fs.readFileSync('resources/[cnr]/cnr_core/server/main.lua', 'utf8');
    expect(core).toContain("AddEventHandler('cnr:database:status_changed'");
    expect(core).toContain('refresh_dependencies()');
  });

  it('holds connection deferrals while session dependencies are still starting', () => {
    const sessions = fs.readFileSync('resources/[cnr]/cnr_sessions/server/main.lua', 'utf8');
    expect(sessions).toContain('Session services are starting. Please wait…');
    expect(sessions).toContain('deferrals.defer()');
  });

  it('keeps the required final deferral tick outside a protected call', () => {
    const sessions = fs.readFileSync('resources/[cnr]/cnr_sessions/server/main.lua', 'utf8');
    expect(sessions).not.toContain('pcall(handle_connection');
    expect(sessions).toContain('handle_connection(player_source, player_name, deferrals)');
    const safeDone = sessions.slice(
      sessions.indexOf('local function safe_done'),
      sessions.indexOf('local function reject'),
    );
    expect(safeDone).toContain('Wait(0)');
    expect(safeDone.indexOf('Wait(0)')).toBeLessThan(safeDone.indexOf('deferrals.done(reason)'));
    expect(safeDone).toContain('deferrals.done()');
    expect(safeDone).not.toContain('deferrals.done(reason or nil)');
  });

  it('retains the documented deferrals object instead of capturing method references', () => {
    const sessions = fs.readFileSync('resources/[cnr]/cnr_sessions/server/main.lua', 'utf8');
    expect(sessions).not.toContain('capture_deferrals');
    expect(sessions).not.toContain('local callbacks');
    expect(sessions).toContain('deferrals.done(reason)');
    expect(sessions).toContain('safe_done(deferrals, state)');
  });
});
