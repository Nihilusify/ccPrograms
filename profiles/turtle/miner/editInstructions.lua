-- Program to ask user for a list of instructions and write them to a file

-- Usage: editInstructions

-- Clear screen
term.clear()

-- Local variables
local instructions = ""
local width, height = term.getSize()
-- height 2/3 for instructions, 1/3 for commands
local instrWindow = window.create(term.current(), 1, 1, width, math.floor(height * 2 / 3))
local cmdWindow = window.create(term.current(), 1, 10, width, math.floor(height / 3))

local instrScroll = 0

-- Read current instructions
if fs.exists("instructions.txt") then
    local file = fs.open("instructions.txt", "r")
    instructions = file.readAll()
    file.close()
end

-- Local functions
local function printHelp()

    -- Hide windows
    instrWindow.setVisible(false)
    cmdWindow.setVisible(false)
    term.redirect(term.native())

    local helpText = ""
    -- Print available commands
    helpText = helpText .. "Available commands:\n"
    helpText = helpText .. "- (h)elp: print this help message\n"
    helpText = helpText .. "- reset: reset and start again\n"
    helpText = helpText .. "- (l)ist: lists current instructions\n"
    helpText = helpText .. "- (r)emove <line number>: remove instruction at line number\n"
    helpText = helpText .. "- (e)dit <line number> <instruction>: edit instruction at line number\n"
    helpText = helpText .. "- (s)ave: finish and save\n"
    helpText = helpText .. "- (c)ancel: cancel and discard\n"
    helpText = helpText .. "- (a)dd <instruction>: add instruction to list\n"
    helpText = helpText .. "- (u)p/(d)own: scroll instructions\n"

    -- Print available instructions
    helpText = helpText .. "\nAvailable instructions:\n"
    helpText = helpText .. "- go: forward, back, up, down, left, right\n"
    helpText = helpText .. "   e.g. go forward 3 right 2\n"
    helpText = helpText .. "- goDig: forward, back, up, down, left, right\n"
    helpText = helpText .. "   e.g. goDig forward 3 right 2\n"
    helpText = helpText .. "- program: run a program\n"
    helpText = helpText .. "   e.g. program tunnel 5\n"

    -- Print help text
    textutils.pagedPrint(helpText, height - 2)
    term.clear()

    -- Show windows
    instrWindow.setVisible(true)
    cmdWindow.setVisible(true)
    term.redirect(cmdWindow)
end

local function resetInstructions()
    -- Ask user for confirmation
    print("Are you sure you want to reset? (y/n)")
    local YNinput = read()
    if YNinput == "y" or YNinput == "Y" then
        -- Clear instructions
        instructions = ""
        print("Instructions reset.  Make sure to save before exiting.")
    end
end

local function listInstructions()
    instrWindow.clear()

    -- Print instructions with line numbers at correct scroll position
    instrWindow.setCursorPos(1, 1)
    local lineNumber = 1
    for line in instructions:gmatch("[^\r\n]+") do
        if lineNumber > instrScroll then
            instrWindow.write(lineNumber .. ": " .. line)
            local _, y = instrWindow.getCursorPos()
            instrWindow.setCursorPos(1, y + 1)
        end
        lineNumber = lineNumber + 1
    end
end

local function removeInstruction(lineNumber)
    -- Split instructions into lines
    local lines = {}
    for line in instructions:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Check if line number is valid
    if lineNumber < 1 or lineNumber > #lines then
        print("Invalid line number")
        return
    end

    -- Ask user for confirmation
    print(lines[lineNumber])
    print("Are you sure you want to remove line " .. lineNumber .. "? (y/n)")
    local YNinput = read()
    if YNinput ~= "y" and YNinput ~= "Y" then
        return
    end

    -- Remove line
    table.remove(lines, lineNumber)

    -- Join lines
    instructions = table.concat(lines, "\n")
end

local function validateInstruction(instruction)
    if instruction == nil or instruction == "" then
        print("Invalid instruction")
        return false
    end

    if instruction:match("^go") then
        -- Check if instruction is valid
        -- e.g. go forward 3 right 2
        if not instruction:match("^go %w") then
            print("Invalid instruction")
            print("Usage: go <direction> <[number]>")
            return false
        end
    elseif instruction:match("^goDig") then
        -- Check if instruction is valid
        if not instruction:match("^goDig %w") then
            print("Invalid instruction")
            return false
        end
    elseif instruction:match("^program") then
        -- Check if instruction is valid
        if not instruction:match("^program %w") then
            print("Invalid instruction")
            return false
        end
    else
        print("Invalid instruction")
        return false
    end

    return true
end

local function editInstruction(lineNumber, instruction)
    -- Check if instruction is valid
    if not validateInstruction(instruction) then
        return
    end

    -- Split instructions into lines
    local lines = {}
    for line in instructions:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Check if line number is valid
    if lineNumber < 1 or lineNumber > #lines then
        print("Invalid line number")
        return
    end

    -- Edit line
    lines[lineNumber] = instruction

    -- Join lines
    instructions = table.concat(lines, "\n")
end

local function addInstruction(instruction)
    -- Check if instruction is valid
    if not validateInstruction(instruction) then
        return
    end

    -- Add instruction
    instructions = instructions .. "\n" .. instruction
end

-- Main program

instrWindow.setBackgroundColor(colors.white)
instrWindow.setTextColor(colors.black)

term.redirect(cmdWindow)
listInstructions()
print("")
print("For help, type 'help' or 'h' or '?'")

-- Ask user for instructions.
-- Repeat until user enters "done"
while true do
    -- Read instruction
    write("-> ")
    local input = read()

    -- Clear screen
    term.clear()
    print(input)

    -- Split input into words
    local words = {}
    for word in input:gmatch("%S+") do
        table.insert(words, word)
    end

    -- Process key presses
    if input == keys.up then
        print("up")
        instrWindow.scroll(-1)
    elseif input == keys.down then
        print("down")
        instrWindow.scroll(1)
    end

    -- Check if input is empty
    if #words == 0 then
        -- Do nothing
        -- Check if input is help
    elseif words[1] == "help" or words[1] == "h" or words[1] == "?" then
        printHelp()
        -- Check if input is reset
    elseif words[1] == "reset" then
        resetInstructions()
        -- Check if input is list
    elseif words[1] == "list" or words[1] == "l" then
        -- Instructions are printed at the end of the loop
        -- Check if input is remove
    elseif words[1] == "remove" or words[1] == "r" then
        -- Check if line number is given
        if #words == 2 then
            -- Check if line number is a number
            if tonumber(words[2]) ~= nil then
                -- Remove instruction
                removeInstruction(tonumber(words[2]))
            else
                print("Invalid line number")
            end
        else
            print("Usage: remove <line number>")
        end
    elseif words[1] == "edit" or words[1] == "e" then
        -- Check if line number is given
        if #words >= 3 then
            -- Check if line number is a number
            if tonumber(words[2]) ~= nil then
                -- Edit instruction
                editInstruction(tonumber(words[2]), table.concat(words, " ", 3))
            else
                print("Invalid line number")
            end
        else
            print("Usage: edit <line number> <instruction>")
        end
        -- Check if input is save
    elseif words[1] == "save" or words[1] == "s" then
        -- Save instructions to file
        local file = fs.open("instructions.txt", "w")
        file.write(instructions)
        file.close()

        term.redirect(term.native())
        term.clear()
        textutils.slowPrint(instructions, 40)
        
        print("Instructions saved")

        -- Exit loop
        break
        -- Check if input is cancel
    elseif words[1] == "cancel" or words[1] == "c" then
        term.redirect(term.native())
        term.clear()
        textutils.slowPrint("Instructions discarded")
        -- Exit loop
        break
        -- Check if input is add
    elseif words[1] == "add" or words[1] == "a" then
        -- Check if instruction is given
        if #words >= 2 then
            -- Add instruction
            addInstruction(table.concat(words, " ", 2))
        else
            print("Usage: add <instruction>")
        end
        -- Check if input is up
    elseif words[1] == "up" or words[1] == "u" then
        -- min scroll is 1
        instrScroll = math.max(instrScroll - 1, 0)
        -- Check if input is down
    elseif words[1] == "down" or words[1] == "d" then
        -- max scroll is number of lines
        instrScroll = math.min(instrScroll + 1, #instructions)
        -- Check if input is go
    else
        print("Invalid command")
    end

    -- Print instructions
    listInstructions()
end
