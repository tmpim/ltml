--- The root LTML module provides functions to compile, execute and render templates.
-- @module ltml
local ltml = {}
local sandbox = require("ltml.sandbox")
local utils   = require("ltml.utils")
local render  = require("ltml.render")

function ltml.execute(template, data, name)
    return ltml.compile(template, name)(data)
end

local function reload(func, env, name)
    if setfenv then
        func = loadstring(string.dump(func), name)
        return setfenv(func, env)
    else
        return load(string.dump(func), name, "b", env)
    end
end

function ltml.compile(template, name)
    local compiledTemplate
    if type(template) == "function" then
        compiledTemplate = template
    elseif setfenv then
        compiledTemplate = loadstring(template, name)
    else
        compiledTemplate = load(template, name, "t")
    end

    return function(data)
        -- Reload the functions environment by dumping and loading it.
        -- (Should be performant, as we aren't recompiling it)
        local reloadedTemplate = reload(compiledTemplate, sandbox(data), name)

        -- Call the template to get our unflattened tree
        local unflattenedTree = reloadedTemplate()

        -- Flatten the tree to ensure the its nice and neat
        local flattenedTree = utils.flatten({}, unflattenedTree)

        return flattenedTree
    end
end

ltml.render = render.renderAll

return ltml