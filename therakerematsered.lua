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

-------------------------------------------------
--  PLAYER TAB FUNCTIONS
-------------------------------------------------
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UserInput   = game:GetService("UserInputService")
local lp          = Players.LocalPlayer

-- helpers
local function getHumanoid()
    local char = lp.Character or lp.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid"), char
end

-- state variables
local speedOn,     speedVal      = false, 16
local jumpOn,      jumpVal       = false, 50
local infJumpOn,   noFallOn      = false, false
local noclipOn,    partTPOn      = false, false
local infJumpConn, noFallConn,   noclipConn, partTPConn

-- ensure settings survive respawn
lp.CharacterAdded:Connect(function()
    local hum = getHumanoid()
    if speedOn  then hum.WalkSpeed  = speedVal  end
    if jumpOn   then hum.JumpPower  = jumpVal   end
end)

-------------------------------------------------
-- WALK SPEED
-------------------------------------------------
PlayerTab:CreateToggle({
    Name = "Custom WalkSpeed",
    CurrentValue = false,
    Callback = function(v)
        speedOn = v
        local hum = getHumanoid()
        hum.WalkSpeed = v and speedVal or 16
    end,
})
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 29},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        speedVal = v
        if speedOn then getHumanoid().WalkSpeed = v end
    end,
})

-------------------------------------------------
-- JUMP POWER
-------------------------------------------------
PlayerTab:CreateToggle({
    Name = "Custom JumpPower",
    CurrentValue = false,
    Callback = function(v)
        jumpOn = v
        local hum = getHumanoid()
        hum.JumpPower = v and jumpVal or 50
    end,
})
PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {0, 120},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v)
        jumpVal = v
        if jumpOn then getHumanoid().JumpPower = v end
    end,
})

-------------------------------------------------
-- INFINITE JUMP
-------------------------------------------------
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        infJumpOn = v
        if v then
            infJumpConn = UserInput.JumpRequest:Connect(function()
                getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        elseif infJumpConn then
            infJumpConn:Disconnect(); infJumpConn = nil
        end
    end,
})

-------------------------------------------------
-- NO FALL DAMAGE (anchors for 0.15 s mid-air)
-------------------------------------------------
PlayerTab:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = false,
    Callback = function(v)
        noFallOn = v
        local hum = getHumanoid()
        if v then
            noFallConn = hum.StateChanged:Connect(function(_, newState)
                if newState == Enum.HumanoidStateType.Freefall then
                    local root = hum.Parent:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Anchored = true
                        task.delay(0.15, function()
                            if root then root.Anchored = false end
                        end)
                    end
                end
            end)
        elseif noFallConn then
            noFallConn:Disconnect(); noFallConn = nil
        end
    end,
})

-------------------------------------------------
-- NOCLIP
-------------------------------------------------
PlayerTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(v)
        noclipOn = v
        if v then
            noclipConn = RunService.Stepped:Connect(function()
                for _,p in ipairs((lp.Character or {}).GetDescendants and lp.Character:GetDescendants() or {}) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end)
        elseif noclipConn then
            noclipConn:Disconnect(); noclipConn = nil
            for _,p in ipairs((lp.Character or {}).GetDescendants and lp.Character:GetDescendants() or {}) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end,
})

-------------------------------------------------
-- TELEPORT ALL UNANCHORED PARTS TO PLAYER
-------------------------------------------------
PlayerTab:CreateToggle({
    Name = "TP Unanchored Parts to Player",
    CurrentValue = false,
    Callback = function(v)
        partTPOn = v
        if v then
            partTPConn = RunService.Heartbeat:Connect(function()
                local root = (lp.Character or {}).HumanoidRootPart
                if not root then return end
                for _,p in ipairs(workspace:GetDescendants()) do
                    if p:IsA("BasePart") and not p.Anchored and not p:IsDescendantOf(lp.Character) then
                        p.CFrame = root.CFrame
                    end
                end
            end)
        elseif partTPConn then
            partTPConn:Disconnect(); partTPConn = nil
        end
    end,
})
