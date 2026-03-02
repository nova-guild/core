--[[
    Helper function for chaining multiple middlewares
]]
function chain(middlewares: { (req: any, next: any) -> any }, finalHandler: (req: any) -> any)
    return function(initialRequest)
        local index = 1

        local function runNext(req)
            local middleware = middlewares[index]
            if middleware then
                index += 1
                return middleware(req, runNext)
            else
                return finalHandler(req)
            end
        end

        return runNext(initialRequest)
    end
end

return chain