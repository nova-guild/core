local RouteHelper = require("./Helpers")

local staticRoutes = RouteHelper.staticRoutes
local routeTreeRoot = RouteHelper.routeTreeRoot

local splitPath = RouteHelper.splitPath
local createNode = RouteHelper.createNode

local function registerRoute(path: string, module: any)
    if not string.find(path, "%[") then
        staticRoutes[path] = module
        return
    end

    local segments = splitPath(path)
    local currentNode = routeTreeRoot

    for _, segment in ipairs(segments) do
        if string.byte(segment, 1) == 91 and string.byte(segment, -1) == 93 then
            local paramName = string.sub(segment, 2, -2)

            if string.sub(paramName, 1, 3) == "..." then
                local cleanName = string.sub(paramName, 4)
                if not currentNode.wildcardChild then
                    currentNode.wildcardChild = createNode()
                    currentNode.wildcardName = cleanName
                end
                currentNode = currentNode.wildcardChild :: RouteHelper.RouteNode
            else
                if not currentNode.dynamicChild then
                    currentNode.dynamicChild = createNode()
                    currentNode.dynamicName = paramName
                end
                currentNode = currentNode.dynamicChild :: RouteHelper.RouteNode
            end
        else
            if not currentNode.children[segment] then
                currentNode.children[segment] = createNode()
            end
            currentNode = currentNode.children[segment]
        end
    end

    currentNode.module = module
end

return registerRoute
