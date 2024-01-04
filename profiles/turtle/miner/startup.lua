-- Startup script for turtle miner profile
-- This script is meant to replace the default startup script

term.clear()

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
if not shell.run("github", "Nihilusify", "ccPrograms", "profiles/turtle/miner/profile.json", "profile.json") then
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
    if not localProfile or not localProfile.programs or not localProfile.programs[k] or localProfile.programs[k].version < v.version then
        local success = shell.run("github", "Nihilusify", "ccPrograms", "profiles/turtle/miner/" .. v.name, v.name)
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
    local success = shell.run("github", "Nihilusify", "ccPrograms", "libs/" .. v, v)
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

-- Run tunnel script
shell.run("tunnel3v", "100")
