<div align="center">
    <div>
        <img height="150" src="./docs/nova.png" alt="Nova logo">
    </div>
    <br>
    <a href="https://pesde.dev/packages/bizwiz3/nova">
        <img src="https://img.shields.io/badge/pesde-bizwiz3/nova-F19D1E?style=flat">
    </a>
    <a href="https://github.com/BizWiz3/nova/blob/main/README.md">
        <img src="https://img.shields.io/badge/github-bizwiz3/benchmark-blue?style=flat">
    </a>
    <a href="https://github.com/BizWiz3/nova/actions/workflows/ci.yml">
        <img src="https://github.com/BizWiz3/nova/actions/workflows/ci.yml/badge.svg">
    </a>
    <h3>
        A filesystem-based web framework for Luau runtimes, with out-of-the-box support for <a href="https://lute.luau.org/" alt="Lute Runtime">Lute</a>, <a href="https://lune-org.github.io/docs/" alt="Lune Runtime">Lune</a> and <a href="https://zune.sh/" alt="Zune Runtime">Zune</a>.
    </h3>
</div> 

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Installation \& Usage](#installation--usage)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Manual Setup](#manual-setup)
- [Core Features](#core-features)
- [Routing Conventions](#routing-conventions)
- [Middleware Chaining](#middleware-chaining)

## Installation & Usage

### Installation

Install Nova via the Pesde package manager:

```sh
pesde add bizwiz3/nova
pesde install
```

### Usage

#### Manual Setup

1. Create a `src/` directory in your project root.
2. Create an entry file (e.g., `index.luau`) inside `src/` with the following code:

```lua
local Nova = require("@path/to/nova")

local app = Nova.new(8080)

app:listen() -- To run the server
```

3. Create an `app/` directory inside `src/`. This directory will house your routes.
4. To create a route, add a `route.luau` file inside a directory within `app/`. The directory name becomes the base route.

For example, to create a route at `/`, create `src/app/route.luau`:

```lua
local Nova = require("@path/to/nova")

local App = {}

function App.Get()
    return Nova.response.json({ msg = "Hello, Nova" })
end

return App
```

The module must export properties named after HTTP methods: `Get`, `Post`, `Put`, `Patch`, and `Delete`. You can define them as functions:

```lua
local App = {}

App.Get = function()
    return Nova.response.json({ msg = "Hello, Nova" })
end

return App
```

## Core Features

- **Filesystem Routing:** Routes are automatically mapped to the directory structure of the `app` folder.
- **Pattern Matching:** Native support for dynamic segments using `[params]` syntax.
- **Middleware Pipeline:** Functional middleware chaining for global and route-specific logic.
- **Unified Response Utility:** Standardized handling for JSON and HTML content types.
- **Environment Management:** Automatic `.env` loading and process injection.
- **Integrated Logger:** Colored terminal output for request monitoring and debugging.

## Routing Conventions

Nova follows a predictable mapping from the filesystem to the URL path:

| Path | Filesystem Map |
| :--- | :--- |
| **/** | `src/app/route.luau` |
| **/users** | `src/app/users/route.luau` |
| **/posts/:id** | `src/app/posts/[id]/route.luau` |

## Middleware Chaining

Utilize the `chain` helper to apply logic sequentially before a request reaches the final handler:

```lua
-- route.luau
local Nova = require("@path/to/nova")

local function validate(req, next)
    if not req.headers["x-api-key"] then
        return Nova.response.json({ error = "Forbidden" }, { status = 403 })
    end
    next()
end

Route.Get = Nova.chain({ validate }, function(req)
    return Nova.response.json({ data = "Authorized access" })
end)
```

*More info about middlewares soon.*
