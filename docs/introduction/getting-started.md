# Getting Started

The fastest way to get a Nova project running is by using our scaffolding tool, but you can also set things up manually if you prefer.

## Prerequisites

Before we start, make sure you have the following installed:

- **A Luau Runtime:** [`Lune`](https://lune-org.github.io/docs/), [`Zune`](https://zune.sh/), or [`Lute`](https://lute.luau.org/).
- **A Package Manager:** We recommend [`pesde`](https://docs.pesde.dev/).

## Option 1: Using the CLI (Recommended)

We created a CLI tool that handles all the boilerplate for you. It sets up your folders, configures your package manager, and creates sample routes automatically.

Open your terminal and run:

```bash
# Scaffold into the current directory
pesde x nova/create -- .
```

or

```bash
# Scaffold into a new named directory. Replace 'my-app' with whatever you want to name your project
pesde x nova/create -- my-app
```

Once executed, the CLI will guide you through two prompts:

1. **Project name:** must follow pesde's package naming format: `scope/name` (e.g. `myorg/my_project`). Names are automatically normalized to lowercase with hyphens converted to underscores.
2. **Runtime:** choose between `Zune`, `Lune`, or `Lute`.

After scaffolding, run the following to get started:

```bash
# If you scaffolded into a new directory
cd <project-name>

pesde install

lune run start
# or
lute run start
# or
zune run start
```

## Option 2: Manual Installation

If you prefer doing things yourself, follow these steps.

**1. Install Nova**

Add Nova to your project using `pesde`:

```bash
pesde add bizwiz3/nova
pesde install
```

**2. Create the Entry Point**

Create a file named `index.luau` (or any name you like) in your root directory. This file initializes Nova and starts the server.

```luau
local Nova = require("path/to/nova")

local app = Nova.new(8080)

app:listen(function()
    print("Server is running on http://localhost:8080")
end)
```

**3. Create your first route**

Nova uses **Filesystem Routing**. This means the files in your `app` folder determine your URL paths. Create a folder named `app`, and inside it, create a file named `route.luau`.

You can structure your project like this:

```bash
/my-app
└── /src
    ├── index.luau
    └── /app
        └── route.luau
```

Inside `app/route.luau`, add this code:

```luau
local Nova = require("path/to/nova")

local Home = {}

function Home.Get()
    return Nova.response.json({ message = "Hello, world!" })
end

return Home
```

**4. Run it**

Start your server:

```bash
lune run src/index
# or
zune run src/index
# or
lute run src/index
```