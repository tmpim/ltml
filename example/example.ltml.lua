return {
    
-- `data` is a variable supplied when executing the template.
-- {
--     message = "This page was created using only Lua (no HTML, JS, CSS) with LTML!",
--     img     = "http://www.lua.org/manual/5.3/logo.gif"
-- }

-- Defining variables within your templates is simple!
def "cool_message" ( data.message:reverse() ),
def "groceries" { "Milk", "Eggs", "Bread" },
-- Define components which can be used within your templates!
def "item" ( function(name) return li { name } end ),

doctype "html",
-- Comments can be rendered!
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
        -- Attributes and contents can be described in the same object
        a { href = "https://justyn.is", "Check out my blog!" },
        
        -- Alternatively, you can define attributes and contents in chains
        a { href = "https://github.com/tmpim/ltml" } "LTML is awesome!",
        
        img { src = data.img },
        h2 "Grocery list:",
        -- Looping over arrays and generating content is easy!
        ul {
            map (groceries, item)
        }
    }
}

}