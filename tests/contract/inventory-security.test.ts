import fs from 'node:fs';
import { describe, expect, it } from 'vitest';

const policy = fs.readFileSync('resources/[cnr]/cnr_inventory/shared/inventory_policy.lua', 'utf8');
const service = fs.readFileSync(
  'resources/[cnr]/cnr_inventory/server/services/inventory_service.lua',
  'utf8',
);
const repository = fs.readFileSync(
  'resources/[cnr]/cnr_inventory/server/repositories/inventory_repository.lua',
  'utf8',
);
const main = fs.readFileSync('resources/[cnr]/cnr_inventory/server/main.lua', 'utf8');

describe('inventory security boundary', () => {
  it('accepts no account, session, character, definition, instance, metadata, or target-slot authority', () => {
    const allowedSection = policy.slice(
      policy.indexOf('source_inventory_uuid = true'),
      policy.indexOf('})', policy.indexOf('source_inventory_uuid = true')),
    );
    for (const forbidden of [
      'account_uuid',
      'session_uuid',
      'character_uuid',
      'definition_uuid',
      'item_instance_uuid',
      'metadata',
      'target_slot',
      'weight_capacity',
    ]) {
      expect(allowedSection).not.toContain(`${forbidden} = true`);
    }
  });

  it('resolves FULL session and spawned character authority from the FiveM source', () => {
    expect(service).toContain('get_session_for_source(player_source)');
    expect(service).toContain('active_character_for_source');
    expect(service).toContain("session.access_state ~= 'FULL'");
  });

  it('locks inventories and entries before guarded atomic transfer mutations', () => {
    expect(repository).toContain('ORDER BY id FOR UPDATE');
    expect(repository).toContain('cnr_item_transactions');
    expect(repository).toContain('payload_sha256');
    expect(repository).toContain('result_source_version');
    expect(repository).toContain(
      'ON DUPLICATE KEY UPDATE public_uuid=cnr_inventory_items.public_uuid',
    );
  });

  it('fails closed and recovers when source-authority dependencies restart', () => {
    expect(main).toContain("GetResourceState(dependency) ~= 'started'");
    expect(main).toContain("stopped == 'cnr_sessions'");
    expect(main).toContain("stopped == 'cnr_characters'");
    expect(main).toContain("stopped == 'cnr_items'");
    expect(main).toContain("if status.status ~= 'ready' then");
  });
});
