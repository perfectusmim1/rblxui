--[[
    SpiemUI - Örnek Kullanım Scripti
    Bu dosya kütüphanenin tüm özelliklerini gösterir.
    
    GitHub'dan yüklemek için:
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/main/SpiemUI.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/main/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/main/Addons/InterfaceManager.lua"))()
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/main/SpiemUI.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/main/Addons/InterfaceManager.lua"))()

-- Pencere oluştur
local Window = Library:CreateWindow({
    Title = "SpiemUI " .. Library.Version,
    SubTitle = "by perfectusmim1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tab'ları oluştur
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Library.Options

-- Karşılama bildirimi
Library:Notify({
    Title = "SpiemUI",
    Content = "Welcome to SpiemUI!",
    SubContent = "Modern UI Library for Roblox",
    Duration = 5
})

-- Main Tab içeriği
do
    -- Paragraph
    Tabs.Main:AddParagraph({
        Title = "📖 Paragraph",
        Content = "This is a paragraph component.\nYou can add multiple lines of text here!"
    })

    -- Button
    Tabs.Main:AddButton({
        Title = "🔘 Button",
        Description = "Click me to open a dialog",
        Callback = function()
            Window:Dialog({
                Title = "Dialog Title",
                Content = "This is a dialog box. You can confirm or cancel actions here.",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("User confirmed the dialog!")
                            Library:Notify({
                                Title = "Confirmed",
                                Content = "You confirmed the dialog!",
                                Duration = 3
                            })
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("User cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })

    -- Toggle
    local Toggle = Tabs.Main:AddToggle("MyToggle", {
        Title = "🔄 Toggle",
        Description = "Enable or disable a feature",
        Default = false
    })

    Toggle:OnChanged(function(value)
        print("Toggle changed:", value)
    end)

    -- Slider
    local Slider = Tabs.Main:AddSlider("MySlider", {
        Title = "📊 Slider",
        Description = "Adjust a value between 0 and 100",
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(value)
            print("Slider value:", value)
        end
    })

    Slider:OnChanged(function(value)
        print("Slider changed:", value)
    end)

    -- Dropdown (Single)
    local Dropdown = Tabs.Main:AddDropdown("MyDropdown", {
        Title = "📋 Dropdown",
        Description = "Select one option",
        Values = {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"},
        Multi = false,
        Default = 1
    })

    Dropdown:OnChanged(function(value)
        print("Dropdown selected:", value)
    end)

    -- Dropdown (Multi)
    local MultiDropdown = Tabs.Main:AddDropdown("MyMultiDropdown", {
        Title = "📋 Multi Dropdown",
        Description = "Select multiple options",
        Values = {"Red", "Green", "Blue", "Yellow", "Purple"},
        Multi = true,
        Default = {"Red", "Blue"}
    })

    MultiDropdown:OnChanged(function(value)
        local selected = {}
        for k, v in pairs(value) do
            if v then table.insert(selected, k) end
        end
        print("Multi dropdown selected:", table.concat(selected, ", "))
    end)

    -- Colorpicker
    local Colorpicker = Tabs.Main:AddColorpicker("MyColor", {
        Title = "🎨 Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Color changed:", Colorpicker.Value)
    end)

    -- Keybind
    local Keybind = Tabs.Main:AddKeybind("MyKeybind", {
        Title = "⌨️ Keybind",
        Mode = "Toggle",
        Default = "E",
        Callback = function(value)
            print("Keybind activated:", value)
        end,
        ChangedCallback = function(new)
            print("Keybind changed to:", new)
        end
    })

    Keybind:OnClick(function()
        print("Keybind clicked! State:", Keybind:GetState())
    end)

    -- Input
    local Input = Tabs.Main:AddInput("MyInput", {
        Title = "✏️ Input",
        Default = "",
        Placeholder = "Enter something...",
        Numeric = false,
        Finished = false,
        Callback = function(value)
            print("Input value:", value)
        end
    })

    Input:OnChanged(function()
        print("Input changed:", Input.Value)
    end)
end

-- Addon'ları ayarla
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Tema ayarlarını ignore et
SaveManager:IgnoreThemeSettings()

-- Kaydetme klasörlerini ayarla
InterfaceManager:SetFolder("SpiemUI")
SaveManager:SetFolder("SpiemUI/Configs")

-- Settings Tab'ına Interface ve Config bölümlerini ekle
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- İlk tab'ı seç
Window:SelectTab(1)

-- Yükleme bildirimi
Library:Notify({
    Title = "SpiemUI",
    Content = "Script loaded successfully!",
    SubContent = "All features are ready to use.",
    Duration = 8
})

-- Autoload config'i yükle (varsa)
SaveManager:LoadAutoloadConfig()
