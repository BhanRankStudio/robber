
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local blurEffect = game.Lighting:FindFirstChild("Blur")

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

local function cleanupQTE(activeQTE)
    blurEffect.Enabled = false
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

local function finishQTE(success, hitItem, callback, activeQTE)
    if not activeQTE then return end
    
    activeQTE.isActive = false
    
    -- Clean up resources
    cleanupQTE(activeQTE)

    -- Call the callback with results
    if callback then
        callback(hitItem)
    end
end

function renderQTE(activeQTE, callback)
    -- show gui
    blurEffect.Enabled = true
    activeQTE.gui.Enabled = true

    activeQTE.qteStartTime = tick()
    activeQTE.startTime = tick()

    -- Start cursor movement with back-and-forth motion
    activeQTE.moveConn = RunService.RenderStepped:Connect(function(deltaTime)
        if not activeQTE or not activeQTE.isActive then return end
        

        -- Check if time limit has been exceeded
        local totalElapsedTime = tick() - activeQTE.qteStartTime
        if totalElapsedTime >= activeQTE.timeLimit then
            print("QTE failed due to time limit")
            finishQTE(false, nil, callback, activeQTE)
            return
        end

        -- Get frame width on first run
        if activeQTE.frameWidth == 0 then
            activeQTE.frameWidth = activeQTE.qteFrame.AbsoluteSize.X
        end
        
        local frameWidth = activeQTE.frameWidth
        local elapsed = tick() - activeQTE.startTime
        
        -- Cursor speed is independent of time limit
        local fullCycleTime = 2 / activeQTE.cursorSpeed -- One full back-and-forth cycle, adjusted by speed
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
        activeQTE.cursor.Position = UDim2.new(0, position, 0, 0)
    end)
    
    -- Setup input handler
    activeQTE.inputConn = UIS.InputBegan:Connect(function(input, processed)
        if processed or not activeQTE or not activeQTE.isActive then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            -- Increment attempts on spacebar press
            activeQTE.attempts += 1
            
            -- Check if cursor is in ANY target zone
            local success, hitTargetZone = isCursorInAnyTargetZone(activeQTE.cursor, activeQTE.targetZones)
            local hitItem = success and activeQTE.targetZoneToItem[hitTargetZone.Name] or nil

            -- End QTE if successful or max attempts reached
            if success then
                finishQTE(true, hitItem, callback, activeQTE)
            elseif activeQTE.attempts >= activeQTE.maxAttempts then
                finishQTE(false, nil, callback, activeQTE)
            end
        end
    end)
end

return renderQTE