export enum Team {
  US = 1,
  RU = 2
}

export function getOtherTeam(team : Team) {

  return team === Team.US ? Team.RU : Team.US;

}