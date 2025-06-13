-- Mapping PlaceId => Filename on disk
local placeScripts = {
    [87700573492940] = "UTDG-87700573492940.lua",
    [662417684] = "lucky_block_battlegrounds.lua",
    [2413927524] = "therakerematsered.lua",
    [482742811] = "Gtecrushedbyaspeedingwall.lua"
}

-- Base URLs for download
local baseUrl = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/"

-- Universal fallback script filename and URL
local universalFile = "universial.lua"
local universalUrl = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/" .. universalFile

-- Folder to store scripts locally
local folderName = "Alexchad Hub"

-- Check if executor supports file system
local hasFileSystem = type(isfolder) == "function" and type(makefolder) == "function"
                  and type(writefile) == "function" and type(readfile) == "function"

local function safeHttpGet(url)
    -- Use pcall to avoid breaking on unsupported HTTP requests
    local ok, res = pcall(function()
        -- Use HttpGetAsync if available, else HttpGet
        if game.HttpGetAsync then
            return game:HttpGetAsync(url, true)
        else
            return game:HttpGet(url, true)
        end
    end)
    if ok and type(res) == "string" and #res > 0 then
        return res
    end
    return nil
end

local function ensureFolder()
    if hasFileSystem then
        if not isfolder(folderName) then
            makefolder(folderName)
        end
    end
end

local function fileExists(path)
    if hasFileSystem then
        local ok, _ = pcall(readfile, path)
        return ok
    end
    return false
end

local function saveScript(filename, content)
    if hasFileSystem then
        writefile(filename, content)
    end
end

local function loadScriptFromFile(filename)
    if hasFileSystem then
        local ok, content = pcall(readfile, filename)
        if ok and content then
            return content
        end
    end
    return nil
end

local function loadAndCacheScript(url, filename)
    local scriptContent = safeHttpGet(url)
    if scriptContent then
        saveScript(filename, scriptContent)
        return scriptContent
    end
    return nil
end

-- Main execution starts here
local function main()
    ensureFolder()

    -- First, load the Universal script from local or download it
    local universalPath = folderName .. "/" .. universalFile
    local universalScript = loadScriptFromFile(universalPath)
    if not universalScript then
        universalScript = loadAndCacheScript(universalUrl, universalPath)
    end

    if universalScript then
        local ok, err = pcall(loadstring(universalScript))
        if not ok then
            warn("[Alexchad Loader] Failed to load Universal script: " .. tostring(err))
        end
    else
        warn("[Alexchad Loader] Could not load Universal script.")
    end

    -- Then load game-specific script
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
                warn("[Alexchad Loader] Failed to load game script: " .. tostring(err))
            end
        else
            warn("[Alexchad Loader] Could not load game script, loading from HTTP directly.")

            -- fallback to loadstring(httpget)
            local fallbackUrl = baseUrl .. fileName
            local fallbackSuccess, fallbackScript = pcall(function()
                return loadstring(game:HttpGet(fallbackUrl, true))()
            end)
            if not fallbackSuccess then
                warn("[Alexchad Loader] Failed to load fallback script: " .. tostring(fallbackScript))
            end
        end
    else
        print("[Alexchad Loader] No specific script for this PlaceId, skipping.")
    end
end

local ok, err = pcall(main)
if not ok then
    warn("[Alexchad Loader] Fatal error: " .. tostring(err))
end
