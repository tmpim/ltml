local ltml = {}
local sandbox = require("ltml.sandbox")
local utils   = require("ltml.utils")
local render  = require("ltml.render")

function ltml.execute(template, data)
    local env = sandbox(data)

    local root
    if type(template) == "function" then
        root = string.dump(template)
    else
        root = template
    end

    if setfenv then
        root = loadstring(root)
        setfenv(root, env)
    else
        root = load(root, nil, nil, env)
    end

    local result = {}
    return utils.flatten(result, root())
end

function ltml.compile(template)
    return function(data)
        ltml.execute(template, data)
    end
end

ltml.render = render.renderAll

return ltml