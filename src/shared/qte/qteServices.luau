-- QTEService (Client ModuleScript)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("QTEGui")
local qteFrame = gui:WaitForChild("QTEFrame")
local attemptLabel = gui:WaitForChild("AttemptLabel")
local targetZone = qteFrame:WaitForChild("TargetZone")
local cursor = qteFrame:WaitForChild("Cursor")

local QTEService = {}
local QTE_ACTIVE = false
local currentAttempts = 0
local inputConn = nil
local moveConn = nil

function QTEService.prepareQTE()
    -- Randomize TargetZone size and position
    local targetWidth = math.random(30, 60)
    targetZone.Size = UDim2.new(0, targetWidth, 1, 0)
    targetZone.Position = UDim2.new(0, math.random(0, qteFrame.AbsoluteSize.X - targetWidth), 0, 0)

    -- Randomize Cursor size and reset to start
    local cursorWidth = math.random(5, 15)
    cursor.Size = UDim2.new(0, cursorWidth, 1, 0)
    cursor.Position = UDim2.new(0, 0, 0, 0)
end

function QTEService.startQTE(config, callback)
    local targetRange = config.targetZoneSizeRange or {30, 60}
    local timeLimit = config.timeLimit or 2.0
    local cursorSpeed = config.cursorSpeed or 1.0
    local MAX_ATTEMPTS = config.maxAttempts or 2
    gui.Enabled = true
    QTE_ACTIVE = true
    cursor.Position = UDim2.new(0, 0, 0, 0)
    currentAttempts = 0
    attemptLabel.Text = string.format("Attempt %d/%d", currentAttempts, MAX_ATTEMPTS)

    -- Store initial target and cursor sizes to reuse on miss
    local targetWidth = math.random(targetRange[1], targetRange[2])
    local cursorWidth = math.random(5, 15)
    local targetPosition

    local function setupTargetZone()
        targetZone.Size = UDim2.new(0, targetWidth, 1, 0)
        targetPosition = UDim2.new(0, math.random(0, qteFrame.AbsoluteSize.X - targetWidth), 0, 0)
        targetZone.Position = targetPosition
    end

    local function startAttempt()
        cursor.Size = UDim2.new(0, cursorWidth, 1, 0)
        cursor.Position = UDim2.new(0, 0, 0, 0)
        local startTime = tick()
        moveConn = RunService.RenderStepped:Connect(function()
            if not QTE_ACTIVE then moveConn:Disconnect() return end
            local progress = math.clamp((tick() - startTime) / (timeLimit / cursorSpeed), 0, 1)
            cursor.Position = UDim2.new(0, qteFrame.AbsoluteSize.X * progress, 0, 0)
            if progress >= 1 then
                moveConn:Disconnect()
                -- Do not increment currentAttempts on miss
                -- Reuse same target zone and cursor sizes
                targetZone.Position = targetPosition -- Restore original position
                cursor.Position = UDim2.new(0, 0, 0, 0)
                startAttempt() -- Restart with same config
            end
        end)
    end

    setupTargetZone()
    startAttempt()

    inputConn = UIS.InputBegan:Connect(function(input, processed)
        if processed or not QTE_ACTIVE then return end
        if input.KeyCode == Enum.KeyCode.Space then
            local cursorX = cursor.AbsolutePosition.X
            local targetX = targetZone.AbsolutePosition.X
            local targetEnd = targetX + targetZone.AbsoluteSize.X
            local passed = cursorX >= targetX and cursorX <= targetEnd
            currentAttempts += 1
            attemptLabel.Text = string.format("Attempt %d/%d", currentAttempts, MAX_ATTEMPTS)
            if passed or currentAttempts >= MAX_ATTEMPTS then
                QTE_ACTIVE = false
                gui.Enabled = false
                moveConn:Disconnect()
                inputConn:Disconnect()
                callback(passed, currentAttempts, MAX_ATTEMPTS)
            else
                moveConn:Disconnect()
                cursor.Position = UDim2.new(0, 0, 0, 0)
                targetZone.Position = targetPosition -- Restore original position
                startAttempt() -- Restart with same config
            end
        end
    end)
end


return QTEService
