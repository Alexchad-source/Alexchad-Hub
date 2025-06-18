local function FindSlapFolders(parent)
    local folders = {}
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("Folder") and (child.Name == "Slap" or child.Name == "Slaps") then
            table.insert(folders, child)
        elseif #child:GetChildren() > 0 then
            -- recurse deeper
            local subFolders = FindSlapFolders(child)
            for _, sub in pairs(subFolders) do
                table.insert(folders, sub)
            end
        end
    end
    return folders
end

-- Teleport function
local function TeleportToAllParts()
    local folders = FindSlapFolders(Workspace)
    if #folders == 0 then
        
        return
    end

    for _, folder in pairs(folders) do
        for _, item in pairs(folder:GetChildren()) do
            if item:IsA("Model") and item.PrimaryPart then
                Character:PivotTo(item.PrimaryPart.CFrame)
                task.wait(0.5)
            elseif item:IsA("BasePart") then
                Character:PivotTo(item.CFrame)
                task.wait(0.5)
            end
        end
    end

    
end









local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()


local Window = Rayfield:CreateWindow({
   Name = "Alexchad Hub",
   LoadingTitle = "Loading Universial",
   LoadingSubtitle = "by Alex",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
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

local infJumpConn
PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         infJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
         end)
      else
         if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
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

MainTab:CreateButton({
    Name = "Teleport to all slaps (may not work and only for those games in some games you also have to press e) ",
    Callback = function()
        TeleportToAllParts()
    end
})

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
