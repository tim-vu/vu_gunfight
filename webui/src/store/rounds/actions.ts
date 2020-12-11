import { Store } from "redux";
import { History } from 'history';
import { Action, AppState } from "store";
import { Loadout } from "models/Loadout";
import { RoundCompleted, RoundStarting, ROUND_COMPLETED, ROUND_STARTING } from "./types";

declare const window: any;

function registerActionCreators(store : Store<AppState, Action>, history : History ) {

  window.roundStarting = (loadout: Loadout) => {

    console.log(loadout)

    const action : RoundStarting = {
      type: ROUND_STARTING,
      loadout
    }

    store.dispatch(action);
    history.push('round_starting');
  }

  window.roundStarting = (loadout : Loadout) => {
  
    const action : RoundStarting = {
      loadout,
      type: ROUND_STARTING
    }
  
    store.dispatch(action);
    history.push('round_starting')
  }

  window.roundStarted = () => {
    history.push('round_started')
  }

  window.roundCompleted = (win : boolean) => {

    const action : RoundCompleted = {
      type: ROUND_COMPLETED,
      win
    }

    store.dispatch(action);
    history.push('round_completed');
  }

}

export default registerActionCreators;