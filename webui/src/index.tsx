import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { Router } from 'react-router-dom';
import store, { registerActionCreators } from 'store';
import App from './components/App/App';
import { createBrowserHistory } from 'history';

import './styles.css';
import '../node_modules/react-toastify/dist/ReactToastify.min.css';
import { ToastContainer } from 'react-toastify';

declare const window: any;
const history = createBrowserHistory();

window.store = store;

registerActionCreators(store, history);

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <ToastContainer
        position="top-right"
        autoClose={3000}
        hideProgressBar={false}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss={false}
        draggable
        pauseOnHover={false}
      />
      <Router history={history}>
        <App />
      </Router>
    </Provider>
  </React.StrictMode>,
  document.getElementById('root')
);
