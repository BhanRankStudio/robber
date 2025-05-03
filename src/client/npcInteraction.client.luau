local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QTEService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("qte"):WaitForChild("qteServices"))
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")
local QTEResult = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEResult")

QTEEvent.OnClientEvent:Connect(function(npcConfig, npcModel)
    print("npc config", npcConfig)
    QTEService.startQTE(npcConfig, function(success, hitItem)
        if success and hitItem then
            QTEResult:FireServer(npcConfig , hitItem, npcModel)
        end
    end)
end)

