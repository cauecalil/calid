local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors"

---@class CalidEnum
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
    local _self = setmetatable({}, CalidEnum)

    _self.type = "enum"
    _self.validation = {}
    _self.validation.enum = enum

    _self.errors = CalidErrors:new(_self.type)

    if options then
        if options.required_error then
            _self.errors:setMessage("required", options.required_error)
        end

        if options.enum_error then
            _self.errors:setMessage("enum", options.enum_error)
        end
    end

    return _self
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