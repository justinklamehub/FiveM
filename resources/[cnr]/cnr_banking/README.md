# cnr_banking

`cnr_banking` is the sole authority for character money balances and financial movements.

The initial Wave 2 slice creates one cash wallet and one personal checking account for every
spawned character. Starter funds are posted exactly once through an immutable, balanced ledger
transaction. The client can request only its current server-derived account snapshot and recent
history; it cannot submit balances, account ownership, funding amounts, or target accounts.

## Current scope

- server-created `CASH_WALLET` and `PERSONAL_CHECKING` accounts;
- one controlled `SYSTEM_SOURCE` account;
- atomic, three-entry starter allocation with a net value of zero;
- balance calculation from ledger entries;
- source/session/active-character authorization;
- read-only, versioned snapshot contract and audit logging.

Transfers, deposits, withdrawals, cards, account administration, and business accounts are later
banking slices.
