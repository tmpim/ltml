local utils = require("ltml.utils")
local color = utils.color

local test_imports = {
    "render_tests",
    "sandbox_tests",
    "util_tests"
}

local tests = {}
local testCount = 0

for _, v in pairs(test_imports) do
    tests[v] = require("tests." .. v)

    for _ in pairs(tests[v]) do
        testCount = testCount + 1
    end
end

local passedTests = 0
local failedTests = 0
print("Loaded " .. testCount .. " tests.")

for category, list in pairs(tests) do
    if utils.count(list) > 0 then
        print(category..": ")
    end

    for name, test in pairs(list) do
        local status, value = pcall(test)

        if status and value then
            print("  [" .. color("green", "PASS") .. "] " .. name)
            passedTests = passedTests + 1
        else
            print("  [" .. color("red", "FAIL") .. "] " .. name)
            print("    !!! ERROR !!!: " .. tostring(value))
            failedTests = failedTests + 1
        end
    end
end

print(passedTests .. " tests passed, " .. failedTests .. " tests failed.")