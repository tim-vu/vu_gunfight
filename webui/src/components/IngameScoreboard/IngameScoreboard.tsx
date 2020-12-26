import Scoreboard from 'components/Scoreboard/Scoreboard';
import { getOtherTeam, Team } from 'models/Team';
import React from 'react';
import { connect } from 'react-redux';
import { RouteComponentProps, withRouter } from 'react-router-dom';
import { AppState } from 'store';
import { MatchState } from 'store/match/types';
import { RoundsState } from 'store/rounds/types';

interface IngameScoreboardProps {
  matchState: MatchState;
  rounds: RoundsState;
}

const getStatus = (team: Team, rounds: RoundsState) => {
  if (rounds.wins !== rounds.losses) {
    console.log(Team.US);
    console.log(Team.RU);
    console.log(team);

    const winningTeam =
      rounds.wins > rounds.losses ? Team[team] : Team[getOtherTeam(team)];

    return `${winningTeam} WINNING`;
  }

  return 'DRAW';
};

const IngameScoreboard: React.FC<
  IngameScoreboardProps & RouteComponentProps
> = ({ matchState, rounds, location }) => {
  if (location.hash !== '#scoreboard') {
    return null;
  }

  const status = getStatus(matchState.team, rounds);

  return <Scoreboard status={status} />;
};

const mapStateToProps = (app: AppState) => ({
  matchState: app.match,
  rounds: app.rounds,
});

export default connect(mapStateToProps, {})(withRouter(IngameScoreboard));
