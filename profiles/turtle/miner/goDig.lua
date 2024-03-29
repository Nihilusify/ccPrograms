-- Modification of go program that includes digging if not able to move

local args = { ... }
if #args < 1 then
    print("Usage: goDig <direction> <[distance]>")
    return
end

-- Require libraries
local tTurtle = require("tTurtle")

local handlers = {
    ["fd"] = tTurtle.forwardDig,
    ["forward"] = tTurtle.forwardDig,
    ["forwards"] = tTurtle.forwardDig,
    ["up"] = tTurtle.upDig,
    ["dn"] = tTurtle.downDig,
    ["down"] = tTurtle.downDig,
    ["lt"] = turtle.turnLeft,
    ["left"] = turtle.turnLeft,
    ["rt"] = turtle.turnRight,
    ["right"] = turtle.turnRight,
}

local nArg = 1
while nArg <= #args do
    local direction = args[nArg]
    local distance = 1
    if nArg < #args then
        local num = tonumber(args[nArg + 1])
        if num then
            distance = num
            nArg = nArg + 1
        end
    end
    nArg = nArg + 1

    local fnHandler = handlers[string.lower(direction)]
    if fnHandler then
        while distance > 0 do
            fnHandler()
            distance = distance - 1
        end
    else
        print("No such direction: " .. direction)
        print("Try: forward, up, down")
        return
    end

end
