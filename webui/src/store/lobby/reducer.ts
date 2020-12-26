import { addPlayer, removePlayer, resetMatch } from "models/Match";
import { Reducer } from "redux";
import { LobbyActions, LobbyState } from "./types";

const initialState : LobbyState = {
  matches: [],
  currentMatchId: null,
  playerId: 0,
  name: ""
}

const lobbyReducer : Reducer<LobbyState, LobbyActions> = (state : LobbyState = initialState, action) => {
  
  switch(action.type){
    case "INITIALIZE_LOBBY":
      return {
        ...state,
        ...action
      }
    case "JOINED_MATCH": 
      
      const index = state.matches.findIndex(m => m.mapId === action.matchId);
    
      if(index === -1)
        return state;

      const newMatches = state.matches.slice();
      newMatches[index] = addPlayer(state.matches[index], action.player);

      const currentMatchId = action.player.id === state.playerId ? action.matchId : state.currentMatchId

      return {
        ...state,
        matches: newMatches,
        currentMatchId: currentMatchId
      }
    case "LEFT_MATCH":

      const index2 = state.matches.findIndex(m => m.mapId === action.matchId);

      if(index2 === -1)
        return state;

      const currentMatchId2 = action.playerId === state.playerId ? null : state.currentMatchId;

      const newMatches2 = state.matches.slice();
      newMatches2[index2] = removePlayer(state.matches[index2], action.playerId);

      return {
        ...state,
        matches: newMatches2,
        currentMatchId: currentMatchId2
      }

    case "UPDATE_SCORE":

        const index3 = state.matches.findIndex(m => m.mapId === action.matchId);

        if(index3 === -1)
          return state;

        const newMatches3 = state.matches.slice();
        newMatches3[index3] = {...state.matches[index3], usScore: action.usScore, ruScore: action.ruScore}

        return {
          ...state,
          matches: newMatches3
        }
    case "RESET_MATCH":

        const index4 = state.matches.findIndex(m => m.mapId === action.matchId);

        if(index4 === -1)
          return state;

        const currentMatchId3 = state.currentMatchId === action.matchId ? null : state.currentMatchId;

        const newMatches4 = state.matches.slice();
        newMatches4[index4] = resetMatch(state.matches[index4]);

        return {
          ...state,
          matches: newMatches4,
          currentMatchId: currentMatchId3
        }


    default:
      return state;
  }

}

export default lobbyReducer;