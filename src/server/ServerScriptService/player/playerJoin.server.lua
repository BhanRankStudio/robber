local Players = game:GetService("Players")
local PlayerDataStoreService = require(game.ServerStorage:WaitForChild("dataStorageServices"):WaitForChild("playerDataStoreServices"))
local initPlayerData = require(game.ServerStorage:WaitForChild("templates"):WaitForChild("initPlayerData"))
local PlayerMoneyRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerMoney")

local function onPlayerAdded(player)
    -- Wait for the player to fully load
    player.CharacterAdded:Wait()
    
    local playerData = PlayerDataStoreService.GetPlayerData(player.UserId)
    if playerData then
        -- Player item
        local playerItems = playerData["items"]
        -- Clone tools to player backpack
        for _, item in pairs(playerItems) do
            -- Make sure the item exists in ServerStorage
            if game.ServerStorage.items:FindFirstChild(item.Id) then
                local tool = game.ServerStorage.items[item.Id]:Clone()
                -- Check if backpack is ready
                if player:FindFirstChild("Backpack") then
                    tool.Parent = player.Backpack
                else
                    -- Wait for backpack to be available
                    player:WaitForChild("Backpack")
                    tool.Parent = player.Backpack
                end
            else
                warn("Item not found: " .. item.Id)
            end
        end

        -- Player money
        local playerMoney = playerData["money"]
        PlayerMoneyRemote:FireClient(player, playerMoney)
    else
        -- create new player data
        PlayerDataStoreService.SetPlayerData(player.UserId, initPlayerData)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)