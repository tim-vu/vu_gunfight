import React from 'react';
import { connect } from 'react-redux';
import { AppState } from 'store';
import { LobbyState } from 'store/lobby/types';
import MatchDisplay from './MatchDisplay/MatchDisplay';
import './Lobby.css';
import { Match } from 'models/Match';
import { joinAnyMatch, leaveMatch } from 'store/lobby/actions';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faChevronLeft,
  faChevronRight,
} from '@fortawesome/free-solid-svg-icons';

const MATCHES_PER_PAGE = 3;

interface LobbyProps {
  lobby: LobbyState;
}

const Lobby: React.FC<LobbyProps> = ({ lobby }) => {
  const [page, setPage] = React.useState(0);

  if (lobby.matches.length <= page * MATCHES_PER_PAGE && page !== 0) {
    setPage(0);
  }

  let visibleMatches: (Match | null)[] = lobby.matches.slice(
    page * MATCHES_PER_PAGE,
    (page + 1) * MATCHES_PER_PAGE
  );

  for (let i = visibleMatches.length; i < MATCHES_PER_PAGE; i++) {
    visibleMatches.push(null);
  }

  const handlePreviousClicked = () => {
    setPage(page - 1);
  };

  const handleNextClicked = () => {
    setPage(page + 1);
  };

  const previousButtonDisabled = page === 0;
  const nextButtonDisabled =
    lobby.matches.length <= (page + 1) * MATCHES_PER_PAGE;

  const joinDisabled = lobby.currentMatchId !== null;
  const leaveButtonDisabled = lobby.currentMatchId === null;

  return (
    <div className="lobby">
      <img
        className="lobby-logo"
        alt="Venice Unleashed logo"
        src="/images/vu_logo.svg"
      />
      <h1 className="lobby-title">GUNFIGHT</h1>
      <div className="lobby-matches">
        <button
          disabled={previousButtonDisabled}
          onClick={handlePreviousClicked}
        >
          <FontAwesomeIcon icon={faChevronLeft} size="lg" />
        </button>
        {visibleMatches.map((m) => (
          <MatchDisplay match={m} joinDisabled={joinDisabled} />
        ))}
        <button disabled={nextButtonDisabled} onClick={handleNextClicked}>
          <FontAwesomeIcon icon={faChevronRight} size="lg" />
        </button>
      </div>
      <div className="lobby-buttons">
        <button disabled={joinDisabled} onClick={joinAnyMatch}>
          JOIN ANY GAME
        </button>
        <button disabled={leaveButtonDisabled} onClick={leaveMatch}>
          LEAVE
        </button>
      </div>
    </div>
  );
};

const mapStateToProps = (app: AppState) => ({
  lobby: app.lobby,
});

export default connect(mapStateToProps, {})(Lobby);
