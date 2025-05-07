local Players = game:GetService("Players")
local MerchantSellRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("MerchantSell")
local NPCMerchantGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("NPCMerchant")

local SellButton = NPCMerchantGui:WaitForChild("sell")
local AskPriceButton = NPCMerchantGui:WaitForChild("askPrice")

MerchantSellRemote.OnClientEvent:Connect(function(item)
    if item then
        NPCMerchantGui.Enabled = true
    end
end)

SellButton.MouseButton1Click:Connect(function()
   
end)

AskPriceButton.MouseButton1Click:Connect(function()
    
end)