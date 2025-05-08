local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors"

---@class CalidString : CalidSchema
---@field type string
---@field validation table
---@field errors CalidErrors
local CalidString = {}
CalidString.__index = CalidString ---@private

---Creates a new CalidString schema.
---@private
---@alias CalidStringOptions { required_error?: string, type_error?: string }
---@param options? CalidStringOptions
---@return CalidString
function CalidString:new(options)
    local schema = setmetatable({}, CalidString)

    schema.type = "string"
    schema.validation = {}

    schema.errors = CalidErrors:new(schema.type)

    if options?.required_error then
        schema.errors:setMessage("required", options?.required_error)
    end

    if options?.type_error then
        schema.errors:setMessage("type", options?.type_error)
    end

    return schema
end

---Defines a default value.
---@param value any
---@return CalidString
function CalidString:default(value)
    self.validation.default = value

    return self
end

---Marks the field as optional.
---@return CalidString
function CalidString:optional()
    self.validation.optional = true

    return self
end

---Enables automatic type coercion
---@return CalidString
function CalidString:coerce()
    self.validation.coerce = true

    return self
end

---Sets exact string length constraint.
---@param length integer
---@param options? { message?: string }
---@return CalidString
function CalidString:length(length, options)
    self.validation.length = length

    if options?.message then
        self.errors:setMessage("length", options?.message)
    end

    return self
end

---Sets minimum string length constraint.
---@param min integer
---@param options? { message?: string }
---@return CalidString
function CalidString:min(min, options)
    self.validation.min = min

    if options?.message then
        self.errors:setMessage("min", options?.message)
    end

    return self
end

---Sets maximum string length constraint.
---@param max integer
---@param options? { message?: string }
---@return CalidString
function CalidString:max(max, options)
    self.validation.max = max

    if options?.message then
        self.errors:setMessage("max", options?.message)
    end

    return self
end

---Validates that the string starts with a specific prefix.
---@param string string
---@param options? { message?: string }
---@return CalidString
function CalidString:startsWith(string, options)
    self.validation.startsWith = string

    if options?.message then
        self.errors:setMessage("startsWith", options?.message)
    end

    return self
end

---Validates that the string ends with a specific suffix.
---@param string string
---@param options? { message?: string }
---@return CalidString
function CalidString:endsWith(string, options)
    self.validation.endsWith = string

    if options?.message then
        self.errors:setMessage("endsWith", options?.message)
    end

    return self
end

---Validates that the string includes a specific substring.
---@param string string
---@param options? { message?: string }
---@return CalidString
function CalidString:includes(string, options)
    self.validation.includes = string

    if options?.message then
        self.errors:setMessage("includes", options?.message)
    end

    return self
end

---Validates the string using a regular expression.
---@param regex string
---@param options? { message?: string }
---@return CalidString
function CalidString:regex(regex, options)
    self.validation.pattern = regex
    self.validation.patternType = "regex"

    if options?.message then
        self.errors:setMessage("regex", options?.message)
    end

    return self
end

---Validates the string as an email format.
---@param options? { message?: string }
---@return CalidString
function CalidString:email(options)
    self.validation.pattern = "^[%w%.%%+%-_]+@[%w%.%-_]+%.%a%a+$"
    self.validation.patternType = "email"

    if options?.message then
        self.errors:setMessage("email", options?.message)
    end

    return self
end

---Validates the string as a URL format.
---@param options? { message?: string }
---@return CalidString
function CalidString:url(options)
    self.validation.pattern = "^(https?)://[%w_.%-]+%.%w+(:%d+)?(/[%w._~!$&'()*+,;=:@%%-]*)?$"
    self.validation.patternType = "url"

    if options?.message then
        self.errors:setMessage("url", options?.message)
    end

    return self
end

---Validates the string as a UUID format.
---@param options? { message?: string }
---@return CalidString
function CalidString:uuid(options)
    self.validation.pattern = "^[0-9a-fA-F]{8}%-[0-9a-fA-F]{4}%-[1-5][0-9a-fA-F]{3}%-[89abAB][0-9a-fA-F]{3}%-[0-9a-fA-F]{12}$"
    self.validation.patternType = "uuid"

    if options?.message then
        self.errors:setMessage("uuid", options?.message)
    end

    return self
end

---Validates the string as a NanoID.
---@param options? { message?: string }
---@return CalidString
function CalidString:nanoid(options)
    self.validation.pattern = "^[A-Za-z0-9_-]{21}$"
    self.validation.patternType = "nanoid"

    if options?.message then
        self.errors:setMessage("nanoid", options?.message)
    end

    return self
end

---Validates the string as a CUID.
---@param options? { message?: string }
---@return CalidString
function CalidString:cuid(options)
    self.validation.pattern = "^c[0-9a-z]{24,}$"
    self.validation.patternType = "cuid"

    if options?.message then
        self.errors:setMessage("cuid", options?.message)
    end

    return self
end

---Validates the string as a CUID2.
---@param options? { message?: string }
---@return CalidString
function CalidString:cuid2(options)
    self.validation.pattern = "^c_[A-Za-z0-9_-]+$"
    self.validation.patternType = "cuid2"

    if options?.message then
        self.errors:setMessage("cuid2", options?.message)
    end

    return self
end

---Validates the string as a ULID.
---@param options? { message?: string }
---@return CalidString
function CalidString:ulid(options)
    self.validation.pattern = "^[0123456789ABCDEFGHJKMNPQRSTVWXYZ]{26}$"
    self.validation.patternType = "ulid"

    if options?.message then
        self.errors:setMessage("ulid", options?.message)
    end

    return self
end

---Validates the string as an IP address (IPv4 or IPv6).
---@param options? { message?: string }
---@return CalidString
function CalidString:ip(options)
    self.validation.pattern = "^([%d]+%.[%d]+%.[%d]+%.[%d]+)$|^([%x:]+)$"
    self.validation.patternType = "ip"

    if options?.message then
        self.errors:setMessage("ip", options?.message)
    end

    return self
end

---Validates the string as a CIDR notation.
---@param options? { message?: string }
---@return CalidString
function CalidString:cidr(options)
    self.validation.pattern = "^([%d]+%.[%d]+%.[%d]+%.[%d]+/%d+)$|^([%x:]+/%d+)$"
    self.validation.patternType = "cidr"

    if options?.message then
        self.errors:setMessage("cidr", options?.message)
    end

    return self
end

---Parses and validates a value.
---@param value any
---@return { success: boolean, data?: string, error?: CalidError }
function CalidString:parse(value)
    value = utils.deepClone(value)

    if value == nil and self.validation.default then
        if type(self.validation.default) == "function" then
            value = self.validation.default()
        else
            value = self.validation.default
        end
    end

    if value == nil then
        if self.validation.optional then
            return { success = true, data = nil }
        else
            return { success = false, error = self.errors:getMessage("required") }
        end
    end

    if self.validation.coerce and type(value) ~= self.type then
        value = tostring(value)
    end

    if type(value) ~= self.type then
        return { success = false, error = self.errors:getMessage("type", self.type, type(value)) }
    end

    if self.validation.length and #value ~= self.validation.length then
        return { success = false, error = self.errors:getMessage("length", self.validation.length) }
    end

    if self.validation.min and #value < self.validation.min then
        return { success = false, error = self.errors:getMessage("min", self.validation.min) }
    end

    if self.validation.max and #value > self.validation.max then
        return { success = false, error = self.errors:getMessage("max", self.validation.max) }
    end

    if self.validation.startsWith and value:sub(1, #self.validation.startsWith) ~= self.validation.startsWith then
        return { success = false, error = self.errors:getMessage("startsWith", self.validation.startsWith) }
    end

    if self.validation.endsWith and value:sub(- #self.validation.endsWith) ~= self.validation.endsWith then
        return { success = false, error = self.errors:getMessage("endsWith", self.validation.endsWith) }
    end

    if self.validation.includes and not value:find(self.validation.includes) then
        return { success = false, error = self.errors:getMessage("includes", self.validation.includes) }
    end

    if self.validation.pattern and not value:match(self.validation.pattern) then
        return { success = false, error = self.errors:getMessage(self.validation.patternType, self.validation.pattern) }
    end

    return { success = true, data = value }
end

return CalidString