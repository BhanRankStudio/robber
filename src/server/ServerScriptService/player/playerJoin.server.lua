local Players = game:GetService("Players")
local PlayerDataStoreService = require(game.ServerStorage:WaitForChild("dataStorageServices"):WaitForChild("playerDataStoreServices"))
local initPlayerData = require(game.ServerStorage:WaitForChild("templates"):WaitForChild("initPlayerData"))
local PlayerMoneyRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerMoney")
local PlayerInventorySlotRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerInventorySlot")
local PlayerDataHandler = require(game.ServerStorage:WaitForChild("player"):WaitForChild("playerDataHandler"))

local function onPlayerAdded(player)
    -- Wait for the player to fully load
    player.CharacterAdded:Wait()
    
    local playerData = PlayerDataStoreService.GetPlayerData(player.UserId)
    if playerData then
        
        PlayerDataHandler:Set(player, playerData)

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
                    tool.Name = item.toolId
                end
            else
                warn("Item not found: " .. item.Id)
            end
        end

        -- Player money
        local playerMoney = playerData["money"]
        PlayerMoneyRemote:FireClient(player, playerMoney)

        -- Player inventory slots
        local playerInventorySlotMax = playerData["inventorySlotMax"]
        local currentUsedSlots = #playerItems
        PlayerInventorySlotRemote:FireClient(player, currentUsedSlots, playerInventorySlotMax)

    else
        -- create new player data
        PlayerDataStoreService.SetPlayerData(player.UserId, initPlayerData)
        PlayerMoneyRemote:FireClient(player, initPlayerData["money"])
        PlayerInventorySlotRemote:FireClient(player, 0, initPlayerData["inventorySlotMax"])
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)