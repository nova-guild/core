# Request & Response

Every route handler in Mayari receives a `Request` object. Your job is to process that request and return a `Response` using Mayari's built-in utilities.

## The Request Object

Even if you don't explicitly use it, every handler is passed a request object.

### A Note on Naming

In our examples, we use the name `req`. However, you can name this parameter anything you like. Because of how Luau works, Mayari will always pass the Request object as the first argument, regardless of what you call it.

```luau
-- This works perfectly fine!
function Home.Get(banana)
    print(banana.path)

end
```

### Request Properties

A standard `common.Request` contains:

- **method:** The HTTP method (e.g., `"GET"`, `"POST"`).
- **path:** The exact URL path requested.
- **body:** The parsed data sent by the client.
- **headers:** A table of all request headers.
- **params:** Data from dynamic route segments (like `[id]`).
- **query:** Data from the URL search string (like `?search=hi`).

## Using Types

Mayari provides two main types for requests. You can access these by requiring Mayari in your route file.

### 1. `common.Request`

Use this for standard routes where you don't need specific autocomplete for parameters or query strings.

```luau
function Home.Get(req: common.Request)
    local method = req.method -- This will show when you type it
end
```

### 2. `common.RequestWith<T>`

Use this when you want to add type-checking and autocomplete for `req.params` or `req.query`.

::: info IMPORTANT 
Types are for your editor's benefit. Mayari does not automatically convert types (e.g., a string `"123"` won't automatically become a number `123`), so you'll still need to parse them manually.
:::

```luau
-- We tell the editor to expect an 'id' string
function User.Get(req: common.RequestWith<{ id: string }>)
    local userId = req.params.id -- Autocomplete works here!
end
```

## The Response Utility

Mayari provides a `response` utility to handle the **boring stuff** like setting `Content-Type` headers and status codes.

### Response Types

There are 5 methods available:

- `common.response.send(string)` Plain text.
- `common.response.json(table)` JSON data (automatically encoded).
- `common.response.html(string)` HTML content.
- `common.response.css(string)` CSS content.
- `common.response.js(string)` JavaScript content.

### The Response Config

Every response function accepts two arguments: `(body, config)`.
The `config` is an optional table where you can define a custom **status code** or extra **headers**.

```luau
function User.Get()
   -- Sending a 404 Not Found with a JSON body
    return response.json(
        { errorMsg = "User not found" }, 
        { status = 404 }
    ) 
end
```

You can also set custom headers, which is useful for things like authentication or custom metadata:

```luau
return response.json(
    { message = "Success" },
    { 
        status = 200,
        headers = {
            ["X-Custom-Header"] = "Mayari-Framework"
        }
    }
)
```

## Summary

- **Naming:** Call the first parameter `req`, `request`, or `banana`, it’s always the Request object.
- **Types:** Use `common.Request` for simplicity, or `common.RequestWith<T>` for additional params and query autocomplete.
- **Headers:** All incoming header keys are converted to **lowercase**.
- **Responses:** Use `common.response` methods with the `(body, config)` pattern to stay organized.