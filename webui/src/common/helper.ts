export const renderNTimes: (n: number, node: React.ReactNode) => React.ReactNode = (
  n,
  node
) => {
  let result = [];

  for (let i = 0; i < n; i++) {
    result.push(node);
  }

  return result;
};