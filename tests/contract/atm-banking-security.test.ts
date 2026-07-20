import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const policy = fs.readFileSync('resources/[cnr]/cnr_banking/shared/banking_policy.lua', 'utf8');
const service = fs.readFileSync(
  'resources/[cnr]/cnr_banking/server/services/banking_service.lua',
  'utf8',
);
const repository = fs.readFileSync(
  'resources/[cnr]/cnr_banking/server/repositories/banking_repository.lua',
  'utf8',
);
const main = fs.readFileSync('resources/[cnr]/cnr_banking/server/main.lua', 'utf8');

describe('ATM authority boundary', () => {
  it('limits the client cash intent to terminal, direction, amount, and idempotency fields', () => {
    expect(policy).toContain('function Policy.validate_atm_cash(payload)');
    expect(policy).toContain("payload.direction ~= 'DEPOSIT'");
    expect(policy).toContain("payload.direction ~= 'WITHDRAW'");
    expect(service).not.toMatch(/payload\.(account|session|character|balance|currency)/);
  });

  it('uses server-observed coordinates and rechecks the persisted ATM radius', () => {
    expect(service).toContain('GetPlayerPed(player_source)');
    expect(service).toContain('GetEntityCoords(ped)');
    expect(service).toContain('Policy.within_atm_radius(coordinates, atm)');
    expect(repository).toContain("FROM cnr_atms WHERE public_uuid=UNHEX(REPLACE(?,'-',''))");
  });

  it('protects dynamic terminal commands with a technical permission', () => {
    expect(service).toContain("'banking.atms.manage'");
    expect(main).toContain("RegisterCommand('cnr_atm_create'");
    expect(main).toContain("RegisterCommand('cnr_atm_remove'");
    expect(main).toContain("RegisterCommand('cnr_atm_list'");
    expect(service).toContain('GetEntityHeading(ped)');
  });

  it('posts both ledger entries atomically behind account version and operation guards', () => {
    expect(repository).toContain('function Repository.post_atm_transaction(context)');
    expect(repository).toContain('account_row.last_operation_uuid=UNHEX(REPLACE');
    expect(repository).toContain('{ -context.amount_minor, context.operation_uuid }');
    expect(repository).toContain('{ context.amount_minor, context.operation_uuid }');
    expect(repository).toContain('SELECT NULL,NULL,0,0,UTC_TIMESTAMP(6)');
  });
});
