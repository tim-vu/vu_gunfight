import { Player } from "models/Player";
import { Team } from "models/Team";
import { Store } from "redux";
import { Action, AppState } from "store";
import { History } from "history";
import { InitializeLobby, INITIALIZE_LOBBY, JoinedMatch, JOINED_MATCH, LeftMatch, LEFT_MATCH, LobbyMatchStarting as LobbyMatchStarted, LOBBY_MATCH_STARTED, MatchStatusChanged, MATCH_STATUS_CHANGED, ResetMatch, RESET_MATCH, UpdateScore, UPDATE_SCORE } from "./types";
import { toast } from "react-toastify";
import { Status } from "models/Status";

declare const window: any;
declare const WebUI: any;

export function joinAnyMatch() {
  
  WebUI.Call('DispatchEvent', 'WebUI:JoinAnyMatch');

  return {
    type: 'JOIN_ANY_MATCH'
  }

}

export function joinMatch(matchId : string, team : Team) {

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

export function leaveMatch() {
  
  WebUI.Call('DispatchEvent', 'WebUI:LeaveMatch');
  
  return {
    type: 'LEAVE_MATCH'
  }
}

export default function registerActionCreators(store : Store<AppState, Action>, history : History) {

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

  window.showLeaveGameToast = () => {
    toast.dark('Hold ESC to leave the game');
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

  window.matchStatusChanged = (matchId : string, status : Status) => {

    const action : MatchStatusChanged = {
      type: MATCH_STATUS_CHANGED,
      matchId,
      status
    }

    console.log(action);

    store.dispatch(action);
  }

  window.lobbyMatchStarted = (matchId : string) => {

    const action : LobbyMatchStarted = {
      type: LOBBY_MATCH_STARTED,
      matchId,
      startTime: Date.now() / 1000
    }

    console.log(action);

    store.dispatch(action);
  }

  window.showLobby = () => {
    history.push('/lobby');
  }

}