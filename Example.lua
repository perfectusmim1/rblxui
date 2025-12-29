-- Example usage for SpiemUI
-- This script demonstrates how to create a window, tabs, and all elements.

-- Loading the library (Assuming it's uploaded to the repo)
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua"))()

-- Create Window
local Window = library.new("Spiem Hub | V1.0")

-- Main Tab
local MainTab = Window:CreateTab("Main Settings")

-- Elements in Main Tab
MainTab:CreateLabel("General Information")

MainTab:CreateParagraph("Welcome!", "This is a premium Roblox UI library designed by Spiem. Use RightControl to toggle visibility.")

MainTab:CreateButton("Perform Action", function()
    print("Button clicked!")
end)

MainTab:CreateToggle("Enable Auto-Farm", false, function(state)
    print("Auto-farm is now:", state)
end)

-- Customization Tab
local CustomTab = Window:CreateTab("Customization")

CustomTab:CreateInput("Walkspeed", "16", function(val)
    local speed = tonumber(val)
    if speed then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        print("Set speed to:", speed)
    end
end)

CustomTab:CreateDropdown("Select Theme", {"Dark Blue", "Midnight", "Amnesia"}, "Dark Blue", function(selected)
    print("Theme selected:", selected)
end)

CustomTab:CreateMultiDropdown("Choose Features", {"Speed", "Jump", "Fly", "Spin"}, {"Speed"}, function(selected)
    print("Selected features:", table.concat(selected, ", "))
end)

-- Support Tab
local SupportTab = Window:CreateTab("Support")
SupportTab:CreateLabel("Discord: discord.gg/spiem")
SupportTab:CreateButton("Destroy UI", function()
    Window:Destroy()
end)

print("SpiemUI Loaded Successfully!")
