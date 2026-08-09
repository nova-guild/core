local registry = require("./RegistryGenerator").registry
local common = require("@mayari.common")

local function Interceptor(args: { string })
    return function(req: common.Request, next: common.Next)
        local attribute = registry["Interceptor"]

        if not attribute then
            return next()
        end

        local rules = {}
        for _, arg in args do
            local rule = attribute[arg]
            if rule then
                table.insert(rules, rule)
            end
        end

        if #rules == 0 then
            return next()
        end

        local function buildChain(index: number): common.Next
            if index > #rules then
                return next
            end
            return function()
                return rules[index](req, buildChain(index + 1))
            end
        end

        return buildChain(1)()
    end
end

return Interceptor
