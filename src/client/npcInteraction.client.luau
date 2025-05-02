local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QTEService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("qte"):WaitForChild("qteServices"))
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")

QTEEvent.OnClientEvent:Connect(function(npcConfig)
    print("NPC Type:", npcConfig)
    QTEService.startQTE(npcConfig.qteDifficulty, function(success)
        if success then
            print("PASS")
        else
            print("NOT PASS")
        end
    end)
end)

