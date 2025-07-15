-- LIBARY FOR ALEXCHAD HUB BRO IDK AFTER SO MANY BUGS I GOT TIRED AND USED SOME AI TO FIX BUGS REPORT MORE BUGS IN DISCORD SERVER(IM AWARE OF DROPDWON) AND THIS IS OPEN SOURCE SO IF YOU COULD HELP ME PLEASE BRO I CNAT ANYMORE
--I SPENT 2 WEEKS 3 WEEKENDS JUST TO MKAE IT AS IT IS AND I MIGHT JUST USE RAYFIELD IDK JUST PLS USE 


local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UI_NAME = "Alexchad_BroFinally"

local AlexchadGui = Instance.new("ScreenGui")
AlexchadGui.Name = UI_NAME
AlexchadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AlexchadGui.ResetOnSpawn = false
AlexchadGui.Parent = Player.PlayerGui

local Themes = {
	-- Dark Theme
	Dark = {
		Background = Color3.fromRGB(25, 25, 25),
		SecondaryBackground = Color3.fromRGB(32, 32, 32),
		TertiaryBackground = Color3.fromRGB(40, 40, 40),
		Accent = Color3.fromRGB(0, 162, 255),
		SecondaryAccent = Color3.fromRGB(0, 140, 220),
		HoverAccent = Color3.fromRGB(0, 180, 255),
		Destructive = Color3.fromRGB(255, 50, 50),
		Text = Color3.fromRGB(240, 240, 240),
		SecondaryText = Color3.fromRGB(180, 180, 180),
		Border = Color3.fromRGB(50, 50, 50),
		Shadow = Color3.fromRGB(15, 15, 15),
		Success = Color3.fromRGB(50, 255, 50),
		Warning = Color3.fromRGB(255, 200, 50)

	},
	-- Light Theme
	Light = {				
		Background = Color3.fromRGB(240, 240, 240),
		SecondaryBackground = Color3.fromRGB(220, 220, 220),
		TertiaryBackground = Color3.fromRGB(200, 200, 200),
		Accent = Color3.fromRGB(0, 120, 200),
		SecondaryAccent = Color3.fromRGB(0, 100, 180),
		HoverAccent = Color3.fromRGB(0, 140, 220), 
		Destructive = Color3.fromRGB(200, 50, 50),		
		Text = Color3.fromRGB(30, 30, 30),
		SecondaryText = Color3.fromRGB(100, 100, 100),
		Border = Color3.fromRGB(150, 150, 150),
		Shadow = Color3.fromRGB(100, 100, 100),
		Success = Color3.fromRGB(50, 200, 50),
		Warning = Color3.fromRGB(200, 150, 50)		
	}
}


local Localization = {
	en = {
		Close = "Close",
		Execute = "Execute",
		Notification = "Notification",
		Success = "Success",
		Error = "Error",
		Warning = "Warning"
	}
}

local function Create(instanceType, properties)
	local instance = Instance.new(instanceType)
	for property, value in pairs(properties) do
		if type(value) == "table" and property == "Children" then
			for _, child in ipairs(value) do
				child.Parent = instance
			end
		else
			instance[property] = value
		end
	end
	return instance
end

local DefaultTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function CreateTween(instance, properties, duration, easingStyle)
	local tweenInfo = duration == 0.2 and DefaultTweenInfo or TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	tween:Play()
	return tween
end

local function AddHoverEffect(button, hoverColor, normalColor, disabled)
	if disabled then
		button.BackgroundColor3 = normalColor:Lerp(Color3.new(0.5, 0.5, 0.5), 0.5)
		button.TextTransparency = 0.5
		return
	end

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
		local targetColor = isHovering and hoverColor or normalColor
		CreateTween(button, {BackgroundColor3 = targetColor}, 0.1)
	end)
end

local function CreateShadow(parent, transparency)
	return Create("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 4),
		Size = UDim2.new(1, 20, 1, 20),
		Image = "rbxassetid://5554236805",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = transparency or 0.8,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23, 23, 277, 277),
		ZIndex = -1,
		Parent = parent
	})
end

local function Round(instance, radius)
	return Create("UICorner", {
		CornerRadius = radius or UDim.new(0, 8),
		Parent = instance
	})
end

local function CreateElementContainer(parentTab, name, height)
	local theme = parentTab.Window.Theme
	local container = Create("Frame", {
		Name = name .. "Frame",
		BackgroundColor3 = theme.SecondaryBackground,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height),
		Parent = parentTab.Content
	})
	Round(container, UDim.new(0, 6))
	Create("UIStroke", {
		Color = theme.Border,
		Transparency = 0.8,
		Thickness = 1,
		Parent = container
	})
	Create("TextLabel", {
		Name = "ElementLabel",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(0.5, -10, 1, 0),
		Font = Enum.Font.Gotham,
		Text = name,
		TextColor3 = theme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = container
	})
	return container
end

local function AddTooltip(element, text)
	local tooltip = Create("TextLabel", {
		Name = "Tooltip",
		BackgroundColor3 = Themes.Dark.SecondaryBackground,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 100, 0, 20), -- Smaller size to prevent clipping
		Position = UDim2.new(0, 0, 1, 2), -- Adjusted position
		Font = Enum.Font.Gotham,
		Text = text,
		TextColor3 = Themes.Dark.Text,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		Visible = false,
		ZIndex = 99999, -- High ZIndex to ensure visibility
		Parent = element
	})
	Round(tooltip, UDim.new(0, 4))
	CreateShadow(tooltip, 0.5)
	element.MouseEnter:Connect(function() tooltip.Visible = true end)
	element.MouseLeave:Connect(function() tooltip.Visible = false end)
end

local Window = {}
Window.__index = Window

function Library:CreateWindow(config)
	config = config or {}
	local self = setmetatable({}, Window)

	self.Name = config.Name or "KavoUI Window"
	self.Theme = config.Themes or Themes.Dark
	self.SaveConfig = config.SaveConfig or false
	self.LoadConfig = config.LoadConfig or false
	self.ConfigFolder = config.ConfigFolder or "KavoUIConfigs"
	self.CloseBind = config.CloseBind or Enum.KeyCode.RightControl
	self.MinSize = config.MinSize or Vector2.new(400, 300)
	self.MaxSize = config.MaxSize or Vector2.new(800, 600)
	self.Language = config.Language or "en"
	self.Tabs = {}
	self.Flags = {}
	self.Connections = {}

	self.MainFrame = Create("Frame", {
		Name = "MainFrame",
		BackgroundColor3 = self.Theme.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, -330, 0.5, -230),
		Size = UDim2.new(0, 660, 0, 460),
		ClipsDescendants = true,
		Parent = AlexchadGui
	})
	Round(self.MainFrame, UDim.new(0, 10))
	CreateShadow(self.MainFrame)

	self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
	CreateTween(self.MainFrame, {Size = UDim2.new(0, 660, 0, 460)}, 0.3, Enum.EasingStyle.Sine)

	self.TitleBar = Create("Frame", {
		Name = "TitleBar",
		BackgroundColor3 = self.Theme.SecondaryBackground,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 44),
		Parent = self.MainFrame
	})
	Round(self.TitleBar, UDim.new(0, 10))
	Create("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = self.Theme.Border,
		Thickness = 1,
		Parent = self.TitleBar
	})

	self.TitleLabel = Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 0),
		Size = UDim2.new(0.5, -15, 1, 0),
		Font = Enum.Font.SourceSansBold,
		Text = self.Name,
		TextColor3 = self.Theme.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.TitleBar
	})

	self.CloseButton = Create("TextButton", {
		Name = "CloseButton",
		BackgroundColor3 = self.Theme.SecondaryBackground,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -15, 0.5, 0),
		Size = UDim2.new(0, 60, 0, 24),
		Font = Enum.Font.SourceSansBold,
		Text = Localization[self.Language].Close,
		TextColor3 = self.Theme.SecondaryText,
		TextSize = 16,
		Parent = self.TitleBar
	})
	Round(self.CloseButton, UDim.new(0.5, 0))

	self.CloseButton.MouseEnter:Connect(function()
		CreateTween(self.CloseButton, {BackgroundColor3 = self.Theme.Destructive, TextColor3 = self.Theme.Text}, 0.2)
	end)
	self.CloseButton.MouseLeave:Connect(function()
		CreateTween(self.CloseButton, {BackgroundColor3 = self.Theme.SecondaryBackground, TextColor3 = self.Theme.SecondaryText}, 0.2)
	end)
	self.CloseButton.MouseButton1Click:Connect(function()
		self:Destroy()
	end)

	self.ResizeHandle = Create("TextButton", {
		Name = "ResizeHandle",
		BackgroundColor3 = self.Theme.SecondaryBackground,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.new(0, 16, 0, 16),
		Text = "↔",
		TextColor3 = self.Theme.SecondaryText,
		TextSize = 10,
		Parent = self.MainFrame
	})
	Round(self.ResizeHandle, UDim.new(0.5, 0))

	self.TabContainer = Create("Frame", {
		Name = "TabContainer",
		BackgroundColor3 = self.Theme.SecondaryBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 44),
		Size = UDim2.new(0, 180, 1, -44),
		Parent = self.MainFrame
	})
	Create("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = self.Theme.Border,
		Thickness = 1,
		Parent = self.TabContainer
	})

	self.TabList = Create("ScrollingFrame", {
		Name = "TabList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 5, 0, 10),
		Size = UDim2.new(1, -10, 1, -20),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = self.Theme.Border,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = self.TabContainer
	})
	Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = self.TabList
	})

	self.ContentContainer = Create("Frame", {
		Name = "ContentContainer",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 180, 0, 44),
		Size = UDim2.new(1, -180, 1, -44),
		ClipsDescendants = false, -- Allow dropdown to render outside
		Parent = self.MainFrame
	})
	Round(self.ContentContainer, UDim.new(0, 10))

	self:SetupDragging()
	self:SetupResizing()

	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == self.CloseBind or input.KeyCode == Enum.KeyCode.Escape then
			self.MainFrame.Visible = not self.MainFrame.Visible
		end
	end))

	if self.LoadConfig and self.ConfigFolder then
		self:LoadConfiguration()
	end

	return self
end

function Window:SetTheme(newTheme)
	self.Theme = newTheme or Themes.Dark
	self.MainFrame.BackgroundColor3 = self.Theme.Background
	self.TitleBar.BackgroundColor3 = self.Theme.SecondaryBackground
	self.TitleLabel.TextColor3 = self.Theme.Text
	self.CloseButton.BackgroundColor3 = self.Theme.SecondaryBackground
	self.CloseButton.TextColor3 = self.Theme.SecondaryText
	self.TabContainer.BackgroundColor3 = self.Theme.SecondaryBackground
	self.TabList.ScrollBarImageColor3 = self.Theme.Border
	for _, tab in ipairs(self.Tabs) do
		tab.TabButton.BackgroundColor3 = tab.Active and self.Theme.Accent or self.Theme.TertiaryBackground
		tab.TabLabel.TextColor3 = tab.Active and self.Theme.Text or self.Theme.SecondaryText
		tab.Content.ScrollBarImageColor3 = self.Theme.Accent
	end
end

function Window:SetupDragging()
	local dragging, dragStart, startPos = false, nil, nil

	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.MainFrame.Position
			-- [ADD] Bring to front when dragging
			self.MainFrame.ZIndex = (self.MainFrame.ZIndex or 1) + 1
		end
	end)

	table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self.MainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end))

	-- [FIX] This was the incomplete dragging function
	table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end))
end

function Window:SetupResizing()
	local resizing, startPos, startSize = false, nil, nil

	self.ResizeHandle.MouseButton1Down:Connect(function()
		resizing = true
		startPos = Vector2.new(Mouse.X, Mouse.Y)
		startSize = self.MainFrame.Size
	end)

	table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - startPos
			local newSize = Vector2.new(
				math.clamp(startSize.X.Offset + delta.X, self.MinSize.X, self.MaxSize.X),
				math.clamp(startSize.Y.Offset + delta.Y, self.MinSize.Y, self.MaxSize.Y)
			)
			self.MainFrame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
		end
	end))

	table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end))
end

local Tab = {}
Tab.__index = Tab

function Window:CreateTab(config)
	config = config or {}
	local tab = setmetatable({}, Tab)

	tab.Name = config.Name or "Tab"
	tab.Icon = config.Icon
	tab.Window = self
	tab.Active = false

	tab.TabButton = Create("TextButton", {
		Name = tab.Name,
		BackgroundColor3 = self.Theme.TertiaryBackground,
		BorderSizePixel = 0,
		Size = UDim2.new(0.95, 0, 0, 35),
		Font = Enum.Font.Gotham,
		Text = "",
		Parent = self.TabList
	})
	Round(tab.TabButton, UDim.new(0, 6))

	tab.TabStroke = Create("UIStroke", {
		Color = self.Theme.Border,
		Transparency = 0.7,
		Thickness = 1,
		Parent = tab.TabButton
	})

	tab.TabLabel = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -20, 1, 0),
		Font = Enum.Font.Gotham,
		Text = tab.Name,
		TextColor3 = self.Theme.SecondaryText,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = tab.TabButton
	})

	tab.Content = Create("ScrollingFrame", {
		Name = tab.Name .. "Content",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0, 10),
		Size = UDim2.new(1, -20, 1, -20),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = self.Theme.Accent,
		Visible = false,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = self.ContentContainer
	})
	Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = tab.Content
	})

	tab.TabButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Return then
			self:SelectTab(tab)
		end
	end)
	tab.TabButton.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)
	AddHoverEffect(tab.TabButton, self.Theme.HoverAccent, self.Theme.TertiaryBackground)

	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end
	return tab
end

function Window:SelectTab(selectedTab)
	for _, tab in ipairs(self.Tabs) do
		local isSelected = (tab == selectedTab)
		tab.Active = isSelected
		tab.Content.Visible = isSelected
		local bgColor = isSelected and self.Theme.Accent or self.Theme.TertiaryBackground
		local textColor = isSelected and self.Theme.Text or self.Theme.SecondaryText
		local strokeTransparency = isSelected and 0.5 or 0.7
		CreateTween(tab.TabButton, {BackgroundColor3 = bgColor}, 0.2)
		CreateTween(tab.TabLabel, {TextColor3 = textColor}, 0.2)
		CreateTween(tab.TabStroke, {Transparency = strokeTransparency}, 0.2)
	end
end

function Tab:CreateButton(config)
	config = config or {}
	local name = config.Name or "Button"
	local callback = config.Callback or function() end
	local icon = config.Icon
	local disabled = config.Disabled or false
	local tooltip = config.Tooltip

	local buttonFrame = CreateElementContainer(self, name, 40)
	buttonFrame.ElementLabel.Size = UDim2.new(1, -120, 1, 0)

	local button = Create("TextButton", {
		Name = "Button",
		BackgroundColor3 = self.Window.Theme.Accent,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 90, 0, 30),
		Font = Enum.Font.Gotham,
		Text = Localization[self.Window.Language].Execute,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 13,
		Parent = buttonFrame
	})
	Round(button, UDim.new(0, 4))

	if icon then
		Create("ImageLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(0, 20, 0, 20),
			Image = icon,
			ImageColor3 = Color3.new(1, 1, 1),
			Parent = button
		})
		button.TextXAlignment = Enum.TextXAlignment.Right
	end
	if tooltip then
		AddTooltip(button, tooltip)
	end

	Create("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
		},
		Rotation = 90,
		Parent = button
	})
	AddHoverEffect(button, self.Window.Theme.SecondaryAccent, self.Window.Theme.Accent, disabled)

	button.MouseButton1Click:Connect(function()
		if not disabled then
			pcall(callback)
		end
	end)
	return {Frame = buttonFrame, Button = button, SetDisabled = function(state)
		disabled = state
		AddHoverEffect(button, self.Window.Theme.SecondaryAccent, self.Window.Theme.Accent, disabled)
	end}
end

function Tab:CreateToggle(config)
	config = config or {}
	local name = config.Name or "Toggle"
	local flag = config.Flag
	local save = config.Save or false
	local default = (flag and self.Window.Flags[flag] ~= nil) and self.Window.Flags[flag] or (config.Default or false)
	local callback = config.Callback or function() end
	local tooltip = config.Tooltip

	local toggleFrame = CreateElementContainer(self, name, 40)
	toggleFrame.ElementLabel.Size = UDim2.new(1, -70, 1, 0)

	local toggleButton = Create("TextButton", {
		Name = "ToggleButton",
		BackgroundColor3 = self.Window.Theme.TertiaryBackground,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 45, 0, 20),
		Text = "",
		Parent = toggleFrame
	})
	Round(toggleButton, UDim.new(0.5, 0))
	if tooltip then
		AddTooltip(toggleButton, tooltip)
	end
	Create("UIStroke", {
		Color = self.Window.Theme.Border,
		Transparency = 0.7,
		Thickness = 1,
		Parent = toggleButton
	})

	local toggleIndicator = Create("Frame", {
		Name = "Indicator",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(0, 16, 0, 16),
		Parent = toggleButton
	})
	Round(toggleIndicator, UDim.new(0.5, 0))

	local toggled = default

	local function updateToggle(isInit)
		local theme = self.Window.Theme
		local targetColor = toggled and theme.Accent or theme.TertiaryBackground
		local targetPos = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		if isInit then
			toggleButton.BackgroundColor3 = targetColor
			toggleIndicator.Position = targetPos
		else
			CreateTween(toggleButton, {BackgroundColor3 = targetColor}, 0.2, Enum.EasingStyle.Sine)
			CreateTween(toggleIndicator, {Position = targetPos}, 0.2, Enum.EasingStyle.Sine)
		end
		pcall(callback, toggled)
		if flag then
			self.Window.Flags[flag] = toggled
			if save and self.Window.SaveConfig then
				self.Window:SaveConfiguration()
			end
		end
	end

	toggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		updateToggle(false)
	end)
	updateToggle(true)

	return {
		Frame = toggleFrame,
		Toggle = toggleButton,
		SetValue = function(val)
			toggled = val
			updateToggle(false)
		end
	}
end

function Tab:CreateSlider(config)
	config = config or {}
	local name = config.Name or "Slider"
	local minVal, maxVal = config.Min or 0, config.Max or 100
	local increment = config.Increment or 1
	local flag = config.Flag
	local save = config.Save or false
	local format = config.Format or "%d"
	local default = (flag and self.Window.Flags[flag] ~= nil) and self.Window.Flags[flag] or (config.Default or minVal)
	local callback = config.Callback or function() end
	local tooltip = config.Tooltip

	local sliderFrame = CreateElementContainer(self, name, 60)
	sliderFrame.ElementLabel.Position = UDim2.new(0, 10, 0, 5)
	sliderFrame.ElementLabel.Size = UDim2.new(0.5, -10, 0, 20)

	local valueLabel = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 5),
		Size = UDim2.new(0.5, -10, 0, 20),
		Font = Enum.Font.Gotham,
		TextColor3 = self.Window.Theme.SecondaryText,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = sliderFrame
	})
	if tooltip then
		AddTooltip(sliderFrame, tooltip)
	end

	local sliderBar = Create("Frame", {
		Name = "SliderBar",
		BackgroundColor3 = self.Window.Theme.TertiaryBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0, 35),
		Size = UDim2.new(1, -20, 0, 6),
		Parent = sliderFrame
	})
	Round(sliderBar, UDim.new(0.5, 0))

	local sliderFill = Create("Frame", {
		Name = "Fill",
		BackgroundColor3 = self.Window.Theme.Accent,
		BorderSizePixel = 0,
		Parent = sliderBar
	})
	Round(sliderFill, UDim.new(0.5, 0))

	local sliderButton = Create("TextButton", {
		Name = "SliderButton",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 16, 0, 16),
		Text = "",
		Parent = sliderBar
	})
	Round(sliderButton, UDim.new(0.5, 0))
	Create("UIStroke", {
		Color = self.Window.Theme.Shadow,
		Transparency = 0.5,
		Thickness = 2,
		Parent = sliderButton
	})

	local value = default
	local dragging = false

	local function updateSliderVisuals(newValue, isInit)
		value = math.clamp(newValue, minVal, maxVal)
		local percentage = (value - minVal) / (maxVal - minVal)
		sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		sliderButton.Position = UDim2.new(percentage, 0, 0.5, 0)
		valueLabel.Text = string.format(format, value)
		if not isInit then
			pcall(callback, value)
		end
		if flag then
			self.Window.Flags[flag] = value
			if save and self.Window.SaveConfig and not isInit then
				self.Window:SaveConfiguration()
			end
		end
	end

	local function calculateValueFromPercentage(percentage)
		local rawValue = minVal + (maxVal - minVal) * percentage
		return math.floor(rawValue / increment + 0.5) * increment
	end

	local function handleInput(input)
		local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		local newValue = calculateValueFromPercentage(pos)
		updateSliderVisuals(newValue, false)
	end

	sliderButton.MouseButton1Down:Connect(function() dragging = true end)
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			handleInput(input)
		end
	end)
	table.insert(self.Window.Connections, UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			handleInput(input)
		end
	end))
	table.insert(self.Window.Connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end))
	updateSliderVisuals(default, true)

	return {
		Frame = sliderFrame,
		SetValue = function(val)
			updateSliderVisuals(val, false)
		end
	}
end

function Tab:CreateDropdown(config)
	config = config or {}
	local name = config.Name or "Dropdown"
	local options = config.Options or {}
	local callback = config.Callback or function() end
	local save = config.Save or false
	local flag = config.Flag
	local multiSelect = config.MultiSelect or false
	local default = (flag and self.Window.Flags[flag]) or config.Default or (multiSelect and {} or options[1] or "")
	local tooltip = config.Tooltip

	local dropdownFrame = CreateElementContainer(self, name, 40)
	dropdownFrame.ElementLabel.Size = UDim2.new(0.4, -10, 1, 0)
	dropdownFrame.ClipsDescendants = false -- Prevent clipping of dropdown list

	local dropdownButton = Create("TextButton", {
		Name = "DropdownButton",
		BackgroundColor3 = self.Window.Theme.TertiaryBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0.4, 0, 0.5, -15),
		Size = UDim2.new(0.6, -10, 0, 30),
		Font = Enum.Font.Gotham,
		Text = multiSelect and table.concat(default, ", ") or default,
		TextColor3 = self.Window.Theme.Text,
		TextSize = 13,
		ZIndex = 10, -- Higher ZIndex for visibility
		Parent = dropdownFrame
	})
	Round(dropdownButton, UDim.new(0, 4))
	if tooltip then
		AddTooltip(dropdownButton, tooltip)
	end

	local dropdownIcon = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -25, 0, 0),
		Size = UDim2.new(0, 25, 1, 0),
		Font = Enum.Font.Gotham,
		Text = "▼",
		TextColor3 = self.Window.Theme.SecondaryText,
		TextSize = 10,
		ZIndex = 10,
		Parent = dropdownButton
	})

	local dropdownList = Create("Frame", {
		Name = "DropdownList",
		BackgroundColor3 = self.Window.Theme.SecondaryBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 2), -- Adjusted to align with button
		Size = UDim2.new(1, 0, 0, 0),
		Visible = false,
		ZIndex = 15, -- Higher ZIndex to appear above content
		Parent = dropdownButton
	})
	Round(dropdownList, UDim.new(0, 4))
	CreateShadow(dropdownList, 0.5)
	Create("UIStroke", {
		Color = self.Window.Theme.Border,
		Transparency = 0.7,
		Thickness = 1,
		Parent = dropdownList
	})
	Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = dropdownList
	})

	local selected = multiSelect and table.clone(default) or default
	local expanded = false

	local function updateDropdown(newValue, isInit)
		selected = newValue
		dropdownButton.Text = multiSelect and table.concat(selected, ", ") or newValue
		if not isInit then
			pcall(callback, selected)
		end
		if flag then
			self.Window.Flags[flag] = selected
			if save and self.Window.SaveConfig and not isInit then
				self.Window:SaveConfiguration()
			end
		end
	end

	local function toggleDropdown()
		expanded = not expanded
		local targetHeight = expanded and (#options * 30 + (multiSelect and 40 or 0)) or 0
		if expanded then
			dropdownList.Visible = true
			CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2)
			CreateTween(dropdownIcon, {Rotation = 180}, 0.2)
		else
			CreateTween(dropdownIcon, {Rotation = 0}, 0.2)
			local tweenOut = CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
			tweenOut.Completed:Connect(function()
				dropdownList.Visible = false
			end)
		end
	end

	dropdownButton.MouseButton1Click:Connect(toggleDropdown)

	if multiSelect then
		local searchBox = Create("TextBox", {
			Name = "SearchBox",
			BackgroundColor3 = self.Window.Theme.TertiaryBackground,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -10, 0, 30),
			Position = UDim2.new(0, 5, 0, 5),
			Font = Enum.Font.Gotham,
			PlaceholderText = "Search...",
			Text = "",
			TextColor3 = self.Window.Theme.Text,
			TextSize = 13,
			ZIndex = 15,
			Parent = dropdownList
		})
		Round(searchBox, UDim.new(0, 4))
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local searchText = searchBox.Text:lower()
			for _, optionButton in ipairs(dropdownList:GetChildren()) do
				if optionButton:IsA("TextButton") then
					optionButton.Visible = optionButton.Text:lower():find(searchText) ~= nil
				end
			end
		end)
	end

	for _, option in ipairs(options) do
		local optionButton = Create("TextButton", {
			Name = option,
			BackgroundColor3 = self.Window.Theme.SecondaryBackground,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			Font = Enum.Font.Gotham,
			Text = option,
			TextColor3 = self.Window.Theme.SecondaryText,
			TextSize = 13,
			ZIndex = 15,
			Parent = dropdownList
		})
		AddHoverEffect(optionButton, self.Window.Theme.TertiaryBackground, self.Window.Theme.SecondaryBackground)
		optionButton.MouseButton1Click:Connect(function()
			if multiSelect then
				if table.find(selected, option) then
					table.remove(selected, table.find(selected, option))
				else
					table.insert(selected, option)
				end
				updateDropdown(selected, false)
			else
				toggleDropdown()
				updateDropdown(option, false)
			end
		end)
	end

	updateDropdown(default, true)
	return {
		Frame = dropdownFrame,
		SetValue = function(val)
			updateDropdown(val, false)
		end
	}
end

function Tab:CreateTextbox(config)
	config = config or {}
	local name = config.Name or "Textbox"
	local placeholderText = config.PlaceholderText or "Enter text..."
	local clearOnFocusLost = config.RemoveTextAfterFocusLost or false
	local callback = config.Callback or function() end
	local validate = config.Validate or function(text) return true end
	local maxLength = config.MaxLength or math.huge
	local tooltip = config.Tooltip

	local textboxFrame = CreateElementContainer(self, name, 40)
	local frameStroke = textboxFrame:FindFirstChildOfClass("UIStroke")
	textboxFrame.ElementLabel.Size = UDim2.new(0.35, -10, 1, 0)

	local textbox = Create("TextBox", {
		Name = "Textbox",
		BackgroundColor3 = self.Window.Theme.TertiaryBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0.35, 0, 0.5, -15),
		Size = UDim2.new(0.65, -10, 0, 30),
		Font = Enum.Font.Gotham,
		PlaceholderText = placeholderText,
		PlaceholderColor3 = self.Window.Theme.SecondaryText,
		Text = "",
		TextColor3 = self.Window.Theme.Text,
		TextSize = 13,
		Parent = textboxFrame
	})
	Round(textbox, UDim.new(0, 4))
	if tooltip then
		AddTooltip(textbox, tooltip)
	end

	textbox.Focused:Connect(function()
		CreateTween(frameStroke, {Color = self.Window.Theme.Accent, Transparency = 0.5}, 0.2)
	end)
	textbox.FocusLost:Connect(function(enterPressed)
		CreateTween(frameStroke, {Color = self.Window.Theme.Border, Transparency = 0.8}, 0.2)
		if enterPressed and validate(textbox.Text) then
			pcall(callback, textbox.Text)
			if clearOnFocusLost then
				textbox.Text = ""
			end
		elseif enterPressed then
			Library:Notify({
				Title = Localization[self.Window.Language].Error,
				Content = "Invalid input",
				Type = "Error",
				Duration = 3
			})
		end
	end)
	textbox:GetPropertyChangedSignal("Text"):Connect(function()
		if #textbox.Text > maxLength then
			textbox.Text = textbox.Text:sub(1, maxLength)
		end
	end)

	return {Frame = textboxFrame, Textbox = textbox}
end

function Tab:CreateColorPicker(config)
	config = config or {}
	local name = config.Name or "ColorPicker"
	local default = config.Default or Color3.new(1, 1, 1)
	local callback = config.Callback or function() end
	local flag = config.Flag
	local save = config.Save or false
	local tooltip = config.Tooltip

	local colorPickerFrame = CreateElementContainer(self, name, 100)
	colorPickerFrame.ElementLabel.Size = UDim2.new(0.5, -10, 0, 20)

	local preview = Create("Frame", {
		Name = "Preview",
		BackgroundColor3 = default,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -50, 0, 10),
		Size = UDim2.new(0, 40, 0, 20),
		Parent = colorPickerFrame
	})
	Round(preview, UDim.new(0, 4))

	local pickerButton = Create("TextButton", {
		Name = "PickerButton",
		BackgroundColor3 = self.Window.Theme.TertiaryBackground,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0, 40),
		Size = UDim2.new(1, -20, 0, 50),
		Text = "",
		Parent = colorPickerFrame
	})
	Round(pickerButton, UDim.new(0, 4))
	if tooltip then
		AddTooltip(pickerButton, tooltip)
	end

	local hueBar = Create("Frame", {
		Name = "HueBar",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 5, 0, 5),
		Size = UDim2.new(1, -10, 0, 10),
		Parent = pickerButton
	})
	Round(hueBar, UDim.new(0.5, 0))
	Create("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
		},
		Parent = hueBar
	})

	local colorArea = Create("ImageLabel", {
		Name = "ColorArea",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 5, 0, 20),
		Size = UDim2.new(1, -10, 0, 25),
		Image = "rbxassetid://698052001",
		Parent = pickerButton
	})
	Round(colorArea, UDim.new(0, 4))

	local hueSlider = Create("TextButton", {
		Name = "HueSlider",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 10, 0, 14),
		Text = "",
		Parent = hueBar
	})
	Round(hueSlider, UDim.new(0.5, 0))

	local colorSelector = Create("TextButton", {
		Name = "ColorSelector",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 8, 0, 8),
		Text = "",
		Parent = colorArea
	})
	Round(colorSelector, UDim.new(0.5, 0))

	local h, s, v = default:ToHSV()
	local selectedColor = default

	local function updateColor(isInit)
		preview.BackgroundColor3 = selectedColor
		if not isInit then
			pcall(callback, selectedColor)
		end
		if flag then
			self.Window.Flags[flag] = selectedColor
			if save and self.Window.SaveConfig and not isInit then
				self.Window:SaveConfiguration()
			end
		end
	end

	local function updatePicker()
		hueSlider.Position = UDim2.new(h, 0, 0.5, 0)
		colorArea.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		colorSelector.Position = UDim2.new(s, 0, 1 - v, 0)
		selectedColor = Color3.fromHSV(h, s, v)
		updateColor(false)
	end

	hueBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local pos = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
			h = pos
			updatePicker()
		end
	end)
	colorArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local x = math.clamp((input.Position.X - colorArea.AbsolutePosition.X) / colorArea.AbsoluteSize.X, 0, 1)
			local y = math.clamp((input.Position.Y - colorArea.AbsolutePosition.Y) / colorArea.AbsoluteSize.Y, 0, 1)
			s = x
			v = 1 - y
			updatePicker()
		end
	end)
	updateColor(true)

	return {
		Frame = colorPickerFrame,
		SetValue = function(color)
			h, s, v = color:ToHSV()
			updatePicker()
		end
	}
end

local Notifications = {}
local Queue = {}
local MaxNotifications = 40

local function Restack()
	local screenPadding, spacing = 20, 10
	local currentY = screenPadding
	for _, notif in ipairs(Notifications) do
		local targetYOffset = -(currentY)
		CreateTween(notif, {Position = UDim2.new(1, -10, 1, targetYOffset)}, 0.25, Enum.EasingStyle.Quint)
		currentY += notif.AbsoluteSize.Y + spacing
	end
end

local function ShowNotification(config)
	local notifType = config.Type or "Info"
	local title = config.Title or Localization[config.Language or "en"][notifType] or "Notification"
	local bgColor = notifType == "Success" and Themes.Dark.Success or
		notifType == "Error" and Themes.Dark.Destructive or
		notifType == "Warning" and Themes.Dark.Warning or
		Themes.Dark.SecondaryBackground

	local notification = Create("Frame", {
		Name = "Notification",
		BackgroundColor3 = bgColor,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 300, 0, 80),
		AnchorPoint = Vector2.new(1, 1),
		ClipsDescendants = true,
		Position = UDim2.new(1, 310, 1, -20),
		Parent = AlexchadGui
	})
	Round(notification, UDim.new(0, 8))
	CreateShadow(notification)
	Create("UIStroke", {
		Color = Themes.Dark.Accent,
		Transparency = 0.5,
		Thickness = 2,
		Parent = notification
	})

	Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 10),
		Size = UDim2.new(1, -30, 0, 20),
		Font = Enum.Font.GothamBold,
		Text = title,
		TextColor3 = Themes.Dark.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = notification
	})
	Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 35),
		Size = UDim2.new(1, -30, 0, 30),
		Font = Enum.Font.Gotham,
		Text = config.Content or "",
		TextColor3 = Themes.Dark.SecondaryText,
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = notification
	})

	if config.Action then
		local actionButton = Create("TextButton", {
			BackgroundColor3 = Themes.Dark.Accent,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -70, 0, 50),
			Size = UDim2.new(0, 60, 0, 20),
			Font = Enum.Font.Gotham,
			Text = config.Action.Text or "OK",
			TextColor3 = Themes.Dark.Text,
			TextSize = 12,
			Parent = notification
		})
		Round(actionButton, UDim.new(0, 4))
		AddHoverEffect(actionButton, Themes.Dark.SecondaryAccent, Themes.Dark.Accent)
		actionButton.MouseButton1Click:Connect(function()
			pcall(config.Action.Callback)
			notification:Destroy()
			local index = table.find(Notifications, notification)
			if index then
				table.remove(Notifications, index)
			end
			Restack()
		end)
	end

	table.insert(Notifications, 1, notification)
	Restack()
	task.wait(config.Duration or 5)
	local tweenOut = CreateTween(notification, {
		Position = UDim2.new(1, 310, notification.Position.Y.Scale, notification.Position.Y.Offset),
		BackgroundTransparency = 1
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
	if #Notifications >= MaxNotifications then
		task.wait(0.1)
		return
	end
	local config = table.remove(Queue, 1)
	if config then
		task.spawn(ShowNotification, config)
	end
end

function Library:Notify(config)
	table.insert(Queue, config)
	task.spawn(ProcessQueue)
end

local SUPPORTS_FILE_IO = type(writefile) == "function" and type(readfile) == "function" and type(isfolder) == "function"

function Window:SaveConfiguration(profile)
	if not self.ConfigFolder or not SUPPORTS_FILE_IO then return end
	local filePath = self.ConfigFolder .. (profile and ("/" .. profile .. ".json") or "/config.json")
	local configData = HttpService:JSONEncode(self.Flags)
	local success, err = pcall(function()
		if not isfolder(self.ConfigFolder) and makefolder then
			makefolder(self.ConfigFolder)
		end
		writefile(filePath, configData)
	end)
	if not success then
		Library:Notify({
			Title = Localization[self.Language].Error,
			Content = "Failed to save configuration: " .. tostring(err),
			Type = "Error",
			Duration = 5
		})
	end
end

function Window:LoadConfiguration(profile)
	if not self.ConfigFolder or not SUPPORTS_FILE_IO then return end
	local filePath = self.ConfigFolder .. (profile and ("/" .. profile .. ".json") or "/config.json")
	local success, result = pcall(function()
		if isfile(filePath) then
			return HttpService:JSONDecode(readfile(filePath))
		end
	end)
	if success and type(result) == "table" then
		for flag, value in pairs(result) do
			self.Flags[flag] = value
		end
	elseif not success then
		Library:Notify({
			Title = Localization[self.Language].Error,
			Content = "Failed to load configuration: " .. tostring(result),
			Type = "Error",
			Duration = 5
		})
	end
end

function Window:Destroy()
	if self.SaveConfig then
		self:SaveConfiguration()
	end
	CreateTween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Sine).Completed:Wait()
	for _, connection in ipairs(self.Connections) do
		if connection and connection.Connected then
			connection:Disconnect()
		end
	end
	self.Connections = {}
	if self.MainFrame then
		self.MainFrame:Destroy()
	end
end

return Library
