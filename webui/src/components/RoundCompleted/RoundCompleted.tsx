import React from 'react';

import './RoundCompleted.css';
import { RoundsState } from 'store/rounds/types';
import { connect } from 'react-redux';
import { AppState } from 'store';
import { getOtherTeam, Team } from 'models/Team';
import { MatchState } from 'store/match/types';
import Banner from 'components/Banner/Banner';
import { Result } from 'models/Result';

interface RoundCompletedProps {
  rounds: RoundsState;
  game: MatchState;
}

const getCause = (win: boolean, ourTeam: Team) => {
  const eliminatedTeam = win ? getOtherTeam(ourTeam) : ourTeam;
  return `${Team[eliminatedTeam]} ELIMINATED`;
};

const RoundCompleted: React.FC<RoundCompletedProps> = ({ rounds, game }) => {
  const resultText = rounds.isLastRoundWin ? 'ROUND WIN' : 'ROUND LOSS';
  const result = rounds.isLastRoundWin ? Result.Win : Result.Loss;

  const switchingSides = rounds.rounds % 2 === 0;

  return (
    <div className="w-full h-full flex flex-col justify-start items-center">
      <Banner result={result} text={resultText} />
      <h3 className="cause">{getCause(rounds.isLastRoundWin, game.team)}</h3>
      <div className="flex justify-between">
        <div className="score-display our">
          <p>{Team[game.team]}</p>
          <h2 className="score-rectangle">{rounds.wins}</h2>
        </div>
        <div className="score-display last their">
          <p>{Team[getOtherTeam(game.team)]}</p>
          <h2 className="score-rectangle">{rounds.losses}</h2>
        </div>
      </div>
      <h2 className={'switching ' + (switchingSides ? 'block' : 'hidden')}>
        SWITCHING SIDES
      </h2>
    </div>
  );
};

const mapStateToProps = (state: AppState) => ({
  rounds: state.rounds,
  game: state.match,
});

export default connect(mapStateToProps)(RoundCompleted);
