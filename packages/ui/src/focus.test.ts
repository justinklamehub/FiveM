import { describe, expect, it } from 'vitest';
import { claimFocus, initialFocusState, releaseFocus } from './focus';

describe('focus ownership', () => {
  it('allows one owner and rejects a competing owner', () => {
    const owned = claimFocus(initialFocusState, 'banking');
    expect(claimFocus(owned, 'inventory')).toEqual(owned);
  });
  it('only lets the owner release focus', () => {
    const owned = claimFocus(initialFocusState, 'banking');
    expect(releaseFocus(owned, 'inventory')).toEqual(owned);
    expect(releaseFocus(owned, 'banking')).toEqual(initialFocusState);
  });
});
