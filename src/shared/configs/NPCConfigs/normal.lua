local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemGrade = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("enums"):WaitForChild("itemGrade"))

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