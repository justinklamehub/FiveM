/** Validates timestamped forward migration names and dbmate section ordering. */
import fs from 'node:fs';
import path from 'node:path';
const directory = path.join(process.cwd(), 'database', 'migrations');
const files = fs.readdirSync(directory).filter((file) => file.endsWith('.sql')).sort();
if (files.length === 0) throw new Error('At least one migration is required.');
const versions = new Set();
for (const file of files) {
  const match = /^(\d{14})_([a-z0-9_]+)\.sql$/.exec(file);
  if (!match) throw new Error(`Invalid migration filename: ${file}`);
  const version = match[1]; if (versions.has(version)) throw new Error(`Duplicate migration version: ${version}`); versions.add(version);
  const sql = fs.readFileSync(path.join(directory, file), 'utf8');
  const up = sql.indexOf('-- migrate:up'); const down = sql.indexOf('-- migrate:down');
  if (up < 0 || down < 0 || down <= up) throw new Error(`Invalid dbmate sections: ${file}`);
}
console.log(`Validated ${files.length} ordered dbmate migration file(s).`);
