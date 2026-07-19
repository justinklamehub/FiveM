import { readFileSync, statSync } from 'node:fs';
import { resolve } from 'node:path';
import { describe, expect, it } from 'vitest';

const iconDirectory = resolve('packages/ui/public/assets/items');
const starterIcons = ['water_bottle.png', 'sandwich.png', 'state_id.png'];

describe('inventory PNG assets', () => {
  it.each(starterIcons)('packages a compact transparent 256px %s icon', (filename) => {
    const path = resolve(iconDirectory, filename);
    const image = readFileSync(path);

    expect(image.subarray(0, 8)).toEqual(
      Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    );
    expect(image.readUInt32BE(16)).toBe(256);
    expect(image.readUInt32BE(20)).toBe(256);
    expect(image[25]).toBe(6);
    expect(statSync(path).size).toBeLessThan(100_000);
  });
});
