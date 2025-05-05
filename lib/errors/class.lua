local utils = requireC "lib.utils"
local config = requireC "lib.errors.config"

---@class CalidErrors
---@field errors table<string, string>
local CalidErrors = {}
CalidErrors.__index = CalidErrors ---@private

---Creates a new CalidErrors instance for a specific type.
---@param errorType string
---@return CalidErrors
function CalidErrors:new(errorType)
    local class = setmetatable({}, CalidErrors)

    class.errors = utils.deepClone(config.generic)

    if config[errorType] then
        for code, message in pairs(config[errorType]) do
            class.errors[code] = message
        end
    end

    return class
end

---Sets a custom error message for a specific error code.
---@param errorCode string
---@param customError string
function CalidErrors:setMessage(errorCode, customError)
    assert(self.errors[errorCode] ~= nil, ("Unknown error code: %s"):format(errorCode))

    self.errors[errorCode] = customError
end

---@class CalidError
---@field code string
---@field message string

---Gets a formatted error message for a specific error code.
---@param errorCode string
---@param ... any Optional values to format the error message.
---@return CalidError
function CalidErrors:getMessage(errorCode, ...)
    assert(self.errors[errorCode] ~= nil, ("Unknown error code: %s"):format(errorCode))

    return {
        code = errorCode,
        message = self.errors[errorCode]:format(...)
    }
end

return CalidErrors