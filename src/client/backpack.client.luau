
-- This script limits the number of tools a player can have in their backpack.
-- Still some error with gun
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local toolCount = 0

local LIMIT = 4
local RETURN_TOOL_PARENT = workspace -- Where the tool will go if the player cannot pick it up


player.Backpack.ChildAdded:Connect(function(child)
    if not child:IsA("Tool") then return end


    toolCount += 1 -- New tool being added

    if toolCount > LIMIT then
        child.Parent = RETURN_TOOL_PARENT
    end
end)

player.Backpack.ChildRemoved:Connect(function(child)
    if child:IsA("Tool") then toolCount -= 1 end
end)