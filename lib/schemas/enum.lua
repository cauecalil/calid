local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors.class"

---@class CalidEnum : CalidSchema
---@field type string
---@field validation table
---@field errors CalidErrors
local CalidEnum = {}
CalidEnum.__index = CalidEnum ---@private

---Creates a new CalidEnum schema.
---@private
---@alias CalidEnumOptions { required_error?: string, enum_error?: string }
---@param enum table
---@param options? CalidEnumOptions
---@return CalidEnum
function CalidEnum:new(enum, options)
    local schema = setmetatable({}, CalidEnum)

    schema.type = "enum"
    schema.validation = {}
    schema.validation.enum = enum

    schema.errors = CalidErrors:new(schema.type)

    if options?.required_error then
        schema.errors:setMessage("required", options?.required_error)
    end

    if options?.enum_error then
        schema.errors:setMessage("type", options?.enum_error)
    end

    return schema
end

---Defines a default value.
---@param value any
---@return CalidEnum
function CalidEnum:default(value)
    self.validation.default = value

    return self
end

---Marks the field as optional.
---@return CalidEnum
function CalidEnum:optional()
    self.validation.optional = true

    return self
end

---Parses and validates a value.
---@param value any
---@return { success: boolean, data?: any, error?: CalidError }
function CalidEnum:parse(value)
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

    for i = 1, #self.validation.enum do
        local option = self.validation.enum[i]

        if option == value then
            return { success = true, data = value }
        end
    end

    return { success = false, error = self.errors:getMessage("enum", table.concat(self.validation.enum, ", "), value) }
end

return CalidEnum