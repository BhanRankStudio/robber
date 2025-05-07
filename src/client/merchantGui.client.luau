local Players = game:GetService("Players")
local MerchantGuiRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantGui")
local MerchantGuiAllRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantGuiAll")
local MerchantSellRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantSell")
local MerchantSellAllRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantSellAll")
local MerchantAskPriceRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantAskPrice")


local blurEffect = game.Lighting:FindFirstChild("Blur")


local NPCMerchantAllGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("NPCMerchantAll")
local NPCMerchantAllFrame = NPCMerchantAllGui:WaitForChild("Frame")
local SellAllButton = NPCMerchantAllFrame:WaitForChild("sell")
local AskPriceAllButton = NPCMerchantAllFrame:WaitForChild("askPrice")

local NPCMerchantGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("NPCMerchant")
local MerchantFrame = NPCMerchantGui:WaitForChild("Frame")
-- Information
local itemNameLabel = MerchantFrame:WaitForChild("itemName")
local itemImageLabel = MerchantFrame:WaitForChild("itemImage")

-- Actions Button
local SellButton = MerchantFrame:WaitForChild("sell")
local AskPriceButton = MerchantFrame:WaitForChild("askPrice")

local currentItem = nil

MerchantGuiRemote.OnClientEvent:Connect(function(item)
    if item then
        blurEffect.Enabled = true
        NPCMerchantGui.Enabled = true
        itemNameLabel.Text = item.toolId
        itemImageLabel.Image = item.assetId
        currentItem = item
    end
end)

MerchantGuiAllRemote.OnClientEvent:Connect(function(items)
    if items then
        blurEffect.Enabled = true
        NPCMerchantAllGui.Enabled = true
        currentItem = items
    end
end)

SellButton.MouseButton1Click:Connect(function()
    if currentItem then
        MerchantSellRemote:FireServer(currentItem)
    end
end)

AskPriceButton.MouseButton1Click:Connect(function()
    if currentItem then
        MerchantAskPriceRemote:FireServer(currentItem)
    end
end)

MerchantSellRemote.OnClientEvent:Connect(function()
    blurEffect.Enabled = false
    NPCMerchantGui.Enabled = false
    itemNameLabel.Text = ""
    itemImageLabel.Image = ""
    currentItem = nil
end)

MerchantSellAllRemote.OnClientEvent:Connect(function()
    blurEffect.Enabled = false
    NPCMerchantAllGui.Enabled = false
    currentItem = nil
end)

SellAllButton.MouseButton1Click:Connect(function()
    MerchantSellAllRemote:FireServer(currentItem)
end)

AskPriceAllButton.MouseButton1Click:Connect(function()
    MerchantAskPriceRemote:FireServer(currentItem)
end)
