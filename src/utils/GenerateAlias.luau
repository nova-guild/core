local adpt = require("@mayari.adpt")
local json = adpt.json
local fs = adpt.fs
local process = adpt.process

local function generateAlias()
    local luauarcPath = process.cwd .. "/.luaurc"

    if not luauarcPath then
        error("Luaurc file is not found in your project.")
    end

    local luaurcJson = fs.readFile(luauarcPath)
    local decoded = json.decode(luaurcJson)

    if not decoded.aliases then
        decoded.aliases = {}
    end

    decoded.aliases.c = process.cwd

    local encoded = json.encode(decoded)
    fs.writeFile(luauarcPath, encoded)
end

return generateAlias
