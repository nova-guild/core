# Requests & Responses

In Nova, data flows through your application via the Request object and is sent back to the client using the Response utility.

## The Request Object

The `req` object is passed to every middleware and route handler. It contains all the necessary data about the incoming HTTP call.

| Property | Type | Description |
| :--- | :--- | :--- |
| `path` | `string` | The requested URL path (e.g., `/users/123`). |
| `method` | `string` | The HTTP method (e.g., `GET`, `POST`). |
| `headers` | `table` | Key-value pairs of request headers. |
| `query` | `table` | Key-value pairs of URL query parameters. |
| `params` | `table` | Captured values from dynamic segments like `[id]`. |
| `body` | `any` | The raw or parsed request body. |

## The Response Utility

While you can return a raw table, it is highly recommended to use `Nova.response` to ensure your headers and status codes are set correctly.

```lua
local Nova = require("@path/to/nova")

-- Usage
Nova.response(body, options)
```

## JSON Responses (Default)

By default, Nova assumes you are building an API. Any table passed as a body will be automatically encoded to JSON.

```lua
function Route.Get(req)
    return Nova.response({ success = true }, { status = 200 })
end
```

## HTML Responses

Nova can also serve server-side rendered strings. Set the `isHtml` flag to `true` to update the `Content-Type` header automatically.

```lua
function Route.Get(req)
    local html = "<html><body><h1>Hello from Nova</h1></body></html>"
    return Nova.response(html, { isHtml = true })
end
```

## Status Codes

You can pass any valid HTTP status code in the options table. Common examples:

`200` : OK (Default)

`201` : Created

`400` : Bad Request

`401` : Unauthorized

`404` : Not Found

`500` : Internal Server Error

## Detailed Errors in Development

Nova's error handler is environment-aware. If you set your environment variable `LUNE_ENV=dev`, Nova will return the full Luau stack trace in the response body when a 500 error occurs, making it much easier to debug crashes in your handlers or middleware.
