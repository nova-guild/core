--!optimize 2
--!native

local net = require("@lune/net")
local fs = require("@lune/fs")
local serde = require("@lune/serde")
local process = require("@lune/process")
local types = require("./types")
local Routing = require("./core/routing")
local Try = require("./utils/try")
local loadEnv = require("./utils/loadEnv")
local findMainDir = require("./utils/findMainDir")
local generateRoute = require("./core/generateRoute")
local generateAlias = require("./utils/generateAlias")

export type Next = types.Next
export type Nova = types.Nova
export type Request = types.Request
export type RequestWith<T> = types.RequestWith<T>
export type ResponseBody = types.ResponseBody
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
    Try.new(function()
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

                local success, result = pcall(rootPipeline, request)

                local status = 200

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

                print(`[{request.method}] {request.path} {color}{status}{reset}`)

                if success then 
                    local body = result.body
                    local contentType = "application/json"

                    if result.config then
                        if result.config.isHtml then
                            contentType = "text/html"
                        elseif result.config.contentType then
                            contentType = result.config.contentType
                        elseif result.config.headers and result.config.headers["Content-Type"] then
                            contentType = result.config.headers["Content-Type"]
                        end
                    end
                    
                    if not result.config.isHtml then 
                        if type(body) == "table" then 
                            body = serde.encode("json", body)
                            if contentType == "text/plain" then contentType = "application/json" end
                        else
                            if type(body) ~= "string" then body = tostring(body) end
                        end
                    end

                    local finalHeaders = {}
                    finalHeaders["Content-Type"] = contentType

                    if process.env.LUNE_ENV == "dev" then
                        finalHeaders["X-Powered-By"] = "Nova-Framework"
                    end

                    if result.config and result.config.headers then
                        for key, value in pairs(result.config.headers) do
                            finalHeaders[key] = value
                        end
                    end

                    local finishReq = os.clock()
                    
                    if process.env.LOGGER == "dev" then 
                        print(string.format("Request Done in %.4f ms", (finishReq - startReq) * 1000))
                    end

                    return {
                        status = status,
                        body = body,
                        headers = finalHeaders
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
            end
        })

        local finish = os.clock() - start
        print(string.format("\nReady in %.4f ms\n", finish * 1000))

        if handler then 
            handler()
        end
    end)
    :catch(function(err: string)
        print("\n" .. err)
    end)
end

return Nova
