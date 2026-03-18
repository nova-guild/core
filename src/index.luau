--!optimize 2
--!native

local net = require("@lune/net")
local fs = require("@lune/fs")
local serde = require("@lune/serde")
local process = require("@lune/process")
local types = require("./types")
local Routing = require("./core/routing")
local loadEnv = require("./utils/loadEnv")
local findMainDir = require("./utils/findMainDir")
local generateRoute = require("./core/generateRoute")
local generateAlias = require("./utils/generateAlias")

export type Next = types.Next
export type Nova = types.Nova
export type Request = types.Request
export type RequestWith<T> = types.RequestWith<T>
export type ResponseOptions = types.ResponseOptions

local Nova = {}
Nova.__index = Nova

Nova.chain = require("./utils/chain")
Nova.response = require("./utils/response")

function Nova.new(port: number, middlewares: { (req: types.Request, next: types.Next) -> () }?) 
    local self = setmetatable({}, Nova)
    self.port = port
    self.middlewares = middlewares

    loadEnv()

    return self :: Nova
end

function Nova:listen(handler: () -> ())
    local start = os.clock()
    generateAlias()
        
    local mainDirName = findMainDir()
    local mainDir = `@c/{mainDirName}`
        
    local faviconPath = `{process.cwd}/{mainDirName}/favicon.ico`
    local faviconData: string? = nil

    if fs.isFile(faviconPath) then
        faviconData = fs.readFile(faviconPath)
    end

    generateRoute(mainDir, "")

    local rootPipeline = Nova.chain(self.middlewares, Routing.routerDispatcher)

    net.serve(self.port, {
        address = "http://0.0.0.0",
        handleRequest = function(request)
            local startReq = os.clock()

            if request.path == "/favicon.ico" and request.method == "GET" then
                local currentData = faviconData

                if process.env.LUNE_ENV and fs.isFile(faviconPath) then
                    currentData = fs.readFile(faviconPath)
                end

                if currentData then
                    return {
                        status = 200,
                        body = currentData,
                        headers = {
                            ["Content-Type"] = "image/x-icon",
                            ["Cache-Control"] = process.env.LUNE_ENV and "no-cache" or "public, max-age=86400"
                        }
                    }
                else
                    return { status = 204 }
                end
            end

            local success, result: types.ResponsePayload = pcall(rootPipeline, request)

            local status: number = 200
            
            if not success then 
                status = 500
            elseif result and result.config then
                status = result.config.status or 200
            end

            local color = "\27[31m"
            if status >= 200 and status < 300 then
                color = "\27[32m"
            elseif status >= 300 and status < 400 then
                color = "\27[34m"
            end
            local reset = "\27[0m"

            local finishReq = os.clock()

            print(string.format("[%s] %s %s%d%s in %.3fms", request.method, request.path, color, status, reset, (finishReq - startReq) * 1000))
            
            local finalHeaders = {}
            if success then 
                if process.env.LUNE_ENV == "dev" then
                    finalHeaders["X-Powered-By"] = "Nova-Framework"
                end

                if result.config and result.config.headers then
                    for key, value in pairs(result.config.headers) do
                        finalHeaders[key] = value
                    end
                end

                return {
                    status = status,
                    body = result.body,
                    headers = finalHeaders
                }
            else
                local errorMessage = tostring(result)

                finalHeaders["Content-Type"] = "application/json"
                finalHeaders["X-Powered-By"] = "Nova-Framework"

                return {
                    status = 500,
                    body = serde.encode("json", {
                    error = "Internal Server Error",
                    message = process.env.LUNE_ENV == "dev" and errorMessage or "An unexpected error occurred", 
                    }),
                    headers = finalHeaders
                }
            end
        end
    })
    local finish = os.clock() - start
    print(string.format("\nReady in %.4f ms\n", finish * 1000))

    if handler then 
        handler()
    end
end

return Nova
