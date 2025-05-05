local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")


local npcServices = require(ServerStorage:WaitForChild("npcServices"):WaitForChild("npcServices"))
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")
local QTEResult = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEResult")
local helperFunction = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("function"))

local spawnerPart = Workspace:WaitForChild("spawnNPC")
local spawnerPrompt = spawnerPart:WaitForChild("ProximityPrompt")

local allNPCs = {} -- This will hold all spawned NPCs

local function spawnNPC(npcType)
    local npcModel = npcServices.findNPCModel(npcType)
    if npcModel then
        -- npc creation process
        local newNPC = npcServices.cloneNPCModelWithUniqueIdentifier(npcModel)
        npcServices.addNewNPCToAllNPCs(newNPC, allNPCs)
        npcServices.generateNPCInfomation(newNPC, allNPCs)

        newNPC.Parent = Workspace
        newNPC:SetPrimaryPartCFrame(spawnerPart.CFrame)

        local prompt = newNPC:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            prompt.Triggered:Connect(function(player)
                -- destroy the NPC when interacted with
                local uniqueId = newNPC:FindFirstChild("UniqueID")
                if uniqueId and uniqueId:IsA("StringValue") then
                    QTEEvent:FireClient(player, allNPCs[uniqueId.Value], newNPC)
                else
                    warn("No UniqueID found in NPC model:", newNPC.Name)
                end
            end)
        end

    else
        warn("NPC model not found for type:", npcType)
    end
end

QTEResult.OnServerEvent:Connect(function(player, npcConfig ,hitItem,npcModel)
    local npcId = npcConfig.id
    local npc = allNPCs[npcId]

    -- update droppedItems related to hitItem
    if npc and hitItem then
        -- edit item in droppedItems that matches hiwItemId
        for idx, item in ipairs(npc.droppedItems) do
            if item.Id == hitItem.Id then
                allNPCs[npcId].droppedItems[idx].isPickable = false

                -- remove the NPC If all items are not pickable
                local pickable = helperFunction.filter(function(item)
                    return item.isPickable == true
                end, allNPCs[npcId].droppedItems)
                if #pickable == 0 then
                    npcServices.removeNPCFromAllNPCs(npcId, allNPCs)
                    npcModel:Destroy()
                end
                break
            end
        end

    end
end)

spawnerPrompt.Triggered:Connect(function(player)
    spawnNPC("normal")
end)