local Spiem = loadfile("ModernSpiem.lua")()
-- For real use: local Spiem = loadstring(game:HttpGet("..."))()

local Window = Spiem.new({
    Title = "SilentSpy - Fryzer Hub",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tab = Window:AddTab({
    Title = "Info",
    Icon = "rbxassetid://6031097225"
})

-- The big blue card from the image
Tab:AddCard({
    Title = "Silent Spy Active",
    Content = "This tool captures remote events and functions. Auto-blocks remotes firing 50+ times. Click 'Block Remote' to manually block.",
    Color = Color3.fromRGB(0, 140, 255)
})

Tab:AddSection("Settings")

Tab:AddToggle("Notifications", {
    Title = "Notifications",
    Description = "Enable/Disable all notifications",
    Default = false,
    Callback = function(state)
        print("Notifications:", state)
    end
})

Tab:AddToggle("AutoBan", {
    Title = "Auto-Ban",
    Description = "Automatically block remotes after 50+ fires",
    Default = false,
    Callback = function(state)
        print("AutoBan:", state)
    end
})

Tab:AddButton({
    Title = "Unblock All Remotes",
    Description = "Unblock all currently blocked remotes",
    Callback = function()
        Spiem:Notify({
            Title = "Success",
            Content = "All remotes unblocked.",
            Duration = 3
        })
    end
})

-- Add SaveManager
Spiem.SaveManager:SetLibrary(Window)
Spiem.SaveManager:IgnoreThemeSettings()
Spiem.SaveManager:BuildConfigSection(Tab)
