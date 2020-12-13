
import { Loadout } from "models/Loadout";
import { Reducer } from "redux";
import { RoundsAction, RoundsState } from "./types";

const loadout : Loadout = {
  primary: {
    weapon: {
      category: 'Sniper rifle',
      displayName: 'M98B',
      imageUrl: 'M98B.png'
    },
    attachments: []
  },
  secondary: {
    weapon: {
      category: 'Shotgun',
      displayName: '870MCS',
      imageUrl: 'Remington.png'
    },
    attachments: []
  },
  accessories: [{
    category: 'Melee',
    displayName: 'Knife',
    imageUrl: 'Knife.png'
  }]
}

const initialState : RoundsState = {
  currentLoadout: loadout,
  rounds: 0,
  wins: 0,
  losses: 0,
  isLastRoundWin: false,
}

const roundsReducer : Reducer<RoundsState, RoundsAction> = (state = initialState, action) => {
  switch(action.type){
    case "MATCH_STARTING":
      return initialState;
    case "ROUND_STARTING":
      return {
        ...state,
        currentLoadout: action.loadout
      }
    case "ROUND_COMPLETED":
      return {
        ...state,
        rounds: state.rounds + 1,
        wins: state.wins + (action.win ? 1 : 0),
        losses: state.losses + (action.win ? 0 : 1),
        isLastRoundWin: action.win
      }
    default:
      return state;
  }
}

export default roundsReducer