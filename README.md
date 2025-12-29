# SpiemUI Library 🚀

Premium, akıcı ve modern bir Roblox Lua UI kütüphanesi.

## ✨ Özellikler
- **Akıcı Animasyonlar:** TweenService ile optimize edilmiş modern geçişler.
- **Modern Tasarım:** Karanlık tema, yuvarlatılmış köşeler ve şık vuruşlar.
- **Zengin Elementler:**
  - Tab Sistemi
  - Butonlar
  - Toggle (Aç/Kapat)
  - Paragraph (Bilgi Paneli)
  - Label (Etiket)
  - Input (Yazı Girişi)
  - Dropdown (Açılır Menü)
- **Sürüklenebilir:** Üst bardan tutarak pencereyi taşıyabilirsiniz.
- **Kısayol:** `RightControl` ile menüyü gizleme/açma.

## 🚀 Kullanım
Scriptinizi şu kodla başlatabilirsiniz:

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua"))()

local Window = library.new("Spiem Hub")
local Tab = Window:CreateTab("Ana Sayfa")

Tab:CreateButton("Tıkla", function()
    print("Çalıştı!")
end)
```

## 🛠️ Elementler Örneği

### Toggle
```lua
Tab:CreateToggle("Özellik", false, function(state)
    print("Durum:", state)
end)
```

### Input
```lua
Tab:CreateInput("Hız Ayarla", "16", function(text)
    print("Girilen Değer:", text)
end)
```

### Dropdown
```lua
Tab:CreateDropdown("Seçenekler", {"A", "B", "C"}, "A", function(selected)
    print("Seçildi:", selected)
end)
```

## 📜 Lisans
Bu proje [perfectusmim1/rblxui](https://github.com/perfectusmim1/rblxui) reposu için özel olarak hazırlanmıştır.
