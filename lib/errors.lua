local ERRORS_CONFIG = {
    ["generic"] = {
        required = "Required field is missing",
        type = "Expected %s, received %s",
    },
    ["number"] = {
        int = "Must be an integer",
        float = "Must be a float",
        positive = "Must be positive",
        negative = "Must be negative",
        min = "Must be at least %s",
        max = "Must be at most %s",
        multipleOf = "Must be multiple of %s",
    },
    ["string"] = {
        length = "Must be exactly %s characters",
        min = "Must be at least %s characters",
        max = "Must be at most %s characters",
        startsWith = "Must start with '%s'",
        endsWith = "Must end with '%s'",
        includes = "Must includes '%s'",
        regex = "Does not match pattern",
        email = "Invalid email address",
        url = "Invalid URL format",
        uuid = "Invalid UUID format",
        nanoid = "Invalid NANOID format",
        cuid = "Invalid CUID format",
        cuid2 = "Invalid CUID2 format",
        ulid = "Invalid ULID format",
        ip = "Invalid IP address",
        cidr = "Invalid CIDR address",
    },
    ["array"] = {
        length = "Must be exactly %s items",
        min = "Must be at least %s items",
        max = "Must be at most %s items",
    },
    ["literal"] = {
        literal = "Expected '%s', got '%s'",
    },
    ["enum"] = {
        enum = "Expected one of '%s', got '%s'",
    },
}

---@class CalidErrors
---@field messages table<string, string>
local CalidErrors = {}
CalidErrors.__index = CalidErrors

---Creates a new CalidErrors instance for a specific type.
---@param type string
---@return CalidErrors
function CalidErrors:new(type)
    local _self = setmetatable({}, CalidErrors)

    _self.messages = {}

    for code, message in pairs(ERRORS_CONFIG.generic) do
        _self.messages[code] = message
    end

    if ERRORS_CONFIG[type] then
        for code, message in pairs(ERRORS_CONFIG[type]) do
            _self.messages[code] = message
        end
    end

    return _self
end

---Sets a custom error message for a specific error code.
---@param code string
---@param message string
function CalidErrors:setMessage(code, message)
    assert(self.messages[code] ~= nil, ("Unknown error code: %s"):format(code))

    self.messages[code] = message
end

---@class CalidError
---@field code string
---@field message string

---Gets a formatted error message for a specific error code.
---@param code string
---@param ... any Optional values to format the error message.
---@return CalidError
function CalidErrors:getMessage(code, ...)
    assert(self.messages[code] ~= nil, ("Unknown error code: %s"):format(code))

    return {
        code = code,
        message = self.messages[code]:format(...)
    }
end

return CalidErrors