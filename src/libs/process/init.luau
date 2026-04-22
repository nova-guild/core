local Types = require("./process/types")
local checkRuntime = require("./checkRuntime")

local function getAdapter(): Types.ProcessAdapter
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
