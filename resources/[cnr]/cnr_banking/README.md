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
- persistent active/inactive ATMs with server-owned coordinates and interaction radii;
- proximity-verified Cash Wallet deposits and Personal Checking withdrawals;
- permission-protected in-game ATM creation, listing, and deactivation commands;
- operation-UUID replay protection with payload conflicts and bounded rate limiting;
- server-derived senders, atomic debit/credit postings, and minimal audit logging.

## Dynamic ATM commands

An account with the `banking.atms.manage` technical permission can manage terminals after controlled
spawn. `owner` and `administrator` receive this permission from the migration.

```text
/cnr_atm_create [English label]
/cnr_atm_list
/cnr_atm_remove
```

Creation uses the administrator's server-observed ped position and heading. Removal affects only the
nearest active ATM inside the configured administrator radius. Clients cannot submit coordinates,
radius, creator, status, source or destination account, currency, balance, or ledger rows.

Cards, recurring payments, broader account administration, and business accounts are later banking
slices.
