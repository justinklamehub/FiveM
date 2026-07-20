# cnr_inventory

## Responsibility

Owns personal character inventories and lockers, inventory entries, unique item instances, idempotency records, starter-item provisioning, atomic slot repositioning, inventory-to-inventory transfers, consumable use, and State ID inspection/presentation.

## Security boundary

Every client request resolves the active FULL session and spawned character from the FiveM source. The client cannot provide account, session, character, item definition, item instance, metadata, weight, capacity, inventory version, position, transfer mode, or result state. Cross-inventory and same-inventory operations accept source and destination slots only as user intent. The server exposes a character-owned locker only within its configured radius, repeats that check for every locker mutation, restricts transfers to the owned `CHARACTER`/`PERSONAL_STORAGE` pair, and validates the destination entry before choosing the atomic operation mode.

## Non-responsibility

Does not implement persistent hunger/thirst attributes, equipment, backpacks, vehicles, ground drops, shared/faction storage access, reservations, cargo lots, banking, or gameplay rewards.

## Public network interface

Snapshot, locker workspace, reposition, transfer, and item-use payloads use inventory contract version `5`.

- `cnr:inventory:request` with `snapshot`, `workspace`, `reposition`, `transfer`, or `use`
- `cnr:inventory:response`

## Public server exports

- `get_status`
- `snapshot_for_source(player_source, request_id, correlation_id)`
- `workspace_for_source(player_source, request_id, correlation_id)`
- `transfer_for_source(player_source, payload, correlation_id)`
- `use_for_source(player_source, payload, correlation_id)`

## Local events

Consumes `cnr:characters:spawned` to provision the starter package. Repeated event delivery returns the existing transaction.

## Owned tables

- `cnr_item_instances`
- `cnr_inventories`
- `cnr_inventory_items`
- `cnr_item_transactions`

## Configuration

- `cnr_inventory_character_slots` defaults to `24`.
- `cnr_inventory_character_weight_grams` defaults to `30000`.
- `cnr_inventory_storage_slots` defaults to `48`.
- `cnr_inventory_storage_weight_grams` defaults to `100000`.
- `cnr_inventory_locker_x/y/z` default to the central parking spawn.
- `cnr_inventory_locker_radius` defaults to `4.0` metres.
- `cnr_inventory_document_show_radius` defaults to `3.0` metres.

## Starter package

Exactly one package is provisioned per character: two Water Bottles, two Sandwiches, and the existing State Identification Card as a referenced unique item.

Their server-owned image keys resolve to reviewed transparent PNGs in `cnr_ui`. The inventory service never accepts filenames or asset paths from a client, and definitions without packaged artwork use the UI's deterministic fallback.

## Recovery

Snapshot reads also run the same idempotent provisioning check, so a missed spawn event or resource restart cannot duplicate or permanently omit the starter package. Locker creation uses the owner/type uniqueness constraint and is safe to repeat. Repositioning locks the selected inventory and all entries before applying a guarded empty-slot move or occupied-slot swap. Transfers lock both inventories and their entries in deterministic order and persist replayable placement details. Cross-inventory stack drops may select a partial quantity, but the server still validates the exact available amount and applies only confirmed results. Item use locks the character inventory and source entry, resolves the definition handler server-side, consumes exactly one food or drink item, and stores the effect for replay. State ID inspection and presentation never consume the unique item; presentation resolves the nearest target from server-observed positions and exposes only bounded public document fields.
