import React from 'react';

import './Countdown.css';

interface CountdownProps {
  duration: number;
}

const MILLIS_IN_SECOND = 1000;

const Countdown: React.FC<CountdownProps> = ({ duration }) => {
  const [remaining, setRemaining] = React.useState(duration);
  const id = React.useRef<number | null>(null);

  const clear = () => id.current != null && window.clearInterval(id.current);

  React.useEffect(() => {
    id.current = window.setInterval(() => {
      setRemaining((remaining) => remaining - 1);
    }, MILLIS_IN_SECOND);

    return () => {
      clear();
    };
  }, []);

  React.useEffect(() => {
    if (remaining === 0) clear();
  }, [remaining]);

  const className = remaining > 0 ? 'block' : 'hidden';

  return (
    <div className={'countdown-circle ' + className}>
      <h2 className="countdown-text">{remaining}</h2>
    </div>
  );
};

export default Countdown;
