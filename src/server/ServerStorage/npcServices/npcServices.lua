local npcServices = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NPCFolder = ServerStorage:WaitForChild("NPCs")

local uuidService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("uuid"))
local itemServices = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("item"))

function npcServices.findNPCModel(npcType)
    -- access to npcType folder
    local npcTypeFolder = NPCFolder:FindFirstChild(npcType)

    -- random one of the NPCs
    if npcTypeFolder then
        local npcModels = npcTypeFolder:GetChildren()
        if #npcModels > 0 then
            return npcModels[math.random(1, #npcModels)]
        else
            warn("No NPC models found for type:", npcType)
            return nil
        end
    else
        warn("NPC type folder not found:", npcType)
        return nil
    end
end

function npcServices.generateNPCInfomation(npcModel, npcList)
    local npcType = npcModel:FindFirstChild("NPCType")
    local npcConfiguration = require(ServerStorage:WaitForChild("configs"):WaitForChild("NPCConfigs"):FindFirstChild(npcType.Value))
    local droppedItems, lengthOfDroppedItem = itemServices.getDropItem(npcConfiguration)
    npcList[npcModel.UniqueID.Value].droppedItems = droppedItems
    npcList[npcModel.UniqueID.Value].lengthOfDroppedItem = lengthOfDroppedItem
    npcList[npcModel.UniqueID.Value].npcType = npcType.Value
    npcList[npcModel.UniqueID.Value].npcConfiguration = npcConfiguration
    npcList[npcModel.UniqueID.Value].id = npcModel.UniqueID.Value
end

function npcServices.cloneNPCModelWithUniqueIdentifier(npcModel)
    local clonedModel = npcModel:Clone()
    local uniqueId = Instance.new("StringValue")
    uniqueId.Name = "UniqueID"
    uniqueId.Value = uuidService.generateShort()
    uniqueId.Parent = clonedModel

    return clonedModel
end

function npcServices.addNewNPCToAllNPCs(npcModel, npcList, npcModelsList)
    local uniqueId = npcModel:FindFirstChild("UniqueID")
    if uniqueId and uniqueId:IsA("StringValue") then
        npcList[uniqueId.Value] = {}
        npcModelsList[uniqueId.Value] = npcModel
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

