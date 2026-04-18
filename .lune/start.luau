local process = require("@lune/process")
local serde = require("../src/libs/serde")
local fs = require("../src/libs/fs")

local luaurcPath = process.cwd .. "/.luaurc"
local luaurcjson = fs.readFile(luaurcPath)
local decode = serde.decode("json", luaurcjson)

if not decode.aliases then
    decode.aliases = {}
end

decode.aliases.c = process.cwd .. "ci/"

local encode = serde.encode("json", decode, true)
fs.writeFile(luaurcPath, encode)

local running = process.exec("lune", { "run", "src/index" }, { stdio = "inherit", cwd = "ci" })

if not running.ok then 
    print(running.stderr)
end