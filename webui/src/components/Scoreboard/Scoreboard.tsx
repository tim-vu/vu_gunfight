import { PlayerInfo } from 'models/Player';
import React from 'react';
import { connect } from 'react-redux';
import { AppState } from 'store';
import { MatchState } from 'store/match/types';
import './Scoreboard.css';
import { RoundsState } from 'store/rounds/types';
import { getOtherTeam, Team } from 'models/Team';

const playerInfoToTableRow = (player: PlayerInfo) => {
  return (
    <tr className="scoreboard-row">
      <td className="text-left scoreboard-data name">{player.name}</td>
      <td className="text-left scoreboard-data ">TODO</td>
      <td className="text-left scoreboard-data ">
        {Math.round(player.damageDealt)}
      </td>
      <td className="text-left scoreboard-data ">{player.kills}</td>
      <td className="text-left scoreboard-data ">{player.deaths}</td>
    </tr>
  );
};

interface ScoreboardProps {
  match: MatchState;
  rounds: RoundsState;
  status: string;
}

const Scoreboard: React.FC<ScoreboardProps> = ({ match, rounds, status }) => {
  const ourTeam = match.playerInfo.filter((p) => p.team === match.team);
  const theirTeam = match.playerInfo.filter((p) => p.team !== match.team);

  return (
    <div className="scoreboard-wrapper">
      <div className="scoreboard our">
        <div className="score-indicator">
          <h3>{Team[match.team]}</h3>
          <h1>{rounds.wins}</h1>
        </div>
        <div>
          <div className="match-info">
            <h1 className="shadow-right">{status}</h1>
            <div className="match-info-content">
              <span>Gunfight</span>
              <span>{match.map}</span>
              <span>Round: {rounds.rounds}</span>
            </div>
          </div>
          <table>
            <thead>
              <tr className="scoreboard-head">
                <th className="scoreboard-data name"></th>
                <th className="scoreboard-data">Score</th>
                <th className="scoreboard-data">Damage</th>
                <th className="scoreboard-data">Kills</th>
                <th className="scoreboard-data">Deaths</th>
              </tr>
            </thead>
          </table>
          <table className="scoreboard-table our">
            <tbody className="scoreboard-body our">
              {ourTeam.map(playerInfoToTableRow)}
            </tbody>
          </table>
        </div>
      </div>
      <div className="scoreboard their">
        <div className="score-indicator">
          <h3>{Team[getOtherTeam(match.team)]}</h3>
          <h1>{rounds.losses}</h1>
        </div>
        <table className="scoreboard-table their">
          <tbody className="scoreboard-body their">
            {theirTeam.map(playerInfoToTableRow)}
          </tbody>
        </table>
      </div>
    </div>
  );
};

const mapStateToProps = (state: AppState) => ({
  match: state.match,
  rounds: state.rounds,
});

export default connect(mapStateToProps, {})(Scoreboard);
