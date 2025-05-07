local Workspace = game:GetService("Workspace")
local merchants = Workspace:WaitForChild("Merchants"):GetChildren()
local MerchantSellRemote = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("MerchantSell")
local helperFunction = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("function"))

local PlayerDataHandler = require(game.ServerStorage:WaitForChild("player"):WaitForChild("playerDataHandler"))

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
                MerchantSellRemote:FireClient(player , toolData[1])
            end
        end)
    end
end
