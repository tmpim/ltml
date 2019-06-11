local ltml = require("ltml")
local utils = require("ltml.utils")

local template = utils.readAll("example/example.ltml.lua")

local data = {
    message = "This page was created using only Lua (no HTML, JS, CSS) with LTML!",
    img     = "http://www.lua.org/manual/5.3/logo.gif"
}

local htmlTree = ltml.execute(template, { data = data })
local htmlSource = ltml.render(htmlTree)
utils.writeAll("example/example.html", htmlSource)