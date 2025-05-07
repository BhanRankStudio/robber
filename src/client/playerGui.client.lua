local Players = game:GetService("Players")
local PlayerMoneyRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerMoney")
local PlayerInventorySlotRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlayerInventorySlot")
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
    GUI.Enabled = true
    local guiTextLabel = GUI:WaitForChild("Frame"):WaitForChild("value")
    guiTextLabel.Text = moneyTextFormat(playerMoney)
end)

PlayerInventorySlotRemote.OnClientEvent:Connect(function(currentUsedSlots, playerInventorySlotMax)
    local GUI = player:WaitForChild("PlayerGui"):WaitForChild("PlayerInventorySlot")
    GUI.Enabled = true
    local guiTextLabel = GUI:WaitForChild("Frame"):WaitForChild("value")
    guiTextLabel.Text = currentUsedSlots .. " / " .. playerInventorySlotMax
end)