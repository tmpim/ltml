local ltml = {}
local sandbox = require("ltml.sandbox")
local utils   = require("ltml.utils")
local render  = require("ltml.render")

function ltml.execute(template, data)
    local env = sandbox(utils.deepCopy(data or {}))

    local root
    if type(template) == "string" then
        root = "return { "..template.." }"
    else
        root = string.dump(template)
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

ltml.render = render.renderAll

return ltml