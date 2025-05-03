local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")


local npcServices = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("npc"):WaitForChild("npcServices"))
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")

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
                    QTEEvent:FireClient(player, allNPCs[uniqueId.Value])
                    npcServices.removeNPCFromAllNPCs(uniqueId.Value, allNPCs)
                else
                    warn("No UniqueID found in NPC model:", newNPC.Name)
                end
                newNPC:Destroy()
            end)
        end

    else
        warn("NPC model not found for type:", npcType)
    end
end

spawnerPrompt.Triggered:Connect(function(player)
    spawnNPC("normal")
end)