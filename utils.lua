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
    else -- number, string, boolean, etc
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

return utils