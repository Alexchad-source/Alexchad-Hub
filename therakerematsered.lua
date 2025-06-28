--LOAD RAYFIELD AND MAKE A WINDOW



local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Alexchad Hub v1.20",
    Icon = 0,
    LoadingTitle = "Welcome to Alexchad Hub - last Updated 06/21/2025",
    LoadingSubtitle = "by mushroom0162",
    Theme = "Dark", -- Modern dark theme for better visuals
    DisableRayfieldPrompts = true, -- Cleaner UI
    DisableBuildWarnings = true, -- Reduce console spam
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AlexchadHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = false
})

-- GET EVERY NEEDED SERVICE AND CONFIG + STATES

-- Services
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local Config = {
    AntiRake = {
        DETECTION_RANGE = 50,
        MIN_RUN_DISTANCE = 20,
        MAX_RUN_DISTANCE = 40,
        SPEED_MULTIPLIER = 2,
        MIN_UPDATE_DELAY = 0.01,
        MAX_UPDATE_DELAY = 0.05,
        DISTANCE_SCALING = 200,
        CLOSE_RANGE = 10,
        SMOOTHNESS_CLOSE = 0.05,
        SMOOTHNESS_FAR = 0.1,
        RAY_HEIGHT = 5,
        RAY_DEPTH = -10,
        ALTERNATIVE_OFFSETS = {
            Vector3.new(5, 0, 5),
            Vector3.new(-5, 0, 5),
            Vector3.new(5, 0, -5),
            Vector3.new(-5, 0, -5)
        }
    },
    ESP = {
        Players = {
            Enabled = false,
            FillColor = Color3.fromRGB(0, 140, 255),
            FillTransparency = 0.7,
            OutlineColor = Color3.fromRGB(0, 80, 255),
            OutlineTransparency = 0
        },
        Rake = {
            Enabled = false,
            FillColor = Color3.fromRGB(255, 0, 0),
            FillTransparency = 0.5,
            OutlineColor = Color3.fromRGB(255, 100, 0),
            OutlineTransparency = 0
        },
        FlareGun = {
            Enabled = false,
            FillColor = Color3.fromRGB(255, 200, 0),
            FillTransparency = 0.3,
            OutlineColor = Color3.fromRGB(255, 100, 0),
            OutlineTransparency = 0
        },
        SupplyBox = {
            Enabled = false,
            FillColor = Color3.fromRGB(0, 255, 0),
            FillTransparency = 0.5,
            OutlineColor = Color3.fromRGB(0, 180, 0),
            OutlineTransparency = 0
        }
    },
    AutoFarm = {
        ENABLED = false,
        STEP_DISTANCE = 2,
        UPDATE_DELAY = 0.1
    },
    AutoCollectFlareGun = {
        ENABLED = false,
        SEARCH_INTERVAL = 0.5, -- still here if you want to slow down the loop
        TELEPORT_OFFSET = Vector3.new(0, 2, 0) -- offset to avoid clipping into the part
    },
    AutoScrapCollect = {
        ENABLED = false,
        SEARCH_INTERVAL = 1 -- optional if you want to loop, not required for one-time teleport
    }
}

-- State Management
local State = {
    AntiRake = {
        isActive = false,
        connections = {},
        originalWalkSpeed = nil,
        targetPart = nil
    },
    ESP = {
        Highlights = {},
        Connections = {}
    },
    FullBright = {
        isEnabled = false,
        connection = nil
    },
    ThirdPerson = {
        isEnabled = false
    },
    AutoFarm = {
        isRunning = false,
        targetPart = nil
    },
    AutoCollectFlareGun = {
        isActive = false,
        connection = nil
    },
    AutoScrapCollect = {
        Connection = nil
    }

}

--[FUNCTIONS / FUNCTIONALITY FOR BASICALLY EVERYTHING

--]





local function clearConnections(stateTable)
    for _, connection in ipairs(stateTable.connections) do
        connection:Disconnect()
    end
    table.clear(stateTable.connections)
end

-- Anti-Rake Functions
local function findSafePosition(desiredPosition, speaker)
    local rayOrigin = desiredPosition + Vector3.new(0, Config.AntiRake.RAY_HEIGHT, 0)
    local rayDirection = Vector3.new(0, Config.AntiRake.RAY_DEPTH, 0)
    
    local collision = workspace:FindPartOnRayWithIgnoreList(
        Ray.new(rayOrigin, rayDirection),
        {speaker.Character}
    )
    
    if not collision then
        return desiredPosition
    end
    
    for _, offset in ipairs(Config.AntiRake.ALTERNATIVE_OFFSETS) do
        local altPosition = desiredPosition + offset
        local altRayOrigin = altPosition + Vector3.new(0, Config.AntiRake.RAY_HEIGHT, 0)
        local altCollision = workspace:FindPartOnRayWithIgnoreList(
            Ray.new(altRayOrigin, rayDirection),
            {speaker.Character}
        )
        
        if not altCollision then
            return altPosition
        end
    end
    
    return desiredPosition + Vector3.new(0, 2, 0)
end

local function updateTargetPart()
    local rake = workspace:FindFirstChild("Rake")
    State.AntiRake.targetPart = rake and rake:FindFirstChild("HumanoidRootPart")
    return State.AntiRake.targetPart ~= nil
end

local function runAwayFromTarget(speaker)
    local character = speaker.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not (humanoidRootPart and humanoid) then return end
    
    if humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.1)
    end
    
    if not (State.AntiRake.targetPart and State.AntiRake.targetPart:IsDescendantOf(workspace)) then
        return
    end
    
    local targetPosition = State.AntiRake.targetPart.Position
    local currentPosition = humanoidRootPart.Position
    local distance = (targetPosition - currentPosition).Magnitude
    
    if distance <= Config.AntiRake.DETECTION_RANGE then
        local runDistance = math.clamp(
            distance * 0.75,
            Config.AntiRake.MIN_RUN_DISTANCE,
            Config.AntiRake.MAX_RUN_DISTANCE
        )
        
        local directionAwayFromTarget = (currentPosition - targetPosition).Unit
        local desiredPosition = currentPosition + (directionAwayFromTarget * runDistance)
        
        local safePosition = findSafePosition(desiredPosition, speaker)
        
        local targetLook = CFrame.new(safePosition, targetPosition)
        local smoothness = distance < Config.AntiRake.CLOSE_RANGE and 
            Config.AntiRake.SMOOTHNESS_CLOSE or Config.AntiRake.SMOOTHNESS_FAR
        
        humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(targetLook, smoothness)
        humanoid:MoveTo(safePosition)
        
        local delay = math.clamp(
            distance / Config.AntiRake.DISTANCE_SCALING,
            Config.AntiRake.MIN_UPDATE_DELAY,
            Config.AntiRake.MAX_UPDATE_DELAY
        )
        task.wait(delay)
    end
end

local function setupTargetTracking()
    local workspaceConnection = workspace.ChildAdded:Connect(function(child)
        if child.Name == "Rake" then
            task.wait()
            updateTargetPart()
        end
    end)
    table.insert(State.AntiRake.connections, workspaceConnection)
    
    local removeConnection = workspace.ChildRemoved:Connect(function(child)
        if child.Name == "Rake" then
            State.AntiRake.targetPart = nil
        end
    end)
    table.insert(State.AntiRake.connections, removeConnection)
end

local function toggleAntiRake(value)
    if State.AntiRake.isActive == value then return end
    
    State.AntiRake.isActive = value
    local player = Players.LocalPlayer
    
    if value then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            State.AntiRake.originalWalkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = State.AntiRake.originalWalkSpeed * Config.AntiRake.SPEED_MULTIPLIER
        end
        
        updateTargetPart()
        setupTargetTracking()
        
        local updateConnection = RunService.Heartbeat:Connect(function()
            if State.AntiRake.isActive then
                runAwayFromTarget(player)
            end
        end)
        table.insert(State.AntiRake.connections, updateConnection)
    else
        clearConnections(State.AntiRake)
        
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and State.AntiRake.originalWalkSpeed then
            humanoid.WalkSpeed = State.AntiRake.originalWalkSpeed
        end
    end
end

-- AutoFarm Functions
local function runAutoFarm(speaker)
    local character = speaker.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not (humanoidRootPart and humanoid) then return end
    
    if humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.1)
    end
    
    if not (State.AutoFarm.targetPart and State.AutoFarm.targetPart:IsDescendantOf(workspace)) then
        return
    end
    
    local targetPosition = State.AutoFarm.targetPart.Position
    local characterPosition = humanoidRootPart.Position
    local directionAway = (characterPosition - targetPosition).Unit
    
    humanoidRootPart.CFrame = humanoidRootPart.CFrame + directionAway * Config.AutoFarm.STEP_DISTANCE
    task.wait(Config.AutoFarm.UPDATE_DELAY)
end

local function toggleAutoFarm(value)
    if State.AutoFarm.isRunning == value then return end
    State.AutoFarm.isRunning = value
    
    local player = Players.LocalPlayer
    if value then
        State.AutoFarm.targetPart = workspace:FindFirstChild("Rake") and workspace.Rake:FindFirstChild("HumanoidRootPart")
        if not State.AutoFarm.targetPart then
            Rayfield:Notify({
                Title = "Error",
                Content = "Rake not found in workspace!",
                Duration = 3
            })
            return
        end
        
        local updateConnection = RunService.Heartbeat:Connect(function()
            if State.AutoFarm.isRunning then
                runAutoFarm(player)
            end
        end)
        table.insert(State.AntiRake.connections, updateConnection)
    else
        clearConnections(State.AntiRake)
    end
end

-- ESP Functions
local ESP = {}

function ESP:CreateHighlight(object, settings)
    if not object then return end
    
    self:RemoveHighlight(object)
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = object
    highlight.FillColor = settings.FillColor
    highlight.FillTransparency = settings.FillTransparency
    highlight.OutlineColor = settings.OutlineColor
    highlight.OutlineTransparency = settings.OutlineTransparency
    highlight.Parent = object
    
    State.ESP.Highlights[object] = highlight
    return highlight
end

function ESP:RemoveHighlight(object)
    local highlight = State.ESP.Highlights[object]
    if highlight then
        highlight:Destroy()
        State.ESP.Highlights[object] = nil
    end
end

function ESP:CleanupConnections()
    for _, connection in pairs(State.ESP.Connections) do
        if connection then connection:Disconnect() end
    end
    State.ESP.Connections = {}
end

function ESP:SetupPlayerESP()
    local function handleCharacter(player)
        if not player or player == LocalPlayer then return end
        
        local function updatePlayerESP(character)
            if not character then return end
            
            if Config.ESP.Players.Enabled then
                self:CreateHighlight(character, Config.ESP.Players)
                
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    local deathConnection
                    deathConnection = humanoid.Died:Connect(function()
                        self:RemoveHighlight(character)
                        if deathConnection then
                            deathConnection:Disconnect()
                        end
                    end)
                end
            else
                self:RemoveHighlight(character)
            end
        end
        
        if player.Character then
            updatePlayerESP(player.Character)
        end
        
        local characterConnection = player.CharacterAdded:Connect(updatePlayerESP)
        table.insert(State.ESP.Connections, characterConnection)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        handleCharacter(player)
    end
    
    local playerAddedConnection = Players.PlayerAdded:Connect(handleCharacter)
    table.insert(State.ESP.Connections, playerAddedConnection)
    
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
        if player.Character then
            self:RemoveHighlight(player.Character)
        end
    end)
    table.insert(State.ESP.Connections, playerRemovingConnection)
end

function ESP:SetupObjectESP(objectPath, configKey)
    local function updateObjectESP()
        local object = workspace:FindFirstChild(objectPath, true)
        
        if object then
            if Config.ESP[configKey].Enabled then
                self:CreateHighlight(object, Config.ESP[configKey])
                
                local destructionConnection
                destructionConnection = object.AncestryChanged:Connect(function(_, parent)
                    if not parent then
                        self:RemoveHighlight(object)
                        if destructionConnection then
                            destructionConnection:Disconnect()
                        end
                    end
                end)
            else
                self:RemoveHighlight(object)
            end
        end
    end
    
    local objectUpdateConnection = RunService.Heartbeat:Connect(updateObjectESP)
    table.insert(State.ESP.Connections, objectUpdateConnection)
end

-- Initialize ESP
ESP:SetupPlayerESP()
ESP:SetupObjectESP("Rake", "Rake")
ESP:SetupObjectESP("FlareGunPickUp", "FlareGun")
ESP:SetupObjectESP("Debris.SupplyCrates.Box", "SupplyBox")

-- FullBright Function
local function toggleFullBright(value)
    if State.FullBright.isEnabled == value then return end
    State.FullBright.isEnabled = value
    
    if value then
        local function brightFunc()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
        State.FullBright.connection = RunService.RenderStepped:Connect(brightFunc)
    else
        if State.FullBright.connection then
            State.FullBright.connection:Disconnect()
            State.FullBright.connection = nil
        end
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(213, 213, 213)
    end
end

-- Third Person Function
local function toggleThirdPerson(value)
    if State.ThirdPerson.isEnabled == value then return end
    State.ThirdPerson.isEnabled = value
    LocalPlayer.CameraMaxZoomDistance = value and 30 or 0.5
    LocalPlayer.CameraMinZoomDistance = 0.5
end



local function AutoCollectFlareGunToggle(value)
    Config.AutoCollectFlareGun.ENABLED = value
    State.AutoCollectFlareGun.isActive = value

    if State.AutoCollectFlareGun.connection then
        State.AutoCollectFlareGun.connection:Disconnect()
        State.AutoCollectFlareGun.connection = nil
    end

    if value then
        State.AutoCollectFlareGun.connection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local pickUp = workspace:FindFirstChild("FlareGunPickUp")

            if hrp and pickUp then
                local flare = pickUp:FindFirstChild("FlareGun")
                if flare and flare:IsA("BasePart") then
                    -- Teleport to the flare first
                    hrp.CFrame = flare.CFrame + Config.AutoCollectFlareGun.TELEPORT_OFFSET
                    -- Fire touch interest
                    firetouchinterest(hrp, flare, 0)
                    task.wait(0.1)
                    firetouchinterest(hrp, flare, 1)
                end
            end
        end)
    end
end

local function AutoScrapCollectToggle(value)
    if State.AutoScrapCollect and State.AutoScrapCollect.Connection then
        State.AutoScrapCollect.Connection:Disconnect()
        State.AutoScrapCollect.Connection = nil
    end

    if value then
        State.AutoScrapCollect = State.AutoScrapCollect or {}
        State.AutoScrapCollect.Connection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local scrapFolder = workspace:FindFirstChild("Filter") and workspace.Filter:FindFirstChild("ScrapSpawns")

            if hrp and scrapFolder then
                for _, spawn in ipairs(scrapFolder:GetChildren()) do
                    for _, scrapContainer in ipairs(spawn:GetChildren()) do
                        local scrap = scrapContainer:FindFirstChild("Scrap")
                        if scrap and scrap:IsA("BasePart") then
                            -- Set properties
                            scrap.Anchored = true
                            scrap.CanCollide = true
                            -- Move the scrap to the player (slightly offset to prevent overlap)
                            scrap.CFrame = hrp.CFrame
                        end
                    end
                end
            end
            task.wait(1) -- adjust interval if needed
        end)
    end
end








--///////////////////////////////////
--TAB AND AND EVERYTHING GUI RELTAED 
--///////////////////////////////////

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)



-- Toggle for Main Tab (add to your MainTab section)
MainTab:CreateSection("Auto collect")
MainTab:CreateToggle({
    Name = "Auto Collect Flare Gun",
    CurrentValue = Config.AutoCollectFlareGun.ENABLED,
    Flag = "AutoCollectFlareGun",
    Callback = AutoCollectFlareGunToggle
})

MainTab:CreateToggle({
    Name = "Auto Collect Scrap",
    CurrentValue = false,
    Flag = "AutoScrapCollect",
    Callback = AutoScrapCollectToggle
})



-- Main Tab
MainTab:CreateSection("Anti-Rake Features")
MainTab:CreateToggle({
    Name = "Anti-Rake Chase",
    CurrentValue = false,
    Flag = "AntiRake",
    Callback = toggleAntiRake
})
MainTab:CreateParagraph({
    Title = "Anti-Rake Info",
    Content = "Automatically runs away from Rake when within 50 studs, maintaining a safe distance."
})

MainTab:CreateToggle({
    Name = "Experimental AutoFarm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = toggleAutoFarm
})


MainTab:CreateSection("Game Modifiers")
MainTab:CreateButton({
    Name = "Remove Fall Damage",
    Callback = function()
        local event = ReplicatedStorage:FindFirstChild("FD_Event")
        if event then
            event:Destroy()
            Rayfield:Notify({
                Title = "Success",
                Content = "Fall damage removed!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "FD_Event not found in ReplicatedStorage!",
                Duration = 3
            })
        end
    end
})

MainTab:CreateButton({
    Name = "Infinite Stamina",
    Callback = function()
        local M_Hs = {}
        
        local function isModuleInTable(module)
            for _, existingModule in ipairs(M_Hs) do
                if existingModule == module then
                    return true
                end
            end
            return false
        end
        
        if ReplicatedStorage:FindFirstChild("TKSMNA") and ReplicatedStorage.TKSMNA:FindFirstChild("Event") then
            local event = ReplicatedStorage.TKSMNA.Event
            for _, connection in ipairs(getconnections(event)) do
                if connection.Connected then
                    connection:Disconnect()
                end
            end
        end
        
        for _, module in ipairs(getloadedmodules()) do
            if module.Name == "M_H" and not isModuleInTable(module) then
                table.insert(M_Hs, module)
                local moduleScript = require(module)
                if moduleScript and moduleScript.TakeStamina then
                    local oldTakeStamina = moduleScript.TakeStamina
                    moduleScript.TakeStamina = function(self, amount)
                        if amount > 0 then
                            return oldTakeStamina(self, -0.5)
                        end
                        return oldTakeStamina(self, amount)
                    end
                    Rayfield:Notify({
                        Title = "Success",
                        Content = "Infinite stamina enabled!",
                        Duration = 3
                    })
                else
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "M_H module does not have TakeStamina function!",
                        Duration = 3
                    })
                end
            end
        end
    end
})

-- ESP Tab
ESPTab:CreateSection("ESP Toggles")
local function createESPToggle(name, configKey)
    return ESPTab:CreateToggle({
        Name = "ESP " .. name,
        CurrentValue = Config.ESP[configKey].Enabled,
        Flag = "ESP_" .. configKey,
        Callback = function(value)
            Config.ESP[configKey].Enabled = value
            if configKey == "Players" then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character then
                        if value then
                            ESP:CreateHighlight(player.Character, Config.ESP.Players)
                        else
                            ESP:RemoveHighlight(player.Character)
                        end
                    end
                end
            end
        end
    })
end

createESPToggle("Players", "Players")
createESPToggle("Rake", "Rake")
createESPToggle("Flare Gun", "FlareGun")
createESPToggle("Supply Box", "SupplyBox")

ESPTab:CreateParagraph({
    Title = "ESP Info",
    Content = "Highlights players, Rake, Flare Guns, and Supply Boxes with customizable colors."
})

-- Misc Tab
MiscTab:CreateSection("Visual Modifiers")
MiscTab:CreateToggle({
    Name = "Full Brightness",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = toggleFullBright
})


MiscTab:CreateToggle({
    Name = "Third Person",
    CurrentValue = false,
    Flag = "ThirdPerson",
    Callback = toggleThirdPerson
})


MiscTab:CreateSection("Utilities")
MiscTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
        Rayfield:Notify({
            Title = "GUI Destroyed",
            Content = "Alexchad Hub has been closed.",
            Duration = 3
        })
    end
})

-- Initialize Notifications
Rayfield:Notify({
    Title = "Alexchad Hub Loaded",
    Content = "Enjoy the features! Use responsibly.",
    Duration = 5
})
