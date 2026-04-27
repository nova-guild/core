local runner = require("@test-runner")
local fs = require("@src/libs/fs")

local FIXTURES = "./tests/fixtures/fs"

local describe, test, expect = runner.describe, runner.test, runner.expect

local function Test()
    describe("isFile", function()
        test("returns true for an existing file", function()
            local result = fs.isFile(FIXTURES .. "/hello.txt")
            expect(result).toBe(true)
        end)

        test("returns false for a directory", function()
            local result = fs.isFile(FIXTURES .. "/subdir")
            expect(result).toBe(false)
        end)

        test("returns false for a nonexistent path, never throws", function()
            local ok, result = pcall(fs.isFile, FIXTURES .. "/does-not-exist.txt")
            expect(ok).toBe(true)
            expect(result).toBe(false)
        end)
    end)

    describe("isDir", function()
        test("returns true for an existing directory", function()
            local result = fs.isDir(FIXTURES .. "/subdir")
            expect(result).toBe(true)
        end)

        test("returns false for a file", function()
            local result = fs.isDir(FIXTURES .. "/hello.txt")
            expect(result).toBe(false)
        end)

        test("returns false for a nonexistent path, never throws", function()
            local ok, result = pcall(fs.isDir, FIXTURES .. "/does-not-exist")
            expect(ok).toBe(true)
            expect(result).toBe(false)
        end)
    end)

    describe("readFile", function()
        test("returns the file contents as a string", function()
            local result = fs.readFile(FIXTURES .. "/hello.txt")
            expect(type(result)).toBe("string")
        end)
    end)

    describe("readDir", function()
        test("returns a table of entry names", function()
            local result = fs.readDir(FIXTURES)
            expect(type(result)).toBe("table")
        end)

        test("includes known entries", function()
            local result = fs.readDir(FIXTURES)
            local found = false
            for _, name in result do
                if name == "hello.txt" then
                    found = true
                    break
                end
            end
            expect(found).toBe(true)
        end)
    end)

    runner.summary()
end

return Test