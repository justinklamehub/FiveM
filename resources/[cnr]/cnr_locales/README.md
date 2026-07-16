# cnr_locales

## Responsibility
Provides server-side German translations with English fallback.

## Non-responsibility
Does not own NUI dictionaries or gameplay decisions.

## Dependencies
`/onesync`

## Public exports
`get_status`, `translate`

## Events and tables
No public events or owned tables.

## Configuration
Default locale: `de`.

## Error codes
Supplies localized message keys for the Wave 0 error contract.

## Security boundary
Unknown keys return the key and never expose internal details.

## Lifecycle and recovery
Starts ready with immutable dictionaries and enters `stopping` on shutdown.

## Tests
Manifest and localization contracts are checked by repository tests.
