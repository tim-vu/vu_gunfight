import { Loadout } from "models/Loadout"

export const ROUND_COMPLETED = "ROUND_COMPLETED"
export const ROUND_STARTING = 'ROUND_STARTING';

export interface RoundsState {
  currentLoadout: Loadout;
  rounds: number;
  wins: number;
  losses: number;
  isLastRoundWin: boolean;
}

export interface RoundStarting {
  type: typeof ROUND_STARTING;
  loadout: Loadout;
}

export interface RoundCompleted {
  type: typeof ROUND_COMPLETED;
  win: boolean;
}


export type RoundsAction = RoundCompleted | RoundStarting
