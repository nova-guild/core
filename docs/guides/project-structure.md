# Project Structure

Nova follows a **Convention over Configuration** approach. This means that if you put your files in the right places, Nova handles the rest automatically.

## Recommended Structure

When you first start building an API, it's tempting to throw everything into one file or dump all your files into a single folder. That works fine for a small project, but as your app grows (more routes, more logic, more things to keep track of) it quickly becomes hard to navigate.

Nova recommends a **Feature-Based Architecture** to solve this. The idea is simple: instead of thinking about *what kind of file it is*, you think about *what it belongs to*. Every feature of your app gets its own folder, and everything related to that feature lives inside it.

For example, if your app has a `users` feature, everything about users (the route handler, the business logic, the type definitions) lives in the `users/` folder. Same for `products`, `orders`, or whatever your app needs.

```bash
my-app/
├── pesde.toml                    <-- Package Manager config
└── src/                          <-- All your Luau code lives here
    ├── main.luau                 <-- Entry Point (Starts the server)
    └── app/                      <-- The "Body" (Your Routes)
        ├── route.luau            <-- Handles "/"
        ├── users/
        │   ├── route.luau        <-- Handles "/users"
        │   ├── users.service.luau
        │   └── users.types.luau
        └── products/
            ├── route.luau        <-- Handles "/products"
            ├── products.service.luau
            └── products.types.luau
```

This structure also fits Nova naturally, since Nova already requires you to create a folder per path, you're already halfway there. Feature-based architecture just gives that folder a real purpose beyond routing.

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

The `app` directory is the heart of your API. Every folder you create inside it represents a URL path, and with feature-based architecture, each of those folders also represents a distinct part of your app's responsibility.

- `src/app/route.luau` handles the root path (`/`).
- `src/app/users/route.luau` handles the path (`/users`).
- `src/app/products/route.luau` handles the path (`/products`).

### Why Feature-Based?

When each feature is isolated in its own folder, it's easy to find what you're looking for, easy to change one thing without breaking another, and easy to hand off a piece of your project to someone else. If your app ever grows into something bigger (say, multiple services running independently) each feature folder is already structured to be pulled out on its own.

### Why use `src/app`?

Nova prioritizes the `src/app` directory. If you have an app folder in your root and another one inside `src`, Nova will use the one in `src` and ignore the root version. This encourages keeping the root directory strictly for configuration files like `pesde.toml` or environment settings.

## The `route.luau` Rule

In Nova, **folders define your URL paths, but files define the logic**.

A folder is only registered as a route if it contains a file named exactly `route.luau`. This is what makes feature-based structure safe: you can place service modules, type files, and helpers right next to your route without any of them becoming public URLs.

- `src/app/users/route.luau` -> Valid (Publicly accessible)
- `src/app/users/users.service.luau` -> Private (Nova ignores this)
- `src/app/users/users.types.luau` -> Private (Nova ignores this)

## Summary

| Location | Role | Description |
| :--- | :--- | :--- |
| Root (`/`) | Configuration | For `pesde.toml`, `.gitignore`, and tool configs. |
| `src/main.luau` | Entry Point | The file that initializes and starts your server. |
| `src/app/` | Routing Root | Where Nova looks for your API structure. |
| `<feature>/` | Feature Module | A self-contained folder per part of your app. |
| `route.luau` | Route Handler | The required filename to turn a folder into a URL. |