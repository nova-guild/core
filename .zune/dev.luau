local adpt = require("@mayari.adpt")
local process = zune.process
local json = adpt.json
local fs = adpt.fs

local luaurcPath = process.cwd() .. "/.luaurc"
local luaurcjson = fs.readFile(luaurcPath)
local decode = json.decode(luaurcjson)

if not decode.aliases then
    decode.aliases = {}
end

local newCAlias = process.cwd() .. "/tests/web/"

if not (newCAlias == decode.aliases.c) then
    decode.aliases.c = newCAlias
end

local encode = json.encode(decode)
fs.writeFile(luaurcPath, encode)


process.run("zune", { "run", "src/main", "dev" }, { stderr = "inherit", stdout = "inherit", cwd = "tests/web" })