import { faCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { MAX_TEAM_SIZE, ROUNDS_TO_WIN } from 'common/constants';
import { renderNTimes } from 'common/helper';
import { Match } from 'models/Match';
import { Player } from 'models/Player';
import { Status } from 'models/Status';
import { Team } from 'models/Team';
import React from 'react';
import { joinMatch } from 'store/lobby/actions';
import './MatchDisplay.css';

const UPDATE_INTERVAL = 1000;

interface MatchDisplayProps {
  match: Match | null;
  joinDisabled: boolean;
}

const toPlayerRows = (players: Player[], teamSize: number) => {
  let rows = players.slice(0, MAX_TEAM_SIZE).map(toPlayerRow);

  for (let i = rows.length; i < teamSize; i++) {
    rows.push(
      <li key={10 + i} className="matchdisplay-playername">
        Waiting for player
      </li>
    );
  }

  for (let i = rows.length; i < MAX_TEAM_SIZE; i++) {
    rows.push(<li key={20 + i} className="matchdisplay-playername"></li>);
  }

  return rows;
};

const toPlayerRow = (player: Player) => {
  const className = player.team === Team.US ? 'us' : 'ru';

  return (
    <li
      key={player.id}
      className={'matchdisplay-playername taken ' + className}
    >
      {player.name}
    </li>
  );
};

const toStatusString = (status: Status | undefined) => {
  switch (status) {
    case Status.NOT_STARTED:
      return 'Waiting for player';
    case Status.PREGAME_WAIT:
    case Status.PREPREROUD_WAIT:
    case Status.POSTROUND_WAIT:
    case Status.ROUND_IN_PROGRESS:
      return 'In progress';
    case Status.MPOSTMATCH_WAIT:
    case Status.MATCH_ENDED:
      return 'Ending';
    default:
      return 'Not enabled';
  }
};

const toScoreIndicator = (wins: number, team: Team) => {
  const className = team === Team.US ? 'us' : 'ru';

  return (
    <div className="matchdisplay-score">
      {renderNTimes(
        wins,
        <FontAwesomeIcon
          icon={faCircle}
          className={'matchdisplay-scorecircle ' + className}
        />
      )}
      {renderNTimes(
        ROUNDS_TO_WIN - wins,
        <FontAwesomeIcon
          icon={faCircle}
          className="matchdisplay-scorecircle other"
        />
      )}
    </div>
  );
};

const toRuntime = (startTime: number) => {
  if (startTime === 0) {
    return '00:00';
  }

  const seconds = Math.floor(Date.now() / 1000 - startTime);

  return `${('0' + Math.floor(seconds / 60)).slice(-2)}:${(
    '0' +
    (seconds % 60)
  ).slice(-2)}`;
};

const MatchDisplay: React.FC<MatchDisplayProps> = ({ match, joinDisabled }) => {
  const [, forceUpdate] = React.useState<any>();

  React.useEffect(() => {
    const timer = setInterval(() => forceUpdate({}), UPDATE_INTERVAL);

    return () => clearInterval(timer);
  }, []);

  const usPlayers = match?.players.filter((p) => p.team === Team.US) || [];
  const ruPlayers = match?.players.filter((p) => p.team === Team.RU) || [];

  const joinUsButtonDisabled =
    match === null || usPlayers.length === match.teamSize || joinDisabled;
  const joinRuButtonDisabled =
    match === null || ruPlayers.length === match.teamSize || joinDisabled;

  return (
    <div className="matchdisplay">
      <div className="matchdisplay-map">
        <h1>{match?.map || ''}</h1>
      </div>
      <div className="matchdisplay-status">
        <p>Status: {toStatusString(match?.status)}</p>
        <p>Runtime: {toRuntime(match?.startTime || 0)}</p>
      </div>
      <div className="matchdisplay-team us">
        <div className="matchdisplay-team-header us">
          <h3>US</h3>
          {toScoreIndicator(match?.usScore || 0, Team.US)}
          <p>
            {usPlayers.length}/{match?.teamSize || 0}
          </p>
        </div>
        <ul className="matchdisplay-playerlist us">
          {toPlayerRows(usPlayers, match?.teamSize || 0)}
        </ul>
        <button
          className="matchdisplay-join"
          disabled={joinUsButtonDisabled}
          onClick={() => joinMatch(match?.mapId || '', Team.US)}
        >
          Join
        </button>
      </div>
      <div className="matchdisplay-team ru">
        <div className="matchdisplay-team-header ru">
          <h3>RU</h3>
          {toScoreIndicator(match?.ruScore || 0, Team.RU)}
          <p>
            {ruPlayers.length}/{match?.teamSize || 0}
          </p>
        </div>
        <ul>{toPlayerRows(ruPlayers, match?.teamSize || 0)}</ul>
      </div>
      <button
        className="matchdisplay-join"
        disabled={joinRuButtonDisabled}
        onClick={() => joinMatch(match?.mapId || '', Team.RU)}
      >
        Join
      </button>
    </div>
  );
};

export default MatchDisplay;
