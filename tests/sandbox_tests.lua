local ltml = require("ltml")
local utils = require("utils")
local sandbox_tests = {}
local serialize = require("serialize")

local execute = ltml.execute

function sandbox_tests.boilerplate()
    local template = execute(function()
        return {
            doctype "html",
            html {
                head {},
                body {}
            }
        }
    end)

    return utils.equals(template, {
        {
            attributes = {},
            name = "doctype",
            children = {
                "html"
            }
        },
        {
            attributes = {},
            name = "html",
            children = {
                {
                    attributes = {},
                    name = "head",
                    children = {}
                },
                {
                    attributes = {},
                    name = "body",
                    children = {}
                }
            }
        }
    })
end

function sandbox_tests.def()
    local template = execute(function()
        return {
            def "test" "it works",
            p { test }
        }
    end)

    return utils.equals(template, {
        {
            attributes = {},
            name = "p",
            children = {
                "it works"
            }
        }
    })
end

function sandbox_tests.component()
    local template = execute(function()
        return {
            def "test" (function(text) return p { text } end),
            test "it works"
        }
    end)

    return utils.equals(template, {
        {
            attributes = {},
            name = "p",
            children = {
                "it works"
            }
        }
    })
end

function sandbox_tests.map()
    local template = execute(function()
        return {
            def "items" { "item1", "item2", "item3" },
            def "test" (function(text) return p { text } end),
            map (items, test)
        }
    end)

    return utils.equals(template, {
        {
            attributes = {},
            name = "p",
            children = {
                "item1"
            }
        },
        {
            attributes = {},
            name = "p",
            children = {
                "item2"
            }
        },
        {
            attributes = {},
            name = "p",
            children = {
                "item3"
            }
        }
    })
end

function sandbox_tests.template_input()
    local template = execute(function()
        return {
            p { test }
        }
    end, { test = "Hello, world!" })

    return utils.equals(template, {
        {
            attributes = {},
            name = "p",
            children = {
                "Hello, world!"
            }
        }
    })
end

function sandbox_tests.split_attributes()
    local template = execute(function()
        return {
            a { href = "https://github.com/tmpim/ltml" } { "GitHub" }
        }
    end)

    return utils.equals(template, {
        {
            children = {
                "GitHub"
            },
            name = "a",
            attributes = {
                href = "https://github.com/tmpim/ltml"
            }
        }
    })
end

function sandbox_tests.merged_attributes()
    local template = execute(function()
        return {
            a { href = "https://github.com/tmpim/ltml", "GitHub" }
        }
    end)

    return utils.equals(template, {
        {
            children = {
                "GitHub"
            },
            name = "a",
            attributes = {
                href = "https://github.com/tmpim/ltml"
            }
        }
    })
end

function sandbox_tests.tag()
    local template = execute(function()
        return {
            tag "marquee" { "Hello, world!" }
        }
    end)

    return utils.equals(template, {
        {
            attributes = {},
            name = "marquee",
            children = {
                "Hello, world!"
            }
        }
    })
end

function sandbox_tests.raw()
    local template = execute(function()
        return {
            raw {
                name = "me",
                attributes = {
                    thonking = true
                }
            }
        }
    end)

    return utils.equals(template, {
        {
            children = {},
            name = "me",
            attributes = {
                thonking = true
            }
        }
    })
end

return sandbox_tests