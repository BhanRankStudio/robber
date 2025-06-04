local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemGrade = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("enums"):WaitForChild("itemGrade"))

--[[
    -- npcType should be matched with the "StringValue" named "NPCType" in the NPC model
    -- qteDifficulty
        -- cursorSpeed: Speed of the cursor in the QTE
        -- timeLimit: Time limit for the QTE in seconds
        -- maxAttempts: Maximum number of attempts allowed for the QTE
    -- maxOfDropItems: Maximum number of items that can be dropped
    -- typeDropRates: Sum of all drop rate should not be more than 1.0
]]

return {
    npcType = "normal",
    qteDifficulty = {
        cursorSpeed = 1,
        timeLimit = 40,
        maxAttempts = 1,
    },
    maxOfDropItems = 2,
    typeDropRates = {
        [ItemGrade.COMMON] = 1,
    }
}