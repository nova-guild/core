# [Nova](https://github.com/BizWiz3/nova)

**A high-performance, filesystem-based web framework built specifically for the [Lune](https://lune-org.github.io/docs/) runtime.**

## Table of Contents

- [Nova](#nova)
  - [Table of Contents](#table-of-contents)
  - [Installation \& Usage](#installation--usage)
    - [Manual Installation](#manual-installation)
      - [Usage](#usage)
    - [Install a boilerplate](#install-a-boilerplate)
  - [Core Features](#core-features)
  - [Route Definition](#route-definition)
  - [Routing Conventions](#routing-conventions)
  - [Middleware Chaining](#middleware-chaining)

## Installation & Usage

### Manual Installation

Manually install Nova via the Pesde package manager:

```sh
pesde add bizwiz3/nova
pesde install
```

#### Usage

In your root project directory, create your entry file.

*Example:* `index.luau`

*Paste the code below:*

```lua
local Nova = require("@path/to/nova")

local app = Nova.new(8080)

app:listen() -- Server is running
```

### Install a boilerplate

Installing a boilerplate for much easier setup

```sh
pesde x bizwiz/nova_setup
pesde install
```

## Core Features

- **Filesystem Routing:** Routes are automatically mapped to the directory structure of the `app` folder.
- **Pattern Matching:** Native support for dynamic segments using `[params]` syntax.
- **Middleware Pipeline:** Functional middleware chaining for global and route-specific logic.
- **Unified Response Utility:** Standardized handling for JSON and HTML content types.
- **Environment Management:** Automatic `.env` loading and process injection.
- **Integrated Logger:** Colored terminal output for request monitoring and debugging.

## Route Definition

Nova organizes routes by folder. To create a route at `/`, you must create an `app/` directory first in your root project directory.

Create a luau file inside the `app/` directory and name it `route.luau`.

*Should look like this:*

```sh
project-dir/
├── app/
    └── route.luau
```

*Paste the code below:*

```lua
local Nova = require("@path/to/nova")

local App = {}

function App.Get()
    return Nova.response({ msg = "Hello, Nova" })
end

return App
```

The Module name `App` itself does not matter, but it must have `Get`, `Post`, etc. as its public function.

## Routing Conventions

Nova follows a predictable mapping from the filesystem to the URL path:

| Path | Filesystem Map |
| :--- | :--- |
| **/** | `app/route.luau` |
| **/users** | `app/users/route.luau` |
| **/posts/:id** | `app/posts/[id]/route.luau` |

## Middleware Chaining

Utilize the `chain` helper to apply logic sequentially before a request reaches the final handler:

```lua
local Nova = require("@path/to/nova")

local function validate(req, next)
    if not req.headers["x-api-key"] then
        return Nova.response({ error = "Forbidden" }, { status = 403 })
    end
    return next(req)
end

Route.Get = Nova.chain({ validate }, function(req)
    return Nova.response({ data = "Authorized access" })
end)
```
