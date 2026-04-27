local fs = require("../libs/fs")
local process = require("../libs/process")
local routing = require("./routing") 

local readDir = fs.readDir
local metadata = fs.metadata
local cwd = process.cwd
local registerRoute = routing.registerRoute

local function generateRoute(currentDir: string, currentRoute: string)
    local resolvedDir = currentDir:gsub("@c/", cwd .. "/")
    local items = readDir(resolvedDir)

    for _, item in ipairs(items) do
        local path = currentDir .. "/" .. item
        local resolvedPath = path:gsub("@c/", cwd .. "/")

        if item == "route.luau" then 
            local modulePath = currentDir .. "/route"
            
            local routeKey = currentRoute == "" and "/" or currentRoute
            
            local routeModule = require(modulePath) :: string

            registerRoute(routeKey, routeModule)
            
            print(`\27[32mRegistered Route: {routeKey}\27[0m`)

        elseif metadata(resolvedPath).kind == "dir" or metadata(resolvedPath).kind == "directory" then
            local nextRoute = currentRoute .. "/" .. item
            generateRoute(path, nextRoute)
        end
    end
end

return generateRoute