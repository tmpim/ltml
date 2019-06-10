local ltml = require("ltml")
local render = require("render").renderAll
local utils = require("utils")

local template = utils.readAll("example.ltml.lua")

local data = {
    message = "Hello, world!"
}

local htmlTree = ltml.execute(template, { data = data })
utils.writeAll("example.html", render(htmlTree))