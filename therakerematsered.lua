local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage") -- Stores objects replicated to clients and server
local ServerScriptService = game:GetService("ServerScriptService") -- Manages server-side scripts
local ServerStorage = game:GetService("ServerStorage") -- Stores server-only assets
local StarterGui = game:GetService("StarterGui") -- Manages initial GUI elements for players
local StarterPlayer = game:GetService("StarterPlayer") -- Configures default player settings
local StarterPack = game:GetService("StarterPack") -- Manages default player inventory items
local Players = game:GetService("Players") -- Handles player instances and properties
local Workspace = game:GetService("Workspace") -- Represents the 3D game world
local Lighting = game:GetService("Lighting") -- Controls lighting and atmosphere effects
local SoundService = game:GetService("SoundService") -- Manages global audio playback
local Chat = game:GetService("Chat") -- Handles in-game chat functionality
local Teams = game:GetService("Teams") -- Manages team-based gameplay
local MarketplaceService = game:GetService("MarketplaceService") -- Handles in-game purchases and product info
local DataStoreService = game:GetService("DataStoreService") -- Saves and retrieves persistent data
local HttpService = game:GetService("HttpService") -- Enables HTTP requests for external APIs
local RunService = game:GetService("RunService") -- Manages game loop and heartbeat events
local UserInputService = game:GetService("UserInputService") -- Detects player input (keyboard, mouse, etc.)
local TweenService = game:GetService("TweenService") -- Creates smooth animations for properties
local PathfindingService = game:GetService("PathfindingService") -- Handles NPC pathfinding
local PhysicsService = game:GetService("PhysicsService") -- Manages collision groups and physics
local CollectionService = game:GetService("CollectionService") -- Tags and manages groups of objects
local ContextActionService = game:GetService("ContextActionService") -- Binds actions to inputs
local ContentProvider = game:GetService("ContentProvider") -- Loads and caches assets
local Debris = game:GetService("Debris") -- Manages temporary objects for cleanup
local GuiService = game:GetService("GuiService") -- Handles GUI-related functionality
local HapticService = game:GetService("HapticService") -- Controls device vibration feedback
local InsertService = game:GetService("InsertService") -- Loads assets into the game
local LocalizationService = game:GetService("LocalizationService") -- Supports multi-language features
local MessagingService = game:GetService("MessagingService") -- Enables cross-server communication
local NotificationService = game:GetService("NotificationService") -- Sends notifications to players
local PolicyService = game:GetService("PolicyService") -- Checks regional policies for content
local ReplicatedFirst = game:GetService("ReplicatedFirst") -- Stores assets loaded first for clients
local TextService = game:GetService("TextService") -- Handles text rendering and filtering
local VoiceChatService = game:GetService("VoiceChatService") -- Manages voice chat functionality
local AnalyticsService = game:GetService("AnalyticsService") -- Tracks game analytics
local AssetService = game:GetService("AssetService") -- Manages asset loading and permissions
local BadgeService = game:GetService("BadgeService") -- Handles badge creation and awarding
local GamePassService = game:GetService("GamePassService") -- Manages game pass functionality
local MemoryStoreService = game:GetService("MemoryStoreService") -- Temporary in-memory data storage
local TeleportService = game:GetService("TeleportService") -- Handles player teleportation between places
local VirtualInputManager = game:GetService("VirtualInputManager") -- Simulates user input for testing
local VirtualUser = game:GetService("VirtualUser") -- Simulates user actions for testing


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




