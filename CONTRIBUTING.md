# Contributing

- Branch from `main`; never develop directly on the protected branch.
- Write code, identifiers, and code comments in English.
- Keep each resource responsible for one bounded area and document public boundaries.
- Never add production secrets or unreviewed vendor resources.
- Never edit an applied migration; add a forward correction.
- Run `pnpm verify`, `pnpm test:lua`, and the MariaDB migration rehearsal before opening a PR.
- Do not add gameplay scope to a technical-foundation change.
