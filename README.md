<div align="center">
    <div>
        <img src="NOVA.svg" alt="Nova logo">
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
        A high-performance, filesystem-based web framework built specifically for the <a href="https://lune-org.github.io/docs/" alt="Lune Runtime">Lune</a> runtime.
    </h3>
</div> 

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Installation \& Usage](#installation--usage)
  - [Manual Installation](#manual-installation)
    - [Usage](#usage)
  - [Install a boilerplate](#install-a-boilerplate)
- [Core Features](#core-features)
- [Route Definition](#route-definition)
- [Routing Conventions](#routing-conventions)
- [Middleware Chaining](#middleware-chaining)
- [Performance Benchmarks](#performance-benchmarks)
  - [Latest Performance (Auto-updated)](#latest-performance-auto-updated)
    - [📊 HTTP / k6 Metrics](#-http--k6-metrics)
    - [🖥️ Container Resource Usage (during benchmark)](#️-container-resource-usage-during-benchmark)

## Installation & Usage

### Manual Installation

Manually install Nova via the Pesde package manager:

```sh
pesde add bizwiz3/nova
pesde install
```

#### Usage

In your root project or `src/` directory, create your entry file.

*Example:* `index.luau`

*Paste the code below:*

```lua
local Nova = require("@path/to/nova")

local app = Nova.new(8080)

app:listen() -- To run the server
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

Nova organizes routes by folder. To create a route at `/`, you must create an `app/` directory first in your root project or `src/` directory.

Create a luau file inside the `app/` directory and name it `route.luau`.

*Should look like this:*

```sh
project-dir/
├── src/
    ├── app/
    |   └── route.luau
    └── index.luau    
```

*Or like this*

```sh
project-dir/
├── app/
|    └── route.luau
└── index.luau
```

*Paste the code below inside the `route.luau`:*

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
    next()
end

Route.Get = Nova.chain({ validate }, function(req)
    return Nova.response({ data = "Authorized access" })
end)
```

*More info about middlewares soon.*

## Performance Benchmarks

<!-- BENCHMARK_START -->
### Latest Performance (Auto-updated)

#### 📊 HTTP / k6 Metrics

| Total Requests | Requests/sec | p95 Latency | p90 Latency | Median Latency | Avg Latency | Success Rate | Failed Requests | Throughput |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **456875** | **5713.58 req/s** | **23.78ms** | **19.14ms** | **10.08ms** | **60.91ms** | **99.00%** | **419** | **0.70 MB/s** |

#### 🖥️ Container Resource Usage (during benchmark)

| Peak CPU | Avg CPU | Peak Memory | Avg Memory % |
| :--- | :--- | :--- | :--- |
| 141.34% | 44.60% | 87MiB | 0.24% |

_Last Benchmarked: Wed Mar 18 11:26:49 UTC 2026_
<!-- BENCHMARK_END -->
