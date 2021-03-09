import { Reducer } from "redux";
import { SetupActions, SetupState, SHOW_CONFIG } from "./types";


const initialState : SetupState = {
  config: ''
}

const setupReducer : Reducer<SetupState, SetupActions> = (state = initialState, action) => {

  switch(action.type) {
    case SHOW_CONFIG:
      return {
        config: action.config
      }
    default:
      return state;
  }

}

export default setupReducer;