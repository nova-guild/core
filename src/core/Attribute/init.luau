local common = require("@mayari.common")

type Attributes = {
    [string]: ({ any }) -> (common.Request, common.Next) -> common.ResponsePayload?,
}

--[[
    List of current implemented attributes
]]
return {
    Guard = require("@self/Guard"),
    Interceptor = require("@self/Interceptor"),
    Validator = require("@self/Validator"),
} :: Attributes
