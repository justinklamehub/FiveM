# cnr_banking

`cnr_banking` is the sole authority for character money balances and financial movements.

The initial Wave 2 slice creates one cash wallet and one personal checking account for every
spawned character. Starter funds are posted exactly once through an immutable, balanced ledger
transaction. The client can request its current server-derived account snapshot and recent history or
submit a bounded transfer intent containing a public recipient checking number, integer amount,
purpose, and correlation fields. It cannot submit a sender, balance, account ownership, currency,
funding amount, ledger entry, or result.

## Current scope

- server-created `CASH_WALLET` and `PERSONAL_CHECKING` accounts;
- one controlled `SYSTEM_SOURCE` account;
- atomic, three-entry starter allocation with a net value of zero;
- balance calculation from ledger entries;
- source/session/active-character authorization;
- versioned balance/history snapshots and character-to-character checking transfers;
- operation-UUID replay protection with payload conflicts and bounded rate limiting;
- server-derived senders, atomic debit/credit postings, and minimal audit logging.

Cash deposits, withdrawals, cards, recurring payments, account administration, and business accounts
are later banking slices.
