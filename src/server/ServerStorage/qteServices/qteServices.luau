local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local typeOfQTEMapToGuiName = require(ReplicatedStorage:WaitForChild('Shared'):WaitForChild('enums'):FindFirstChild("typeOfQTEMapToGuiName"))
local randomService = require(ReplicatedStorage:WaitForChild('Shared'):WaitForChild('utils'):WaitForChild('ramdom'))
local specialImage = require(ServerStorage:WaitForChild('configs'):WaitForChild('SpecialConfigs'):WaitForChild('specialImage'))

local QTEServerService = {}
local activeQTE = nil

-- Reusable function to add image to frame
local function addImageToFrame(frame, imageId)
    local imageLabel = frame:WaitForChild("Image")
    imageLabel.Image = imageId 
end

-- Improved target zone adjustment with a fixed base size
local function adjustTargetZoneSize(targetZone, difficultyLevel, enable)
    if not enable then
        targetZone.Size = UDim2.new(0, 0, 0, 0)
        return
    end

    local originalSize = targetZone.Size
    local originalPosition = targetZone.Position
    local originalSizeXScale = originalSize.X.Scale
    local originalPositionXScale = originalPosition.X.Scale

    local newSizeXScale = originalSizeXScale * difficultyLevel

    local diffOfOriginalSizeXScaleWithNewSizeXScale = originalSizeXScale - newSizeXScale
    local newPositionXScale = originalPositionXScale + (diffOfOriginalSizeXScaleWithNewSizeXScale / 2)

    targetZone.Size = UDim2.new(newSizeXScale, originalSize.Width, originalSize.Y.Scale, originalSize.Height)
    targetZone.Position = UDim2.new(newPositionXScale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset)
end

function QTEServerService.GetReadyQTE(player, config)
    -- Initialize config with defaults
    local lengthOfDroppedItem = config.lengthOfDroppedItem or 2
    local npcETQConfig = config.npcConfiguration.qteDifficulty
    local timeLimit = npcETQConfig.timeLimit
    local cursorSpeed = npcETQConfig.cursorSpeed
    local maxAttempts = npcETQConfig.maxAttempts
    
    -- Get correct UI based on item length
    local guiName = typeOfQTEMapToGuiName[5]
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

    -- if lengthOfDroppedItem less than #targetZones or #itemImageFrames, randomize where to drop

    -- Setup item images and map target zones to items
    local targetZoneToItem = {}
    local allTargetZones = targetZones:GetChildren()

    table.sort(allTargetZones, function(a, b)
        return a.Name < b.Name
    end)

    table.sort(itemImageFrames, function(a, b)
        return a.Name < b.Name
    end)
    
    if lengthOfDroppedItem ~= #allTargetZones then
        -- Randomize the target zones to drop items
        local randomNumbers = randomService.getListDifferentInt(1, #allTargetZones, lengthOfDroppedItem)

        -- add image to frame
        for idx, randomNumber in ipairs(randomNumbers) do
            local item = config.droppedItems[idx]
            addImageToFrame(itemImageFrames[randomNumber], item.assetId)
            adjustTargetZoneSize(allTargetZones[randomNumber], item.EasyRate, item.isPickable)

            -- Map target zones to items (assuming target zones are ordered similarly)
            local targetZone = allTargetZones[randomNumber]
            if targetZone then
                targetZoneToItem[targetZone.Name] = item
            end
        end

        -- add locked item to unused item image frames
        -- if idx of itemImageFrames is not in randomNumbers, add locked item to it
        for idx, itemImageFrame in ipairs(itemImageFrames) do
            if not table.find(randomNumbers, idx) then
                addImageToFrame(itemImageFrame, specialImage['lock'])
            end
        end

        -- adjust the rest of the target zones to be invisible
        for idx, targetZone in ipairs(allTargetZones) do
            if not table.find(randomNumbers, idx) then
                targetZone.Size = UDim2.new(0, 0, 0, 0)
            end
        end
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
        startTime = 0,
        timeLimit = timeLimit,
        cursorSpeed = cursorSpeed,
        cursor = cursor,
        targetZones = targetZones,
        qteFrame = qteFrame,
        movingRight = true,
        frameWidth = 0,
        qteStartTime = 0,
        targetZoneToItem = targetZoneToItem,
    }

    return activeQTE
end

return QTEServerService