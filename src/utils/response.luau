--!optimize 2

local Types = require("../types")
local serde = require("@lune/serde")

--[[
    Helper function for sending responses
]]
local Response = {} :: Types.Response

local function generateResponse(body: Types.ResponseBody, config: Types.ResponseOptions?) 
    return {
        body = body, 
        config = { 
            status = config.status, 
            headers = config.headers
        }
    }
end

function Response.send(body: string, config: Types.ResponseOptions?) 
    return generateResponse(tostring(body), { 
        status = config and config.status or 200,
        headers = config and config.headers or {
            ["Content-Type"] = "text/plain"
        }
     })
end

function Response.json(body: {any}, config: Types.ResponseOptions?)
    local encodedBody = serde.encode("json", body)

    return generateResponse(encodedBody, {
        status = config and config.status or 200,
        headers = config and config.headers or {
            ["Content-Type"] = "application/json"
        }
    })
end

function Response.html(body: string, config: Types.ResponseOptions?) 
    return generateResponse(tostring(body), {
        status = config and config.status or 200,
        headers = config and config.headers or {
            ["Content-Type"] = "text/html"
        }
    })
end

function Response.js(body: string, config: Types.ResponseOptions?) 
    return generateResponse(tostring(body), {
        status = config and config.status or 200,
        headers = config and config.headers or {
            ["Content-Type"] = "text/javascript"
        }
    })
end

function Response.css(body: string, config: Types.ResponseOptions?) 
    return generateResponse(tostring(body), {
        status = config and config.status or 200,
        headers = config and config.headers or {
            ["Content-Type"] = "text/css"
        }
    })
end

return Response
