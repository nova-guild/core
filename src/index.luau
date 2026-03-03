--!optimize 2
--!native

local net = require("@lune/net")
local serde = require("@lune/serde")
local fs = require("@lune/fs")
local process = require("@lune/process")
local loadEnv = require("./loadEnv")
local Types = require("./types")

export type Request = Types.Request
export type RequestWith<T> = Types.RequestWith<T>
export type ResponseBody = Types.ResponseBody
export type ResponseOptions = Types.ResponseOptions
export type NovaInstance = Types.NovaInstance
export type Next = Types.Next

local Nova = {}
Nova.__index = Nova

local baseDir = "./app"
local absolutePath = process.cwd
local srcPath = "/lune_packages/.pesde/bizwiz3+nova/0.1.2/nova/src"
local routePatterns = {}

Nova.chain = require("./chain")
Nova.response = require("./response")

local function routerDispatcher(origReq)
    local req = {
        path = origReq.path,
        body = origReq.body,
        headers = origReq.headers,
        query = origReq.query
    } :: Request

    local cleanPath = origReq.path
    if #cleanPath > 1 and cleanPath:sub(-1) == "/" then
        cleanPath = cleanPath:sub(1, -2)
    end

    local matchedModule = nil
    local params = {}

    for _, route in ipairs(routePatterns) do
        local matches = { cleanPath:match(route.pattern) }

        if #matches > 0 then
            matchedModule = route.module
            
            if #route.params > 0 then
                for i, name in ipairs(route.params) do
                    params[name] = matches[i]
                end
            end
            break
        end
    end

    if not matchedModule then 
        return { body = { error = "Not Found" }, config = { status = 404 } } 
    end

    local method = origReq.method:sub(1, 1):upper() .. origReq.method:sub(2):lower()
    local handler = matchedModule[method]

    if type(handler) ~= "function" then 
        return { body = { error = "Method Not Allowed" }, config = { status = 405 } } 
    end

    req.params = params
    req.query = req.query or {} 

    return handler(req)
end

local function createAppDir() 
    fs.copy(`{process.cwd}/app`, `{process.cwd}{srcPath}/app`)
end

local function removeAppDir() 
    fs.removeDir(`{process.cwd}{srcPath}/app`)
end

local function buildRouter(currentDir: string, currentRoute: string)
    local items = fs.readDir((currentDir:gsub("../app", `{absolutePath}/app`)))
    local hasRouteFile = false

    for _, item in ipairs(items) do
        if item == "route.luau" then 
            hasRouteFile = true 
            break 
        end
    end

    if hasRouteFile then
        local modulePath = currentDir .. "/route"
        local routeKey = currentRoute == "" and "/" or currentRoute
        
        local pattern = routeKey:gsub("%[([^%]]+)%]", "([^/]+)")
        pattern = "^" .. pattern .. "$"
        
        local params = {}
        for paramName in routeKey:gmatch("%[([^%]]+)%]") do
            table.insert(params, paramName)
        end

        table.insert(routePatterns, {
            pattern = pattern,
            params = params,
            module = require(modulePath),
            path = routeKey
        })
        
        print("Route Registered: " .. routeKey)
    end

    for _, item in ipairs(items) do
        local path = currentDir .. "/" .. item
        if fs.metadata((path:gsub("../app", `{absolutePath}/app`))).kind == "dir" then
            buildRouter(path, currentRoute .. "/" .. item)
        end
    end
end


-- || Public Functions || --

function Nova.new(port: number, globalMiddlewares: { (req: Request, next: Next) -> any }?)
    local self = setmetatable({}, Nova)
    
    self.port = port
    self.middlewares = globalMiddlewares or {}
    self.router = {}

    loadEnv()
    return (self :: any) :: NovaInstance
end

function Nova:listen(callback: () -> ())
    local start = os.clock()
    local srcDir = fs.readDir(`{process.cwd}{srcPath}`)
    
    for _, item in ipairs(srcDir) do 
        if item == "app" and fs.isDir(`{process.cwd}{srcPath}/{item}`) then
            removeAppDir()
        end
    end

    createAppDir()

    buildRouter(baseDir, "")
 
    local rootPipeline = Nova.chain(self.middlewares, routerDispatcher)

    print("\nStarting...")
    net.serve(self.port, function(origReq)
        local success, result = pcall(rootPipeline, origReq)

        if success and result == nil then
            success = false
            result = "Middleware chain failed to return a Response. Did you forget to 'return next(req)'?"
        end

        local status = 200
        if not success then
            status = 500
        elseif result and result.config then
            status = result.config.status or 200
        end

        -- ANSI Coloring logic
        local color = "\27[31m" -- Default Red
        if status >= 200 and status < 300 then
            color = "\27[32m" -- Green
        elseif status >= 300 and status < 400 then
            color = "\27[34m" -- Blue
        end
        local reset = "\27[0m"

        print(`[{origReq.method}] {origReq.path} {color}{status}{reset}`)

        if success then
            local body = result.body
            local contentType = result.config.isHtml and "text/html" or "application/json"
            
            if not result.config.isHtml and type(body) == "table" then
                body = serde.encode("json", body)
            end

            return {
                status = status,
                body = body,
                headers = { 
                    ["Content-Type"] = contentType,
                    ["X-Powered-By"] = "Nova" 
                }
            }
        else
            local errorMessage = tostring(result)
            return {
                status = 500,
                body = serde.encode("json", {
                    error = "Internal Server Error",
                    message = process.env.LUNE_ENV == "dev" and errorMessage or "An unexpected error occurred",
                }),
                headers = { ["Content-Type"] = "application/json" }
            }
        end
    end)
    local finish = os.clock() - start

    print(string.format("Ready in %.4fs\n", finish))

    if callback then 
        callback() 
    end 
end

return Nova