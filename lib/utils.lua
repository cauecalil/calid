local utils = {}

function utils.isArray(table)
    local count = 0

    for k, _ in pairs(table) do
        if type(k) ~= "number" or k <= 0 or k % 1 ~= 0 then
            return false
        end
        count = count + 1
    end

    return count == #table
end

return utils