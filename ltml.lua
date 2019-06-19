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
        return utils.flatten({}, reload(compiledTemplate, sandbox(data), name)())
    end
end

ltml.render = render.renderAll

return ltml