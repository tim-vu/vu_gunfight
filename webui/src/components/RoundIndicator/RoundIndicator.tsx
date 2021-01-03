import React, { Fragment } from 'react';
import { faCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import './RoundIndicator.css';
import { RoundsState } from 'store/rounds/types';
import { AppState } from 'store';
import { connect } from 'react-redux';
import IngameScoreboard from 'components/IngameScoreboard/IngameScoreboard';
import { renderNTimes } from 'common/helper';
import { ROUNDS_TO_WIN } from 'common/constants';

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
            ROUNDS_TO_WIN - rounds.wins,
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
            ROUNDS_TO_WIN - rounds.losses,
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
