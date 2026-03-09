--!optimize 2

local serde = require("@lune/serde")
local fs = require("@lune/fs")
local process = require("@lune/process")

local function generateAlias() 
    local items = fs.readDir(process.cwd)

    for _, item in ipairs(items) do 
        if item == ".luaurc" then
            local luaurcjson = fs.readFile(process.cwd .. item)
            local decode = serde.decode("json", luaurcjson)

            if decode.aliases.c then 
                break
            end

            decode.aliases.c = ""

            local encode = serde.encode("json", decode, true)
            fs.writeFile(process.cwd .. "/.luaurc", encode)
            print("New alias \"c\" has been created\n")
        end
    end
end

return generateAlias
