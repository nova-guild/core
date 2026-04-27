local process = zune.process

process.run("zune", { "run", "tests" }, { stdout = "inherit", stderr = "inherit" })
