import store from "store";
import { DamageDealt, MatchStarting, MATCH_STARTING, DAMAGE_DEALT } from "./types";
import { History } from 'history';
import { Team } from "models/Team";
import { Player } from "models/Player";
import { RoundCompleted, ROUND_COMPLETED } from "store/rounds/types";

declare const window: any;

function registerActionCreators(history : History) {

  window.matchStarting = (team: Team, map: string, players: Player[]) => {

    const action : MatchStarting = {
      type: MATCH_STARTING,
      team,
      map,
      players
    }

    store.dispatch(action);
  }

  window.matchCompleted = (win: boolean) => {

    const action : RoundCompleted = {
      type: ROUND_COMPLETED,
      win
    }

    store.dispatch(action);

    history.push('/match_completed')
  }


  window.showScoreboard = () => {
    window.location.hash = '#scoreboard';
  }

  window.hideScoreboard = () => {
    window.location.hash = '';
  }
  
  window.damageDealt = (giverId : number | null, receiverId : number, amount : number, lethal : boolean) => {

    const action : DamageDealt = {
      type: DAMAGE_DEALT,
      giverId,
      receiverId,
      amount,
      lethal
    }

    store.dispatch(action)
  }


}



export default registerActionCreators;