
helperFunction = {}

function helperFunction.foldl(func, initialValue, items)
    local result = initialValue
    for _, item in ipairs(items) do
        result = func(result, item)
    end
    return result
end


return helperFunction