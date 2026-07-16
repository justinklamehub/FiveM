/** Fails verification when likely credentials or forbidden secret files enter the repository. */
import fs from 'node:fs';
import path from 'node:path';
const ignored = new Set(['.git', 'node_modules', '.pnpm-store', '.tools', 'dist', 'coverage']);
const patterns = [
  ['GitHub token', /github_pat_[A-Za-z0-9_]{20,}/],
  ['classic GitHub token', /ghp_[A-Za-z0-9]{30,}/],
  ['private key', /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/],
  ['Discord webhook', /discord(?:app)?\.com\/api\/webhooks\/\d+\/[A-Za-z0-9_-]+/],
];
const files = [];
function walk(directory) {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    if (ignored.has(entry.name)) continue;
    const full = path.join(directory, entry.name);
    if (entry.isDirectory()) walk(full); else files.push(full);
  }
}
walk(process.cwd());
for (const file of files) {
  const value = fs.readFileSync(file); if (value.includes(0)) continue;
  const text = value.toString('utf8');
  for (const [name, pattern] of patterns) if (pattern.test(text)) throw new Error(`${name} detected in ${path.relative(process.cwd(), file)}`);
}
console.log(`Secret-pattern scan passed for ${files.length} text files.`);
