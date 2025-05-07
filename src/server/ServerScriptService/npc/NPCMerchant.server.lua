local Workspace = game:GetService("Workspace")
local merchants = Workspace:WaitForChild("Merchants"):GetChildren()
local MerchantGuiRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantGui")
local MerchantSellRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantSell")
local MerchantAskPriceRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantAskPrice")

local helperFunction = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("function"))

local PlayerDataHandler = require(game.ServerStorage:WaitForChild("player"):WaitForChild("playerDataHandler"))
local InventoryServices = require(game.ServerStorage:WaitForChild("inventoryServices"):WaitForChild("inventoryServices"))

for _, merchant in pairs(merchants) do
    local prompt = merchant:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        prompt.Triggered:Connect(function(player)
            local playerTool = Workspace:FindFirstChild(player.Name):FindFirstChildWhichIsA("Tool")
            if playerTool then
                --  Todo: Fix ID of item to be unique
                local playerData = PlayerDataHandler:Get(player)
                local toolData = helperFunction.filter(function(item)
                    return item.Id == playerTool.Name
                end, playerData.items)
                MerchantGuiRemote:FireClient(player , toolData[1])
            end
        end)
    end
end


local function checkIfPlayerHasItem(player, itemId)
    local playerData = PlayerDataHandler:Get(player)
    local toolData = helperFunction.filter(function(item)
        return item.Id == itemId
    end, playerData.items)

    return #toolData > 0
end

MerchantSellRemote.OnServerEvent:Connect(function(player, item)
    -- local playerData = PlayerDataHandler:Get(player)
    local playerTool = Workspace:FindFirstChild(player.Name):FindFirstChildWhichIsA("Tool") or player.Backpack:FindFirstChildWhichIsA("Tool")

    local hasItem = checkIfPlayerHasItem(player, item.Id)
    if not hasItem then
        return
    end

    if playerTool then
        InventoryServices.RemoveItem(player, item)
    end
end)

-- MerchantAskPriceRemote.OnServerEvent:Connect(function(player, item)
-- end)
