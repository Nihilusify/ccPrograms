-- Turtle program to go down an excavated shaft wall and plug up the walls
-- When it can't go down any further, it will return to the surface
--
-- Usage: lineShaft <length>
--   If length is not specified, go down until not possible (.e.g bedrock)

-- Local variables
local traveled = 0
local minimumFuel = 200
local blocksPlaced = 0

term.clear()

-- Get length
local length = tonumber(arg[1])

-- Require libraries
local tTurtle = require("tTurtle")

-- Print length
if length == nil then
    print("Going down until not possible")
else
    print("Shaft length: " .. length)
end

-- Check if enough fuel
print("Fuel level: " .. turtle.getFuelLevel())
-- Fuel needed is 2x the length of the shaft
local fuelNeeded = minimumFuel or 2 * length

-- Refuel from inventory if needed
tTurtle.refuelFromInventory(fuelNeeded)

-- Check for blocks to plug up shaft
local blockSlot = tTurtle.findItemByType("primBlock")
if blockSlot == nil then
    print("No blocks found!  Waiting for blocks...")
    print("Press q to quit...")
    blockSlot = tTurtle.waitForItemByType("primBlock")

    -- If still no blocks, quit
    if blockSlot == nil then
        print("No blocks found!  Quitting...")
        return
    end
end

local aborted = false
-- Go down shaft
print("Going down shaft...")
while turtle.down() do
    traveled = traveled + 1

    -- Place block to plug up shaft
    blockSlot = tTurtle.findItemByType("primBlock")

    -- If no blocks, return to surface
    if blockSlot == nil then
        print("No more blocks!  Returning to surface...")
        aborted = true
        break
    end

    turtle.select(blockSlot)
    if turtle.place() then
        blocksPlaced = blocksPlaced + 1
    end

    if length ~= nil and traveled >= length then
        print("Reached end of shaft!  Returning to surface...")
        break
    end
end

-- Return to surface
print("Returning to surface...")
while traveled > 0 do
    -- Make sure we dig up just in case something is now blocking the way
    tTurtle.upDig()
    traveled = traveled - 1
end

-- If aborted, print aborted, otherwise print done
if aborted then
    print("Aborted!")
else
    print("Done!")
end
print("Blocks placed: " .. blocksPlaced)
