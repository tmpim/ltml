local utils = require("ltml.utils")
local color = utils.color

local test_imports = {
    "ltml.tests.render_tests",
    "ltml.tests.sandbox_tests",
    "ltml.tests.util_tests"
}

local tests = {}
local testCount = 0

for _, v in pairs(test_imports) do
    tests[v] = require(v)

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
            print("  [" .. color.green("PASS") .. "] " .. name)
            passedTests = passedTests + 1
        else
            print("  [" .. color.red("FAIL") .. "] " .. name)
            print("    !!! " .. color.red("ERROR") .. "!!!: " .. tostring(value))
            failedTests = failedTests + 1
        end
    end
end

print(color.green(passedTests) .. " tests passed, " .. color.red(failedTests) .. " tests failed.")
if failedTests > 0 then
    os.exit(1)
end