local process = require("@lune/process")

local running = process.exec("lune", { "run", "tests/index" }, { stdio = "inherit" })

if not running.ok then 
    print(running.stderr)
end