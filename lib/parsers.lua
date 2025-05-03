local utils = requireCalid "lib/utils"

---@class CalidParsers
local calidParsers = {}
calidParsers.__index = calidParsers

---Creates a new CalidParsers instance.
---@return CalidParsers
function calidParsers:new()
    return setmetatable({}, self)
end

---Validates a literal value.
---@param self CalidOptions
---@param value any
---@return boolean, string?
function calidParsers:literal(value)
    if value ~= self.options.value then
        return false, self:getErrorMessage("literal", tostring(self.options.value), tostring(value))
    end

    return true
end

---Validates a boolean value.
---@param self CalidOptions
---@param value any
---@return boolean, string?
function calidParsers:boolean(value)
    if value == nil then
        if self.options.optional or self.options.nullable then
            return self.options.default or nil
        end

        return false, self:getErrorMessage("type", "boolean", "nil")
    end

    if type(value) ~= "boolean" then
        return false, self:getErrorMessage("type", "boolean", type(value))
    end

    return true
end

---Validates a number value.
---@param self CalidOptions
---@param value any
---@return boolean, string?
function calidParsers:number(value)
    if value == nil then
        if self.options.optional or self.options.nullable then
            return self.options.default or nil
        end

        return false, self:getErrorMessage("type", "number", "nil")
    end

    if type(value) ~= "number" then
        return false, self:getErrorMessage("type", "number", type(value))
    end

    if self.options.int and value % 1 ~= 0 then
        return false, self:getErrorMessage("int")
    end

    if self.options.min and value < self.options.min then
        return false, self:getErrorMessage("min", self.options.min)
    end

    if self.options.max and value > self.options.max then
        return false, self:getErrorMessage("max", self.options.max)
    end

    if self.options.positive and value <= 0 then
        return false, self:getErrorMessage("positive")
    end

    if self.options.negative and value >= 0 then
        return false, self:getErrorMessage("negative")
    end

    return true
end

---Validates a string value.
---@param self CalidOptions
---@param value any
---@return boolean, string?
function calidParsers:string(value)
    if value == nil then
        if self.options.optional or self.options.nullable then
            return self.options.default or nil
        end

        return false, self:getErrorMessage("type", "string", "nil")
    end

    if type(value) ~= "string" then
        return false, self:getErrorMessage("type", "string", type(value))
    end

    if self.options.length and #value ~= self.options.length then
        return false, self:getErrorMessage("length", self.options.length)
    end

    if self.options.min and #value < self.options.min then
        return false, self:getErrorMessage("minLength", self.options.min)
    end

    if self.options.max and #value > self.options.max then
        return false, self:getErrorMessage("maxLength", self.options.max)
    end

    if self.options.regex and not value:match(self.options.regex) then
        return false, self:getErrorMessage("regex")
    end

    if self.options.email and not value:match(self.options.email) then
        return false, self:getErrorMessage("email")
    end

    if self.options.url and not value:match(self.options.url) then
        return false, self:getErrorMessage("url")
    end

    if self.options.uuid and not value:match(self.options.uuid) then
        return false, self:getErrorMessage("uuid")
    end

    if self.options.cuid and not value:match(self.options.cuid) then
        return false, self:getErrorMessage("cuid")
    end

    if self.options.startsWith and value:sub(1, #self.options.startsWith) ~= self.options.startsWith then
        return false, self:getErrorMessage("startsWith", self.options.startsWith)
    end

    if self.options.endsWith and value:sub(- #self.options.endsWith) ~= self.options.endsWith then
        return false, self:getErrorMessage("endsWith", self.options.endsWith)
    end

    if self.options.int and (not tonumber(value) or tonumber(value) % 1 ~= 0) then
        return false, self:getErrorMessage("int")
    end

    return true
end

---Validates that the value is in a specified set.
---@param self CalidOptions
---@param value any
---@return boolean, string?
function calidParsers:enum(value)
    for i = 1, #self.options.enum do
        local option = self.options.enum[i]

        if option == value then
            return true
        end
    end

    return false, self:getErrorMessage("enum", table.concat(self.options.enum, ", "))
end

---Validates a table as an object with nested options.
---@param self CalidOptions
---@param value table<string | number, any>
---@return boolean, string?
function calidParsers:object(value)
    if value == nil then
        if self.options.optional or self.options.nullable then
            return self.options.default or nil
        end

        return false, self:getErrorMessage("type", "table", "nil")
    end

    if type(value) ~= "table" then
        return false, self:getErrorMessage("type", "table", type(value))
    end

    if utils.isArray(value) then
        return false, self:getErrorMessage("type", "object", "array")
    end

    for key, subs in pairs(self.options.object) do
        local field = value[key]

        if field == nil and subs.options.default ~= nil then
            field = subs.options.default
        end

        local ok, err = subs:parse(field)

        if not ok then
            return false, self:getErrorMessage("object", key, err)
        end
    end

    return true
end

---Validates a table as an array of items.
---@param self CalidOptions
---@param value table<integer, any>
---@return boolean, string?
function calidParsers:array(value)
    if value == nil then
        if self.options.optional or self.options.nullable then
            return self.options.default or nil
        end

        return false, self:getErrorMessage("type", "table", "nil")
    end

    if type(value) ~= "table" then
        return false, self:getErrorMessage("type", "table", type(value))
    end

    if not utils.isArray(value) then
        return false, self:getErrorMessage("type", "array", "object")
    end

    if self.options.min and #value < self.options.min then
        return false, self:getErrorMessage("arrayMin", self.options.min)
    end

    if self.options.max and #value > self.options.max then
        return false, self:getErrorMessage("arrayMax", self.options.max)
    end

    for i = 1, #value do
        local item = value[i]

        if item == nil and self.options.array.default ~= nil then
            item = self.options.array.default
        end

        local ok, err = self.options.array:parse(item)

        if not ok then
            return false, self:getErrorMessage("array", i, err)
        end
    end

    return true
end

return calidParsers