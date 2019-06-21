--- The LTML sandbox module returns a function environment 
-- to be used when executing templates.
-- @module ltml.sandbox
-- @tparam[opt] table env A table to use as the starting environment.
-- @treturn Sandbox A Sandbox instance.
local sandbox = {}

local tags  = require("ltml.tags")
local utils = require("ltml.utils")
local tagCache = {}

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

--- An LTML tag.
-- @type Tag

--- Modifies the tag immutably.
-- @function __call
-- @tparam table data The attributes and children to apply to the tag.
-- @treturn Tag The modified tag.

--- The name of the tag.
-- @string name

--- The attributes of the tag.
-- @tparam {[string]=string,...}|{[string]=boolean,...} attributes

--- The tag's children.
-- @tparam {Tag,...} children

--- An LTML sandbox environment.
-- @type Sandbox
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

--- Returns a constructed tag with given attributes and children.
-- @tparam string name The tag's name.
-- @tparam[opt] table attributes The tag's attributes.
-- @tparam[opt] table children The tag's children.
-- @treturn table The constructed tag.
function sandbox:tag(name, attributes, children)
    local tag = {
        name = name or "tag",
        attributes = attributes or {},
        children = children or {}
    }

    setmetatable(tag, tagMetatable)

    return tag
end

--- Takes a raw tag and passes it into @{tag}.
-- @tparam table data The raw tag.
-- @treturn table The constructed tag.
function sandbox:raw(data)
    return sandbox:tag(data.name, data.attributes, data.children)
end

--- Declares an environment variable.
-- This function is optionally curried.
-- @tparam string name A variable path name. Can be separated by dots to define variables in table structures.
-- @param[opt] value The value to set the variable to.
function sandbox:def(name, value)
    local _ = function(...)
        local args = {...}
        if #args > 1 then
            utils.envSet(self, name, args)
        else
            utils.envSet(self, name, args[1])
        end

        return {}
    end

    if value ~= nil then
        return _(value)
    else
        return _
    end
end

--- Iterates over a list of items and applies a function to all of them, returning a list of the results.
-- @tparam table list The list of items to iterate over.
-- @tparam function func The function to apply.
-- @treturn table The list of results.
function sandbox:map(list, func)
    local results = {}

    for _, v in ipairs(list) do
        table.insert(results, func(v))
    end

    return results
end

--- Returns a selection of the two final values based on the first value.
-- This function is optionally curried.
-- @tparam boolean test The boolean value to act on.
-- @param[opt] yes The value to return when test is truthy.
-- @param[opt] no The value to return when test is falsy.
-- @return The value of yes if test is truthy, or the value of no if test is falsy.
function sandbox:cond(test, yes, no)
    local _ = function(a)
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

    if yes ~= nil or no ~= nil then
        return _(yes)(no)
    else
        return _
    end
end

--- A helper function which checks if the variable is defined within the environment using @{cond}.
-- This function is optionally curried.
-- @tparam string var The name of the variable to check for. Can be dot separated for variables within tables.
-- @param[opt] yes The value to return when the variable is defined.
-- @param[opt] no The value to return when the variable is not defined.
-- @return The value of yes if the variable is defined, or the value of no if the variable is not defined.
function sandbox:isdef(var, yes, no)
    local _ = sandbox:cond(utils.envGet(self, var) ~= nil)
    if yes ~= nil or no ~= nil then
        return _(yes)(no)
    else
        return _
    end
end

return function(env)
    env = env or {}
    setmetatable(env, sandboxMetatable)
    return env
end