-- Turtle program for refeuling from create depot
--   that will refuel a lava bucket
-- 
-- Usage: tRef <[fuelLevel]>
--   fuelLevel: fuel level to refuel to
--     default: max fuel level

-- Clear screen
term.clear()

-- Get fuel level
local reqFuelLevel = tonumber(arg[1])
if reqFuelLevel == nil then
    reqFuelLevel = turtle.getFuelLimit()
end

-- Require libraries
local tTurtle = require("tTurtle")

-- Print fuel level
print("Fuel level: " .. turtle.getFuelLevel())
print("Fuel needed: " .. reqFuelLevel)

-- Check for depot
local depot = peripheral.wrap("front")
if depot == nil then
    print("No depot found!")
    return
end

-- Check for bucket or bucket of lava
local bucketSlot = tTurtle.findItem("minecraft:bucket") or tTurtle.findItem("minecraft:lava_bucket")
if bucketSlot == nil then
    print("No bucket found in inventory!  Checking for bucket in depot...")

    -- Check for bucket in depot
    local depotItem = depot.getItemDetail(1)
    if depotItem == nil then
        print("No bucket found in depot!")
        return
    end

    if depotItem.name ~= "minecraft:lava_bucket" then
        print("No bucket found in depot!")
        return
    end

    -- Get bucket from depot
    print("Getting bucket from depot...")
    turtle.suck(1)
    bucketSlot = 1
end

-- Refuel
print("Refueling...")
turtle.refuel()
while turtle.getFuelLevel() < reqFuelLevel do
    turtle.drop()
    -- Wait for lava bucket in depot
    while depot.getItemDetail(1) and depot.getItemDetail(1).name ~= "minecraft:lava_bucket" do
        os.sleep(1)
    end
    turtle.suck(1)
    turtle.refuel()
end

-- Print fuel level
print("Fuel level: " .. turtle.getFuelLevel())
