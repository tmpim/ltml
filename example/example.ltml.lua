-- At the top level, an LTML template is simply file which returns a table of
-- elements. These elements are generated using functions which return elements
-- in the form of a Lua table structure which is then passed off to the renderer.
-- 
-- Since this file ends with .ltml.lua (or .ltml), we can omit the top level
-- table. Alternatively, you could remove the .ltml from the name of this file
-- and encase it in `return { ... }`. But, instead here we omit this wrapping 
-- and leave that to the code which executes this template.
--
-- When executing a template, we have the option to supply an environment to it.
-- In the case of this template, we supply a `data` variable in the environment,
-- its contents are as follows:
--
--    {
--        message = "This page was created using only Lua (no HTML, JS, CSS) with LTML!",
--        img     = "http://www.lua.org/manual/5.3/logo.gif"
--    }
--
-- In LTML, when you create a tag, you're simply calling a function which
-- returns a structure to represent that tag. These functions are actually
-- tables, so you don't even always have to actually call them. For example,
-- if you use `a`, you're really just referencing a table that looks like
-- this:
--
--    {
--        name = "a",
--        attributes = {},
--        children = {}
--    }
--
-- And, when you call that table (yes, you can make tables callable in Lua),
-- we simply copy that element and then populate its attributes and children.
-- For example, when you do `a { href = "/hello", "Hello Page" }` you get this:
--
--    {
--        name = "a",
--        attributes = { href = "/hello" },
--        children = { "Hello Page" }
--    }
--
-- `def` is a function which is included in the LTML environment by default. It
-- allows you to set variables in your environment from within the template, and
-- you have total free reign to run absolutely any Lua you want. Keep in mind,
-- certain functions aren't exposed in LTML templates. `def` is actually a curried
-- function, which means it takes its arguments in a series of calls rather than
-- all at once. We do this mostly to make the syntax a bit more elegant.
-- For example, we can do something like this:
--
def "cool_message" ( data.message:reverse() ),
def "groceries" { "Milk", "Eggs", "Bread" },
--
-- Thanks to the dynamicness of LTML, we can simply create components using simple
-- functions. For example, we'll make a function that returns a list item here:
--
def "item" ( function(name) return li { name } end ),
--
-- In HTML, the start of every file is intended to have `<!DOCTYPE html>`. This
-- tag doesn't follow the typical scheme of other tags, so we simply call it
-- `doctype` and then deal with it in the renderer as a special case.
--
doctype "html",
--
-- Additionally, comments are also atypical of HTML tags similarly to DOCTYPE.
-- So, we just include it as yet another special case in the renderer.
--
comment "This page was rendered with <3 by LTML",
--
-- Here we're getting into the meat of the document, so rather than explain
-- everything I'll focus on the interesting bits.
--
html {
    head {
--
-- When creating an element in LTML, you have the choice to supply a table,
-- or a string. This is because Lua allows calling functions without parentheses
-- as long as the are only supplied one argument that is a string or table literal.
-- Any string contents anywhere in the LTML tree is assumed to be text elements.
--
        title "LTML Example"
    },
    body {
        h1 "LTML Example",
--
-- When referencing variables in your template, it is important to consider that
-- a variable reference isn't a string literal. Therefore, we must encase any
-- variable references with a table literal.
--
        p { data.message },
        p { cool_message },
--
-- Again, all the element functions in LTML are actually already constructed tables,
-- so you can omit arguments to get a empty void tag.
--
        br,
--
-- Because of the way tables work in Lua, you can define attributes and children in
-- the same table together.
--
        a { href = "https://justyn.is", "Check out my blog!" },
--
-- Text elements can be anywhere in the tree. However, keep in mind that text elements
-- are sanitized and therefore you should not attempt to place raw HTML in them.
--
        " ",
--
-- Alternatively, you can chain calls to an element to further add content or attributes.
--
        a { href = "https://github.com/tmpim/ltml" } "LTML is awesome!",
        br,
        img { src = data.img },
        h2 "Grocery list:",
--
-- `map` is a function in the default LTML environment that allows you to create elements
-- by iterating over a table. It simply calls the function supplied in the second argument
-- on every element in the table supplied in the first argument. The resulting elements
-- are simply appended to the children of the parent element.
--
        ul {
            map (groceries, item)
        }
    }
}