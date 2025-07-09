local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Alexchad Hub - Rainbow Friends 2",
    LoadingTitle = "Alexchad Hub",
    LoadingSubtitle = "RF2 Enhancer v1.0",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "alexchad_rf2",
        FileName = "config"
    }
})

local PlayerTab = Window:CreateTab("Player")
local EspTab = Window:CreateTab("ESP")
local SettingsTab = Window:CreateTab("Settings")

Rayfield:Notify({
    Title = "Alexchad Hub",
    Content = "RF2 Loaded - v1.0",
    Duration = 3
})

-- ESP Utility
local function CreateEsp(obj, color)
    if obj and not obj:FindFirstChildOfClass("Highlight") then
        local hl = Instance.new("Highlight", obj)
        hl.FillColor = color
        hl.OutlineColor = color
    end
end
local function ClearEsp(obj)
    local hl = obj:FindFirstChildOfClass("Highlight")
    if hl then hl:Destroy() end
end

-- Combined ESP Toggle
local allEsp = false
EspTab:CreateToggle({
    Name = "All ESP (Items + Monsters)",
    CurrentValue = false,
    Callback = function(state)
        allEsp = state
        task.spawn(function()
            while allEsp do
                -- Items
                for _,v in ipairs(workspace:GetChildren()) do
                    if table.find({"CakeMix", "GasCanister", "LightBulb"}, v.Name) then
                        CreateEsp(v, Color3.fromRGB(0, 255, 0))
                    end
                end
                -- Looky
                for _,v in ipairs(workspace.ignore:GetChildren()) do
                    if v.Name == "Looky" and v.PrimaryPart then
                        CreateEsp(v.PrimaryPart, Color3.fromRGB(0, 255, 0))
                    end
                end
                -- Monsters
                for _,v in ipairs(workspace.Monsters:GetChildren()) do
                    CreateEsp(v, Color3.fromRGB(255, 0, 0))
                end
                task.wait(0.3)
            end

            -- Cleanup
            for _,v in ipairs(workspace:GetChildren()) do
                if table.find({"CakeMix", "GasCanister", "LightBulb"}, v.Name) then ClearEsp(v) end
            end
            for _,v in ipairs(workspace.ignore:GetChildren()) do
                if v.Name == "Looky" and v.PrimaryPart then ClearEsp(v.PrimaryPart) end
            end
            for _,v in ipairs(workspace.Monsters:GetChildren()) do ClearEsp(v) end
        end)
    end
})

-- Auto Task Completion
local autoTask = false
PlayerTab:CreateToggle({
    Name = "Auto Complete Task",
    CurrentValue = false,
    Callback = function(state)
        autoTask = state
        task.spawn(function()
            while autoTask do
                local char = game.Players.LocalPlayer.Character
                if not char then task.wait(0.5) continue end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end

                -- Prioritize CakeMix > GasCanister > LightBulb > Looky
                local function tpTo(name)
                    for _,v in ipairs(workspace:GetChildren()) do
                        if v.Name == name and v:IsA("Model") and v:FindFirstChild("PrimaryPart") then
                            hrp.CFrame = v.PrimaryPart.CFrame
                            return true
                        end
                    end
                    return false
                end
                local function tpToLooky()
                    for _,v in ipairs(workspace.ignore:GetChildren()) do
                        if v.Name == "Looky" and v:IsA("Model") and v:FindFirstChild("PrimaryPart") then
                            hrp.CFrame = v.PrimaryPart.CFrame
                            return true
                        end
                    end
                    return false
                end

                if not tpTo("CakeMix") then
                    if not tpTo("GasCanister") then
                        if not tpTo("LightBulb") then
                            tpToLooky()
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
})

-- Manual Task Pickup
PlayerTab:CreateButton({
    Name = "Pickup Next Closest Item",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _,name in ipairs({"CakeMix", "GasCanister", "LightBulb"}) do
            for _,v in ipairs(workspace:GetChildren()) do
                if v.Name == name and v:IsA("Model") and v:FindFirstChild("PrimaryPart") then
                    hrp.CFrame = v.PrimaryPart.CFrame
                    return
                end
            end
        end
        for _,v in ipairs(workspace.ignore:GetChildren()) do
            if v.Name == "Looky" and v:IsA("Model") and v:FindFirstChild("PrimaryPart") then
                hrp.CFrame = v.PrimaryPart.CFrame
                return
            end
        end
    end
})

-- Speed Control
local walkSpeed = 16
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 21},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = walkSpeed,
    Callback = function(val)
        walkSpeed = val
    end
})

local speedActive = false
PlayerTab:CreateToggle({
    Name = "Apply WalkSpeed",
    CurrentValue = false,
    Callback = function(state)
        speedActive = state
        task.spawn(function()
            while speedActive do
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = walkSpeed
                end
                task.wait(0.2)
            end
        end)
    end
})

-- FPS Boost
local fpsBoost = false
SettingsTab:CreateToggle({
    Name = "FPS Boost Mode",
    CurrentValue = false,
    Callback = function(state)
        fpsBoost = state
        if fpsBoost then
            game.Lighting.FogEnd = 1e10
            game.Lighting.GlobalShadows = false
            game.Lighting.Brightness = 0
            sethiddenproperty(game.Lighting, "Technology", Enum.Technology.Compatibility)
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Texture") or v:IsA("Decal") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        else
            game.Lighting.GlobalShadows = true
            game.Lighting.Brightness = 2
        end
    end
})

-- Unload Button
SettingsTab:CreateButton({
    Name = "Unload Alexchad Hub",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Theme Switcher
SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = {"Default", "Amber Glow", "Amethyst", "Bloom", "Dark Blue", "Green", "Light", "Ocean", "Serenity"},
    CurrentOption = "Default",
    Callback = function(theme)
        Window.ModifyTheme(theme[1])
    end
})

Rayfield:LoadConfiguration()
