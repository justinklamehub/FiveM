# cnr_logs

## Responsibility
Produces structured application logs and a separate audit channel.

## Non-responsibility
Does not decide gameplay outcomes or persist future audit records.

## Dependencies
`/onesync`

## Public exports
`get_status`, `log`, `audit`

## Events and tables
No public events or owned tables in Wave 0.

## Configuration
None.

## Error codes
Uses the stable Wave 0 result/error contract where applicable.

## Security boundary
Callers may pass only safe context; secrets and complete sensitive payloads are forbidden.

## Lifecycle and recovery
Publishes `ready` after initialization and `stopping` during shutdown.

## Tests
Manifest and lifecycle contracts are checked by repository tests.
