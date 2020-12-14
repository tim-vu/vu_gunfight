import React from 'react';
import { connect } from 'react-redux';
import { AppState } from 'store';
import { MatchState } from 'store/match/types';
import RoundIndicator from '../RoundIndicator/RoundIndicator';
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useParams,
  useLocation,
} from 'react-router-dom';
import './App.css';
import RoundCompleted from 'components/RoundCompleted/RoundCompleted';
import LoadoutDisplay from 'components/RoundIndicator/LoadoutDisplay/LoadoutDisplay';
import Countdown from 'components/RoundIndicator/Countdown/Countdown';
import HealthIndicator from 'components/RoundIndicator/HealthIndicator/HealthIndicator';
import Scoreboard from 'components/Scoreboard/Scoreboard';

const PREROUND_WAIT = 5;

const App: React.FC = () => {
  return (
    <div className="screen">
      <Route path="/round_completed" component={RoundCompleted} />
      <Route path="/round_starting" component={RoundIndicator} />
      <Route
        path="/round_starting"
        render={(props) => <Countdown {...props} duration={PREROUND_WAIT} />}
      />
      <Route path="/round_starting" component={LoadoutDisplay} />
      <Route path="/round_started" component={RoundIndicator} />
      <Route path="/round_started" component={HealthIndicator} />
      <Route path="/match_completed" component={RoundCompleted} />
      <Route path="/scoreboard" component={Scoreboard} />
    </div>
  );
};

export default App;
