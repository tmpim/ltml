local ltml = {}
local sandbox = require("ltml.sandbox")
local utils   = require("ltml.utils")
local render  = require("ltml.render")

function ltml.execute(template, data, name)
    return ltml.compile(template, name)(data)
end

function ltml.compile(template, name)
    local env = sandbox(data)

    if type(template) == "function" then
        template = string.dump(template)
    end

    local compiledTemplate
    if setfenv then
        compiledTemplate = loadstring(template, name)
        setfenv(compiledTemplate, env)
    else
        compiledTemplate = load(template, name, nil, env)
    end

    return function(data)
        utils.empty(env)
        if data then
            utils.deepCopy(data)
            utils.shallowCopy(data, env)
        end

        local result = {}
        return utils.flatten(result, compiledTemplate())
    end
end

ltml.render = render.renderAll

return ltml