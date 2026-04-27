local serde = require("@lune/serde")
local Types = require("./types")

local LuneSerde = {} :: Types.SerdeAdapter

local decode = serde.decode
local encode = serde.encode

function LuneSerde.decode(format, encoded)
    return decode(format, encoded)
end

function LuneSerde.encode(format, value, pretty)
    return encode(format, value, pretty)
end

return LuneSerde
