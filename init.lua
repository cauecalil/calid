assert(GetCurrentResourceName() ~= "calid")
assert(_VERSION:find("5.4"), "^1Lua 5.4 must be enabled in the resource manifest!^0")
assert(GetResourceState("calid") == "started", "^1calid must be started before this resource.^0")

local loaded, _require = {}, require
local package = {
    path = "./?.lua;./?/init.lua",
    preload = {},
    loaded = setmetatable({}, {
        __index = loaded,
        __newindex = function() end,
        __metatable = false
    })
}

local function loadModule(modName)
    local resource, fileName = "calid", modName:gsub("%.", "/")

    for template in package.path:gmatch("[^;]+") do
        local path = template:gsub("^%./", ""):gsub("?", fileName)
        local file = LoadResourceFile(resource, path)

        if file then
            return assert(load(file, ("@@%s/%s"):format(resource, path), "t", _ENV))
        end
    end

    return nil, "module not found"
end

package.searchers = {
    function(modName)
        local ok, result = pcall(_require, modName)
        return ok and result or ok, result
    end,
    function(modName)
        return package.preload[modName] or nil, ("no field package.preload['%s']"):format(modName)
    end,
    loadModule
}

_ENV.requireCalid = function(modName)
    if type(modName) ~= "string" then
        error(("module name must be a string (received '%s')"):format(modName), 3)
    end

    if loaded[modName] then
        return loaded[modName]
    end

    if loaded[modName] == "__loading" then
        error(("^1circular-dependency occurred when loading module '%s'^0"):format(modName), 2)
    end

    loaded[modName] = "__loading"

    for _, searcher in ipairs(package.searchers) do
        local result, errMsg = searcher(modName)

        if result then
            loaded[modName] = type(result) == "function" and result() or result or true
            return loaded[modName]
        end
    end

    error(("module not found: %s"):format(modName))
end

---@class CalidAPI
---@field name string The name of the Calid instance ("calid")
---@field literal fun(self: any, value: any, message?: string): CalidOptions Creates a literal value validator
---@field boolean fun(self: any, message?: string): CalidOptions Creates a boolean validator
---@field number fun(self: any, message?: string): CalidOptions Creates a number validator
---@field string fun(self: any, message?: string): CalidOptions Creates a string validator
---@field enum fun(self: any, enum: any[], message?: string): CalidOptions Creates an enum validator
---@field object fun(self: any, object: CalidOptions, messageType?: string, messageObject?: string): CalidOptions Creates an object validator
---@field array fun(self: any, array: CalidOptions, messageType?: string, messageArray?: string): CalidOptions Creates an array validator

---Main Calid instance exposing all validator constructors
---@type CalidAPI
_ENV.calid = setmetatable({ name = "calid" }, { __index = requireCalid "lib/constructors" })

---Shortcut alias for `calid`
---@type CalidAPI
_ENV.c = _ENV.calid