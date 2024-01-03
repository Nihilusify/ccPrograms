-- Turtle program to sip lava from a lava pool
-- It will try to find lava in front, top and bottom, then refuel from it and move forward
-- When fuel max is reached or no more lava is found, it will return to start
--
-- Usage: lavaSip
--

term.clear()

-- Require libraries
local tTurtle = require("tTurtle")

-- Local variables
local maxFuel = turtle.getFuelLimit() - 1000
local relativeY = 0
local relativeX = 0
local startFuel = turtle.getFuelLevel()

-- Check if already at max fuel (or close enough: within 1000)
if turtle.getFuelLevel() > maxFuel then
    print("Fuel level is already at max!")
    return
end

-- Check if bucket of lava in inventory and refuel from it
local bucketSlot = tTurtle.findItem("minecraft:lava_bucket")
if bucketSlot ~= nil then
    print("Refueling from lava bucket...")
    turtle.refuel()
end

-- Check if empty bucket in inventory
if tTurtle.findItem("minecraft:bucket") == nil then
    print("No empty bucket found in inventory!")
    return
end

while turtle.getFuelLevel() < maxFuel do
    -- If lava above, refuel and move up until no more lava or max fuel
    while turtle.getFuelLevel() < maxFuel do
        if tTurtle.refuelFromLava("up") then
            tTurtle.upDig()
            relativeY = relativeY + 1
        else
            break
        end
    end

    -- Return down
    for i = 1, relativeY do
        tTurtle.downDig()
        relativeY = relativeY - 1
    end

    -- If lava below, refuel and move down until no more lava or max fuel
    while turtle.getFuelLevel() < maxFuel do
        if tTurtle.refuelFromLava("down") then
            tTurtle.downDig()
            relativeY = relativeY - 1
        else
            break
        end
    end

    -- Return up
    for i = 1, math.abs(relativeY) do
        tTurtle.upDig()
        relativeY = relativeY + 1
    end

    -- If lava in front, refuel and move forward one block
    tTurtle.refuelFromLava("front")
    tTurtle.forwardDig()
    relativeX = relativeX + 1
    if not tTurtle.checkBlock("down", "minecraft:lava") or tTurtle.checkBlock("up", "minecraft:lava") or tTurtle.checkBlock("front", "minecraft:lava") then
        break
    end
end

-- Return to start
turtle.turnLeft()
turtle.turnLeft()
for i = 1, relativeX do
    tTurtle.forwardDig()
end
turtle.turnLeft()
turtle.turnLeft()

-- Print summary
print("Done!")
print("Fuel start: " .. startFuel)
print("Fuel gained: " .. (turtle.getFuelLevel() - startFuel))
print("Fuel level: " .. turtle.getFuelLevel())
