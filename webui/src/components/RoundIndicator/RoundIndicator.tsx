import React, { Fragment } from 'react';
import { faCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import './RoundIndicator.css';
import { RoundsState } from 'store/rounds/types';
import { AppState } from 'store';
import { connect } from 'react-redux';
import IngameScoreboard from 'components/IngameScoreboard/IngameScoreboard';
import { renderNTimes } from 'common/helper';

const MAX_ROUNDS = 10;

interface RoundIndicatorProps {
  rounds: RoundsState;
}

const RoundIndicator: React.FC<RoundIndicatorProps> = ({ rounds }) => {
  return (
    <Fragment>
      <IngameScoreboard />
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
    </Fragment>
  );
};

const mapStateToProps = (state: AppState) => ({
  rounds: state.rounds,
});

export default connect(mapStateToProps, {})(RoundIndicator);
