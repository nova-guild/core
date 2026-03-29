local Types = require("../types")

local function chain(middlewares: { Types.Middleware }?, finalHandler: Types.Handler)
    local queue = middlewares or {}

    local currentPipeline = function(req: any)
        local result = finalHandler(req)
        if result == nil then
            error("Final route handler did not return a response!")
        end
        return result
    end

    for i = #queue, 1, -1 do
        local middleware = queue[i]
        local nextHandler = currentPipeline
        
        currentPipeline = function(req: any)
            local nextCalled = false
            local nextResponse = nil
            
            local function nextFn()
                if nextCalled then
                    error(`next() was called multiple times in middleware #{i}`)
                end
                nextCalled = true
                nextResponse = nextHandler(req)
            end
            
            local result = (middleware :: Types.Middleware)(req, nextFn)
            
            if result ~= nil then
                return result
            elseif not nextCalled then
                error(`Middleware at index {i} failed to call next() or return a response!`)
            end
            
            if nextResponse == nil then
                error(`Middleware at index {i} did not return a response!`)
            end

            return nextResponse
        end
    end
    
    return function(rawReq: any)
        local req = {
            method = rawReq.method,
            path = rawReq.path,
            query = rawReq.query,
            headers = rawReq.headers,
            body = rawReq.body,
            
            locals = {},
            
            raw = rawReq 
        }
        
        return currentPipeline(req)
    end
end

return chain