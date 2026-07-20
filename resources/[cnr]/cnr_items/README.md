# cnr_items

## Responsibility

Owns versioned item definitions and exposes normalized active catalogue reads to trusted server resources.

## Security boundary

Definitions, image keys, weights, stack limits, categories, trade/drop flags, handlers, and metadata schema versions come only from MariaDB. No client event can create or modify a definition. Image keys are stable logical references; packaged PNG assets will be added separately without accepting arbitrary client URLs.

## Non-responsibility

Does not own inventories, item locations, instances, transfers, reservations, ground drops, use effects, cargo lots, or money.

## Public exports

- `get_status`
- `list_active(correlation_id)`
- `get_active(code, correlation_id)`

## Owned tables

- `cnr_item_definitions`

## Configuration

The catalogue is migration-backed and currently includes the starter consumables, State ID, and unique City Tablet. Later configuration publishing must create a new version rather than silently changing live client authority.

## Recovery

The resource remains unavailable if the catalogue cannot be read or contains no active definitions. Inventory mutations fail closed while this dependency is unavailable.
