local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemGrade = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("enums"):WaitForChild("itemGrade"))

return {
    [ItemGrade.COMMON] = require(script:WaitForChild("common")),
    [ItemGrade.UNCOMMON] = require(script:WaitForChild("uncommon")),
    [ItemGrade.RARE] = require(script:WaitForChild("rare")),
    [ItemGrade.EPIC] = require(script:WaitForChild("epic")),
    [ItemGrade.LEGENDARY] = require(script:WaitForChild("legendary")),
    [ItemGrade.MYSTICAL] = require(script:WaitForChild("mystical")),
}