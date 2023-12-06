-- Program to download files from github
--
-- Usage: github <user> <repo> <file> <destination> [branch]
-- Example: github Nihilusify turtlePrograms tunnel.lua tunnel.lua

local args = {...}
local user = args[1]
local repo = args[2]
local file = args[3]
local destination = args[4]
local branch = args[5]

if user == nil or repo == nil or file == nil or destination == nil then
    print("Usage: github <user> <repo> <file> <destination>")
    return
end

if branch == nil then
    branch = "main"
end

-- Download file
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
