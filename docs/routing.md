# Routing Guide

Nova uses a filesystem-based router. This means the structure of your `app` directory directly defines the URL structure of your API or website.

## Directory Structure Rules

Nova recursively scans the `app` folder for `route.luau` files. Each file represents a set of HTTP handlers for that specific path.

| URL Path | Filesystem Location |
| :--- | :--- |
| `/` | `app/route.luau` |
| `/auth/login` | `app/auth/login/route.luau` |
| `/posts/:id` | `app/posts/[id]/route.luau` |

## Defining Handlers

Inside a `route.luau` file, you export a table where keys correspond to HTTP methods (e.g., `get` or `Get`).

```lua
local Nova = require("@path/to/nova")

local Route = {}

function Route.Get(req)
    return Nova.response({ body = "Hello GET" })
end

function Route.Post(req)
    return Nova.response({ body = "Hello POST" })
end

return Route
```

## Dynamic Routing

To create a dynamic route, wrap a folder name in square brackets `[ ]`. This tells Nova that the segment is a variable that should be captured.

### Example: User Profiles

If you create `app/users/[id]/route.luau`, it will match URLs like `/users/123` or `/users/john`

You can access these variables via the `req.params` table:

```lua
-- app/users/[id]/route.luau
local Nova = require("@path/to/nova")
local User = {}

function User.Get(req: Nova.RequestWith<{ id: string }>)
    local userId = req.params.id

    return Nova.response({
        body = {
            message = "Fetching data for user: " .. userId
        }
    })
end

return User
```

## Nested Parameters

Nova supports multiple dynamic segments in a single path.

- **Path:** app/orgs/[orgId]/members/[memberId]/route.luau

- **URL:** /orgs/nova-team/members/admin

- **Access:** req.params.orgId and req.params.memberId

## Trailing Slashes

Nova automatically normalizes incoming URLs. A request to `/users/` is treated exactly the same as a request to `/users`, preventing duplicate route errors.

## Next Steps

After defining your routes, learn how to protect them or add pre-processing logic in the Middleware guide.
