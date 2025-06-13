-- Configuration for place-specific scripts
local placeScripts = {
    [87700573492940] = {
        url = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/UTDG-87700573492940%20code",
        name = "UTDG Script"
    },
    [662417684] = {
        url = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/lucky%20blcok%20battlegrounds.lua",
        name = "Lucky Block Battlegrounds"
    },
    [2413927524] = {
        url = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/therakerematsered.lua",
        name = "The Rake Remastered"
    },
    [482742811] = {
        url = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/Gtecrushedbyaspeedingwall.lua",
        name = "Get Crushed by a Speeding Wall"
    }
}

-- Fallback script configuration
local fallbackScript = {
    url = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/universial.lua",
    name = "Universal Script"
}

-- Constants
local MAX_RETRIES = 3
local RETRY_DELAY = 2 -- Seconds between retries
local CHARACTER_TIMEOUT = 30 -- Seconds to wait for character to load
local CHECK_INTERVAL = 0.5 -- Seconds between character checks

-- Services
local Players = game:GetService("Players")

-- Logger utility
local Logger = {
    info = function(msg) print("[INFO] " .. msg) end,
    warn = function(msg) warn("[WARN] " .. msg) end,
    error = function(msg) error("[ERROR] " .. msg, 0) end
}

-- Waits for the player's character to load and be ready
local function waitForCharacter()
    local player = Players.LocalPlayer
    if not player then
        Logger.error("LocalPlayer not found")
        return false
    end

    local startTime = tick()
    while tick() - startTime < CHARACTER_TIMEOUT do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude >= 0 then
                Logger.info("Character loaded and ready")
                return true
            end
        end
        wait(CHECK_INTERVAL)
    end

    Logger.warn("Timeout waiting for character to load")
    return false
end

-- Function to load and execute a script from a URL with retry logic
local function loadScript(url, scriptName, retries)
    retries = retries or MAX_RETRIES
    local attempt = MAX_RETRIES - retries + 1

    if attempt > 1 then
        Logger.info(string.format("Retrying (%d/%d) to load script: %s", attempt, MAX_RETRIES, scriptName))
        wait(RETRY_DELAY)
    end

    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url, true) -- Enable caching
        if not scriptContent or scriptContent == "" then
            error("Empty script content received")
        end
        return loadstring(scriptContent)()
    end)

    if success then
        return true, result
    elseif retries > 0 then
        return loadScript(url, scriptName, retries - 1)
    else
        return false, string.format("Failed after %d attempts: %s", MAX_RETRIES, tostring(result))
    end
end

-- Validates a URL (basic check)
local function isValidUrl(url)
    return type(url) == "string" and url:match("^https?://") and url ~= ""
end

-- Main execution
local function main()
    -- Wait for character to load
    if not waitForCharacter() then
        Logger.error("Failed to load script due to character loading timeout")
        return
    end

    local placeId = game.PlaceId
    local scriptConfig = placeScripts[placeId] or fallbackScript
    local scriptUrl = scriptConfig.url
    local scriptName = scriptConfig.name

    if not isValidUrl(scriptUrl) then
        Logger.error(string.format("Invalid URL for script %s: %s", scriptName, scriptUrl))
        return
    end

    Logger.info(string.format("Loading script '%s' for PlaceId: %d from %s", scriptName, placeId, scriptUrl))

    local success, result = loadScript(scriptUrl, scriptName)

    if success then
        Logger.info(string.format("Script '%s' loaded successfully!", scriptName))
    else
        Logger.warn(string.format("Failed to load script '%s': %s", scriptName, result))
    end
end

-- Run main with top-level error handling
local success, err = pcall(main)
if not success then
    Logger.error("Main execution failed: " .. tostring(err))
end
