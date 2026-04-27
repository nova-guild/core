local server = require("@lute/net/server")
local client = require("@lute/net/client")
local Types = require("./types")
local normalizeHeader = require("../normalizeHeader")

local LuteNet = {} :: Types.NetAdapter

local req = client.request
local serve = server.serve

function LuteNet.serve(port, handlerOrConfig)
    if not (typeof(handlerOrConfig) == "table") then return end

    serve({
        port = port,
        hostname = handlerOrConfig.address,
        handler = function(request)
            local res = handlerOrConfig.handleRequest(request :: any)
            
            if typeof(res) == "string" then
                return {
                    status = 200,
                    body = res
                }
            end

            local normalizedHeaders = {}

            if not res.headers then
                normalizedHeaders = res.headers
            else
                for header, value in pairs(res.headers) do
                    local newHeader = normalizeHeader(header)
                    normalizedHeaders[newHeader] = value
                end
            end

            return {
                status = res.status,
                headers = normalizedHeaders,
                body = res.body :: string
            }
        end
    })
end

function LuteNet.request(config)
    
    if typeof(config) == "table" and config.url then
        return req(config.url, {
            headers = config.headers,
            method = config.method,
            body = config.body,
            
        }) :: any
    end

    return req(config) :: any
end

return LuteNet
