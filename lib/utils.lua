---@class utils
local utils = {}

---Performs a deep clone of the given value. If it's a table, recursively copies its contents.
---@param value any
---@return any
function utils.deepClone(value)
    if type(value) ~= "table" then
        return value
    end

    local clone = {}

    for k, v in pairs(value) do
        clone[k] = utils.deepClone(v)
    end

    return clone
end

---Checks if a table is a numerically indexed array (with positive integer keys).
---@param tbl table
---@return boolean
function utils.isArray(tbl)
    local count = 0

    for k, _ in pairs(tbl) do
        if type(k) ~= "number" or k <= 0 or k % 1 ~= 0 then
            return false
        end
        count = count + 1
    end

    return count == #tbl
end

---Remove keys that are not in the schema.
---@param value table
---@param schema table<string, any>
---@return table
function utils.cleanFields(value, schema)
    local cleaned = {}

    for key, val in pairs(value) do
        local fieldSchema = schema[key]

        if fieldSchema then
            if fieldSchema.type == "object" and type(val) == "table" and not utils.isArray(val) then
                cleaned[key] = utils.cleanFields(val, fieldSchema.validation.object)
            elseif fieldSchema.type == "array" and type(val) == "table" and utils.isArray(val) then
                local subSchema = fieldSchema.validation.schema

                if subSchema and subSchema.type == "object" then
                    local arrayCleaned = {}

                    for i = 1, #val do
                        table.insert(arrayCleaned, utils.cleanFields(val[i], subSchema.validation.object))
                    end

                    cleaned[key] = arrayCleaned
                else
                    cleaned[key] = val
                end
            else
                cleaned[key] = val
            end
        end
    end

    return cleaned
end

return utils