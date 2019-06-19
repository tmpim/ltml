--- The LTML sandbox module.
-- Returns a function environment to
-- be used when executing templates.
-- @module ltml.sandbox
-- @param env a table to use as the starting environment
-- @return an ltml function environment
local sandbox = {}

local tags  = require("ltml.tags")
local utils = require("ltml.utils")

local tagMetatable = {
    __call = function(self, data)
        self = utils.deepCopy(self)
    
        if type(data) == "string" then
            table.insert(self.children, data)
        elseif type(data) == "table" then
            for k, v in pairs(data) do
                if type(k) == "string" then
                    self.attributes[k] = v
                elseif type(k) == "number" then
                    utils.flatten(self.children, v)
                end
            end
        end
        
        return self
    end
}

local tagCache = {}

local sandboxMetatable = {
    __index = function(self, name)
        if sandbox[name] and type(sandbox[name]) == "function" then
            return function(...)
                return sandbox[name](self, ...)
            end
        elseif tags.lookup[name] then
            if not tagCache[name] then
                tagCache[name] = sandbox:tag(name)
            end

            return tagCache[name]
        end
    end
}

function sandbox:tag(name, attributes, children)
    local tag = {
        name = name or "tag",
        attributes = attributes or {},
        children = children or {}
    }

    setmetatable(tag, tagMetatable)

    return tag
end

function sandbox:raw(data)
    return sandbox:tag(data.name, data.attributes, data.children)
end

function sandbox:def(name)
    return function(...)
        local args = {...}
        if #args > 1 then
            utils.envSet(self, name, args)
        else
            utils.envSet(self, name, args[1])
        end

        return {}
    end
end

function sandbox:map(list, func)
    local results = {}

    for _, v in ipairs(list) do
        table.insert(results, func(v))
    end

    return results
end

function sandbox:cond(test)
    return function(a)
        return function(b)
            a = a or {}
            b = b or {}
            if test then
                return a
            else
                return b
            end
        end
    end
end

function sandbox:isdef(var)
    return sandbox:cond(utils.envGet(self, var) ~= nil)
end

return function(env)
    env = env or {}
    setmetatable(env, sandboxMetatable)
    return env
end