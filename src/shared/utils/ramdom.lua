
randomService = {}

randomService.getListDifferentInt = function(min, max, numberOfElements)
    local randomNumbers = {}
    local randomSet = {}

    -- Generate unique random numbers
    while #randomNumbers < numberOfElements do
        local randomNumber = math.random(min, max)
        if not randomSet[randomNumber] then
            table.insert(randomNumbers, randomNumber)
            randomSet[randomNumber] = true
        end
    end

    table.sort(randomNumbers, function(a, b)
        return a < b
    end)

    return randomNumbers
end

return randomService