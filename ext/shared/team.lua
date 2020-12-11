Team = {
  ['US'] = 1,
  ['RU'] = 2
}

local otherTeam = {
  [Team.US] = Team.RU,
  [Team.RU] = Team.US
} 

GetOtherTeam = function(team)
  return otherTeam[team]
end

local teamId = {
  [Team.US] = TeamId.Team1,
  [Team.RU] = TeamId.Team2
}

GetTeamId = function(team)
  return teamId[team]
end
