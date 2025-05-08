local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors"

---@class CalidNumber
---@field type string
---@field validation table
---@field errors CalidErrors
local CalidNumber = {}
CalidNumber.__index = CalidNumber ---@private

---Creates a new CalidNumber schema.
---@private
---@alias CalidNumberOptions { required_error?: string, type_error?: string }
---@param options? CalidNumberOptions
---@return CalidNumber
function CalidNumber:new(options)
    local _self = setmetatable({}, CalidNumber)

    _self.type = "number"
    _self.validation = {}

    _self.errors = CalidErrors:new(_self.type)

    if options then
        if options.required_error then
            _self.errors:setMessage("required", options.required_error)
        end

        if options.type_error then
            _self.errors:setMessage("type", options.type_error)
        end
    end

    return _self
end

---Defines a default value.
---@param value any
---@return CalidNumber
function CalidNumber:default(value)
    self.validation.default = value

    return self
end

---Marks the field as optional.
---@return CalidNumber
function CalidNumber:optional()
    self.validation.optional = true

    return self
end

---Enables automatic type coercion
---@return CalidNumber
function CalidNumber:coerce()
    self.validation.coerce = true

    return self
end

---Validates the field as an integer.
---@param options? { message?: string }
---@return CalidNumber
function CalidNumber:int(options)
    self.validation.int = true

    if options?.message then
        self.errors:setMessage("int", options?.message)
    end

    return self
end

---Validates the field as a float.
---@param options? { message?: string }
---@return CalidNumber
function CalidNumber:float(options)
    self.validation.float = true

    if options?.message then
        self.errors:setMessage("float", options?.message)
    end

    return self
end

---Validates the field as positive.
---@param options? { message?: string }
---@return CalidNumber
function CalidNumber:positive(options)
    self.validation.positive = true

    if options?.message then
        self.errors:setMessage("positive", options?.message)
    end

    return self
end

---Validates the field as negative.
---@param options? { message?: string }
---@return CalidNumber
function CalidNumber:negative(options)
    self.validation.negative = true

    if options?.message then
        self.errors:setMessage("negative", options?.message)
    end

    return self
end

---Sets the minimum value constraint.
---@param min number
---@param options? { message?: string }
---@return CalidNumber
function CalidNumber:min(min, options)
    self.validation.min = min

    if options?.message then
        self.errors:setMessage("min", options?.message)
    end

    return self
end

---Sets the maximum value constraint.
---@param max number
---@param options? { message?: string }
---@return CalidNumber
function CalidNumber:max(max, options)
    self.validation.max = max

    if options?.message then
        self.errors:setMessage("max", options?.message)
    end

    return self
end

---Sets a multiple-of constraint.
---@param multipleOf number
---@param options? { message?: string }
---@return CalidNumber
function CalidNumber:multipleOf(multipleOf, options)
    self.validation.multipleOf = multipleOf

    if options?.message then
        self.errors:setMessage("multipleOf", options?.message)
    end

    return self
end

---Parses and validates a value.
---@param value any
---@return { success: boolean, data?: number, error?: CalidError }
function CalidNumber:parse(value)
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
        value = tonumber(value)
    end

    if type(value) ~= self.type then
        return { success = false, error = self.errors:getMessage("type", self.type, type(value)) }
    end

    if self.validation.int and value % 1 ~= 0 then
        return { success = false, error = self.errors:getMessage("int") }
    end

    if self.validation.float and value % 1 == 0 then
        return { success = false, error = self.errors:getMessage("float") }
    end

    if self.validation.positive and value <= 0 then
        return { success = false, error = self.errors:getMessage("positive") }
    end

    if self.validation.negative and value >= 0 then
        return { success = false, error = self.errors:getMessage("negative") }
    end

    if self.validation.min and value < self.validation.min then
        return { success = false, error = self.errors:getMessage("min", self.validation.min) }
    end

    if self.validation.max and value > self.validation.max then
        return { success = false, error = self.errors:getMessage("max", self.validation.max) }
    end

    if self.validation.multipleOf and value % self.validation.multipleOf == 0 then
        return { success = false, error = self.errors:getMessage("multipleOf", self.validation.multipleOf) }
    end

    return { success = true, data = value }
end

return CalidNumber