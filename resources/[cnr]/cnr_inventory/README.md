# cnr_inventory

## Responsibility

Owns personal character inventories, inventory entries, unique item instances, idempotency records, starter-item provisioning, and atomic inventory-to-inventory transfers.

## Security boundary

Every client request resolves the active FULL session and the spawned character from the FiveM source. The client cannot provide account, session, character, item definition, item instance, metadata, weight, capacity, target slot, inventory version, or result state. A transfer may reference only source/target inventory UUIDs returned by the server, a source slot, quantity, request ID, operation UUID, and contract version.

## Non-responsibility

Does not implement item use effects, equipment, backpacks, vehicles, ground drops, shared storage access, reservations, cargo lots, banking, or gameplay rewards.

## Public network interface

- `cnr:inventory:request` with `snapshot` or `transfer`
- `cnr:inventory:response`

## Public server exports

- `get_status`
- `snapshot_for_source(player_source, request_id, correlation_id)`
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

## Starter package

Exactly one package is provisioned per character: two Water Bottles, two Sandwiches, and the existing State Identification Card as a referenced unique item.

## Recovery

Snapshot reads also run the same idempotent provisioning check, so a missed spawn event or resource restart cannot duplicate or permanently omit the starter package. Transfers lock both inventories and their entries in deterministic order before applying the guarded transaction.
