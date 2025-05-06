-- Turtle program to dig 3 1x3 tunnels on top of each other, then return to start
--
-- Usage: tunnel3v <length> <fillLeftWall> <fillRightWall>
-- Length recommended to be less than 150
-- fillLeftWall and fillRightWall are optional, if true, the left and/or right wall will be filled.  
--      This takes extra time and fuel, so use with caution.  Extra fuel not calculated.
--
-- Local variables
local requiredEmptySlotsPerTunnel = 10

-- Clear screen
term.clear()

-- Get length
local length = tonumber(arg[1])
if length == nil then
    print("Usage: tunnel3v <length> <fillLeftWall> <fillRightWall>")
    return
end

if length < 1 then
    print("Length must be greater than 0")
    return
end

if length > 150 then
    print("Warning: Length is greater than 150, this may cause issues with fuel and inventory space")
end

-- Get fillLeftWall
local fillLeftWall = "false"
if arg[2] == "true" then
    fillLeftWall = "true"
end
-- Get fillRightWall
local fillRightWall = "false"
if arg[3] == "true" then
    fillRightWall = "true"
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

-- Check for storage block in inventory and place it.
-- Wait for storage block before continuing.
print("Waiting for storage block (e.g. chest/barrel)...")
print("Press q to continue anyway...")
local storageSlot = tTurtle.findItemByType("storage")
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
    tTurtle.sortInventory()
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
shell.run("tunnel", length, "false", "true", fillLeftWall, fillRightWall)

tTurtle.downDig()
tTurtle.downDig()
tTurtle.downDig()

dumpInventory()

-- Tunnel 2

-- This is the middle tunnel, so don't plug holes above or below
shell.run("tunnel", length, "true", "true", fillLeftWall, fillRightWall)

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
shell.run("tunnel", length, "true", "false", fillLeftWall, fillRightWall)

tTurtle.upDig()
tTurtle.upDig()
tTurtle.upDig()

dumpInventory()

-- Done
tTurtle.plugHole("down")
print("Done")
print("Fuel remaining: " .. turtle.getFuelLevel())
