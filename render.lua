local render = {}

render.renderElement = function(element)
    if type(element) == "string" or type(element) == "number" then
        return element
    end

    local result = "<" .. element.name

    for key, value in pairs(element.attributes) do
        if value == true then
            result = result .. " " .. key
        else
            result = result .. " " .. key .. "=\"" .. value .. "\""
        end
    end

    if #element.children > 0 then
        result = result..">"

        local count = 0
        for _, child in pairs(element.children) do
            result = result .. render.renderElement(child)
            count = count + 1
        end

        result = result .. "</" .. element.name .. ">"
    else
        result = result.." />"
    end

    return result
end

render.renderAll = function(elements)
    local result = ""

    for _, element in pairs(elements) do
        result = result .. render.renderElement(element)
    end

    return result
end

return render