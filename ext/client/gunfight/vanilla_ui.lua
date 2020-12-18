require('__shared/common')

local SPAWN_BUTTON_SCREEN = 'UI/Flow/Screen/SpawnButtonScreen'

local SCREENS_TO_REMOVE = {
    ['UI/Flow/Screen/PreRoundWaitingScreen'] = {},
    ['UI/Flow/Screen/HudTDMScreen'] = { 'TicketCounter', 'HudBackgroundWidget', 'Compass'},
    ['UI/Flow/Screen/SpawnScreenPC'] = {},
    ['UI/Flow/Screen/SpawnScreenTicketCounterTDMScreen'] = {},
    ['UI/Flow/Screen/Scoreboards/ScoreboardTwoTeamsHUD32Screen'] = {},
    ['UI/Flow/Screen/KillScreen'] = {},
    [SPAWN_BUTTON_SCREEN] = {}
}

local removeDefaultUI = function(setup)

    Hooks:Install("UI:PushScreen", 1, function(hook, screen, priority, parentGraph)
        local screen = UIGraphAsset(screen)

        if setup and screen.name then
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

end

return removeDefaultUI
