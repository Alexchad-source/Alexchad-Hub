--[[
    Alexchad Ui Library COMPLETE REMAKE. The old one was just a waste of space so  i deleted it.
	This is just generally better and in production and the OFFICAL ONE PLEASE ATLEAST CREDIT ME IF YOU PLAN TO edit it for yourself or else il have to add an license
	You can see the creation of things are similar to rayfield which is intended because its easy and most developers use it, espacially small ones.
	Also it take significantly longer because i decided to make it pretty readable and lots of error handling and stuff.
	KNOWN BUGS AS OFF 26th november 2025 : 1.when changing themes previous selected theme button stays highlighted but atleast in the current theme always so should be a quick fix
	2.Things getting cut off a little from the sides
	Suggestions by some people : "better tab switching animation" yeah idk really, "lucide icon soppurt for tabs" yeah im gonna idk when, "Gradient to the glassy background configurable in themes" yeah thats kinda needed?
	"More configurable settings for blurring" yeah ive been kinda annyoed having blur when gui is minimized so yeah pretty soon "KEYBIND FIX" dude idk keybinds been to annoying tho
	"Make Notifications better with animations when dissapearing and better design" offensive just offensive
]]


local AlexchadLibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Get proper GUI parent
local function GetGuiParent()
    local success, result = pcall(function()
        if gethui then
            return gethui()
        elseif syn and syn.protect_gui then
            return CoreGui
        end
        return CoreGui
    end)
    return success and result or CoreGui
end

local GuiParent = GetGuiParent()

-- Clean up ALL existing blur effects
local function CleanupAllBlur()
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") and effect.Name:find("Rayfield") then
            effect:Destroy()
        end
    end
end

-- Theme Configuration
local Themes = {
    Default = {
        Background = Color3.fromRGB(20, 20, 30),
        BackgroundTransparency = 0.15,
        Container = Color3.fromRGB(30, 30, 45),
        ContainerTransparency = 0.25,
        Element = Color3.fromRGB(40, 40, 60),
        ElementTransparency = 0.3,
        ElementHover = Color3.fromRGB(50, 50, 75),
        Accent = Color3.fromRGB(100, 120, 255),
        AccentDark = Color3.fromRGB(70, 90, 200),
        AccentGlow = Color3.fromRGB(130, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 200),
        TextMuted = Color3.fromRGB(120, 120, 150),
        Border = Color3.fromRGB(80, 80, 120),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        GradientStart = Color3.fromRGB(60, 60, 100),
        GradientEnd = Color3.fromRGB(30, 30, 50)
    },
    Dark = {
        Background = Color3.fromRGB(10, 10, 15),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(18, 18, 25),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(25, 25, 35),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(130, 100, 255),
        AccentDark = Color3.fromRGB(100, 70, 200),
        AccentGlow = Color3.fromRGB(160, 130, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(160, 160, 180),
        TextMuted = Color3.fromRGB(100, 100, 130),
        Border = Color3.fromRGB(60, 60, 90),
        BorderTransparency = 0.6,
        Success = Color3.fromRGB(80, 220, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        GradientStart = Color3.fromRGB(40, 40, 70),
        GradientEnd = Color3.fromRGB(15, 15, 25)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 250),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(250, 250, 255),
        ContainerTransparency = 0.15,
        Element = Color3.fromRGB(235, 235, 245),
        ElementTransparency = 0.2,
        ElementHover = Color3.fromRGB(225, 225, 240),
        Accent = Color3.fromRGB(80, 100, 220),
        AccentDark = Color3.fromRGB(60, 80, 180),
        AccentGlow = Color3.fromRGB(110, 130, 255),
        Text = Color3.fromRGB(30, 30, 50),
        TextDark = Color3.fromRGB(80, 80, 110),
        TextMuted = Color3.fromRGB(130, 130, 160),
        Border = Color3.fromRGB(200, 200, 220),
        BorderTransparency = 0.3,
        Success = Color3.fromRGB(60, 180, 100),
        Warning = Color3.fromRGB(230, 160, 40),
        Error = Color3.fromRGB(220, 60, 60),
        GradientStart = Color3.fromRGB(255, 255, 255),
        GradientEnd = Color3.fromRGB(230, 230, 245)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 40),
        BackgroundTransparency = 0.15,
        Container = Color3.fromRGB(20, 35, 55),
        ContainerTransparency = 0.25,
        Element = Color3.fromRGB(25, 45, 70),
        ElementTransparency = 0.3,
        ElementHover = Color3.fromRGB(35, 55, 85),
        Accent = Color3.fromRGB(60, 180, 220),
        AccentDark = Color3.fromRGB(40, 150, 190),
        AccentGlow = Color3.fromRGB(90, 210, 250),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(170, 200, 220),
        TextMuted = Color3.fromRGB(120, 150, 180),
        Border = Color3.fromRGB(60, 100, 140),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(80, 220, 150),
        Warning = Color3.fromRGB(255, 190, 80),
        Error = Color3.fromRGB(255, 100, 100),
        GradientStart = Color3.fromRGB(40, 80, 120),
        GradientEnd = Color3.fromRGB(20, 40, 60)
    },
    Midnight = {
        Background = Color3.fromRGB(8, 8, 15),
        BackgroundTransparency = 0.1,
        Container = Color3.fromRGB(12, 12, 22),
        ContainerTransparency = 0.2,
        Element = Color3.fromRGB(18, 18, 32),
        ElementTransparency = 0.25,
        ElementHover = Color3.fromRGB(28, 28, 45),
        Accent = Color3.fromRGB(180, 80, 255),
        AccentDark = Color3.fromRGB(140, 50, 200),
        AccentGlow = Color3.fromRGB(210, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 170, 200),
        TextMuted = Color3.fromRGB(120, 110, 150),
        Border = Color3.fromRGB(80, 60, 120),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(100, 255, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 80, 100),
        GradientStart = Color3.fromRGB(50, 30, 80),
        GradientEnd = Color3.fromRGB(15, 10, 25)
    },
    Emerald = {
        Background = Color3.fromRGB(15, 25, 20),
        BackgroundTransparency = 0.15,
        Container = Color3.fromRGB(20, 35, 28),
        ContainerTransparency = 0.25,
        Element = Color3.fromRGB(25, 45, 35),
        ElementTransparency = 0.3,
        ElementHover = Color3.fromRGB(35, 60, 48),
        Accent = Color3.fromRGB(50, 205, 130),
        AccentDark = Color3.fromRGB(35, 170, 100),
        AccentGlow = Color3.fromRGB(80, 235, 160),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 210, 195),
        TextMuted = Color3.fromRGB(130, 160, 145),
        Border = Color3.fromRGB(60, 120, 90),
        BorderTransparency = 0.5,
        Success = Color3.fromRGB(80, 255, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 100, 100),
        GradientStart = Color3.fromRGB(40, 100, 70),
        GradientEnd = Color3.fromRGB(20, 50, 35)
    }
}

-- Utility Functions
local Utility = {}

function Utility:Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utility:Tween(instance, properties, duration, easingStyle, easingDirection)
    if not instance then return end
    local tweenInfo = TweenInfo.new(
        duration or 0.25,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utility:Ripple(button, theme, config)
    if not config.RippleEnabled then return end
    
    local ripple = Utility:Create("Frame", {
        Name = "Ripple",
        Parent = button,
        BackgroundColor3 = theme.AccentGlow,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Position = UDim2.new(0, Mouse.X - button.AbsolutePosition.X, 0, Mouse.Y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = button.ZIndex + 5
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    
    Utility:Tween(ripple, {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1
    }, config.RippleSpeed).Completed:Connect(function()
        ripple:Destroy()
    end)
end

function Utility:MakeDraggable(frame, handle, config)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(frame, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, config.AnimationSpeed * 0.5)
        end
    end)
end

-- Configuration Manager
local ConfigManager = {}

function ConfigManager:GetSaveFolder(folderName)
    local success, result = pcall(function()
        if isfolder and writefile and readfile then
            if not isfolder(folderName) then
                makefolder(folderName)
            end
            return true
        end
        return false
    end)
    return success and result
end

function ConfigManager:Save(folderName, fileName, data)
    pcall(function()
        if writefile then
            writefile(folderName .. "/" .. fileName .. ".json", HttpService:JSONEncode(data))
        end
    end)
end

function ConfigManager:Load(folderName, fileName)
    local success, result = pcall(function()
        if readfile and isfile then
            local path = folderName .. "/" .. fileName .. ".json"
            if isfile(path) then
                return HttpService:JSONDecode(readfile(path))
            end
        end
        return nil
    end)
    return success and result or nil
end

-- Main Library
function AlexchadLibrary:CreateWindow(options)
    options = options or {}
    
    -- Cleanup
    CleanupAllBlur()
    if GuiParent:FindFirstChild("RayfieldUI") then
        GuiParent:FindFirstChild("RayfieldUI"):Destroy()
    end
    
    -- Options
    local windowName = options.Name or "Rayfield"
    local windowSubtitle = options.Subtitle or "Interface Suite"
    local windowVersion = options.Version or "v3.2"
    local loadingTitle = options.LoadingTitle or "Rayfield Interface"
    local loadingSubtitle = options.LoadingSubtitle or "Loading..."
    local themeName = options.Theme or "Default"
    local configSaving = options.ConfigurationSaving or {}
    local configEnabled = configSaving.Enabled or false
    local configFolder = configSaving.FolderName or "RayfieldConfig"
    local configFile = configSaving.FileName or "config"
    
    -- Config
    local Config = {
        AnimationSpeed = options.AnimationSpeed or 0.25,
        RippleEnabled = options.RippleEnabled ~= false,
        RippleSpeed = options.RippleSpeed or 0.4,
        CornerRadius = options.CornerRadius or 12,
        ElementCornerRadius = options.ElementCornerRadius or 10,
        BlurEnabled = options.BlurEnabled ~= false
    }
    
    -- Window State
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Theme = Themes[themeName] or Themes.Default,
        ThemeName = themeName,
        Config = Config,
        Minimized = false,
        Elements = {},
        ConfigData = {},
        Connections = {},
        ElementRefs = {} -- Store references for theme updates
    }
    
    -- Load saved config
    if configEnabled then
        ConfigManager:GetSaveFolder(configFolder)
        local savedData = ConfigManager:Load(configFolder, configFile)
        if savedData then
            Window.ConfigData = savedData
            if savedData.Theme and Themes[savedData.Theme] then
                Window.Theme = Themes[savedData.Theme]
                Window.ThemeName = savedData.Theme
            end
        end
    end
    
    local theme = Window.Theme
    
    -- ScreenGui
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "RayfieldUI",
        Parent = GuiParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    
    -- Blur
    local Blur
    if Config.BlurEnabled then
        Blur = Utility:Create("BlurEffect", {
            Name = "RayfieldBlur",
            Parent = Lighting,
            Size = 0
        })
    end
    
    -- Loading Screen
    local LoadingFrame = Utility:Create("Frame", {
        Name = "LoadingFrame",
        Parent = ScreenGui,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = theme.BackgroundTransparency,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 320, 0, 160),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius + 4) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1.5 }),
        Utility:Create("UIGradient", {
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
            Rotation = 135,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 0.3) })
        })
    })
    
    local LoadingTitle = Utility:Create("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = loadingTitle,
        TextColor3 = theme.Text,
        TextSize = 22,
        TextTransparency = 1
    })
    
    local LoadingSubtitle = Utility:Create("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 65),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = loadingSubtitle,
        TextColor3 = theme.TextDark,
        TextSize = 14,
        TextTransparency = 1
    })
    
    local LoadingBarBg = Utility:Create("Frame", {
        Parent = LoadingFrame,
        BackgroundColor3 = theme.Element,
        BackgroundTransparency = theme.ElementTransparency,
        Position = UDim2.new(0.1, 0, 0, 110),
        Size = UDim2.new(0.8, 0, 0, 8)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
    
    local LoadingBarFill = Utility:Create("Frame", {
        Parent = LoadingBarBg,
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new(0, 0, 1, 0)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
    })
    
    -- Animate loading
    if Blur then Utility:Tween(Blur, {Size = 10}, Config.AnimationSpeed) end
    Utility:Tween(LoadingTitle, {TextTransparency = 0}, Config.AnimationSpeed)
    task.wait(Config.AnimationSpeed * 0.5)
    Utility:Tween(LoadingSubtitle, {TextTransparency = 0}, Config.AnimationSpeed)
    Utility:Tween(LoadingBarFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
    
    task.wait(1.8)
    
    -- Fade out loading
    Utility:Tween(LoadingFrame, {BackgroundTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingTitle, {TextTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingSubtitle, {TextTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingBarBg, {BackgroundTransparency = 1}, Config.AnimationSpeed)
    Utility:Tween(LoadingBarFill, {BackgroundTransparency = 1}, Config.AnimationSpeed)
    for _, child in pairs(LoadingFrame:GetDescendants()) do
        if child:IsA("UIStroke") then
            Utility:Tween(child, {Transparency = 1}, Config.AnimationSpeed)
        end
    end
    task.wait(Config.AnimationSpeed + 0.1)
    LoadingFrame:Destroy()
    
    -- Main Container
    local MainContainer = Utility:Create("Frame", {
        Name = "MainContainer",
        Parent = ScreenGui,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = theme.BackgroundTransparency,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius + 6) }),
        Utility:Create("UIStroke", { Name = "MainStroke", Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1.5 }),
        Utility:Create("UIGradient", {
            Name = "MainGradient",
            Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
            Rotation = 135,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 0.3) })
        })
    })
    
    -- Glow
    local Glow = Utility:Create("ImageLabel", {
        Name = "Glow",
        Parent = MainContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 50, 1, 50),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://5028857084",
        ImageColor3 = theme.Accent,
        ImageTransparency = 0.85,
        ZIndex = 0,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276)
    })
    
    -- Animate open
    Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 480)}, Config.AnimationSpeed * 1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.wait(Config.AnimationSpeed * 0.8)
    
    -- Header
    local Header = Utility:Create("Frame", {
        Name = "Header",
        Parent = MainContainer,
        BackgroundColor3 = theme.Container,
        BackgroundTransparency = theme.ContainerTransparency + 0.1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 0, 55)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
    })
    
    -- Title
    local TitleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(0.6, 0, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = windowName,
        TextColor3 = theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local SubtitleLabel = Utility:Create("TextLabel", {
        Name = "Subtitle",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(0.6, 0, 0, 16),
        Font = Enum.Font.Gotham,
        Text = windowSubtitle .. " | " .. windowVersion,
        TextColor3 = theme.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Controls (Minimize then Close, left to right)
    local ControlsContainer = Utility:Create("Frame", {
        Name = "Controls",
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -95, 0, 0),
        Size = UDim2.new(0, 80, 1, 0)
    }, {
        Utility:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        })
    })
    
    local function CreateControlButton(name, text, hoverColor, callback)
        local btn = Utility:Create("TextButton", {
            Name = name,
            Parent = ControlsContainer,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = theme.ElementTransparency,
            Size = UDim2.new(0, 34, 0, 34),
            Font = Enum.Font.GothamBold,
            Text = text,
            TextColor3 = theme.TextDark,
            TextSize = 16,
            AutoButtonColor = false,
            LayoutOrder = name == "Minimize" and 1 or 2
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
            Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
        })
        
        btn.MouseEnter:Connect(function()
            Utility:Tween(btn, {BackgroundColor3 = hoverColor, BackgroundTransparency = 0, TextColor3 = theme.Text}, Config.AnimationSpeed * 0.5)
        end)
        btn.MouseLeave:Connect(function()
            Utility:Tween(btn, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency, TextColor3 = theme.TextDark}, Config.AnimationSpeed * 0.5)
        end)
        btn.MouseButton1Click:Connect(function()
            Utility:Ripple(btn, theme, Config)
            callback()
        end)
        
        return btn
    end
    
    -- Close button (using simple X)
    CreateControlButton("Close", "X", theme.Error, function()
        for _, conn in pairs(Window.Connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        if Blur then Utility:Tween(Blur, {Size = 0}, Config.AnimationSpeed) end
        Utility:Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(Config.AnimationSpeed + 0.1)
        CleanupAllBlur()
        ScreenGui:Destroy()
    end)
    
    -- Minimize button
    CreateControlButton("Minimize", "-", theme.Warning, function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 85)}, Config.AnimationSpeed)
            if Blur then Utility:Tween(Blur, {Size = 5}, Config.AnimationSpeed) end
        else
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 480)}, Config.AnimationSpeed)
            if Blur then Utility:Tween(Blur, {Size = 10}, Config.AnimationSpeed) end
        end
    end)
    
    Utility:MakeDraggable(MainContainer, Header, Config)
    
    -- Content Area
    local ContentArea = Utility:Create("Frame", {
        Name = "ContentArea",
        Parent = MainContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 80),
        Size = UDim2.new(1, -30, 1, -95)
    })
    
    -- Tab Container
    local TabContainer = Utility:Create("Frame", {
        Name = "TabContainer",
        Parent = ContentArea,
        BackgroundColor3 = theme.Container,
        BackgroundTransparency = theme.ContainerTransparency,
        Size = UDim2.new(0, 150, 1, 0)
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
    })
    
    local TabList = Utility:Create("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true
    }, {
        Utility:Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
    })
    
    -- Main Content
    local MainContent = Utility:Create("Frame", {
        Name = "MainContent",
        Parent = ContentArea,
        BackgroundColor3 = theme.Container,
        BackgroundTransparency = theme.ContainerTransparency,
        Position = UDim2.new(0, 160, 0, 0),
        Size = UDim2.new(1, -160, 1, 0),
        ClipsDescendants = true
    }, {
        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
        Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
    })
    
    -- Save Config
    local function SaveConfig()
        if not configEnabled then return end
        local data = { Theme = Window.ThemeName, Elements = {} }
        for id, el in pairs(Window.Elements) do
            if el.Value ~= nil then data.Elements[id] = el.Value end
        end
        Window.ConfigData = data
        ConfigManager:Save(configFolder, configFile, data)
    end
    
    -- Apply Theme (COMPLETE FIX)
    local function ApplyTheme(newThemeName, animate)
        local newTheme = Themes[newThemeName]
        if not newTheme then return end
        
        Window.Theme = newTheme
        Window.ThemeName = newThemeName
        theme = newTheme
        
        local dur = animate and Config.AnimationSpeed or 0
        
        -- Main Container
        Utility:Tween(MainContainer, {BackgroundColor3 = newTheme.Background, BackgroundTransparency = newTheme.BackgroundTransparency}, dur)
        local mainStroke = MainContainer:FindFirstChild("MainStroke")
        if mainStroke then Utility:Tween(mainStroke, {Color = newTheme.Border, Transparency = newTheme.BorderTransparency}, dur) end
        local mainGrad = MainContainer:FindFirstChild("MainGradient")
        if mainGrad then
            mainGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, newTheme.GradientStart), ColorSequenceKeypoint.new(1, newTheme.GradientEnd) })
        end
        Utility:Tween(Glow, {ImageColor3 = newTheme.Accent}, dur)
        
        -- Header
        Utility:Tween(Header, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency + 0.1}, dur)
        Utility:Tween(TitleLabel, {TextColor3 = newTheme.Text}, dur)
        Utility:Tween(SubtitleLabel, {TextColor3 = newTheme.TextMuted}, dur)
        
        -- Containers
        Utility:Tween(TabContainer, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency}, dur)
        Utility:Tween(MainContent, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency}, dur)
        
        -- Tab buttons
        for _, tab in pairs(Window.Tabs) do
            local isCurrent = tab == Window.CurrentTab
            Utility:Tween(tab.Button, {
                BackgroundColor3 = isCurrent and newTheme.Accent or newTheme.Element,
                BackgroundTransparency = isCurrent and 0 or newTheme.ElementTransparency
            }, dur)
            Utility:Tween(tab.Label, {TextColor3 = isCurrent and newTheme.Text or newTheme.TextDark}, dur)
            Utility:Tween(tab.Icon, {TextColor3 = isCurrent and newTheme.Text or newTheme.TextDark}, dur)
            Utility:Tween(tab.Indicator, {BackgroundColor3 = newTheme.Accent}, dur)
            
            -- Update strokes
            local btnStroke = tab.Button:FindFirstChildOfClass("UIStroke")
            if btnStroke then Utility:Tween(btnStroke, {Color = newTheme.Border, Transparency = newTheme.BorderTransparency + 0.3}, dur) end
        end
        
        -- Update all registered elements
        for _, ref in pairs(Window.ElementRefs) do
            if ref.Type == "Toggle" then
                local isOn = ref.Element.Value
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Switch, {BackgroundColor3 = isOn and newTheme.Accent or newTheme.Element, BackgroundTransparency = isOn and 0 or newTheme.ElementTransparency - 0.1}, dur)
                Utility:Tween(ref.Circle, {BackgroundColor3 = newTheme.Text}, dur)
                local switchStroke = ref.Switch:FindFirstChild("SwitchStroke")
                if switchStroke then Utility:Tween(switchStroke, {Color = isOn and newTheme.Accent or newTheme.Border}, dur) end
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Slider" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.ValueLabel, {TextColor3 = newTheme.Accent}, dur)
                Utility:Tween(ref.BarBg, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency - 0.1}, dur)
                Utility:Tween(ref.Fill, {BackgroundColor3 = newTheme.Accent}, dur)
                Utility:Tween(ref.Knob, {BackgroundColor3 = newTheme.Text}, dur)
                local knobStroke = ref.Knob:FindFirstChildOfClass("UIStroke")
                if knobStroke then Utility:Tween(knobStroke, {Color = newTheme.Accent}, dur) end
                local fillGrad = ref.Fill:FindFirstChildOfClass("UIGradient")
                if fillGrad then
                    fillGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, newTheme.Accent), ColorSequenceKeypoint.new(1, newTheme.AccentGlow) })
                end
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Button" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Icon, {TextColor3 = newTheme.Accent}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Dropdown" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Selected, {TextColor3 = newTheme.TextDark}, dur)
                Utility:Tween(ref.Arrow, {TextColor3 = newTheme.TextDark}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                -- Update options
                for _, opt in pairs(ref.OptionsContainer:GetChildren()) do
				    if opt:IsA("TextButton") then
				        local dropdownValue = ref.Element.Value
				        local isSelected = false
				        
				        -- Check if this option is selected
				        if type(dropdownValue) == "table" then
				            -- Multi-select dropdown
				            isSelected = table.find(dropdownValue, opt.Name) ~= nil
				        else
				            -- Single-select dropdown
				            isSelected = dropdownValue == opt.Name
				        end
				        
				        Utility:Tween(opt, {
				            BackgroundColor3 = isSelected and newTheme.Accent or newTheme.Container,
				            BackgroundTransparency = isSelected and 0 or newTheme.ContainerTransparency,
				            TextColor3 = isSelected and newTheme.Text or newTheme.TextDark
				        }, dur)
				    end
				end
                
            elseif ref.Type == "Input" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.BoxContainer, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency}, dur)
                Utility:Tween(ref.TextBox, {TextColor3 = newTheme.Text, PlaceholderColor3 = newTheme.TextMuted}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                local boxStroke = ref.BoxContainer:FindFirstChild("BoxStroke")
                if boxStroke then Utility:Tween(boxStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Keybind" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.KeyButton, {BackgroundColor3 = newTheme.Container, BackgroundTransparency = newTheme.ContainerTransparency, TextColor3 = newTheme.TextDark}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "ColorPicker" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Label, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.RGBLabel, {TextColor3 = newTheme.TextDark}, dur)
                local displayStroke = ref.Display:FindFirstChildOfClass("UIStroke")
                if displayStroke then Utility:Tween(displayStroke, {Color = newTheme.Border}, dur) end
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
                
            elseif ref.Type == "Label" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency + 0.1}, dur)
                Utility:Tween(ref.Text, {TextColor3 = newTheme.TextDark}, dur)
                
            elseif ref.Type == "Paragraph" then
                Utility:Tween(ref.Frame, {BackgroundColor3 = newTheme.Element, BackgroundTransparency = newTheme.ElementTransparency}, dur)
                Utility:Tween(ref.Title, {TextColor3 = newTheme.Text}, dur)
                Utility:Tween(ref.Content, {TextColor3 = newTheme.TextDark}, dur)
                local frameStroke = ref.Frame:FindFirstChildOfClass("UIStroke")
                if frameStroke then Utility:Tween(frameStroke, {Color = newTheme.Border}, dur) end
            end
        end
        
        -- Update scrollbars
        TabList.ScrollBarImageColor3 = newTheme.Accent
        for _, tab in pairs(Window.Tabs) do
            tab.Content.ScrollBarImageColor3 = newTheme.Accent
        end
        
        SaveConfig()
    end
    
    Window.ApplyTheme = ApplyTheme
    
    -- Notification System (IMPROVED)
    function Window:Notify(notifyOptions)
        notifyOptions = notifyOptions or {}
        local title = notifyOptions.Title or "Notification"
        local content = notifyOptions.Content or ""
        local duration = notifyOptions.Duration or 5
        local notifyType = notifyOptions.Type or "Info"
        local showButtons = notifyOptions.Buttons ~= false
        
        local typeColors = {
            Info = theme.Accent,
            Success = theme.Success,
            Warning = theme.Warning,
            Error = theme.Error
        }
        local typeColor = typeColors[notifyType] or theme.Accent
        
        local NotifHolder = ScreenGui:FindFirstChild("NotificationHolder")
        if not NotifHolder then
            NotifHolder = Utility:Create("Frame", {
                Name = "NotificationHolder",
                Parent = ScreenGui,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, -20),
                Size = UDim2.new(0, 340, 1, -40),
                AnchorPoint = Vector2.new(1, 1)
            }, {
                Utility:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                    Padding = UDim.new(0, 12)
                })
            })
        end
        
        local NotifFrame = Utility:Create("Frame", {
            Name = "Notification",
            Parent = NotifHolder,
            BackgroundColor3 = theme.Background,
            BackgroundTransparency = theme.BackgroundTransparency - 0.05,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.new(1, 50, 0, 0),
            ClipsDescendants = true
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius) }),
            Utility:Create("UIStroke", { Color = typeColor, Transparency = 0.3, Thickness = 1.5 }),
            Utility:Create("UIGradient", {
                Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
                Rotation = 135,
                Transparency = NumberSequence.new(0.2)
            })
        })
        
        -- Accent bar on left
        local AccentBar = Utility:Create("Frame", {
            Name = "AccentBar",
            Parent = NotifFrame,
            BackgroundColor3 = typeColor,
            Size = UDim2.new(0, 4, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, 4) })
        })
        
        -- Content container
        local ContentContainer = Utility:Create("Frame", {
            Name = "ContentContainer",
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 16, 0, 0),
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        }, {
            Utility:Create("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingRight = UDim.new(0, 10) }),
            Utility:Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })
        })
        
        -- Header with icon and title
        local HeaderFrame = Utility:Create("Frame", {
            Name = "Header",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24)
        })
        
        local TypeIcon = Utility:Create("TextLabel", {
            Name = "Icon",
            Parent = HeaderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 24, 0, 24),
            Font = Enum.Font.GothamBold,
            Text = notifyType == "Success" and "✓" or notifyType == "Warning" and "!" or notifyType == "Error" and "✗" or "i",
            TextColor3 = typeColor,
            TextSize = 16
        })
        
        local NotifTitle = Utility:Create("TextLabel", {
            Name = "Title",
            Parent = HeaderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(1, -70, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        
        -- Close button
        local CloseBtn = Utility:Create("TextButton", {
            Name = "Close",
            Parent = HeaderFrame,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = 0.5,
            Position = UDim2.new(1, -24, 0, 0),
            Size = UDim2.new(0, 24, 0, 24),
            Font = Enum.Font.GothamBold,
            Text = "X",
            TextColor3 = theme.TextDark,
            TextSize = 12,
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, 6) })
        })
        
        -- Content text
        local NotifContent = Utility:Create("TextLabel", {
            Name = "Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        -- Progress bar
        local ProgressContainer = Utility:Create("Frame", {
            Name = "ProgressContainer",
            Parent = ContentContainer,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 4)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        
        local ProgressFill = Utility:Create("Frame", {
            Name = "Fill",
            Parent = ProgressContainer,
            BackgroundColor3 = typeColor,
            Size = UDim2.new(1, 0, 1, 0)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        
        -- Buttons row (optional)
        if showButtons then
            local ButtonsRow = Utility:Create("Frame", {
                Name = "Buttons",
                Parent = ContentContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32)
            }, {
                Utility:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8)
                })
            })
            
            local OkButton = Utility:Create("TextButton", {
                Name = "OK",
                Parent = ButtonsRow,
                BackgroundColor3 = typeColor,
                Size = UDim2.new(0, 70, 0, 28),
                Font = Enum.Font.GothamBold,
                Text = "OK",
                TextColor3 = theme.Text,
                TextSize = 12,
                AutoButtonColor = false
            }, {
                Utility:Create("UICorner", { CornerRadius = UDim.new(0, 6) })
            })
            
            OkButton.MouseEnter:Connect(function()
                Utility:Tween(OkButton, {BackgroundColor3 = theme.AccentDark}, Config.AnimationSpeed * 0.5)
            end)
            OkButton.MouseLeave:Connect(function()
                Utility:Tween(OkButton, {BackgroundColor3 = typeColor}, Config.AnimationSpeed * 0.5)
            end)
        end
        
        -- Animation
        Utility:Tween(NotifFrame, {Position = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Utility:Tween(ProgressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
        
        local function CloseNotification()
            Utility:Tween(NotifFrame, {Position = UDim2.new(1, 50, 0, 0)}, Config.AnimationSpeed)
            task.wait(Config.AnimationSpeed + 0.1)
            if NotifFrame then NotifFrame:Destroy() end
        end
        
        CloseBtn.MouseButton1Click:Connect(CloseNotification)
        if showButtons then
            local okBtn = ContentContainer:FindFirstChild("Buttons") and ContentContainer.Buttons:FindFirstChild("OK")
            if okBtn then okBtn.MouseButton1Click:Connect(CloseNotification) end
        end
        
        task.delay(duration, function()
            if NotifFrame and NotifFrame.Parent then
                CloseNotification()
            end
        end)
    end
    
    -- Create Tab
    function Window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or "📁"
        
        local Tab = { Name = tabName, Sections = {} }
        
        local TabButton = Utility:Create("TextButton", {
            Name = tabName,
            Parent = TabList,
            BackgroundColor3 = theme.Element,
            BackgroundTransparency = theme.ElementTransparency,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
            Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.3, Thickness = 1 })
        })
        
        local TabIcon = Utility:Create("TextLabel", {
            Name = "Icon",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0, 25, 1, 0),
            Font = Enum.Font.Gotham,
            Text = tabIcon,
            TextColor3 = theme.TextDark,
            TextSize = 16
        })
        
        local TabLabel = Utility:Create("TextLabel", {
            Name = "Label",
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 38, 0, 0),
            Size = UDim2.new(1, -48, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = tabName,
            TextColor3 = theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        
        local TabIndicator = Utility:Create("Frame", {
            Name = "Indicator",
            Parent = TabButton,
            BackgroundColor3 = theme.Accent,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -4, 0.2, 0),
            Size = UDim2.new(0, 3, 0.6, 0)
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        
        local TabContent = Utility:Create("ScrollingFrame", {
		    Name = tabName .. "Content",
		    Parent = MainContent,
		    BackgroundTransparency = 1,
		    Position = UDim2.new(0, 18, 0, 15),
		    Size = UDim2.new(1, -36, 1, -30),  -- More horizontal padding
		    ScrollBarThickness = 4,
		    ScrollBarImageColor3 = theme.Accent,
		    ScrollBarImageTransparency = 0.3,
		    CanvasSize = UDim2.new(0, 0, 0, 0),
		    AutomaticCanvasSize = Enum.AutomaticSize.Y,
		    Visible = false,
		    ClipsDescendants = true
		}, {
		    Utility:Create("UIListLayout", { 
		        SortOrder = Enum.SortOrder.LayoutOrder, 
		        Padding = UDim.new(0, 10) 
		    }),
		    -- ADD this padding to prevent content touching edges
		    Utility:Create("UIPadding", {
		        PaddingLeft = UDim.new(0, 2),
		        PaddingRight = UDim.new(0, 6)  -- Extra for scrollbar
		    })
		})
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Icon = TabIcon
        Tab.Label = TabLabel
        Tab.Indicator = TabIndicator
        
        local function GetTabIndex(t)
            for i, tab in ipairs(Window.Tabs) do
                if tab == t then return i end
            end
            return 0
        end
        
        -- Tab selection with VERTICAL slide animation
        local function SelectTab()
            if Window.CurrentTab == Tab then return end
            
            local oldTab = Window.CurrentTab
            local oldIdx = oldTab and GetTabIndex(oldTab) or 0
            local newIdx = GetTabIndex(Tab)
            local goingDown = newIdx > oldIdx
            
            -- Deselect old tab
            if oldTab then
                Utility:Tween(oldTab.Button, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed)
                Utility:Tween(oldTab.Label, {TextColor3 = theme.TextDark}, Config.AnimationSpeed)
                Utility:Tween(oldTab.Icon, {TextColor3 = theme.TextDark}, Config.AnimationSpeed)
                Utility:Tween(oldTab.Indicator, {BackgroundTransparency = 1}, Config.AnimationSpeed)
                
                -- Slide out old content (opposite direction)
                local slideOutY = goingDown and -60 or 60
                Utility:Tween(oldTab.Content, {Position = UDim2.new(0, 15, 0, slideOutY)}, Config.AnimationSpeed * 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                
                task.delay(Config.AnimationSpeed * 0.5, function()
                    if oldTab.Content then
                        oldTab.Content.Visible = false
                        oldTab.Content.Position = UDim2.new(0, 15, 0, 15)
                    end
                end)
            end
            
            -- Select new tab
            Window.CurrentTab = Tab
            Utility:Tween(TabButton, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0}, Config.AnimationSpeed)
            Utility:Tween(TabLabel, {TextColor3 = theme.Text}, Config.AnimationSpeed)
            Utility:Tween(TabIcon, {TextColor3 = theme.Text}, Config.AnimationSpeed)
            Utility:Tween(TabIndicator, {BackgroundTransparency = 0}, Config.AnimationSpeed)
            
            -- Slide in new content
            local slideInY = goingDown and 60 or -60
            TabContent.Position = UDim2.new(0, 15, 0, slideInY)
            TabContent.Visible = true
            TabContent.CanvasPosition = Vector2.new(0, 0)
            
            Utility:Tween(TabContent, {Position = UDim2.new(0, 15, 0, 15)}, Config.AnimationSpeed * 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Utility:Ripple(TabButton, theme, Config)
        end
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Utility:Tween(TabButton, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed * 0.5)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Utility:Tween(TabButton, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed * 0.5)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            Window.CurrentTab = Tab
            TabButton.BackgroundColor3 = theme.Accent
            TabButton.BackgroundTransparency = 0
            TabLabel.TextColor3 = theme.Text
            TabIcon.TextColor3 = theme.Text
            TabIndicator.BackgroundTransparency = 0
            TabContent.Visible = true
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Create Section
        function Tab:CreateSection(sectionName)
            local Section = { Name = sectionName }
            
            local SectionFrame = Utility:Create("Frame", {
                Name = sectionName or "Section",
                Parent = TabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Utility:Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) })
            })
            
            if sectionName then
                local SectionHeader = Utility:Create("Frame", {
                    Parent = SectionFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28)
                })
                
                Utility:Create("TextLabel", {
                    Parent = SectionHeader,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0, 0),
                    Size = UDim2.new(1, -10, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = sectionName:upper(),
                    TextColor3 = theme.TextMuted,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                Utility:Create("Frame", {
                    Name = "Line",
                    Parent = SectionHeader,
                    BackgroundColor3 = theme.Border,
                    BackgroundTransparency = theme.BorderTransparency,
                    Position = UDim2.new(0, 0, 1, -1),
                    Size = UDim2.new(1, 0, 0, 1)
                })
            end
            
            table.insert(Tab.Sections, Section)
            
            -- Button
            function Section:CreateButton(opts)
                opts = opts or {}
                local name = opts.Name or "Button"
                local callback = opts.Callback or function() end
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Button",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Icon = Utility:Create("TextLabel", {
                    Name = "Icon",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -40, 0, 0),
                    Size = UDim2.new(0, 30, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "→",
                    TextColor3 = theme.Accent,
                    TextSize = 16
                })
                
                local ClickArea = Utility:Create("TextButton", {
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                table.insert(Window.ElementRefs, { Type = "Button", Frame = Frame, Label = Label, Icon = Icon })
                
                ClickArea.MouseEnter:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed * 0.5)
                    Utility:Tween(Icon, {Position = UDim2.new(1, -35, 0, 0)}, Config.AnimationSpeed * 0.5)
                end)
                
                ClickArea.MouseLeave:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed * 0.5)
                    Utility:Tween(Icon, {Position = UDim2.new(1, -40, 0, 0)}, Config.AnimationSpeed * 0.5)
                end)
                
                ClickArea.MouseButton1Click:Connect(function()
                    Utility:Ripple(ClickArea, theme, Config)
                    Utility:Tween(Frame, {Size = UDim2.new(1, -4, 0, 40)}, Config.AnimationSpeed * 0.3)
                    task.wait(Config.AnimationSpeed * 0.3)
                    Utility:Tween(Frame, {Size = UDim2.new(1, 0, 0, 42)}, Config.AnimationSpeed * 0.3)
                    callback()
                end)
                
                return { SetText = function(_, t) Label.Text = t end }
            end
            
            -- Toggle
            function Section:CreateToggle(opts)
                opts = opts or {}
                local name = opts.Name or "Toggle"
                local id = opts.Flag or name
                local default = opts.CurrentValue or false
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Toggle = { Value = default }
                Window.Elements[id] = Toggle
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Toggle",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -70, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Switch = Utility:Create("Frame", {
                    Name = "Switch",
                    Parent = Frame,
                    BackgroundColor3 = default and theme.Accent or theme.Element,
                    BackgroundTransparency = default and 0 or theme.ElementTransparency - 0.1,
                    Position = UDim2.new(1, -55, 0.5, 0),
                    Size = UDim2.new(0, 44, 0, 24),
                    AnchorPoint = Vector2.new(0, 0.5)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create("UIStroke", { Name = "SwitchStroke", Color = default and theme.Accent or theme.Border, Transparency = default and 0.3 or theme.BorderTransparency, Thickness = 1 })
                })
                
                local Circle = Utility:Create("Frame", {
                    Name = "Circle",
                    Parent = Switch,
                    BackgroundColor3 = theme.Text,
                    Position = default and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    AnchorPoint = Vector2.new(0, 0.5)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                
                local ClickArea = Utility:Create("TextButton", {
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                table.insert(Window.ElementRefs, { Type = "Toggle", Element = Toggle, Frame = Frame, Label = Label, Switch = Switch, Circle = Circle })
                
                local function Update(anim)
                    local dur = anim and Config.AnimationSpeed or 0
                    local t = Window.Theme
                    if Toggle.Value then
                        Utility:Tween(Switch, {BackgroundColor3 = t.Accent, BackgroundTransparency = 0}, dur)
                        Utility:Tween(Circle, {Position = UDim2.new(1, -22, 0.5, 0)}, dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Utility:Tween(Switch:FindFirstChild("SwitchStroke"), {Color = t.Accent, Transparency = 0.3}, dur)
                    else
                        Utility:Tween(Switch, {BackgroundColor3 = t.Element, BackgroundTransparency = t.ElementTransparency - 0.1}, dur)
                        Utility:Tween(Circle, {Position = UDim2.new(0, 4, 0.5, 0)}, dur, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Utility:Tween(Switch:FindFirstChild("SwitchStroke"), {Color = t.Border, Transparency = t.BorderTransparency}, dur)
                    end
                end
                
                ClickArea.MouseEnter:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed * 0.5)
                end)
                
                ClickArea.MouseLeave:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed * 0.5)
                end)
                
                ClickArea.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    Update(true)
                    Utility:Ripple(ClickArea, theme, Config)
                    SaveConfig()
                    callback(Toggle.Value)
                end)
                
                function Toggle:Set(v, skip)
                    Toggle.Value = v
                    Update(true)
                    SaveConfig()
                    if not skip then callback(v) end
                end
                
                if default then callback(default) end
                
                return Toggle
            end
            
            -- Slider
            function Section:CreateSlider(opts)
                opts = opts or {}
                local name = opts.Name or "Slider"
                local id = opts.Flag or name
                local min = opts.Range and opts.Range[1] or 0
                                local max = opts.Range and opts.Range[2] or 100
                local increment = opts.Increment or 1
                local default = opts.CurrentValue or min
                local suffix = opts.Suffix or ""
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Slider = { Value = default }
                Window.Elements[id] = Slider
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Slider",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 58)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 8),
                    Size = UDim2.new(0.6, 0, 0, 18),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ValueLabel = Utility:Create("TextLabel", {
                    Name = "Value",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.6, 0, 0, 8),
                    Size = UDim2.new(0.4, -15, 0, 18),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default) .. suffix,
                    TextColor3 = theme.Accent,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                
                local BarBg = Utility:Create("Frame", {
                    Name = "BarBg",
                    Parent = Frame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency - 0.1,
                    Position = UDim2.new(0, 15, 0, 36),
                    Size = UDim2.new(1, -30, 0, 10)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                
                local fillPct = (default - min) / (max - min)
                
                local Fill = Utility:Create("Frame", {
                    Name = "Fill",
                    Parent = BarBg,
                    BackgroundColor3 = theme.Accent,
                    Size = UDim2.new(fillPct, 0, 1, 0)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create("UIGradient", {
                        Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.Accent), ColorSequenceKeypoint.new(1, theme.AccentGlow) }),
                        Rotation = 0
                    })
                })
                
                local Knob = Utility:Create("Frame", {
                    Name = "Knob",
                    Parent = BarBg,
                    BackgroundColor3 = theme.Text,
                    Position = UDim2.new(fillPct, 0, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 5
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create("UIStroke", { Color = theme.Accent, Thickness = 2 })
                })
                
                local Input = Utility:Create("TextButton", {
                    Parent = BarBg,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 20),
                    Position = UDim2.new(0, 0, 0, -10),
                    Text = "",
                    AutoButtonColor = false
                })
                
                table.insert(Window.ElementRefs, { Type = "Slider", Element = Slider, Frame = Frame, Label = Label, ValueLabel = ValueLabel, BarBg = BarBg, Fill = Fill, Knob = Knob })
                
                local dragging = false
                
                local function UpdateSlider(input, anim)
                    local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
                    local value = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    Slider.Value = value
                    local fillPos = (value - min) / (max - min)
                    local dur = anim and Config.AnimationSpeed * 0.5 or 0
                    
                    ValueLabel.Text = tostring(value) .. suffix
                    Utility:Tween(Fill, {Size = UDim2.new(fillPos, 0, 1, 0)}, dur)
                    Utility:Tween(Knob, {Position = UDim2.new(fillPos, 0, 0.5, 0)}, dur)
                    
                    SaveConfig()
                    callback(value)
                end
                
                Input.MouseButton1Down:Connect(function()
                    dragging = true
                    Utility:Tween(Knob, {Size = UDim2.new(0, 22, 0, 22)}, Config.AnimationSpeed * 0.3)
                end)
                
                local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                        dragging = false
                        Utility:Tween(Knob, {Size = UDim2.new(0, 18, 0, 18)}, Config.AnimationSpeed * 0.3)
                    end
                end)
                table.insert(Window.Connections, inputEndedConn)
                
                local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input, false)
                    end
                end)
                table.insert(Window.Connections, inputChangedConn)
                
                Input.MouseButton1Click:Connect(function()
                    UpdateSlider({Position = Vector3.new(Mouse.X, Mouse.Y, 0)}, true)
                    Utility:Ripple(Input, theme, Config)
                end)
                
                function Slider:Set(v, skip)
                    v = math.clamp(v, min, max)
                    Slider.Value = v
                    local fillPos = (v - min) / (max - min)
                    ValueLabel.Text = tostring(v) .. suffix
                    Fill.Size = UDim2.new(fillPos, 0, 1, 0)
                    Knob.Position = UDim2.new(fillPos, 0, 0.5, 0)
                    SaveConfig()
                    if not skip then callback(v) end
                end
                
                callback(default)
                return Slider
            end
            
            -- Dropdown
            function Section:CreateDropdown(opts)
                opts = opts or {}
                local name = opts.Name or "Dropdown"
                local id = opts.Flag or name
                local options = opts.Options or {}
                local default = opts.CurrentOption or (options[1] or "")
                local multiSelect = opts.MultiSelect or false
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Dropdown = {
                    Value = multiSelect and (type(default) == "table" and default or {default}) or default,
                    Open = false,
                    Options = options
                }
                Window.Elements[id] = Dropdown
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Dropdown",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42),
                    ClipsDescendants = true
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Header = Utility:Create("TextButton", {
                    Name = "Header",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 42),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.5, -15, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local function GetDisplayText()
                    if multiSelect then
                        if #Dropdown.Value == 0 then return "None"
                        elseif #Dropdown.Value == 1 then return Dropdown.Value[1]
                        else return #Dropdown.Value .. " selected" end
                    else
                        return Dropdown.Value or "Select..."
                    end
                end
                
                local Selected = Utility:Create("TextLabel", {
                    Name = "Selected",
                    Parent = Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, -45, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = GetDisplayText(),
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local Arrow = Utility:Create("TextLabel", {
                    Name = "Arrow",
                    Parent = Header,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -35, 0, 0),
                    Size = UDim2.new(0, 25, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "v",
                    TextColor3 = theme.TextDark,
                    TextSize = 12,
                    Rotation = 0
                })
                
                local OptionsContainer = Utility:Create("Frame", {
                    Name = "Options",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 48),
                    Size = UDim2.new(1, -16, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Utility:Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })
                })
                
                table.insert(Window.ElementRefs, { Type = "Dropdown", Element = Dropdown, Frame = Frame, Label = Label, Selected = Selected, Arrow = Arrow, OptionsContainer = OptionsContainer })
                
                local function CreateOption(optName)
                    local isSelected = multiSelect and table.find(Dropdown.Value, optName) or Dropdown.Value == optName
                    
                    local OptBtn = Utility:Create("TextButton", {
                        Name = optName,
                        Parent = OptionsContainer,
                        BackgroundColor3 = isSelected and theme.Accent or theme.Container,
                        BackgroundTransparency = isSelected and 0 or theme.ContainerTransparency,
                        Size = UDim2.new(1, 0, 0, 32),
                        Font = Enum.Font.Gotham,
                        Text = optName,
                        TextColor3 = isSelected and theme.Text or theme.TextDark,
                        TextSize = 13,
                        AutoButtonColor = false
                    }, {
                        Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) })
                    })
                    
                    OptBtn.MouseEnter:Connect(function()
                        local isSel = multiSelect and table.find(Dropdown.Value, optName) or Dropdown.Value == optName
                        if not isSel then
                            Utility:Tween(OptBtn, {BackgroundColor3 = theme.AccentDark, BackgroundTransparency = 0.5, TextColor3 = theme.Text}, Config.AnimationSpeed * 0.5)
                        end
                    end)
                    
                    OptBtn.MouseLeave:Connect(function()
                        local isSel = multiSelect and table.find(Dropdown.Value, optName) or Dropdown.Value == optName
                        local t = Window.Theme
                        Utility:Tween(OptBtn, {
                            BackgroundColor3 = isSel and t.Accent or t.Container,
                            BackgroundTransparency = isSel and 0 or t.ContainerTransparency,
                            TextColor3 = isSel and t.Text or t.TextDark
                        }, Config.AnimationSpeed * 0.5)
                    end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        Utility:Ripple(OptBtn, theme, Config)
                        local t = Window.Theme
                        
                        if multiSelect then
                            local idx = table.find(Dropdown.Value, optName)
                            if idx then
                                table.remove(Dropdown.Value, idx)
                                Utility:Tween(OptBtn, {BackgroundColor3 = t.Container, BackgroundTransparency = t.ContainerTransparency, TextColor3 = t.TextDark}, Config.AnimationSpeed)
                            else
                                table.insert(Dropdown.Value, optName)
                                Utility:Tween(OptBtn, {BackgroundColor3 = t.Accent, BackgroundTransparency = 0, TextColor3 = t.Text}, Config.AnimationSpeed)
                            end
                            Selected.Text = GetDisplayText()
                            SaveConfig()
                            callback(Dropdown.Value)
                        else
                            Dropdown.Value = optName
                            Selected.Text = optName
                            
                            for _, opt in pairs(OptionsContainer:GetChildren()) do
                                if opt:IsA("TextButton") then
                                    local isThis = opt.Name == optName
                                    Utility:Tween(opt, {
                                        BackgroundColor3 = isThis and t.Accent or t.Container,
                                        BackgroundTransparency = isThis and 0 or t.ContainerTransparency,
                                        TextColor3 = isThis and t.Text or t.TextDark
                                    }, Config.AnimationSpeed)
                                end
                            end
                            
                            SaveConfig()
                            callback(optName)
                            
                            -- Close dropdown
                            task.wait(Config.AnimationSpeed * 0.3)
                            Dropdown.Open = false
                            Utility:Tween(Frame, {Size = UDim2.new(1, 0, 0, 42)}, Config.AnimationSpeed)
                            Utility:Tween(Arrow, {Rotation = 0}, Config.AnimationSpeed)
                        end
                    end)
                    
                    return OptBtn
                end
                
                for _, opt in pairs(options) do
                    CreateOption(opt)
                end
                
                Header.MouseEnter:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed * 0.5)
                end)
                
                Header.MouseLeave:Connect(function()
                    Utility:Tween(Frame, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed * 0.5)
                end)
                
                Header.MouseButton1Click:Connect(function()
                    Dropdown.Open = not Dropdown.Open
                    Utility:Ripple(Header, theme, Config)
                    
                    local optCount = #options
                    local targetH = Dropdown.Open and math.min(42 + 8 + optCount * 36, 250) or 42
                    
                    Utility:Tween(Frame, {Size = UDim2.new(1, 0, 0, targetH)}, Config.AnimationSpeed)
                    Utility:Tween(Arrow, {Rotation = Dropdown.Open and 180 or 0}, Config.AnimationSpeed)
                end)
                
                function Dropdown:Set(v, skip)
                    local t = Window.Theme
                    if multiSelect then
                        Dropdown.Value = type(v) == "table" and v or {v}
                        for _, opt in pairs(OptionsContainer:GetChildren()) do
                            if opt:IsA("TextButton") then
                                local isSel = table.find(Dropdown.Value, opt.Name)
                                opt.BackgroundColor3 = isSel and t.Accent or t.Container
                                opt.BackgroundTransparency = isSel and 0 or t.ContainerTransparency
                                opt.TextColor3 = isSel and t.Text or t.TextDark
                            end
                        end
                    else
                        Dropdown.Value = v
                        for _, opt in pairs(OptionsContainer:GetChildren()) do
                            if opt:IsA("TextButton") then
                                local isThis = opt.Name == v
                                opt.BackgroundColor3 = isThis and t.Accent or t.Container
                                opt.BackgroundTransparency = isThis and 0 or t.ContainerTransparency
                                opt.TextColor3 = isThis and t.Text or t.TextDark
                            end
                        end
                    end
                    Selected.Text = GetDisplayText()
                    SaveConfig()
                    if not skip then callback(Dropdown.Value) end
                end
                
                function Dropdown:Refresh(newOpts, keepVal)
                    options = newOpts
                    Dropdown.Options = newOpts
                    
                    for _, child in pairs(OptionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    
                    if not keepVal then
                        Dropdown.Value = multiSelect and {} or (newOpts[1] or "")
                    end
                    
                    for _, opt in pairs(newOpts) do
                        CreateOption(opt)
                    end
                    
                    Selected.Text = GetDisplayText()
                    
                    if Dropdown.Open then
                        local optCount = #newOpts
                        local targetH = math.min(42 + 8 + optCount * 36, 250)
                        Utility:Tween(Frame, {Size = UDim2.new(1, 0, 0, targetH)}, Config.AnimationSpeed)
                    end
                end
                
                if default then callback(Dropdown.Value) end
                return Dropdown
            end
            
            -- Input
            function Section:CreateInput(opts)
                opts = opts or {}
                local name = opts.Name or "Input"
                local id = opts.Flag or name
                local placeholder = opts.PlaceholderText or "Enter text..."
                local default = opts.CurrentValue or ""
                local removeOnLost = opts.RemoveTextAfterFocusLost or false
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Input = { Value = default }
                Window.Elements[id] = Input
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Input",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.35, 0, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local BoxContainer = Utility:Create("Frame", {
                    Name = "BoxContainer",
                    Parent = Frame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency,
                    Position = UDim2.new(0.35, 5, 0.15, 0),
                    Size = UDim2.new(0.65, -20, 0.7, 0)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) }),
                    Utility:Create("UIStroke", { Name = "BoxStroke", Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                })
                
                local TextBox = Utility:Create("TextBox", {
                    Name = "TextBox",
                    Parent = BoxContainer,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = theme.TextMuted,
                    Text = default,
                    TextColor3 = theme.Text,
                    TextSize = 13,
                    ClearTextOnFocus = false,
                    ClipsDescendants = true
                })
                
                table.insert(Window.ElementRefs, { Type = "Input", Element = Input, Frame = Frame, Label = Label, BoxContainer = BoxContainer, TextBox = TextBox })
                
                TextBox.Focused:Connect(function()
                    Utility:Tween(BoxContainer:FindFirstChild("BoxStroke"), {Color = theme.Accent, Transparency = 0}, Config.AnimationSpeed)
                    Utility:Tween(Frame, {BackgroundColor3 = theme.ElementHover, BackgroundTransparency = theme.ElementTransparency - 0.1}, Config.AnimationSpeed)
                end)
                
                TextBox.FocusLost:Connect(function(enter)
                    Utility:Tween(BoxContainer:FindFirstChild("BoxStroke"), {Color = theme.Border, Transparency = theme.BorderTransparency}, Config.AnimationSpeed)
                    Utility:Tween(Frame, {BackgroundColor3 = theme.Element, BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed)
                    
                    Input.Value = TextBox.Text
                    SaveConfig()
                    
                    if enter or not removeOnLost then
                        callback(TextBox.Text)
                    end
                    
                    if removeOnLost then
                        TextBox.Text = ""
                        Input.Value = ""
                    end
                end)
                
                function Input:Set(t, skip)
                    TextBox.Text = t
                    Input.Value = t
                    SaveConfig()
                    if not skip then callback(t) end
                end
                
                return Input
            end
            
            -- Keybind
            function Section:CreateKeybind(opts)
                opts = opts or {}
                local name = opts.Name or "Keybind"
                local id = opts.Flag or name
                local default = opts.CurrentKeybind or "None"
                local holdMode = opts.HoldToInteract or false
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    default = Window.ConfigData.Elements[id]
                end
                
                local Keybind = {
                    Value = default ~= "None" and Enum.KeyCode[default] or nil,
                    Listening = false
                }
                Window.Elements[id] = { Value = default }
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "Keybind",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local KeyButton = Utility:Create("TextButton", {
                    Name = "KeyButton",
                    Parent = Frame,
                    BackgroundColor3 = theme.Container,
                    BackgroundTransparency = theme.ContainerTransparency,
                    Position = UDim2.new(1, -100, 0.15, 0),
                    Size = UDim2.new(0, 85, 0.7, 0),
                    Font = Enum.Font.GothamBold,
                    Text = default,
                    TextColor3 = theme.TextDark,
                    TextSize = 12,
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) }),
                    Utility:Create("UIStroke", { Name = "ButtonStroke", Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                })
                
                table.insert(Window.ElementRefs, { Type = "Keybind", Element = Keybind, Frame = Frame, Label = Label, KeyButton = KeyButton })
                
                KeyButton.MouseEnter:Connect(function()
                    if not Keybind.Listening then
                        Utility:Tween(KeyButton, {BackgroundTransparency = theme.ContainerTransparency - 0.15}, Config.AnimationSpeed * 0.5)
                    end
                end)
                
                KeyButton.MouseLeave:Connect(function()
                    if not Keybind.Listening then
                        Utility:Tween(KeyButton, {BackgroundTransparency = theme.ContainerTransparency}, Config.AnimationSpeed * 0.5)
                    end
                end)
                
                KeyButton.MouseButton1Click:Connect(function()
                    Keybind.Listening = true
                    KeyButton.Text = "..."
                    Utility:Tween(KeyButton, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0}, Config.AnimationSpeed)
                    Utility:Tween(KeyButton:FindFirstChild("ButtonStroke"), {Color = theme.Accent, Transparency = 0.3}, Config.AnimationSpeed)
                    Utility:Ripple(KeyButton, theme, Config)
                end)
                
                local inputConn = UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    
                    if Keybind.Listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            local keyName = input.KeyCode.Name
                            
                            if input.KeyCode == Enum.KeyCode.Escape then
                                Keybind.Value = nil
                                keyName = "None"
                            else
                                Keybind.Value = input.KeyCode
                            end
                            
                            Keybind.Listening = false
                            KeyButton.Text = keyName
                            Window.Elements[id].Value = keyName
                            
                            Utility:Tween(KeyButton, {BackgroundColor3 = theme.Container, BackgroundTransparency = theme.ContainerTransparency}, Config.AnimationSpeed)
                            Utility:Tween(KeyButton:FindFirstChild("ButtonStroke"), {Color = theme.Border, Transparency = theme.BorderTransparency}, Config.AnimationSpeed)
                            
                            SaveConfig()
                        end
                    elseif Keybind.Value and input.KeyCode == Keybind.Value then
                        if holdMode then
                            callback(true)
                        else
                            callback()
                        end
                    end
                end)
                table.insert(Window.Connections, inputConn)
                
                if holdMode then
                    local inputEndConn = UserInputService.InputEnded:Connect(function(input, gpe)
                        if gpe then return end
                        if Keybind.Value and input.KeyCode == Keybind.Value then
                            callback(false)
                        end
                    end)
                    table.insert(Window.Connections, inputEndConn)
                end
                
                function Keybind:Set(key, skip)
                    if type(key) == "string" then
                        if key == "None" then
                            Keybind.Value = nil
                        else
                            Keybind.Value = Enum.KeyCode[key]
                        end
                        KeyButton.Text = key
                        Window.Elements[id].Value = key
                    else
                        Keybind.Value = key
                        KeyButton.Text = key and key.Name or "None"
                        Window.Elements[id].Value = key and key.Name or "None"
                    end
                    SaveConfig()
                end
                
                return Keybind
            end
            
            -- Color Picker
            function Section:CreateColorPicker(opts)
                opts = opts or {}
                local name = opts.Name or "Color Picker"
                local id = opts.Flag or name
                local default = opts.Color or Color3.fromRGB(255, 255, 255)
                local callback = opts.Callback or function() end
                
                if Window.ConfigData.Elements and Window.ConfigData.Elements[id] ~= nil then
                    local saved = Window.ConfigData.Elements[id]
                    if type(saved) == "table" then
                        default = Color3.fromRGB(saved[1], saved[2], saved[3])
                    end
                end
                
                local ColorPicker = { Value = default, Open = false }
                Window.Elements[id] = { Value = {math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)} }
                
                local h, s, v = default:ToHSV()
                
                local Frame = Utility:Create("Frame", {
                    Name = name .. "ColorPicker",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 42),
                    ClipsDescendants = true
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 })
                })
                
                local Label = Utility:Create("TextLabel", {
                    Name = "Label",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.6, 0, 0, 42),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Display = Utility:Create("TextButton", {
                    Name = "Display",
                    Parent = Frame,
                    BackgroundColor3 = default,
                    Position = UDim2.new(1, -55, 0, 9),
                    Size = UDim2.new(0, 40, 0, 24),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1 })
                })
                
                local PickerContainer = Utility:Create("Frame", {
                    Name = "Picker",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 50),
                    Size = UDim2.new(1, -30, 0, 130)
                })
                
                local SatVal = Utility:Create("ImageLabel", {
                    Name = "SatVal",
                    Parent = PickerContainer,
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    Size = UDim2.new(1, -40, 0, 100),
                    Image = "rbxassetid://4155801252",
                    ScaleType = Enum.ScaleType.Stretch
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) })
                })
                
                local SatValCursor = Utility:Create("Frame", {
                    Name = "Cursor",
                    Parent = SatVal,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.new(s, 0, 1 - v, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 5
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Utility:Create("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 2 })
                })
                
                local HueSlider = Utility:Create("Frame", {
                    Name = "Hue",
                    Parent = PickerContainer,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.new(1, -30, 0, 0),
                    Size = UDim2.new(0, 25, 0, 100)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius - 2) }),
                    Utility:Create("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                        }),
                        Rotation = 90
                    })
                })
                
                local HueCursor = Utility:Create("Frame", {
                    Name = "Cursor",
                    Parent = HueSlider,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.new(0.5, 0, h, 0),
                    Size = UDim2.new(1, 6, 0, 8),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 5
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Utility:Create("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 2 })
                })
                
                local RGBLabel = Utility:Create("TextLabel", {
                    Name = "RGB",
                    Parent = PickerContainer,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 108),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = string.format("RGB: %d, %d, %d", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
                    TextColor3 = theme.TextDark,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                table.insert(Window.ElementRefs, { Type = "ColorPicker", Element = ColorPicker, Frame = Frame, Label = Label, Display = Display, RGBLabel = RGBLabel })
                
                local function UpdateColor()
                    local color = Color3.fromHSV(h, s, v)
                    ColorPicker.Value = color
                    Display.BackgroundColor3 = color
                    SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    RGBLabel.Text = string.format("RGB: %d, %d, %d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
                    
                    Window.Elements[id].Value = {math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)}
                    SaveConfig()
                    callback(color)
                end
                
                local draggingSV, draggingH = false, false
                
                local SatValInput = Utility:Create("TextButton", {
                    Parent = SatVal,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local function UpdateSatVal(input)
                    local rx = math.clamp((input.Position.X - SatVal.AbsolutePosition.X) / SatVal.AbsoluteSize.X, 0, 1)
                    local ry = math.clamp((input.Position.Y - SatVal.AbsolutePosition.Y) / SatVal.AbsoluteSize.Y, 0, 1)
                    s = rx
                    v = 1 - ry
                    Utility:Tween(SatValCursor, {Position = UDim2.new(rx, 0, ry, 0)}, Config.AnimationSpeed * 0.3)
                    UpdateColor()
                end
                
                SatValInput.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV = true
                        UpdateSatVal(input)
                    end
                end)
                
                local HueInput = Utility:Create("TextButton", {
                    Parent = HueSlider,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    AutoButtonColor = false
                })
                
                local function UpdateHue(input)
                    local ry = math.clamp((input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                    h = ry
                    Utility:Tween(HueCursor, {Position = UDim2.new(0.5, 0, ry, 0)}, Config.AnimationSpeed * 0.3)
                    UpdateColor()
                end
                
                HueInput.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingH = true
                        UpdateHue(input)
                    end
                end)
                
                local colorInputEndConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV = false
                        draggingH = false
                    end
                end)
                table.insert(Window.Connections, colorInputEndConn)
                
                local colorInputChangeConn = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingSV then UpdateSatVal(input)
                        elseif draggingH then UpdateHue(input) end
                    end
                end)
                table.insert(Window.Connections, colorInputChangeConn)
                
                Display.MouseButton1Click:Connect(function()
                    ColorPicker.Open = not ColorPicker.Open
                    Utility:Ripple(Display, theme, Config)
                    Utility:Tween(Frame, {Size = UDim2.new(1, 0, 0, ColorPicker.Open and 190 or 42)}, Config.AnimationSpeed)
                end)
                
                function ColorPicker:Set(color, skip)
                    h, s, v = color:ToHSV()
                    ColorPicker.Value = color
                    Display.BackgroundColor3 = color
                    SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    SatValCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueCursor.Position = UDim2.new(0.5, 0, h, 0)
                    RGBLabel.Text = string.format("RGB: %d, %d, %d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
                    
                    Window.Elements[id].Value = {math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)}
                    SaveConfig()
                    if not skip then callback(color) end
                end
                
                callback(default)
                return ColorPicker
            end
            
            -- Label
            function Section:CreateLabel(text)
                local Frame = Utility:Create("Frame", {
                    Name = "Label",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency + 0.1,
                    Size = UDim2.new(1, 0, 0, 32)
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) })
                })
                
                local Text = Utility:Create("TextLabel", {
                    Name = "Text",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = text or "Label",
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                table.insert(Window.ElementRefs, { Type = "Label", Frame = Frame, Text = Text })
                
                return {
                    Set = function(_, t)
                        Text.Text = t
                        Text.TextTransparency = 0.5
                        Utility:Tween(Text, {TextTransparency = 0}, Config.AnimationSpeed)
                    end
                }
            end
            
            -- Paragraph
            function Section:CreateParagraph(opts)
                opts = opts or {}
                local title = opts.Title or "Paragraph"
                local content = opts.Content or "Content"
                
                local Frame = Utility:Create("Frame", {
                    Name = "Paragraph",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Element,
                    BackgroundTransparency = theme.ElementTransparency,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                    Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency + 0.2, Thickness = 1 }),
                    Utility:Create("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) })
                })
                
                local Title = Utility:Create("TextLabel", {
                    Name = "Title",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.GothamBold,
                    Text = title,
                    TextColor3 = theme.Text,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Content = Utility:Create("TextLabel", {
                    Name = "Content",
                    Parent = Frame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Font = Enum.Font.Gotham,
                    Text = content,
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    RichText = true
                })
                
                table.insert(Window.ElementRefs, { Type = "Paragraph", Frame = Frame, Title = Title, Content = Content })
                
                return {
                    Set = function(_, newTitle, newContent)
                        if newTitle then Title.Text = newTitle end
                        if newContent then Content.Text = newContent end
                        Frame.BackgroundTransparency = theme.ElementTransparency + 0.2
                        Utility:Tween(Frame, {BackgroundTransparency = theme.ElementTransparency}, Config.AnimationSpeed)
                    end
                }
            end
            
            -- Divider
            function Section:CreateDivider()
                return Utility:Create("Frame", {
                    Name = "Divider",
                    Parent = SectionFrame,
                    BackgroundColor3 = theme.Border,
                    BackgroundTransparency = theme.BorderTransparency,
                    Size = UDim2.new(1, 0, 0, 1)
                })
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Dialog
    function Window:Dialog(opts)
        opts = opts or {}
        local title = opts.Title or "Dialog"
        local content = opts.Content or ""
        local buttons = opts.Buttons or {}
        
        local DialogBg = Utility:Create("Frame", {
            Name = "DialogBackground",
            Parent = ScreenGui,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 100
        })
        
        local DialogFrame = Utility:Create("Frame", {
            Name = "Dialog",
            Parent = DialogBg,
            BackgroundColor3 = theme.Background,
            BackgroundTransparency = theme.BackgroundTransparency,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 101,
            ClipsDescendants = true
        }, {
            Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.CornerRadius + 4) }),
            Utility:Create("UIStroke", { Color = theme.Border, Transparency = theme.BorderTransparency, Thickness = 1.5 }),
            Utility:Create("UIGradient", {
                Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, theme.GradientStart), ColorSequenceKeypoint.new(1, theme.GradientEnd) }),
                Rotation = 135,
                Transparency = NumberSequence.new(0.2)
            })
        })
        
        local DialogTitle = Utility:Create("TextLabel", {
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 0, 20),
            Size = UDim2.new(1, -50, 0, 25),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = theme.Text,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 102
        })
        
        local DialogContent = Utility:Create("TextLabel", {
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 0, 50),
            Size = UDim2.new(1, -50, 0, 60),
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = theme.TextDark,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            ZIndex = 102
        })
        
        local ButtonContainer = Utility:Create("Frame", {
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 25, 1, -60),
            Size = UDim2.new(1, -50, 0, 38),
            ZIndex = 102
        }, {
            Utility:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 12)
            })
        })
        
        Utility:Tween(DialogBg, {BackgroundTransparency = 0.5}, Config.AnimationSpeed)
        Utility:Tween(DialogFrame, {Size = UDim2.new(0, 380, 0, 180)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        if Blur then Utility:Tween(Blur, {Size = 15}, Config.AnimationSpeed) end
        
        local function CloseDialog()
            Utility:Tween(DialogBg, {BackgroundTransparency = 1}, Config.AnimationSpeed)
            Utility:Tween(DialogFrame, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            if Blur then Utility:Tween(Blur, {Size = 10}, Config.AnimationSpeed) end
            task.wait(Config.AnimationSpeed + 0.1)
            DialogBg:Destroy()
        end
        
        for _, btnInfo in pairs(buttons) do
            local btnText = btnInfo.Title or "Button"
            local btnCallback = btnInfo.Callback or function() end
            local isPrimary = btnInfo.Primary or false
            
            local DialogBtn = Utility:Create("TextButton", {
                Parent = ButtonContainer,
                BackgroundColor3 = isPrimary and theme.Accent or theme.Element,
                BackgroundTransparency = isPrimary and 0 or theme.ElementTransparency,
                Size = UDim2.new(0, 90, 0, 36),
                Font = Enum.Font.GothamBold,
                Text = btnText,
                TextColor3 = isPrimary and theme.Text or theme.TextDark,
                TextSize = 13,
                AutoButtonColor = false,
                ZIndex = 103
            }, {
                Utility:Create("UICorner", { CornerRadius = UDim.new(0, Config.ElementCornerRadius) }),
                Utility:Create("UIStroke", { Color = isPrimary and theme.Accent or theme.Border, Transparency = isPrimary and 0.3 or theme.BorderTransparency, Thickness = 1 })
            })
            
            DialogBtn.MouseEnter:Connect(function()
                Utility:Tween(DialogBtn, {BackgroundTransparency = 0, BackgroundColor3 = isPrimary and theme.AccentDark or theme.Accent, TextColor3 = theme.Text}, Config.AnimationSpeed * 0.5)
            end)
            
            DialogBtn.MouseLeave:Connect(function()
                Utility:Tween(DialogBtn, {
                    BackgroundColor3 = isPrimary and theme.Accent or theme.Element,
                    BackgroundTransparency = isPrimary and 0 or theme.ElementTransparency,
                    TextColor3 = isPrimary and theme.Text or theme.TextDark
                }, Config.AnimationSpeed * 0.5)
            end)
            
            DialogBtn.MouseButton1Click:Connect(function()
                Utility:Ripple(DialogBtn, theme, Config)
                btnCallback()
                CloseDialog()
            end)
        end
        
        DialogBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mPos = UserInputService:GetMouseLocation()
                local fPos = DialogFrame.AbsolutePosition
                local fSize = DialogFrame.AbsoluteSize
                if mPos.X < fPos.X or mPos.X > fPos.X + fSize.X or mPos.Y < fPos.Y or mPos.Y > fPos.Y + fSize.Y then
                    CloseDialog()
                end
            end
        end)
    end
    
    -- Destroy
    function Window:Destroy()
        for _, conn in pairs(Window.Connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        if Blur then Utility:Tween(Blur, {Size = 0}, Config.AnimationSpeed) end
        Utility:Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(Config.AnimationSpeed + 0.1)
        CleanupAllBlur()
        ScreenGui:Destroy()
    end
    
    -- Toggle
    function Window:Toggle(visible)
        if visible == nil then visible = not MainContainer.Visible end
        
        if visible then
            MainContainer.Visible = true
            MainContainer.Size = UDim2.new(0, 0, 0, 0)
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 700, 0, 480)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            if Blur then Utility:Tween(Blur, {Size = 10}, Config.AnimationSpeed) end
        else
            Utility:Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            if Blur then Utility:Tween(Blur, {Size = 0}, Config.AnimationSpeed) end
            task.wait(Config.AnimationSpeed + 0.1)
            MainContainer.Visible = false
        end
    end
    
    -- Theme getters/setters
    function Window:GetTheme() return Window.ThemeName end
    function Window:SetTheme(name) ApplyTheme(name, true) end
    function Window:GetThemes()
        local list = {}
        for n, _ in pairs(Themes) do table.insert(list, n) end
        return list
    end
    
    -- Toggle keybind
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    local toggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then Window:Toggle() end
    end)
    table.insert(Window.Connections, toggleConn)
    
    return Window
end

-- Static methods
function AlexchadLibrary:GetThemes()
    local list = {}
    for n, _ in pairs(Themes) do table.insert(list, n) end
    return list
end

function AlexchadLibrary:AddTheme(name, data)
    Themes[name] = data
end

function AlexchadLibrary:IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

return AlexchadLibrary
