export type RouteNode = {
    children: { [string]: RouteNode },
    dynamicChild: RouteNode?,
    dynamicName: string?,
    wildcardChild: RouteNode?,
    wildcardName: string?,
    module: any?,
}

type METHOD_MAP = {
    [string]: string,
}

local staticRoutes: { [string]: any } = {}

local routeTreeRoot: RouteNode = {
    children = {},
    dynamicChild = nil,
    dynamicName = nil,
    module = nil,
}

local METHOD_MAP = {
    GET = "Get",
    POST = "Post",
    PUT = "Put",
    DELETE = "Delete",
    PATCH = "Patch",
    HEAD = "Head",
} :: METHOD_MAP

local function splitPath(path: string): { string }
    local segments = {}
    for segment in path:gmatch("[^/]+") do
        table.insert(segments, segment)
    end
    return segments
end

local function createNode(): RouteNode
    return { children = {} }
end

return {
    staticRoutes = staticRoutes,
    routeTreeRoot = routeTreeRoot,
    METHOD_MAP = METHOD_MAP,
    splitPath = splitPath,
    createNode = createNode,
}
