-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Alexchad Hub",
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

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Kill Aura Toggle
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local killAuraEnabled = false
local reachDistance = 30 -- Erhöhte Reichweite

-- Toggle im Combat Tab
CombatTab:CreateToggle({
    Name = "Kill Aura (Reach Bypass)",
    CurrentValue = false,
    Callback = function(Value)
        killAuraEnabled = Value
        if killAuraEnabled then
            task.spawn(function()
                while killAuraEnabled do
                    local character = LocalPlayer.Character
                    if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        local tool = character:FindFirstChildOfClass("Tool")
                        if humanoidRootPart and tool then
                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character then
                                    local enemyHRP = player.Character:FindFirstChild("HumanoidRootPart")
                                    local enemyHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                    if enemyHRP and enemyHumanoid and enemyHumanoid.Health > 0 then
                                        local distance = (humanoidRootPart.Position - enemyHRP.Position).Magnitude
                                        if distance <= reachDistance then
                                            -- Tool aktivieren (Angriff)
                                            pcall(function()
                                                tool:Activate()
                                            end)
                                            -- Optional: Bewege Tool (wenn möglich) näher zum Gegner, z.B. Tool.Handle.Position = enemyHRP.Position
                                            -- Oder simuliere Hitbox
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local playerNames = {}
local function updatePlayerNames()
    playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
end
updatePlayerNames()

local selectedPlayerName = nil
local bringAllEnabled = false
local bringSelectedEnabled = false
local runService = game:GetService("RunService")

-- Bring All Toggle
CombatTab:CreateToggle({
    Name = "Bring All Players",
    CurrentValue = false,
    Callback = function(value)
        bringAllEnabled = value
        if value then
            -- Teleport loop
            task.spawn(function()
                while bringAllEnabled do
                    local character = LocalPlayer.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                player.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(2, 0, 0)
                            end
                        end
                    end
                    task.wait(0.5) -- alle 0.5 Sekunden wiederholen
                end
            end)
        end
    end,
})

-- Dropdown für Spieler auswählen
CombatTab:CreateDropdown({
    Name = "Select Player",
    Options = playerNames,
    CurrentOption = nil,
    Callback = function(option)
        selectedPlayerName = option
    end,
})

-- Bring Selected Player Toggle
CombatTab:CreateToggle({
    Name = "Bring Selected Player",
    CurrentValue = false,
    Callback = function(value)
        bringSelectedEnabled = value
        if value then
            task.spawn(function()
                while bringSelectedEnabled do
                    if selectedPlayerName then
                        local targetPlayer = Players:FindFirstChild(selectedPlayerName)
                        local character = LocalPlayer.Character
                        local hrp = character and character:FindFirstChild("HumanoidRootPart")
                        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and hrp then
                            targetPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(2, 0, 0)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})

-- Update dropdown wenn Spieler joinen/leave
Players.PlayerAdded:Connect(function()
    updatePlayerNames()
    CombatTab:UpdateDropdownOptions("Select Player", playerNames)
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerNames()
    CombatTab:UpdateDropdownOptions("Select Player", playerNames)
end)







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
PlayerTab:CreateSlider({
	Name = "JumpPower",
	Range = {50, 300},
	Increment = 5,
	CurrentValue = 50,
	Callback = function(Value)
		local char = game.Players.LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.JumpPower = Value
			end
		end
	end,
})
PlayerTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function(Value)
		getgenv().InfJump = Value
		game:GetService("UserInputService").JumpRequest:Connect(function()
			if getgenv().InfJump then
				local player = game.Players.LocalPlayer
				if player.Character then
					player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end
			end
		end)
	end,
})
PlayerTab:CreateToggle({
	Name = "No Clip",
	CurrentValue = false,
	Callback = function(Value)
		getgenv().NoClip = Value
		game:GetService("RunService").Stepped:Connect(function()
			if getgenv().NoClip then
				local char = game.Players.LocalPlayer.Character
				if char then
					for _, part in ipairs(char:GetDescendants()) do
						if part:IsA("BasePart") and part.CanCollide then
							part.CanCollide = false
						end
					end
				end
			end
		end)
	end,
})
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({
	Name = "Anti AFK",
	Callback = function()
		for _, conn in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
			conn:Disable()
		end
	end,
})
local players = {}
for _, v in pairs(game.Players:GetPlayers()) do
	if v ~= game.Players.LocalPlayer then
		table.insert(players, v.Name)
	end
end


MiscTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/TBJgw6MHcB")
        Rayfield:Notify({
            Title = "Erfolg",
            Content = "Discord-Link wurde kopiert!",
            Duration = 3
        })
    end
})

