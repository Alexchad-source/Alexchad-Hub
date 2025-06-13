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
local GAME_READY_TIMEOUT = 30 -- Seconds to wait for game/character to load
local CHECK_INTERVAL = 1 -- Seconds between checks
local SCRIPT_CACHE = {} -- Cache for script content

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Logger utility
local Logger = {
    info = function(msg) print("[INFO] " .. msg) end,
    warn = function(msg) warn("[WARN] " .. msg) end,
    error = function(msg) error("[ERROR] " .. msg, 0) end
}

-- Waits for the game and character (if present) to be ready
local function waitForGameReady()
    local player = Players.LocalPlayer
    if not player then
        Logger.warn("LocalPlayer not found, proceeding with game check")
        -- Check if game is minimally loaded
        if #Workspace:GetChildren() > 0 then
            Logger.info("Game assets detected, proceeding")
            return true
        end
        return false
    end

    local function isCharacterReady(character)
        -- Check for 3D character (Humanoid-based)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart and humanoid.Health > 0 then
            return true
        end
        -- Check for 2D/custom character (basic presence in Workspace)
        if character and character:IsDescendantOf(Workspace) then
            return true
        end
        return false
    end

    local startTime = tick()
    local character = player.Character
    if character and isCharacterReady(character) then
        Logger.info("Character already loaded and ready")
        return true
    end

    -- Wait for character or game assets
    local connection
    local success = false
    connection = player.CharacterAdded:Connect(function(newCharacter)
        if isCharacterReady(newCharacter) then
            success = true
            connection:Disconnect()
        end
    end)

    while tick() - startTime < GAME_READY_TIMEOUT and not success do
        -- Check game assets as fallback (e.g., for games without characters)
        if #Workspace:GetChildren() > 0 then
            Logger.info("Game assets detected, proceeding without character")
            success = true
            break
        end
        task.wait(CHECK_INTERVAL)
    end

    if connection and connection.Connected then
        connection:Disconnect()
    end

    if not success then
        Logger.warn("Timeout waiting for game or character, proceeding anyway")
    else
        Logger.info("Game and/or character ready")
    end
    return true -- Proceed regardless to avoid stalling
end

-- Function to load and execute a script from a URL with retry logic
local function loadScript(url, scriptName)
    -- Check cache first
    if SCRIPT_CACHE[url] then
        Logger.info(string.format("Using cached script content for '%s'", scriptName))
        local success, result = pcall(loadstring(SCRIPT_CACHE[url]))
        return success, result
    end

    local function attemptLoad(attempt)
        local success, result = pcall(function()
            local scriptContent = game:HttpGetAsync(url) -- Async HTTP request
            if not scriptContent or scriptContent == "" then
                error("Empty script content received")
            end
            return scriptContent
        end)

        if success then
            SCRIPT_CACHE[url] = result -- Cache the script content
            return pcall(loadstring(result))
        end
        return success, result
    end

    for attempt = 1, MAX_RETRIES do
        if attempt > 1 then
            Logger.info(string.format("Retrying (%d/%d) to load script: %s", attempt, MAX_RETRIES, scriptName))
            task.wait(RETRY_DELAY)
        end

        local success, result = attemptLoad(attempt)
        if success then
            Logger.info(string.format("Script '%s' loaded successfully!", scriptName))
            return true, result
        elseif attempt == MAX_RETRIES then
            return false, string.format("Failed after %d attempts: %s", MAX_RETRIES, tostring(result))
        end
    end
end

-- Validates a URL
local function isValidUrl(url)
    return type(url) == "string" and url:match("^https?://") and url ~= ""
end

-- Main execution
local function main()
    Logger.info("Alexchad Hub Initializing...")

    -- Wait for game and character (if present)
    waitForGameReady()

    local placeId = game.PlaceId
    local scriptConfig = placeScripts[placeId] or fallbackScript
    local scriptUrl = scriptConfig.url
    local scriptName = scriptConfig.name

    if not isValidUrl(scriptUrl) then
        Logger.error(string.format("Invalid URL for script '%s': %s", scriptName, scriptUrl))
        return
    end

    Logger.info(string.format("Loading script '%s' for PlaceId: %d from %s", scriptName, placeId, scriptUrl))

    local success, result = loadScript(scriptUrl, scriptName)

    if not success then
        Logger.warn(string.format("Failed to load script '%s': %s", scriptName, result))
    end
end

-- Run main with top-level error handling
local success, err = pcall(main)
if not success then
    Logger.error("Main execution failed: " .. tostring(err))
end
