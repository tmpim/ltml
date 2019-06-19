local utils = {}

function utils.keys(t)
    local results = {}

    for k in pairs(t) do
        table.insert(results, k)
    end

    return results
end

function utils.equals(a, b)
    local comparison
    if type(a) ~= type(b) then
        return false
    else
        comparison = type(a)
    end

    if comparison == "table" then
        local keys = utils.shallowMerge(utils.keys(a), utils.keys(b))

        for _, v in ipairs(keys) do
            if not utils.equals(a[v], b[v]) then
                return false
            end
        end

        return true
    else
        return a == b
    end
end

function utils.shallowCopy(from, to)
    to = to or {}

    for k, v in pairs(from) do
        to[k] = v
    end

    return to
end

function utils.shallowMerge(a, b)
    local c = {}

    utils.shallowCopy(a, c)
    utils.shallowCopy(b, c)

    return c
end

function utils.deepCopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[utils.deepCopy(orig_key)] = utils.deepCopy(orig_value)
        end
        setmetatable(copy, utils.deepCopy(getmetatable(orig)))
    else
        copy = orig
    end

    return copy
end

function utils.readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function utils.writeAll(file, content)
    local f = assert(io.open(file, "w"))
    f:write(content)
    f:close()
    return content
end

function utils.htmlSpecialChars(txt)
    return txt:gsub("&", "&amp;")
              :gsub("<", "&lt;")
              :gsub(">", "&gt;")
              :gsub("\"", "&quot;")
end

function utils.count(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function utils.splitVar(var)
    local result = {}

    for value in string.gmatch(var, "[^%.]+") do
        table.insert(result, value)
    end

    return result
end

function utils.flatten(a, b)
    if type(b) == "table" and b.name == nil then
        for _, c in ipairs(b) do
            utils.flatten(a, c)
        end
    else
        table.insert(a, b)
    end
    return a
end

local function isWindows()
    return type(package) == 'table' and type(package.config) == 'string' and package.config:sub(1,1) == '\\'
end

function utils.ansiSupported()
    local supported = not isWindows()
    
    if isWindows() then
        supported = os.getenv("ANSICON")
    end

    local term = os.getenv("TERM")
    if term and term:lower():find("xterm") then
        supported = true
    end

    return supported
end

local colors = {
    reset     = 0,
    black     = 30,
    red       = 31,
    green     = 32,
    yellow    = 33,
    blue      = 34,
    magenta   = 35,
    cyan      = 36,
    white     = 37
}

utils.color = {}

for k, v in pairs(colors) do
    utils.color[k] = function(text)
        if utils.ansiSupported() then
            return "\27[" .. v .."m" .. text .. "\27[0m"
        else
            return text
        end
    end
end

function utils.envSet(env, name, value)
    if type(name) == "string" then
        name = utils.splitVar(name)
    end
    local e = env

    for i, v in ipairs(name) do
        if i ~= #name then
            if e[v] == nil then
                e[v] = {}
            end
            e = e[v]
        end
    end

    e[name[#name]] = value
    return env
end

function utils.envGet(env, name)
    if type(name) == "string" then
        name = utils.splitVar(name)
    end
    local e = env

    for i, v in ipairs(name) do
        if e[v] == nil then
            return nil
        else
            e = e[v]
        end
    end

    return e
end

function utils.loadTemplateFromFile(filename)
    return "return {" .. utils.readAll(filename) .. "}"
end

function utils.empty(t)
    for k in pairs(t) do
        t[k] = nil
    end

    return t
end

return utils