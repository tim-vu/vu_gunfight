import React from 'react';
import { faCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import './RoundIndicator.css';
import HealthIndicator from './HealthIndicator/HealthIndicator';
import { RoundsState } from 'store/rounds/types';
import { AppState } from 'store';
import { connect } from 'react-redux';
import LoadoutDisplay from './LoadoutDisplay/LoadoutDisplay';
import Countdown from './Countdown/Countdown';

const MAX_ROUNDS = 10;

const renderNTimes: (n: number, node: React.ReactNode) => React.ReactNode = (
  n,
  node
) => {
  let result = [];

  for (let i = 0; i < n; i++) {
    result.push(node);
  }

  return result;
};

interface RoundIndicatorProps {
  rounds: RoundsState;
}

const RoundIndicator: React.FC<RoundIndicatorProps> = ({ rounds }) => {
  return (
    <div className="score">
      <div className="flex items-end mb-1">
        <p className="shadow-right score-text">{rounds.wins}</p>
        {renderNTimes(
          rounds.wins,
          <FontAwesomeIcon
            icon={faCircle}
            className="score-circle score-circle win"
          />
        )}
        {renderNTimes(
          MAX_ROUNDS / 2 + 1 - rounds.wins,
          <FontAwesomeIcon icon={faCircle} className="score-circle" />
        )}
      </div>
      <div className="flex items-start">
        <p className="shadow-right score-text">{rounds.losses}</p>
        {renderNTimes(
          rounds.losses,
          <FontAwesomeIcon
            icon={faCircle}
            className="score-circle score-circle loss"
          />
        )}
        {renderNTimes(
          MAX_ROUNDS / 2 + 1 - rounds.losses,
          <FontAwesomeIcon icon={faCircle} className="score-circle" />
        )}
      </div>
    </div>
  );
};

const mapStateToProps = (state: AppState) => ({
  rounds: state.rounds,
});

export default connect(mapStateToProps, {})(RoundIndicator);
