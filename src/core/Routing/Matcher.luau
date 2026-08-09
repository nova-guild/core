local RouteHelper = require("./Helpers")

local function matchRouteFrom(
    node: RouteHelper.RouteNode,
    segments: { string },
    index: number,
    params: { [string]: any }
): RouteHelper.RouteNode?
    while index <= #segments do
        local segment = segments[index]

        if node.children[segment] then
            node = node.children[segment]
        elseif node.dynamicChild then
            if node.wildcardChild and node.wildcardChild.module then
                local dynamicParams = table.clone(params)
                dynamicParams[node.dynamicName :: string] = segment

                local result =
                    matchRouteFrom(node.dynamicChild :: RouteHelper.RouteNode, segments, index + 1, dynamicParams)
                if result then
                    for k, v in dynamicParams do
                        params[k] = v
                    end
                    return result
                end

                local remainingCount = #segments - index + 1
                local remaining = table.create(remainingCount)
                for i = index, #segments do
                    remaining[i - index + 1] = segments[i]
                end
                params[node.wildcardName :: string] = remaining
                return node.wildcardChild
            end

            params[node.dynamicName :: string] = segment
            node = node.dynamicChild :: RouteHelper.RouteNode
        elseif node.wildcardChild and node.wildcardChild.module then
            local remainingCount = #segments - index + 1
            local remaining = table.create(remainingCount)
            for i = index, #segments do
                remaining[i - index + 1] = segments[i]
            end
            params[node.wildcardName :: string] = remaining
            return node.wildcardChild
        else
            return nil
        end

        index += 1
    end

    if node.wildcardChild and node.wildcardChild.module then
        params[node.wildcardName :: string] = {}
        return node.wildcardChild
    end

    return node.module and node or nil
end

local function matchRoute(
    rootNode: RouteHelper.RouteNode,
    segments: { string },
    params: { [string]: any }
): RouteHelper.RouteNode?
    return matchRouteFrom(rootNode, segments, 1, params)
end

return {
    matchRoute = matchRoute,
    matchRouteFrom = matchRouteFrom,
}
