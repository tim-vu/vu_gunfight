import { Loadout } from "models/Loadout";
import store from "store";
import { DamageDealt, MatchStarting, MATCH_STARTING, DAMAGE_DEALT } from "./types";
import { History } from 'history';
import { Team } from "models/Team";
import { Player } from "models/Player";

declare const window: any;

function registerActionCreators(history : History) {

  window.matchStarting = (team: Team, players: Player[]) => {

    const action : MatchStarting = {
      type: MATCH_STARTING,
      team,
      players
    }

    store.dispatch(action);
  }

  window.matchStopped = () => {
    history.push('');
  }
  
  window.damageDealt = (giverId : number | null, receiverId : number, amount : number) => {

    const action : DamageDealt = {
      type: DAMAGE_DEALT,
      giverId,
      receiverId,
      amount
    }

    store.dispatch(action)
  }


}



export default registerActionCreators;