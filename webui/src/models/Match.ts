import { Player } from "./Player";
import { Status } from "./Status";

export interface Match {
  mapId: string;
  mapName: string;
  teamSize: number;
  startTime: number;
  status: Status;
  players: Player[];
  usScore: number;
  ruScore: number;
}

export function resetMatch(match : Match) : Match {
  return {
    ...match,
    startTime: 0,
    status: Status.NOT_STARTED,
    usScore: 0,
    ruScore: 0,
    players: []
  }
}

export function addPlayer(match : Match, player : Player) : Match {
  return {
    ...match,
    players: [...match.players, player]
  }
}

export function removePlayer(match : Match, playerId : number) : Match {
  return {
    ...match,
    players: match.players.filter(p => p.id !== playerId)
  }
}

export function updateStatus(match : Match, status : Status) : Match {
  return {
    ...match,
    status: status
  }
}

export function startMatch(match : Match, startTime : number) : Match {
  return {
    ...match,
    status: Status.PREGAME_WAIT,
    startTime: startTime
  }
}