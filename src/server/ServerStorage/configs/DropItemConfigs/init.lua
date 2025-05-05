local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemGrade = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("enums"):WaitForChild("itemGrade"))

return {
    [ItemGrade.COMMON] = require(script:WaitForChild("commonItems")),
    [ItemGrade.RARE] = require(script:WaitForChild("rareItems"))
}