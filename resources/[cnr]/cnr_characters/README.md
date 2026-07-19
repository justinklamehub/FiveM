# cnr_characters

## Responsibility

Owns configurable account slots, character drafts, roleplay identity, activation, base-document issuance, session-bound selection, persistent appearance, and controlled spawn state.

## Security boundary

The active FiveM source resolves the account and session. The server allocates the first free slot, validates identity and appearance rules, generates UUIDs and document numbers, binds one owned ACTIVE character, chooses the routing bucket and spawn location, and validates the spawn acknowledgement token.

## Non-responsibility

Does not create money, inventory, roleplay jobs, property spawn choices, clothing catalogs, deletion, or character switching. The client executes appearance preview and spawn natives but owns no authoritative state.

## Public exports

- `get_status`
- `lifecycle_snapshot(player_source, correlation_id)` for server-side orchestration; it derives only a lifecycle phase from the source-owned FULL session and never accepts account, session, character, or spawn authority from a client.
- `active_character_for_source(player_source, correlation_id)` for trusted server resources; it returns only the source-bound spawned character, active binding, and State ID references.

## Local events

- `cnr:characters:spawned` is emitted after a valid server-issued spawn acknowledgement. Consumers must still resolve their own source authority and treat repeated delivery as idempotent.

## Owned tables

- `cnr_character_settings`
- `cnr_character_backgrounds`
- `cnr_characters`
- `cnr_character_identities`
- `cnr_document_types`
- `cnr_character_documents`
- `cnr_character_operations`
- `cnr_character_session_bindings`
- `cnr_character_appearances`
- `cnr_character_appearance_operations`
- `cnr_character_locations`
