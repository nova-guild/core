# Routing

Routing is the core of any Nova application. Nova uses a **Filesystem-based Router**, meaning the structure of your directories defines the paths of your API.

## The `route.luau` File

In Nova, every route is defined by a file named `route.luau`. For a directory to be recognized as a valid endpoint, it must contain this file.

## File Structure

Nova follows the Luau **Module** pattern. Your `route.luau` must return a table containing your request handlers.

```luau
local Home = {}

-- Handlers go here...

return Home
```

## Defining Handlers (HTTP Methods)

To handle specific HTTP methods (GET, POST, etc.), you define functions as properties of your returned table.

### Naming Rules

- **PascalCase:** Handlers must use PascalCase (e.g., `Get`, not `GET` or `get`).
- **Method Names:** Use standard HTTP method names: `Get`, `Post`, `Put`, `Delete`, `Patch`, etc.

```luau
local Users = {}

-- Handles GET /users
function Users.Get()
    
end

-- Handles POST /users
function Users.Post()
    
end

return Users
```

## Static Routes

Static routes are fixed paths. The folder name in your `app` directory matches the URL path exactly.

- `app/route.luau` -> `/`
- `app/users/route.luau` -> `/users`
- `app/settings/profile/route.luau` -> `/settings/profile`

## Dynamic Routes

Sometimes you don't know the exact segment name ahead of time (like a User ID). Nova supports two types of dynamic routes using special folder naming conventions.

### Route Parameters `[param]`

To create a dynamic segment, wrap the folder name in brackets: `[name]`. This captures a single segment of the URL.

- **Directory:** `app/users/[id]/route.luau`
- **URL:** `/users/123`
- **Access:** The value is available in `req.params` as a string.

Here is an example of how to access the route paramter (the name matches the directory name without the brackets):

```luau
local UserId = {}

function UserId.Get(req)
    local userId = req.params.id -- The params table now contains an id field
    
end

return UserId
```

### Wildcard Routes `[...param]`

Wildcard routes (or **Catch-all** routes) are greedy. They capture every remaining segment of the URL. To create one, prefix the name inside the brackets with three dots `...`.

- **Directory:** `app/files/[...path]/route.luau`
- **URL:** `/files/documents/work/resume.pdf`
- **Access:** The value is available in `req.params` as a **table of strings**.

| URL | `req.params.path` |
| :--- | :--- |
| `/files/a` | `{"a"}` |
| `/files/a/b/c` | `{"a", "b", "c"}` |

```luau
local FileViewer = {}

function FileViewer.Get(req)
    local pathSegments = req.params.path -- {"documents", "work", "resume.pdf"}
    local fullPath = table.concat(pathSegments, "/") -- "documents/work/resume.pdf"
    
end

return FileViewer
```

::: warning
When using Wildcard routes to map URL segments to actual files on your disk (as shown in the example above), you must be extremely careful.

Because wildcards capture **all** segments, a malicious user could attempt to access sensitive files outside of your intended directory by using `".."` (parent directory) sequences or absolute paths.
:::