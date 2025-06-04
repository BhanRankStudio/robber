
local ItemGrade = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("enums"):WaitForChild("itemGrade"))

return {
    npcType = "uncommon",
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