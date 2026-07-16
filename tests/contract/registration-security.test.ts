import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const service = fs.readFileSync(
  'resources/[cnr]/cnr_registration/server/services/registration_service.lua',
  'utf8',
);
const repository = fs.readFileSync(
  'resources/[cnr]/cnr_registration/server/repositories/registration_repository.lua',
  'utf8',
);

describe('registration security boundary', () => {
  it('binds both memory and database session state to the active FiveM source', () => {
    expect(service).toContain('get_session_for_source(player_source)');
    expect(service).toContain(
      'session_for_source(exports.cnr_core:get_server_instance_id(), player_source)',
    );
    expect(repository).toContain("s.status = 'ACTIVE'");
  });
  it('requires pending registration and onboarding on both service and transaction paths', () => {
    expect(service).toContain("session.account_status ~= 'PENDING_REGISTRATION'");
    expect(service).toContain("session.access_state ~= 'ONBOARDING'");
    expect(repository).toContain("account_row.status = 'PENDING_REGISTRATION'");
    expect(repository).toContain("session_row.access_state = 'ONBOARDING'");
  });
  it('compares the stored semantic payload hash before returning a repeated result', () => {
    expect(service).toContain('previous.payload_sha256 ~= hash.payload_sha256');
    expect(service).toContain("failure('CONFLICT', 'registration.error.operation_conflict'");
  });
});
