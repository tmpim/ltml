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