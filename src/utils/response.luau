--!optimize 2

local Types = require("../types")

--[[
    Helper function for sending responses
]]
local function Response(body: Types.ResponseBody, options: Types.ResponseOptions?) 
  	return {
        body = body, 
        config = { 
            status = options and options.status or 200, 
            isHtml = options and options.isHtml or false,
            headers = options and options.headers or {}
        }
    }
end

return Response
