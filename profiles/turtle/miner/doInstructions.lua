-- Program to perform instructions saved to the file

-- Usage: doInstructions <[instructions file]>
-- instructions file (optional): file containing instructions to perform (default: instructions.txt)

-- Clear screen
term.clear()

-- Local variables
local instructions = ""

-- Get instructions file
local instructionsFile = "instructions.txt"
if arg[1] ~= nil then
    instructionsFile = arg[1]
end

-- Read instructions file
local file = fs.open(instructionsFile, "r")
instructions = file.readAll()
file.close()

-- Check if instructions file is empty
if instructions == "" then
    print("Instructions file is empty")
    return
end

-- Split instructions into lines
local lines = {}
for line in instructions:gmatch("[^\r\n]+") do
    table.insert(lines, line)
end

-- Loop through instructions
for i = 1, #lines do
    -- Split line into words
    local words = {}
    for word in lines[i]:gmatch("%S+") do
        table.insert(words, word)
    end

    -- Check if instruction is go
    if words[1] == "go" then
        -- Run go script with arguments
        shell.run("go", table.unpack(words, 2))

        -- Check if instruction is goDig
    elseif words[1] == "goDig" then
        -- Run goDig script with arguments
        shell.run("goDig", table.unpack(words, 2))

        -- Check if instruction is program
    elseif words[1] == "program" then
        -- Run program script with arguments
        shell.run(words[2], table.unpack(words, 3))
    elseif words[1] == "wait" then
        -- Sleep for specified number of seconds
        print("Waiting for " .. words[2] .. " seconds")
        sleep(tonumber(words[2]))
    elseif words[1] == "waitUser" then
        -- Wait for user to press enter
        print("Press enter to continue")
        read()
    end
end

-- Clear screen
term.clear()

-- Print done
print("Done performing instructions")
