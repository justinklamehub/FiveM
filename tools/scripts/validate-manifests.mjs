/** Validates required FiveM manifest fields and rejects cyclic CNR dependencies. */
import fs from 'node:fs';
import path from 'node:path';

const expected = new Map([
  ['cnr_database', ['/onesync', 'oxmysql']],
  ['cnr_logs', ['/onesync']],
  ['cnr_locales', ['/onesync']],
  ['cnr_config', ['/onesync', 'cnr_logs', 'cnr_locales']],
  ['cnr_core', ['/onesync', 'cnr_database', 'cnr_logs', 'cnr_locales', 'cnr_config']],
  ['cnr_ui', ['/onesync', 'cnr_core', 'cnr_logs', 'cnr_locales', 'cnr_config']],
]);
const graph = new Map();
for (const [resource, dependencies] of expected) {
  const content = fs.readFileSync(path.join('resources', '[cnr]', resource, 'fxmanifest.lua'), 'utf8');
  for (const [label, expression] of [
    ['fx_version cerulean', /fx_version\s*\(?['"]cerulean['"]\)?/],
    ['game gta5', /game\s*\(?['"]gta5['"]\)?/],
    ['version 0.1.0', /version\s*\(?['"]0\.1\.0['"]\)?/],
  ]) if (!expression.test(content)) throw new Error(`${resource}: missing ${label}`);
  if (/lua54\s*\(?['"]yes['"]\)?/.test(content)) throw new Error(`${resource}: deprecated lua54 flag found`);
  const listed = [...content.matchAll(/^\s*'([^']+)',?\s*$/gm)].map((match) => match[1]);
  for (const dependency of dependencies) if (!listed.includes(dependency)) throw new Error(`${resource}: missing dependency ${dependency}`);
  graph.set(resource, dependencies.filter((dependency) => dependency.startsWith('cnr_')));
}
const visiting = new Set(); const visited = new Set();
function visit(node) {
  if (visiting.has(node)) throw new Error(`Resource dependency cycle detected at ${node}`);
  if (visited.has(node)) return;
  visiting.add(node); for (const dependency of graph.get(node) ?? []) visit(dependency); visiting.delete(node); visited.add(node);
}
for (const resource of expected.keys()) visit(resource);
console.log(`Validated ${expected.size} FiveM manifests and their acyclic dependency graph.`);
