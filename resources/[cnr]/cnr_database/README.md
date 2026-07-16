# cnr_database

## Responsibility
Owns the database driver boundary and schema readiness.

## Non-responsibility
Does not run migrations or own gameplay tables.

## Dependencies
`/onesync`, `oxmysql`

## Public exports
`get_status`, `query`, `single`, `transaction`

## Events
`cnr:database:status_changed`

## Owned tables
None in Wave 0.

## Configuration
`cnr_schema_minimum`

## Error codes
Uses the stable Wave 0 result/error contract.

## Security boundary
Rejects calls while unavailable; accepts only server-authored SQL from repository modules.

## Lifecycle and recovery
Starts as `starting`, becomes `ready` only after connectivity and schema checks, and enters `stopping` on shutdown. It never runs DDL at startup.

## Tests
Manifest contracts and migration checks run in CI; pure contracts are covered separately.
