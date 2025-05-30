local utils = requireC "lib.utils"
local CalidErrors = requireC "lib.errors"

---@class CalidObject
---@field type string
---@field validation table
---@field errors CalidErrors
local CalidObject = {}
CalidObject.__index = CalidObject ---@private

---Creates a new CalidObject schema.
---@private
---@alias CalidObjectOptions { required_error?: string, type_error?: string }
---@param object table<string, any>
---@param options? CalidObjectOptions
---@return CalidObject
function CalidObject:new(object, options)
    local _self = setmetatable({}, CalidObject)

    _self.type = "object"
    _self.validation = {}
    _self.validation.object = object

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
---@return CalidObject
function CalidObject:default(value)
    self.validation.default = value

    return self
end

---Marks the field as optional.
---@return CalidObject
function CalidObject:optional()
    self.validation.optional = true

    return self
end

---If you want to pass through unknown keys
---@return CalidObject
function CalidObject:passthrough()
    self.validation.passthrough = true

    return self
end

---Parses and validates a value.
---@param value any
---@return { success: boolean, data?: table, error?: CalidError }
function CalidObject:parse(value)
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

    if type(value) ~= "table" or utils.isArray(value) then
        return { success = false, error = self.errors:getMessage("type", self.type, type(value) == "table" and "array" or type(value)) }
    end

    if not self.validation.passthrough then
        value = utils.cleanFields(value, self.validation.object)
    end

    for key, schema in pairs(self.validation.object) do
        local result = schema:parse(value[key])

        if not result.success then
            local err = result.error
            err.path = err.path and ("%s.%s"):format(key, err.path) or key
            return { success = false, error = err }
        end

        value[key] = result.data
    end

    return { success = true, data = value }
end

return CalidObject