local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QTEEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEEvent")
local QTEResult = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEResult")
local QTEStart = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("QTEStart")
local QTERenderer = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("qte"):WaitForChild("renderQTE"))

QTEEvent.OnClientEvent:Connect(function(npcConfig)
    -- Send the NPC configuration to the server to returning QTE information
    QTEStart:FireServer(npcConfig)
end)

QTEStart.OnClientEvent:Connect(function(qteInfo, npcConfig)
    QTERenderer(qteInfo, function(hitItem)
        QTEResult:FireServer(npcConfig, hitItem)
    end)
end)

