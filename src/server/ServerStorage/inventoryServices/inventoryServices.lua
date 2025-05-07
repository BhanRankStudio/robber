local PlayerDataStoreService = require(game.ServerStorage:WaitForChild("dataStorageServices"):WaitForChild("playerDataStoreServices"))
local PlayerDataHandler = require(game.ServerStorage:WaitForChild("player"):WaitForChild("playerDataHandler"))

local inventoryServices = {}

function inventoryServices.AddItem(player, item)
    -- DataStorePart
    local playerData = PlayerDataHandler:Get(player)
    
    table.insert(playerData.items, item)
    
    -- Save the updated data
    PlayerDataStoreService.SetPlayerData(player.UserId, playerData)
    PlayerDataHandler:Set(player, playerData)

    -- Clone the item to the player
    local playerBackpack = player:FindFirstChild("Backpack")
    if playerBackpack then
        -- TODO: Change this to appropriate item
        local itemClone = game.ServerStorage.items[item.Id]:Clone()
        itemClone.Parent = playerBackpack
    end
end

function inventoryServices.RemoveItem(player, item)
    local playerData = PlayerDataHandler:Get(player)
    
    for i, v in ipairs(playerData.items) do
        if v.id == item.id then
            table.remove(playerData.items, i)
            break
        end
    end
    
    -- Save the updated data
    PlayerDataStoreService.SetPlayerData(player.UserId, playerData)
    PlayerDataHandler:Set(player, playerData)

    -- Remove the item from the player's backpack
    local playerBackpack = player:FindFirstChild("Backpack")
    if playerBackpack then
        local itemClone = playerBackpack:FindFirstChild(item.id)
        if itemClone then
            itemClone:Destroy()
        end
    end
end

return inventoryServices