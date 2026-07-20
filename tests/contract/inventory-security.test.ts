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
const uiClient = fs.readFileSync('resources/[cnr]/cnr_ui/client/main.lua', 'utf8');
const uiApp = fs.readFileSync('packages/ui/src/App.tsx', 'utf8');
const identification = fs.readFileSync('packages/ui/src/StateIdentificationCard.tsx', 'utf8');

describe('inventory security boundary', () => {
  it('accepts destination-slot intent without accepting inventory authority', () => {
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
      'weight_capacity',
    ]) {
      expect(allowedSection).not.toContain(`${forbidden} = true`);
    }
    expect(allowedSection).toContain('target_slot = true');
    expect(service).toContain('target_slot = validated.target_slot');
  });

  it('keeps same-inventory reposition intent equally narrow', () => {
    const repositionStart = policy.indexOf('function Policy.validate_reposition');
    const repositionSection = policy.slice(
      policy.indexOf('inventory_uuid = true', repositionStart),
      policy.indexOf('})', policy.indexOf('inventory_uuid = true', repositionStart)),
    );
    expect(repositionSection).toContain('target_slot = true');
    for (const forbidden of [
      'account_uuid',
      'session_uuid',
      'character_uuid',
      'entry_uuid',
      'definition_uuid',
      'item_instance_uuid',
      'inventory_version',
    ]) {
      expect(repositionSection).not.toContain(`${forbidden} = true`);
    }
    expect(service).toContain('Repository.find_owned(context.character_uuid');
  });

  it('accepts item intent without accepting effect, quantity, identity, or target authority', () => {
    const useStart = policy.indexOf('function Policy.validate_use');
    const useSection = policy.slice(
      policy.indexOf('inventory_uuid = true', useStart),
      policy.indexOf('})', policy.indexOf('inventory_uuid = true', useStart)),
    );
    expect(useSection).toContain('intent = true');
    for (const forbidden of [
      'account_uuid',
      'session_uuid',
      'character_uuid',
      'definition_uuid',
      'item_instance_uuid',
      'quantity',
      'effect',
      'target_source',
      'document_number',
    ]) {
      expect(useSection).not.toContain(`${forbidden} = true`);
    }
    expect(service).toContain('Policy.use_plan(source_entry, validated.intent)');
    expect(service).toContain("inventory.inventory_type ~= 'CHARACTER'");
    expect(repository).toContain("d.use_handler=? AND d.status='ACTIVE'");
  });

  it('resolves FULL session and spawned character authority from the FiveM source', () => {
    expect(service).toContain('get_session_for_source(player_source)');
    expect(service).toContain('active_character_for_source');
    expect(service).toContain("session.access_state ~= 'FULL'");
  });

  it('gates the personal locker and every cross-inventory transfer by server position', () => {
    expect(service).toContain('GetPlayerPed(player_source)');
    expect(service).toContain('GetEntityCoords(ped)');
    expect(service).toContain('Policy.within_access_radius');
    expect(service).toContain('Policy.is_personal_storage_pair');
    expect(policy).toContain("source_type == 'CHARACTER'");
    expect(policy).toContain("target_type == 'PERSONAL_STORAGE'");
    expect(main).toContain("action == 'workspace'");
  });

  it('locks inventories and entries before guarded atomic transfer mutations', () => {
    expect(repository).toContain('ORDER BY id FOR UPDATE');
    expect(repository).toContain('cnr_item_transactions');
    expect(repository).toContain('payload_sha256');
    expect(repository).toContain('result_source_version');
    expect(repository).toContain(
      'ON DUPLICATE KEY UPDATE public_uuid=cnr_inventory_items.public_uuid',
    );
    expect(repository).toContain("'REPOSITION'");
    expect(repository).toContain('temporary_slot');
    expect(repository).toContain('transfer_mode');
    expect(repository).toContain('context.plan.target_slot');
    expect(repository).toContain("'USE_ITEM'");
    expect(repository).toContain('context.plan.quantity_consumed');
  });

  it('fails closed and recovers when source-authority dependencies restart', () => {
    expect(main).toContain("GetResourceState(dependency) ~= 'started'");
    expect(main).toContain("stopped == 'cnr_sessions'");
    expect(main).toContain("stopped == 'cnr_characters'");
    expect(main).toContain("stopped == 'cnr_items'");
    expect(main).toContain("if status.status ~= 'ready' then");
  });

  it('closes inventory after confirmed item actions without stealing inspected-ID focus', () => {
    expect(uiApp).toContain('onItemAction={completeInventoryItemAction}');
    expect(uiApp).toContain("postNui<{ ok: boolean }>('inventory.actionComplete', { effect })");
    expect(uiClient).toContain("RegisterNUICallback('inventory.actionComplete'");
    expect(uiClient).toContain(
      "effect ~= 'INSPECT_STATE_ID' or focus_owner ~= 'inventoryDocument'",
    );
    expect(uiClient).toContain(
      "document_previous_focus = presentation.mode == 'PRESENTED' and focus_owner or nil",
    );
    expect(identification).toContain('identity-card__edge');
    expect(identification).toContain('Department of Motor Vehicles');
  });
});
