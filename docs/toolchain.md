# Toolchain and compatibility record

Checked on **2026-07-16** against official project documentation and release pages.

| Tool | Pinned version | Decision |
|---|---:|---|
| Node.js | 24.18.0 LTS | Repository build runtime; satisfies Vite and Vitest requirements. |
| pnpm | 11.13.1 | Stable Corepack-managed package manager. |
| Lua | 5.4.8 | Exact official Lua patch used for standalone tests. |
| LuaRocks | 3.13.0 | Exact package manager for Busted. |
| React / React DOM | 19.2.7 | Stable React patch line. |
| TypeScript | 6.0.3 | Strict contract and NUI checks. |
| Vite | 8.1.4 | Stable Vite build; Node 24 satisfies its engine range. |
| Vitest | 4.1.10 | Stable TypeScript test runner. |
| MariaDB | 11.4.10 | Pinned 11.4 LTS development and CI image. |
| dbmate | 2.34.1 | Exact migration CLI. |
| StyLua | 2.5.2 | Exact Lua formatter. |
| Lua Language Server | 3.18.2 | Exact diagnostics release. |
| Busted | 2.3.0 | Exact Lua test framework. |
| oxmysql | 2.14.1 | Reviewed adapter pin; not vendored. |
| actions/checkout | v7.0.0 commit SHA | Immutable action reference. |
| actions/setup-node | v7.0.0 commit SHA | Immutable action reference. |

The machine-readable source is `tools/versions.json`. Updates require a separate reviewed pull request and fresh migration/build tests.
