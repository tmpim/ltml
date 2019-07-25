package = "ltml"
version = "scm-1"
source = {
   url = "git+https://github.com/tmpim/ltml.git",
}
description = {
   summary = "A simple and concise templating engine that takes advantage of elegant Lua syntax.",
   detailed = [[
      LTML utilizes Lua's tables and optional parentheses around table
      and string literals to allow for a simple template syntax that 
      can be easily rendered as HTML.
   ]],
   homepage = "https://github.com/tmpim/ltml",
   license = "MIT"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      ["ltml"] = "ltml/init.lua",
      ["ltml.init"] = "ltml/init.lua",
      ["ltml.sandbox"] = "ltml/sandbox.lua",
      ["ltml.render"] = "ltml/render.lua",
      ["ltml.tags"] = "ltml/tags.lua",
      ["ltml.utils"] = "ltml/utils.lua"
   }
}
