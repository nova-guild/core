type MyObject = setmetatable<{ name: string }, { __index: { ping: () -> () } }>

type Inventory = { Sword: number, Shield: boolean }
type Items = keyof<Inventory> -- Evaluates to "Sword" | "Shield"
type Values = index<Inventory, "Sword"> -- Evaluates to number

type function main() 

end

-- This is a hypothetical custom type function
type function MakeOptional(T: type)
    
    local props = T:properties()
    local result = types:newtable({})
    for name, prop in props do
        
        result:setproperty(name, types.unionof(prop.type, types.unknown))
    end
    return result
end

type StrictUser = { name: string, age: number }
type RelaxedUser = MakeOptional<StrictUser> -- { name: string?, age: number? }


-- A function that can take a string OR a number and return the same
type SmartToString = 
    ((val: string) -> string) & 
    ((val: number) -> string)

local fn: SmartToString = function(val: string | number)
    
    return tostring(val)
end

fn()

type VectorImpl = {
    x: number,
    y: number,
}

type VectorMetatable = {
    __add: (a: Vector, b: Vector) -> Vector,
    __index: VectorMetatable -- For methods
}

-- The setmetatable type function links them:
export type Vector = setmetatable<VectorImpl, VectorMetatable>

local v1: Vector = setmetatable({x = 10, y = 5}, {} :: VectorMetatable) :: any
local v2: Vector = setmetatable({x = 5, y = 2}, {} :: VectorMetatable) :: any

-- Because of the 'setmetatable' type, this is now legal and typed!
local v3 = v1 + v2 
print(v3.x) -- 15