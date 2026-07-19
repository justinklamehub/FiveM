import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const manifest = fs.readFileSync('resources/[cnr]/cnr_ui/fxmanifest.lua', 'utf8');
const client = fs.readFileSync('resources/[cnr]/cnr_ui/client/main.lua', 'utf8');
const server = fs.readFileSync('resources/[cnr]/cnr_ui/server/main.lua', 'utf8');
const app = fs.readFileSync('packages/ui/src/App.tsx', 'utf8');

describe('Wave 1 loadscreen and lifecycle orchestration', () => {
  it('declares a packaged manual-shutdown loadscreen beside the interactive NUI', () => {
    expect(manifest).toContain("ui_page('web/dist/index.html')");
    expect(manifest).toContain("loadscreen('web/dist/loadscreen.html')");
    expect(manifest).toContain("loadscreen_manual_shutdown('yes')");
    expect(manifest).toContain("'web/dist/loadscreen.html'");
  });

  it('hands the loadscreen off only after a server-derived lifecycle snapshot', () => {
    expect(client).toContain('SendLoadingScreenMessage(json.encode({');
    expect(client).toContain("RegisterNetEvent('cnr:ui:lifecycle'");
    expect(client).toContain("type = 'ui.lifecycle.open'");
    expect(client).toContain('shutdown_loadscreen()');
    expect(client.indexOf("type = 'ui.lifecycle.open'")).toBeLessThan(
      client.indexOf('shutdown_loadscreen()', client.indexOf("type = 'ui.lifecycle.open'")),
    );
  });

  it('derives access and character phases from source-owned server state', () => {
    expect(server).toContain('exports.cnr_sessions:get_session_for_source(player_source)');
    expect(server).toContain('CNR_UI_LIFECYCLE_CONTRACT.phase_for_access(session.access_state)');
    expect(server).toContain('exports.cnr_characters:lifecycle_snapshot');
    expect(server).toContain("snapshot('RECOVERABLE_ERROR', true, correlation_id)");
    expect(server).not.toContain('payload.account_uuid');
    expect(server).not.toContain('payload.session_uuid');
    expect(server).not.toContain('payload.character_uuid');
  });

  it('supports bounded refresh recovery and keeps locked lifecycle views unclosable', () => {
    expect(client).toContain("RegisterNUICallback('lifecycleRefresh'");
    expect(client).toContain("TriggerServerEvent('cnr:ui:refresh')");
    expect(server).toContain("'ui:lifecycle:' .. tostring(player_source)");
    expect(server).toContain('6,');
    expect(server).toContain('10000,');
    expect(app).not.toContain('className="close-link"');
    expect(app).toContain('Access Review Pending');
    expect(app).toContain('Lifecycle Unavailable');
  });

  it('keeps every packaged document and visual route explicitly English', () => {
    const index = fs.readFileSync('packages/ui/index.html', 'utf8');
    const loadscreen = fs.readFileSync('packages/ui/loadscreen.html', 'utf8');
    expect(index).toContain('<html lang="en">');
    expect(loadscreen).toContain('<html lang="en">');
    expect(loadscreen).not.toMatch(/https?:\/\//);
  });
});
