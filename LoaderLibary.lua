-- Universal Roblox LoaderLib v1.2
-- A flexible loader library to handle script loading, versioning, caching, and updating

local LoaderLib = {}

-- ======================
-- === CONFIGURATION ===
-- ======================
LoaderLib.Config = {
    FolderName = "MyLoaderCache",       -- Folder where scripts and versions are stored locally
    VersionFileName = "loader.version", -- File that stores the loader's current version string
    UniversalScriptFile = "universal.lua", -- Filename for the universal bootstrap script
    UniversalScriptURL = "",              -- URL to download universal script (set by user)
    BaseURL = "",                        -- Base URL for game-specific scripts (set by user)
    CurrentVersion = "1.0",              -- Current loader version in number.number format
    VersionCheckEnabled = true,          -- Whether to check for loader updates from remote
    MaxVersionLength = 4,                -- Max length of version string (like "2.3")
    HttpTimeout = 10,                    -- Max timeout for HTTP requests (seconds)
}

-- ======================
-- === INTERNAL STATE ===
-- ======================
LoaderLib.Scripts = {}   -- Maps PlaceId => Filename (to be registered via RegisterScripts)
LoaderLib.HasFileSystem = false
LoaderLib.HasHttp = false
LoaderLib.HttpService = game:GetService("HttpService")
LoaderLib.Players = game:GetService("Players")

-- ======================
-- === UTILITIES ===
-- ======================

-- Checks if executor supports filesystem features
function LoaderLib:CheckFileSystemSupport()
    self.HasFileSystem = (type(isfolder) == "function" and
                         type(makefolder) == "function" and
                         type(writefile) == "function" and
                         type(readfile) == "function" and
                         type(delfile) == "function" and
                         type(listfiles) == "function")
    return self.HasFileSystem
end

-- Checks if HTTP requests are supported
function LoaderLib:CheckHttpSupport()
    self.HasHttp = pcall(function()
        return game:HttpGetAsync or game:HttpGet
    end)
    return self.HasHttp
end

-- Safe HTTP GET with error handling and timeout
function LoaderLib:SafeHttpGet(url)
    if not self.HasHttp then return nil end
    local ok, res = pcall(function()
        if game.HttpGetAsync then
            return game:HttpGetAsync(url, true)
        elseif game.HttpGet then
            return game:HttpGet(url, true)
        else
            return nil
        end
    end)
    if ok and type(res) == "string" and #res > 0 then
        return res
    end
    return nil
end

-- Wait for game fully loaded
function LoaderLib:WaitForGameLoad()
    if game:IsLoaded() then return end
    game.Loaded:Wait()
end

-- Wait for local player object to exist
function LoaderLib:WaitForLocalPlayer()
    if self.Players.LocalPlayer then return self.Players.LocalPlayer end
    return self.Players.PlayerAdded:Wait()
end

-- Validate version string format (number.number)
function LoaderLib:IsValidVersion(ver)
    if type(ver) ~= "string" then return false end
    if #ver > self.Config.MaxVersionLength then return false end
    return ver:match("^%d+%.%d+$") ~= nil
end

-- Return true if version2 > version1 (numeric comparison)
function LoaderLib:IsNewerVersion(v1, v2)
    if not (self:IsValidVersion(v1) and self:IsValidVersion(v2)) then return false end
    local n1, n2 = tonumber(v1), tonumber(v2)
    return n2 > n1
end

-- Ensure folder exists or create it if possible
function LoaderLib:EnsureFolder()
    if not self.HasFileSystem then return false end
    if not isfolder(self.Config.FolderName) then
        makefolder(self.Config.FolderName)
    end
    return true
end

-- Check if file exists locally
function LoaderLib:FileExists(path)
    if not self.HasFileSystem then return false end
    local ok = pcall(readfile, path)
    return ok
end

-- Write content to file safely
function LoaderLib:WriteFile(path, content)
    if not self.HasFileSystem then return false end
    local ok, err = pcall(function() writefile(path, content) end)
    return ok
end

-- Read file content safely
function LoaderLib:ReadFile(path)
    if not self.HasFileSystem then return nil end
    local ok, content = pcall(readfile, path)
    if ok then return content end
    return nil
end

-- Delete file safely
function LoaderLib:DeleteFile(path)
    if not self.HasFileSystem then return false end
    local ok, err = pcall(function() delfile(path) end)
    return ok
end

-- Delete all cached files in folder (including version file)
function LoaderLib:ClearCache()
    if not self.HasFileSystem then return end
    local files = listfiles(self.Config.FolderName)
    for _, file in pairs(files) do
        delfile(file)
    end
end

-- Load script from local cache or download and cache
function LoaderLib:LoadScript(fileName)
    local localPath = self.Config.FolderName .. "/" .. fileName
    local scriptContent = nil

    if self:FileExists(localPath) then
        scriptContent = self:ReadFile(localPath)
    else
        if self.HasHttp and self.Config.BaseURL ~= "" then
            local url = self.Config.BaseURL .. fileName
            scriptContent = self:SafeHttpGet(url)
            if scriptContent and self.HasFileSystem then
                self:WriteFile(localPath, scriptContent)
            end
        end
    end

    -- fallback: direct HTTP fetch if no FS or file missing
    if not scriptContent and self.HasHttp and self.Config.BaseURL ~= "" then
        local url = self.Config.BaseURL .. fileName
        scriptContent = self:SafeHttpGet(url)
    end

    return scriptContent
end

-- Run lua code safely
function LoaderLib:RunScript(code, scriptName)
    if type(code) ~= "string" then return false end
    local ok, err = pcall(function()
        loadstring(code)()
    end)
    if not ok then
        warn("[LoaderLib] Failed to run '" .. tostring(scriptName) .. "': " .. tostring(err))
        return false
    end
    return true
end

-- Load version string from local version file
function LoaderLib:ReadLocalVersion()
    local versionPath = self.Config.FolderName .. "/" .. self.Config.VersionFileName
    local ver = self:ReadFile(versionPath)
    if ver and self:IsValidVersion(ver) then
        return ver
    end
    return nil
end

-- Write current loader version to local version file
function LoaderLib:WriteLocalVersion()
    local versionPath = self.Config.FolderName .. "/" .. self.Config.VersionFileName
    self:WriteFile(versionPath, self.Config.CurrentVersion)
end

-- Check remote version and update loader if newer
function LoaderLib:CheckAndUpdateLoader()
    if not self.Config.VersionCheckEnabled or not self.HasHttp or not self.HasFileSystem then
        return
    end
    if self.Config.BaseURL == "" then
        warn("[LoaderLib] BaseURL not set, skipping version check")
        return
    end

    local remoteVersionURL = self.Config.BaseURL .. self.Config.VersionFileName
    local remoteVer = self:SafeHttpGet(remoteVersionURL)
    if remoteVer and self:IsValidVersion(remoteVer) then
        local localVer = self:ReadLocalVersion()
        if localVer == nil or self:IsNewerVersion(localVer, remoteVer) then
            print("[LoaderLib] New loader version detected (" .. remoteVer .. "). Clearing cache and updating...")
            self:ClearCache()
            self:WriteFile(self.Config.FolderName .. "/" .. self.Config.VersionFileName, remoteVer)
            -- Optional: You could trigger an automatic restart or re-download here
        end
    end
end

-- Register game-specific scripts (PlaceId => Filename)
function LoaderLib:RegisterScripts(scriptsTable)
    for placeId, fileName in pairs(scriptsTable) do
        self.Scripts[placeId] = fileName
    end
end

-- Main execution flow of loader
function LoaderLib:Run()
    self:CheckFileSystemSupport()
    self:CheckHttpSupport()

    self:WaitForGameLoad()
    self:WaitForLocalPlayer()

    self:EnsureFolder()

    self:CheckAndUpdateLoader()

    -- Load and run universal script first
    if self.Config.UniversalScriptURL == "" then
        warn("[LoaderLib] UniversalScriptURL not set, skipping universal script load.")
    else
        local universalPath = self.Config.FolderName .. "/" .. self.Config.UniversalScriptFile
        local universalScript = nil

        if self:FileExists(universalPath) then
            universalScript = self:ReadFile(universalPath)
        else
            universalScript = self:LoadScript(self.Config.UniversalScriptFile)
        end

        if universalScript then
            self:RunScript(universalScript, "Universal Script")
        else
            warn("[LoaderLib] Failed to load Universal Script.")
        end
    end

    -- Load and run game-specific script if registered for this place
    local placeId = tostring(game.PlaceId)
    local gameScriptFile = self.Scripts[placeId]
    if gameScriptFile then
        local gameScript = self:LoadScript(gameScriptFile)
        if gameScript then
            self:RunScript(gameScript, "Game Script for PlaceId " .. placeId)
        else
            warn("[LoaderLib] Failed to load Game Script for PlaceId " .. placeId)
        end
    else
        print("[LoaderLib] No registered game script for PlaceId " .. placeId)
    end
end

-- Expose the LoaderLib
return LoaderLib
