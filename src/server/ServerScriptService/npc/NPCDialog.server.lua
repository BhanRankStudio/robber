local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local dialogRemotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Dialog")
local createDialogRemote = dialogRemotes:WaitForChild("createDialog")
local setDialogRemote = dialogRemotes:WaitForChild("setDialog")

-- Dialog data (can be stored in a ModuleScript for better organization)
local Dialogs = {
    npc_dialog = {
        NPCName = "NPC Name Here", -- Name of the NPC
        NPCImage = "rbxassetid://1234567890", -- Asset ID of the NPC's image
        Text = { -- Dialog text split into parts
            "Hello, traveler!",
            "Can you help me?",
            "I need you to collect 10 apples."
        },
        Options = { -- Dialog options
            { Text = "Sure!", NextDialog = 2 },
            { Text = "No, sorry.", NextDialog = nil }
        }
    }
}

-- Get NPCs from the NPCs folder
local npcs = Workspace:WaitForChild("NPCs"):GetChildren()

for _, npc in pairs(npcs) do
    -- Check if the NPC has a DialogConfig folder
    local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        local dialogId = npc.DialogConfig:FindFirstChild("DialogId")
        
        if dialogId then
                prompt.Triggered:Connect(function(player)
                    local dialog = Dialogs[dialogId.Value]
                    
                    if dialog then
                        createDialogRemote:FireClient(player, dialog)
                    end
                end)
            
        else
            print("DialogId not found for NPC: " .. npc.Name)
        end
    end
end

-- Handle dialog progression
setDialogRemote.OnServerEvent:Connect(function(player, dialogId, dialogIndex)
    local dialog = Dialogs[dialogId]
    if dialog and dialog[dialogIndex] then
        createDialogRemote:FireClient(player, dialog[dialogIndex])
    end
end)