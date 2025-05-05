local CalidNumber = requireC "lib.schemas.number"
local CalidString = requireC "lib.schemas.string"
local CalidBoolean = requireC "lib.schemas.boolean"
local CalidObject = requireC "lib.schemas.object"
local CalidArray = requireC "lib.schemas.array"
local CalidLiteral = requireC "lib.schemas.literal"
local CalidEnum = requireC "lib.schemas.enum"

---@class CalidSchema

---@class CalidAPI
local CalidAPI = {}
CalidAPI.__index = CalidAPI ---@private

---Creates a new CalidAPI instance.
---@private
---@return CalidAPI
function CalidAPI:new()
    return setmetatable({ name = "calid" }, CalidAPI)
end

---Creates a new CalidNumber schema instance.
---@param options? CalidNumberOptions
---@return CalidNumber
function CalidAPI:number(options)
    return CalidNumber:new(options)
end

---Creates a new CalidString schema instance.
---@param options? CalidStringOptions
---@return CalidString
function CalidAPI:string(options)
    return CalidString:new(options)
end

---Creates a new CalidBoolean schema instance.
---@param options? CalidBooleanOptions
---@return CalidBoolean
function CalidAPI:boolean(options)
    return CalidBoolean:new(options)
end

---Creates a new CalidObject schema instance.
---@param object table<string, any>
---@param options? CalidObjectOptions
---@return CalidObject
function CalidAPI:object(object, options)
    return CalidObject:new(object, options)
end

---Creates a new CalidArray schema instance.
---@param schema CalidSchema
---@param options? CalidArrayOptions
---@return CalidArray
function CalidAPI:array(schema, options)
    return CalidArray:new(schema, options)
end

---Creates a new CalidLiteral schema instance.
---@param literal any
---@param options? CalidLiteralOptions
---@return CalidLiteral
function CalidAPI:literal(literal, options)
    return CalidLiteral:new(literal, options)
end

---Creates a new CalidEnum schema instance.
---@param enum table
---@param options? CalidEnumOptions
---@return CalidEnum
function CalidAPI:enum(enum, options)
    return CalidEnum:new(enum, options)
end

return CalidAPI:new()