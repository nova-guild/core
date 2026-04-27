local http = zune.net.http
local Types = require("./types")
local normalizeHeader = require("../normalizeHeader")

local ZuneNet = {} :: Types.NetAdapter

local serve = http.serve
local req = http.request

function ZuneNet.serve(port, handlerOrConfig)
    if not (typeof(handlerOrConfig) == "table") then return end

    serve({
        port = port,
        address = handlerOrConfig.address,
        request = function(request)
            local res = handlerOrConfig.handleRequest(request :: any)

            if typeof(res) == "string" then
                return {
                    status_code = 200,
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
                status_code = res.status,
                headers = normalizedHeaders,
                body = res.body
            }
        end
    })
end

function ZuneNet.request(config: Types.FetchParams| string)
    if typeof(config) == "table" and config.url then
        return req(config.url, {
            headers = config.headers,
            method = config.method,
            body = config.body,
            
        }) :: any
    end

    return (req :: (string) -> Types.FetchResponse)(config)
end

return ZuneNet