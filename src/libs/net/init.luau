local Types = require("./net/types")
local checkRuntime = require("./checkRuntime")

export type NetResponse = Types.NetResponse
export type NetRequest = Types.NetRequest
export type NetConfig = Types.NetConfig
export type FetchParams = Types.FetchParams
export type FetchResponse = Types.FetchResponse

local function getAdapter(): Types.NetAdapter
    local runtime = checkRuntime()

    if runtime == "lune" then
        return require("@self/lune")
    elseif runtime == "zune" then
        return require("@self/zune")
    elseif runtime == "luau" then
        return require("@self/lute")
    else
        error(`Unsupported Runtime: "{runtime}"`)
    end
end

return getAdapter()
