# Wave 1 – Player lifecycle

Wave 1 implements the player lifecycle defined by the project README without adding economic or crime gameplay.

## Delivery slices

1. **Connection foundation**
   - validated FiveM identifiers
   - account lookup and registration state
   - whitelist decision
   - one active session per account
   - isolated onboarding state
2. **Permissions foundation**
   - database-driven technical roles and permissions
   - server-authoritative permission evaluation
   - audited grant and revoke operations
   - console-only owner bootstrap and recovery
   - no character job or business permissions
3. **Character lifecycle**
   - three configurable character slots
   - atomic draft creation and activation
   - identity and base document issuance
4. **Selection and spawn**
   - secure character selection
   - reconnect-safe session binding
   - server-authoritative spawn decision
5. **Loadscreen and NUI flow**
   - localized connection progress
   - registration and character views
   - browser mocks and typed message contracts

## Technical permissions boundary

Technical roles belong to an account and control administrative server capabilities. Roleplay jobs, ranks, factions, and business employment will belong to characters or organizations in later waves. The two models must never share authoritative tables or permission checks.

Default technical roles and role-to-permission mappings are seeded by migration for a usable baseline. Runtime evaluation reads those mappings from MariaDB so a later control panel can change them without rebuilding the resource.

The protected `owner` role cannot be assigned through normal resource exports. It is bootstrapped and recovered only through source-zero FXServer console commands.

## Branch strategy

Wave 1 is developed as a stacked branch based on the verified Wave 0 branch. The Wave 0 pull request remains independently reviewable and unchanged.

## Security boundaries

- The client never chooses an account, whitelist result, session identifier, character ownership, role, permission, or spawn authority.
- FiveM sources are ephemeral and are never stored as durable identities.
- Only server-generated UUIDs and normalized identifiers cross repository boundaries.
- Duplicate active sessions and duplicate active technical role assignments are rejected by database constraints.
- Registration, role changes, whitelist decisions, character creation, and document issuance are auditable.
- No economic, vehicle, job, oil, or crime gameplay is part of Wave 1.
