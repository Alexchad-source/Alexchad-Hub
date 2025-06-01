local placeScripts = {
    [87700573492940] = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/UTDG-87700573492940%20code",
    [87654321] = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/main/script_for_place2.lua",
    -- add more place IDs and URLs here
}

-- Universelles GUI (für nicht unterstützte Spiele)
local fallbackScriptUrl = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/universial.lua"

local placeId = game.PlaceId
local scriptUrl = placeScripts[placeId] or fallbackScriptUrl

local success, err = pcall(function()
    loadstring(game:HttpGet(scriptUrl))()
end)

if not success then
    warn("Failed to load script: " .. err)
end
