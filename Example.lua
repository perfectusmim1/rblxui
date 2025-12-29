--[[
    SpiemUI V1.3 - Fluent Style Example
    This script demonstrates the new Fluent-like syntax and components.
]]

-- Load Library
local url = "https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua?v=" .. tick()
local Spiem = loadstring(game:HttpGet(url))()

-- Create Window
local Window = Spiem.new({
    Title = "Spiem Hub " .. Spiem.Version,
    SubTitle = "by perfectusmim1",
    Size = UDim2.fromOffset(580, 460)
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://10709761881" }), -- Icon optional
    Settings = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://10709762114" })
}

local Options = Spiem.Options

-- Main Tab Components
do
    -- Notification
    Spiem:Notify({
        Title = "SpiemUI Loaded",
        Content = "Welcome to the new V1.3 version with Fluent style!",
        Duration = 5
    })

    -- Paragraph
    Tabs.Main:AddParagraph({
        Title = "Modern UI",
        Content = "This library is designed for performance and aesthetics.\nEnjoy the new components!"
    })

    -- Button + Dialog
    Tabs.Main:AddButton({
        Title = "Show Dialog",
        Description = "Opens a confirmation dialog",
        Callback = function()
            Window:Dialog({
                Title = "Confirm Action",
                Content = "Are you sure you want to test the Dialog system?",
                Buttons = {
                    {
                        Title = "Yes",
                        Callback = function()
                            Spiem:Notify({Title = "Dialog", Content = "You clicked Yes!", Duration = 3})
                        end
                    },
                    {
                        Title = "No",
                        Callback = function()
                            print("Cancelled.")
                        end
                    }
                }
            })
        end
    })

    -- Toggle
    local MyToggle = Tabs.Main:AddToggle("Toggle1", {
        Title = "Enable God Mode",
        Default = false
    })

    MyToggle:OnChanged(function(state)
        print("Toggle state:", state)
    end)

    -- Slider
    local SpeedSlider = Tabs.Main:AddSlider("Slider1", {
        Title = "WalkSpeed",
        Min = 16,
        Max = 200,
        Default = 16,
        Rounding = 1,
        Callback = function(val)
            print("Speed set to:", val)
        end
    })

    -- Single Dropdown
    local Drop = Tabs.Main:AddDropdown("Dropdown1", {
        Title = "Kill Method",
        Values = {"Melee", "Sword", "Gun", "Explosion"},
        Default = "Sword",
        Multi = false,
        Callback = function(val)
            print("Selected kill method:", val)
        end
    })

    -- Multi Dropdown
    local MultiDrop = Tabs.Main:AddDropdown("MultiDropdown1", {
        Title = "Selected Players",
        Values = {"Player1", "Player2", "Player3", "Admin"},
        Default = {Player1 = true},
        Multi = true,
        Callback = function(values)
            local list = {}
            for k,v in pairs(values) do if v then table.insert(list, k) end end
            print("Multi-selected:", table.concat(list, ", "))
        end
    })

    -- Input
    local TextInput = Tabs.Main:AddInput("Input1", {
        Title = "User Profile",
        Placeholder = "Enter bio...",
        Callback = function(val)
            print("User bio:", val)
        end
    })

    -- Colorpicker
    local WallColor = Tabs.Main:AddColorpicker("ColorPicker1", {
        Title = "Esp Color",
        Default = Color3.fromRGB(0, 255, 120),
        Callback = function(clr)
            print("Color changed")
        end
    })

    -- Keybind
    local ToggleBind = Tabs.Main:AddKeybind("Keybind1", {
        Title = "Menu Toggle Bind",
        Default = "RightControl",
        Callback = function(key)
            print("Menu bind changed to:", key)
        end
    })
end

-- Select Initial Tab
-- Window:SelectTab(1) -- Auto selects first tab by default

print("Proje hazır! Keyfini çıkar.")
