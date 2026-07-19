import fs from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';

function collectFiles(directory: string, extensions: ReadonlySet<string>): string[] {
  const files: string[] = [];
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const fullPath = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      files.push(...collectFiles(fullPath, extensions));
    } else if (extensions.has(path.extname(entry.name))) {
      files.push(fullPath);
    }
  }
  return files;
}

const ownedSqlAndLuaFiles = [
  ...collectFiles('database/migrations', new Set(['.sql'])),
  ...collectFiles('resources/[cnr]', new Set(['.lua'])),
];

describe('MariaDB UUID compatibility', () => {
  it.each(ownedSqlAndLuaFiles)('%s avoids MySQL-only UUID conversion functions', (file) => {
    const content = fs.readFileSync(file, 'utf8');
    expect(content).not.toMatch(/\bUUID_TO_BIN\s*\(/);
    expect(content).not.toMatch(/\bBIN_TO_UUID\s*\(/);
  });

  it('uses explicit MariaDB-compatible binary conversion in the permissions migration', () => {
    const migration = fs.readFileSync(
      'database/migrations/20260716000300_technical_roles_permissions.sql',
      'utf8',
    );
    expect(migration).toContain("UNHEX(REPLACE('018f0000-0000-7000-8000-000000000001', '-', ''))");
  });
});
