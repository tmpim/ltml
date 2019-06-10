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

return utils