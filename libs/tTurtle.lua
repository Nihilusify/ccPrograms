-- Library of functions for turtles
-- Author: Terence van Jaarsveldt
-- If not a turtle, return
if not turtle then
    print("Not a turtle!")
    return
end

local tTurtle = {}

-- Import items dictionary
local itemDict = require("items")

-- Move forward, dig if blocked
-- Returns nothing
function tTurtle.forwardDig()
    while not turtle.forward() do
        turtle.dig()
    end
end

-- Move up, dig if blocked
-- Returns nothing
function tTurtle.upDig()
    while not turtle.up() do
        turtle.digUp()
    end
end

-- Move down, dig if blocked
-- Returns nothing
function tTurtle.downDig()
    while not turtle.down() do
        turtle.digDown()
    end
end

-- Place in front, dig if blocked
--   If inventory slot has no items, return false
--   If no block to dig, but still fail to place, return false
-- Args: slot (number): Defaults to current slot
-- Returns boolean
function tTurtle.placeDig(slot)
    if slot then
        turtle.select(slot)
    end
    if turtle.getItemCount() == 0 then
        return false
    end
    while not turtle.place() do
        if not turtle.detect() then
            return false
        end
        turtle.dig()
    end
    return true
end

-- Place up, dig if blocked
--   If inventory slot has no items, return false
--   If no block to dig, but still fail to place, return false
-- Args: slot (number): Defaults to current slot
-- Returns boolean
function tTurtle.placeUpDig(slot)
    if slot then
        turtle.select(slot)
    end
    if turtle.getItemCount() == 0 then
        return false
    end
    while not turtle.placeUp() do
        if not turtle.detectUp() then
            return false
        end
        turtle.digUp()
    end
    return true
end

-- Place down, dig if blocked
--   If inventory slot has no items, return false
--   If no block to dig, but still fail to place, return false
-- Args: slot (number): Defaults to current slot
-- Returns boolean
function tTurtle.placeDownDig(slot)
    if slot then
        turtle.select(slot)
    end
    if turtle.getItemCount() == 0 then
        return false
    end
    while not turtle.placeDown() do
        if not turtle.detectDown() then
            return false
        end
        turtle.digDown()
    end
    return true
end

-- Find item in inventory
-- Args: item/partial item (string) Example: "minecraft:torch" or "torch"
-- Returns slot number or nil
function tTurtle.findItem(item)
    for i = 1, 16 do
        local data = turtle.getItemDetail(i)
        if data then
            if data.name == item or data.name:find(item) then
                return i
            end
        end
    end
    return nil
end

-- Find item in inventory by type
-- Args: item type from  (string) Example: "fuel"
-- Returns slot number or nil
function tTurtle.findItemByType(itemType)
    for i = 1, 16 do
        local data = turtle.getItemDetail(i)
        if data then
            for _, v in pairs(itemDict[itemType]) do
                if data.name == v.name then
                    return i
                end
            end
        end
    end
    return nil
end

-- Check if facing block is a specified name
-- Args: side (string) Example: "front"
--       block/partial name (string) Example: "minecraft:torch" or "torch"
-- Returns true if facing block is specified name
function tTurtle.checkBlock(side, name)
    local success, data
    if side == "front" then
        local s, d = turtle.inspect()
        success = s
        data = d
    elseif side == "up" then
        local s, d = turtle.inspectUp()
        success = s
        data = d
    elseif side == "down" then
        local s, d = turtle.inspectDown()
        success = s
        data = d
    else
        return false
    end

    if success then
        if data.name == name or data.name:find(name) then
            return true
        end
    end
    return false
end

-- Check if facing block is a specified type
-- Args: side (string) Example: "front"
--       item type from  (string) Example: "fluid"
-- Returns true if facing block is specified type
function tTurtle.checkBlockByType(side, itemType)
    local success, data
    if side == "front" then
        local s, d = turtle.inspect()
        success = s
        data = d
    elseif side == "up" then
        local s, d = turtle.inspectUp()
        success = s
        data = d
    elseif side == "down" then
        local s, d = turtle.inspectDown()
        success = s
        data = d
    else
        return false
    end

    if success then
        for _, v in pairs(itemDict[itemType]) do
            if data.name == v.name then
                return true
            end
        end
    end
    return false
end

-- Check fuel level, refuel if needed
-- Args: fuelNeeded (number)
-- Returns true if enough fuel
function tTurtle.checkFuel(fuelNeeded)
    if turtle.getFuelLevel() < fuelNeeded then
        local fuelSlot = tTurtle.findItemByType("fuel")
        if fuelSlot then
            turtle.select(fuelSlot)
            print("Refueling with " .. turtle.getItemDetail(fuelSlot).name)
            turtle.refuel(1)
            return tTurtle.checkFuel(fuelNeeded)
        else
            print("Not enough fuel!")
            return false
        end
    else
        return true
    end
end

-- Refuel from inventory, wait for fuel if needed (q to quit)
-- Args: fuelNeeded (number)
-- Returns true if enough fuel, false if quit
function tTurtle.refuelFromInventory(fuelNeeded)
    if turtle.getFuelLevel() < fuelNeeded then
        local fuelSlot = tTurtle.findItemByType("fuel")
        if fuelSlot then
            turtle.select(fuelSlot)
            print("Refueling with " .. turtle.getItemDetail(fuelSlot).name)
            turtle.refuel(1)
            return tTurtle.refuelFromInventory(fuelNeeded)
        else
            print("Not enough fuel!  Waiting for fuel...")
            print("Press q to continue...")
            local slot = tTurtle.waitForItemByType("fuel")
            if slot == nil then
                -- User quit
                return false
            end
            return tTurtle.refuelFromInventory(fuelNeeded)
        end
    else
        return true
    end
end

-- Refuel from external lava source
-- Args: side (string) Example: "front"
-- Returns true if successful
function tTurtle.refuelFromLava(side)
    -- Find empty bucket
    local bucketSlot = tTurtle.findItem("minecraft:bucket")

    -- If no empty bucket, try to find lava bucket and refuel from it first
    if bucketSlot == nil then
        bucketSlot = tTurtle.findItem("minecraft:lava_bucket")
        if bucketSlot ~= nil then
            turtle.select(bucketSlot)
            turtle.refuel()
        end
    end

    if bucketSlot == nil then
        return false
    end

    turtle.select(bucketSlot)

    if side == "front" then
        if tTurtle.checkBlock("front", "minecraft:lava") then
            turtle.place()
            turtle.refuel()
            return true
        end
    elseif side == "up" then
        if tTurtle.checkBlock("up", "minecraft:lava") then
            turtle.placeUp()
            turtle.refuel()
            return true
        end
    elseif side == "down" then
        if tTurtle.checkBlock("down", "minecraft:lava") then
            turtle.placeDown()
            turtle.refuel()
            return true
        end
    end
    return false
end

-- Place block if possible, try to refuel first
-- Args: side (string) Example: "front"
-- Returns nothing
function tTurtle.plugHole(side)
    if side == "up" then
        if not turtle.detectUp() then
            tTurtle.refuelFromLava("up")

            local cobbleSlot = tTurtle.findItemByType("primBlock")
            if cobbleSlot ~= nil then
                turtle.select(cobbleSlot)
                turtle.placeUp()
            end
        end
    elseif side == "down" then
        if not turtle.detectDown() then
            tTurtle.refuelFromLava("down")

            local cobbleSlot = tTurtle.findItemByType("primBlock")
            if cobbleSlot ~= nil then
                turtle.select(cobbleSlot)
                turtle.placeDown()
            end
        end
    elseif side == "forward" then
        if not turtle.detect() then
            tTurtle.refuelFromLava("forward")

            local cobbleSlot = tTurtle.findItemByType("primBlock")
            if cobbleSlot ~= nil then
                turtle.select(cobbleSlot)
                turtle.place()
            end
        end
    end
end

-- Get inventory space
-- Returns number of empty slots
function tTurtle.getInventorySpace()
    local space = 0
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            space = space + 1
        end
    end
    return space
end

-- Count items of type in inventory
-- Args: item type from  (string) Example: "fuel"
-- Returns number of items
function tTurtle.countItemsByType(itemType)
    local count = 0
    for i = 1, 16 do
        local data = turtle.getItemDetail(i)
        if data then
            for _, v in pairs(itemDict[itemType]) do
                if data.name == v.name then
                    count = count + data.count
                end
            end
        end
    end
    return count
end

-- Wait for item count in inventory by type or timeout or keypress (q)
-- Args: item type from  (string) Example: "fuel"
--       count (number) Example: 10, if nil, wait for at least 1 item
--       timeout (number) Example: 10, if nil, wait forever
-- Returns true if item count is at least count
function tTurtle.waitForItemCountByType(itemType, count, timeout)
    -- If item count is already at least count, return true
    local itemCount = tTurtle.countItemsByType(itemType)
    if count then
        if itemCount >= count then
            return true
        end
    else
        if itemCount > 0 then
            return true
        end
    end

    -- else wait for item count to be at least count
    local timer
    if timeout then
        timer = os.startTimer(timeout)
    end
    while true do
        local event, key = os.pullEvent()
        if event == "timer" and key == timer then
            return false
        elseif event == "key" and key == keys.q then
            return false
        elseif event == "turtle_inventory" then
            local itemCount = tTurtle.countItemsByType(itemType)
            if count then
                if itemCount >= count then
                    return true
                end
            else
                if itemCount > 0 then
                    return true
                end
            end
        end
        -- sleep
        os.sleep(0.2)
    end
end

-- Wait for item in inventory or timeout or keypress (q)
-- Args: item/partial item (string) Example: "minecraft:torch" or "torch"
--       timeout (number) Example: 10, if nil, wait forever
-- Returns slot number or nil
function tTurtle.waitForItem(item, timeout)
    -- If item is already in inventory, return slot number
    local slot = tTurtle.findItem(item)
    if slot then
        return slot
    end

    -- else wait for item to be added to inventory
    local timer
    if timeout then
        timer = os.startTimer(timeout)
    end
    while true do
        local event, key = os.pullEvent()
        if event == "timer" and key == timer then
            return nil
        elseif event == "key" and key == keys.q then
            return nil
        elseif event == "turtle_inventory" then
            local slot = tTurtle.findItem(item)
            if slot then
                return slot
            end
        end
        -- sleep
        os.sleep(0.2)
    end
end

-- Wait for item in inventory by type or timeout or keypress (q)
-- Args: item type from  (string) Example: "fuel"
--       timeout (number) Example: 10, if nil, wait forever
-- Returns slot number or nil
function tTurtle.waitForItemByType(itemType, timeout)
    -- If item is already in inventory, return slot number
    local slot = tTurtle.findItemByType(itemType)
    if slot then
        return slot
    end

    -- else wait for item to be added to inventory
    local timer
    if timeout then
        timer = os.startTimer(timeout)
    end
    while true do
        local event, key = os.pullEvent()
        if event == "timer" and key == timer then
            return nil
        elseif event == "key" and key == keys.q then
            return nil
        elseif event == "turtle_inventory" then
            local slot = tTurtle.findItemByType(itemType)
            if slot then
                return slot
            end
        end
        -- sleep
        os.sleep(0.2)
    end
end

-- Wait for inventory to be empty or timeout or keypress (q)
-- Args: emptySlots (number) Example: 2, if nil, wait for all slots to be empty
--       timeout (number) Example: 10, if nil, wait forever
-- Returns true if inventory is empty
function tTurtle.waitForEmptyInventory(emptySlots, timeout)
    -- If inventory is already as empty as specified, return true
    local empty = tTurtle.getInventorySpace()
    if emptySlots then
        if empty >= emptySlots then
            return true
        end
    else
        if empty == 16 then
            return true
        end
    end

    -- else wait for inventory to be empty
    local timer
    if timeout then
        timer = os.startTimer(timeout)
    end
    while true do
        local event, key = os.pullEvent()
        if event == "timer" and key == timer then
            return false
        elseif event == "key" and key == keys.q then
            return false
        elseif event == "turtle_inventory" then
            local empty = tTurtle.getInventorySpace()
            if emptySlots then
                if empty >= emptySlots then
                    return true
                end
            else
                if empty == 16 then
                    return true
                end
            end
        end
        -- sleep
        os.sleep(0.2)
    end
end

-- Dump inventory except for specified items
--  Keep amount of stacks specified in ignore table
-- Args: ignore (table) Example: { "minecraft:torch": 1, "minecraft:cobblestone": 2, "minecraft:coal": 1 }
-- Returns nothing
function tTurtle.dumpInventory(ignore)
    -- Dump inventory
    print("Dumping inventory...")
    for i = 1, 16 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data then
            local keep = false
            if ignore then
                for k, v in pairs(ignore) do
                    if data.name == k then
                        if v > 0 then
                            keep = true
                            ignore[k] = v - 1
                        end
                    end
                end
            end
            if not keep then
                turtle.drop()
            end
        end
    end
end

-- Dump inventory except for specified item types
--  Keep amount of stacks specified in ignore table
-- Args: ignore (table) Example: { "fuel": 1, "primBlock": 2 }
-- Returns nothing
function tTurtle.dumpInventoryExceptByType(ignore)
    -- Dump inventory
    print("Dumping inventory...")
    for i = 1, 16 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data then
            local keep = false
            if ignore then
                for k, v in pairs(ignore) do
                    for _, w in pairs(itemDict[k]) do
                        if data.name == w.name then
                            if v > 0 then
                                keep = true
                                ignore[k] = v - 1
                            end
                        end
                    end
                end
            end
            if not keep then
                turtle.drop()
            end
        end
    end
end

-- Dump specified item type items from inventory
-- Args: type blacklist (array) Example: { "fuel", "primBlock" }
--       keepSlots (number): Number of stack slots to keep.  If nil, drop all
--                    Example: 2 => Everything except 2 stacks will be dropped
-- Returns nothing
function tTurtle.dumpInventoryBlacklist(blacklist, keepSlots)
    -- Dump inventory
    local emptiedSlots = 0
    print("Dumping inventory...")
    for i = 1, 16 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data then
            local drop = false
            if blacklist then
                for _, v in pairs(blacklist) do
                    for _, w in pairs(itemDict[v]) do
                        if data.name == w.name then
                            drop = true
                        end
                    end
                end
            end
            if drop then
                if keepSlots then
                    if emptiedSlots < keepSlots then
                        -- Skip dropping if keepSlots not reached
                        emptiedSlots = emptiedSlots + 1
                    else
                        print("Dropping " .. data.name)
                        turtle.drop()
                        emptiedSlots = emptiedSlots + 1
                    end
                else
                    print("Dropping " .. data.name)
                    turtle.drop()
                    emptiedSlots = emptiedSlots + 1
                end
            end
        end
    end
    if emptiedSlots == 0 then
        print("No items dropped")
    else
        print(emptiedSlots .. " items dropped")
    end
end

-- Sort inventory
--  Stack items together
--  Move items to first empty slot
function tTurtle.sortInventory()
    print("Sorting inventory...")
    for i = 2, 16 do
        local count = turtle.getItemCount(i)
        if count > 0 then
            turtle.select(i)
            local j = 1
            while turtle.getItemCount(i) > 0 and j < i do
                turtle.transferTo(j, count)
                j = j + 1
            end
        end
    end
end

return tTurtle
