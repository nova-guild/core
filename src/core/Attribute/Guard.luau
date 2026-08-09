local registry = require("./RegistryGenerator").registry
local common = require("@mayari.common")
local Exception = common.exception

local function Guard(args: { string })
    return function(req: common.Request, next: common.Next)
        local attribute = registry["Guard"]

        if not attribute then
            return next()
        end

        for _, arg in args do
            local rule = attribute[arg]

            if not rule then
                continue
            end

            local isAllowed = rule(req)

            if not isAllowed then
                error(Exception.Unauthorized())
            end
        end

        return next()
    end
end

return Guard
