-- dont think of it skid btw you may copy all my advanced functions for your own script idrc
local loaderVersion = "1.0"  


local placeScripts = {
    [87700573492940] = "UTDG-87700573492940.lua",
    [662417684] = "lucky_block_battlegrounds.lua",
    [2413927524] = "therakerematsered.lua",
    [482742811] = "Gtecrushedbyaspeedingwall.lua",
    [101949297449238] = "Build-an-Island.lua"
}

-- URLs
local baseUrl = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/"
local universalFile = "universial.lua"
local universalUrl = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/" .. universalFile

local folderName = "AlexchadHub"
local versionFile = folderName .. "/loader_version.txt"

-- Executor filesystem support check
local hasFileSystem = type(isfolder) == "function" and type(makefolder) == "function"
                   and type(writefile) == "function" and type(readfile) == "function" 
                   and type(delfolder) == "function"

local function safeHttpGet(url)
    local ok, res = pcall(function()
        if game.HttpGetAsync then
            return game:HttpGetAsync(url, true)
        else
            return game:HttpGet(url, true)
        end
    end)
    return ok and res or nil
end

local function ensureFolder()
    if hasFileSystem and not isfolder(folderName) then
        makefolder(folderName)
    end
end

local function writeVersion()
    if hasFileSystem then
        writefile(versionFile, loaderVersion)
    end
end

local function readVersion()
    if hasFileSystem and isfile(versionFile) then
        local ok, content = pcall(readfile, versionFile)
        if ok and content then
            return content
        end
    end
    return "0.0" -- if no version file, treat as oldest
end

local function compareVersions(localV, remoteV)
    local function toNumParts(ver)
        local major, minor = ver:match("^(%d+)%.(%d+)$")
        return tonumber(major) or 0, tonumber(minor) or 0
    end
    local lMajor, lMinor = toNumParts(localV)
    local rMajor, rMinor = toNumParts(remoteV)
    if lMajor ~= rMajor then return lMajor - rMajor end
    return lMinor - rMinor
end

local function resetAndReinstall()
    if hasFileSystem and isfolder(folderName) then
        delfolder(folderName)
        makefolder(folderName)
    end
end

local function fileExists(path)
    if hasFileSystem then
        return isfile(path)
    end
    return false
end

local function saveScript(filename, content)
    if hasFileSystem then
        writefile(filename, content)
    end
end

local function loadScriptFromFile(filename)
    if hasFileSystem and isfile(filename) then
        local ok, content = pcall(readfile, filename)
        return ok and content or nil
    end
    return nil
end

local function loadAndCacheScript(url, filename)
    local content = safeHttpGet(url)
    if content then
        saveScript(filename, content)
        return content
    end
    return nil
end

local function main()
    if not hasFileSystem then
        warn("[Alexchad Loader] Filesystem unsupported! Running HTTP fallback.")
    else
        ensureFolder()
        local oldVersion = readVersion()
        if compareVersions(loaderVersion, oldVersion) > 0 then
            print("[Alexchad Loader] New version detected (" .. loaderVersion .. " > " .. oldVersion .. "), reinstalling...")
            resetAndReinstall()
            writeVersion()
        else
            print("[Alexchad Loader] Loader version up to date: " .. loaderVersion)
        end
    end

    -- Universal script
    local universalPath = folderName .. "/" .. universalFile
    local uniScript = loadScriptFromFile(universalPath)
    if not uniScript then
        uniScript = loadAndCacheScript(universalUrl, universalPath)
    end
    if uniScript then
        local ok, err = pcall(loadstring(uniScript))
        if not ok then
            warn("[Alexchad Loader] Failed Universal script: " .. tostring(err))
        end
    end

    -- Game-specific script
    local placeId = game.PlaceId
    local fileName = placeScripts[placeId]
    if fileName then
        local localPath = folderName .. "/" .. fileName
        local scriptContent = loadScriptFromFile(localPath)
        if not scriptContent then
            local url = baseUrl .. fileName
            scriptContent = loadAndCacheScript(url, localPath)
        end
        if scriptContent then
            local ok, err = pcall(loadstring(scriptContent))
            if not ok then
                warn("[Alexchad Loader] Failed Game script: " .. tostring(err))
            end
        else
            warn("[Alexchad Loader] Cannot load game script. Falling back to HTTP.")
            local fallbackUrl = baseUrl .. fileName
            local fallbackOk, fallbackErr = pcall(function()
                return loadstring(game:HttpGet(fallbackUrl, true))()
            end)
            if not fallbackOk then
                warn("[Alexchad Loader] Fallback failed: " .. tostring(fallbackErr))
            end
        end
    else
        print("[Alexchad Loader] No specific script for this game.")
    end
end

local success, err = pcall(main)
if not success then
    warn("[Alexchad Loader] Fatal Error: " .. tostring(err))
end
