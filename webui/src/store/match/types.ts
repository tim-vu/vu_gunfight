import { Player, PlayerInfo } from "models/Player";
import { Team } from "models/Team";
import { RoundCompleted, RoundStarting } from "store/rounds/types";

export const MATCH_STARTING = 'MATCH_STARTING';
export const DAMAGE_DEALT = 'DAMAGE_DEALT';


export interface MatchState {
  team: Team;
  map: string;
  spectating: boolean;
  playerInfo: PlayerInfo[];
  ourHealth: number;
  theirHealth: number; 
}

export interface MatchStarting {
  type: typeof MATCH_STARTING;
  team: Team;
  map: string;
  players: Player[]
}

export interface DamageDealt {
  type: typeof DAMAGE_DEALT;
  giverId: number | null;
  receiverId: number;
  amount: number;
  lethal: boolean
}

export type MatchActions = MatchStarting | RoundStarting | RoundCompleted | DamageDealt