-- Turtle tunneling program
-- Dig a 1x3 tunnel with length parameter, then return to start
-- Place torches at regular intervals
-- Place cobble at key positions to prevent mobs from getting out or lava from spilling
--
-- Usage: tunnel <length> <ignoreCobbleTop> <ignoreCobbleBottom> <fillLeftWall> <fillRightWall>
-- Length recommended to be less than 150
-- ignoreCobble is optional, if true, cobble will not be placed at top and/or bottom
-- fillLeftWall and fillRightWall are optional, if true, the left and/or right wall will be filled.  
--      This takes extra time and fuel, so use with caution.  Extra fuel not calculated.
--
-- Local variables
local requiredEmptySlots = 10
local requiredEmptySlotsInTunnel = 3
local inTunnelCheckLength = 64
local torchSpacing = 9

-- Clear screen
term.clear()

-- Get length
local length = tonumber(arg[1])
if length == nil then
    print("Usage: tunnel <length> <ignoreCobbleTop> <ignoreCobbleBottom> <fillLeftWall> <fillRightWall>")
    return
end

if length < 1 then
    print("Length must be greater than 0")
    return
end

if length > 150 then
    print("Warning: Length is greater than 150, this may cause issues with fuel and inventory space")
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

-- Get fillLeftWall
local fillLeftWall = false
if arg[4] == "true" then
    fillLeftWall = true
end
-- Get fillRightWall
local fillRightWall = false
if arg[5] == "true" then
    fillRightWall = true
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

    -- If block above is a fluid source, try to refuel from it, else place a block and pick it up
    if tTurtle.checkBlockByType("up", "fluid") then
        if tTurtle.refuelFromLava("up") then
            print("Refueled from fluid")
        else
            -- Place cobble
            local cobbleSlot = tTurtle.findItemByType("primBlock")
            if cobbleSlot ~= nil then
                turtle.select(cobbleSlot)
                turtle.placeUp()
                turtle.digUp()
            end
        end
    end

    -- Place block down if needed, try to refuel first
    if not ignoreCobbleBottom then
        tTurtle.plugHole("down")
    end

    -- Fill hole left and/or right if needed
    -- 2 blocks on left side and 1 on right for now.  The other 3 will be done when coming back
    if fillLeftWall then
        turtle.turnLeft()
        tTurtle.plugHole("forward")
        tTurtle.upDig()
        tTurtle.plugHole("forward")
        tTurtle.downDig()
        turtle.turnRight()
    end

    if fillRightWall then
        turtle.turnRight()
        tTurtle.plugHole("forward")
        turtle.turnLeft()
    end

    -- If length is more than 150; Every inTunnelCheckLength blocks, 
    -- make sure there is at least the required empty slots.
    -- If not, drop items to make space
    if length > 150 and i % inTunnelCheckLength == 0 then
        local invEmptySpace = tTurtle.getInventorySpace()
        if (invEmptySpace < requiredEmptySlotsInTunnel) then
            print("Not enough inventory space!  Dropping some items...")
            tTurtle.dumpInventoryBlacklist({"primBlock"}, requiredEmptySlotsInTunnel - invEmptySpace)
        end
        -- Check again.  If still not enough space, break loop to go back to startTimer
        invEmptySpace = tTurtle.getInventorySpace()
        if (invEmptySpace < requiredEmptySlotsInTunnel) then
            print("Still not enough inventory space!")
            -- Go back to start.  Change length to make sure we don't go too far
            length = i
            break
        end
    end
end

print("Returning to start...")
-- Plug hole at end of tunnel
tTurtle.plugHole("forward")
tTurtle.upDig()
tTurtle.plugHole("forward")
tTurtle.upDig()
tTurtle.plugHole("forward")
turtle.turnLeft()
turtle.turnLeft()

-- Place block above if needed, try to refuel first
if not ignoreCobbleTop then
    tTurtle.plugHole("up")
end

for i = 1, length do

    -- Fill hole left and/or right if needed
    -- 2 blocks on right side and 1 on left as other 3 were done before
    -- Remember, right is now left and left is now right
    if fillRightWall then
        turtle.turnLeft()
        tTurtle.plugHole("forward")
        tTurtle.downDig()
        tTurtle.plugHole("forward")
        tTurtle.upDig()
        turtle.turnRight()
    end

    if fillLeftWall then
        turtle.turnRight()
        tTurtle.plugHole("forward")
        turtle.turnLeft()
    end

    tTurtle.refuelFromLava("forward")
    tTurtle.forwardDig()

    -- Place block above if possible, try to refuel first
    if not ignoreCobbleTop then
        tTurtle.plugHole("up")
    end

    -- Place torches
    -- Find torch slot (maybe torches in current slot were used up)
    torchSlot = tTurtle.findItemByType("lightSource")
    if torchSlot ~= nil and i % torchSpacing == 0 then
        tTurtle.placeDownDig(torchSlot)
    end

    -- If length is more than 150; Every inTunnelCheckLength blocks, 
    -- make sure there is at least the required empty slots.
    -- If not, drop items to make space
    if length > 150 and i % inTunnelCheckLength == 0 then
        local invEmptySpace = tTurtle.getInventorySpace()
        if (invEmptySpace < requiredEmptySlotsInTunnel) then
            print("Not enough inventory space!  Dropping some items...")
            tTurtle.dumpInventoryBlacklist({"primBlock"}, requiredEmptySlotsInTunnel - invEmptySpace)
        end
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
