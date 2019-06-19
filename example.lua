local ltml = require("ltml")
local utils = require("ltml.utils")

-- Load the an .ltml.lua template from a specific path.
local template = utils.loadTemplateFromFile("example/example.ltml.lua")

-- Create the table which we will supply in the environment.
local data = {
    message = "This page was created using only Lua (no HTML, JS, CSS) with LTML!",
    img     = "http://www.lua.org/manual/5.3/logo.gif"
}

-- Alternatively, we could use `ltml.execute` if we are
-- only using it once. However, compile optimizes away
-- a compilation step and makes templates run faster.
local htmlTemplate = ltml.compile(template)
local htmlTree = htmlTemplate({ data = data })

-- `ltml.render` simply returns the raw rendered HTML as a string.
local htmlSource = ltml.render(htmlTree)

-- Write the rendered HTML to a file.
utils.writeAll("example/example.html", htmlSource)