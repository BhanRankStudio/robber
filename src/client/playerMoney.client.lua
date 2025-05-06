local Players = game:GetService("Players")
local PlayerMoneyRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerMoney")
local player = Players.LocalPlayer

local function moneyTextFormat(money)
    local formattedMoney = money
    if money >= 1000000 then
        formattedMoney = string.format("%.1fm", money / 1000000)
    elseif money >= 1000 then
        formattedMoney = string.format("%.1fk", money / 1000)
    end
    return formattedMoney
end

PlayerMoneyRemote.OnClientEvent:Connect(function(playerMoney)
    local GUI = player:WaitForChild("PlayerGui"):WaitForChild("PlayerMoney")
    local guiTextLabel = GUI:WaitForChild("Frame"):WaitForChild("value")
    guiTextLabel.Text = moneyTextFormat(playerMoney)
end)
