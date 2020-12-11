import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { Router } from 'react-router-dom';
import store, { registerActionCreators } from 'store';
import App from './components/App/App';
import { createBrowserHistory } from 'history';

import './styles.css';

declare const window: any;
const history = createBrowserHistory();

window.store = store;

registerActionCreators(store, history);

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <Router history={history}>
        <App />
      </Router>
    </Provider>
  </React.StrictMode>,
  document.getElementById('root')
);
