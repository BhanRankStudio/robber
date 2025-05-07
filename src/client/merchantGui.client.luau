local Players = game:GetService("Players")
local MerchantGuiRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantGui")
local MerchantSellRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantSell")
local MerchantAskPriceRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Merchant"):WaitForChild("MerchantAskPrice")
local NPCMerchantGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("NPCMerchant")
local blurEffect = game.Lighting:FindFirstChild("Blur")

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
