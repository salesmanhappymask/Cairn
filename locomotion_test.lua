local args = {...}

local STATE_FILE = ".cairn_locomotion_test"
local TEST_VERSION = 1
local SETTLE_TIME = 0.75
local FIND_TIMEOUT = 10

local faces = {"left", "right", "top", "bottom", "front", "back"}

local directionSets = {
    north = {forward = 2, backward = 3, left = 4, right = 5},
    south = {forward = 3, backward = 2, left = 5, right = 4},
    west = {forward = 4, backward = 5, left = 3, right = 2},
    east = {forward = 5, backward = 4, left = 2, right = 3}
}

local function writeState(state)
    local h = fs.open(STATE_FILE, "w")
    if not h then
        return false, "Could not open state file"
    end
    h.write(textutils.serialize(state))
    h.close()
    return true
end

local function readState()
    if not fs.exists(STATE_FILE) then
        return nil
    end
    local h = fs.open(STATE_FILE, "r")
    if not h then
        return nil
    end
    local data = h.readAll()
    h.close()
    return textutils.unserialize(data)
end

local function addUnique(list, seen, name)
    if name and not seen[name] then
        seen[name] = true
        list[#list + 1] = name
    end
end

local function getNames()
    local list = {}
    local seen = {}

    for _, side in ipairs(faces) do
        local ok, present = pcall(peripheral.isPresent, side)
        if ok and present then
            addUnique(list, seen, side)
        end
    end

    if peripheral.getNames then
        local ok, names = pcall(peripheral.getNames)
        if ok and type(names) == "table" then
            for _, name in ipairs(names) do
                addUnique(list, seen, name)
            end
        end
    end

    return list
end

local function getMethods(name)
    local ok, methods = pcall(peripheral.getMethods, name)
    if not ok or type(methods) ~= "table" then
        return nil
    end
    return methods
end

local function hasMethod(methods, wanted)
    for _, method in ipairs(methods) do
        if method == wanted then
            return true
        end
    end
    return false
end

local function scoreController(name)
    local methods = getMethods(name)
    if not methods or not hasMethod(methods, "move") then
        return nil
    end

    local typeName = ""
    local ok, value = pcall(peripheral.getType, name)
    if ok and value then
        typeName = tostring(value)
    end

    local probe = string.lower(tostring(name) .. " " .. typeName)
    local score = 1

    if string.find(probe, "redstoneinmotion", 1, true) then
        score = score + 100
    end
    if string.find(probe, "carriagecontroller", 1, true) then
        score = score + 100
    end
    if string.find(probe, "carriage", 1, true) then
        score = score + 25
    end
    if string.find(probe, "controller", 1, true) then
        score = score + 10
    end

    return score, typeName
end

local function scanController()
    local bestName = nil
    local bestType = nil
    local bestScore = -1
    local tied = false

    for _, name in ipairs(getNames()) do
        local score, typeName = scoreController(name)
        if score then
            if score > bestScore then
                bestName = name
                bestType = typeName
                bestScore = score
                tied = false
            elseif score == bestScore and name ~= bestName then
                tied = true
            end
        end
    end

    if tied and bestScore <= 1 then
        return nil, nil, "Multiple move-capable peripherals found"
    end

    return bestName, bestType
end

local function findController()
    local started = os.clock()

    while os.clock() - started < FIND_TIMEOUT do
        local name, typeName, err = scanController()
        if name then
            return name, typeName
        end
        if err then
            return nil, nil, err
        end
        sleep(0.25)
    end

    return nil, nil, "No carriage controller found"
end

local function resultText(...)
    local values = {...}
    local parts = {}
    for i = 1, #values do
        if values[i] ~= nil then
            parts[#parts + 1] = tostring(values[i])
        end
    end
    return table.concat(parts, " ")
end

local function callMove(name, direction, simulate)
    local result = {pcall(peripheral.call, name, "move", direction, simulate, false)}
    local callOk = table.remove(result, 1)

    if not callOk then
        return false, resultText(unpack(result))
    end

    if result[1] == false then
        return false, resultText(unpack(result, 2))
    end

    return true, resultText(unpack(result, 2))
end

local function buildMoves(forwardName)
    local d = directionSets[forwardName]
    local segments = {
        {"Raise", 1, 5},
        {"Forward", d.forward, 5},
        {"Backward", d.backward, 10},
        {"Forward", d.forward, 5},
        {"Left", d.left, 5},
        {"Right", d.right, 10},
        {"Left", d.left, 5},
        {"Lower", 0, 5}
    }

    local moves = {}

    for _, segment in ipairs(segments) do
        for i = 1, segment[3] do
            moves[#moves + 1] = {
                label = segment[1] .. " " .. i .. "/" .. segment[3],
                direction = segment[2]
            }
        end
    end

    return moves
end

local function chooseForward()
    local requested = args[1]

    if requested == "--resume" then
        requested = nil
    end

    if requested then
        requested = string.lower(requested)
        if directionSets[requested] then
            return requested
        end
    end

    print("Redstone in Motion uses world directions.")
    print("Which world direction is Cairn facing?")
    write("north/south/east/west: ")

    local answer = string.lower(read() or "")
    if directionSets[answer] then
        return answer
    end

    return nil
end

local state = readState()

if not state then
    local forwardName = chooseForward()

    if not forwardName then
        print("Invalid forward direction")
        return
    end

    state = {
        version = TEST_VERSION,
        forward = forwardName,
        index = 1
    }

    local ok, err = writeState(state)
    if not ok then
        print(err)
        return
    end

    print("CAIRN locomotion test")
    print("Forward: " .. forwardName)
    print("Moves: 50")
    print("")
end

if state.version ~= TEST_VERSION or not directionSets[state.forward] then
    print("Invalid locomotion test state")
    return
end

local moves = buildMoves(state.forward)

while true do
    if state.index > #moves then
        if fs.exists(STATE_FILE) then
            fs.delete(STATE_FILE)
        end
        print("Test complete")
        return
    end

    local move = moves[state.index]
    local controllerName, controllerType, findErr = findController()

    if not controllerName then
        print("Locomotion test stopped")
        print(findErr or "Controller discovery failed")
        print("Progress remains saved at step " .. state.index)
        return
    end

    print("Step " .. state.index .. "/" .. #moves .. ": " .. move.label)
    print("Controller: " .. controllerName)
    if controllerType and controllerType ~= "" then
        print("Type: " .. controllerType)
    end

    local canMove, simErr = callMove(controllerName, move.direction, true)

    if not canMove then
        print("Simulation failed")
        if simErr ~= "" then
            print(simErr)
        end
        print("Progress remains saved at step " .. state.index)
        return
    end

    local currentIndex = state.index
    state.index = state.index + 1

    local saved, saveErr = writeState(state)
    if not saved then
        state.index = currentIndex
        print("Could not save movement state")
        print(saveErr or "")
        return
    end

    local moved, moveErr = callMove(controllerName, move.direction, false)

    if not moved then
        state.index = currentIndex
        writeState(state)
        print("Move failed")
        if moveErr ~= "" then
            print(moveErr)
        end
        print("Progress restored to step " .. state.index)
        return
    end

    sleep(SETTLE_TIME)
end
