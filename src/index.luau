local routeDispatcher = require("./core/Routing/Dispatcher")
local generateRoute = require("./core/Routing/Generator")
local loadEnv = require("./utils/LoadEnv")
local MainDir = require("./utils/MainDir")
local alias = require("./utils/Alias")
local attrRegistryGenerator = require("./core/Attribute/RegistryGenerator")
local RouteLogger = require("./utils/Logger")
local Chain = require("./utils/Chain")
local common = require("@mayari.common")
local adpt = require("@mayari.adpt")

export type Next = common.Next
export type Mayari = common.Mayari
export type Middleware = common.Middleware
export type Middleware2 = (req: Request | RequestWith<any>, next: Next) -> ResponsePayload?
export type Handler = common.Handler
export type Request = common.Request
export type RequestWith<T> = common.RequestWith<T>
export type ResponseOptions = common.ResponseOptions
export type ResponsePayload = common.ResponsePayload
export type Response = common.Response

-- Validator Schema
export type BodyField = common.BodyField
export type StringField = common.StringField
export type ValidatorSchema = common.ValidatorSchema

local net = adpt.net
local fs = adpt.fs
local json = adpt.json
local process = adpt.process

local serve = net.serve
local isFile = fs.isFile
local readFile = fs.readFile
local cwd = process.cwd

local Mayari = {}
Mayari.__index = Mayari

type MayariPrivate = typeof(Mayari)

local function statusLog(status: number, req)
    local statusColor = "\27[31m"
    if status >= 200 and status < 300 then
        statusColor = "\27[32m"
    elseif status >= 300 and status < 400 then
        statusColor = "\27[34m"
    end

    if req.path ~= "/favicon.ico" then
        local attrs = RouteLogger.getAttributes(req.path, req.method)
        local attrSuffix = attrs ~= "" and ("  " .. statusColor .. attrs .. "\27[0m") or ""
        print(string.format("[%s] %s %s%d\27[0m%s", req.method, req.path, statusColor, status, attrSuffix))
    end
end

local function devMiddleware(req: common.Request, next: common.Next)
    local res = next()
    local status = res.config.status or 200

    statusLog(status, req)
end

function Mayari.new(port: number, middlewares: { any }?)
    local self = setmetatable({} :: MayariPrivate, Mayari)
    self.port = port
    self.middlewares = middlewares
    self.dev = table.find(process.args, "dev") ~= nil

    loadEnv()
    alias.set("c", cwd, `{cwd}/packages/luau/.lpm/mayari_core/.luaurc`)
    alias.set("c", cwd)

    return self :: Mayari
end

function Mayari.listen(self: MayariPrivate, handler: () -> ())
    local start = os.clock()

    local mainDirName = MainDir
    local mainDir = `@c/{mainDirName}`

    local faviconPath = `{cwd}/{mainDirName}/favicon.ico`
    local isDev = self.dev

    local FAVICON_CACHED_RESPONSE: any = nil

    if isFile(faviconPath) then
        FAVICON_CACHED_RESPONSE = {
            status = 200,
            body = readFile(faviconPath),
            headers = {
                ["Content-Type"] = "image/x-icon",
                ["Cache-Control"] = "public, max-age=86400",
            },
        }
    end

    RouteLogger.setMiddlewares(self.middlewares or {})

    attrRegistryGenerator.loadRegistry(mainDir)
    generateRoute(mainDir, "")

    RouteLogger.flush()

    local allMiddlewares = self.middlewares and table.clone(self.middlewares) or {}

    if isDev then
        table.insert(allMiddlewares :: { common.Middleware }, 1, devMiddleware :: common.Middleware)
    end

    local rootPipeline = Chain(allMiddlewares :: { common.Middleware }, routeDispatcher)

    serve(self.port, {
        address = "0.0.0.0",
        handleRequest = function(request)
            if request.path == "/favicon.ico" and request.method == "GET" then
                if isDev and isFile(faviconPath) then
                    return {
                        status = 200,
                        body = readFile(faviconPath),
                        headers = {
                            ["Content-Type"] = "image/x-icon",
                            ["Cache-Control"] = "no-cache",
                        },
                    }
                end
                return FAVICON_CACHED_RESPONSE or { status = 204 }
            end

            local success, result: common.ResponsePayload | { statusCode: number, message: string } | any =
                pcall(rootPipeline, request)

            if not success then
                statusLog(result.statusCode or 500, request)
                if typeof(result) == "table" then
                    return {
                        status = result.statusCode,
                        body = json.encode({ error = result.message }),
                        headers = { ["Content-Type"] = "application/json" },
                    }
                else
                    local errorMessage = debug.traceback(tostring(result), 2)
                    print("\27[31m[Error]: \n" .. errorMessage .. "\27[0m")

                    return {
                        status = 500,
                        body = json.encode({ error = "Internal Server Error" }),
                        headers = { ["Content-Type"] = "application/json" },
                    }
                end
            end

            local status: number?
            local headers = nil

            if result.config then
                status = result.config.status
                headers = result.config.headers
            end

            return {
                status = status or 200,
                body = result and result.body or nil,
                headers = headers,
            }
        end,
    })

    local finish = os.clock() - start
    print(string.format("\nReady in %.4f ms\n", finish * 1000))

    if handler then
        handler()
    end
end

return Mayari
