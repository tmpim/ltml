package = "ltml"
version = "scm-1"
source = {
   url = "git+https://github.com/tmpim/ltml.git"
}
description = {
   summary = "A simple and concise templating engine that takes advantage of elegant Lua syntax.",
   detailed = "LTML utilizes Lua's tables and optional parentheses around table and string literals to allow for a simple template syntax that can be easily rendered as HTML.",
   homepage = "https://github.com/tmpim/ltml",
   license = "MIT"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      ltml = "ltml.lua"
   }
}
