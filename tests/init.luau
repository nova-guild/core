local fs = require("@src/libs/fs")
local runner = require("@self/runner")

local function findTestFiles(dir: string): { string }
    local results = {}

    for _, entry in fs.readDir(dir) do
        local fullPath = dir .. "/" .. entry

        if fs.isDir(fullPath) then
            for _, nested in findTestFiles(fullPath) do
                table.insert(results, nested)
            end
        elseif string.match(entry, "%.test%.luau$") then
            table.insert(results, fullPath)
        end
    end

    return results
end

local files = findTestFiles("tests")

for _, file in files do
    local modulePath = string.match(file, "^(.-)%.luau$")
    print("\27[1;36m\n[ " .. file .. " ]\n\27[0m")
    runner.reset()
    local testFn = require(`./{modulePath}`) :: any
    testFn()
end