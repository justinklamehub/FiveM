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

  it('opens onboarding only after the browser NUI reports readiness through Lua', () => {
    const app = fs.readFileSync('packages/ui/src/App.tsx', 'utf8');
    const client = fs.readFileSync('resources/[cnr]/cnr_ui/client/main.lua', 'utf8');
    const server = fs.readFileSync('resources/[cnr]/cnr_ui/server/main.lua', 'utf8');
    expect(app).toContain("postNui<{ ok: boolean }>('uiReady', {})");
    expect(client).toContain("RegisterNUICallback('uiReady'");
    expect(client).toContain("TriggerServerEvent('cnr:ui:ready')");
    expect(client).not.toContain("AddEventHandler('onClientResourceStart'");
    expect(server).toContain("RegisterNetEvent('cnr:ui:ready'");
    expect(server).toContain('exports.cnr_sessions:get_session_for_source(player_source)');
    expect(server).toContain(
      "TriggerClientEvent('cnr:ui:open', player_source, 'registration', 'en')",
    );
    expect(server).toContain('ready_sources[player_source]');
  });

  it('provides a registration-only client command for manual NUI smoke testing', () => {
    const client = fs.readFileSync('resources/[cnr]/cnr_ui/client/main.lua', 'utf8');
    expect(client).toContain("RegisterCommand('cnr_registration_open'");
    expect(client).toContain("TriggerEvent('cnr:ui:open', 'registration', 'en')");
    expect(client).not.toContain("RegisterCommand('cnr_character");
  });

  it('fails closed before authority and keeps appearance preview separate from the player ped', () => {
    const client = fs.readFileSync('resources/[cnr]/cnr_ui/client/main.lua', 'utf8');
    expect(client).toContain('local lifecycle_locked = true');
    expect(client).toContain("lifecycle_phase = 'AWAITING_AUTHORITY'");
    expect(client).toContain('preview_ped = CreatePed(');
    expect(client).toContain('ensure_preview_ped(payload)');
    expect(client).toContain('DisableAllControlActions(0)');
    expect(client).toContain('exports.spawnmanager:setAutoSpawn(false)');
    expect(client).toContain("AddEventHandler('playerSpawned'");
    expect(client).not.toContain(
      'SetEntityCoordsNoOffset(ped, 402.92, -996.72, -99.0, false, false, false)',
    );
  });

  it('warns when the stock gamemode conflicts with CNR spawn authority', () => {
    const server = fs.readFileSync('resources/[cnr]/cnr_ui/server/main.lua', 'utf8');
    const configuration = fs.readFileSync('server/server.cfg.example', 'utf8');
    expect(server).toContain("GetResourceState('basic-gamemode') == 'started'");
    expect(server).toContain('Remove it from the CNR txAdmin recipe');
    expect(configuration).not.toMatch(/^ensure basic-gamemode$/m);
    expect(configuration).toContain('CNR owns every pre-game and controlled spawn transition');
  });

  it('acknowledges NUI callbacks before forwarding correlated server results', () => {
    const client = fs.readFileSync('resources/[cnr]/cnr_ui/client/main.lua', 'utf8');
    const transport = fs.readFileSync('packages/ui/src/nui.ts', 'utf8');
    expect(client).toContain('callback({ ok = true, queued = true, request_id = request_id })');
    expect(client).toContain("type = 'ui.request.response'");
    expect(client).not.toContain('pending_registration[request_id] = callback');
    expect(transport).toContain("message.data.type !== 'ui.request.response'");
    expect(transport).toContain('responseTimeoutMs = 10_000');
  });
});
