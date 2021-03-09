import { Store } from "redux";
import { History } from 'history';
import { Action, AppState } from "store";
import { ShowConfig, SHOW_CONFIG } from "./types";

declare const window: any;
declare const WebUI: any;

export function closeConfig() {

  WebUI.Call('DispatchEvent', 'WebUI:CloseConfig');

}


export default function registerActionsCreators(store : Store<AppState, Action>, history : History) {

  window.showConfig = (config : any) => {

    const content : string = config.content

    const action : ShowConfig = {
      type: SHOW_CONFIG,
      config: content
    }

    console.log(action)

    store.dispatch(action)
    history.push('/config')
  }

}