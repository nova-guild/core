local process = require("@lune/process")

process.exec("lune", { "run", "tests" }, { stdio = "inherit" })