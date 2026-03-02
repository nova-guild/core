# Introduction

**NOVA is a high-performance, filesystem-based web framework built specifically for the [Lune](https://lune-org.github.io/docs/) runtime.**

In a traditional web server, you manually map every URL to a function. Nova changes this by using your folder structure as the source of truth for your API. This approach reduces boilerplate, keeps projects organized, and makes it clear exactly where a specific piece of logic lives.

## Core Principles

### 1. Zero-Config Routing

Nova eliminates the need for a central router configuration. By placing a `route.luau` file inside any folder within your `app` directory, Nova automatically registers that path as a reachable endpoint.

### 2. Functional Pipelines

Middlewares in Nova are pure functions. By using a functional chaining pattern, you can wrap your handlers with logic for authentication, validation, and logging without nesting your code.

### 3. Native Type Safety

Nova is built with Luau's type system at its core. Whether you are accessing `req.params` or defining a `NovaInstance`, the framework provides strict typing to ensure your code is robust before it even runs.

### 4. Performance First

By leveraging Lune's native `net` and `serde` modules, Nova provides a high-level developer experience with minimal overhead, making it suitable for both microservices and full-scale web applications.

---

## Documentation Roadmap

To get the most out of Nova, we recommend exploring the documentation in the following order:

1. **Getting Started**: Installation and your first "Hello World" server.
2. **Routing**: Understanding static paths and dynamic `[id]` patterns.
3. **Middleware**: Master global and route-specific logic chaining.
4. **Requests & Responses**: Deep dive into the data flow and HTML rendering.
