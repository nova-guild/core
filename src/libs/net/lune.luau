local net = require("@lune/net")
local Types = require("./types")

local LuneNet = {} :: Types.NetAdapter

local serve = net.serve
local request = net.request

function LuneNet.serve(port, handlerOrConfig)
    serve(port, handlerOrConfig :: any)
end

function LuneNet.request(config)
    return request(config :: any) :: any
end

return LuneNet
