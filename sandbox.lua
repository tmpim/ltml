local tags  = require("tags")
local utils = require("utils")

local tagMetatable = {}

local function callTag(self, data)
    if type(data) == "string" then
        table.insert(self.children, data)
    elseif type(data) == "table" then
        for k, v in pairs(data) do
            if type(k) == "string" then
                self.attributes[k] = v
            elseif type(k) == "number" then
                table.insert(self.children, v)
            end
        end
    end
    
    return self
end

tagMetatable.__call = callTag

local function tag(name, attributes, children)
    local tag = {
        name = name or "tag",
        attributes = attributes or {},
        children = children or {}
    }

    setmetatable(tag, tagMetatable)

    return tag
end

local sandbox = {}

for _, tagName in pairs(tags) do
    sandbox[tagName] = function(data)
        return tag(tagName)(data)
    end
end

function sandbox.doctype(type)
    return "<!DOCTYPE " .. type .. ">"
end

function sandbox.comment(text)
    return "<!-- " .. text .. " -->"
end

function sandbox.tag(name)
    return tag(name)
end

function sandbox.raw(data)
    return tag(data.name, data.attributes, data.children)
end

sandbox.br = "<br>"

return sandbox