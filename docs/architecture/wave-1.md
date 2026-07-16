# Wave 1 – Player lifecycle

Wave 1 implements the player lifecycle defined by the project README without adding economic or crime gameplay.

## Current implementation status

| Slice                               | Status                     | Evidence                                                                                                      |
| ----------------------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Connection foundation               | Implemented in draft PR #2 | Accounts, identifiers, whitelist evaluation, one active session, onboarding access state, migration and tests |
| Technical permissions               | Implemented in draft PR #2 | Database-driven roles and permissions, console-only owner bootstrap, audited mutations and tests              |
| Registration and account activation | Implemented in draft PR #2 | Versioned rules, idempotent source-bound activation, audit evidence, contracts and English NUI                |
| Character lifecycle                 | Implemented in draft PR #2 | Configurable slots, atomic drafts, validated identity, activation, base state ID and English NUI              |
| Selection, appearance and spawn     | Implemented in draft PR #2 | Owned-character selection, session binding, persistent appearance and token-confirmed controlled spawn        |
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
   - English registration NUI with typed request and result contracts
4. **Character lifecycle**
   - three configurable character slots
   - atomic draft creation and activation
   - identity and base document issuance
5. **Selection and spawn**
   - secure character selection
   - reconnect-safe session binding
   - server-authoritative spawn decision
   - persistent freemode appearance and isolated customization preview
   - server-issued spawn token and client acknowledgement before controls are released
6. **Loadscreen and complete NUI flow**
   - localized connection progress
   - registration and character views
   - browser mocks and typed message contracts

## Registration boundary

The account already exists before registration and remains `PENDING_REGISTRATION`. Registration does not create a second account and does not collect a roleplay identity.

The client may submit only the current ruleset reference, explicit acceptance, locale, request ID, operation UUID, contract version, and other fields explicitly approved by the registration contract. The server resolves source, session, account, current ruleset, whitelist decision, target account status, and resulting access state.

Repeated submission of the same operation UUID returns the existing result and cannot create a second acceptance or status transition. Submitting an outdated ruleset, a mismatched payload, an inactive session, or a non-onboarding account fails without changing state.

## Character lifecycle boundary

Character creation requires a server-resolved active FULL session and ACTIVE account. The server allocates the first free configurable slot, validates identity and age rules, and controls the `DRAFT` to `ACTIVE` transition. Draft creation and activation use separate idempotent operation UUIDs.

Activation issues one unique state identification card. An ACTIVE character can then be selected only through its source-owned FULL session. The binding is unique per session, its selection operation is idempotent, and stale bindings are ended during resource recovery.

The first selection requires a curated freemode appearance. The server validates and persists every appearance field, places the player in an isolated routing bucket during preview, and chooses either the last safe location or the configured central default. The client executes the server-issued spawn instruction and remains frozen until the matching spawn UUID is acknowledged. Clothing expansion, inventory, banking, deletion, switching, property spawn choices, jail, hospital, and tutorial priority remain later slices. All player-visible text is English.

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
- Registration, role changes, whitelist decisions, character creation, selection, appearance persistence, document issuance, and controlled spawn are auditable.
- Registration mutations require the current server ruleset and a server-resolved onboarding session.
- No economic, vehicle, job, oil, or crime gameplay is part of Wave 1.
