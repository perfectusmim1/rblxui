-- SpiemUI V1.2 - Örnek Kullanım
-- NOT: GitHub'a yükledikten sonra linki kendi raw linkinle değiştir.

-- Kütüphaneyi Yükle (Cache Buster ile)
local url = "https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua?v=" .. tick()
local library = loadstring(game:HttpGet(url))()

-- Pencere Oluştur
local Window = library.new("Spiem Hub | V1.2")

-- Sekmeler
local MainTab = Window:CreateTab("Ana Sayfa")
local ScriptsTab = Window:CreateTab("Scriptler")
local SettingsTab = Window:CreateTab("Ayarlar")

-- Ana Sayfa Elementleri
MainTab:CreateLabel("Hoş Geldiniz!")
MainTab:CreateParagraph("Bilgilendirme", "Bu UI kütüphanesi akıcı animasyonlar ve modern bir tasarımla hazırlanmıştır. Sağ CTRL tuşu ile menüyü gizleyebilirsiniz.")

MainTab:CreateButton("Discord Sunucusuna Katıl", function()
    -- Setclipboard("discord.gg/spiem") -- Eğer executor destekliyorsa
    print("Discord linki kopyalandı!")
end)

-- Scriptler Elementleri
ScriptsTab:CreateButton("Inf Yield Çalıştır", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- Ayarlar Elementleri
SettingsTab:CreateToggle("Hızlı Koşma", false, function(state)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
end)

SettingsTab:CreateInput("Jumppower Ayarla", "50", function(val)
    local jp = tonumber(val)
    if jp then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = jp
    end
end)

SettingsTab:CreateDropdown("Tema Seç", {"Koyu", "Mavi", "Gece"}, "Koyu", function(selected)
    print("Tema seçildi: " .. selected)
end)

print("SpiemUI V1.2 Başarıyla Çalıştı!")
