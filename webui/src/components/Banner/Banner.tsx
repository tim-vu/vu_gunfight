import { Result } from 'models/Result';
import React from 'react';
import './Banner.css';

interface BannerProps {
  result: Result;
  text: string;
}

const RESULT_TO_CLASS = {
  [Result.Win]: 'win',
  [Result.Loss]: 'loss',
  [Result.Draw]: 'draw',
};

const Banner: React.FC<BannerProps> = ({ result, text }) => {
  const resultClass = RESULT_TO_CLASS[result];

  return <h1 className={'font-medium round-result ' + resultClass}>{text}</h1>;
};

export default Banner;
