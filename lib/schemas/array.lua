local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors"

---@class CalidArray : CalidSchema
---@field type string
---@field validation table
---@field errors CalidErrors
local CalidArray = {}
CalidArray.__index = CalidArray ---@private

---Creates a new CalidArray schema.
---@private
---@alias CalidArrayOptions { required_error?: string, type_error?: string }
---@param schema CalidSchema
---@param options? CalidArrayOptions
---@return CalidArray
function CalidArray:new(schema, options)
    local _schema = setmetatable({}, CalidArray)

    _schema.type = "array"
    _schema.validation = {}
    _schema.validation.schema = schema

    _schema.errors = CalidErrors:new(_schema.type)

    if options?.required_error then
        _schema.errors:setMessage("required", options?.required_error)
    end

    if options?.type_error then
        _schema.errors:setMessage("type", options?.type_error)
    end

    return _schema
end

---Defines a default value.
---@param value any
---@return CalidArray
function CalidArray:default(value)
    self.validation.default = value

    return self
end

---Marks the field as optional.
---@return CalidArray
function CalidArray:optional()
    self.validation.optional = true

    return self
end

---Sets exact array length constraint.
---@param length integer
---@param options? { message?: string }
---@return CalidArray
function CalidArray:length(length, options)
    self.validation.length = length

    if options?.message then
        self.errors:setMessage("length", options?.message)
    end

    return self
end

---Sets minimum array length constraint.
---@param min integer
---@param options? { message?: string }
---@return CalidArray
function CalidArray:min(min, options)
    self.validation.min = min

    if options?.message then
        self.errors:setMessage("min", options?.message)
    end

    return self
end

---Sets maximum array length constraint.
---@param max integer
---@param options? { message?: string }
---@return CalidArray
function CalidArray:max(max, options)
    self.validation.max = max

    if options?.message then
        self.errors:setMessage("max", options?.message)
    end

    return self
end

---Parses and validates a value.
---@param value any
---@return { success: boolean, data?: table, error?: CalidError }
function CalidArray:parse(value)
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

    if type(value) ~= "table" or not utils.isArray(value) then
        return { success = false, error = self.errors:getMessage("type", self.type, type(value) == "table" and "object" or type(value)) }
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

    for i = 1, #value do
        local item = value[i]

        local result = self.validation.schema:parse(item)

        if not result.success then
            local err = result.error
            err.path = err.path and ("[%s].%s"):format(i, err.path) or ("[%s]"):format(i)
            return { success = false, error = err }
        end

        value[i] = result.data
    end

    return { success = true, data = value }
end

return CalidArray