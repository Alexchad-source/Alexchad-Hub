local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()


local Window = Rayfield:CreateWindow({
    Name = "Alexchad Hub",
    LoadingTitle = "Alexchad Hub",
    LoadingSubtitle = "The rake remastered",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "RayfieldPlayerConfig"
    },
    Discord = {
       Enabled = false
    },
    KeySystem = false
})

local PlayerTab = Window:CreateTab("Player", 4483362458)

local speedEnabled = false
local currentSpeed = 16 -- default

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Reapply WalkSpeed when character respawns
lp.CharacterAdded:Connect(function(newChar)
	char = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	if speedEnabled then
		humanoid.WalkSpeed = currentSpeed
	end
end)

-- Speed Toggle
PlayerTab:CreateToggle({
	Name = "Enable Custom Speed",
	CurrentValue = false,
	Callback = function(Value)
		speedEnabled = Value
		if humanoid then
			humanoid.WalkSpeed = Value and currentSpeed or 16
		end
	end,
})

-- Speed Slider
PlayerTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {0, 29},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 16,
	Callback = function(Value)
		currentSpeed = Value
		if speedEnabled and humanoid then
			humanoid.WalkSpeed = Value
		end
	end,
})

-- No Fall Damage Toggle
PlayerTab:CreateToggle({
	Name = "No Fall Damage",
	CurrentValue = false,
	Callback = function(Value)
		if not humanoid then return end

		if Value then
			-- Connect protection
			humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				if humanoid.Health < 5 then
					humanoid.Health = 100
				end
			end)
		end
	end,
})

