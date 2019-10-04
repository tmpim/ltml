# Project Status
If you're here and reading this, thanks for being interested in LTML! Unfortunately, this project is on hiatus due to the main maintainer (me, Justyn) being busy searching for employment. If for some reason you have tips as to places I can get a job, you can find my email on my GitHub profile [here](https://github.com/Lustyn).

# LTML

[![Documentation](https://img.shields.io/badge/-docs-blue.svg?style=flat-square)](https://tmpim.github.io/ltml) [![Travis build status](https://img.shields.io/travis/tmpim/ltml.svg?style=flat-square)](https://travis-ci.org/tmpim/ltml) [![MIT License](https://img.shields.io/github/license/tmpim/ltml.svg?style=flat-square)](LICENSE) [![Discord](https://img.shields.io/discord/591488795040546818.svg?style=flat-square)](https://discord.gg/gd4KZvE)

A simple and concise templating engine that takes advantage of elegant Lua syntax.

## Explanation

LTML utilizes Lua's tables and optional parentheses around table and string literals to allow for a simple template syntax that can be easily rendered as HTML. LTML is portable enough to run in any typical Lua environment, given you can use `setfenv` (<5.1) or `load` (5.2+). It is even possible to [run LTML in the browser](https://github.com/tmpim/ltml-react).

## Example

```lua

def "cool_message" ( data.message:reverse() ),
def "groceries" { "Milk", "Eggs", "Bread" },
def "item" ( function(name) return li { name } end ),

doctype "html",
comment "This page was rendered with <3 by LTML",
html {
    head {
        title "LTML Example"
    },
    body {
        h1 "LTML Example",
        p { data.message },
        p { cool_message },
        br,
        a { href = "https://justyn.is", "Check out my blog!" },
        a { href = "https://github.com/tmpim/ltml" } "LTML is awesome!",
        img { src = data.img },
        h2 "Grocery list:",
        ul {
            map (groceries, item)
        }
    }
}
```

This renders to (prettified for readability):

```html
<!DOCTYPE html>
<!-- This page was rendered with <3 by LTML -->
<html>
    <head>
        <title>LTML Example</title>
    </head>
    <body>
        <h1>LTML Example</h1>
        <p>This page was created using only Lua (no HTML, JS) with LTML!</p>
        <p>!LMTL htiw )SSC ,SJ ,LMTH on( auL ylno gnisu detaerc saw egap sihT</p>
        <br />
        <a href="https://justyn.is">Check out my blog!</a>
        <a href="https://github.com/tmpim/ltml">LTML is awesome!</a>
        <img src="http://www.lua.org/manual/5.3/logo.gif" />
        <h2>Grocery list:</h2>
        <ul>
            <li>Milk</li>
            <li>Eggs</li>
            <li>Bread</li>
        </ul>
    </body>
</html>
```

A more explanatory version of this template (and LTML as a whole) can be found in [ltml/example/example.ltml.lua](ltml/example/example.ltml.lua)

Example code for executing and rendering templates can be found in [ltml/example/example.lua](ltml/example/example.lua)

## Disclaimer

LTML is a very immature library, things are subject to change, and it is very much in testing, so utilize it with caution.

## Contributing

[Standard Lua style conventions](http://lua-users.org/wiki/LuaStyleGuide) should be followed when pushing to this repository.
