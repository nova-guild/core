local serde = require("../libs/serde")
local fs = require("../libs/fs")
local process = require("../libs/process")

local function generateAlias()
    local luaurcPath = process.cwd .. "/.luaurc"
    local luaurcjson = fs.readFile(luaurcPath)
    local decode = serde.decode("json", luaurcjson)

    if not decode.aliases then
        decode.aliases = {}
    end

    decode.aliases.c = process.cwd

    local encode = serde.encode("json", decode, true)
    decode.aliases.c = process.cwd
    fs.writeFile(luaurcPath, encode)
end

return generateAlias