# LTML
A simple templating engine that takes advantage of elegant Lua syntax.

# Explanation
LTML utilizes Lua's tables and lack of parentheses around table and string literals to allow for a simple template syntax that can be easily rendered as HTML. LTML is portable enough to run in any typical Lua environment, given you can use `setfenv` (<5.1) or `load` (5.2+).

# Example
```lua
doctype "html",
comment "This page was rendered with <3 by LTML",
html {
    head {
        title "LTML Example"
    },
    body {
        h1 "LTML Example",
        p { data.message },
        img { src = data.img }
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
        <p>Hello, world!</p>
        <img src="http://www.lua.org/manual/5.3/logo.gif" />
    </body>
</html>
```
Example code for executing and rendering templates can be found in [example.lua](https://github.com/tmpim/ltml/blob/master/example.lua)

# Disclaimer
LTML is a very immature library and currently lacks HTML escaping, so utilize it with caution.