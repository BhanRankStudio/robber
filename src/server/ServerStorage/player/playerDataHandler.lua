

local PlayerDataHandler = {}

local playerDatas = {} -- Table to temporarily store player data for quick access

function PlayerDataHandler:Set(player, data)
	print(player)
	playerDatas[player.UserId] = data
end

function PlayerDataHandler:Get(player)
	return playerDatas[player.UserId]
end

function PlayerDataHandler:Remove(player)
	playerDatas[player.UserId] = nil
end

function PlayerDataHandler:Has(player)
	return playerDatas[player.UserId] ~= nil
end

return PlayerDataHandler