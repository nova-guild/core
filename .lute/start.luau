local process = require("@lute/process")
local alias = require("../src/utils/Alias")

local newCAlias = process.cwd() .. "/tests/web/"

alias.set("c", newCAlias)

process.run({ "lute", "run", "src/main" }, { stdio = "inherit", cwd = "tests/web" })