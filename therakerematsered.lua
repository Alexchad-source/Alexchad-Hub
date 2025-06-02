local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local function getHumanoid()
    local char = lp.Character or lp.CharacterAdded:Wait()
    return char:FindFirstChildOfClass("Humanoid")
end


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
local Main = Window:CreateTab("Main", 4483362458)
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local UserInput = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Für Always Sprint
local function getHumanoid()
    local char = lp.Character or lp.CharacterAdded:Wait()
    return char:FindFirstChildOfClass("Humanoid")
end

-- FullBright original Werte speichern
local originalLighting = {
    Brightness = Lighting.Brightness,
    TimeOfDay = Lighting.TimeOfDay,
    FogEnd = Lighting.FogEnd
}

-- --- Toggle: Unlock Mouse ---
Main:CreateToggle({
    Name = "Unlock Mouse",
    CurrentValue = false,
    Callback = function(v)
        if v then
            UserInput.MouseBehavior = Enum.MouseBehavior.Default
            UserInput.MouseIconEnabled = true
        else
            UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
            UserInput.MouseIconEnabled = false
        end
    end,
})

-- --- Toggle: Full Bright ---
Main:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Callback = function(v)
        if v then
            Lighting.Brightness = 3
            Lighting.TimeOfDay = "14:00:00"
            Lighting.FogEnd = 1e10
        else
            Lighting.Brightness = originalLighting.Brightness
            Lighting.TimeOfDay = originalLighting.TimeOfDay
            Lighting.FogEnd = originalLighting.FogEnd
        end
    end,
})

-- --- Toggle: Always Sprint ---
local alwaysSprintOn = false
local sprintConn
local hum

local function setupSprint()
    hum = getHumanoid()
    if not hum then return end
    if alwaysSprintOn then
        hum.WalkSpeed = 29
        sprintConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if alwaysSprintOn and hum.WalkSpeed ~= 29 then
                hum.WalkSpeed = 29
            end
        end)
    end
end

Main:CreateToggle({
    Name = "Always Sprint (WalkSpeed 29)",
    CurrentValue = false,
    Callback = function(v)
        alwaysSprintOn = v
        if sprintConn then
            sprintConn:Disconnect()
            sprintConn = nil
        end
        if alwaysSprintOn then
            setupSprint()
        else
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end,
})

-- Charakter Respawn abfangen, Sprint neu setzen falls aktiv
lp.CharacterAdded:Connect(function()
    if alwaysSprintOn then
        if sprintConn then
            sprintConn:Disconnect()
            sprintConn = nil
        end
        setupSprint()
    end
end)


