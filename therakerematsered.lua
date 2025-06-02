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
local Main = Window:CreateTab("Main", 4483362458)
-------------------------------------------------
-- MOUSE UNLOCK
-------------------------------------------------
Main:CreateToggle({
    Name = "Unlock Mouse",
    CurrentValue = false,
    Callback = function(v)
        if v then
            -- Allow free mouse movement & show cursor
            UserInput.MouseBehavior = Enum.MouseBehavior.Default
            UserInput.MouseIconEnabled = true
        else
            -- Re-lock cursor to center & hide default icon
            UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
            UserInput.MouseIconEnabled = false
        end
    end,
})
local original = {}

Main:CreateToggle({
	Name = "Full Bright",
	CurrentValue = false,
	Callback = function(v)
		local l = game:GetService("Lighting")
		if v then
			original.Brightness = l.Brightness
			original.TimeOfDay = l.TimeOfDay
			original.FogEnd = l.FogEnd

			l.Brightness = 3
			l.TimeOfDay = "14:00:00"
			l.FogEnd = 1e10
		else
			for prop, val in pairs(original) do
				game:GetService("Lighting")[prop] = val
			end
		end
	end,
})




































