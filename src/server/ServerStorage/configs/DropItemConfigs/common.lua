--[[
    -- DropRate: Sum of all drop rate can be more than 1.0 to be easy to add new items. When calculating the drop rate, it will be normalized to 1.0.
    -- EasyRate:
        -- less than 1 = Harder. for example, 0.5 = decrase target zone 50% of the default size
        -- 1.0: Normal (Default)
        -- more than 1 = Easier. for example, 2.0 = increase target zone 100% of the default size
    -- ItemPrice: The price of the item
    -- assetId: The asset id of the item image. It will be used to show the item image in the target zone.
        -- Geting this asset id from roblox studio   
]]

return {
    {
        Id = "CM_Book",
        Name = "Book",
        DropRate = 2.5,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Bread",
        Name = "Bread",
        DropRate = 3.2,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Chocolate_Milk",
        Name = "Chocolate Milk",
        DropRate = 4.0,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Flash_Drive",
        Name = "Flash Drive",
        DropRate = 2.0,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Key",
        Name = "Key",
        DropRate = 2.8,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Milk",
        Name = "Milk",
        DropRate = 3.5,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Banana",
        Name = "Banana",
        DropRate = 2.3,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Cig",
        Name = "Cig",
        DropRate = 3.0,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Cig_Pack",
        Name = "Cig Pack",
        DropRate = 2.7,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    },
    {
        Id = "CM_Sunglasses",
        Name = "Sunglasses",
        DropRate = 3.8,
        EasyRate = 1,
        assetId = "rbxassetid://140525813552947"
    }
}
