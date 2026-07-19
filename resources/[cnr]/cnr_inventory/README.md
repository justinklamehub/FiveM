# cnr_inventory

## Responsibility

Owns personal character inventories, inventory entries, unique item instances, idempotency records, starter-item provisioning, atomic slot repositioning, and inventory-to-inventory transfers.

## Security boundary

Every client request resolves the active FULL session and the spawned character from the FiveM source. The client cannot provide account, session, character, item definition, item instance, metadata, weight, capacity, inventory version, or result state. A cross-inventory transfer never accepts a target slot. Same-inventory repositioning accepts source and target slots as user intent, then locks and derives both entries from the source-owned inventory before choosing an atomic move or swap.

## Non-responsibility

Does not implement item use effects, equipment, backpacks, vehicles, ground drops, shared storage access, reservations, cargo lots, banking, or gameplay rewards.

## Public network interface

The snapshot, reposition, and transfer payloads use inventory contract version `2`.

- `cnr:inventory:request` with `snapshot`, `reposition`, or `transfer`
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

Snapshot reads also run the same idempotent provisioning check, so a missed spawn event or resource restart cannot duplicate or permanently omit the starter package. Repositioning locks the personal inventory and all entries before applying a guarded empty-slot move or occupied-slot swap. Transfers lock both inventories and their entries in deterministic order.
