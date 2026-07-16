import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

describe('FiveM session source promotion', () => {
  it('promotes the temporary connection source to the final player NetID', () => {
    const main = fs.readFileSync('resources/[cnr]/cnr_sessions/server/main.lua', 'utf8');
    const repository = fs.readFileSync(
      'resources/[cnr]/cnr_sessions/server/repositories/session_repository.lua',
      'utf8',
    );

    expect(main).toContain("AddEventHandler('playerJoining', function(old_id)");
    expect(main).toContain('local temporary_source = normalize_source(old_id)');
    expect(main).toContain('SessionRepository.promote_source(');
    expect(main).toContain('source_sessions[temporary_source] = nil');
    expect(main).toContain('source_sessions[final_source] = session');
    expect(main).toContain('session.source = final_source');
    expect(repository).toContain('function SessionRepository.promote_source(');
    expect(repository).toContain('SET source_at_start = ?, last_seen_at = UTC_TIMESTAMP(6)');
    expect(repository).toContain('AND source_at_start = ?');
    expect(repository).toContain("AND status = 'ACTIVE'");
  });

  it('retries automatic UI opening while source promotion completes', () => {
    const server = fs.readFileSync('resources/[cnr]/cnr_ui/server/main.lua', 'utf8');
    expect(server).toContain('local function open_when_session_is_ready(player_source)');
    expect(server).toContain('for _ = 1, 50 do');
    expect(server).toContain("AddEventHandler('cnr:sessions:source_promoted'");
    expect(server).toContain('open_when_session_is_ready(session.source)');
  });
});
