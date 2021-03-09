import { MAX_HEALTH } from "common/constants";
import { Match } from "models/Match";
import { Player } from "models/Player";
import { Status } from "models/Status";
import { Team } from "models/Team";

export const INITIALIZE_LOBBY = "INITIALIZE_LOBBY";
export const JOIN_ANY_MATCH = "JOIN_ANY_MATCH";
export const UPDATE_SCORE = "UPDATE_SCORE";
export const JOIN_MATCH = "JOIN_MATCH";
export const JOINED_MATCH = "JOINED_MATCH";
export const LEAVE_MATCH = "LEAVE_MATCH";
export const LEFT_MATCH = "LEFT_MATCH";
export const RESET_MATCH = "RESET_MATCH";
export const MATCH_STATUS_CHANGED = "MATCH_STATUS_CHANGED";
export const LOBBY_MATCH_STARTED = "LOBBY_MATCH_STARTED";

export interface LobbyState {
  matches: Match[];
  currentMatchId: string | null;
  playerId: number;
  name: string;
}

export interface InitializeLobby {
  type: typeof INITIALIZE_LOBBY;
  matches: Match[];
  playerId: number;
  name: string;
}

export interface JoinedMatch {
  type: typeof JOINED_MATCH;
  matchId: string;
  player: Player;
}

export interface LeftMatch {
  type: typeof LEFT_MATCH;
  playerId: number;
  matchId: string;
}

export interface ResetMatch {
  type: typeof RESET_MATCH;
  matchId: string;
}

export interface UpdateScore {
  type: typeof UPDATE_SCORE;
  matchId: string;
  usScore: number;
  ruScore: number;
}

export interface MatchStatusChanged {
  type: typeof MATCH_STATUS_CHANGED;
  matchId: string;
  status: Status;
}

export interface LobbyMatchStarting {
  type: typeof LOBBY_MATCH_STARTED;
  matchId: string;
  startTime: number;
}

export type LobbyActions = InitializeLobby | ResetMatch | JoinedMatch | LeftMatch | UpdateScore | MatchStatusChanged | LobbyMatchStarting;