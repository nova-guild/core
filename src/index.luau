local net = require("./libs/net")
local fs = require("./libs/fs")
local serde = require("./libs/serde")
local process = require("./libs/process")
local types = require("./types")
local routing = require("./core/routing")
local loadEnv = require("./utils/loadEnv")
local findMainDir = require("./utils/findMainDir")
local generateRoute = require("./core/generateRoute")
local generateAlias = require("./utils/generateAlias")

export type Next = types.Next
export type Nova = types.Nova
export type Request = types.Request
export type RequestWith<T> = types.RequestWith<T>
export type ResponseOptions = types.ResponseOptions

local serve = net.serve
local isFile = fs.isFile
local readFile = fs.readFile
local encode = serde.encode
local env = process.env
local cwd = process.cwd
local routerDispatcher = routing.routerDispatcher

local Nova = {}
Nova.__index = Nova

Nova.chain = require("./utils/chain")
Nova.response = require("./utils/response")

function Nova.new(port: number, middlewares: { (req: types.Request, next: types.Next) -> () }?) 
    local self = setmetatable({}, Nova)
    self.port = port
    self.middlewares = middlewares

    loadEnv()
    generateAlias()

    return self :: Nova
end

function Nova:listen(handler: () -> ())
    local start = os.clock()
        
    local mainDirName = findMainDir()
    local mainDir = `@c/{mainDirName}`
        
    local faviconPath = `{cwd}/{mainDirName}/favicon.ico`
    local enableLogging = env.LUNE_ENV ~= nil

    local INTERNAL_ERROR_RESPONSE = {
        status = 500,
        body = encode("json", { error = "Internal Server Error" }),
        headers = { ["Content-Type"] = "application/json" }
    }
    
    local FAVICON_EMPTY_RESPONSE = { status = 204 }
    local FAVICON_CACHED_RESPONSE: any = nil

    if isFile(faviconPath) then
        FAVICON_CACHED_RESPONSE = {
            status = 200,
            body = readFile(faviconPath),
            headers = {["Content-Type"] = "image/x-icon",
                ["Cache-Control"] = enableLogging and "no-cache" or "public, max-age=86400"
            }
        }
    end

    generateRoute(mainDir, "")

    local rootPipeline = Nova.chain(self.middlewares, routerDispatcher)

    serve(self.port, {
        address = "0.0.0.0",
        handleRequest = function(request)
            if request.path == "/favicon.ico" and request.method == "GET" then
                if enableLogging and isFile(faviconPath) then
                    return {
                        status = 200,
                        body = readFile(faviconPath),
                        headers = {["Content-Type"] = "image/x-icon",
                            ["Cache-Control"] = "no-cache"
                        }
                    }
                end
                return FAVICON_CACHED_RESPONSE or FAVICON_EMPTY_RESPONSE :: net.NetResponse
            end

            local success, result: types.ResponsePayload | any = pcall(rootPipeline , request)

            if not success then
                if enableLogging then
                    local errorMessage = debug.traceback(tostring(result), 2)
                    print("\27[31m[Error]: " .. errorMessage .. "\27[0m")
                end
                return INTERNAL_ERROR_RESPONSE :: net.NetResponse
            end

            local status: number
            local headers = nil

            if result.config then
                status = result.config.status
                headers = result.config.headers
            end

            if enableLogging then
                local color = "\27[31m"
                if status >= 200 and status < 300 then color = "\27[32m"
                elseif status >= 300 and status < 400 then color = "\27[34m" end
                print(string.format("[%s] %s %s%d\27[0m", request.method, request.path, color, status))
            end

            return {
                status = status or 200,
                body = result and result.body or nil,
                headers = headers
            }
        end
    })
    
    local finish = os.clock() - start
    print(string.format("\nReady in %.4f ms\n", finish * 1000))

    if handler then 
        handler()
    end
end

return Nova
