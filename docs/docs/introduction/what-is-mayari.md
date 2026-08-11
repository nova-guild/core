# What is Mayari?

Luau is growing. While most of us started using it within the Roblox engine, runtimes like `Lune`, `Zune`, and `Lute` are making it possible to use the language we love for things like CLI tools and web servers.

However, building a web server from scratch can be a bit tedious. You usually have to manually handle request parsing, manage complex routing logic, and figure out how to structure your project so it doesn't become one giant, unreadable file.

**Mayari** is a web framework designed to give you a solid foundation for building APIs in Luau. It brings **Filesystem Routing**, a concept popular in frameworks like` Next.js`, to the Luau ecosystem.

## How it works

The core idea behind Mayari is that **your file structure defines your API**. Instead of writing code to map every URL to a function, you just organize your files into folders.

- A file at `app/route.luau` handles requests to `/`.
- A file at `app/users/route.luau` handles requests to `/users`.

This keeps your project organized by default and lets you focus on writing the actual logic of your app.

## Key Features

- **Filesystem Routing:** No manual route registration. Your folders are your paths.
- **Runtime Agnostic:** Whether you prefer Lune, Zune, or Lute, Mayari is built to work across the different Luau runtimes seamlessly.
- **Middleware Support:** Easily chain logic together (like authentication or logging) before your main code runs.
- **Type Safety:** Built with Luau’s typing in mind, so you get better autocompletion and fewer runtime errors.

## A Simple Example

In Mayari, a basic "Hello World" route looks like this:

```luau
local Mayari = require("@mayari")
local common = require("@mayari.common")
local response = common.response

local Home = {}

-- This function runs when someone sends a GET request to this path
function Home.Get()
    return response.json({ message = "Hello, world!" })
end

return Home
```

## Why use Mayari?

If you're looking to build a web backend for your Roblox game, a custom dashboard, or just want to experiment with Luau outside of the engine, Mayari is here to make that process easier. It’s not about making things complicated; it’s about giving you a standard way to build things quickly.
