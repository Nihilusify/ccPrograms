-- Turtle tunneling program
-- Dig a 1x3 tunnel with length parameter, then return to start
-- Place torches at regular intervals
-- Place cobble at end to prevent mobs from getting out
--
-- Usage: tunnel <length> <ignoreCobbleTop> <ignoreCobbleBottom>
-- Length must be between 1 and 100
-- ignoreCobble is optional, if true, cobble will not be placed at top and/or bottom

-- Local variables
local requiredEmptySlots = 10
local torchSpacing = 9

-- Clear screen
term.clear()

-- Get length
local length = tonumber(arg[1])
if length == nil then
    print("Usage: tunnel <length>")
    return
end

if length < 1 or length > 100 then
    print("Length must be between 1 and 100")
    return
end

-- Get ignoreCobbleTop
local ignoreCobbleTop = false
if arg[2] == "true" then
    ignoreCobbleTop = true
end

-- Get ignoreCobbleBottom
local ignoreCobbleBottom = false
if arg[3] == "true" then
    ignoreCobbleBottom = true
end

-- Require libraries
local tTurtle = require("tTurtle")

-- Print length
print("Tunnel length: " .. length)

-- Check if enough fuel
-- TODO: wait for fuel if not enough
print("Fuel level: " .. turtle.getFuelLevel())
local fuelNeeded = 2 * length + 4
print("Fuel needed: " .. fuelNeeded)
tTurtle.refuelFromInventory(fuelNeeded)

-- Check for inventory space
if tTurtle.getInventorySpace() < requiredEmptySlots then
    print("Not enough inventory space!  Waiting for inventory to be emptied...")
    print("At least " .. requiredEmptySlots .. " empty slots required")
    print("Press q to continue...")
    tTurtle.waitForEmptyInventory(requiredEmptySlots)
end

-- Place block above if possible, try to refuel first
tTurtle.plugHole("up")

-- Place block below if possible, try to refuel first
tTurtle.plugHole("down")

-- Dig tunnel
-- Steps for moving forward (bottom row): dig, forward, digup
-- Steps for turning: turn left, turn left, up, digup, up
-- Steps for moving back (top row): dig, forward
print("Digging tunnel...")
for i = 1, length do

    tTurtle.refuelFromLava("forward")
    tTurtle.forwardDig()
    turtle.digUp()

    -- Place block down if needed, try to refuel first
    if not ignoreCobbleBottom then
        tTurtle.plugHole("down")
    end
end

print("Returning to start...")
-- Plug hole at end of tunnel
tTurtle.plugHole("forward")
tTurtle.upDig()
tTurtle.plugHole("forward")
tTurtle.upDig()
-- Place torch
local torchSlot = tTurtle.findItemByType("lightSource")
if torchSlot ~= nil then
    tTurtle.placeDownDig(torchSlot)
end
tTurtle.plugHole("forward")
turtle.turnLeft()
turtle.turnLeft()

-- Place block above if needed, try to refuel first
if not ignoreCobbleTop then
    tTurtle.plugHole("up")
end

for i = 1, length do
    tTurtle.refuelFromLava("forward")
    tTurtle.forwardDig()

    -- Place block above if possible, try to refuel first
    if not ignoreCobbleTop then
        tTurtle.plugHole("up")
    end

    -- If block below is a fluid source, try to refuel from it, else place a block and pick it up
    if tTurtle.checkBlockByType("down", "fluid") then
        if tTurtle.refuelFromLava("down") then
            print("Refueled from fluid")
        else
            -- Place cobble
            local cobbleSlot = tTurtle.findItemByType("primBlock")
            if cobbleSlot ~= nil then
                turtle.select(cobbleSlot)
                turtle.placeDown()
                turtle.digDown()
            end
        end
    end

    -- Place torches
    -- Find torch slot (maybe torches in current slot were used up)
    torchSlot = tTurtle.findItemByType("lightSource")
    if torchSlot ~= nil and i % torchSpacing == 0 then
        tTurtle.placeDownDig(torchSlot)
    end
end

turtle.turnLeft()
turtle.turnLeft()
tTurtle.downDig()
-- Place cobble to make sure mobs can't get out
local cobbleSlot = tTurtle.findItemByType("primBlock")
if cobbleSlot ~= nil then
    tTurtle.placeDig(cobbleSlot)
end
tTurtle.downDig()
-- Place torch on ground
torchSlot = tTurtle.findItemByType("lightSource")
if torchSlot ~= nil then
    tTurtle.placeDig(torchSlot)
end

print("Done!")
