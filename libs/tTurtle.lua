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

return tTurtle
