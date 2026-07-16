# cnr_core

## Responsibility
Owns readiness aggregation, standard results, stable errors, correlation IDs, request context, and rate-limit foundations.

## Non-responsibility
Does not own accounts, money, inventory, vehicles, jobs, properties, or crime.

## Dependencies
`/onesync`, `cnr_database`, `cnr_logs`, `cnr_locales`, `cnr_config`

## Public exports
`get_status`, `get_resource_status`, `get_all_resource_statuses`, `report_resource_status`, `is_ready`, `is_mutation_allowed`, `consume_rate_limit`, `create_request_context`, `create_correlation_id`, `create_success_result`, `create_error_result`, `get_error_codes`

## Events
`cnr:core:status_changed`, `cnr:core:resource_status_changed`

## Owned tables
None.

## Configuration
Readiness and maintenance settings through `cnr_config`.

## Error codes
Defines the stable Wave 0 technical error classes.

## Security boundary
Mutations must be blocked unless required dependencies are ready and maintenance mode is off.

## Lifecycle and recovery
Aggregates dependency status, degrades safely, and enters `stopping` on shutdown.

## Tests
Pure contracts are covered by Busted and Vitest; manifests are validated in CI.
