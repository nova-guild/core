local fs = require("@lune/fs")
local process = require("@lune/process")
local warn = require("./warn")

local function findMainDir()
    local basePath = process.cwd
    
    local hasSrc = fs.isDir(`{basePath}/src`)
    local hasApp = fs.isDir(`{basePath}/app`)

    if hasSrc and hasApp then
        warn("Found both src/ and app/ on your project directory. Nova will try reading the src/ only.")
    end

    if hasSrc then
        return "src/app"
    end
    
    return "app"
end

return findMainDir
