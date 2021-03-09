import { MatchStarting } from "store/match/types"

export const SHOW_CONFIG = "SHOW_CONFIG"

export interface SetupState {
  config: string;
}

export interface ShowConfig {
  type: typeof SHOW_CONFIG;
  config: string;
}

export type SetupActions = ShowConfig