local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("QTEGui")
local qteFrame = gui:WaitForChild("QTEFrame")
local targetZone = qteFrame:WaitForChild("TargetZone")
local cursor = qteFrame:WaitForChild("Cursor")

local QTEService = {}

function QTEService.prepareQTE()
    -- Randomize TargetZone size and position
    local targetWidth = math.random(30, 60)
    targetZone.Size = UDim2.new(0, targetWidth, 1, 0)
    targetZone.Position = UDim2.new(0, math.random(0, 200 - targetWidth), 0, 0)

    -- Randomize Cursor size and reset to start
    local cursorWidth = math.random(5, 15)
    cursor.Size = UDim2.new(0, cursorWidth, 1, 0)
    cursor.Position = UDim2.new(0, 0, 0, 0)
end

return QTEService