local utils = require("utils")
local render = {}

local function attributes(element)
    local result = ""

    for key, value in pairs(element.attributes) do
        if value == true then
            result = result .. " " .. key
        else
            result = result .. " " .. key .. "=\"" .. utils.htmlSpecialChars(value) .. "\""
        end
    end

    return result
end

local function openTag(element)
    return "<" .. element.name .. attributes(element) .. ">"
end

local function closeTag(element)
    return "</" .. element.name .. ">"
end

local function loneTag(element)
    return "<" .. element.name .. attributes(element) .. " />"
end

render.renderElement = function(element)
    if type(element) == "string" or type(element) == "number" then
        return utils.htmlSpecialChars(element)
    elseif element.name == "comment" then
        return render.renderComment(element)
    elseif element.name == "doctype" then
        return render.renderDoctype(element)
    else
        return render.renderTag(element)
    end
end

render.renderTag = function(element)
    if #element.children > 0 then
        return openTag(element) .. render.renderAll(element.children) .. closeTag(element)
    else
        return loneTag(element)
    end
end

function render.renderComment(element)
    return "<!-- " .. element.text .. " -->"
end

function render.renderDoctype(element)
    return "<!DOCTYPE " .. element.type ..">"
end

function render.renderAll(elements)
    local result = ""

    for _, element in pairs(elements) do
        result = result .. render.renderElement(element)
    end

    return result
end

return render