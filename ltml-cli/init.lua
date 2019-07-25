local ltml = require("ltml")
local utils = require("ltml.utils")
local files = {...}

for _, v in pairs(files) do
    local template = utils.readAll(v..".ltml.lua")
    local htmlTree = ltml.execute(template)
    local htmlSource = ltml.render(htmlTree)
    utils.writeAll(v..".html", htmlSource)
end