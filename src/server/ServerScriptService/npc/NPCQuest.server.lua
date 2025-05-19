local ReplicateStorage = game:GetService("ReplicatedStorage")
local QuestAccepted = ReplicateStorage:WaitForChild("Remotes"):WaitForChild("Quest"):WaitForChild("QuestAccepted")
local QuestData = {
	["TutorialQuest"] = {
		Description = "Catch 1 chicken for the NPC.",
		Required = "CatchChicken",
	},
	["QuestFromPromt1"] = {
        Description = "Talk to the NPC to start your journey.",
        Required = "TalkToNPC",
    },

	-- Add more quests here
}

QuestAccepted.OnServerEvent:Connect(function(player, questName)
	local statusFolder = ReplicateStorage:WaitForChild("QuestStatus")

	print("QuestAccepted event triggered by player:", player.Name)
	print("Quest name:", questName)

	local playerFolder = statusFolder:FindFirstChild(tostring(player.UserId))
	if not playerFolder then
		playerFolder = Instance.new("Folder")
		playerFolder.Name = tostring(player.UserId)
		playerFolder.Parent = statusFolder
	end

	if not playerFolder:FindFirstChild(questName) then
		local questStatus = Instance.new("BoolValue")
		questStatus.Name = questName
		questStatus.Value = false
		questStatus.Parent = playerFolder

		-- Store quest objective (optional)
		local objectiveValue = Instance.new("StringValue")
		objectiveValue.Name = questName .. "_Objective"
		objectiveValue.Value = QuestData[questName] and QuestData[questName].Description or "Objective unknown"
		objectiveValue.Parent = playerFolder
	end
end)
