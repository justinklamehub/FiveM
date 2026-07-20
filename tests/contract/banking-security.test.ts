import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const service = fs.readFileSync(
  'resources/[cnr]/cnr_banking/server/services/banking_service.lua',
  'utf8',
);
const repository = fs.readFileSync(
  'resources/[cnr]/cnr_banking/server/repositories/banking_repository.lua',
  'utf8',
);

describe('banking authority boundary', () => {
  it('derives session and active character from the FiveM source', () => {
    expect(service).toContain('exports.cnr_sessions:get_session_for_source(player_source)');
    expect(service).toContain('exports.cnr_characters:active_character_for_source');
    expect(service).toContain("session.access_state ~= 'FULL'");
  });

  it('posts one atomic system-source debit and two character credits', () => {
    expect(repository).toContain('return exports.cnr_database:transaction({');
    expect(repository).toContain("a.account_type='SYSTEM_SOURCE'");
    expect(repository).toContain("a.account_type='CASH_WALLET'");
    expect(repository).toContain("a.account_type='PERSONAL_CHECKING'");
    expect(repository).toContain('{ -total, context.operation_uuid }');
  });

  it('never accepts a client-supplied amount, account, owner, or operation UUID', () => {
    expect(service).toContain('Policy.validate_snapshot(payload)');
    expect(service).not.toMatch(/payload\.(amount|balance|account|character|session|operation)/);
  });
});
