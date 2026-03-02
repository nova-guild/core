# Middleware Guide

Middleware allows you to run code before your route handler. In Nova, middlewares are functions that receive the `Request` and a `Next` function.

## What is Middleware?

A middleware function acts as a layer in a pipeline. It can:

1. Execute any code.
2. Make changes to the request object.
3. End the request-response cycle (by returning a response early).
4. Call the `next` middleware in the stack.

## Global Middleware

Global middlewares run for every single request that enters your server. You define these when initializing the `Nova` instance.

```lua
local Nova = require("@path/to/nova")

local function logger(req: Nova.Request, next: Nova.Next)
    print("Incoming request to: " .. req.path)
    return next(req) -- You must return next(req) to continue the chain
end

local app = Nova.new(8080, { logger })
```

## Route-Specific Middleware

If you only want middleware to run on a specific route (e.g., authentication on a dashboard), use the `Nova.chain` helper in your `route.luau` file.

```lua
-- app/admin/route.luau
local Nova = require("@path/to/nova")

local function protect(req, next)
    local auth = req.headers["authorization"]
    if not auth then
        return Nova.response({ error = "Unauthorized" }, { status = 401 })
    end
    return next(req)
end

local Admin = {}

-- Wrap the handler in a chain
Admin.Get = Nova.chain({ protect }, function(req)
    return Nova.response({ data = "Welcome, Admin" })
end)

return Admin
```

## The Importance of `return`

In Nova, middlewares are functional. You must return the result of the `next(req)` call. If you forget to return, the chain will break and the server will return an error.

```lua
-- WRONG
function middleware(req, next)
    next(req)
end

-- CORRECT
function middleware(req, next)
    return next(req)
end
```

## Next Steps

Now that you can intercept requests, learn about the data structures used for communication in the Requests & Responses guide.
