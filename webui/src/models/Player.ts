import { Team } from "./Team";

export interface Player {
  id: number;
  name: string;
  team: Team;
}

export interface PlayerInfo {
  id: number;
  name: string;
  team: Team;
  damageDealt: number;
  kills: number;
  deaths: number;
}

export const toPlayerInfo = (player : Player) => (
  {
    id: player.id,
    name: player.name,
    team: player.team,
    damageDealt: 0,
    kills: 0,
    deaths: 0
  }
)