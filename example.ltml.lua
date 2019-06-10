doctype "html",
comment "This page was rendered with LTML",
html {
    head {
        title { data.message }
    },
    body {
        h1 "LTML says hi",
        p { data.message },
        img {
            src = "https://www.lua.org/images/luaa.gif"
        },
        br,
        tag "faketag" {
            "hello"
        },
        br,
        raw {
            name = "a",
            attributes = {
                href = "https://google.com"
            },
            children = {
                "Click here for google."
            }
        }
    }
}