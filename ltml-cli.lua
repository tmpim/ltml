local ltml = require("ltml")
local render = require("render")
local utils = require("utils")
local files = {...}

for _, v in pairs(files) do
    local template = utils.readAll(v..".ltml.lua")
    local htmlTree = ltml.execute(template)
    local htmlSource = render.renderAll(htmlTree)
    utils.writeAll(v..".html", htmlSource)
end