assert(GetCurrentResourceName() ~= "calid")
assert(_VERSION:find("5.4"), "^1Lua 5.4 must be enabled in the resource manifest!^0")
assert(GetResourceState("calid") == "started", "^1calid must be started before this resource.^0")

local loaded = {}
local _require = require

local package = {
    path = "./?.lua;./?/init.lua",
    preload = {},
    loaded = setmetatable({}, {
        __index = loaded,
        __newindex = function() end,
        __metatable = false
    }),
}

package.searchers = {
    function(module)
        local ok, result = pcall(_require, module)
        return ok and result or ok, result
    end,
    function(module)
        return package.preload[module] or nil, ("no field package.preload['%s']"):format(module)
    end,
    function(module)
        local resource, fileName = "calid", module:gsub("%.", "/")

        for template in package.path:gmatch("[^;]+") do
            local path = template:gsub("^%./", ""):gsub("?", fileName)
            local file = LoadResourceFile(resource, path)

            if file then
                return assert(load(file, ("@@%s/%s"):format(resource, path), "t", _ENV))
            end
        end

        return nil, "module not found"
    end
}

_ENV.requireC = function(module)
    if type(module) ~= "string" then
        error(("module name must be a string (received '%s')"):format(module), 3)
    end

    if loaded[module] then
        return loaded[module]
    end

    if loaded[module] == "__loading" then
        error(("^1circular-dependency occurred when loading module '%s'^0"):format(module), 2)
    end

    loaded[module] = "__loading"

    for _, searcher in ipairs(package.searchers) do
        local result, errMsg = searcher(module)

        if result then
            loaded[module] = type(result) == "function" and result() or result or true
            return loaded[module]
        end
    end

    error(("module not found: %s"):format(module))
end

---@type CalidAPI
_ENV.calid = requireC "lib.api"
_ENV.c = _ENV.calid