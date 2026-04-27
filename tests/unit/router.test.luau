local runner = require("../../tests/runner")
local describe, test, expect = runner.describe, runner.test, runner.expect

local createRouter = require("../../src/core/routing").createTestRouter

local function Test()
    describe("static routes", function()
        test("matches an exact path", function()
            local router = createRouter()
            local module = { Get = function() end }
            router.registerRoute("/hello", module)

            local params = {}
            local matched = router.matchRoute("/hello", params)
            expect(matched).toBe(module)
        end)

        test("returns nil for unregistered path", function()
            local router = createRouter()
            local params = {}
            local matched = router.matchRoute("/nope", params)
            expect(matched).toBeNil()
        end)

        test("strips trailing slash before matching", function()
            local router = createRouter()
            local module = { Get = function() end }
            router.registerRoute("/hello", module)

            local params = {}
            local matched = router.matchRoute("/hello/", params)
            expect(matched).toBe(module)
        end)
    end)

    describe("dynamic routes", function()
        test("matches a single dynamic segment and extracts param", function()
            local router = createRouter()
            local module = { Get = function() end }
            router.registerRoute("/user/[id]", module)

            local params = {}
            local matched = router.matchRoute("/user/42", params)
            expect(matched).toBe(module)
            expect(params.id).toBe("42")
        end)

        test("matches nested dynamic segments", function()
            local router = createRouter()
            local module = { Get = function() end }
            router.registerRoute("/user/[id]/post/[postId]", module)

            local params = {}
            local matched = router.matchRoute("/user/5/post/99", params)
            expect(matched).toBe(module)
            expect(params.id).toBe("5")
            expect(params.postId).toBe("99")
        end)

        test("does not match when segment count differs", function()
            local router = createRouter()
            local module = { Get = function() end }
            router.registerRoute("/user/[id]", module)

            local params = {}
            local matched = router.matchRoute("/user/42/extra", params)
            expect(matched).toBeNil()
        end)

        test("static segment takes priority over dynamic", function()
            local router = createRouter()
            local staticModule = { Get = function() end }
            local dynamicModule = { Get = function() end }
            router.registerRoute("/user/me", staticModule)
            router.registerRoute("/user/[id]", dynamicModule)

            local params = {}
            local matched = router.matchRoute("/user/me", params)
            expect(matched).toBe(staticModule)
        end)
    end)

    describe("wildcard routes", function()
        test("matches remaining segments as a table", function()
            local router = createRouter()
            local module = { Get = function() end }
            router.registerRoute("/files/[...path]", module)

            local params = {}
            local matched = router.matchRoute("/files/a/b/c", params)
            expect(matched).toBe(module)
            expect(params.path).toEqual({ "a", "b", "c" })
        end)

        test("matches with zero remaining segments", function()
            local router = createRouter()
            local module = { Get = function() end }
            router.registerRoute("/files/[...path]", module)

            local params = {}
            local matched = router.matchRoute("/files", params)
            expect(matched).toBe(module)
            expect(params.path).toEqual({})
        end)
    end)

    runner.summary()
end

return Test