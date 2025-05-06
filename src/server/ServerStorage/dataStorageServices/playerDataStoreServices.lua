local dataStoreName = require(script.Parent.Parent:WaitForChild("configs"):WaitForChild("dataStoreName"))
local playerDataStore = game:GetService("DataStoreService"):GetDataStore(dataStoreName["playerDataStore_Dev"])

local playerDataStoreServices = {}

function playerDataStoreServices.GetPlayerData(playerId)
    local success, result = pcall(function()
        print("Fetching data for player ID:", playerId)
        local playerData = playerDataStore:GetAsync(playerId)
        if playerData then
            return playerData
        end
    end)
    if not success then
        warn("Failed to fetch player data:", result)
        return nil
    end
    return result
end

function playerDataStoreServices.SetPlayerData(playerId, data)
    return pcall(function()
        playerDataStore:SetAsync(playerId, data)
    end)
end

return playerDataStoreServices