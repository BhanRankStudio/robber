local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local dialogRemotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Dialog")
local createDialogRemote = dialogRemotes:WaitForChild("createDialog")
local setDialogRemote = dialogRemotes:WaitForChild("setDialog")

-- Dialog GUI
local DialogGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DA")
local DialogFrame = DialogGui:WaitForChild("Frame")
local NPCName = DialogFrame:WaitForChild("NPCName"):WaitForChild("npcName") -- TextLabel
local NPCPic = DialogFrame:WaitForChild("NPCPic"):WaitForChild("npcDialogImage") -- ImageLabel
local DialogText = DialogFrame:WaitForChild("dialogTextFrame"):WaitForChild("dialog") -- TextLabel
local OptionButtons = DialogFrame:FindFirstChild("Options") -- Use FindFirstChild instead of WaitForChild

-- Hide dialog
local function hideDialog()
    DialogGui.Enabled = false
    DialogFrame.Visible = false
end

local function showNextPart(dialogData, currentPart)
    if currentPart <= #dialogData.Text then
        local fullText = dialogData.Text[currentPart]
        DialogText.Text = "" -- Clear the text before animating

        -- Coroutine to animate text word by word
        coroutine.wrap(function()
            local words = string.split(fullText, " ") -- Split the text into words
            for _, word in ipairs(words) do
                DialogText.Text = DialogText.Text .. word .. " " -- Append each word with a space
                task.wait(0.15) -- Delay between each word (adjust as needed)
            end
        end)()

        return currentPart + 1 --
    else
        -- All parts have been shown, display options or hide dialog
        if OptionButtons and dialogData.Options and #dialogData.Options > 0 then
            -- Clear previous options
            for _, button in pairs(OptionButtons:GetChildren()) do
                if button:IsA("TextButton") then
                    button:Destroy()
                end
            end

            -- Add new options
            for _, option in pairs(dialogData.Options) do
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 50)
                button.Text = option.Text
                button.Parent = OptionButtons

                -- Handle button click
                button.MouseButton1Click:Connect(function()
                    if option.IsQuest then
                        -- Handle quest logic here (optional)
                    end
                    if option.NextDialog then
                        setDialogRemote:FireServer(dialogData.DialogId, option.NextDialog)
                    else
                        hideDialog()
                    end
                end)
            end
        else
            -- No options available, hide the dialog
            hideDialog()
        end
        return nil -- Return nil to indicate the dialog has ended
    end
end
-- Show dialog
createDialogRemote.OnClientEvent:Connect(function(dialogData)
    if dialogData then
        -- Show the dialog GUI
        DialogGui.Enabled = true
        DialogFrame.Visible = true

        -- Update NPC name and picture
        NPCName.Text = dialogData.NPCName or "Unknown NPC"
        NPCPic.Image = dialogData.NPCImage or "rbxassetid://0" -- Default image if none provided
        local currentPart = 1
        -- Update dialog text
        currentPart = showNextPart(dialogData, currentPart)
        DialogFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if currentPart then
                    currentPart = showNextPart(dialogData, currentPart)
                end
            end
        end)
        
    end
end)