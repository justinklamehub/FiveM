# cnr_config

## Responsibility
Provides immutable static technical configuration and maintenance state.

## Non-responsibility
Does not implement the later dynamic publish workflow.

## Dependencies
`/onesync`, `cnr_logs`, `cnr_locales`

## Public exports
`get_status`, `get`, `is_maintenance_mode`

## Events and tables
No public events or owned tables.

## Configuration
`cnr_maintenance_mode` and safe defaults in `config/defaults.lua`.

## Error codes
Uses the stable Wave 0 result/error contract where applicable.

## Security boundary
Exports deep copies so consumers cannot mutate shared configuration.

## Lifecycle and recovery
Starts ready after static configuration loads and enters `stopping` on shutdown.

## Tests
Manifest and configuration contracts are checked by repository tests.
