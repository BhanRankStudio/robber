-- Roblox API
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService") -- Add this service

-- Required services
local QTEService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("qte"):WaitForChild("qteServices"))

local player = Players.LocalPlayer
local QTEGui = player:WaitForChild("PlayerGui"):WaitForChild("QTEGui")
local QTEFrame = QTEGui:WaitForChild("QTEFrame")
local Cursor = QTEFrame:WaitForChild("Cursor")
local TargetZone = QTEFrame:WaitForChild("TargetZone")
local prompt = workspace.NPC.ProximityPrompt

local QTE_ACTIVE = false
local QTE_DURATION = 2

prompt.Triggered:Connect(function()
    QTEService.prepareQTE() -- Prepare the QTE (randomize target zone size and position)
    prompt.Enabled = false
    QTEGui.Enabled = true
    QTE_ACTIVE = true
    Cursor.Position = UDim2.new(0, 0, 0, 0)
    
    local startTime = tick()

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not QTE_ACTIVE then connection:Disconnect() return end
        local progress = math.clamp((tick() - startTime) / QTE_DURATION, 0, 1)
        Cursor.Position = UDim2.new(0, QTEFrame.AbsoluteSize.X * progress, 0, 0)
        if progress >= 1 then
            QTEGui.Enabled = false
            QTE_ACTIVE = false
            print("NOT PASS")
            connection:Disconnect()
        end
    end)

    local inputConn
    inputConn = UIS.InputBegan:Connect(function(input, processed)
        if processed or not QTE_ACTIVE then return end
        if input.KeyCode == Enum.KeyCode.Space then
            local cursorX = Cursor.AbsolutePosition.X
            local targetX = TargetZone.AbsolutePosition.X
            local targetEnd = targetX + TargetZone.AbsoluteSize.X
            if cursorX >= targetX and cursorX <= targetEnd then
                print("PASS")
            else
                print("NOT PASS")
            end
            QTEGui.Enabled = false
            QTE_ACTIVE = false
            connection:Disconnect()
            inputConn:Disconnect()
            prompt.Enabled = true
        end
    end)
end)