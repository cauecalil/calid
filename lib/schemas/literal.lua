local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors"

---@class CalidLiteral
---@field type string
---@field validation table
---@field errors CalidErrors
local CalidLiteral = {}
CalidLiteral.__index = CalidLiteral ---@private

---Creates a new CalidLiteral schema.
---@private
---@alias CalidLiteralOptions { required_error?: string, literal_error?: string }
---@param literal any
---@param options? CalidLiteralOptions
---@return CalidLiteral
function CalidLiteral:new(literal, options)
    local _self = setmetatable({}, CalidLiteral)

    _self.type = "literal"
    _self.validation = {}
    _self.validation.literal = literal

    _self.errors = CalidErrors:new(_self.type)

    if options then
        if options.required_error then
            _self.errors:setMessage("required", options.required_error)
        end

        if options.literal_error then
            _self.errors:setMessage("literal", options.literal_error)
        end
    end

    return _self
end

---Defines a default value.
---@param value any
---@return CalidLiteral
function CalidLiteral:default(value)
    self.validation.default = value

    return self
end

---Marks the field as optional.
---@return CalidLiteral
function CalidLiteral:optional()
    self.validation.optional = true

    return self
end

---Parses and validates a value.
---@param value any
---@return { success: boolean, data?: any, error?: CalidError }
function CalidLiteral:parse(value)
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

    if value ~= self.validation.literal then
        return { success = false, error = self.errors:getMessage("literal", self.validation.literal, value) }
    end

    return { success = true, data = value }
end

return CalidLiteral