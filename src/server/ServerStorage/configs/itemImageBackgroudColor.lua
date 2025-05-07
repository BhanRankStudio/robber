local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemGrade = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("enums"):WaitForChild("itemGrade"))

return {
    [ItemGrade.COMMON] = Color3.fromRGB(255, 255, 255), -- White
    [ItemGrade.RARE] = Color3.fromRGB(0, 0, 255), -- Blue
    [ItemGrade.EPIC] = Color3.fromRGB(255, 0, 255), -- Purple
    [ItemGrade.LEGENDARY] = Color3.fromRGB(255, 215, 0), -- Gold
}