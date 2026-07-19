# cnr_inventory

## Responsibility

Owns personal character inventories and lockers, inventory entries, unique item instances, idempotency records, starter-item provisioning, atomic slot repositioning, and inventory-to-inventory transfers.

## Security boundary

Every client request resolves the active FULL session and spawned character from the FiveM source. The client cannot provide account, session, character, item definition, item instance, metadata, weight, capacity, inventory version, position, transfer mode, or result state. Cross-inventory and same-inventory operations accept source and destination slots only as user intent. The server exposes a character-owned locker only within its configured radius, repeats that check for every locker mutation, restricts transfers to the owned `CHARACTER`/`PERSONAL_STORAGE` pair, and validates the destination entry before choosing the atomic operation mode.

## Non-responsibility

Does not implement item use effects, equipment, backpacks, vehicles, ground drops, shared/faction storage access, reservations, cargo lots, banking, or gameplay rewards.

## Public network interface

The snapshot, locker workspace, reposition, and transfer payloads use inventory contract version `4`.

- `cnr:inventory:request` with `snapshot`, `workspace`, `reposition`, or `transfer`
- `cnr:inventory:response`

## Public server exports

- `get_status`
- `snapshot_for_source(player_source, request_id, correlation_id)`
- `workspace_for_source(player_source, request_id, correlation_id)`
- `transfer_for_source(player_source, payload, correlation_id)`

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

## Starter package

Exactly one package is provisioned per character: two Water Bottles, two Sandwiches, and the existing State Identification Card as a referenced unique item.

## Recovery

Snapshot reads also run the same idempotent provisioning check, so a missed spawn event or resource restart cannot duplicate or permanently omit the starter package. Locker creation uses the owner/type uniqueness constraint and is safe to repeat. Repositioning locks the selected inventory and all entries before applying a guarded empty-slot move or occupied-slot swap. Transfers lock both inventories and their entries in deterministic order and persist replayable placement details.
