
helperFunction = {}

function helperFunction.foldl(func, initialValue, items)
    local result = initialValue
    for _, item in ipairs(items) do
        result = func(result, item)
    end
    return result
end

function helperFunction.filter(func, items)
    local result = {}
    for _, item in ipairs(items) do
        if func(item) then
            table.insert(result, item)
        end
    end
    return result
end


return helperFunction