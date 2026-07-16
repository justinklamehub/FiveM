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
   - technical account roles and permissions
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

## Branch strategy

Wave 1 is developed as a stacked branch based on the verified Wave 0 branch. The Wave 0 pull request remains independently reviewable and unchanged.

## Security boundaries

- The client never chooses an account, whitelist result, session identifier, character ownership, role, or spawn authority.
- FiveM sources are ephemeral and are never stored as durable identities.
- Only server-generated UUIDs and normalized identifiers cross repository boundaries.
- Duplicate active sessions are rejected or recovered through a documented server-side policy.
- Registration, role changes, whitelist decisions, character creation, and document issuance are auditable.
- No economic, vehicle, job, oil, or crime gameplay is part of Wave 1.
