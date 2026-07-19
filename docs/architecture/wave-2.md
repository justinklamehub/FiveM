# Wave 2 – Economic foundations

Wave 2 builds the persistent economic primitives required by later gameplay without adding jobs, rewards, vehicles, properties, crime, or a mutable client-owned economy.

## Current slice

The first slice implements:

- migration-backed, versioned item definitions in `cnr_items`;
- one personal `CHARACTER` inventory per spawned character;
- slots and weight capacity enforced by server policy;
- stackable entries and referenced unique item instances;
- exactly-once starter provisioning after controlled spawn;
- atomic, operation-UUID-backed transfers between inventories owned by the source-bound character;
- an English dynamic personal-inventory slot grid opened with F2;
- idempotent, atomic empty-slot moves and occupied-slot swaps through drag/drop or accessible selection;
- stable server-owned image keys with deterministic UI fallbacks for a later PNG asset pack;
- browser mocks, contracts, MariaDB tests, Lua policy tests, and audit events.

Banking, reservations, use effects, backpacks, shared storage, vehicles, ground drops, equipment, and gameplay rewards remain later Wave 2 slices.

## Ownership boundaries

`cnr_items` owns definition state. Codes, labels, descriptions, image keys, weights, stack limits, flags, handlers, and metadata schema versions are server data and are never accepted from a client.

`cnr_inventory` owns inventories, inventory entries, item instances, and transaction history. It resolves the active FULL session and spawned character from the FiveM source through `cnr_sessions` and `cnr_characters`.

Cross-resource references use canonical UUIDs. Inventory tables retain the stable character UUID instead of importing the character module's internal relational ID.

## Client contract

The interactive slot slice uses inventory contract version 2.

A snapshot request contains only:

- `request_id`;
- `contract_version`.

A transfer request may additionally contain only:

- source and target inventory UUIDs previously returned by the server;
- source slot;
- positive integer quantity;
- `operation_uuid`.

The client cannot submit account, session, character, definition, item instance, metadata, weight, capacity, inventory version, distance, or result state. Cross-inventory transfers do not accept a target slot. A same-inventory reposition request may express source and target slots as user intent; the server resolves both entries, validates capacity and versions, and chooses move or swap semantics. The transfer contract remains reserved for later server-presented secondary inventories.

## Starter provisioning

After the controlled spawn acknowledgement, `cnr_characters` emits a local server event. `cnr_inventory` independently resolves the source authority and provisions:

- two Water Bottles;
- two Sandwiches;
- the character's existing State Identification Card as one referenced unique item.

A generated unique key permits only one `PROVISION_STARTER` transaction per character. Snapshot reads repeat the same check, allowing recovery after a missed event or resource restart without duplication.

## Atomic transfers

Transfers lock source and target inventories and their entries in deterministic order. A guarded transaction checks ownership, inventory versions, source entry version and quantity, target slot/stack state, stack limit, and target weight before applying any debit or credit. Constraint or guard failure rolls back the complete transaction.

Repeating the same operation UUID and semantic payload returns the stored result. Reusing it with changed content, action, account, or character returns `CONFLICT`.

Personal repositioning uses the same rule. Empty destinations move the source entry; occupied destinations swap the locked entries through a transaction-local temporary slot. The browser never mutates its snapshot optimistically and reloads the server result after completion.

## Audit and recovery

Starter provisioning and completed transfers include request/correlation context and stable object references. Logs exclude platform identifiers, secrets, item-instance metadata, and document contents.

Both resources publish readiness. Inventory mutations fail closed if the catalogue, character authority, session authority, core, or database is unavailable.

## Branch strategy

This slice is developed on `agent/wave-2-economic-foundations`, stacked on `agent/wave-1-player-lifecycle`. It must not be folded into Draft PR #2, and existing Draft PRs must not be merged or closed without explicit approval.
