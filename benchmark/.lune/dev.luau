local process = require("@lune/process")

local result = process.exec("pesde", {
    "run",
    "lunemon",
    "--",
    "src/index.luau"
}, {
    stdio = "inherit",
})

if not result.ok then 
    error(result.stderr)
end
