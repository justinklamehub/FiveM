import fs from 'node:fs';
import { describe, expect, it } from 'vitest';
const service = fs.readFileSync(
  'resources/[cnr]/cnr_characters/server/services/character_service.lua',
  'utf8',
);
const repository = fs.readFileSync(
  'resources/[cnr]/cnr_characters/server/repositories/character_repository.lua',
  'utf8',
);
const policy = fs.readFileSync(
  'resources/[cnr]/cnr_characters/shared/character_policy.lua',
  'utf8',
);
const main = fs.readFileSync('resources/[cnr]/cnr_characters/server/main.lua', 'utf8');
describe('character security boundary', () => {
  it('resolves account and active session from source and requires full access', () => {
    expect(service).toContain('get_session_for_source(player_source)');
    expect(service).toContain("session.account_status ~= 'ACTIVE'");
    expect(service).toContain("session.access_state ~= 'FULL'");
    expect(repository).toContain("s.status='ACTIVE'");
  });
  it('scopes every character lookup to the server-resolved account', () => {
    expect(repository).toContain("WHERE c.account_id=? AND c.public_uuid=UNHEX(REPLACE(?,'-',''))");
  });
  it('rejects client authority fields and compares semantic operation hashes', () => {
    expect(policy).not.toContain('account_uuid = true');
    expect(policy).not.toContain('slot_number = true');
    expect(service).toContain('operation.payload_sha256 ~= hash.payload_sha256');
  });
  it('binds selection to the resolved full session and issues server spawn tokens', () => {
    expect(service).toContain('function Service.select_character');
    expect(service).toContain("character.status ~= 'ACTIVE'");
    expect(service).toContain('Repository.binding_for_session(session.session_id)');
    expect(service).toContain('SetPlayerRoutingBucket(player_source');
    expect(service).toContain('binding.spawn_uuid ~= validated.spawn_uuid');
    expect(policy).not.toContain('spawn_x = true');
    expect(policy).not.toContain('session_uuid = true');
  });
  it('persists only validated appearance fields for the selected character', () => {
    expect(service).toContain('Policy.validate_appearance(payload)');
    expect(service).toContain('character_id = binding.character_id');
    expect(repository).toContain('cnr_character_appearance_operations');
    expect(policy).not.toContain('character_uuid = true,\n        model');
  });
  it('uses the shared core rate-limit export at runtime', () => {
    expect(main).toContain('exports.cnr_core:consume_rate_limit');
    expect(main).not.toContain("require('shared.rate_limiter')");
  });
  it('binds every activation operation value to the matching SQL column', () => {
    expect(repository).toContain(
      "VALUES (UNHEX(REPLACE(?,'-','')),?,?,?,'ACTIVATE',?,?,?,UNHEX(?),'ACTIVE'",
    );
    expect(repository).not.toContain(
      "VALUES (UNHEX(REPLACE(?,'-','')),?,?,?,?,'ACTIVATE',?,?,?,UNHEX(?),'ACTIVE'",
    );
  });
});
