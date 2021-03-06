import React from 'react';

import './HealthIndicator.css';
import { AppState } from 'store';
import { connect } from 'react-redux';
import { MatchState } from 'store/match/types';
import { MAX_HEALTH } from 'common/constants';

interface HealthIndicatorProps {
  match: MatchState;
}

const getStatus: (ourHealth: number, theirHealth: number) => string = (
  ourHealth,
  theirHealth
) => {
  if (ourHealth > theirHealth) return 'WINNING';
  else if (theirHealth > ourHealth) return 'LOSING';

  return 'TIED';
};

const getBarWidth: (health: number, teamSize: number) => string = (
  health,
  teamSize
) => {
  return `${(health / (MAX_HEALTH * teamSize)) * 100}%`;
};

const HealthIndicator: React.FC<HealthIndicatorProps> = ({ match }) => {
  const status = getStatus(match.ourHealth, match.theirHealth);

  const ourBarStyle: React.CSSProperties = {
    width: getBarWidth(match.ourHealth, match.teamSize),
  };

  const theirBarStyle: React.CSSProperties = {
    width: getBarWidth(match.theirHealth, match.teamSize),
  };

  return (
    <div className="health-indicators flex justify-center">
      <div>
        <p className="mr-0 text-right shadow-left">
          {Math.round(match.ourHealth)}
        </p>
        <div className="health-bar">
          <div className="health-bar-inner our" style={ourBarStyle}></div>
        </div>
      </div>
      <p className="health-status shadow-left">{status}</p>
      <div>
        <p className="ml-0 text-left shadow-left">
          {Math.round(match.theirHealth)}
        </p>
        <div className="health-bar">
          <div className="health-bar-inner their" style={theirBarStyle}></div>
        </div>
      </div>
    </div>
  );
};

const mapStateToProps = (state: AppState) => ({ match: state.match });

export default connect(mapStateToProps)(HealthIndicator);
