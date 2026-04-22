local process = require("@lute/process")

local TEST_FILES = { "post", "get", "put", "delete" }
local failed = false

print("\27[36mStarting Nova Test Suite...\27[0m")

for _, name in TEST_FILES do
    print(`Running {name}... `)
    
    local result = process.run({"lune", "run", `tests/{name}` })

    if result.ok then
        print("\27[32mPASSED\27[0m")
    else
        print("\27[31mFAILED\27[0m")
        print(`\27[33m{result.stderr}\27[0m`)
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