local Types = require("../types")
local Response = require("../utils/response")
local BodyParsers = require("./bodyParsers")

local staticRoutes: { [string]: any } = {}

type RouteNode = {
    children: { [string]: RouteNode },
    dynamicChild: RouteNode?,
    dynamicName: string?,
    wildcardChild: RouteNode?,
    wildcardName: string?,
    module: any?
}

local routeTreeRoot: RouteNode = {
    children = {},
    dynamicChild = nil,
    dynamicName = nil,
    module = nil
}

local function splitPath(path: string): {string}
    local segments = {}
    for segment in string.gmatch(path, "[^/]+") do
        table.insert(segments, segment)
    end
    return segments
end

local function createNode(): RouteNode
    return { children = {} }
end

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
                currentNode = currentNode.wildcardChild :: RouteNode
            else
                if not currentNode.dynamicChild then
                    currentNode.dynamicChild = createNode()
                    currentNode.dynamicName = paramName
                end
                currentNode = currentNode.dynamicChild :: RouteNode
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

local function matchRoute(node: RouteNode, segments: {string}, index: number, params: {[string]: any}): RouteNode?
    if index > #segments then
        return node.module and node or nil
    end

    local segment = segments[index]

    if node.children[segment] then
        local result = matchRoute(node.children[segment], segments, index + 1, params)
        if result then return result end
    end

    if node.dynamicChild then
        local result = matchRoute(node.dynamicChild, segments, index + 1, params)
        if result then
            params[node.dynamicName :: string] = segment
            return result
        end
    end

    if node.wildcardChild and node.wildcardChild.module then
        local remainingCount = #segments - index + 1
        local remaining = table.create(remainingCount) 
        
        local c = 1
        for i = index, #segments do
            remaining[c] = segments[i]
            c += 1
        end
        
        params[node.wildcardName :: string] = remaining
        return node.wildcardChild
    end

    return nil
end

local function routerDispatcher(request: Types.Request)
    local cleanPath = request.path
    local pathLen = #cleanPath

    if pathLen > 1 and string.byte(cleanPath, pathLen) == 47 then 
        cleanPath = string.sub(cleanPath, 1, pathLen - 1)
    end

    local method = request.method
    method = string.upper(string.sub(method, 1, 1)) .. string.lower(string.sub(method, 2))

    local req = {
        method = request.method,
        path = cleanPath,
        body = request.body or {},
        headers = request.headers,
        query = request.query or {},
        params = {}
    } :: Types.Request

    local rawBody = request.body or ""
    if #rawBody > 0 then
        if not request.headers then 
            return Response.json({ error = "Conflict" }, { status = 409 })
        end

        local rawType = request.headers["content-type"] or request.headers["Content-Type"] or ""
        local cleanType = string.split(rawType, ";")[1]
        local parser = BodyParsers[cleanType]

        if not parser then 
            return Response.json({ error = "Unsupported Media Type" }, { status = 415 })
        end

        req.body = parser(rawBody :: string) :: {any}
    end

    local matchedModule = staticRoutes[cleanPath]
    
    if not matchedModule then
        local segments = splitPath(cleanPath)
        local matchedNode = matchRoute(routeTreeRoot, segments, 1, req.params)

        if not matchedNode or not matchedNode.module then
            return Response.json({ error = "Not Found" }, { status = 404 })
        end
        
        matchedModule = matchedNode.module
    end

    local handler = matchedModule[method]

    if type(handler) ~= "function" then 
        if method == "Head" then 
            handler = matchedModule["Get"]
            if type(handler) ~= "function" then
                error("The request method is Head but neither function Head nor Get are found")
            end
        else
            return Response.json({ error = "Method Not Allowed" }, { status = 405 })
        end
    end

    return handler(req)
end

return { 
    registerRoute = registerRoute, 
    routerDispatcher = routerDispatcher 
}
