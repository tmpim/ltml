local utils = {}

function utils.copy(from, to)
    for k, v in pairs(from) do
        to[k] = v
    end
end

function utils.shallowMerge(a, b)
    local c = {}

    utils.copy(a, c)
    utils.copy(b, c)

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
    local count
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

return utils