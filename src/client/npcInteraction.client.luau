local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QTEService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("qte"):WaitForChild("qteServices"))
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")

QTEEvent.OnClientEvent:Connect(function(npcConfig)
    QTEService.startQTE(npcConfig, function(success, hitItem)
        if success and hitItem then
            print("Player picked up:", hitItem)
        else
            print("QTE failed or no item picked")
        end
    end)
end)

