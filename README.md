# SpiemUI

**Modern Fluent-style UI Library for Roblox**

[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)]()

SpiemUI, Roblox için Fluent UI benzeri modern, animasyonlu ve özelleştirilebilir bir UI kütüphanesidir.

![SpiemUI Preview](https://i.imgur.com/placeholder.png)

## 🚀 Özellikler

- 🎨 **6 Farklı Tema**: Dark, Darker, Light, Aqua, Rose, Amethyst
- 🪟 **Sürüklenebilir Pencere**: Başlık çubuğundan tutup taşıyın
- 📑 **Tab Sistemi**: İkonlu sekmeler
- 🔔 **Bildirim Sistemi**: Özelleştirilebilir bildirimler
- 💬 **Dialog/Modal**: Onay diyalogları
- 💾 **SaveManager**: Konfigürasyon kaydetme/yükleme
- ⚙️ **InterfaceManager**: Tema yönetimi

## 📦 UI Elementleri

| Element | Açıklama |
|---------|----------|
| **Button** | Tıklanabilir buton |
| **Toggle** | Açma/kapama switch |
| **Slider** | Değer kaydırıcı |
| **Dropdown** | Tekli/çoklu seçim menüsü |
| **Colorpicker** | Renk seçici (transparency desteği) |
| **Keybind** | Tuş atama (Always, Toggle, Hold modları) |
| **Input** | Metin/sayı giriş kutusu |
| **Paragraph** | Başlık ve açıklama metni |
| **Section** | Elementleri gruplama |

## 📥 Kurulum

```lua
-- Ana kütüphane
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua"))()

-- Addon'lar (opsiyonel)
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/Addons/InterfaceManager.lua"))()
```

## 📖 Temel Kullanım

```lua
-- Pencere oluştur
local Window = Library:CreateWindow({
    Title = "SpiemUI",
    SubTitle = "by perfectusmim1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tab ekle
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Bildirim gönder
Library:Notify({
    Title = "Merhaba!",
    Content = "SpiemUI yüklendi",
    Duration = 5
})

-- Toggle ekle
local Toggle = Tabs.Main:AddToggle("Toggle1", {
    Title = "Feature",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

-- Slider ekle
local Slider = Tabs.Main:AddSlider("Slider1", {
    Title = "Value",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 0
})

-- Dropdown ekle
local Dropdown = Tabs.Main:AddDropdown("Dropdown1", {
    Title = "Selection",
    Values = {"First", "Second", "Third"},
    Default = 1
})

-- Button ekle
Tabs.Main:AddButton({
    Title = "Button",
    Description = "Description",
    Callback = function()
        -- Dialog aç
        Window:Dialog({
            Title = "Confirm",
            Content = "Are you sure?",
            Buttons = {
                { Title = "Yes", Callback = function() print("Yes") end },
                { Title = "No", Callback = function() print("No") end }
            }
        })
    end
})
```

## ⚙️ SaveManager & InterfaceManager

```lua
-- Ayarla
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Tema ayarlarını ignore et (config'e kaydetme)
SaveManager:IgnoreThemeSettings()

-- Klasörleri ayarla
InterfaceManager:SetFolder("MyScript")
SaveManager:SetFolder("MyScript/Game")

-- Settings tab'ına ekle
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Autoload config yükle
SaveManager:LoadAutoloadConfig()
```

## 🎨 Temalar

```lua
-- Tema değiştir
Library:SetTheme("Rose") -- Dark, Darker, Light, Aqua, Rose, Amethyst

-- Transparency aç/kapa
Library:ToggleTransparency(true)
```

## 📁 Dosya Yapısı

```
rblxui/
├── SpiemUI.lua          # Ana kütüphane (tek dosya)
├── Example.lua          # Örnek kullanım scripti
├── README.md            # Dokümantasyon
└── Addons/
    ├── SaveManager.lua      # Config kaydetme/yükleme
    └── InterfaceManager.lua # Tema yönetimi
```

## 📚 API Referansı

### Library

| Method | Açıklama |
|--------|----------|
| `CreateWindow(config)` | Ana pencere oluştur |
| `SetTheme(theme)` | Tema değiştir |
| `ToggleTransparency(state)` | Saydamlığı aç/kapa |
| `Notify(config)` | Bildirim gönder |
| `Destroy()` | UI'ı kapat |

### Window

| Method | Açıklama |
|--------|----------|
| `AddTab(config)` | Yeni tab ekle |
| `SelectTab(index)` | Tab seç |
| `Dialog(config)` | Dialog aç |

### Tab

| Method | Açıklama |
|--------|----------|
| `AddSection(title)` | Bölüm ekle |
| `AddButton(config)` | Buton ekle |
| `AddToggle(id, config)` | Toggle ekle |
| `AddSlider(id, config)` | Slider ekle |
| `AddDropdown(id, config)` | Dropdown ekle |
| `AddInput(id, config)` | Input ekle |
| `AddKeybind(id, config)` | Keybind ekle |
| `AddColorpicker(id, config)` | Colorpicker ekle |
| `AddParagraph(config)` | Paragraph ekle |

## 📝 Lisans

MIT License - Özgürce kullanabilirsiniz!

## 🤝 Katkıda Bulunma

Pull request'lerinizi bekliyoruz!

---

Made with ❤️ by perfectusmim1
