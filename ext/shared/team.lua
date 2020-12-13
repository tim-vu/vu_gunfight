local team = {
  ['US'] = 1,
  ['RU'] = 2
}

local otherTeam = {
  [team.US] = team.RU,
  [team.RU] = team.US
} 

GetOtherTeam = function(team)
  return otherTeam[team]
end

local teamId = {
  [team.US] = TeamId.Team1,
  [team.RU] = TeamId.Team2
}

GetTeamId = function(team)
  return teamId[team]
end

return team
