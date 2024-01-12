-- Turtle program to dig 5 1x3 tunnels on top of each other, then return to start

-- Usage: tunnel5v <length>
-- Length must be between 1 and 300

-- Local variables
local requiredEmptySlotsPerTunnel = 10

-- Clear screen
term.clear()

-- Get length
local length = tonumber(arg[1])
if length == nil then
    print("Usage: tunnel5v <length>")
    return
end

if length < 1 or length > 300 then
    print("Length must be between 1 and 300")
    return
end

-- Require libraries
local tTurtle = require("tTurtle")

-- Print length
print("Tunnel length: " .. length)

-- Check if enough fuel
print("Fuel level: " .. turtle.getFuelLevel())
-- Fuel needed for 5 tunnels
local fuelNeeded = 6 + 4 + (2 * length + 4) + 6 + 3 + (2 * length + 4) + 3 + (2 * length + 4) + 3 + (2 * length + 4) + 3 + 6 + (2 * length + 4) + 6
print("Fuel needed: " .. fuelNeeded)
tTurtle.refuelFromInventory(fuelNeeded)

-- Check for storage block in inventory and place it.
-- Wait for storage block before continuing.
print("Waiting for storage block (e.g. chest/barrel)...")
print("Press q to continue anyway...")
local storageSlot = tTurtle.waitForItemByType("storage")
if storageSlot ~= nil then
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.select(storageSlot)
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
for i = 1, 6 do
    tTurtle.upDig()
    tTurtle.plugHole("forward")
end

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

for i = 1, 6 do
    tTurtle.downDig()
end

dumpInventory()

-- Tunnel 2

for i = 1, 3 do
    tTurtle.upDig()
end

-- This is a middle tunnel, so don't plug holes above or below
shell.run("tunnel", length, "true", "true")

for i = 1, 3 do
    tTurtle.downDig()
end

dumpInventory()

-- Tunnel 3

-- This is a middle tunnel, so don't plug holes above or below
shell.run("tunnel", length, "true", "true")

dumpInventory()

-- Tunnel 4

turtle.turnLeft()
turtle.turnLeft()

for i = 1, 3 do
    tTurtle.downDig()
    tTurtle.plugHole("forward")
end

turtle.turnLeft()
turtle.turnLeft()

-- This is a middle tunnel, so don't plug holes above or below
shell.run("tunnel", length, "true", "true")

for i = 1, 3 do
    tTurtle.upDig()
end

dumpInventory()

-- Tunnel 5

turtle.turnLeft()
turtle.turnLeft()

for i = 1, 6 do
    tTurtle.downDig()
    tTurtle.plugHole("forward")
end

turtle.turnLeft()
turtle.turnLeft()

-- This is the bottom tunnel, so plug holes below but not above
shell.run("tunnel", length, "true", "false")

for i = 1, 6 do
    tTurtle.upDig()
end

dumpInventory()

-- Done
tTurtle.plugHole("down")
print("Done")
print("Fuel remaining: " .. turtle.getFuelLevel())
