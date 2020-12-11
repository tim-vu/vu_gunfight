import { combineReducers, createStore, Store } from 'redux';
import { composeWithDevTools } from "redux-devtools-extension";
import { History } from 'history';

import matchReducer from './match/reducer';
import { MatchActions, MatchState } from './match/types';
import registerMatchActionCreators from './match/actions';

import roundReducer from './rounds/reducer';
import { RoundsAction, RoundsState } from './rounds/types';
import registerRoundActionCreators from './rounds/actions';

export interface AppState {
  rounds: RoundsState;
  match: MatchState;
}

export type Action =
  | RoundsAction
  | MatchActions

const rootReducer = combineReducers<AppState>({
  rounds: roundReducer,
  match: matchReducer,
})

export function registerActionCreators(store : Store<AppState, Action>, history : History){

  registerMatchActionCreators(history);
  registerRoundActionCreators(store, history);
  
}

function configureStore() {
  return createStore<AppState, Action, {}, {}>(rootReducer, composeWithDevTools())
}

export default configureStore();