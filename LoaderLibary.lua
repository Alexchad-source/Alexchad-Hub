-- Alexchad LoaderLib v1.0
local LoaderLib = {}

-- ============ Configuration Defaults ============
LoaderLib.Config = {
    FolderName = "Alexchad Hub",  -- Folder where scripts will be saved
    VersionFileName = "version.txt", -- File to store version info
    BaseURL = "",                  -- Base URL to fetch scripts (required)
    FallbackURL = "",              -- URL to universal fallback script (required)
    PlaceScripts = {},             -- Table mapping PlaceId => Filename
    LocalVersion = "1.0"           -- Loader version (for auto-update)
}

-- ============ Executor Support Check ============
LoaderLib.HasFileSystem = type(isfolder) == "function"
    and type(makefolder) == "function"
    and type(writefile) == "function"
    and type(readfile) == "function"
    and type(delfile) == "function"

-- ============ Helper Functions ============
function LoaderLib:SafeHttpGet(url)
    local ok, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    return ok and res or nil
end

function LoaderLib:EnsureFolder()
    if self.HasFileSystem and not isfolder(self.Config.FolderName) then
        makefolder(self.Config.FolderName)
    end
end

function LoaderLib:FileExists(path)
    if self.HasFileSystem then
        local ok, _ = pcall(readfile, path)
        return ok
    end
    return false
end

function LoaderLib:ReadFile(path)
    if self.HasFileSystem then
        local ok, content = pcall(readfile, path)
        if ok then return content end
    end
    return nil
end

function LoaderLib:WriteFile(path, content)
    if self.HasFileSystem then
        writefile(path, content)
    end
end

function LoaderLib:DeleteFile(path)
    if self.HasFileSystem and self:FileExists(path) then
        delfile(path)
    end
end

-- ============ Version Handling ============
function LoaderLib:GetLocalVersion()
    local path = self.Config.FolderName .. "/" .. self.Config.VersionFileName
    local content = self:ReadFile(path)
    return content or "0.0"
end

function LoaderLib:IsNewerVersion(localVer, remoteVer)
    local function toNumber(v)
        local major, minor = string.match(v, "(%d+)%.(%d+)")
        return tonumber(major) * 1000 + tonumber(minor)
    end
    return toNumber(remoteVer) > toNumber(localVer)
end

function LoaderLib:UpdateAllScripts(remoteVersion)
    print("[LoaderLib] Updating all cached scripts to version " .. remoteVersion)
    -- Clear folder
    for id, filename in pairs(self.Config.PlaceScripts) do
        self:DeleteFile(self.Config.FolderName .. "/" .. filename)
    end
    self:DeleteFile(self.Config.FolderName .. "/" .. self.Config.VersionFileName)
    self:WriteFile(self.Config.FolderName .. "/" .. self.Config.VersionFileName, remoteVersion)
end

-- ============ Main Loading Logic ============
function LoaderLib:LoadScript(url, localPath)
    local content = self:ReadFile(localPath)
    if not content then
        content = self:SafeHttpGet(url)
        if content then
            self:WriteFile(localPath, content)
        end
    end
    return content
end

function LoaderLib:RunScript(code)
    local ok, err = pcall(loadstring(code))
    if not ok then
        warn("[LoaderLib] Script execution error: " .. tostring(err))
    end
end

function LoaderLib:Run()
    self:EnsureFolder()

    -- Check version
    local localVersion = self:GetLocalVersion()
    local remoteVersion = self.Config.LocalVersion -- You can make this dynamic from a remote version file if needed

    if self:IsNewerVersion(localVersion, remoteVersion) then
        self:UpdateAllScripts(remoteVersion)
    else
        print("[LoaderLib] Local version is up-to-date.")
    end

    -- Load universal first
    local universalPath = self.Config.FolderName .. "/universial.lua"
    local universalScript = self:LoadScript(self.Config.FallbackURL, universalPath)
    if universalScript then
        self:RunScript(universalScript)
    else
        warn("[LoaderLib] Failed to load universal script.")
    end

    -- Load place-specific
    local placeId = game.PlaceId
    local fileName = self.Config.PlaceScripts[placeId]
    if fileName then
        local url = self.Config.BaseURL .. fileName
        local localPath = self.Config.FolderName .. "/" .. fileName
        local script = self:LoadScript(url, localPath)
        if script then
            self:RunScript(script)
        else
            warn("[LoaderLib] Failed to load place script.")
        end
    else
        print("[LoaderLib] No specific script for this PlaceId.")
    end
end

return LoaderLib
