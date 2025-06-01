-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Chatgpt Hub",
    LoadingTitle = "loading LB Script...",
    LoadingSubtitle = "by Alex",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end,
})

-- Lucky Blocks Tab
local BlocksTab = Window:CreateTab("Lucky Blocks", 4483362458)

-- Define block types and corresponding RemoteEvents
local blockTypes = {
    {Name = "Lucky", Remote = "SpawnLuckyBlock"},
    {Name = "Super", Remote = "SpawnSuperBlock"},
    {Name = "Diamond", Remote = "SpawnDiamondBlock"},
    {Name = "Rainbow", Remote = "SpawnRainbowBlock"},
    {Name = "Galaxy", Remote = "SpawnGalaxyBlock"},
}

for _, block in ipairs(blockTypes) do
    -- Variables to store user settings
    local spawnCount = 1
    local autoSpawn = false
    local spawnInterval = 1
    local autoSpawnConnection

    -- Section for each block type
    local Section = BlocksTab:CreateSection(block.Name .. " Block")

    -- Slider to set the number of blocks to spawn
    BlocksTab:CreateSlider({
        Name = "Number to Spawn",
        Range = {1, 50},
        Increment = 1,
        CurrentValue = 1,
        Callback = function(Value)
            spawnCount = Value
        end,
    })

    -- Button to spawn blocks
    BlocksTab:CreateButton({
        Name = "Spawn " .. block.Name .. " Block(s)",
        Callback = function()
            local remote = game.ReplicatedStorage:FindFirstChild(block.Remote)
            if remote then
                for i = 1, spawnCount do
                    remote:FireServer()
                    wait(0.1)
                end
            else
                warn("RemoteEvent '" .. block.Remote .. "' not found in ReplicatedStorage.")
            end
        end,
    })

    -- Toggle for auto-spawning
    BlocksTab:CreateToggle({
        Name = "Auto Spawn " .. block.Name .. " Block(s)",
        CurrentValue = false,
        Callback = function(Value)
            autoSpawn = Value
            if autoSpawn then
                autoSpawnConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    local remote = game.ReplicatedStorage:FindFirstChild(block.Remote)
                    if remote then
                        for i = 1, spawnCount do
                            remote:FireServer()
                            wait(0.1)
                        end
                    end
                    wait(spawnInterval)
                end)
            else
                if autoSpawnConnection then
                    autoSpawnConnection:Disconnect()
                    autoSpawnConnection = nil
                end
            end
        end,
    })

    -- Slider to set the interval between auto spawns
    BlocksTab:CreateSlider({
        Name = "Auto Spawn Interval (seconds)",
        Range = {1, 10},
        Increment = 1,
        CurrentValue = 1,
        Callback = function(Value)
            spawnInterval = Value
        end,
    })
end
