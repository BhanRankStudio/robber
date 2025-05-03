local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemGrade = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("enums"):WaitForChild("itemGrade"))

return {
    npcType = "normal",
    qteDifficulty = {
        targetZoneSizeRange = {30, 60},
        cursorSpeed = 1.0,
        timeLimit = 2.0,
        maxAttempts = 5,
    },
    maxOfDropItems = 3,
    typeDropRates = {
        [ItemGrade.COMMON] = 1,
    }
}