local RouteHelper = require("./Helpers")
local RouteMatcher = require("./Matcher")

local splitPath = RouteHelper.splitPath
local createNode = RouteHelper.createNode
local matchRouteFrom = RouteMatcher.matchRouteFrom

local function createTestRouter()
    local staticRoute: { [string]: any } = {}
    local root: RouteHelper.RouteNode = { children = {} }

    return {
        registerRoute = function(path: string, module: any)
            if not string.find(path, "%[") then
                staticRoute[path] = module
                return
            end

            local segments = splitPath(path)
            local currentNode = root

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
        end,

        matchRoute = function(path: string, params: { [string]: any })
            local cleanPath = path
            if #cleanPath > 1 and string.byte(cleanPath, -1) == 47 then
                cleanPath = string.sub(cleanPath, 1, -2)
            end

            if staticRoute[cleanPath] then
                return staticRoute[cleanPath]
            end

            local segments = splitPath(cleanPath)
            local node = matchRouteFrom(root, segments, 1, params)
            return node and node.module or nil
        end,
    }
end

return createTestRouter
