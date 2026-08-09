local process = require("@lute/process")
local adpt = require("@mayari.adpt")
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

process.run({ "lute", "run", "src/main", "dev" }, { stdio = "inherit", cwd = "tests/web" })