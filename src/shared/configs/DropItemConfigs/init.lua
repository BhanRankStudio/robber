
local ItemGrade = require(script.Parent.Parent:WaitForChild("enums"):WaitForChild("itemGrade"))

return {
    [ItemGrade.COMMON] = require(script:WaitForChild("commonItems")),
    [ItemGrade.RARE] = require(script:WaitForChild("rareItems"))
}