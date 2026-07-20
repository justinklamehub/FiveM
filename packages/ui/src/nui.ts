/** FiveM NUI transport with correlated asynchronous server responses and browser mocks. */
import { isNuiMessage } from '@cnr/contracts';
import { browserLifecycleSnapshot, currentBrowserSearch } from './lifecycle';

export const isBrowserMock = (): boolean => typeof window.GetParentResourceName !== 'function';

const bridgedEvents = new Set([
  'registrationStatus',
  'registrationRuleset',
  'registrationSubmit',
  'characters.configuration',
  'characters.list',
  'characters.createDraft',
  'characters.activate',
  'characters.selectionStatus',
  'characters.select',
  'characters.appearanceConfiguration',
  'characters.appearanceSave',
  'inventory.snapshot',
  'inventory.workspace',
  'inventory.reposition',
  'inventory.transfer',
  'inventory.use',
  'banking.snapshot',
]);
const responseTimeoutMs = 10_000;

interface NuiAcknowledgement {
  ok: boolean;
  queued?: boolean;
  request_id?: string;
}

async function invokeNuiCallback(event: string, body: unknown): Promise<unknown> {
  const resource = window.GetParentResourceName?.() ?? 'cnr_ui';
  const response = await fetch(`https://${resource}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(body),
  });
  if (!response.ok) throw new Error(`NUI callback failed with HTTP ${String(response.status)}`);
  return response.json();
}

export async function postNui<TResponse>(event: string, body: unknown): Promise<TResponse> {
  if (isBrowserMock()) return browserMock(event, body) as TResponse;
  if (!bridgedEvents.has(event)) return (await invokeNuiCallback(event, body)) as TResponse;

  const requestId = (body as { request_id?: unknown } | null)?.request_id;
  if (typeof requestId !== 'string' || requestId === '') {
    throw new Error('A request ID is required for a bridged NUI request.');
  }

  let resolveResponse: (result: TResponse) => void = () => undefined;
  const responsePromise = new Promise<TResponse>((resolve) => {
    resolveResponse = resolve;
  });
  const listener = (message: MessageEvent<unknown>) => {
    if (!isNuiMessage(message.data) || message.data.type !== 'ui.request.response') return;
    if (message.data.payload.event === event && message.data.payload.request_id === requestId) {
      resolveResponse(message.data.payload.result as TResponse);
    }
  };
  window.addEventListener('message', listener);
  let timeout: ReturnType<typeof setTimeout> | undefined;

  try {
    const acknowledgement = (await invokeNuiCallback(event, body)) as NuiAcknowledgement;
    if (
      !acknowledgement.ok ||
      acknowledgement.queued !== true ||
      acknowledgement.request_id !== requestId
    ) {
      throw new Error('The NUI request was not queued.');
    }
    const timeoutPromise = new Promise<never>((_, reject) => {
      timeout = setTimeout(
        () => reject(new Error('The NUI server response timed out.')),
        responseTimeoutMs,
      );
    });
    return await Promise.race([responsePromise, timeoutPromise]);
  } finally {
    if (timeout) clearTimeout(timeout);
    window.removeEventListener('message', listener);
  }
}

const mockRuleset = {
  ruleset_uuid: '0190b7a0-0000-7000-8000-000000000001',
  version: 1,
  locale: 'en',
  content: 'Treat others respectfully. Cheating, exploits, and harassment are prohibited.',
  published_at: '2026-07-16T00:00:00Z',
};
const mockInventorySlots = new Map([
  ['water_bottle', 1],
  ['sandwich', 2],
  ['state_id', 3],
]);
let mockInventoryVersion = 2;
function browserMock(event: string, body: unknown): unknown {
  const request = body as {
    locale?: 'de' | 'en';
    operation_uuid?: string;
    source_inventory_uuid?: string;
    target_inventory_uuid?: string;
    source_slot?: number;
    target_slot?: number;
    quantity?: number;
    intent?: 'USE' | 'INSPECT' | 'SHOW';
  };
  const lifecycle = browserLifecycleSnapshot(currentBrowserSearch());
  if (event === 'lifecycleRefresh') return { ok: true };
  if (event === 'registrationRuleset')
    return {
      ok: true,
      data: { ...mockRuleset, locale: 'en' },
      correlation_id: 'mock-ruleset',
    };
  if (event === 'banking.snapshot')
    return {
      ok: true,
      data: {
        currency: 'USD',
        starter_provisioned: true,
        repeated: true,
        accounts: [
          {
            account_uuid: '0190b7a0-7000-7000-8000-000000000010',
            account_number: 'CASH-800000000010',
            account_type: 'CASH_WALLET',
            currency: 'USD',
            status: 'ACTIVE',
            balance_minor: 5000,
            version: 1,
          },
          {
            account_uuid: '0190b7a0-7000-7000-8000-000000000011',
            account_number: 'SA-800000000011',
            account_type: 'PERSONAL_CHECKING',
            currency: 'USD',
            status: 'ACTIVE',
            balance_minor: 25000,
            version: 1,
          },
        ],
        recent_transactions: [
          {
            transaction_uuid: '0190b7a0-7000-7000-8000-000000000020',
            transaction_number: 'TX-0190B7A0700070008000000000000020',
            transaction_type: 'STARTER_ALLOCATION',
            status: 'POSTED',
            amount_minor: 30000,
            currency: 'USD',
            purpose: 'Initial character funds',
            posted_at: '2026-07-20T12:00:00Z',
          },
        ],
      },
      correlation_id: 'mock-banking',
    };
  if (event === 'inventory.snapshot')
    return {
      ok: true,
      data: {
        inventory_uuid: '0190b7a0-6000-7000-8000-000000000010',
        inventory_type: 'CHARACTER',
        slot_capacity: 24,
        weight_capacity_grams: 30000,
        current_weight_grams: 1520,
        version: mockInventoryVersion,
        starter_provisioned: true,
        entries: [
          {
            entry_uuid: '0190b7a0-6000-7000-8000-000000000011',
            slot_number: mockInventorySlots.get('water_bottle') ?? 1,
            quantity: 2,
            definition: {
              definition_uuid: '0190b7a0-6000-7000-8000-000000000001',
              code: 'water_bottle',
              category: 'CONSUMABLE',
              label: 'Water Bottle',
              description: 'A sealed bottle of drinking water.',
              icon_key: 'water_bottle',
              is_stackable: true,
              is_unique: false,
              max_stack: 10,
              unit_weight_grams: 500,
              version: 1,
              actions: ['USE'],
            },
            total_weight_grams: 1000,
          },
          {
            entry_uuid: '0190b7a0-6000-7000-8000-000000000012',
            slot_number: mockInventorySlots.get('sandwich') ?? 2,
            quantity: 2,
            definition: {
              definition_uuid: '0190b7a0-6000-7000-8000-000000000002',
              code: 'sandwich',
              category: 'CONSUMABLE',
              label: 'Sandwich',
              description: 'A simple wrapped sandwich.',
              icon_key: 'sandwich',
              is_stackable: true,
              is_unique: false,
              max_stack: 10,
              unit_weight_grams: 250,
              version: 1,
              actions: ['USE'],
            },
            total_weight_grams: 500,
          },
          {
            entry_uuid: '0190b7a0-6000-7000-8000-000000000013',
            slot_number: mockInventorySlots.get('state_id') ?? 3,
            quantity: 1,
            definition: {
              definition_uuid: '0190b7a0-6000-7000-8000-000000000003',
              code: 'state_id',
              category: 'DOCUMENT',
              label: 'State Identification Card',
              description: "The holder's official state identification card.",
              icon_key: 'state_id',
              is_stackable: false,
              is_unique: true,
              max_stack: 1,
              unit_weight_grams: 20,
              version: 1,
              actions: ['INSPECT', 'SHOW'],
            },
            total_weight_grams: 20,
          },
        ],
      },
      correlation_id: 'mock-inventory',
    };
  if (event === 'inventory.workspace') {
    const character = browserMock('inventory.snapshot', body) as {
      ok: true;
      data: Record<string, unknown>;
    };
    return {
      ok: true,
      data: {
        character: character.data,
        storage: {
          inventory_uuid: '0190b7a0-6000-7000-8000-000000000020',
          inventory_type: 'PERSONAL_STORAGE',
          slot_capacity: 48,
          weight_capacity_grams: 100000,
          current_weight_grams: 0,
          version: 1,
          starter_provisioned: false,
          entries: [],
        },
        access_label: 'Personal Locker',
      },
      correlation_id: 'mock-inventory-workspace',
    };
  }
  if (event === 'inventory.reposition') {
    const source = [...mockInventorySlots.entries()].find(
      ([, slot]) => slot === request.source_slot,
    );
    const target = [...mockInventorySlots.entries()].find(
      ([, slot]) => slot === request.target_slot,
    );
    if (!source || typeof request.target_slot !== 'number')
      return {
        ok: false,
        error: {
          code: 'PRECONDITION_FAILED',
          message_key: 'inventory.error.reposition_rejected',
          safe_details: {},
          correlation_id: 'mock-inventory-reposition-error',
        },
      };
    mockInventorySlots.set(source[0], request.target_slot);
    if (target && typeof request.source_slot === 'number')
      mockInventorySlots.set(target[0], request.source_slot);
    mockInventoryVersion += 1;
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        inventory_version: mockInventoryVersion,
        source_slot: request.source_slot,
        target_slot: request.target_slot,
        mode: target ? 'SWAP' : 'MOVE',
      },
      correlation_id: 'mock-inventory-reposition',
    };
  }
  if (event === 'inventory.transfer') {
    if (
      typeof request.source_inventory_uuid !== 'string' ||
      typeof request.target_inventory_uuid !== 'string' ||
      typeof request.source_slot !== 'number' ||
      typeof request.target_slot !== 'number' ||
      typeof request.quantity !== 'number'
    )
      return {
        ok: false,
        error: {
          code: 'VALIDATION_ERROR',
          message_key: 'inventory.error.invalid_request',
          safe_details: {},
          correlation_id: 'mock-inventory-transfer-error',
        },
      };
    mockInventoryVersion += 1;
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        source_inventory_uuid: request.source_inventory_uuid,
        target_inventory_uuid: request.target_inventory_uuid,
        source_slot: request.source_slot,
        target_slot: request.target_slot,
        target_entry_uuid: request.operation_uuid,
        quantity: request.quantity,
        mode: 'CREATE_STACK',
        source_version: mockInventoryVersion,
        target_version: 2,
      },
      correlation_id: 'mock-inventory-transfer',
    };
  }
  if (event === 'inventory.use') {
    if (
      typeof request.source_slot !== 'number' ||
      typeof request.intent !== 'string' ||
      typeof request.operation_uuid !== 'string'
    )
      return {
        ok: false,
        error: {
          code: 'VALIDATION_ERROR',
          message_key: 'inventory.error.invalid_request',
          safe_details: {},
          correlation_id: 'mock-inventory-use-error',
        },
      };
    const effect =
      request.intent === 'INSPECT'
        ? 'INSPECT_STATE_ID'
        : request.intent === 'SHOW'
          ? 'SHOW_STATE_ID'
          : request.source_slot === (mockInventorySlots.get('water_bottle') ?? 1)
            ? 'DRINK_WATER'
            : 'EAT_FOOD';
    const consumed = request.intent === 'USE' ? 1 : 0;
    mockInventoryVersion += consumed;
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        inventory_uuid: '0190b7a0-6000-7000-8000-000000000010',
        source_slot: request.source_slot,
        quantity_consumed: consumed,
        inventory_version: mockInventoryVersion,
        effect,
      },
      correlation_id: 'mock-inventory-use',
    };
  }
  if (event === 'registrationStatus')
    return {
      ok: true,
      data: {
        registered: false,
        account_status: 'PENDING_REGISTRATION',
        access_state: 'ONBOARDING',
        ruleset_uuid: mockRuleset.ruleset_uuid,
        ruleset_version: 1,
      },
      correlation_id: 'mock-status',
    };
  if (event === 'registrationSubmit')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        account_status: 'ACTIVE',
        access_state: 'FULL',
      },
      correlation_id: 'mock-submit',
    };
  if (event === 'characters.configuration')
    return {
      ok: true,
      data: {
        slot_limit: 3,
        minimum_age: 18,
        maximum_age: 85,
        backgrounds: [
          {
            code: 'local',
            label: 'San Andreas Local',
            description: 'Born and raised in San Andreas.',
          },
        ],
      },
      correlation_id: 'mock-character-config',
    };
  if (event === 'characters.list')
    return {
      ok: true,
      data: {
        slot_limit: 3,
        characters:
          lifecycle.phase === 'CHARACTER_CREATION_REQUIRED'
            ? []
            : [
                {
                  character_uuid: '0190b7a0-2000-7000-8000-000000000001',
                  slot_number: 1,
                  status: 'ACTIVE',
                  first_name: 'Alex',
                  last_name: 'Morgan',
                  date_of_birth: '1995-05-20',
                  background_code: 'local',
                },
              ],
      },
      correlation_id: 'mock-character-list',
    };
  if (event === 'characters.createDraft')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        character: {
          character_uuid: '0190b7a0-2000-7000-8000-000000000001',
          slot_number: 1,
          status: 'DRAFT',
          first_name: 'Alex',
          last_name: 'Morgan',
          date_of_birth: '1995-05-20',
          background_code: 'local',
        },
      },
      correlation_id: 'mock-character-draft',
    };
  if (event === 'characters.activate')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        character: {
          character_uuid: '0190b7a0-2000-7000-8000-000000000001',
          slot_number: 1,
          status: 'ACTIVE',
          first_name: 'Alex',
          last_name: 'Morgan',
          date_of_birth: '1995-05-20',
          background_code: 'local',
        },
      },
      correlation_id: 'mock-character-activate',
    };
  if (event === 'characters.selectionStatus')
    return {
      ok: true,
      data: {
        selected: lifecycle.phase === 'APPEARANCE_REQUIRED' || lifecycle.phase === 'SPAWN_PENDING',
        binding_uuid:
          lifecycle.phase === 'APPEARANCE_REQUIRED' || lifecycle.phase === 'SPAWN_PENDING'
            ? '0190b7a0-2100-7000-8000-000000000001'
            : null,
        character: null,
        next_state:
          lifecycle.phase === 'APPEARANCE_REQUIRED'
            ? 'APPEARANCE_REQUIRED'
            : lifecycle.phase === 'SPAWN_PENDING'
              ? 'SPAWN_PENDING'
              : null,
      },
      correlation_id: 'mock-character-selection-status',
    };
  if (event === 'characters.select')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        binding_uuid: '0190b7a0-2100-7000-8000-000000000001',
        character: {
          character_uuid: '0190b7a0-2000-7000-8000-000000000001',
          slot_number: 1,
          status: 'ACTIVE',
          first_name: 'Alex',
          last_name: 'Morgan',
          date_of_birth: '1995-05-20',
          background_code: 'local',
        },
        next_state: 'APPEARANCE_REQUIRED',
      },
      correlation_id: 'mock-character-select',
    };
  if (event === 'characters.appearanceConfiguration')
    return {
      ok: true,
      data: {
        models: ['mp_m_freemode_01', 'mp_f_freemode_01'],
        parent_minimum: 0,
        parent_maximum: 45,
        face_feature_count: 20,
        face_feature_minimum: -100,
        face_feature_maximum: 100,
        hair_style_maximum: 76,
        hair_texture_maximum: 10,
        hair_color_maximum: 63,
        eye_color_maximum: 31,
        outfit_codes: ['starter_casual'],
        defaults: {
          model: 'mp_m_freemode_01',
          shape_first: 0,
          shape_second: 21,
          shape_mix: 50,
          skin_mix: 50,
          face_features: Array.from({ length: 20 }, () => 0),
          hair_style: 0,
          hair_texture: 0,
          hair_color: 0,
          hair_highlight: 0,
          eye_color: 0,
          outfit_code: 'starter_casual',
        },
      },
      correlation_id: 'mock-appearance-configuration',
    };
  if (event === 'characters.appearanceSave')
    return {
      ok: true,
      data: {
        repeated: false,
        operation_uuid: request.operation_uuid,
        appearance_version: 1,
        next_state: 'SPAWN_PENDING',
      },
      correlation_id: 'mock-appearance-save',
    };
  return { ok: true };
}

declare global {
  interface Window {
    GetParentResourceName?: () => string;
  }
}
