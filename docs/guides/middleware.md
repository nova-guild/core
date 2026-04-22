# Middleware

Middleware is one of the fundamental features of Nova. It allows you to intercept, inspect, or modify requests before they reach your route handlers, and perform actions after the handler has finished.

Common use cases include:

- **Logging:** Tracking request times and paths.
- **Authentication:** Checking if a user is logged in.
- **Validation:** Ensuring the request body contains the correct data.
- **Security:** Adding headers or blocking malicious IPs.

## The Middleware Function

A middleware in Nova is a simple function that receives two arguments:

- `req:` The Request object.
- `next:` A function that, when called, passes control to the next middleware in the stack.

### The Onion Pattern

Nova uses the **Onion Pattern**. This means that when you call `next()`, the code execution **dives** into the next middleware or the final handler. Once the handler finishes, the execution "bubbles" back up, running the code after `next()`.

```luau
local function myMiddleware(req, next)
    print("1. This runs BEFORE the route handler")
    
    next() -- Move to the next middleware or handler
    
    print("2. This runs AFTER the route handler is finished")
end
```

## Global Middleware

Global middlewares are executed for **every single request** made to your server. These are defined when you initialize your Nova application.

The `Nova.new()` constructor accepts an optional second argument: a table of middleware functions.

```luau
local Nova = require("path/to/nova")

local app = Nova.new(8080, {
    function(req, next)
        print(`[{req.method}] {req.path}`)
        next()
    end,
    function(req, next)
        -- Another global middleware
        next()
    end
})

app:listen(function()
    print("Server running on http://localhost:8080")
end)
```

## Route-Specific Middleware (`Nova.chain`)

Sometimes you only want middleware to run on specific routes (e.g., protecting a `/dashboard` route). For this, Nova provides the `Nova.chain` utility.

`Nova.chain` takes two arguments:

- A table of middlewares.
- The final route handler function.

Usage in `route.luau`

```luau
local Nova = require("path/to/nova")

local Home = {}

-- A simple auth middleware
local function checkAuth(req, next)
    if req.headers["Authorization"] then
        next()
    else
        -- If we don't call next(), the chain stops here
        return Nova.response.json({ error = "Unauthorized" }, { status = 401 })
    end
end

-- Using Nova.chain to protect this specific GET route
Home.Get = Nova.chain({ checkAuth }, function(req)
    return Nova.response.json({ 
        message = "Welcome to the protected dashboard!" 
    })
end)

return Home
```

## Execution Order

It is important to understand the order in which Nova executes your code:

- **Global Middlewares:** Executed in the order they were defined in `Nova.new`.
- **Route Middlewares:** Executed in the order they appear in the `Nova.chain` table.
- **Route Handler:** The actual logic inside your `Home.Get` or similar function.
- **The "Bubble Up":** The code after `next()` in all middlewares runs in reverse order.

**Example Flow:**

If you have Global Middleware `A`, Route Middleware `B`, and Handler` C`:
`A (before next)` → `B (before next)` → `C (Handler)` → `B (after next)` → `A (after next)`

## Important Notes

- **Always call `next()`:** If you do not call `next()`, the request will "hang" and never reach the handler (unless you intentionally return a response early to stop the request).
- **Order Matters:** If Middleware A depends on data added to the request by Middleware B, Middleware B must come first in the table.