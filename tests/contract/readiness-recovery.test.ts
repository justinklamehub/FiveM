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
    expect(sessions).toContain('callbacks.defer()');
  });

  it('keeps the required final deferral tick outside a protected call', () => {
    const sessions = fs.readFileSync('resources/[cnr]/cnr_sessions/server/main.lua', 'utf8');
    expect(sessions).not.toContain('pcall(handle_connection');
    expect(sessions).toContain('handle_connection(player_source, player_name, callbacks)');
    const safeDone = sessions.slice(
      sessions.indexOf('local function safe_done'),
      sessions.indexOf('local function reject'),
    );
    expect(safeDone).toContain('Wait(0)');
    expect(safeDone.indexOf('Wait(0)')).toBeLessThan(safeDone.indexOf('callbacks.done(reason)'));
  });

  it('captures FXServer deferral call references before asynchronous database exports yield', () => {
    const sessions = fs.readFileSync('resources/[cnr]/cnr_sessions/server/main.lua', 'utf8');
    expect(sessions).toContain('local callbacks = capture_deferrals(deferrals)');
    expect(sessions).toContain('defer = deferrals.defer');
    expect(sessions).toContain('update = deferrals.update');
    expect(sessions).toContain('done = deferrals.done');
    expect(sessions).toContain('callbacks.done(reason)');
    expect(sessions).not.toContain('safe_done(deferrals');
  });

  it('returns from playerConnecting before the deferred database workflow yields', () => {
    const sessions = fs.readFileSync('resources/[cnr]/cnr_sessions/server/main.lua', 'utf8');
    const handler = sessions.slice(
      sessions.indexOf("AddEventHandler('playerConnecting'"),
      sessions.indexOf("AddEventHandler('playerDropped'"),
    );
    expect(handler).toContain('callbacks.defer()');
    expect(handler).toContain('CreateThread(function()');
    expect(handler.indexOf('CreateThread(function()')).toBeLessThan(
      handler.indexOf('handle_connection(player_source, player_name, callbacks)'),
    );
    expect(handler).not.toContain('already_deferred');
  });
});
