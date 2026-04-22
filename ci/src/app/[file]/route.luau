local Nova = require("@nova/index")
local fs = require("@nova/libs/fs")
local process = require("@nova/libs/process")

local SimpleWeb = {}

function SimpleWeb.Get(req: Nova.RequestWith<{ file: string }>) 
    local filename = req.params.file
    local filePath = `{process.cwd}/src/web/{filename}`

    if not fs.isFile(filePath) then
        return Nova.response.json({ error = "File Not Found" }, { status = 400 })
    end

    local contentType = "text/html"
    if filename:match("%.css$") then
        contentType = "text/css"
    elseif filename:match("%.js$") then
        contentType = "text/javascript"
    end

    if contentType == "text/html" then 
        return Nova.response.html(fs.readFile(filePath))
    elseif contentType == "text/css" then 
        return Nova.response.css(fs.readFile(filePath))
    else 
        return Nova.response.js(fs.readFile(filePath))
    end
end

return SimpleWeb