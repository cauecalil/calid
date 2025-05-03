local calidOptions = requireCalid "lib/options"

---@class CalidConstructors
local calidConstructors = {}

---Creates a literal value validator.
---@param self any
---@param value any
---@param message? string Optional custom error message when validation fails
---@return CalidOptions
function calidConstructors:literal(value, message)
    local schema = calidOptions:new()

    schema.options.type = "literal"
    schema.options.value = value

    if message then
        schema:setErrorMessage("literal", message)
    end

    return schema
end

---Creates a validator for a boolean value.
---@param self? any
---@param message? string Optional custom error message when validation fails
---@return CalidOptions
function calidConstructors:boolean(message)
    local schema = calidOptions:new()

    schema.options.type = "boolean"

    if message then
        schema:setErrorMessage("type", message)
    end

    return schema
end

---Creates a validator for a number value.
---@param self? any
---@param message? string Optional custom error message when validation fails
---@return CalidOptions
function calidConstructors:number(message)
    local schema = calidOptions:new()

    schema.options.type = "number"

    if message then
        schema:setErrorMessage("type", message)
    end

    return schema
end

---Creates a validator for a string value.
---@param self? any
---@param message? string Optional custom error message when validation fails
---@return CalidOptions
function calidConstructors:string(message)
    local schema = calidOptions:new()

    schema.options.type = "string"

    if message then
        schema:setErrorMessage("type", message)
    end

    return schema
end

---Creates a validator that only accepts one of the specified values.
---@param self? any
---@param enum any[]
---@param message? string Optional custom error message when validation fails
---@return CalidOptions
function calidConstructors:enum(enum, message)
    local schema = calidOptions:new()

    schema.options.type = "enum"
    schema.options.enum = enum

    if message then
        schema:setErrorMessage("enum", message)
    end

    return schema
end

---Creates a validator for an array of validated items.
---@param self? any
---@param object CalidOptions
---@param messageType? string Optional custom error message when type validation fails
---@param messageObject? string Optional custom error message when a object element validation fails
---@return CalidOptions
function calidConstructors:object(object, messageType, messageObject)
    local schema = calidOptions:new()

    schema.options.type = "object"
    schema.options.object = object

    if messageType then
        schema:setErrorMessage("type", messageType)
    end

    if messageObject then
        schema:setErrorMessage("object", messageObject)
    end

    return schema
end

---Creates a validator for an object with validated fields.
---@param self? any
---@param array table<string, CalidOptions>
---@param messageType? string Optional custom error message when type validation fails
---@param messageArray? string Optional custom error message when a array element validation fails
---@return CalidOptions
function calidConstructors:array(array, messageType, messageArray)
    local schema = calidOptions:new()

    schema.options.type = "array"
    schema.options.array = array

    if messageType then
        schema:setErrorMessage("type", messageType)
    end

    if messageArray then
        schema:setErrorMessage("array", messageArray)
    end

    return schema
end

return calidConstructors