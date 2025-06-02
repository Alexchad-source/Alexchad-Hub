local placeScripts = {
    [87700573492940] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/UTDG-87700573492940%20code",
    [662417684] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/lucky%20blcok%20battlegrounds.lua",
}

-- Universelles script(for unsoppurted games)
local fallbackScriptUrl = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/universial.lua"

local placeId = game.PlaceId
local scriptUrl = placeScripts[placeId] or fallbackScriptUrl

local success, err = pcall(function()
    loadstring(game:HttpGet(scriptUrl))()
end)

if not success then
    warn("Failed to load script: " .. err)
end
