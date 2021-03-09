import React from 'react';
import './MapConfig.css';
import 'index.css';
import { AppState } from 'store';
import { connect } from 'react-redux';
import { closeConfig } from 'store/setup/actions';

interface MapConfigProps {
  content: string;
}

const MapConfig: React.FC<MapConfigProps> = ({ content }) => {
  return (
    <div className="flex flex-col justify-center m-auto config">
      <div className="config-header">
        <h1>CONFIG</h1>
      </div>
      <textarea
        className="config-text"
        readOnly={true}
        value={content}
      ></textarea>
      <button className="config-btn" onClick={() => closeConfig()}>
        CLOSE
      </button>
    </div>
  );
};

const mapStateToProps = (state: AppState) => ({
  content: state.setup.config,
});

export default connect(mapStateToProps, {})(MapConfig);
