require('__shared/common')
local Settings = require('__shared/settings')

if Settings.setup then
    return
end

local SPAWN_BUTTON_SCREEN = 'UI/Flow/Screen/SpawnButtonScreen'

local SCREENS_TO_REMOVE = {
    ['UI/Flow/Screen/PreRoundWaitingScreen'] = {},
    ['UI/Flow/Screen/HudMPScreen'] = {'HudMessageKills', 'ScoreMessage', 'ScoreAggregator', 'HudInformationMessage'},
    ['UI/Flow/Screen/HudTDMScreen'] = { 'TicketCounter', 'HudBackgroundWidget', 'Compass', 'LocalKillMessage', 'SquadList'},
    ['UI/Flow/Screen/Scoreboards/ScoreboardTwoTeamsHUD32Screen'] = {},
    ['UI/Flow/Screen/Scoreboards/ScoreboardTwoTeamsHUD16Screen'] = {},
    ['UI/Flow/Screen/Scoreboards/ScoreboardTwoTeamsHUD64Screen'] = {},
    ['UI/Flow/Screen/KillScreen'] = {},
    [SPAWN_BUTTON_SCREEN] = {}
}

Hooks:Install("UI:PushScreen", 1, function(hook, screen, priority, parentGraph)

    local screen = UIGraphAsset(screen)

    print(screen.name)

    if setup and screen.name == SPAWN_BUTTON_SCREEN then
        return
    end

    local val = SCREENS_TO_REMOVE[screen.name]

    if val ~= nil then

        if #val == 0 then
            hook:Return()
            return
        end

        local clone = UIGraphAsset(screen:Clone())

        for i = #screen.nodes, 1, -1 do
            local node = screen.nodes[i]

            if node ~= nil and ArrayContains(val, node.name) then
                clone.nodes:erase(i)
            end
        end

        hook:Pass(clone, priority, parentGraph)
        return
    end
end)

local UI_GAME_LOGIC_TDM = Guid('9EDDE27B-044B-4AA0-91BA-B949F03223CF')
local UI_GAME_LOGIC_TDM_BLUEPRINT = Guid('9B5398F2-ADB2-4CA8-80C6-6E062FECA9B8')
local SPAWN_SCREEN_TICKET_COUNTER = Guid('A5B6F1F4-CFC0-498B-B4AC-3044F573C460')
local SPAWN_MENU_SOUND_STATE = Guid('C75E0F55-DC7D-4A46-B638-524E570340C3')
local INGAME_MENU_SOUND_STATE = Guid('E6B4AC5B-C492-435C-BFBB-9571C949179A')

ResourceManager:RegisterInstanceLoadHandler(UI_GAME_LOGIC_TDM, UI_GAME_LOGIC_TDM_BLUEPRINT, function(instance)

  local blueprint = LogicPrefabBlueprint(instance)
  blueprint:MakeWritable()

  --exclude UISpawnMenuMPLogic
  local reference = LogicReferenceObjectData(blueprint.objects[10])
  reference:MakeWritable()
  reference.excluded = true

  for i = #blueprint.eventConnections, 1 , -1 do

    local connection = blueprint.eventConnections[i]

    if connection.target and connection.target.instanceGuid == SPAWN_SCREEN_TICKET_COUNTER then
      blueprint.eventConnections:erase(i)
    end

    if connection.target and connection.target.instanceGuid == SPAWN_MENU_SOUND_STATE then
      blueprint.eventConnections:erase(i)
    end

    if connection.target and connection.target.instanceGuid == INGAME_MENU_SOUND_STATE then
      blueprint.eventConnections:erase(i)
    end

  end

end)


return removeDefaultUI
