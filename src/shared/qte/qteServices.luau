local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local typeOfQTEMapToGuiName = require(script.Parent.Parent:WaitForChild('enums'):FindFirstChild("typeOfQTEMapToGuiName"))
local specialImage = require(script.Parent.Parent:WaitForChild("configs"):WaitForChild("SpecialConfigs"):FindFirstChild("specialImage"))

local QTEService = {}
local activeQTE = nil

-- Reusable function to add image to frame
local function addImageToFrame(frame, imageId, isPickable)
    local imageLabel = frame:WaitForChild("Image")
    imageLabel.Image = isPickable and imageId or specialImage["lock"]
end

-- Improved target zone adjustment
local function adjustTargetZoneSize(targetZone, difficultyLevel, enable)

    if not enable then
        targetZone.Size = UDim2.new(0, 0, 0, 0)
        return
    end

    local originalSize = targetZone.Size
    local originalPosition = targetZone.Position
    
    -- Calculate center position
    local centerX = originalPosition.X.Scale + (originalPosition.X.Offset + originalSize.X.Offset / 2)
    
    -- Calculate new size based on difficulty
    local newSizeOffset = originalSize.X.Offset * difficultyLevel

    -- Calculate new position to maintain center alignment
    local newPositionOffset = centerX - (newSizeOffset / 2)
    
    -- Apply changes directly
    targetZone.Size = UDim2.new(originalSize.X.Scale, newSizeOffset, originalSize.Y.Scale, originalSize.Y.Offset)
    targetZone.Position = UDim2.new(originalPosition.X.Scale, newPositionOffset, originalPosition.Y.Scale, originalPosition.Y.Offset)
end

-- Improved cursor-in-target-zone check that checks all target zones
local function isCursorInAnyTargetZone(cursor, targetZones)
    local cursorStart = cursor.AbsolutePosition.X
    local cursorEnd = cursorStart + cursor.AbsoluteSize.X
    local cursorWidth = cursorEnd - cursorStart
    
    -- Check each target zone
    for _, targetZone in ipairs(targetZones:GetChildren()) do
        local targetStart = targetZone.AbsolutePosition.X
        local targetEnd = targetStart + targetZone.AbsoluteSize.X
        
        -- Calculate overlap
        local overlapStart = math.max(cursorStart, targetStart)
        local overlapEnd = math.min(cursorEnd, targetEnd)
        local overlapLength = math.max(0, overlapEnd - overlapStart)
        
        -- Consider it a hit if at least 40% of the cursor is inside the target zone
        local overlapPercentage = cursorWidth > 0 and (overlapLength / cursorWidth) or 0
        if overlapPercentage >= 0.4 then
            return true, targetZone
        end
    end
    
    return false, nil
end

-- Clean up function to properly dispose of resources
local function cleanupQTE()
    if activeQTE then
        if activeQTE.moveConn then
            activeQTE.moveConn:Disconnect()
        end
        if activeQTE.inputConn then
            activeQTE.inputConn:Disconnect()
        end
        if activeQTE.gui then
            activeQTE.gui:Destroy()
        end
        activeQTE = nil
    end
end

function QTEService.startQTE(config, callback)
    -- Clean up any existing QTE first
    cleanupQTE()
    
    -- Initialize config with defaults
    local lengthOfDroppedItem = config.lengthOfDroppedItem or 2
    local npcETQConfig = config.npcConfiguration.qteDifficulty
    local timeLimit = npcETQConfig.timeLimit
    local cursorSpeed = npcETQConfig.cursorSpeed
    local maxAttempts = npcETQConfig.maxAttempts
    
    -- Get correct UI based on item length
    local guiName = typeOfQTEMapToGuiName[lengthOfDroppedItem]
    if not guiName then
        warn("Invalid lengthOfDroppedItem or mapping missing for typeOfQTEMapToGuiName")
        return
    end
    
    -- Cache GUI elements
    local playerGui = player:WaitForChild("PlayerGui")
    local originalGui = playerGui:FindFirstChild(guiName)
    
    if not originalGui then
        warn("QTE GUI not found:", guiName)
        return
    end
    
    local gui = originalGui:Clone()
    gui.Parent = playerGui
    
    local mainFrame = gui:WaitForChild("Frame")
    local itemImageFrames = mainFrame:WaitForChild("ItemImages"):GetChildren()
    local qteFrame = mainFrame:WaitForChild("QTEFrame")
    local cursor = qteFrame:WaitForChild("Cursor")
    local targetZones = qteFrame:WaitForChild("TargetZones")
    
    -- Setup z-index for visuals (ensure cursor is on top)
    cursor.ZIndex = 3
    for _, child in ipairs(targetZones:GetChildren()) do
        child.ZIndex = 2
    end

    -- Setup item images and map target zones to items
    local targetZoneToItem = {}
    for idx, item in ipairs(config.droppedItems) do
        if idx <= #itemImageFrames then
            addImageToFrame(itemImageFrames[idx], item.assetId, item.isPickable)
        end
        -- Map target zones to items (assuming target zones are ordered similarly)
        local targetZone = targetZones:GetChildren()[idx]
        if targetZone then
            targetZoneToItem[targetZone] = item
        end
    end

    -- Show the GUI
    gui.Enabled = true
    
    -- Setup item images
    for idx, item in ipairs(config.droppedItems) do
        if idx <= #itemImageFrames then
            addImageToFrame(itemImageFrames[idx], item.assetId, item.isPickable)
        end
    end
    
    -- Adjust all target zones
    for idx, targetZone in ipairs(targetZones:GetChildren()) do
        local itemDifficultyLevel = config.droppedItems[idx].EasyRate
        print("itemDifficultyLevel", itemDifficultyLevel)
        if not config.droppedItems[idx].isPickable then
            adjustTargetZoneSize(targetZone, itemDifficultyLevel, false)
        end
        adjustTargetZoneSize(targetZone, itemDifficultyLevel,true)
    end
    
    -- Setup cursor
    local cursorWidth = math.random(5, 5)
    cursor.Size = UDim2.new(0, cursorWidth, 1, 0)
    cursor.Position = UDim2.new(0, 0, 0, 0)
    
    -- Create active QTE state
    activeQTE = {
        gui = gui,
        isActive = true,
        attempts = 0,
        maxAttempts = maxAttempts,
        cursorWidth = cursorWidth,
        startTime = tick(),
        timeLimit = timeLimit,
        cursorSpeed = cursorSpeed,
        cursor = cursor,
        targetZones = targetZones,
        qteFrame = qteFrame,
        movingRight = true,
        frameWidth = 0,
        qteStartTime = tick(),
        targetZoneToItem = targetZoneToItem,
    }

    -- Function to finish the QTE
    local function finishQTE(success,hitItem)
        if not activeQTE then return end
        
        activeQTE.isActive = false
        
        -- Clean up resources
        cleanupQTE()
        
        -- Call the callback with results
        if callback then
            callback(success,hitItem)
        end
    end
    
    -- Start cursor movement with back-and-forth motion
    activeQTE.moveConn = RunService.RenderStepped:Connect(function(deltaTime)
        if not activeQTE or not activeQTE.isActive then return end
        
        -- Check if time limit has been exceeded
        local totalElapsedTime = tick() - activeQTE.qteStartTime
        if totalElapsedTime >= timeLimit then
            finishQTE(false)
            return
        end
        
        -- Get frame width on first run
        if activeQTE.frameWidth == 0 then
            activeQTE.frameWidth = qteFrame.AbsoluteSize.X
        end
        
        local frameWidth = activeQTE.frameWidth
        local elapsed = tick() - activeQTE.startTime
        
        -- Cursor speed is independent of time limit
        local fullCycleTime = 2 / cursorSpeed -- One full back-and-forth cycle, adjusted by speed
        local normalizedTime = (elapsed % fullCycleTime) / fullCycleTime
        
        -- Calculate position based on direction
        local position
        if activeQTE.movingRight then
            position = normalizedTime * frameWidth
            if normalizedTime >= 0.99 then
                activeQTE.movingRight = false
                activeQTE.startTime = tick()
            end
        else
            position = frameWidth - (normalizedTime * frameWidth)
            if normalizedTime >= 0.99 then
                activeQTE.movingRight = true
                activeQTE.startTime = tick()
            end
        end
        
        -- Update cursor position
        cursor.Position = UDim2.new(0, position, 0, 0)
    end)
    
    -- Setup input handler
    activeQTE.inputConn = UIS.InputBegan:Connect(function(input, processed)
        if processed or not activeQTE or not activeQTE.isActive then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            -- Increment attempts on spacebar press
            activeQTE.attempts += 1
            
            -- Check if cursor is in ANY target zone
            local success, hitTargetZone = isCursorInAnyTargetZone(cursor, targetZones)
            local hitItem = success and activeQTE.targetZoneToItem[hitTargetZone] or nil
            
            -- End QTE if successful or max attempts reached
            if success then
                finishQTE(true,hitItem)
            elseif activeQTE.attempts >= maxAttempts then
                finishQTE(false,nil)
            end
        end
    end)
end

-- Ensure cleanup when the script is destroyed
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == player then
        cleanupQTE()
    end
end)

return QTEService