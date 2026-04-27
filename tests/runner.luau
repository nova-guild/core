local process = require("../src/libs/process")

export type Expected = {
    toBe: (expected: any) -> (),
    toEqual: (expected: any) -> (),
    toBeNil: (expected: any) -> (),
    never: (expected: any) -> (),
}

export type TestRunner = {
    describe: (name: string, fn: () -> ()) -> (),
    test: (name: string, fn: () -> ()) -> (),
    summary: () -> (),
    expect: (any) -> Expected,
    reset: () -> ()
}

local passed = 0
local failed = 0
local errors = {}

local function expect(value: any)
    return {
        toBe = function(expected: any)
            if value ~= expected then
                error(
                    `expected {tostring(expected)}, got {tostring(value)}`,
                    2
                )
            end
        end,
        toEqual = function(expected: any)
            -- deep equality for tables
            local function deepEqual(a, b)
                if type(a) ~= type(b) then return false end
                if type(a) ~= "table" then return a == b end
                for k, v in a do
                    if not deepEqual(v, b[k]) then return false end
                end
                for k in b do
                    if a[k] == nil then return false end
                end
                return true
            end
            if not deepEqual(value, expected) then
                error(
                    `expected {tostring(expected)}, got {tostring(value)}`,
                    2
                )
            end
        end,
        toBeNil = function()
            if value ~= nil then
                error(`expected nil, got {tostring(value)}`, 2)
            end
        end,
        never = {
            toBeNil = function()
                if value == nil then
                    error("expected a value, got nil", 2)
                end
            end
        }
    }
end

local currentSuite = ""

local function describe(name: string, fn: () -> ())
    currentSuite = name
    fn()
    currentSuite = ""
end

local function test(name: string, fn: () -> ())
    local label = if currentSuite ~= "" then `{currentSuite} > {name}` else name
    local ok, err = pcall(fn)
    if ok then
        passed += 1
        print("\27[32m" .. "  ✓ " .. "\27[0m" .. label)
    else
        failed += 1
        table.insert(errors, { label = label, message = tostring(err) })
        print("\27[31m" .. "  ✗ " .. "\27[0m" .. label)
    end
end

local function summary()
    if #errors > 0 then
        print("\n\27[31m" .. "Failures:\n" .. "\27[0m")
        for _, e in errors do
            print(`  {e.label}\n    {e.message}`)
        end
    end
    print(
        "\n\27[32m" .. `{passed} passed` .. "\27[0m" ..
        ", " ..
        "\27[31m" .. `{failed} failed` .. "\27[0m"
    )
    
    if failed > 0 then
        process.exit(1)
    end
end

local function reset()
    passed = 0
    failed = 0
    errors = {}
end

return { 
    describe = describe, 
    test = test, 
    expect = expect, 
    summary = summary, 
    reset = reset 
}