--[[
    SpiemUI V1.6 - Complete Feature Example
    This script demonstrates ALL features of SpiemUI library.
    
    Features demonstrated:
    - Window creation with MinimizeKey
    - Multiple Tabs with smooth animations
    - Sections for organizing content
    - Paragraphs for information display
    - Buttons with descriptions & SetDesc
    - Toggles with OnChanged callbacks
    - Sliders with rounding
    - Dropdowns (single & multi)
    - Inputs (text and numeric)
    - Colorpickers
    - Keybinds
    - Dialog system
    - Notification system
    - SaveManager (config system)
    - InterfaceManager (settings)
]]

-- Load Library
local url = "https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua?v=" .. tick()
local Spiem = loadstring(game:HttpGet(url))()

-- Reference for Options (needed for SaveManager)
local Options = Spiem.Options

-- Create Window
local Window = Spiem.new({
    Title = "Spiem Universal | V" .. Spiem.Version,
    MinimizeKey = Enum.KeyCode.LeftControl -- Press LeftControl to toggle minimize
})

-- Welcome Notification
Spiem:Notify({
    Title = "SpiemUI Loaded",
    Content = "Welcome to the complete V" .. Spiem.Version .. " demo!\nAll features are demonstrated in this example.",
    Duration = 5
})

-- Create All Tabs
local Tabs = {
    Player = Window:AddTab({ Title = "Player" }),
    Visuals = Window:AddTab({ Title = "Visuals" }),
    Teleport = Window:AddTab({ Title = "Teleport" }),
    Misc = Window:AddTab({ Title = "Misc" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

-- ============================================
-- PLAYER TAB
-- ============================================
do
    local PlayerTab = Tabs.Player
    
    -- Section: Movement
    PlayerTab:AddSection("Movement")
    
    -- Paragraph: Info about this section
    PlayerTab:AddParagraph({
        Title = "Movement Settings",
        Content = "Configure your character's movement properties.\nAdjust speed, jump power, and more!"
    })
    
    -- Toggle: Speed Hack
    local SpeedToggle = PlayerTab:AddToggle("SpeedEnabled", {
        Title = "Speed Hack",
        Default = false,
        Callback = function(enabled)
            if enabled then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Options.SpeedValue.Value
            else
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    })
    
    -- Slider: Speed Value
    local SpeedSlider = PlayerTab:AddSlider("SpeedValue", {
        Title = "Walk Speed",
        Min = 16,
        Max = 500,
        Default = 50,
        Rounding = 1,
        Callback = function(value)
            if Options.SpeedEnabled and Options.SpeedEnabled.Value then
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                end)
            end
        end
    })
    
    -- Toggle: Jump Hack
    PlayerTab:AddToggle("JumpEnabled", {
        Title = "Jump Power Hack",
        Default = false,
        Callback = function(enabled)
            if enabled then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = Options.JumpValue.Value
            else
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
            end
        end
    })
    
    -- Slider: Jump Value
    PlayerTab:AddSlider("JumpValue", {
        Title = "Jump Power",
        Min = 50,
        Max = 350,
        Default = 100,
        Rounding = 5,
        Callback = function(value)
            if Options.JumpEnabled and Options.JumpEnabled.Value then
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
                end)
            end
        end
    })
    
    -- Section: Combat
    PlayerTab:AddSection("Combat")
    
    -- Toggle: Infinite Health (Demo)
    PlayerTab:AddToggle("InfiniteHealth", {
        Title = "Infinite Health (Visual)",
        Default = false,
        Callback = function(enabled)
            print("Infinite Health:", enabled)
        end
    })
    
    -- Button: Kill Aura (Düzeltilmiş tanım)
    local killAuraButton
    killAuraButton = PlayerTab:AddButton({
        Title = "Kill Aura",
        Description = "Status: Inactive",
        Callback = function()
            Spiem:Notify({
                Title = "Kill Aura",
                Content = "This is a demo feature!",
                Duration = 3
            })
            -- Update button description
            killAuraButton:SetDesc("Status: Demo triggered!")
        end
    })
    
    -- Dropdown: Attack Mode
    PlayerTab:AddDropdown("AttackMode", {
        Title = "Attack Mode",
        Values = {"Melee", "Sword", "Gun", "Explosion", "Magic"},
        Default = "Sword",
        Multi = false,
        Callback = function(value)
            print("Attack mode changed to:", value)
        end
    })
    -- Section: Timer (UI Update Test)
    PlayerTab:AddSection("Timer")

    local timerPara = PlayerTab:AddParagraph({
        Title = "Countdown Timer",
        Content = "Click 'Start' to begin the countdown (1-30)."
    })

    PlayerTab:AddButton({
        Title = "Start Countdown",
        Description = "Updates the paragraph content every second",
        Callback = function()
            task.spawn(function()
                for i = 1, 30 do
                    timerPara:SetContent("Current value: " .. i .. " seconds")
                    task.wait(1)
                end
                timerPara:SetContent("Timer finished! (30 seconds)")
            end)
        end
    })
end

-- ============================================
-- VISUALS TAB
-- ============================================
do
    local VisualsTab = Tabs.Visuals
    
    -- Section: ESP
    VisualsTab:AddSection("ESP")
    
    -- Toggle: Player ESP
    VisualsTab:AddToggle("PlayerESP", {
        Title = "Player ESP",
        Default = false,
        Callback = function(enabled)
            print("Player ESP:", enabled)
        end
    })
    
    -- Colorpicker: ESP Color
    VisualsTab:AddColorpicker("ESPColor", {
        Title = "ESP Color",
        Default = Color3.fromRGB(0, 255, 120),
        Callback = function(color)
            print("ESP Color changed to:", color)
        end
    })
    
    -- Multi Dropdown: ESP Options
    VisualsTab:AddDropdown("ESPOptions", {
        Title = "ESP Display Options",
        Values = {"Box", "Name", "Health", "Distance", "Tracers"},
        Default = {Box = true, Name = true},
        Multi = true,
        Callback = function(values)
            local selected = {}
            for k, v in pairs(values) do
                if v then table.insert(selected, k) end
            end
            print("ESP Options:", table.concat(selected, ", "))
        end
    })
    
    -- Section: Environment
    VisualsTab:AddSection("Environment")
    
    -- Toggle: Fullbright
    VisualsTab:AddToggle("Fullbright", {
        Title = "Fullbright",
        Default = false,
        Callback = function(enabled)
            local Lighting = game:GetService("Lighting")
            if enabled then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
            else
                Lighting.Brightness = 1
                Lighting.ClockTime = 14
                Lighting.FogEnd = 10000
                Lighting.GlobalShadows = true
            end
        end
    })
    
    -- Toggle: Remove Fog
    VisualsTab:AddToggle("RemoveFog", {
        Title = "Remove Fog",
        Default = false,
        Callback = function(enabled)
            game:GetService("Lighting").FogEnd = enabled and 1000000 or 10000
        end
    })
    
    -- Dropdown: Time of Day
    VisualsTab:AddDropdown("TimeOfDay", {
        Title = "Time of Day",
        Values = {"Morning", "Noon", "Evening", "Night", "Midnight"},
        Default = "Noon",
        Multi = false,
        Callback = function(value)
            local times = {
                Morning = 6,
                Noon = 12,
                Evening = 18,
                Night = 21,
                Midnight = 0
            }
            game:GetService("Lighting").ClockTime = times[value] or 12
        end
    })
end

-- ============================================
-- TELEPORT TAB
-- ============================================
do
    local TeleportTab = Tabs.Teleport
    
    -- Section: Player Teleport
    TeleportTab:AddSection("Player Teleport")
    
    -- Paragraph
    TeleportTab:AddParagraph({
        Title = "Teleport System",
        Content = "Select a player from the dropdown and click teleport to move to their location."
    })
    
    -- Get all player names
    local function getPlayerNames()
        local names = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(names, player.Name)
            end
        end
        if #names == 0 then
            table.insert(names, "No players")
        end
        return names
    end
    
    -- Dropdown: Target Player
    local targetDropdown = TeleportTab:AddDropdown("TeleportTarget", {
        Title = "Target Player",
        Values = getPlayerNames(),
        Multi = false
    })
    
    -- Button: Refresh Player List
    TeleportTab:AddButton({
        Title = "Refresh Player List",
        Callback = function()
            targetDropdown:Refresh(getPlayerNames())
            Spiem:Notify({Title = "Refreshed", Content = "Player list updated!", Duration = 2})
        end
    })
    
    -- Button: Teleport to Player
    TeleportTab:AddButton({
        Title = "Teleport to Player",
        Description = "Teleports you to the selected player",
        Callback = function()
            local targetName = Options.TeleportTarget and Options.TeleportTarget.Value
            if not targetName or targetName == "No players" then
                return Spiem:Notify({Title = "Error", Content = "No player selected!", Duration = 3})
            end
            
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(
                    targetPlayer.Character.HumanoidRootPart.CFrame
                )
                Spiem:Notify({Title = "Success", Content = "Teleported to " .. targetName, Duration = 2})
            else
                Spiem:Notify({Title = "Error", Content = "Player not found or has no character", Duration = 3})
            end
        end
    })
    
    -- Section: Waypoints
    TeleportTab:AddSection("Custom Waypoints")
    
    -- Input: Waypoint Name
    TeleportTab:AddInput("WaypointName", {
        Title = "Waypoint Name",
        Placeholder = "Enter waypoint name...",
        Callback = function(value)
            print("Waypoint name:", value)
        end
    })
    
    -- Input: Coordinates (numeric example)
    TeleportTab:AddInput("WaypointX", {
        Title = "X Coordinate",
        Placeholder = "0",
        Numeric = true,
        Callback = function(value)
            print("X:", value)
        end
    })
    
    -- Button: Save Waypoint
    TeleportTab:AddButton({
        Title = "Save Current Position as Waypoint",
        Callback = function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                print("Saved waypoint at:", pos)
                Spiem:Notify({
                    Title = "Waypoint Saved",
                    Content = string.format("Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z),
                    Duration = 3
                })
            end
        end
    })
end

-- ============================================
-- MISC TAB
-- ============================================
do
    local MiscTab = Tabs.Misc
    
    -- Section: Utilities
    MiscTab:AddSection("Utilities")
    
    -- Button with Dialog
    MiscTab:AddButton({
        Title = "Show Dialog Example",
        Description = "Opens a confirmation dialog",
        Callback = function()
            Window:Dialog({
                Title = "Confirm Action",
                Content = "This is a dialog example. Do you want to proceed with this action?\n\nDialogs are great for confirmations!",
                Buttons = {
                    {
                        Title = "Yes, proceed",
                        Callback = function()
                            Spiem:Notify({
                                Title = "Dialog Result",
                                Content = "You clicked Yes!",
                                Duration = 3
                            })
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("User cancelled the dialog")
                        end
                    }
                }
            })
        end
    })
    
    -- Toggle with keybind functionality
    local noclipEnabled = false
    MiscTab:AddToggle("Noclip", {
        Title = "Noclip",
        Default = false,
        Callback = function(enabled)
            noclipEnabled = enabled
            print("Noclip:", enabled)
        end
    })
    
    -- Keybind for Noclip
    MiscTab:AddKeybind("NoclipKeybind", {
        Title = "Noclip Toggle Key",
        Default = "N",
        Callback = function(key, isChange)
            if not isChange then
                -- Key was pressed, toggle noclip
                noclipEnabled = not noclipEnabled
                Options.Noclip:SetValue(noclipEnabled)
            else
                -- Key was changed
                print("Noclip keybind changed to:", key)
            end
        end
    })
    
    -- Section: Fun
    MiscTab:AddSection("Fun Features")
    
    -- Toggle: Anti AFK
    MiscTab:AddToggle("AntiAFK", {
        Title = "Anti AFK",
        Default = false,
        Callback = function(enabled)
            if enabled then
                local vu = game:GetService("VirtualUser")
                game:GetService("Players").LocalPlayer.Idled:Connect(function()
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
                Spiem:Notify({Title = "Anti AFK", Content = "You will no longer be kicked for idling!", Duration = 3})
            end
        end
    })
    
    -- Slider: FPS Cap
    MiscTab:AddSlider("FPSCap", {
        Title = "FPS Cap",
        Min = 30,
        Max = 240,
        Default = 60,
        Rounding = 10,
        Callback = function(value)
            -- This would require external tools to actually work
            print("FPS Cap set to:", value)
        end
    })
    
    -- Section: Rejoin
    MiscTab:AddSection("Server")
    
    MiscTab:AddButton({
        Title = "Rejoin Server",
        Callback = function()
            Window:Dialog({
                Title = "Rejoin Confirmation",
                Content = "Are you sure you want to rejoin the server?",
                Buttons = {
                    {
                        Title = "Rejoin",
                        Callback = function()
                            local TeleportService = game:GetService("TeleportService")
                            TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function() end
                    }
                }
            })
        end
    })
    
    MiscTab:AddButton({
        Title = "Server Hop",
        Callback = function()
            Spiem:Notify({Title = "Server Hop", Content = "Finding a new server...", Duration = 2})
            -- Server hop logic would go here
        end
    })
end

-- ============================================
-- SETTINGS TAB
-- ============================================
do
    local SettingsTab = Tabs.Settings
    
    -- Setup SaveManager & InterfaceManager
    local SaveManager = Spiem.SaveManager
    local InterfaceManager = Spiem.InterfaceManager
    
    -- Set the library reference
    SaveManager:SetLibrary(Spiem)
    InterfaceManager:SetLibrary(Spiem)
    
    -- Set folders for saving
    SaveManager:SetFolder("SpiemUI_Example")
    InterfaceManager:SetFolder("SpiemUI_Example")
    
    -- Ignore certain options from being saved
    SaveManager:IgnoreThemeSettings()
    
    -- Build the config section (Save/Load/Delete configs)
    SaveManager:BuildConfigSection(SettingsTab)
    
    -- Build the interface section (Menu keybind, etc.)
    InterfaceManager:BuildInterfaceSection(SettingsTab)
    
    -- Section: About
    SettingsTab:AddSection("About")
    
    SettingsTab:AddParagraph({
        Title = "SpiemUI V" .. Spiem.Version,
        Content = "A modern, fluent-style UI library for Roblox.\n\nFeatures:\n• Smooth animations\n• Save/Load configs\n• All component types\n• Dark modern theme"
    })
    
    SettingsTab:AddButton({
        Title = "Join Discord",
        Description = "Get support and updates",
        Callback = function()
            setclipboard("https://discord.gg/example")
            Spiem:Notify({Title = "Discord", Content = "Invite link copied to clipboard!", Duration = 3})
        end
    })
    
    SettingsTab:AddButton({
        Title = "Destroy UI",
        Description = "Completely removes the UI",
        Callback = function()
            Window:Dialog({
                Title = "Destroy UI",
                Content = "Are you sure you want to destroy the UI? You will need to re-execute the script.",
                Buttons = {
                    {
                        Title = "Yes, destroy",
                        Callback = function()
                            Window:Destroy()
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function() end
                    }
                }
            })
        end
    })
    
    -- Load autoload config if exists
    SaveManager:LoadAutoloadConfig()
end

-- Final notification
Spiem:Notify({
    Title = "Ready!",
    Content = "All tabs and features are loaded.\nPress LeftControl to minimize the UI.",
    Duration = 4
})

print("=========================================")
print("SpiemUI V" .. Spiem.Version .. " Example Loaded!")
print("All features demonstrated successfully.")
print("=========================================")
