-- Turtle program to dig 3 1x3 tunnels on top of each other, then return to start

-- Usage: tunnel3 <length>
-- Length must be between 1 and 100

-- Local variables
local requiredEmptySlotsPerTunnel = 10

-- Clear screen
term.clear()

-- Get length
local length = tonumber(arg[1])
if length == nil then
    print("Usage: tunnel3 <length>")
    return
end

if length < 1 or length > 100 then
    print("Length must be between 1 and 100")
    return
end

-- Require libraries
local tTurtle = require("tTurtle")

-- Print length
print("Tunnel length: " .. length)

-- Check if enough fuel
print("Fuel level: " .. turtle.getFuelLevel())
-- Fuel needed for 3 tunnels
local fuelNeeded = 3 + 4 + (2 * length + 4) + 3 + (2 * length + 4) + 3 + (2 * length + 4) + 3
print("Fuel needed: " .. fuelNeeded)
tTurtle.refuelFromInventory(fuelNeeded)

-- Check for storage block in inventory and place it,
if tTurtle.findItemByType("storage") then
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.select(tTurtle.findItemByType("storage"))
    turtle.place()
    turtle.turnLeft()
    turtle.turnLeft()
end

-- Dump inventory, but keep:
-- 1 stack of light sources
-- 1 stack of primitive building blocks
-- 1 bucket
function dumpInventory()
    local keepTable = {
        ["lightSource"] = 1,
        ["primBlock"] = 1,
        ["bucket"] = 1
    }
    turtle.turnLeft()
    turtle.turnLeft()
    tTurtle.dumpInventoryExceptByType(keepTable)
    turtle.turnLeft()
    turtle.turnLeft()
end

dumpInventory()

-- Tunnel 1
turtle.turnLeft()
turtle.turnLeft()
tTurtle.plugHole("forward")
tTurtle.upDig()
tTurtle.plugHole("forward")
tTurtle.upDig()
tTurtle.plugHole("forward")
tTurtle.upDig()
tTurtle.plugHole("forward")

-- Go up 2 more to plug more holes and come back
tTurtle.upDig()
tTurtle.plugHole("forward")
tTurtle.upDig()
tTurtle.plugHole("forward")
tTurtle.plugHole("up")
tTurtle.downDig()
tTurtle.downDig()

turtle.turnLeft()
turtle.turnLeft()

-- tunnel args: length, ignoreCobbleTop, ignoreCobbleBottom
-- This is top tunnel, so plug holes above but not below
shell.run("tunnel", length, "false", "true")

tTurtle.downDig()
tTurtle.downDig()
tTurtle.downDig()

dumpInventory()

-- Tunnel 2

-- This is the middle tunnel, so don't plug holes above or below
shell.run("tunnel", length, "true", "true")

dumpInventory()

-- Tunnel 3
turtle.turnLeft()
turtle.turnLeft()
tTurtle.downDig()
tTurtle.plugHole("forward")
tTurtle.downDig()
tTurtle.plugHole("forward")
tTurtle.downDig()
tTurtle.plugHole("forward")
turtle.turnLeft()
turtle.turnLeft()

-- This is the bottom tunnel, so plug holes below but not above
shell.run("tunnel", length, "true", "false")

tTurtle.upDig()
tTurtle.upDig()
tTurtle.upDig()

dumpInventory()

-- Done
print("Done")
print("Fuel remaining: " .. turtle.getFuelLevel())
