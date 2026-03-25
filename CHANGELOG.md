# Changelog

## `v0.3.4` - March 25, 2026

### Added
- **Catch-All Routing (`[...slug]`)**: Introduced Next.js-inspired terminal wildcard routes. Wildcards instantly absorb all remaining URL segments in $O(1)$ time, providing extremely fast dynamic deep-routing.
- **URL-Encoded Body Parsing**: The request dispatcher now supports `application/x-www-form-urlencoded` payloads out of the box, automatically parsing them into the `request.body` table.

### Changed
- **Zero-Allocation Route Parsing**: Completely rewrote the internal path parser. Replaced expensive regex/pattern matching (`:match`, `:gsub`) with raw C-level byte checking (`string.byte`) for dynamic route registration and trailing slash removal, drastically reducing memory allocations per request.
- **Dynamic Parameter Memory Optimization**: Replaced standard array shifting (`table.insert(list, 1, val)`) with pre-allocated Luau arrays (`table.create`) and linear indexed assignments, massively speeding up dynamic route segment extraction.
- **Dispatcher Refactoring (DRY)**: Consolidated the internal route execution logic. Static and dynamic routes now share a unified, centralized block for `HEAD` method fallbacks, handler validation, and `405 Method Not Allowed` responses.

## `v0.3.2` - March 15, 2026

###  Fixed

Fixed typos on `routing.luau`

## `v0.3.1` - March 14, 2026

### Fixed

Resolved a critical ***EOF while parsing*** crash that occurred during `GET` requests or requests with empty bodies.

## `v0.3.0` - March 14, 2026

This version removes the automatic detection of Content-Type. You must now use the specific response functions (e.g., `.json()`, `.html()`) to ensure your headers are set correctly. This change give developers explicit control over the response stream.

### Added

- **Explicit Response Utilities:** A new suite of methods under Nova.response to handle common web formats with the correct MIME types:
  - `.send(body, config)` - Generic response handler.
  - `.json(table, config)` - Automatically encodes a table to JSON and sets `application/json`.
  - `.html(string, config)` - Sets `text/html` for server-side rendered content.
  - `.css(string, config)` - Sets `text/css` for stylesheet delivery.
  - `.js(string, config)` - Sets `text/javascript` for client-side scripts.

### Changed

- **Response Handling Logic:** Refactored the core engine to move away from automatic type detection. The system no longer attempts to guess the Content-Type based on the Luau type provided to the router, reducing overhead and preventing ambiguity.

### Fixed

- Resolved a critical bug where the server failed to correctly receive or buffer the request body during POST and PUT operations, ensuring payload integrity for data-driven routes.

### Removed

- `isHtml` property from the response configuration table has been removed. This is now handled exclusively by the .html() utility function.

---

### Implementation Example

```lua
function Home.Get(request)
    -- The new way to send a JSON response
    return Nova.response.json({ msg = "Hello World" })
end
```

## `v0.2.1` - March 9, 2026

### Fixed

- Fixed Nova types not appearing on the latest version

## `v0.2.0` - March 9, 2026

### Added

- Automated discovery of `favicon.ico` in the app directory with dev-mode cache-busting.
- Added automatic `HEAD` method fallback to `GET` handlers.

### Changed

- Replaced O(N) linear route matching with a high-performance Radix Tree (Trie) for O(L) dispatching.
- Implemented O(1) static route fast-path alongside dynamic route handling.
- Integrated `--!native` and `--!optimize 2` to all core files.

### Fixed

- Improved middleware chaining robustness and fixed header merging logic.
- Corrected internal typos in the Nova constructor.