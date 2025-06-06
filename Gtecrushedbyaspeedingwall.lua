local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Alexchad Hub",
   LoadingTitle = "Loading GCBASW",
   LoadingSubtitle = "by Alex",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

-- MainTab creation
local MainTab = Window:CreateTab("Main", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lifebricks = workspace:WaitForChild("Lifebricks")



local autoFarmEnabled = false

MainTab:CreateToggle({
    Name = "Auto Farm Lifebricks (1->4)",
    CurrentValue = false,
    Callback = function(value)
        autoFarmEnabled = value
        if autoFarmEnabled then
            task.spawn(function()
                while autoFarmEnabled do
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if not hrp then
                        LocalPlayer.CharacterAdded:Wait()
                        char = LocalPlayer.Character
                        hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not hrp then
                            task.wait(1)
                            continue
                        end
                    end

                    for i = 1, 4 do
                        local part = Lifebricks:FindFirstChild(tostring(i))
                        if part and part:IsA("BasePart") then
                            hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.8)
                        else
                            break
                        end
                    end

                    -- Reset character
                    

                    -- Wait for new character to spawn & update hrp reference
                    LocalPlayer.CharacterAdded:Wait()
                    char = LocalPlayer.Character
                    hrp = char and char:WaitForChild("HumanoidRootPart", 5)
                    if not hrp then
                        task.wait(1)
                        continue
                    end

                    task.wait(3) -- delay before next run
                end
            end)
        end
    end,
})
local autoFarmEnabledblatant = false

MainTab:CreateToggle({
    Name = "Auto Farm Lifebricks (blatant) (1->4)", -- geänderter Name
    CurrentValue = false,
    Callback = function(value)
        autoFarmEnabledblatant = value
        if autoFarmEnabledblatant then  -- korrigierte Variable
            task.spawn(function()
                while autoFarmEnabledblatant do
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if not hrp then
                        LocalPlayer.CharacterAdded:Wait()
                        char = LocalPlayer.Character
                        hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not hrp then
                            task.wait(0.1)
                            continue
                        end
                    end

                    for i = 1, 4 do
                        local part = Lifebricks:FindFirstChild(tostring(i))
                        if part and part:IsA("BasePart") then
                            hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.3)
                        else
                            break
                        end
                    end

                    if char then
                        char:BreakJoints()
                    end

                    LocalPlayer.CharacterAdded:Wait()
                    char = LocalPlayer.Character
                    hrp = char and char:WaitForChild("HumanoidRootPart", 5)
                    if not hrp then
                        task.wait(0.1)
                        continue
                    end

                    task.wait(0.1)
                end
            end)
        end
    end,
})

MainTab:CreateButton({
    Name = "Delete Wall",
    Callback = function()
        local wall = workspace.Map.Tunnel.Wall
        if wall then
            wall:Destroy()
        end
    end
})

MainTab:CreateButton({
    Name = "Delete Kill Blocks",
    Callback = function()
        for i,v in pairs(game:GetService('Workspace'):GetChildren()) do
            if v.Name == "Awesome Lava!" then
                v:Destroy()
            elseif v.Name == "Smooth Block Model" then
                if v:FindFirstChild("Script") then v.Script:Destroy() end
                if v:FindFirstChild("TouchInterest") then v.TouchInterest:Destroy() end
            elseif v.Name == "lava" or v.Name == "Lava" then
                if v:FindFirstChild("Script") then v.Script:Destroy() end
                if v:FindFirstChild("TouchInterest") then v.TouchInterest:Destroy() end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Delete impossiwall wall",
    Callback = function()
        local wall2 = game.Workspace:FindFirstChild("Wall2")
        if wall2 then
            wall2:Destroy()
        end
    end
})

MainTab:CreateButton({
    Name = "Finish impossible obby",
    Callback = function()
        local plr = game:GetService('Players').LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local oldcf = hrp.CFrame
        hrp.CFrame = CFrame.new(-5066.81299, 3354.42676, -44055.9648, 0.700624108, 0, 0.71353054, 0, 1, 0, -0.71353054, 0, 0.700624108)
        wait(3)

        for _ = 1, 12 do
            if hrp then hrp.CFrame = oldcf end
            wait(0.5)
        end
    end
})

MainTab:CreateButton({
    Name = "Finish impossiwall",
    Callback = function()
        local plr = game:GetService('Players').LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local oldcf = hrp.CFrame
        hrp.CFrame = CFrame.new(2795.28174, 2062.15332, -14428.668, -1, 0, 0, 0, 0, 1, 0, 1, -0)
        wait(3)

        for _ = 1, 12 do
            if hrp then hrp.CFrame = oldcf end
            wait(0.5)
        end
    end
})




-- PLAYER TAB
local PlayerTab = Window:CreateTab("Player", 4483362458)

local currentWalkSpeed = 16
local currentJumpPower = 50

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 200},
   Increment = 1,
   CurrentValue = currentWalkSpeed,
   Callback = function(Value)
      currentWalkSpeed = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {0, 300},
   Increment = 1,
   CurrentValue = currentJumpPower,
   Callback = function(Value)
      currentJumpPower = Value
   end,
})

PlayerTab:CreateButton({
   Name = "Apply Stats",
   Callback = function()
      local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
      if hum then
         hum.WalkSpeed = currentWalkSpeed
         hum.JumpPower = currentJumpPower
      end
   end,
})

local noclip = false

game:GetService("RunService").Stepped:Connect(function()
   if noclip then
      local char = game.Players.LocalPlayer.Character
      if char then
         for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
         end
      end
   end
end)

PlayerTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(Value)
      noclip = Value
   end,
})

local flying = false
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local speed = 100

PlayerTab:CreateToggle({
   Name = "Fly (WASD)",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      local plr = game.Players.LocalPlayer
      local char = plr.Character or plr.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      local bv = Instance.new("BodyVelocity", root)
      bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
      bv.Velocity = Vector3.zero

      while flying and RS.RenderStepped:Wait() do
         local move = Vector3.zero
         if UIS:IsKeyDown(Enum.KeyCode.W) then move += workspace.CurrentCamera.CFrame.LookVector end
         if UIS:IsKeyDown(Enum.KeyCode.S) then move -= workspace.CurrentCamera.CFrame.LookVector end
         if UIS:IsKeyDown(Enum.KeyCode.A) then move -= workspace.CurrentCamera.CFrame.RightVector end
         if UIS:IsKeyDown(Enum.KeyCode.D) then move += workspace.CurrentCamera.CFrame.RightVector end
         bv.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.zero
      end
      bv:Destroy()
   end,
})

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         game:GetService("UserInputService").JumpRequest:Connect(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
         end)
      end
   end,
})

PlayerTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char then
         char:BreakJoints()
      end
   end,
})

-- MISC TAB
local MiscTab = Window:CreateTab("Misc", 4483363063)

MiscTab:CreateButton({
   Name = "Full Bright",
   Callback = function()
      local l = game:GetService("Lighting")
      l.Brightness = 2
      l.ClockTime = 12
      l.FogEnd = 1e9
      l.GlobalShadows = false
      l.OutdoorAmbient = Color3.new(1, 1, 1)
   end,
})

MiscTab:CreateButton({
   Name = "FPS Boost",
   Callback = function()
      for _, obj in pairs(game:GetDescendants()) do
         if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
         elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
         end
      end
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
      game:GetService("Lighting").GlobalShadows = false
      game:GetService("Lighting").FogEnd = 100000
   end,
})

MiscTab:CreateButton({
   Name = "Copy Discord Invite",
   Callback = function()
      setclipboard("https://discord.gg/yourserver")
   end,
})

MiscTab:CreateButton({
   Name = "Enable Anti-AFK",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
         vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
         task.wait(1)
         vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      end)
   end,
})

MiscTab:CreateButton({
   Name = "ServerHop",
   Callback = function()
      local Http = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Player = game.Players.LocalPlayer
      local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
      for _, v in pairs(Servers.data) do
         if v.playing < v.maxPlayers then
            TPS:TeleportToPlaceInstance(game.PlaceId, v.id, Player)
            break
         end
      end
   end,
})
