--!optimize 2

local Types = require("../types")
local Response = require("../utils/response")
local serde = require("@lune/serde")

local staticRoutes = {}
local routeTreeRoot = {
    children = {},
    dynamicChild = nil,
    dynamicName = nil,
    module = nil
}

local function splitPath(path: string)
    local segments = {}
    for segment in path:gmatch("[^/]+") do
        table.insert(segments, segment)
    end
    return segments
end

local function createNode()
    return { children = {}, dynamicChild = nil, dynamicName = nil, module = nil }
end

local function registerRoute(path: string, module: any)
    if not path:match("%[.-%]") then
        staticRoutes[path] = module
        return
    end

    local segments = splitPath(path)
    local currentNode = routeTreeRoot

    for _, segment in ipairs(segments) do
        local paramName = segment:match("^%[(.+)%]$")
        
        if paramName then
            if not currentNode.dynamicChild then
                currentNode.dynamicChild = createNode()
                currentNode.dynamicName = paramName
            end
            
            currentNode = currentNode.dynamicChild
        else
            if not currentNode.children[segment] then
                currentNode.children[segment] = createNode()
            end
            currentNode = currentNode.children[segment]
        end
    end
    
    currentNode.module = module
end

local function routerDispatcher(request)
    local cleanPath = request.path
    if #cleanPath > 1 and cleanPath:sub(-1) == "/" then
        cleanPath = cleanPath:sub(1, -2)
    end

    local method = request.method:sub(1, 1):upper() .. request.method:sub(2):lower()

    local rawBody = request.body or ""
    local decodedBody = {}

    if #rawBody > 0 then
        local success, result = pcall(function()
            return serde.decode("json", rawBody)
        end)
        
        if success then
            decodedBody = result
        else
            print("Warning: Failed to decode JSON body")
        end
    end

    local req = {
        method = request.method,
        path = cleanPath,
        body = decodedBody,
        headers = request.headers,
        query = request.query or {},
        params = {}
    } :: Types.Request

    local staticModule = staticRoutes[cleanPath]
    if staticModule then
        local handler = staticModule[method]

        if method == "Head" and not handler then
            handler = staticModule["Get"]
        end

        if type(handler) == "function" then
            return handler(req)
        else
            return Response.json({ error = "Method Not Allowed" }, { status = 405 })
        end
    end

    local segments = splitPath(cleanPath)
    local currentNode = routeTreeRoot

    for _, segment in ipairs(segments) do
        if currentNode.children[segment] then
            currentNode = currentNode.children[segment]
        elseif currentNode.dynamicChild then
            req.params[currentNode.dynamicName] = segment
            currentNode = currentNode.dynamicChild
        else
            return Response.json({ error = "Not Found" }, { status = 404 })
        end
    end

    local matchedModule = currentNode.module
    if not matchedModule then 
        return Response.json({ error = "Not Found" }, { status = 404 }) 
    end

    local handler = matchedModule[method]

    if method == "Head" and not handler then
        handler = matchedModule["Get"]
    end

    if type(handler) ~= "function" then 
        return Response.json({ error = "Method Not Allowed" }, { status = 405 })
    end

    return handler(req)
end

return { 
    registerRoute = registerRoute, 
    routerDispatcher = routerDispatcher 
}
