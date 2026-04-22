# Project Structure

Nova follows a **Convention over Configuration** approach. This means that if you put your files in the right places, Nova handles the rest automatically.

## Recommended Structure

This is the standard layout for a Nova project. It separates your configuration from your code, making the project much easier to navigate as it grows.

```bash
my-app/
├── pesde.toml        <-- Package Manager config
└── src/              <-- All your Luau code lives here
    ├── main.luau     <-- Entry Point (Starts the server)
    └── app/          <-- The "Body" (Your Routes)
        ├── route.luau
        └── users/
            └── route.luau
```

## The Entry Point (`src/main.luau`)

The entry point is the file you run to start your server. By placing it inside `src`, you ensure that all your logic is contained in one place.

Its job is to initialize Nova and tell it where to find your routes:

```luau
local Nova = require("path/to/nova")

local app = Nova.new(8080)

app:listen(function()
    print("Server started on http://localhost:8080")
end)
```

Run your nova app

```bash
lune run src/main
# or
lute run src/main
# or
zune run src/main
```

## The `app` Directory

The `app` directory is the heart of your API. Every folder inside `app` represents a URL path.

- `src/app/route.luau` handles the root path (`/`).
- `src/app/users/route.luau` handles the path (`/users`).

### Why use `src/app`?

Nova prioritizes the `src/app` directory. If you have an app folder in your root and another one inside `src`, Nova will use the one in `src` and ignore the root version. This encourages keeping the root directory strictly for configuration files like `pesde.toml` or environment settings.

## The `route.luau` Rule

In Nova, **folders define your URL paths, but files define the logic**.

A folder is only registered as a route if it contains a file named exactly `route.luau`. This is great for organization because it allows you to keep other files (like helper scripts, local types, or tests) right next to your routes without them becoming public URLs.

- `src/app/users/route.luau` -> Valid (Publicly accessible)
- `src/app/users/utils.luau` -> Private (Nova ignores this)

## Summary

| Location | Role | Description |
| :--- | :--- | :--- |
| Root (`/`) | Configuration | For `pesde.toml`, `.gitignore`, and tool configs. |
| `src/main.luau` | Entry Point | The file that initializes and starts your server. |
| `src/app/` | Routing Root | Where Nova looks for your API structure. |
| `route.luau` | Route Handler | The required filename to turn a folder into a URL. |