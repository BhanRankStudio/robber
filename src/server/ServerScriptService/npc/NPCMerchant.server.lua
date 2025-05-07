local Workspace = game:GetService("Workspace")
local merchants = Workspace:WaitForChild("Merchants"):GetChildren()
local MerchantGuiRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantGui")
local MerchantGuiAllRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantGuiAll")
local MerchantSellRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantSell")
local MerchantSellAllRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantSellAll")
local MerchantAskPriceRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantAskPrice")

local PlayerMoneyRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerMoney")
local PlayerDataStoreService = require(game.ServerStorage:WaitForChild("dataStorageServices"):WaitForChild("playerDataStoreServices"))

local helperFunction = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("function"))

local PlayerDataHandler = require(game.ServerStorage:WaitForChild("player"):WaitForChild("playerDataHandler"))
local InventoryServices = require(game.ServerStorage:WaitForChild("inventoryServices"):WaitForChild("inventoryServices"))

for _, merchant in pairs(merchants) do
    local prompt = merchant:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        prompt.Triggered:Connect(function(player)
            local playerTool = Workspace:FindFirstChild(player.Name):FindFirstChildWhichIsA("Tool")
            if playerTool then
                -- sell only holding tool
                local playerData = PlayerDataHandler:Get(player)
                local toolData = helperFunction.filter(function(item)
                    return item.toolId == playerTool.Name
                end, playerData.items)
                MerchantGuiRemote:FireClient(player , toolData[1])
            else
                local playerData = PlayerDataHandler:Get(player)
                MerchantGuiAllRemote:FireClient(player, playerData.items)
            end
        end)
    end
end


local function checkIfPlayerHasItem(player, itemId)
    local playerData = PlayerDataHandler:Get(player)
    local toolData = helperFunction.filter(function(item)
        return item.toolId == itemId
    end, playerData.items)

    return #toolData > 0
end


MerchantSellRemote.OnServerEvent:Connect(function(player, item)
    local playerTool = Workspace:FindFirstChild(player.Name):FindFirstChildWhichIsA("Tool") or player.Backpack:FindFirstChildWhichIsA("Tool")
    
    local hasItem = checkIfPlayerHasItem(player, item.toolId)
    if not hasItem then
        return
    end
    
    if playerTool then
        InventoryServices.RemoveItem(player, item)
        local playerData = PlayerDataHandler:Get(player)
        playerData.money += 100
        PlayerDataStoreService.SetPlayerData(player.UserId, playerData)
        PlayerDataHandler:Set(player, playerData)
        PlayerMoneyRemote:FireClient(player, playerData.money)
        MerchantSellRemote:FireClient(player)
    end
end)

MerchantAskPriceRemote.OnServerEvent:Connect(function(player, item)
end)

MerchantSellAllRemote.OnServerEvent:Connect(function(player, items)
    local playerData = PlayerDataHandler:Get(player)
    local totalMoney = 0
    for _, item in pairs(items) do
        local hasItem = checkIfPlayerHasItem(player, item.toolId)
        if hasItem then
            InventoryServices.RemoveItem(player, item)
            totalMoney += 100
        end
    end

    playerData.money += totalMoney
    PlayerDataStoreService.SetPlayerData(player.UserId, playerData)
    PlayerDataHandler:Set(player, playerData)
    PlayerMoneyRemote:FireClient(player, playerData.money)
    MerchantSellAllRemote:FireClient(player)
end)