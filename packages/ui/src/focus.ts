/** Pure focus ownership helpers used by the browser shell and unit tests. */
export interface FocusState {
  owner: string | null;
  modalStack: readonly string[];
}

export const initialFocusState: FocusState = { owner: null, modalStack: [] };

export function claimFocus(state: FocusState, owner: string): FocusState {
  if (state.owner && state.owner !== owner) return state;
  return { ...state, owner };
}

export function releaseFocus(state: FocusState, owner: string): FocusState {
  if (state.owner !== owner) return state;
  return { owner: null, modalStack: [] };
}
