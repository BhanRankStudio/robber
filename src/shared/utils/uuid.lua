local uuidService = {}

local HttpService = game:GetService("HttpService")

-- Generate a standard UUID using HttpService
function uuidService.generate()
    return HttpService:GenerateGUID(false)
end

-- Generate a UUID without braces
function uuidService.generateWithoutBraces()
    return HttpService:GenerateGUID(true)
end

-- Generate a shorter version of a UUID (first 8 characters)
function uuidService.generateShort()
    local uuid = uuidService.generateWithoutBraces()
    return string.sub(uuid, 1, 8)
end

-- Check if a string is a valid UUID
function uuidService.isValid(uuid)
    if type(uuid) ~= "string" then
        return false
    end
    
    -- Check for standard UUID format with braces
    if string.match(uuid, "^%{%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%}$") then
        return true
    end
    
    -- Check for UUID format without braces
    if string.match(uuid, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
        return true
    end
    
    return false
end

return uuidService
