import React from 'react';

import 'index.css';
import { RoundsState, RoundStarting } from 'store/rounds/types';
import { connect } from 'react-redux';
import { AppState } from 'store';
import { getOtherTeam, Team } from 'models/Team';
import { MatchState } from 'store/match/types';
import Banner from 'components/Banner/Banner';
import { Result } from 'models/Result';

const MAX_ROUNDS = 10;
const ROUNDS_TO_WIN = MAX_ROUNDS / 2 + 1;

interface RoundCompletedProps {
  rounds: RoundsState;
  game: MatchState;
}

const getCause = (win: boolean, ourTeam: Team) => {
  const eliminatedTeam = win ? getOtherTeam(ourTeam) : ourTeam;
  return `${Team[eliminatedTeam]} ELIMINATED`;
};

const getResult = (rounds: RoundsState) => {
  if (rounds.wins > ROUNDS_TO_WIN) return Result.Win;
  if (rounds.losses > ROUNDS_TO_WIN) return Result.Loss;

  return Result.Draw;
};

const RESULT_TO_TEXT = {
  [Result.Win]: 'VICTORY!',
  [Result.Loss]: 'DEFEAT!',
  [Result.Draw]: 'DRAW!',
};

const RoundCompleted: React.FC<RoundCompletedProps> = ({ rounds, game }) => {
  const result = getResult(rounds);
  const resultText = RESULT_TO_TEXT[result];

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
    </div>
  );
};

const mapStateToProps = (state: AppState) => ({
  rounds: state.rounds,
  game: state.match,
});

export default connect(mapStateToProps)(RoundCompleted);
