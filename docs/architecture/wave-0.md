# Wave 0 architecture

The six resources form an acyclic base:

```text
oxmysql -> cnr_database ----\
          cnr_logs ----------\
          cnr_locales --------> cnr_core -> cnr_ui
          cnr_config --------/
```

`cnr_config` additionally consumes logs and locales. `cnr_core` aggregates readiness and owns the
standard result/error/correlation contract, but no gameplay state. `cnr_database` checks connectivity
and the minimum dbmate schema version without changing the schema. `cnr_ui` is presentation only.

Statuses are `starting`, `ready`, `degraded`, `unavailable`, and `stopping`. A future mutating use case
must reject work unless every mandatory lower-level dependency is ready.
