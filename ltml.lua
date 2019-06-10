local ltml = {}
local ltmlEnv = require("sandbox")
local utils   = require("utils")

function ltml.execute(template, data)
    local env = utils.shallowMerge(data, ltmlEnv)

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

    return root()
end

return ltml