import React from 'react';
import './App.css';
import RoundIndicator from '../RoundIndicator/RoundIndicator';
import { Route } from 'react-router-dom';
import RoundCompleted from 'components/RoundCompleted/RoundCompleted';
import LoadoutDisplay from 'components/LoadoutDisplay/LoadoutDisplay';
import Countdown from 'components/RoundIndicator/Countdown/Countdown';
import HealthIndicator from 'components/RoundIndicator/HealthIndicator/HealthIndicator';
import Lobby from 'components/Lobby/Lobby';
import MatchCompleted from 'components/MatchCompleted/MatchCompleted';
import { PREROUND_WAIT } from 'common/constants';
import MapConfig from 'components/MapConfig/MapConfig';

const App: React.FC = () => {
  return (
    <div className="screen">
      <Route path="/config" ext component={MapConfig} />
      <Route path="/lobby" exact component={Lobby} />
      <Route path="/round_completed" component={RoundCompleted} />
      <Route path="/round_starting" component={RoundIndicator} />
      <Route
        path="/round_starting"
        render={(props) => <Countdown {...props} duration={PREROUND_WAIT} />}
      />
      <Route path="/round_starting" component={LoadoutDisplay} />
      <Route path="/round_started" component={RoundIndicator} />
      <Route path="/round_started" component={HealthIndicator} />
      <Route path="/match_completed" component={MatchCompleted} />
    </div>
  );
};

export default App;
