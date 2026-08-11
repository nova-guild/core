# Interceptor

An Interceptor wraps the route handler, giving you access to both the incoming request and the outgoing response. This makes it useful for logging, response transformation, timing, and similar cross-cutting concerns.

Interceptors are the last Attribute to execute before the handler:

```bash
Guard → Validator → Interceptor → Route Handler`
```

## Defining an Interceptor Attribute

Apply an Interceptor to a route handler using the `--@Interceptor` comment above the function:

```luau
local common = require("@mayari.common")
local response = common.response

local Home = {}

--@Interceptor(Transform)
function Home.Get()
    return response.send("Hello, World")
end

return Home
```

Multiple rules can be passed:

```luau
--@Interceptor(Logger, Transform)
function Home.Get()
    return response.send("Hello, World")
end
```

## Defining an Interceptor Rule

Interceptor Rules live in `src/interceptors/`. Each file exports a single function that receives `req` and `next`.

```luau
-- src/interceptors/Logger.luau
local common = require("@mayari.common")

local function Logger(req: common.Request, next: common.Next)
    print(`[{req.method}] {req.path}`)
    next()
end

return Logger
```

## The Onion Pattern

Interceptors follow the **Onion Pattern**. Calling `next()` dives into the remaining pipeline — the next Interceptor rule or the final route handler. Any code after `next()` runs once the handler has finished, on the way back out.

```luau
local common = require("@mayari.common")

local function Logger(_req: common.Request, next: common.Next)
    local start = os.clock()

    next()

    local elapsed = os.clock() - start
    print(`Request took {elapsed * 1000} ms`)
end

return Logger
```

## Intercepting the Response

If you return a value from an Interceptor rule, it replaces whatever the handler returned. This is how you transform or override responses:

```luau
local common = require("@mayari.common")

local function Transform(_req: common.Request, next: common.Next)
    next()
    return response.json({ message = "Intercepted" })
end

return Transform
```

Here, `next()` still runs the handler, but since `Transform` does not capture its return value, it replaces the response with its own.
