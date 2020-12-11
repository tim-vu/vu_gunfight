import React from 'react';
import './LoadoutDisplay.css';
import 'index.css';
import { Loadout } from 'models/Loadout';
import { AppState } from 'store';
import { connect } from 'react-redux';

interface LoadoutDisplayProps {
  loadout: Loadout;
}

const LoadoutDisplay: React.FC<LoadoutDisplayProps> = ({ loadout }) => {
  console.log(loadout);

  return (
    <div className="loadout-display">
      <div className="item-rectangle weapon">
        <h3>Primary Weapon</h3>
        <p>{loadout.primary.weapon.displayName}</p>
        <img src={loadout.primary.weapon.imageUrl} alt="" />
        <p>{loadout.primary.weapon.category}</p>
      </div>
      {loadout.secondary && (
        <div className="item-rectangle weapon">
          <h3>Secondary Weapon</h3>
          <p>{loadout.secondary.weapon.displayName}</p>
          <img src={loadout.secondary.weapon.imageUrl} alt="" />
          <p>{loadout.secondary.weapon.category}</p>
        </div>
      )}
      {loadout.accessories?.map((item, i) => (
        <div className="item-rectangle accessory">
          <div className="flex flex-col justify-between">
            <h3>Accessory {i + 1}</h3>
            <p>{item.displayName}</p>
          </div>
        </div>
      ))}
    </div>
  );
};

const mapStateToProps = (state: AppState) => ({
  loadout: state.rounds.currentLoadout,
});

export default connect(mapStateToProps)(LoadoutDisplay);
