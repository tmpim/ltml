local tags  = require("ltml.tags")
local utils = require("ltml.utils")

local tagMetatable = {}

local function callTag(self, data)
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

tagMetatable.__call = callTag

local function tag(name, attributes, children)
    local tag = {
        name = name or "tag",
        attributes = attributes or {},
        children = children or {}
    }

    setmetatable(tag, tagMetatable)

    return tag
end

local function set(env, name, value)
    if type(name) == "string" then
        name = utils.splitVar(name)
    end
    local e = env

    for i, v in ipairs(name) do
        if i ~= #name then
            e = e[v]
        end
    end

    e[name[#name]] = value
end

local function get(env, name)
    if type(name) == "string" then
        name = utils.splitVar(name)
    end
    local e = env

    for i, v in ipairs(name) do
        e = e[v]
    end

    return e
end

return function(sandbox)
    for _, tagName in pairs(tags) do
        sandbox[tagName] = tag(tagName)
    end

    function sandbox.tag(name)
        return tag(name)
    end

    function sandbox.raw(data)
        return tag(data.name, data.attributes, data.children)
    end

    function sandbox.def(name)
        return function(...)
            local args = {...}
            if #args > 1 then
                set(sandbox, name, args)
            else
                set(sandbox, name, args[1])
            end

            return {}
        end
    end

    function sandbox.map(list, func)
        local results = {}

        for _, v in ipairs(list) do
            table.insert(results, func(v))
        end

        return results
    end

    return sandbox
end