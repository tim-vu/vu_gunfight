
import { PlayerInfo, toPlayerInfo } from "models/Player";
import { Team } from "models/Team";
import { Reducer } from "redux";
import { MatchActions, MatchState } from "./types";

const initialState : MatchState = {
  team: Team.RU,
  spectating: false,
  playerInfo: [],
  ourHealth: 200,
  theirHealth: 200
}

const matchReducer : Reducer<MatchState, MatchActions> = (state : MatchState = initialState, action) => {

  switch(action.type){
    case "DAMAGE_DEALT":

      const receiverIsOurTeam = state.playerInfo.some(p => p.team === state.team && p.id === action.receiverId)

      return {
        ...state,
        playerInfo: state.playerInfo.map(addDamageToPlayer(action.giverId, action.amount)),
        ourHealth: receiverIsOurTeam ? state.ourHealth - action.amount : state.ourHealth,
        theirHealth: receiverIsOurTeam ? state.theirHealth : state.theirHealth - action.amount
      }
    case "MATCH_STARTING":
      return {
        ...initialState,
        team: action.team,
        playerInfo: action.players.map(toPlayerInfo)
      }
    case "ROUND_STARTING":
      return {
        ...state,
        ourHealth: 200,
        theirHealth: 200
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

const addDamageToPlayer = (id : number | null, amount : number) => (player : PlayerInfo) => {

  if (id === null || player.id !== id)
    return player
  
  return {
    ...player,
    damageDealt: player.damageDealt + amount
  }

} 

export default matchReducer;