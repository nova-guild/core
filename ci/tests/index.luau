local process = require("@lune/process")
local stdio = require("@lune/stdio")

local TEST_FILES = { "post", "get", "put", "delete" }
local failed = false

print(stdio.color("cyan") .. "Starting Nova Test Suite..." .. stdio.color("reset"))

for _, name in TEST_FILES do
    stdio.write(`Running {name}... `)
    
    local result = process.exec("lune", { "run", `tests/{name}` })

    if result.ok then
        print(stdio.color("green") .. "PASSED" .. stdio.color("reset"))
    else
        print(stdio.color("red") .. "FAILED" .. stdio.color("reset"))
        print(stdio.color("yellow") .. result.stderr .. stdio.color("reset"))
        failed = true
    end
end

if failed then
    print("\nTest Suite Failed")
    process.exit(1)
else
    print("\nTest Suite Successful")
    process.exit(0)
end