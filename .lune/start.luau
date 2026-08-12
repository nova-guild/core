local process = require("@lune/process")
local alias = require("../src/utils/Alias")

local newCAlias = process.cwd .. "tests/web/"

alias.set("c", newCAlias)

process.exec("lune", { "run", "src/main" }, { stdio = "inherit", cwd = "tests/web" })