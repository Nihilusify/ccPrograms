-- Dictionary of items by category to be used by other programs
-- Item format: {name, display name}

local itemDict = {}

-- Fuel
itemDict.fuel = {
    { name = "minecraft:coal",        display_name = "Coal" },
    { name = "minecraft:charcoal",    display_name = "Charcoal" },
    { name = "minecraft:lava_bucket", display_name = "Lava Bucket" },
    { name = "minecraft:blaze_rod",   display_name = "Blaze Rod" },
    { name = "minecraft:coal_block",  display_name = "Coal Block" },
    { name = "minecraft:planks",      display_name = "Planks" },
    { name = "minecraft:stick",       display_name = "Stick" }
}

-- Primitive Building Blocks
itemDict.primBlock = {
    { name = "minecraft:cobblestone",       display_name = "Cobblestone" },
    { name = "minecraft:mossy_cobblestone", display_name = "Mossy Cobblestone" },
    { name = "minecraft:andesite",          display_name = "Andesite" },
    { name = "minecraft:granite",           display_name = "Granite" },
    { name = "minecraft:diorite",           display_name = "Diorite" },
    { name = "minecraft:dirt",              display_name = "Dirt" },
    { name = "minecraft:netherrack",        display_name = "Netherrack" },
    { name = "minecraft:cobbled_deepslate", display_name = "Cobbled Deepslate" },
    { name = "minecraft:deepslate",         display_name = "Deepslate" },
    { name = "minecraft:basalt",            display_name = "Basalt" },
    { name = "minecraft:soul_soil",         display_name = "Soul Soil" }
}

-- Blocks that fall

-- Light sources
itemDict.lightSource = {
    { name = "minecraft:torch", display_name = "Torch" }
}

itemDict.bucket = {
    { name = "minecraft:bucket",       display_name = "Bucket" },
    { name = "minecraft:water_bucket", display_name = "Water Bucket" },
    { name = "minecraft:lava_bucket",  display_name = "Lava Bucket" }
}

itemDict.fluid = {
    { name = "minecraft:water", display_name = "Water" },
    { name = "minecraft:lava",  display_name = "Lava" }
}

return itemDict
