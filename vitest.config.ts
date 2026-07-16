import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['packages/**/*.test.ts', 'packages/**/*.test.tsx', 'tests/contract/**/*.test.ts'],
    passWithNoTests: false,
    restoreMocks: true,
    pool: 'forks',
    maxWorkers: 1,
  },
});
