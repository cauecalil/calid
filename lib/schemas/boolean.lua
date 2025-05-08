local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors"

---@class CalidBoolean : CalidSchema
---@field type string
---@field validation table
---@field errors CalidErrors
local CalidBoolean = {}
CalidBoolean.__index = CalidBoolean ---@private

---Creates a new CalidBoolean schema.
---@private
---@alias CalidBooleanOptions { required_error?: string, type_error?: string }
---@param options? CalidBooleanOptions
---@return CalidBoolean
function CalidBoolean:new(options)
    local schema = setmetatable({}, CalidBoolean)

    schema.type = "boolean"
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
---@return CalidBoolean
function CalidBoolean:default(value)
    self.validation.default = value

    return self
end

---Marks the field as optional.
---@return CalidBoolean
function CalidBoolean:optional()
    self.validation.optional = true

    return self
end

---Enables automatic type coercion
---@return CalidBoolean
function CalidBoolean:coerce()
    self.validation.coerce = true

    return self
end

---Parses and validates a value.
---@param value any
---@return { success: boolean, data?: boolean, error?: CalidError }
function CalidBoolean:parse(value)
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
        if type(value) == "string" then
            value = value:lower()

            if value == "true" or value == "1" then
                value = true
            elseif value == "false" or value == "0" then
                value = false
            end
        elseif type(value) == "number" then
            value = value ~= 0
        end
    end

    if type(value) ~= self.type then
        return { success = false, error = self.errors:getMessage("type", self.type, type(value)) }
    end

    return { success = true, data = value }
end

return CalidBoolean