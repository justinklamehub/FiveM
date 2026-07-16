# Toolchain and compatibility record

Checked on **2026-07-16** against official project documentation and release pages.

| Tool                | Pinned version | Compatibility decision                                                     |
| ------------------- | -------------: | -------------------------------------------------------------------------- |
| Node.js             |    24.18.0 LTS | Repository build runtime; satisfies Vite and Vitest requirements.          |
| pnpm                |        11.13.1 | Stable Corepack-managed package manager; pnpm 12 prereleases are excluded. |
| Lua (local tests)   |          5.4.8 | Exact official Lua 5.4 patch used for Busted outside the FXServer runtime. |
| LuaRocks            |         3.13.0 | Exact package manager used to install the pinned Busted test runner.       |
| React / React DOM   |         19.2.7 | Stable React 19.2 patch line.                                              |
| TypeScript          |          6.0.3 | Strict TypeScript checks for contracts and NUI.                            |
| Vite                |          8.1.4 | Stable Vite 8 build; Node 24 satisfies its engine range.                   |
| Vitest              |         4.1.10 | Stable test runner; Vitest 5 prereleases are excluded.                     |
| MariaDB             |        11.4.10 | Current 11.4 long-term-support line required by the project plan.          |
| dbmate              |         2.34.1 | Exact migration CLI version from the official project.                     |
| StyLua              |          2.5.2 | Exact formatter version through the official npm binary package.           |
| Lua Language Server |         3.18.2 | Exact diagnostics version downloaded in CI from the official release.      |
| Busted              |          2.3.0 | Exact Lua unit-test framework version installed through LuaRocks.          |
| oxmysql             |         2.14.1 | Reviewed and pinned adapter; not vendored in this commit.                  |
| actions/checkout    |     v7.0.0 SHA | Pinned to the signed release commit rather than a mutable version tag.     |
| actions/setup-node  |     v7.0.0 SHA | Pinned to the signed immutable release commit.                             |

The machine-readable source is `tools/versions.json`. Updates require a separate reviewed pull
request, fresh migration/build tests, and a staging check where applicable.

## Official primary sources

- Cfx.re resource manifest and CfxLua documentation
- Node.js release schedule and release archive
- pnpm official releases and installation documentation
- React, Vite, TypeScript, Vitest, MariaDB, dbmate, StyLua, LuaLS, and Busted official release pages
- oxmysql official release page

Exact source URLs and the review date are retained in the project README chapter 15 and the pull-request verification record.
