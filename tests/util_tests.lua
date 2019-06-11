local utils = require("ltml.utils")
local util_tests = {}

local function test_object()
    return {
        name = "test",
        attributes = {
            asdf = true,
            onload = "test"
        },
        children = {
            {
                name = "asdf",
                attributes = {},
                children = {}
            }
        }
    }
end

function util_tests.equals_test_object()
    local a, b = test_object(), test_object()

    return utils.equals(a, b)
end

function util_tests.equals_empty_object()
    return utils.equals({}, {})
end

function util_tests.shallowCopy_test_object()
    local copy = utils.shallowCopy(test_object())

    return utils.equals(copy, test_object())
end

function util_tests.shallowCopy_empty_object()
    local copy = utils.shallowCopy({})

    return utils.equals(copy, {})
end

function util_tests.deepCopy_test_object()
    local copy = utils.deepCopy(test_object())

    return utils.equals(copy, test_object())
end

function util_tests.deepCopy_empty_object()
    local copy = utils.deepCopy({})

    return utils.equals(copy, {})
end

function util_tests.shallowMerge()
    local merge = utils.shallowMerge({
        a = "test0",
        c = "test3"
    }, {
        a = "test1",
        b = "test2"
    })

    return utils.equals(merge, {
        a = "test1",
        b = "test2",
        c = "test3"
    })
end

function util_tests.htmlSpecialChars()
    local escaped = utils.htmlSpecialChars("&<>\"")

    return utils.equals(escaped, "&amp;&lt;&gt;&quot;")
end

function util_tests.count()
    local count = utils.count({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})

    return utils.equals(count, 10)
end

function util_tests.splitVar()
    local var = utils.splitVar("this.is.a.test.variable.chain")

    return utils.equals(var, {"this", "is", "a", "test", "variable", "chain"})
end

function util_tests.flatten_single_level()
    local flat = {}

    utils.flatten(flat, {
        {
            test_object()
        }
    })

    return utils.equals(flat, {
        test_object()
    })
end

function util_tests.flatten_multi_level()
    local flat = {}

    utils.flatten(flat, {
        {
            {
                {
                    test_object()
                }
            }
        }
    })

    return utils.equals(flat, {
        test_object()
    })
end

return util_tests