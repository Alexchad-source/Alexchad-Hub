local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()


local Window = Rayfield:CreateWindow({
   Name = "Universal Chatgpt Hub",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Alex",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})



--PLAYER TAB




local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
       if hum then hum.WalkSpeed = Value end
   end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {0, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
       local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
       if hum then hum.JumpPower = Value end
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
local speed = 5

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
           bv.Velocity = move.Unit * speed
       end
       bv:Destroy()
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

PlayerTab:CreateButton({
   Name = "Sit / Unsit",
   Callback = function()
       local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
       if hum then hum.Sit = not hum.Sit end
   end,
})





--MISC TAB



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


