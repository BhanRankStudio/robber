local Workspace = game:GetService("Workspace")
local PlayerDataStoreService = require(game.ServerStorage:WaitForChild("dataStorageServices"):WaitForChild("playerDataStoreServices"))
local PlayerDataHandler = require(game.ServerStorage:WaitForChild("player"):WaitForChild("playerDataHandler"))
local PlayerInventorySlotRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerInventorySlot")

local inventoryServices = {}

function inventoryServices.AddItem(player, item)
    -- DataStorePart
    local playerData = PlayerDataHandler:Get(player)
    
    table.insert(playerData.items, item)
    
    -- Save the updated data
    PlayerDataStoreService.SetPlayerData(player.UserId, playerData)
    PlayerDataHandler:Set(player, playerData)
    PlayerInventorySlotRemote:FireClient(player, #playerData.items, playerData.inventorySlotMax)

    -- Clone the item to the player
    local playerBackpack = player:FindFirstChild("Backpack")
    if playerBackpack then
        -- TODO: Change this to appropriate item
        local itemClone = game.ServerStorage.items[item.Id]:Clone()
        itemClone.Parent = playerBackpack
        itemClone.Name = item.toolId
    end
end

function inventoryServices.RemoveItem(player, item)
    local playerData = PlayerDataHandler:Get(player)
    
    for i, v in ipairs(playerData.items) do
        if v.toolId == item.toolId then
            table.remove(playerData.items, i)
            break
        end
    end
    
    -- Save the updated data
    PlayerDataStoreService.SetPlayerData(player.UserId, playerData)
    PlayerDataHandler:Set(player, playerData)
    PlayerInventorySlotRemote:FireClient(player, #playerData.items, playerData.inventorySlotMax)

    -- Remove the item from the player's backpack
    local playerTool = player.Backpack:FindFirstChild(item.toolId) or Workspace:FindFirstChild(player.Name):FindFirstChild(item.toolId)
    if playerTool then
        playerTool:Destroy()
    end
end

return inventoryServices