local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DropItemConfigs = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("configs"):WaitForChild("DropItemConfigs"))
local helperFunction = require(script.Parent:WaitForChild("function"))

local itemServices = {}

local function weightNormalizeProp(items)
    local normalizedItems = {}

    -- sum of all weights
    local totalWeight = helperFunction.foldl(function(acc, item)
        return acc + item.DropRate
    end, 0, items)

    -- normalize each item weight
    for _, item in ipairs(items) do
        local itemProps = item.DropRate / totalWeight
        local itemNormalized = table.clone(item)
        itemNormalized.DropRate = itemProps
        table.insert(normalizedItems, itemNormalized)
    end
    return normalizedItems
end

local function getRandomItemTypes(typeDropRates, maxItems)
    -- Create an array of item grades and their drop rates
    local itemGrades = {}
    local dropRates = {}
    
    -- Convert dictionary to arrays for selection
    for grade, rate in pairs(typeDropRates) do
        table.insert(itemGrades, grade)
        table.insert(dropRates, rate)
    end
    
    -- Normalize drop rates
    local totalRate = 0
    for _, rate in ipairs(dropRates) do
        totalRate = totalRate + rate
    end
    
    for i, rate in ipairs(dropRates) do
        dropRates[i] = rate / totalRate
    end
    
    -- Perform weighted random selection
    local selectedGrades = {}
    for i = 1, maxItems do
        local randomValue = math.random()
        local cumulativeWeight = 0
        
        for j, grade in ipairs(itemGrades) do
            cumulativeWeight = cumulativeWeight + dropRates[j]
            if randomValue <= cumulativeWeight then
                table.insert(selectedGrades, grade)
                break
            end
        end
    end
    
    return selectedGrades
end

local function countSameGradeItems(listOfGrades)
    local count = {}
    for _, grade in ipairs(listOfGrades) do
        if count[grade] then
            count[grade] = count[grade] + 1
        else
            count[grade] = 1
        end
    end
    return count
end

local function getRandomItems(numberOfItems, items)
    local selected = {}
    local availableItems = {table.unpack(items)} -- make a shallow copy

    for _ = 1, math.min(numberOfItems, #availableItems) do
        -- Calculate total DropRate
        local totalRate = 0
        for _, item in ipairs(availableItems) do
            totalRate += item.DropRate
        end

        -- Random roll
        local roll = math.random()
        local cumulative = 0
        local pickedIndex = nil

        for index, item in ipairs(availableItems) do
            cumulative += item.DropRate / totalRate
            if roll <= cumulative then
                pickedIndex = index
                break
            end
        end

        -- Pick the item and remove it to prevent duplicates
        if pickedIndex then
            table.insert(selected, availableItems[pickedIndex])
            table.remove(availableItems, pickedIndex)
        end
    end

    return selected
end

--[[
    @param npcConfig: table containing the NPC's drop configuration
    @return: [{
                       ["DropRate"] = 0.08333333333333334,
                       ["Grade"] = "COMMON",
                       ["Name"] = "Sunglasses"
            }]
]]
function itemServices.getDropItem(npcConfig)
    local dropItems = {}

    -- Random select type of item to drop
    local selectedItemGrades = getRandomItemTypes(npcConfig.typeDropRates, npcConfig.maxOfDropItems)
    
    -- Group types
    local groupedItemGrades = countSameGradeItems(selectedItemGrades)

    -- Random select item from each type
    for grade,count in pairs(groupedItemGrades) do
        local items = DropItemConfigs[grade]
        local itemsNormalized = weightNormalizeProp(items)
        print(itemsNormalized)
        local selectedItems = getRandomItems(count, itemsNormalized)

        for _, item in ipairs(selectedItems) do
            local itemClone = table.clone(item)
            itemClone.Grade = grade
            table.insert(dropItems, itemClone)
        end
    end

    return dropItems
end

return itemServices
