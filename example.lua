local ltml = require("ltml")
local render = require("render")
local utils = require("utils")

local template = utils.readAll("example.ltml.lua")

local data = {
    message = "This page was created using only Lua (no HTML, JS, CSS) with LTML!",
    img     = "http://www.lua.org/manual/5.3/logo.gif"
}

local htmlTree = ltml.execute(template, { data = data })
local htmlSource = render.renderAll(htmlTree)
utils.writeAll("example.html", htmlSource)