local placeScripts = {
    [87700573492940] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/UTDG-87700573492940%20code",
    [662417684] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/lucky%20blcok%20battlegrounds.lua",
    [2413927524] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/therakerematsered.lua",
    [482742811] = "https://raw.githubusercontent.com/Alexchad-source/Alexchad-Hub/refs/heads/main/Gtecrushedbyaspeedingwall.lua"
}

local fallbackScript = "https://raw.githubusercontent.com/Alexchad-source/Chatgpt-Hub/refs/heads/main/universial.lua"

local function loadScript(url)
    local success, script = pcall(game.HttpGet, game, url)
    if success and script then
        loadstring(script)()
    end
end

local url = placeScripts[game.PlaceId] or fallbackScript
loadScript(url)
