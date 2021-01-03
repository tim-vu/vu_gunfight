
import { MAX_HEALTH } from "common/constants";
import { PlayerInfo, toPlayerInfo } from "models/Player";
import { Team } from "models/Team";
import { Reducer } from "redux";
import { MatchActions, MatchState } from "./types";

const initialState : MatchState = {
  team: Team.RU,
  teamSize: 2,
  map: "Noshar Canals",
  spectating: false,
  playerInfo: [],
  ourHealth: MAX_HEALTH * 2,
  theirHealth: MAX_HEALTH * 2
}

const matchReducer : Reducer<MatchState, MatchActions> = (state : MatchState = initialState, action) => {

  switch(action.type){
    case "DAMAGE_DEALT":

      const receiverIsOurTeam = state.playerInfo.some(p => p.team === state.team && p.id === action.receiverId)

      return {
        ...state,
        playerInfo: state.playerInfo.map(processDamage(action.giverId, action.receiverId, action.amount, action.lethal)),
        ourHealth: receiverIsOurTeam ? state.ourHealth - action.amount : state.ourHealth,
        theirHealth: receiverIsOurTeam ? state.theirHealth : state.theirHealth - action.amount
      }
    case "MATCH_STARTING":
      return {
        ...initialState,
        map: action.map,
        team: action.team,
        teamSize: action.teamSize,
        playerInfo: action.players.map(toPlayerInfo),
        ourHealth: MAX_HEALTH * action.teamSize,
        theirHealth: MAX_HEALTH * action.teamSize
      }
    case "ROUND_STARTING":
      return {
        ...state,
        ourHealth: MAX_HEALTH * state.teamSize,
        theirHealth: MAX_HEALTH * state.teamSize
      }
    case "ROUND_COMPLETED":
      return {
        ...state,
        spectating: false
      }
    default:
      return state;
  }
}

const processDamage = (giverId : number | null, receiverId : number, amount : number, lethal : boolean) => (player : PlayerInfo) => {

  if (player.id === giverId) {
    return {
      ...player,
      damageDealt: player.damageDealt + amount,
      kills: lethal ? player.kills + 1 : player.kills
    }
  }
  
  if (player.id === receiverId) {
    return {
      ...player,
      deaths: lethal ? player.deaths + 1 : player.deaths
    }
  }

  return player;

} 

export default matchReducer;