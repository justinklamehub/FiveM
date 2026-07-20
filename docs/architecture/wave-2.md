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
- idempotent, atomic empty-slot moves and occupied-slot swaps through direct drag/drop;
- one server-created `PERSONAL_STORAGE` locker per character with configurable slots and weight;
- a proximity-gated two-panel locker workspace with atomic cross-inventory drag/drop;
- replayable, server-validated destination slots and transfer modes for confirmed in-place UI updates;
- partial stack quantities selected after a direct cross-inventory drop;
- stable server-owned image keys, reviewed transparent starter-item PNGs, and deterministic UI fallbacks for unknown keys or failed loads;
- server-derived one-unit food and drink consumption with client animations;
- non-consumable State ID inspection and nearest-player presentation with server distance checks;
- browser mocks, contracts, MariaDB tests, Lua policy tests, and audit events;
- one server-created cash wallet and personal checking account per spawned character;
- exactly-once starter funding from a controlled system source through an atomic three-entry ledger;
- balances calculated from immutable signed entries rather than client-owned or directly mutable fields;
- one unique, non-tradeable, character-bound City Tablet with idempotent provisioning;
- a reusable English Tablet shell with Banking as its first enabled app;
- a read-only Banking app with account balances and recent posted activity.

Player transfers, deposits, withdrawals, cards, persistent hunger/thirst attributes, reservations, backpacks, shared/faction storage, vehicles, ground drops, equipment, and gameplay rewards remain later Wave 2 slices.

## Ownership boundaries

`cnr_items` owns definition state. Codes, labels, descriptions, image keys, weights, stack limits, flags, handlers, and metadata schema versions are server data and are never accepted from a client.

`cnr_inventory` owns inventories, inventory entries, item instances, and transaction history. It resolves the active FULL session and spawned character from the FiveM source through `cnr_sessions` and `cnr_characters`.

Cross-resource references use canonical UUIDs. Inventory tables retain the stable character UUID instead of importing the character module's internal relational ID.

## Item artwork boundary

Item definitions expose only a stable `icon_key`. The browser resolves known keys through a packaged allowlist and never interprets a client-supplied URL or filesystem path. The initial 256×256 RGBA pack covers Water Bottle, Sandwich, State Identification Card, and City Tablet in one navy-and-gold visual language. Missing assets degrade to deterministic text initials without blocking inventory use.

## Client contract

The personal-locker workspace and item actions use inventory contract version 5.

A snapshot request contains only:

- `request_id`;
- `contract_version`.

A transfer request may additionally contain only:

- source and target inventory UUIDs previously returned by the server;
- source and destination slots as drag/drop intent;
- positive integer quantity;
- `operation_uuid`.

An item-action request may contain only the server-presented character inventory UUID, source slot, one `USE`, `INSPECT`, or `SHOW` intent, request ID, operation UUID, and contract version. The server resolves the item definition handler, consumed quantity, effect, document fields, and nearest presentation target. The client cannot provide any of those results.

The client cannot submit account, session, character, definition, item instance, metadata, weight, capacity, inventory version, distance, transfer mode, effect, consumed quantity, document content, presentation target, or result state. Both same-inventory and cross-inventory requests may express source and destination slots as user intent. The server resolves the entries, validates ownership, compatibility, capacity, and versions, then chooses move, swap, stack, create-stack, or unique-instance semantics. The storage workspace is returned only while the server-observed player ped is within the configured locker radius, and every storage reposition or transfer repeats that proximity check.

## Starter provisioning

After the controlled spawn acknowledgement, `cnr_characters` emits a local server event. `cnr_inventory` independently resolves the source authority and provisions:

- two Water Bottles;
- two Sandwiches;
- the character's existing State Identification Card as one referenced unique item.

A generated unique key permits only one `PROVISION_STARTER` transaction per character. Snapshot reads repeat the same check, allowing recovery after a missed event or resource restart without duplication.

The server separately provisions one unique City Tablet in the first free character slot. A generated character key permits only one `PROVISION_TABLET` transaction even for existing characters that already received their starter package. The Tablet instance is character-bound, non-tradeable, and non-droppable. Its server-resolved `OPEN_TABLET` action is replayable and does not consume the item or change inventory version.

## Atomic transfers

Transfers lock source and target inventories and their entries in deterministic order. A guarded transaction checks ownership, inventory versions, source entry version and quantity, target slot/stack state, stack limit, and target weight before applying any debit or credit. Constraint or guard failure rolls back the complete transaction.

Repeating the same operation UUID and semantic payload returns the stored result. Reusing it with changed content, action, account, or character returns `CONFLICT`.

Personal repositioning uses the same rule. Empty destinations move the source entry; occupied destinations swap the locked entries through a transaction-local temporary slot. The browser never mutates its snapshot optimistically; it applies only the confirmed server outcome to the open view.

The first personal locker is created idempotently from server configuration. Cross-inventory transfers are restricted to one `CHARACTER` and one `PERSONAL_STORAGE` inventory owned by the active character. The transaction stores the requested and validated source/destination slots, target entry, quantity, server-selected mode, and both result versions. The NUI applies those details only after server confirmation, so successful moves do not require a second snapshot while retries remain idempotent.

## Item actions

Water and food definitions publish only `USE` capability. Their private server handlers resolve to a one-unit debit and a server-issued drink or eat effect. State ID definitions publish `INSPECT` and `SHOW`; the unique item remains in inventory. Inspection presents the source-bound identity locally. Presentation selects the nearest player inside the configured radius from server-observed entity coordinates and sends only the holder name, date of birth, document number, and issue date. The Tablet publishes only `USE`; its private handler produces `OPEN_TABLET` only for the unique instance. After server confirmation, every item action closes the inventory. Consumables release NUI focus, inspection transfers focus to a compact left-docked State ID card, and Tablet use transfers focus to the reusable device shell. Every successful action is an immutable `USE_ITEM` transaction, and failed proximity or authority checks leave the inventory open and disclose nothing.

## Audit and recovery

Starter provisioning and completed transfers include request/correlation context and stable object references. Logs exclude platform identifiers, secrets, item-instance metadata, and document contents.

Both resources publish readiness. Inventory mutations fail closed if the catalogue, character authority, session authority, core, or database is unavailable.

## Banking foundation

`cnr_banking` is the only resource allowed to create financial accounts or ledger entries. It resolves
the FULL session and spawned character from the active FiveM source. The client snapshot contains only
a request ID and contract version.

The first controlled spawn creates one `CASH_WALLET` and one `PERSONAL_CHECKING` account and posts a
single `STARTER_ALLOCATION`. Its entries debit the `SYSTEM_SOURCE` by the complete amount and credit
the wallet and checking account by their configured shares. The transaction and account uniqueness
constraints make recovery safe after reconnects, concurrent reads, or resource restarts. Every balance
shown in the Tablet Banking app is calculated as the sum of signed immutable entries. There is no
direct Banking key binding. This slice exposes no payment or
transfer mutation to the client.

## Branch strategy

This slice is developed on `agent/wave-2-economic-foundations`, stacked on `agent/wave-1-player-lifecycle`. It must not be folded into Draft PR #2, and existing Draft PRs must not be merged or closed without explicit approval.
