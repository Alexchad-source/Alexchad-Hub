-- KavoUI Library | Modern Roblox UI Framework
-- Inspired by Kavo UI aesthetics with Rayfield-like API

local Library = {}
Library.__index = Library

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- UI Parent
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KavoUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

if RunService:IsStudio() then
	ScreenGui.Parent = Player:WaitForChild("PlayerGui")
else
	ScreenGui.Parent = CoreGui
end

--// [SUGGESTED] Improved Default Theme
local DefaultTheme = {
	Background = Color3.fromRGB(25, 25, 25),
	SecondaryBackground = Color3.fromRGB(32, 32, 32),
	TertiaryBackground = Color3.fromRGB(40, 40, 40),
	Accent = Color3.fromRGB(0, 162, 255),
	SecondaryAccent = Color3.fromRGB(0, 140, 220),
	Text = Color3.fromRGB(240, 240, 240),
	SecondaryText = Color3.fromRGB(180, 180, 180),
	Border = Color3.fromRGB(50, 50, 50),
	Shadow = Color3.fromRGB(15, 15, 15),
	Destructive = Color3.fromRGB(231, 76, 60) 
}


-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle)
	easingStyle = easingStyle or Enum.EasingStyle.Quart
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(duration, easingStyle, Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

local function AddHoverEffect(button, hoverColor, normalColor)
	local isHovering = false

	button.MouseEnter:Connect(function()
		isHovering = true
		CreateTween(button, {BackgroundColor3 = hoverColor}, 0.2)
	end)

	button.MouseLeave:Connect(function()
		isHovering = false
		CreateTween(button, {BackgroundColor3 = normalColor}, 0.2)
	end)

	button.MouseButton1Down:Connect(function()
		CreateTween(button, {BackgroundColor3 = normalColor:Lerp(Color3.new(0, 0, 0), 0.3)}, 0.1)
	end)

	button.MouseButton1Up:Connect(function()
		if isHovering then
			CreateTween(button, {BackgroundColor3 = hoverColor}, 0.1)
		else
			CreateTween(button, {BackgroundColor3 = normalColor}, 0.1)
		end
	end)
end

local function CreateShadow(parent, transparency)
	transparency = transparency or 0.8
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
	shadow.Size = UDim2.new(1, 20, 1, 20)
	shadow.Image = "rbxassetid://5554236805"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = transparency
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(23, 23, 277, 277)
	shadow.Parent = parent
	return shadow
end

local function Round(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 8)
	corner.Parent = instance
	return corner
end


-- Window Class
local Window = {}
Window.__index = Window

function Library:CreateWindow(config)
	config = config or {}
	local self = setmetatable({}, Window)

	self.Name = config.Name or "KavoUI Window"
	self.Theme = config.Theme or DefaultTheme
	self.SaveConfig = config.SaveConfig or false
	self.LoadConfig = config.LoadConfig or false
	self.ConfigFolder = config.ConfigFolder or "KavoUIConfigs"
	self.CloseBind = config.CloseBind or Enum.KeyCode.RightControl
	self.Tabs = {}
	self.Flags = {}

	-- Main Frame (bigger, centered)
	self.MainFrame = Instance.new("Frame")
	self.MainFrame.Name = "MainFrame"
	self.MainFrame.BackgroundColor3 = self.Theme.Background
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Position = UDim2.new(0.5, -330, 0.5, -230) -- Centered for 660x460
	self.MainFrame.Size = UDim2.new(0, 660, 0, 460) -- Increased size
	self.MainFrame.Parent = ScreenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10) -- Slightly rounder
	mainCorner.Parent = self.MainFrame

	CreateShadow(self.MainFrame)

	-- Title Bar
	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Name = "TitleBar"
	self.TitleBar.BackgroundColor3 = self.Theme.SecondaryBackground
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
	self.TitleBar.Parent = self.MainFrame

	local titleGradient = Instance.new("UIGradient")
	titleGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
	}
	titleGradient.Rotation = 90
	titleGradient.Parent = self.TitleBar

	self.TitleLabel = Instance.new("TextLabel")
	self.TitleLabel.Name = "Title"
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	self.TitleLabel.Size = UDim2.new(0.5, -15, 1, 0)
	self.TitleLabel.Font = Enum.Font.Gotham
	self.TitleLabel.Text = self.Name
	self.TitleLabel.TextColor3 = self.Theme.Text
	self.TitleLabel.TextScaled = false
	self.TitleLabel.TextSize = 16
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.Parent = self.TitleBar

	-- Close Button
	self.CloseButton = Instance.new("TextButton")
	self.CloseButton.Name = "CloseButton"
	self.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	self.CloseButton.BorderSizePixel = 0
	self.CloseButton.Position = UDim2.new(1, -35, 0.5, -10)
	self.CloseButton.Size = UDim2.new(0, 20, 0, 20)
	self.CloseButton.Font = Enum.Font.Gotham
	self.CloseButton.Text = "×"
	self.CloseButton.TextColor3 = Color3.new(1, 1, 1)
	self.CloseButton.TextSize = 18
	self.CloseButton.Parent = self.TitleBar

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 4)
	closeCorner.Parent = self.CloseButton

	AddHoverEffect(self.CloseButton, Color3.fromRGB(255, 80, 80), Color3.fromRGB(255, 60, 60))

	self.CloseButton.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	-- Tab Container (wider)
	self.TabContainer = Instance.new("Frame")
	self.TabContainer.Name = "TabContainer"
	self.TabContainer.BackgroundColor3 = self.Theme.SecondaryBackground
	self.TabContainer.BorderSizePixel = 0
	self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
	self.TabContainer.Size = UDim2.new(0, 180, 1, -40) -- Wider by 30px
	self.TabContainer.Parent = self.MainFrame

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 4)
	tabCorner.Parent = self.TabContainer

	local tabGradient = Instance.new("UIGradient")
	tabGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230))
	}
	tabGradient.Rotation = 90
	tabGradient.Parent = self.TabContainer

	self.TabList = Instance.new("ScrollingFrame")
	self.TabList.Name = "TabList"
	self.TabList.BackgroundTransparency = 1
	self.TabList.BorderSizePixel = 0
	self.TabList.Position = UDim2.new(0, 0, 0, 10)
	self.TabList.Size = UDim2.new(1, 0, 1, -20)
	self.TabList.ScrollBarThickness = 3
	self.TabList.ScrollBarImageColor3 = self.Theme.Accent
	self.TabList.Parent = self.TabContainer

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Padding = UDim.new(0, 5)
	tabListLayout.Parent = self.TabList

	-- Content Container (shifted to match new TabContainer width)
	self.ContentContainer = Instance.new("Frame")
	self.ContentContainer.Name = "ContentContainer"
	self.ContentContainer.BackgroundTransparency = 1
	self.ContentContainer.Position = UDim2.new(0, 180, 0, 40)
	self.ContentContainer.Size = UDim2.new(1, -180, 1, -40)
	self.ContentContainer.Parent = self.MainFrame

	local ContentContainerCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 4)
	closeCorner.Parent = self.ContentContainer

	Round(self.MainFrame)
	Round(self.TitleBar)
	Round(self.TabContainer)
	Round(self.CloseButton, UDim.new(0, 6))
	Round(self.ContentContainer)

	
	-- Draggable TitleBar
	local dragging, dragStart, startPos = false

	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.MainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self.MainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Close/Open Keybind
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == self.CloseBind then
			self.MainFrame.Visible = not self.MainFrame.Visible
		end
	end)

	-- Load saved config
	if self.LoadConfig and self.ConfigFolder then
		self:LoadConfiguration()
	end

	return self
end


-- Tab Class
local Tab = {}
Tab.__index = Tab

function Window:CreateTab(config)
	config = config or {}
	local tab = setmetatable({}, Tab)

	tab.Name = config.Name or "Tab"
	tab.Icon = config.Icon
	tab.Window = self
	tab.Active = false

	-- Tab Button
	tab.TabButton = Instance.new("TextButton")
	tab.TabButton.Name = tab.Name
	tab.TabButton.BackgroundColor3 = self.Theme.TertiaryBackground
	tab.TabButton.BorderSizePixel = 0
	tab.TabButton.Size = UDim2.new(1, -10, 0, 35)
	tab.TabButton.Font = Enum.Font.Gotham
	tab.TabButton.Text = ""
	tab.TabButton.TextColor3 = self.Theme.SecondaryText
	tab.TabButton.TextSize = 14
	tab.TabButton.Parent = self.TabList

	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 6)
	tabCorner.Parent = tab.TabButton

	local tabStroke = Instance.new("UIStroke")
	tabStroke.Color = self.Theme.Border
	tabStroke.Transparency = 0.7
	tabStroke.Thickness = 1
	tabStroke.Parent = tab.TabButton

	-- Tab Label
	local tabLabel = Instance.new("TextLabel")
	tabLabel.BackgroundTransparency = 1
	tabLabel.Position = UDim2.new(0, 10, 0, 0)
	tabLabel.Size = UDim2.new(1, -20, 1, 0)
	tabLabel.Font = Enum.Font.Gotham
	tabLabel.Text = tab.Name
	tabLabel.TextColor3 = self.Theme.SecondaryText
	tabLabel.TextSize = 14
	tabLabel.TextXAlignment = Enum.TextXAlignment.Left
	tabLabel.Parent = tab.TabButton

	-- Tab Content
	tab.Content = Instance.new("ScrollingFrame")
	tab.Content.Name = tab.Name .. "Content"
	tab.Content.BackgroundTransparency = 1
	tab.Content.BorderSizePixel = 0
	tab.Content.Position = UDim2.new(0, 10, 0, 10)
	tab.Content.Size = UDim2.new(1, -20, 1, -20)
	tab.Content.ScrollBarThickness = 3
	tab.Content.ScrollBarImageColor3 = self.Theme.Accent
	tab.Content.Visible = false
	tab.Content.Parent = self.ContentContainer

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 8)
	contentLayout.Parent = tab.Content

	-- Tab selection
	tab.TabButton.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	AddHoverEffect(tab.TabButton, self.Theme.Accent:Lerp(self.Theme.TertiaryBackground, 0.7), self.Theme.TertiaryBackground)

	table.insert(self.Tabs, tab)

	-- Select first tab by default
	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end

	return tab
end

function Window:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		if t == tab then
			t.Active = true
			t.Content.Visible = true
			CreateTween(t.TabButton, {BackgroundColor3 = self.Theme.Accent}, 0.2)
			CreateTween(t.TabButton:FindFirstChildOfClass("TextLabel"), {TextColor3 = self.Theme.Text}, 0.2)
			CreateTween(t.TabButton:FindFirstChildOfClass("UIStroke"), {Transparency = 0.5}, 0.2)
		else
			t.Active = false
			t.Content.Visible = false
			CreateTween(t.TabButton, {BackgroundColor3 = self.Theme.TertiaryBackground}, 0.2)
			CreateTween(t.TabButton:FindFirstChildOfClass("TextLabel"), {TextColor3 = self.Theme.SecondaryText}, 0.2)
			CreateTween(t.TabButton:FindFirstChildOfClass("UIStroke"), {Transparency = 0.7}, 0.2)
		end
	end
end

-- Component Creation Functions
function Tab:CreateButton(config)
	config = config or {}
	local name = config.Name or "Button"
	local callback = config.Callback or function() end

	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = name .. "Frame"
	buttonFrame.BackgroundColor3 = self.Window.Theme.SecondaryBackground
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Size = UDim2.new(1, 0, 0, 40)
	buttonFrame.Parent = self.Content

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = buttonFrame

	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = self.Window.Theme.Border
	frameStroke.Transparency = 0.8
	frameStroke.Thickness = 1
	frameStroke.Parent = buttonFrame

	local button = Instance.new("TextButton")
	button.Name = "Button"
	button.BackgroundColor3 = self.Window.Theme.Accent
	button.BorderSizePixel = 0
	button.Position = UDim2.new(1, -100, 0.5, -15)
	button.Size = UDim2.new(0, 90, 0, 30)
	button.Font = Enum.Font.Gotham
	button.Text = "Execute"
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 13
	button.Parent = buttonFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 4)
	buttonCorner.Parent = button

	local buttonGradient = Instance.new("UIGradient")
	buttonGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
	}
	buttonGradient.Rotation = 90
	buttonGradient.Parent = button

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Size = UDim2.new(1, -120, 1, 0)
	label.Font = Enum.Font.Gotham
	label.Text = name
	label.TextColor3 = self.Window.Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = buttonFrame

	AddHoverEffect(button, self.Window.Theme.SecondaryAccent, self.Window.Theme.Accent)

	button.MouseButton1Click:Connect(function()
		callback()
	end)

	return {Frame = buttonFrame, Button = button}
end

function Tab:CreateToggle(config)
	config = config or {}
	local name = config.Name or "Toggle"
	local default = config.Default or false
	local callback = config.Callback or function() end
	local flag = config.Flag
	local save = config.Save or false

	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = name .. "Frame"
	toggleFrame.BackgroundColor3 = self.Window.Theme.SecondaryBackground
	toggleFrame.BorderSizePixel = 0
	toggleFrame.Size = UDim2.new(1, 0, 0, 40)
	toggleFrame.Parent = self.Content

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = toggleFrame

	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = self.Window.Theme.Border
	frameStroke.Transparency = 0.8
	frameStroke.Thickness = 1
	frameStroke.Parent = toggleFrame

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.BackgroundColor3 = self.Window.Theme.TertiaryBackground
	toggleButton.BorderSizePixel = 0
	toggleButton.Position = UDim2.new(1, -55, 0.5, -10)
	toggleButton.Size = UDim2.new(0, 45, 0, 20)
	toggleButton.Text = ""
	toggleButton.Parent = toggleFrame

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0.5, 0)
	toggleCorner.Parent = toggleButton

	local toggleStroke = Instance.new("UIStroke")
	toggleStroke.Color = self.Window.Theme.Border
	toggleStroke.Transparency = 0.7
	toggleStroke.Thickness = 1
	toggleStroke.Parent = toggleButton

	local toggleIndicator = Instance.new("Frame")
	toggleIndicator.Name = "Indicator"
	toggleIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
	toggleIndicator.BorderSizePixel = 0
	toggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
	toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
	toggleIndicator.Parent = toggleButton

	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(0.5, 0)
	indicatorCorner.Parent = toggleIndicator

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Font = Enum.Font.Gotham
	label.Text = name
	label.TextColor3 = self.Window.Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame

	local toggled = default

	local function updateToggle()
		if toggled then
			CreateTween(toggleButton, {BackgroundColor3 = self.Window.Theme.Accent}, 0.2)
			CreateTween(toggleIndicator, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
		else
			CreateTween(toggleButton, {BackgroundColor3 = self.Window.Theme.TertiaryBackground}, 0.2)
			CreateTween(toggleIndicator, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
		end
		callback(toggled)

		if flag and save then
			self.Window.Flags[flag] = toggled
			if self.Window.SaveConfig then
				self.Window:SaveConfiguration()
			end
		end
	end

	toggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		updateToggle()
	end)

	if flag then
		self.Window.Flags[flag] = toggled
	end

	updateToggle()

	return {Frame = toggleFrame, Toggle = toggleButton, SetValue = function(val) toggled = val; updateToggle() end}
end

function Tab:CreateSlider(config)
	config = config or {}
	local name = config.Name or "Slider"
	local min = config.Min or 0
	local max = config.Max or 100
	local increment = config.Increment or 1
	local default = config.Default or min
	local callback = config.Callback or function() end
	local flag = config.Flag
	local save = config.Save or false

	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = name .. "Frame"
	sliderFrame.BackgroundColor3 = self.Window.Theme.SecondaryBackground
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Size = UDim2.new(1, 0, 0, 60)
	sliderFrame.Parent = self.Content

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = sliderFrame

	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = self.Window.Theme.Border
	frameStroke.Transparency = 0.8
	frameStroke.Thickness = 1
	frameStroke.Parent = sliderFrame

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 5)
	label.Size = UDim2.new(0.5, -10, 0, 20)
	label.Font = Enum.Font.Gotham
	label.Text = name
	label.TextColor3 = self.Window.Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.BackgroundTransparency = 1
	valueLabel.Position = UDim2.new(0.5, 0, 0, 5)
	valueLabel.Size = UDim2.new(0.5, -10, 0, 20)
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.Text = tostring(default)
	valueLabel.TextColor3 = self.Window.Theme.SecondaryText
	valueLabel.TextSize = 14
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = sliderFrame

	local sliderBar = Instance.new("Frame")
	sliderBar.Name = "SliderBar"
	sliderBar.BackgroundColor3 = self.Window.Theme.TertiaryBackground
	sliderBar.BorderSizePixel = 0
	sliderBar.Position = UDim2.new(0, 10, 0, 35)
	sliderBar.Size = UDim2.new(1, -20, 0, 6)
	sliderBar.Parent = sliderFrame

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0.5, 0)
	barCorner.Parent = sliderBar

	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.BackgroundColor3 = self.Window.Theme.Accent
	sliderFill.BorderSizePixel = 0
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.Parent = sliderBar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.5, 0)
	fillCorner.Parent = sliderFill

	local sliderButton = Instance.new("TextButton")
	sliderButton.Name = "SliderButton"
	sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
	sliderButton.BorderSizePixel = 0
	sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
	sliderButton.Size = UDim2.new(0, 16, 0, 16)
	sliderButton.Text = ""
	sliderButton.Parent = sliderBar

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0.5, 0)
	buttonCorner.Parent = sliderButton

	local buttonShadow = Instance.new("UIStroke")
	buttonShadow.Color = self.Window.Theme.Shadow
	buttonShadow.Transparency = 0.5
	buttonShadow.Thickness = 2
	buttonShadow.Parent = sliderButton

	local value = default
	local dragging = false

	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		value = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
		value = math.clamp(value, min, max)

		sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		sliderButton.Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8)
		valueLabel.Text = tostring(value)

		callback(value)

		if flag and save then
			self.Window.Flags[flag] = value
			if self.Window.SaveConfig then
				self.Window:SaveConfiguration()
			end
		end
	end

	sliderButton.MouseButton1Down:Connect(function()
		dragging = true
	end)

	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	if flag then
		self.Window.Flags[flag] = value
	end

	return {Frame = sliderFrame, SetValue = function(val) value = val; updateSlider({Position = Vector3.new(sliderBar.AbsolutePosition.X + (val - min) / (max - min) * sliderBar.AbsoluteSize.X, 0, 0)}) end}
end

function Tab:CreateDropdown(config)
	config = config or {}
	local name = config.Name or "Dropdown"
	local options = config.Options or {}
	local default = config.Default or options[1] or ""
	local callback = config.Callback or function() end
	local save = config.Save or false

	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = name .. "Frame"
	dropdownFrame.BackgroundColor3 = self.Window.Theme.SecondaryBackground
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
	dropdownFrame.Parent = self.Content

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = dropdownFrame

	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = self.Window.Theme.Border
	frameStroke.Transparency = 0.8
	frameStroke.Thickness = 1
	frameStroke.Parent = dropdownFrame

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Size = UDim2.new(0.4, -10, 1, 0)
	label.Font = Enum.Font.Gotham
	label.Text = name
	label.TextColor3 = self.Window.Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = dropdownFrame

	local dropdownButton = Instance.new("TextButton")
	dropdownButton.Name = "DropdownButton"
	dropdownButton.BackgroundColor3 = self.Window.Theme.TertiaryBackground
	dropdownButton.BorderSizePixel = 0
	dropdownButton.Position = UDim2.new(0.4, 0, 0.5, -15)
	dropdownButton.Size = UDim2.new(0.6, -10, 0, 30)
	dropdownButton.Font = Enum.Font.Gotham
	dropdownButton.Text = default
	dropdownButton.TextColor3 = self.Window.Theme.Text
	dropdownButton.TextSize = 13
	dropdownButton.Parent = dropdownFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 4)
	buttonCorner.Parent = dropdownButton

	local dropdownIcon = Instance.new("TextLabel")
	dropdownIcon.BackgroundTransparency = 1
	dropdownIcon.Position = UDim2.new(1, -25, 0, 0)
	dropdownIcon.Size = UDim2.new(0, 25, 1, 0)
	dropdownIcon.Font = Enum.Font.Gotham
	dropdownIcon.Text = "▼"
	dropdownIcon.TextColor3 = self.Window.Theme.SecondaryText
	dropdownIcon.TextSize = 10
	dropdownIcon.Parent = dropdownButton

	local dropdownList = Instance.new("Frame")
	dropdownList.Name = "DropdownList"
	dropdownList.BackgroundColor3 = self.Window.Theme.SecondaryBackground
	dropdownList.BorderSizePixel = 0
	dropdownList.Position = UDim2.new(0, 0, 1, 5)
	dropdownList.Size = UDim2.new(1, 0, 0, 0)
	dropdownList.Visible = false
	dropdownList.ZIndex = 10
	dropdownList.Parent = dropdownButton

	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 4)
	listCorner.Parent = dropdownList

	local listStroke = Instance.new("UIStroke")
	listStroke.Color = self.Window.Theme.Border
	listStroke.Transparency = 0.7
	listStroke.Thickness = 1
	listStroke.Parent = dropdownList

	CreateShadow(dropdownList, 0.5)

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = dropdownList

	local selected = default
	local expanded = false

	local function toggleDropdown()
		expanded = not expanded
		if expanded then
			dropdownList.Visible = true
			CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, #options * 30)}, 0.2)
			CreateTween(dropdownIcon, {Rotation = 180}, 0.2)
		else
			CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2).Completed:Connect(function()
				dropdownList.Visible = false
			end)
			CreateTween(dropdownIcon, {Rotation = 0}, 0.2)
		end
	end

	dropdownButton.MouseButton1Click:Connect(toggleDropdown)

	for _, option in ipairs(options) do
		local optionButton = Instance.new("TextButton")
		optionButton.Name = option
		optionButton.BackgroundColor3 = self.Window.Theme.SecondaryBackground
		optionButton.BorderSizePixel = 0
		optionButton.Size = UDim2.new(1, 0, 0, 30)
		optionButton.Font = Enum.Font.Gotham
		optionButton.Text = option
		optionButton.TextColor3 = self.Window.Theme.SecondaryText
		optionButton.TextSize = 13
		optionButton.Parent = dropdownList

		AddHoverEffect(optionButton, self.Window.Theme.TertiaryBackground, self.Window.Theme.SecondaryBackground)

		optionButton.MouseButton1Click:Connect(function()
			selected = option
			dropdownButton.Text = option
			toggleDropdown()
			callback(selected)

			if save then
				if self.Window.SaveConfig then
					self.Window:SaveConfiguration()
				end
			end
		end)
	end

	return {Frame = dropdownFrame, SetValue = function(val) selected = val; dropdownButton.Text = val; callback(val) end}
end

function Tab:CreateTextbox(config)
	config = config or {}
	local name = config.Name or "Textbox"
	local placeholderText = config.PlaceholderText or "Enter text..."
	local removeTextAfterFocusLost = config.RemoveTextAfterFocusLost or false
	local callback = config.Callback or function() end

	local textboxFrame = Instance.new("Frame")
	textboxFrame.Name = name .. "Frame"
	textboxFrame.BackgroundColor3 = self.Window.Theme.SecondaryBackground
	textboxFrame.BorderSizePixel = 0
	textboxFrame.Size = UDim2.new(1, 0, 0, 40)
	textboxFrame.Parent = self.Content

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = textboxFrame

	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = self.Window.Theme.Border
	frameStroke.Transparency = 0.8
	frameStroke.Thickness = 1
	frameStroke.Parent = textboxFrame

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Size = UDim2.new(0.35, -10, 1, 0)
	label.Font = Enum.Font.Gotham
	label.Text = name
	label.TextColor3 = self.Window.Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = textboxFrame

	local textbox = Instance.new("TextBox")
	textbox.Name = "Textbox"
	textbox.BackgroundColor3 = self.Window.Theme.TertiaryBackground
	textbox.BorderSizePixel = 0
	textbox.Position = UDim2.new(0.35, 0, 0.5, -15)
	textbox.Size = UDim2.new(0.65, -10, 0, 30)
	textbox.Font = Enum.Font.Gotham
	textbox.PlaceholderText = placeholderText
	textbox.PlaceholderColor3 = self.Window.Theme.SecondaryText
	textbox.Text = ""
	textbox.TextColor3 = self.Window.Theme.Text
	textbox.TextSize = 13
	textbox.Parent = textboxFrame

	local textboxCorner = Instance.new("UICorner")
	textboxCorner.CornerRadius = UDim.new(0, 4)
	textboxCorner.Parent = textbox

	textbox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			callback(textbox.Text)
			if removeTextAfterFocusLost then
				textbox.Text = ""
			end
		end
	end)

	textbox.Focused:Connect(function()
		CreateTween(frameStroke, {Color = self.Window.Theme.Accent, Transparency = 0.5}, 0.2)
	end)

	textbox.FocusLost:Connect(function()
		CreateTween(frameStroke, {Color = self.Window.Theme.Border, Transparency = 0.8}, 0.2)
	end)

	return {Frame = textboxFrame, Textbox = textbox}
end
--//Notification System
local Notifications = {}
local Queue = {}
local MaxNotifications = 7
local Processing = false

local function Restack()
	local screenPadding = 20
	local spacing = 10
	local currentY = screenPadding

	for _, notif in ipairs(Notifications) do
		local targetOffset = -(currentY + notif.AbsoluteSize.Y)
		CreateTween(notif, {
			Position = UDim2.new(1, -10, 1, targetOffset)
		}, 0.25, Enum.EasingStyle.Quint)
		currentY += notif.AbsoluteSize.Y + spacing
	end
end

local function ShowNotification(config)
	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.BackgroundColor3 = DefaultTheme.SecondaryBackground
	notification.BorderSizePixel = 0
	notification.Size = UDim2.new(0, 300, 0, 80)
	notification.AnchorPoint = Vector2.new(1, 1)
	notification.ClipsDescendants = true
	notification.Position = UDim2.new(1, 310, 1, -80) -- offscreen right initially
	notification.Parent = ScreenGui

	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 8)
	notifCorner.Parent = notification

	local notifStroke = Instance.new("UIStroke")
	notifStroke.Color = DefaultTheme.Accent
	notifStroke.Transparency = 0.5
	notifStroke.Thickness = 2
	notifStroke.Parent = notification

	CreateShadow(notification)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 15, 0, 10)
	titleLabel.Size = UDim2.new(1, -30, 0, 20)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = config.Title or "Notification"
	titleLabel.TextColor3 = DefaultTheme.Text
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = notification

	local contentLabel = Instance.new("TextLabel")
	contentLabel.BackgroundTransparency = 1
	contentLabel.Position = UDim2.new(0, 15, 0, 35)
	contentLabel.Size = UDim2.new(1, -30, 0, 30)
	contentLabel.Font = Enum.Font.Gotham
	contentLabel.Text = config.Content or ""
	contentLabel.TextColor3 = DefaultTheme.SecondaryText
	contentLabel.TextSize = 14
	contentLabel.TextWrapped = true
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.Parent = notification

	table.insert(Notifications, 1, notification)
	Restack()

	-- Animate in
	local tweenIn = CreateTween(notification, {
		Position = UDim2.new(1, -10, 1, -80)
	}, 0.35, Enum.EasingStyle.Back)
	tweenIn.Completed:Wait()

	Restack()

	task.wait(config.Duration or 5)

	-- Animate out
	local tweenOut = CreateTween(notification, {
		Position = UDim2.new(1, 310, notification.Position.Y.Scale, notification.Position.Y.Offset)
	}, 0.3, Enum.EasingStyle.Quart)
	tweenOut.Completed:Wait()

	local index = table.find(Notifications, notification)
	if index then
		table.remove(Notifications, index)
	end
	notification:Destroy()

	Restack()
end

local function ProcessQueue()
	if Processing then return end
	Processing = true

	while #Queue > 0 do
		if #Notifications < MaxNotifications then
			local config = table.remove(Queue, 1)
			task.spawn(function()
				ShowNotification(config)
			end)
		else
			task.wait(0.1)
		end
	end

	Processing = false
end

function Library:Notify(config)
	table.insert(Queue, config)
	task.spawn(ProcessQueue)
end

-- Configuration System
function Window:SaveConfiguration()
	if not self.ConfigFolder then return end

	local config = {}
	for flag, value in pairs(self.Flags) do
		config[flag] = value
	end

	local success, err = pcall(function()
		if not isfolder(self.ConfigFolder) then
			makefolder(self.ConfigFolder)
		end
		writefile(self.ConfigFolder .. "/config.json", HttpService:JSONEncode(config))
	end)

	if not success then
		warn("Failed to save configuration:", err)
	end
end

function Window:LoadConfiguration()
	if not self.ConfigFolder then return end

	local success, result = pcall(function()
		if isfolder(self.ConfigFolder) and isfile(self.ConfigFolder .. "/config.json") then
			return HttpService:JSONDecode(readfile(self.ConfigFolder .. "/config.json"))
		end
	end)

	if success and result then
		self.Flags = result
	end
end

function Window:Destroy()
	if self.SaveConfig then
		self:SaveConfiguration()
	end
	self.MainFrame:Destroy()
end

return Library


