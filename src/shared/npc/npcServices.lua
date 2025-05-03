local npcServices = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NPCFolder = ServerStorage:WaitForChild("NPCs")

local uuidService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("uuid"))
local itemServices = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("item"))

function npcServices.findNPCModel(npcType)
    for _, model in pairs(NPCFolder:GetChildren()) do
        if model:IsA("Model") then
            -- Look for a StringValue that identifies the NPC type
            local typeValue = model:FindFirstChild("NPCType")
            if typeValue and typeValue:IsA("StringValue") and typeValue.Value == npcType then
                return model
            end
        end
    end
    return nil -- Return nil if no matching model is found
end

function npcServices.generateNPCInfomation(npcModel, npcList)
    local npcType = npcModel:FindFirstChild("NPCType")
    local npcConfiguration = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("configs"):WaitForChild("NPCConfigs"):FindFirstChild(npcType.Value))
    local droppedItems, lenghtOfDropedItem = itemServices.getDropItem(npcConfiguration)
    npcList[npcModel.UniqueID.Value].droppedItems = droppedItems
    npcList[npcModel.UniqueID.Value].lenghtOfDropedItem = lenghtOfDropedItem
    npcList[npcModel.UniqueID.Value].npcType = npcType.Value
    npcList[npcModel.UniqueID.Value].npcConfiguration = npcConfiguration
end

function npcServices.cloneNPCModelWithUniqueIdentifier(npcModel)
    local clonedModel = npcModel:Clone()
    local uniqueId = Instance.new("StringValue")
    uniqueId.Name = "UniqueID"
    uniqueId.Value = uuidService.generateShort()
    uniqueId.Parent = clonedModel
    return clonedModel
end

function npcServices.addNewNPCToAllNPCs(npcModel, npcList)
    local uniqueId = npcModel:FindFirstChild("UniqueID")
    if uniqueId and uniqueId:IsA("StringValue") then
        npcList[uniqueId.Value] = {}
    else
        warn("No UniqueID found in cloned NPC model:", npcModel.Name)
    end
end

function npcServices.removeNPCFromAllNPCs(uniqueId, npcList)
    if npcList[uniqueId] then
        npcList[uniqueId] = nil
    else
        warn("No NPC found with UniqueID:", uniqueId)
    end
end

return npcServices

