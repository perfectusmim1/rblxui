--[[
    SpiemUI V1.4 - Advanced Universal Script
    Comprehensive script for any Roblox game.
    Now with SaveManager & InterfaceManager support!
]]

local url = "https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua?v=" .. tick()
local Spiem = loadstring(game:HttpGet(url))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Get Managers from Library
local SaveManager = Spiem.SaveManager
local InterfaceManager = Spiem.InterfaceManager

-- Configuration
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    InfiniteJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    ESP = false,
    ESPColor = Color3.fromRGB(0, 255, 120),
    Fullbright = false,
    NoFog = false,
    AntiAFK = true,
    ClickTP = false
}

-- Setup Managers
SaveManager:SetLibrary(Spiem)
InterfaceManager:SetLibrary(Spiem)

-- Set folders (can be per-game)
local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:gsub("[^%w]", "")
SaveManager:SetFolder("SpiemHub/" .. gameName)
InterfaceManager:SetFolder("SpiemHub")

-- Ignore interface settings from game configs
SaveManager:IgnoreThemeSettings()

-- Window Creation
local Window = Spiem.new({
    Title = "Spiem Universal | " .. LP.Name,
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Player = Window:AddTab("Oyuncu"),
    Visuals = Window:AddTab("Görsel"),
    Teleport = Window:AddTab("Teleport"),
    Misc = Window:AddTab("Diğer"),
    Settings = Window:AddTab("Ayarlar")
}

-- Notify on Load
Spiem:Notify({
    Title = "Spiem Universal",
    Content = "Script başarıyla yüklendi!\nSol CTRL ile menüyü aç/kapat.",
    Duration = 5
})

-- ============================================
-- OYUNCU (Player) TAB
-- ============================================
do
    Tabs.Player:AddParagraph({
        Title = "Hareket Ayarları",
        Content = "Karakterinizin hız ve zıplama değerlerini ayarlayın."
    })

    Tabs.Player:AddSlider("WalkSpeed", {
        Title = "Yürüme Hızı",
        Min = 16,
        Max = 500,
        Default = 16,
        Rounding = 1,
        Callback = function(v) Config.WalkSpeed = v end
    })

    Tabs.Player:AddSlider("JumpPower", {
        Title = "Zıplama Gücü",
        Min = 50,
        Max = 500,
        Default = 50,
        Rounding = 1,
        Callback = function(v) Config.JumpPower = v end
    })

    Tabs.Player:AddSlider("Gravity", {
        Title = "Yerçekimi",
        Min = 50,
        Max = 500,
        Default = 196,
        Rounding = 1,
        Callback = function(v)
            Config.Gravity = v
            workspace.Gravity = v
        end
    })

    Tabs.Player:AddToggle("InfJump", {
        Title = "Sınırsız Zıplama",
        Default = false,
        Callback = function(v)
            Config.InfiniteJump = v
            Spiem:Notify({Title = "Sınırsız Zıplama", Content = v and "Aktif!" or "Kapatıldı.", Duration = 2})
        end
    })

    Tabs.Player:AddToggle("Noclip", {
        Title = "Noclip (Duvardan Geç)",
        Default = false,
        Callback = function(v)
            Config.Noclip = v
            Spiem:Notify({Title = "Noclip", Content = v and "Aktif!" or "Kapatıldı.", Duration = 2})
        end
    })

    Tabs.Player:AddToggle("FlyToggle", {
        Title = "Uçma (Fly)",
        Default = false,
        Callback = function(v)
            Config.Fly = v
            if not v and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LP.Character.HumanoidRootPart
                local bv = hrp:FindFirstChild("SpiemBV")
                local bg = hrp:FindFirstChild("SpiemBG")
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
            Spiem:Notify({Title = "Fly", Content = v and "WASD + Space/Shift ile uç!" or "Kapatıldı.", Duration = 2})
        end
    })

    Tabs.Player:AddSlider("FlySpeed", {
        Title = "Uçma Hızı",
        Min = 10,
        Max = 300,
        Default = 50,
        Rounding = 1,
        Callback = function(v) Config.FlySpeed = v end
    })

    Tabs.Player:AddButton({
        Title = "Karakteri Yenile",
        Callback = function()
            LP.Character:FindFirstChildOfClass("Humanoid").Health = 0
            Spiem:Notify({Title = "Karakter", Content = "Yenileniyor...", Duration = 2})
        end
    })
end

-- ============================================
-- GÖRSEL (Visuals) TAB
-- ============================================
do
    Tabs.Visuals:AddParagraph({Title = "ESP Ayarları", Content = "Diğer oyuncuları görmenizi kolaylaştırır."})

    Tabs.Visuals:AddToggle("ESPToggle", {
        Title = "Oyuncu ESP",
        Default = false,
        Callback = function(v)
            Config.ESP = v
            Spiem:Notify({Title = "ESP", Content = v and "Aktif!" or "Kapatıldı.", Duration = 2})
        end
    })

    Tabs.Visuals:AddColorpicker("ESPColor", {
        Title = "ESP Rengi",
        Default = Color3.fromRGB(0, 255, 120),
        Callback = function(clr) Config.ESPColor = clr end
    })

    Tabs.Visuals:AddToggle("Fullbright", {
        Title = "Fullbright",
        Default = false,
        Callback = function(v)
            Config.Fullbright = v
            if v then
                Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows = 2, 14, 100000, false
            else
                Lighting.Brightness, Lighting.GlobalShadows = 1, true
            end
            Spiem:Notify({Title = "Fullbright", Content = v and "Aktif!" or "Kapatıldı.", Duration = 2})
        end
    })

    Tabs.Visuals:AddToggle("NoFog", {
        Title = "Sisi Kaldır",
        Default = false,
        Callback = function(v)
            Config.NoFog = v
            Lighting.FogEnd = v and 100000 or 1000
            Spiem:Notify({Title = "Sis", Content = v and "Kaldırıldı!" or "Geri geldi.", Duration = 2})
        end
    })

    Tabs.Visuals:AddDropdown("TimeOfDay", {
        Title = "Gün Zamanı",
        Values = {"Sabah", "Öğlen", "Akşam", "Gece"},
        Default = "Öğlen",
        Multi = false,
        Callback = function(v)
            local times = {Sabah = 6, ["Öğlen"] = 12, ["Akşam"] = 18, Gece = 0}
            Lighting.ClockTime = times[v] or 12
        end
    })
end

-- ============================================
-- TELEPORT TAB
-- ============================================
do
    Tabs.Teleport:AddParagraph({Title = "Teleport", Content = "Oyuncuların yanına veya koordinatlara ışınlanın."})

    Tabs.Teleport:AddToggle("ClickTP", {
        Title = "Tıkla Işınlan (Ctrl + Click)",
        Default = false,
        Callback = function(v)
            Config.ClickTP = v
            Spiem:Notify({Title = "Click TP", Content = v and "CTRL + Mouse ile ışınlan!" or "Kapatıldı.", Duration = 2})
        end
    })

    local playerNames = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(playerNames, p.Name) end
    end

    Tabs.Teleport:AddDropdown("TPPlayer", {
        Title = "Oyuncuya Işınlan",
        Values = playerNames,
        Default = playerNames[1] or "Yok",
        Multi = false,
        Callback = function(v)
            local target = Players:FindFirstChild(v)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                Spiem:Notify({Title = "Teleport", Content = v .. " oyuncusuna ışınlandın!", Duration = 2})
            end
        end
    })

    Tabs.Teleport:AddButton({
        Title = "Spawn'a Işınlan",
        Callback = function()
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            Spiem:Notify({Title = "Teleport", Content = "Spawn'a ışınlandın.", Duration = 2})
        end
    })

    Tabs.Teleport:AddInput("CustomTP", {
        Title = "Koordinat (X,Y,Z)",
        Placeholder = "0,50,0",
        Callback = function(v)
            local coords = string.split(v, ",")
            if #coords == 3 then
                local x, y, z = tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3])
                if x and y and z then
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
                    Spiem:Notify({Title = "Teleport", Content = "Koordinata ışınlandın!", Duration = 2})
                end
            end
        end
    })
end

-- ============================================
-- DİĞER (Misc) TAB
-- ============================================
do
    Tabs.Misc:AddParagraph({Title = "Ek Özellikler", Content = "Anti-AFK, Sunucu araçları ve daha fazlası."})

    Tabs.Misc:AddToggle("AntiAFK", {
        Title = "Anti-AFK",
        Default = true,
        Callback = function(v)
            Config.AntiAFK = v
            Spiem:Notify({Title = "Anti-AFK", Content = v and "AFK atılmayacaksın!" or "Kapatıldı.", Duration = 2})
        end
    })

    Tabs.Misc:AddButton({
        Title = "Tüm Oyuncuları Listele",
        Callback = function()
            local list = ""
            for _, p in pairs(Players:GetPlayers()) do list = list .. p.Name .. "\n" end
            Spiem:Notify({Title = "Oyuncular (" .. #Players:GetPlayers() .. ")", Content = list, Duration = 8})
        end
    })

    Tabs.Misc:AddButton({
        Title = "Sunucu Bilgisi",
        Callback = function()
            local info = "Oyun: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
            info = info .. "\nPlaceId: " .. game.PlaceId
            info = info .. "\nOyuncu: " .. #Players:GetPlayers()
            Spiem:Notify({Title = "Sunucu", Content = info, Duration = 10})
        end
    })

    Tabs.Misc:AddButton({
        Title = "Rejoin",
        Description = "Aynı sunucuya tekrar bağlan",
        Callback = function()
            Spiem:Notify({Title = "Rejoin", Content = "Bağlanılıyor...", Duration = 2})
            task.wait(1)
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end
    })

    Tabs.Misc:AddButton({
        Title = "Server Hop",
        Description = "Başka sunucuya atla",
        Callback = function()
            Spiem:Notify({Title = "Server Hop", Content = "Sunucu aranıyor...", Duration = 2})
            task.wait(1)
            local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LP)
                    return
                end
            end
            Spiem:Notify({Title = "Hata", Content = "Uygun sunucu bulunamadı!", Duration = 3})
        end
    })
end

-- ============================================
-- AYARLAR (Settings) TAB - Config & Interface
-- ============================================
do
    -- Interface Section
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)

    -- Config Section
    SaveManager:BuildConfigSection(Tabs.Settings)

    Tabs.Settings:AddButton({
        Title = "Scripti Kapat",
        Description = "Tüm özellikleri kapatır ve menüyü siler",
        Callback = function() Window:Destroy() end
    })

    Tabs.Settings:AddParagraph({
        Title = "Hakkında",
        Content = "SpiemUI Library V" .. Spiem.Version .. "\nby perfectusmim1"
    })
end

-- ============================================
-- LOGIC LOOPS
-- ============================================
RS.RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        LP.Character.Humanoid.JumpPower = Config.JumpPower
    end

    if Config.Noclip and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if Config.Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        local bv = hrp:FindFirstChild("SpiemBV") or Instance.new("BodyVelocity", hrp)
        bv.Name = "SpiemBV"
        local bg = hrp:FindFirstChild("SpiemBG") or Instance.new("BodyGyro", hrp)
        bg.Name = "SpiemBG"
        
        bv.MaxForce = Vector3.new(1,1,1) * math.huge
        bg.MaxTorque = Vector3.new(1,1,1) * math.huge
        bg.CFrame = workspace.CurrentCamera.CFrame
        
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
        
        bv.Velocity = moveDir * Config.FlySpeed
    end
end)

UIS.JumpRequest:Connect(function()
    if Config.InfiniteJump and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Config.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LP:GetMouse()
        if mouse.Target then
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

LP.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- ESP Logic
local ESPFolder = Instance.new("Folder", workspace.CurrentCamera)
ESPFolder.Name = "SpiemESP"

local function CreateESP(player)
    if player == LP then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    highlight.FillTransparency, highlight.OutlineTransparency = 0.5, 0
    highlight.Parent = ESPFolder
    
    RS.RenderStepped:Connect(function()
        if player.Character and Config.ESP then
            highlight.Adornee, highlight.Enabled = player.Character, true
            highlight.FillColor, highlight.OutlineColor = Config.ESPColor, Config.ESPColor
        else
            highlight.Enabled = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Wait(); CreateESP(p) end)

-- Load autoload config if exists
SaveManager:LoadAutoloadConfig()

Spiem:Notify({Title = "Hazır!", Content = "Tüm özellikler aktif. İyi eğlenceler!", Duration = 3})
