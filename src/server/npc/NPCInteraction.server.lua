local npcFolder = workspace:WaitForChild("NPCs")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")

local function onNPCInteracted(player, npcType)
    local npcConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("configs"):WaitForChild("NPCConfigs"):FindFirstChild(npcType))
    if not npcConfig then
        warn("NPC config not found for type:", npcType)
        return
    end
    QTEEvent:FireClient(player, npcConfig)
end

local function setupPrompt(npcModel)
    local prompt = npcModel:FindFirstChildWhichIsA("ProximityPrompt", true)
    local npcTypeValue = npcModel:FindFirstChild("NPCType")

    if prompt and npcTypeValue and npcTypeValue:IsA("StringValue") then
        prompt.Triggered:Connect(function(player)
            onNPCInteracted(player, npcTypeValue.Value)
        end)
    else
        warn("Missing ProximityPrompt or NPCType in:", npcModel.Name)
    end
end


-- Setup all NPCs at runtime
for _, npcModel in ipairs(npcFolder:GetChildren()) do
    if npcModel:IsA("Model") then
        setupPrompt(npcModel)
    end
end