local loaderVersion = "1.0"



local placeScripts = {
    [87700573492940] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/UTDG-87700573492940.lua",
    [662417684] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/lucky_block_battlegrounds.lua",
    [2413927524] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/therakerematsered.lua",
    [482742811] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/Gtecrushedbyaspeedingwall.lua",
    [101949297449238] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/Build-an-Island-lua",
    [10905034443] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/SmoothieFactoryTycoon.lua"
    --[] = ""--
    --[] = ""--
}

local universalUrl = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/universial.lua"

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

local function executeScript(url)
    local content = safeHttpGet(url)
    if content then
        local ok, err = pcall(loadstring(content))
        if not ok then
            warn("[Alexchad Loader] Failed to execute script: " .. tostring(err))
        end
    else
        warn("[Alexchad Loader] Could not fetch script: " .. url)
    end
end

local function main()
    print("[Alexchad Loader] Version " .. loaderVersion)

    -- Game-specific script FIRST
    local placeId = game.PlaceId
    local scriptUrl = placeScripts[placeId]
    if scriptUrl then
        executeScript(scriptUrl)
    else
        -- No specific script, fallback to universal
        print("[Alexchad Loader] No specific script found. Loading universal script...")
        executeScript(universalUrl)
    end
end

local success, err = pcall(main)
if not success then
    warn("[Alexchad Loader] Fatal Error: " .. tostring(err))
end
