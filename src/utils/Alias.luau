local adpt = require("@mayari.adpt")
local fs = adpt.fs
local process = adpt.process

local Alias = {}

--[[
    Links a package alias to the given value in the `.luaurc` file.
    If the alias already exists, its value is overwritten with the new one.
    If it doesn't exist, a new entry is added.

    @param name The name of the alias.
    @param value The value the alias should point to.
]]
function Alias.set(name: string, value: string, rcFile: string?)
    local luauarcPath = if rcFile then rcFile else process.cwd .. ".luaurc"
    local luaurc = fs.readFile(luauarcPath)

    if luaurc:find('"' .. name .. '"') then
        luaurc = luaurc:gsub('("' .. name .. '"%s*:%s*)"[^"]*"', '%1"' .. value .. '"')
        fs.writeFile(luauarcPath, luaurc)
    else
        local aliasStart = luaurc:find('"aliases"') :: number
        local blockClose = luaurc:find("}", aliasStart) :: number

        local isEmpty = luaurc:sub(aliasStart, blockClose):match("{%s*}") ~= nil

        local detectedIndent = luaurc:match('"aliases"%s*:%s*{%s*\n(%s*)"', aliasStart)
        local detectedClose = luaurc:match("\n(%s*)}", aliasStart)
        local baseIndent: string = luaurc:match('\n(%s*)"aliases"') or ""

        local entryIndent: string = (not isEmpty and detectedIndent) or (baseIndent .. "  ")
        local closeIndent: string = detectedClose or baseIndent

        local aliasEntry = (isEmpty and "" or ",") .. "\n" .. entryIndent .. '"' .. name .. '": "' .. value .. '"'

        luaurc = luaurc:sub(1, blockClose - 1):gsub("%s+$", "")
            .. aliasEntry
            .. "\n"
            .. closeIndent
            .. luaurc:sub(blockClose)

        fs.writeFile(luauarcPath, luaurc)
    end
end

--[[
    Removes an existing alias from the `.luaurc` file, if it exists.

    @param name The name of the package alias to remove.
]]
function Alias.remove(name: string)
    local luaurc = fs.readFile(".luaurc")

    if not luaurc:find('"' .. name .. '"') then
        return
    end

    local escapedName = name:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")

    local newContent, count = luaurc:gsub(',%s*\n%s*"' .. escapedName .. '"%s*:%s*"[^"]*"', "")

    if count == 0 then
        newContent, count = luaurc:gsub('"' .. escapedName .. '"%s*:%s*"[^"]*",%s*\n%s*', "")
    end

    if count == 0 then
        newContent, count = luaurc:gsub('"' .. escapedName .. '"%s*:%s*"[^"]*"%s*\n?%s*', "")
    end

    if count > 0 then
        fs.writeFile(".luaurc", newContent)
    end
end

return Alias
