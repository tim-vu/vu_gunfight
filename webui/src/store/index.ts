import { combineReducers, createStore, Store } from 'redux';
import { composeWithDevTools } from "redux-devtools-extension";
import { History } from 'history';

import matchReducer from './match/reducer';
import { MatchActions, MatchState } from './match/types';
import registerMatchActionCreators from './match/actions';

import roundReducer from './rounds/reducer';
import { RoundsAction, RoundsState } from './rounds/types';
import registerRoundActionCreators from './rounds/actions';

import lobbyReducer from './lobby/reducer';
import { LobbyActions, LobbyState } from './lobby/types';
import registerLobbyActionCreators from './lobby/actions';

export interface AppState {
  rounds: RoundsState;
  match: MatchState;
  lobby: LobbyState;
}

export type Action =
  | RoundsAction
  | MatchActions
  | LobbyActions

const rootReducer = combineReducers<AppState>({
  rounds: roundReducer,
  match: matchReducer,
  lobby: lobbyReducer
})

export function registerActionCreators(store : Store<AppState, Action>, history : History){

  registerMatchActionCreators(history);
  registerRoundActionCreators(store, history);
  registerLobbyActionCreators(store);
  
}

function configureStore() {
  return createStore<AppState, Action, {}, {}>(rootReducer, composeWithDevTools())
}

export default configureStore();