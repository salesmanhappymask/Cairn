local args = {...}

local CONFIG_FILE = ".cairn_repo"
local VERSION_FILE = ".cairn_version"
local MANIFEST_NAME = "manifest.txt"
local STAGE_DIR = ".cairn_update_stage"
local BACKUP_DIR = ".cairn_update_backup"

local function normalize(url)
    url = string.gsub(url or "", "%s+$", "")
    url = string.gsub(url, "/+$", "")
    return url
end

local function writeText(path, data)
    local h = fs.open(path, "w")
    if not h then
        return false
    end
    h.write(data)
    h.close()
    return true
end

local function readText(path)
    if not fs.exists(path) then
        return nil
    end
    local h = fs.open(path, "r")
    if not h then
        return nil
    end
    local data = h.readAll()
    h.close()
    return data
end

local function fetch(url)
    if not http or not http.get then
        return nil, "HTTP API is unavailable"
    end

    local ok, handle, err = pcall(http.get, url)

    if not ok then
        return nil, tostring(handle)
    end

    if not handle then
        return nil, tostring(err or "HTTP request failed")
    end

    local data = handle.readAll()
    handle.close()

    if not data or data == "" then
        return nil, "Empty response"
    end

    return data
end

local function parseManifest(data)
    local version = nil
    local files = {}

    for line in string.gmatch(data, "[^\r\n]+") do
        local key, value = string.match(line, "^([%w_]+)%s*=%s*(.-)%s*$")

        if key == "version" then
            version = tonumber(value)
        elseif key == "file" and value ~= "" then
            files[#files + 1] = value
        end
    end

    if not version then
        return nil, nil, "Manifest has no version"
    end

    if #files == 0 then
        return nil, nil, "Manifest has no files"
    end

    return version, files
end

local function syntaxCheck(path, name)
    if string.match(name, "%.lua$") or name == "startup" then
        local fn, err = loadfile(path)
        if not fn then
            return false, err
        end
    end
    return true
end

local base = nil

if args[1] and args[1] ~= "" then
    base = normalize(args[1])
    if base ~= "" then
        writeText(CONFIG_FILE, base)
    end
else
    base = normalize(readText(CONFIG_FILE) or "")
end

if base == "" then
    print("Enter the raw repository base URL.")
    print("Example:")
    print("https://raw.githubusercontent.com/user/repo/main")
    write("> ")
    base = normalize(read() or "")

    if base == "" then
        print("Update cancelled")
        return
    end

    if not writeText(CONFIG_FILE, base) then
        print("Could not save repository URL")
        return
    end
end

print("Checking CAIRN repository...")

local manifestData, manifestErr = fetch(base .. "/" .. MANIFEST_NAME)

if not manifestData then
    print("Manifest download failed")
    print(manifestErr or "")
    return
end

local version, files, parseErr = parseManifest(manifestData)

if not version then
    print(parseErr or "Manifest parse failed")
    return
end

if fs.exists(STAGE_DIR) then
    fs.delete(STAGE_DIR)
end
fs.makeDir(STAGE_DIR)

for _, name in ipairs(files) do
    print("Downloading " .. name)

    local data, err = fetch(base .. "/" .. name)

    if not data then
        fs.delete(STAGE_DIR)
        print("Download failed: " .. name)
        print(err or "")
        return
    end

    local path = fs.combine(STAGE_DIR, name)
    local parent = fs.getDir(path)

    if parent ~= "" and not fs.exists(parent) then
        fs.makeDir(parent)
    end

    if not writeText(path, data) then
        fs.delete(STAGE_DIR)
        print("Could not stage " .. name)
        return
    end

    local valid, syntaxErr = syntaxCheck(path, name)

    if not valid then
        fs.delete(STAGE_DIR)
        print("Validation failed: " .. name)
        print(syntaxErr or "")
        return
    end
end

if fs.exists(BACKUP_DIR) then
    fs.delete(BACKUP_DIR)
end
fs.makeDir(BACKUP_DIR)

for _, name in ipairs(files) do
    if fs.exists(name) then
        local backupPath = fs.combine(BACKUP_DIR, name)
        local parent = fs.getDir(backupPath)

        if parent ~= "" and not fs.exists(parent) then
            fs.makeDir(parent)
        end

        fs.copy(name, backupPath)
    end
end

local committed = {}
local commitOk, commitErr = pcall(function()
    for _, name in ipairs(files) do
        local staged = fs.combine(STAGE_DIR, name)

        if fs.exists(name) then
            fs.delete(name)
        end

        local parent = fs.getDir(name)
        if parent ~= "" and not fs.exists(parent) then
            fs.makeDir(parent)
        end

        fs.move(staged, name)
        committed[#committed + 1] = name
    end
end)

if not commitOk then
    for _, name in ipairs(committed) do
        if fs.exists(name) then
            fs.delete(name)
        end
    end

    for _, name in ipairs(files) do
        local backup = fs.combine(BACKUP_DIR, name)
        if fs.exists(backup) then
            local parent = fs.getDir(name)
            if parent ~= "" and not fs.exists(parent) then
                fs.makeDir(parent)
            end
            fs.copy(backup, name)
        end
    end

    if fs.exists(STAGE_DIR) then
        fs.delete(STAGE_DIR)
    end

    print("Update failed; previous files restored")
    print(tostring(commitErr))
    return
end

writeText(VERSION_FILE, tostring(version))

if fs.exists(STAGE_DIR) then
    fs.delete(STAGE_DIR)
end
if fs.exists(BACKUP_DIR) then
    fs.delete(BACKUP_DIR)
end

print("CAIRN updated to version " .. version)
