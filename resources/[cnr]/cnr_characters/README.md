# cnr_characters

## Responsibility

Owns configurable account slots, character drafts, roleplay identity, activation, and base-document issuance.

## Security boundary

The active FiveM source resolves the account and session. The server allocates the first free slot, validates identity rules, generates UUIDs and document numbers, and controls every status transition.

## Non-responsibility

Does not select a character, bind a character to a session, spawn a player, create money or inventory, define appearance, or provide deletion and switching.

## Owned tables

- `cnr_character_settings`
- `cnr_character_backgrounds`
- `cnr_characters`
- `cnr_character_identities`
- `cnr_document_types`
- `cnr_character_documents`
- `cnr_character_operations`
