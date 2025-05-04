--[[
    -- DropRate: Sum of all drop rate can be more than 1.0 to be easy to add new items. When calculating the drop rate, it will be normalized to 1.0.
    -- EasyRate:
        -- less than 1 = Harder. for example, 0.5 = decrase target zone 50% of the default size
        -- 1.0: Normal (Default)
        -- more than 1 = Easier. for example, 2.0 = increase target zone 100% of the default size
    -- assetId: The asset id of the item image. It will be used to show the item image in the target zone.
        -- Geting this asset id from roblox studio   
]]
return {
    {
        Id = "CM_Cash",
        Name = "Cash",
        DropRate = 0.5,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Key",
        Name = "Key",
        DropRate = 0.5,
        EasyRate = 1,
        assetId = "rbxassetid://77506332916797"
    },
}