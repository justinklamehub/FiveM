/** Ensures all independently declared tool versions match the authoritative version file. */
import fs from 'node:fs';

const versions = JSON.parse(fs.readFileSync('tools/versions.json', 'utf8'));
const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
const assertions = [
  ['Node', fs.readFileSync('.node-version', 'utf8').trim(), versions.node],
  ['pnpm', packageJson.packageManager, `pnpm@${versions.pnpm}`],
  ['TypeScript', packageJson.devDependencies.typescript, versions.typescript],
  ['Vite', packageJson.devDependencies.vite, versions.vite],
  ['Vitest', packageJson.devDependencies.vitest, versions.vitest],
  ['dbmate', packageJson.devDependencies.dbmate, versions.dbmate],
  ['StyLua', packageJson.devDependencies['@johnnymorganz/stylua-bin'], versions.stylua],
];
for (const [name, actual, expected] of assertions) {
  if (actual !== expected) throw new Error(`${name} version mismatch: ${actual} != ${expected}`);
}

const workflow = fs.readFileSync('.github/workflows/ci.yml', 'utf8');
const workflowPins = [
  ['pnpm CI', `pnpm@${versions.pnpm}`],
  ['Lua CI', `LUA_VERSION: ${versions.lua}`],
  ['LuaRocks CI', `LUAROCKS_VERSION: ${versions.luaRocks}`],
  ['Busted CI', `BUSTED_VERSION: ${versions.busted}`],
  ['LuaLS CI', `LUA_LS_VERSION: ${versions.luaLanguageServer}`],
  ['checkout action', `actions/checkout@${versions.actionsCheckout}`],
  ['setup-node action', `actions/setup-node@${versions.actionsSetupNode}`],
];
for (const [name, pin] of workflowPins) {
  if (!workflow.includes(pin)) throw new Error(`${name} is not pinned to ${pin}`);
}

const compose = fs.readFileSync('compose.yaml', 'utf8');
if (!compose.includes(`mariadb:${versions.mariaDb}`))
  throw new Error('MariaDB image is not pinned');
console.log('Toolchain pins are internally consistent.');
