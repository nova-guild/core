local process = require("@lute/process")

process.run({ "lute", "run", "tests" }, { stdio = "inherit" })