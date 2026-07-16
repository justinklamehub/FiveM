# Wave 1 – Player lifecycle

Wave 1 implements the player lifecycle defined by the project README without adding economic or crime gameplay.

## Current implementation status

| Slice                               | Status                     | Evidence                                                                                                      |
| ----------------------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Connection foundation               | Implemented in draft PR #2 | Accounts, identifiers, whitelist evaluation, one active session, onboarding access state, migration and tests |
| Technical permissions               | Implemented in draft PR #2 | Database-driven roles and permissions, console-only owner bootstrap, audited mutations and tests              |
| Registration and account activation | Next                       | Rule acceptance, idempotent server-authoritative registration, account transition and NUI                     |
| Character lifecycle                 | Pending                    | Three character slots, draft creation, identity and base documents                                            |
| Selection and spawn                 | Pending                    | Character selection, session binding and server-authoritative spawn                                           |
| Loadscreen and complete NUI flow    | Pending                    | Localized progress, registration and character views, browser mocks and typed contracts                       |

Automated CI is green for the implemented slices. A real FXServer connection and permission smoke test remains required before Wave 1 can be considered runtime-verified.

## Delivery slices

1. **Connection foundation**
   - validated FiveM identifiers
   - account lookup and initial `PENDING_REGISTRATION` state
   - whitelist decision
   - one active session per account
   - isolated `ONBOARDING` access state
2. **Permissions foundation**
   - database-driven technical roles and permissions
   - server-authoritative permission evaluation
   - audited grant and revoke operations
   - console-only owner bootstrap and recovery
   - no character job or business permissions
3. **Registration and account activation**
   - current versioned ruleset supplied by the server
   - explicit and auditable rule acceptance
   - one idempotent registration mutation per operation UUID
   - account status transition decided by the server and whitelist policy
   - session access refresh without trusting client-supplied account state
   - localized registration NUI with typed request and result contracts
4. **Character lifecycle**
   - three configurable character slots
   - atomic draft creation and activation
   - identity and base document issuance
5. **Selection and spawn**
   - secure character selection
   - reconnect-safe session binding
   - server-authoritative spawn decision
6. **Loadscreen and complete NUI flow**
   - localized connection progress
   - registration and character views
   - browser mocks and typed message contracts

## Registration boundary

The account already exists before registration and remains `PENDING_REGISTRATION`. Registration does not create a second account and does not collect a roleplay identity.

The client may submit only the current ruleset reference, explicit acceptance, locale, request ID, operation UUID, contract version, and other fields explicitly approved by the registration contract. The server resolves source, session, account, current ruleset, whitelist decision, target account status, and resulting access state.

Repeated submission of the same operation UUID returns the existing result and cannot create a second acceptance or status transition. Submitting an outdated ruleset, a mismatched payload, an inactive session, or a non-onboarding account fails without changing state.

## Technical permissions boundary

Technical roles belong to an account and control administrative server capabilities. Roleplay jobs, ranks, factions, and business employment will belong to characters or organizations in later waves. The two models must never share authoritative tables or permission checks.

Default technical roles and role-to-permission mappings are seeded by migration for a usable baseline. Runtime evaluation reads those mappings from MariaDB so a later control panel can change them without rebuilding the resource.

The protected `owner` role cannot be assigned through normal resource exports. It is bootstrapped and recovered only through source-zero FXServer console commands.

## Branch strategy

Wave 1 is developed on `agent/wave-1-player-lifecycle` as a stacked branch based on the verified Wave 0 branch. Draft PR #2 must remain based on `agent/wave-0-technical-foundation` until Wave 0 is merged or the stack is deliberately restacked.

The next coding chat continues the existing Wave 1 branch and draft PR. It must not create a parallel registration branch or duplicate the implemented account/session resources.

## Security boundaries

- The client never chooses an account, whitelist result, session identifier, account status, character ownership, role, permission, or spawn authority.
- FiveM sources are ephemeral and are never stored as durable identities.
- Only server-generated UUIDs and normalized identifiers cross repository boundaries.
- Duplicate active sessions and duplicate active technical role assignments are rejected by database constraints.
- Registration, role changes, whitelist decisions, character creation, and document issuance are auditable.
- Registration mutations require the current server ruleset and a server-resolved onboarding session.
- No economic, vehicle, job, oil, or crime gameplay is part of Wave 1.
