local calidParsers = requireCalid "lib/parsers"

---@class CalidOptionsConfigs
---@field type string The type of the schema ("string", "number", etc.)
---@field value any? Literal value for literal schemas
---@field enum table<integer, any>?
---@field object table<string | number, any>?
---@field array CalidOptions?
---@field min number? Minimum value/length (for number, string, array)
---@field max number? Maximum value/length (for number, string, array)
---@field int boolean? Integer-only enforcement for numbers
---@field positive boolean? Enforce positive numbers
---@field negative boolean? Enforce negative numbers
---@field length number? Exact length for strings
---@field startsWith string? Required prefix for strings
---@field endsWith string? Required suffix for strings
---@field regex string? Lua pattern for regex validation
---@field email string? Lua pattern for regex validation
---@field url string? Lua pattern for regex validation
---@field uuid string? Lua pattern for regex validation
---@field cuid string? Lua pattern for regex validation
---@field optional boolean?
---@field nullable boolean?
---@field default any? Default value if input is nil

---@class CalidOptions
---@field options {
---    type: string, -- The type of the schema ("string", "number", etc.)
---    value?: any, -- Literal value for literal schemas
---    enum?: any[], -- Allowed values for enum schemas
---    object?: table<string, CalidOptions>, -- Field validators for object schemas
---    array?: CalidOptions, -- Item validator for array schemas
---    min?: number, -- Minimum value (for numbers/arrays) or length (for strings)
---    max?: number, -- Maximum value (for numbers/arrays) or length (for strings)
---    int?: boolean, -- Integer-only numbers
---    positive?: boolean, -- Positive numbers only
---    negative?: boolean, -- Negative numbers only
---    length?: number, -- Exact string length
---    startsWith?: string, -- Required prefix
---    endsWith?: string, -- Required suffix
---    regex?: string, -- Lua pattern for validation
---    email?: string|boolean, -- Email pattern (or true for default)
---    url?: string|boolean, -- URL pattern (or true for default)
---    uuid?: string|boolean, -- UUID pattern (or true for default)
---    cuid?: string|boolean, -- CUID pattern (or true for default)
---    optional?: boolean, -- Allows nil values
---    nullable?: boolean, -- Explicitly allows nil values
---    default?: any, -- Default value when nil
---}
---@field parsers CalidParsers -- Parser functions for each type
---@field errorMessages? table<string, string> -- Custom error messages
local calidOptions = {}
calidOptions.__index = calidOptions

---Creates a new `CalidOptions` instance.
---@return CalidOptions
function calidOptions:new()
    return setmetatable({
        options = {},
        parsers = calidParsers:new(),
    }, self)
end

local DEFAULT_MESSAGES = {
    type = "Expected %s, got %s",
    literal = "Expected literal '%s', got '%s'",
    enum = "Value must be one of '%s'",
    min = "Number must be at least %s",
    max = "Number must be at most %s",
    length = "Must be exactly %s characters",
    minLength = "String must be at least %s characters",
    maxLength = "String must be at most %s characters",
    startsWith = "String must start with '%s'",
    endsWith = "String must end with '%s'",
    pattern = "Invalid format",
    int = "Must be an integer",
    positive = "Must be positive",
    negative = "Must be negative",
    regex = "String does not match pattern",
    email = "Invalid email address",
    url = "Invalid URL format",
    uuid = "Invalid UUID format",
    cuid = "Invalid CUID format",
    array = "Index %d: %s",
    arrayMin = "Array must have at least %d items",
    arrayMax = "Array must have at most %d items",
    object = "Field '%s': %s"
}

---Sets a custom error message for a given key.
---@param key string
---@param message string
function calidOptions:setErrorMessage(key, message)
    if not self.errorMessages then
        self.errorMessages = {}
    end

    self.errorMessages[key] = message
end

---Gets the error message for a given key, with formatting.
---@param key string
---@param ... any
---@return string
function calidOptions:getErrorMessage(key, ...)
    if self.errorMessages and self.errorMessages[key] then
        return (self.errorMessages[key]):format(...)
    end

    local default = DEFAULT_MESSAGES[key]
    if type(default) == "table" then
        default = default[self.options.type] or default.default
    end

    return (default or "Validation error: %s"):format(...)
end

---Sets the minimum value or length.
---@param min number
---@param message? string
---@return CalidOptions
function calidOptions:min(min, message)
    self.options.min = min

    if message then
        if self.options.type == "string" then
            self:setErrorMessage("minLength", message)
        elseif self.options.type == "array" then
            self:setErrorMessage("arrayMin", message)
        else
            self:setErrorMessage("min", message)
        end
    end

    return self
end

---Sets the maximum value or length.
---@param max number
---@param message? string
---@return CalidOptions
function calidOptions:max(max, message)
    self.options.max = max

    if message then
        if self.options.type == "string" then
            self:setErrorMessage("maxLength", message)
        elseif self.options.type == "array" then
            self:setErrorMessage("arrayMax", message)
        else
            self:setErrorMessage("max", message)
        end
    end

    return self
end

---Requires an integer.
---@param message? string
---@return CalidOptions
function calidOptions:int(message)
    self.options.int = true

    if message then
        self:setErrorMessage("int", message)
    end

    return self
end

---Requires a positive number.
---@param message? string
---@return CalidOptions
function calidOptions:positive(message)
    self.options.positive = true

    if message then
        self:setErrorMessage("positive", message)
    end

    return self
end

---Requires a negative number.
---@param message? string
---@return CalidOptions
function calidOptions:negative(message)
    self.options.negative = true

    if message then
        self:setErrorMessage("negative", message)
    end

    return self
end

---Requires an exact length.
---@param length number
---@param message? string
---@return CalidOptions
function calidOptions:length(length, message)
    self.options.length = length

    if message then
        self:setErrorMessage("length", message)
    end

    return self
end

---Requires string to start with a prefix.
---@param prefix string
---@param message? string
---@return CalidOptions
function calidOptions:startsWith(prefix, message)
    self.options.startsWith = prefix

    if message then
        self:setErrorMessage("startsWith", message)
    end

    return self
end

---Requires string to end with a suffix.
---@param suffix string
---@param message? string
---@return CalidOptions
function calidOptions:endsWith(suffix, message)
    self.options.endsWith = suffix

    if message then
        self:setErrorMessage("endsWith", message)
    end

    return self
end

---Validates with a regex pattern.
---@param pattern string
---@param message? string
---@return CalidOptions
function calidOptions:regex(pattern, message)
    self.options.regex = pattern

    if message then
        self:setErrorMessage("regex", message)
    end

    return self
end

---Requires a valid email format.
---@param message? string
---@return CalidOptions
function calidOptions:email(message)
    self.options.email = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+%.[a-zA-Z]{2,}$"

    if message then
        self:setErrorMessage("email", message)
    end

    return self
end

---Requires a valid URL format.
---@param message? string
---@return CalidOptions
function calidOptions:url(message)
    self.options.url = "^https?://.+"

    if message then
        self:setErrorMessage("url", message)
    end

    return self
end

---Requires a valid UUID format.
---@param message? string
---@return CalidOptions
function calidOptions:uuid(message)
    self.options.uuid = "^[%x]+%-%x+%-%x+%-%x+%-%x+$"

    if message then
        self:setErrorMessage("uuid", message)
    end

    return self
end

---Requires a valid CUID format.
---@param message? string
---@return CalidOptions
function calidOptions:cuid(message)
    self.options.cuid = "^c[a-z0-9]{8,}$"

    if message then
        self:setErrorMessage("cuid", message)
    end

    return self
end

---Marks the field as optional.
---@return CalidOptions
function calidOptions:optional()
    self.options.optional = true

    return self
end

---Marks the field as nullable.
---@return CalidOptions
function calidOptions:nullable()
    self.options.nullable = true

    return self
end

---Sets a default value.
---@param value any
---@return CalidOptions
function calidOptions:default(value)
    self.options.default = value

    return self
end

---Parses and validates the value using the configured options.
---@param value any
---@return any|nil, string? Error message if invalid
function calidOptions:parse(value)
    if value == nil and self.options.default ~= nil then
        value = self.options.default
    end

    local parser = self.parsers[self.options.type]
    if not parser then error(("No parser for type: %s"):format(self.options.type)) end

    local ok, err = parser(self, value)
    if not ok then return nil, err end

    return value
end

return calidOptions