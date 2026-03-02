# Getting Started

This guide will walk you through setting up your first Nova server.

## Prerequisites

Before installing Nova, ensure you have the [Lune](https://lune-org.github.io/docs) runtime installed on your system.

## Installation

### Manual Installation

Add Nova to your project using the Pesde package manager:

```sh
pesde add bizwiz3/nova
pesde install
```

### With a Boilerplate

Using the official Nova boilerplate:

```sh
pesde x bizwiz/nova_setup
pesde install
```

## Project Structure

Nova is opinionated about where your code lives. By default, it looks for an app directory at the root of your project.

```txt
my-project/
├── app/
│   └── route.luau     <-- This maps to "/"
├── index.luau         <-- Your entry point
└── .env               <-- Environment variables (optional but recommended)
```

## Creating Your First Server

In your`index.luau` file, initialize the Nova instance and tell it to listen on a port.

```lua
local Nova = require("@path/to/nova")

-- Initialize on port 8080
local app = Nova.new(8080)

app:listen(function()
    print("Nova is running on http://localhost:8080")
end)
```

## Defining Your First Route

Create a folder named `app` and add a `route.luau` file inside it. This file must return a table containing functions named after HTTP methods (e.g., `Get`, `Post`, `Put`, `Delete`).

```lua
-- app/route.luau
local Nova = require("@path/to/nova")

local Home = {}

function Home.Get()
    return Nova.response({
        message = "Welcome to Nova!",
        version = "0.1.0"
    })
end

return Home
```

## Running the Server

Run your entry file using Lune:

```sh
lune run index
```

or

```sh
pesde run index.luau
```

Navigate to [http://localhost:8080](http://localhost:8080) in your browser or use curl. You should see your JSON response and a colored log entry in your terminal.

## Next Steps

Now that your server is running, learn how to create nested and dynamic routes in the Routing guide.
