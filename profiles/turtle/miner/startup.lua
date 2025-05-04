-- Startup script for turtle miner profile
-- This script is meant to replace the default startup script
term.clear()

local base_url = "http://localhost:5173"

-- local functions
local function dlGitHub(user, repo, file, destination, branch)
    local url = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. file
    print("Downloading " .. file)
    local response = http.get(url)
    if response == nil then
        print("Error downloading file")
        return false
    end

    -- Save file
    local file = fs.open(destination, "w")
    file.write(response.readAll())
    file.close()

    return true
end

local function requestName()
    local url = base_url .. "/util/generateName"

    -- Add computerID to the URL
    local computerID = os.getComputerID()
    local url = url .. "?computerId=" .. computerID

    -- Send request
    local response = http.get(url)
    if response == nil then
        print("Error requesting name")
        return false
    end

    -- Get name from response
    local body = response.readAll()
    local name = textutils.unserialiseJSON(body).name

    return name
end

local function assignName()
    -- Get turtle name
    local name = os.getComputerLabel()
    if name == nil then
        print("Turtle name not set, please enter a name:")
        print("To generate a random name, just press enter")
        name = read()

        -- If name is empty, request a name from the name generator
        if name == "" then
            name = requestName()
        end

        -- If name is still nil, generate a random name
        if name == nil then
            name = "Miner" .. math.random(1000, 9999)
        end

        os.setComputerLabel(name)
        print("My name is " .. name)
    end
end

local function downloadInstructions()
    -- Download instructions
    local url = "http://localhost:5173/instructions"
    local computerID = os.getComputerID()
    url = url .. "?computerId=" .. computerID
    local response = http.get(url)
    if response == nil then
        print("Failed to download instructions")
        return
    end

    -- Read response
    local body = response.readAll()
    body = textutils.unserializeJSON(body)

    -- Add instructions
    instructions = body["body"]

    -- Save instructions to file
    local file = fs.open("instructions.txt", "w")
    file.write(instructions)
    file.close()

    print("Instructions downloaded")
end

-- Main

-- Assign name to turtle if it doesn't have one
assignName()

-- Download scripts if newer version is available
-- First read profile.json if it exists
local localProfile = {}
if fs.exists("profile.json") then
    local file = fs.open("profile.json", "r")
    local body = file.readAll()
    localProfile = textutils.unserialiseJSON(body)
    file.close()
end

-- Download new profile.json
if not dlGitHub("Nihilusify", "ccPrograms", "profiles/turtle/miner/profile.json", "profile.json", "main") then
    return false
end

-- Read remote profile.json
local file = fs.open("profile.json", "r")
local remoteProfile = textutils.unserialiseJSON(file.readAll())
file.close()

-- Compare program versions
local reboot = false
for k, v in pairs(remoteProfile.programs) do
    -- If localProfile doesn't exist, or if localProfile is older than remoteProfile
    if not localProfile or not localProfile.programs or not localProfile.programs[k] or localProfile.programs[k].version <
        v.version then
        local success = dlGitHub("Nihilusify", "ccPrograms", "profiles/turtle/miner/" .. v.name, v.name, "main")
        -- If program is startup.lua, reboot after downloading
        if v.name == "startup.lua" then
            reboot = true
        end

        if not success then
            return false
        end
    end
end

-- Download dependency scripts
print("Downloading dependencies...")
for k, v in pairs(remoteProfile.dependencies) do
    local success = dlGitHub("Nihilusify", "ccPrograms", "libs/" .. v, v, "main")
    if not success then
        return false
    end
end

-- Reboot if startup.lua was updated
if reboot then
    print("New version of startup.lua downloaded, rebooting...")
    os.sleep(3)
    os.reboot()
end

term.clear()
print("Download complete, starting program...")

-- If instructions.txt exists, run doInstructions.lua
if fs.exists("instructions.txt") then
    downloadInstructions()
    shell.run("doInstructions")
else
    shell.run("editInstructions")
end
