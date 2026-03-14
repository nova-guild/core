local Aura = require("@pesde/aura")
local Tester = require("../utils/tester")

Tester.describe("POST Method", function()
    for i = 1, 5 do
        local res = Aura.put({ 
            url = `http://localhost:8080/users/{i}`,
            body = { name = `User {i}`, job = " Nova Developer" }
        })
        
        if not res.ok then 
            error(`Failed at {i} with status {res.status}`) 
        end
        print(`Test {i} passed!`)
    end
end)