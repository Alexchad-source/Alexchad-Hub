local placeScripts = {
    [12345678] = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/main/script_for_place1.lua",
    [87654321] = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/main/script_for_place2.lua",
    -- add more place IDs and URLs here
}

local placeId = game.PlaceId
local scriptUrl = placeScripts[placeId]

if scriptUrl then
    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)
    if not success then
        warn("Failed to load script for this place: "..err)
    end
else
    warn("No script mapped for this PlaceId: "..placeId)
end
