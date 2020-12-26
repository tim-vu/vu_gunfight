import { Player } from "models/Player";
import { Team } from "models/Team";
import { Store } from "redux";
import { Action, AppState } from "store";
import { InitializeLobby, INITIALIZE_LOBBY, JoinAnyMatch, JoinedMatch, JOINED_MATCH, JoinMatch, LeaveMatch, LeftMatch, LEFT_MATCH, ResetMatch, RESET_MATCH, UpdateScore, UPDATE_SCORE } from "./types";

declare const window: any;
declare const WebUI: any;

export function joinAnyMatch() : JoinAnyMatch {
  
  WebUI.Call('DispatchEvent', 'WebUI:JoinAnyMatch');

  return {
    type: 'JOIN_ANY_MATCH'
  }

}

export function joinMatch(matchId : string, team : Team) : JoinMatch {

  const data : any = {
    mapId : matchId,
    team
  }

  WebUI.Call('DispatchEvent', 'WebUI:JoinMatch', JSON.stringify(data))

  return {
    type: 'JOIN_MATCH',
    matchId,
    team
  }
}

export function leaveMatch() : LeaveMatch {
  
  WebUI.Call('DispatchEvent', 'WebUI:LeaveMatch');
  
  return {
    type: 'LEAVE_MATCH'
  }
}

export default function registerActionCreators(store : Store<AppState, Action>) {

  window.initializeLobby = (name : string, playerId : number, matches : any[]) => {

    console.log(matches);
    
    if(matches === null) {
      matches = [];
    }

    matches = matches.map(m => {
      if (m.players === undefined) {
        m.players = [];
      }
      return m;
    });

    const action : InitializeLobby = {
      type: INITIALIZE_LOBBY,
      name,
      playerId,
      matches
    }

    store.dispatch(action);

  }

  window.joinedMatch = (matchId : string, player : Player) => {

    const action : JoinedMatch = {
      type: JOINED_MATCH,
      matchId,
      player
    };

    console.log(action);

    store.dispatch(action)
  }

  window.leftMatch = (matchId : string, playerId : number) => {
    const action : LeftMatch = {
      type: LEFT_MATCH,
      playerId,
      matchId,
    }

    console.log(action);

    store.dispatch(action);
  }

  window.resetMatch = (matchId : string) => {

    const action : ResetMatch = {
      type: RESET_MATCH,
      matchId
    }

    console.log(action);

    store.dispatch(action);
  }

  window.updateScore = (matchId : string, usScore : number, ruScore : number) => {

    const action : UpdateScore = {
      type: UPDATE_SCORE,
      matchId,
      usScore,
      ruScore
    }

    console.log(action);

    store.dispatch(action);

  }

}