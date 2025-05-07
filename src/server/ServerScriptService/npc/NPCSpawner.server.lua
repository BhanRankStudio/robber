local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")


local QTEStart = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEStart")
local QTEServerService = require(ServerStorage:WaitForChild("qteServices"):WaitForChild("qteServices"))
local npcServices = require(ServerStorage:WaitForChild("npcServices"):WaitForChild("npcServices"))
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")
local QTEResult = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEResult")
local helperFunction = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("utils"):WaitForChild("function"))
local InventoryServices = require(ServerStorage:WaitForChild("inventoryServices"):WaitForChild("inventoryServices"))
local PlayerDataHandler = require(game.ServerStorage:WaitForChild("player"):WaitForChild("playerDataHandler"))

local spawnerPart = Workspace:WaitForChild("spawnNPC")
local spawnerPrompt = spawnerPart:WaitForChild("ProximityPrompt")

local allNPCs = {} -- This will hold all spawned NPCs infomation
local npcModels = {} -- This will hold all NPC models

local function spawnNPC(npcType)
    local npcModel = npcServices.findNPCModel(npcType)
    if npcModel then
        -- npc creation process
        local newNPC = npcServices.cloneNPCModelWithUniqueIdentifier(npcModel)
        npcServices.addNewNPCToAllNPCs(newNPC, allNPCs,npcModels)
        npcServices.generateNPCInfomation(newNPC, allNPCs)

        newNPC.Parent = Workspace
        newNPC:SetPrimaryPartCFrame(spawnerPart.CFrame)

        local prompt = newNPC:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            prompt.Triggered:Connect(function(player)
                -- destroy the NPC when interacted with
                local uniqueId = newNPC:FindFirstChild("UniqueID")
                if uniqueId and uniqueId:IsA("StringValue") then
                    QTEEvent:FireClient(player, allNPCs[uniqueId.Value])
                else
                    warn("No UniqueID found in NPC model:", newNPC.Name)
                end
            end)
        end

    else
        warn("NPC model not found for type:", npcType)
    end
end

QTEStart.OnServerEvent:Connect(function(player, npcConfig)
    -- prepare qte config to send to client to be rendered
    local qteInfo = QTEServerService.GetReadyQTE(player, npcConfig)

    -- fire client to start QTE
    QTEStart:FireClient(player, qteInfo, npcConfig)
end)

local function destroyNPC(id)
    local npcModel = npcModels[id]
    if npcModel then
        npcModel:Destroy()
        npcModels[id] = nil -- remove from the models list
    end
end

QTEResult.OnServerEvent:Connect(function(player, npcConfig ,hitItem)
    local npcId = npcConfig.id
    local npc = allNPCs[npcId]

    -- update droppedItems related to hitItem
    if npc and hitItem then
        -- edit item in droppedItems that matches hiwItemId
        for idx, item in ipairs(npc.droppedItems) do
            if item.Id == hitItem.Id then
                local playerData = PlayerDataHandler:Get(player)
                local numberOfItems = #playerData.items

                if numberOfItems >= playerData.inventorySlotMax then
                    return
                end

                allNPCs[npcId].droppedItems[idx].isPickable = false

                -- Randoom weight of that item
                hitItem.weight = math.random(1, 100)
                hitItem.toolId = hitItem.Name .. " " .. hitItem.weight .. " " .. "kg"

                -- add item to player backpack with image show
                InventoryServices.AddItem(player, hitItem)

                -- remove the NPC If all items are not pickable
                local pickable = helperFunction.filter(function(item)
                    return item.isPickable == true
                end, allNPCs[npcId].droppedItems)
                if #pickable == 0 then
                    npcServices.removeNPCFromAllNPCs(npcId, allNPCs)
                    destroyNPC(npcId)
                end
                break
            end
        end
    end
end)

spawnerPrompt.Triggered:Connect(function(player)
    spawnNPC("normal")
end)