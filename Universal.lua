--[[
    SpiemUI V1.3.1 - Universal Script
    Comprehensive script for any game.
]]

local url = "https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua?v=" .. tick()
local Spiem = loadstring(game:HttpGet(url))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Configuration
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 50,
    ESP = false,
    BoxESP = false,
    Tracers = false,
    Fullbright = false
}

-- Window Creation
local Window = Spiem.new({
    Title = "Spiem Universal | " .. LP.Name,
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Player = Window:AddTab("Gelişmiş"),
    Visuals = Window:AddTab("Görsel"),
    Misc = Window:AddTab("Diğer")
}

-- Gelişmiş (Advanced Player) Tab
do
    Tabs.Player:AddSlider("WalkSpeed", {
        Title = "Yürüme Hızı",
        Min = 16,
        Max = 250,
        Default = 16,
        Callback = function(v)
            Config.WalkSpeed = v
        end
    })

    Tabs.Player:AddSlider("JumpPower", {
        Title = "Zıplama Gücü",
        Min = 50,
        Max = 300,
        Default = 50,
        Callback = function(v)
            Config.JumpPower = v
        end
    })

    Tabs.Player:AddToggle("InfJump", {
        Title = "Sınırsız Zıplama",
        Default = false,
        Callback = function(v)
            Config.InfiniteJump = v
        end
    })

    Tabs.Player:AddToggle("FlyToggle", {
        Title = "Uçma (Fly)",
        Default = false,
        Callback = function(v)
            Config.Fly = v
            if not v then
                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
                    LP.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro"):Destroy()
                end
            end
        end
    })

    Tabs.Player:AddSlider("FlySpeed", {
        Title = "Uçma Hızı",
        Min = 10,
        Max = 200,
        Default = 50,
        Callback = function(v)
            Config.FlySpeed = v
        end
    })
end

-- Görsel (Visuals) Tab
do
    Tabs.Visuals:AddToggle("ESPToggle", {
        Title = "Oyuncu ESP",
        Default = false,
        Callback = function(v)
            Config.ESP = v
        end
    })

    Tabs.Visuals:AddToggle("BoxESP", {
        Title = "Kutu ESP",
        Default = false,
        Callback = function(v)
            Config.BoxESP = v
        end
    })

    Tabs.Visuals:AddToggle("Fullbright", {
        Title = "Fullbright (Aydınlık)",
        Default = false,
        Callback = function(v)
            Config.Fullbright = v
            if v then
                game.Lighting.Brightness = 2
                game.Lighting.ClockTime = 14
                game.Lighting.FogEnd = 100000
                game.Lighting.GlobalShadows = false
            else
                game.Lighting.Brightness = 1
                game.Lighting.GlobalShadows = true
            end
        end
    })
end

-- Diğer (Misc) Tab
do
    Tabs.Misc:AddKeybind("MenuToggle", {
        Title = "Menü Aç/Kapat Tuşu",
        Default = "RightControl",
        Callback = function(key)
            Window.MinimizeKey = Enum.KeyCode[key]
            Spiem:Notify({
                Title = "Tuş Atandı",
                Content = "Menü tuşu şu an: " .. key,
                Duration = 2
            })
        end
    })

    Tabs.Misc:AddButton({
        Title = "Hileyi Tamamen Kapat",
        Callback = function()
            Window:Destroy()
        end
    })
end

-- Logic (Loops)
RS.RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        LP.Character.Humanoid.JumpPower = Config.JumpPower
    end

    if Config.Fly and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        local bv = hrp:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", hrp)
        local bg = hrp:FindFirstChild("BodyGyro") or Instance.new("BodyGyro", hrp)
        
        bv.MaxForce = Vector3.new(1,1,1) * 10^6
        bg.MaxTorque = Vector3.new(1,1,1) * 10^6
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

-- Basic ESP Logic
local function CreateESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "SpiemESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    local function update()
        if player.Character and Config.ESP then
            highlight.Parent = player.Character
            highlight.Enabled = true
            highlight.FillColor = player.TeamColor.Color
        else
            highlight.Enabled = false
        end
    end
    
    RS.RenderStepped:Connect(update)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then CreateESP(p) end
end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Wait(); CreateESP(p) end)

Spiem:Notify({
    Title = "Spiem Universal",
    Content = "Universal script başarıyla yüklendi. İyi eğlenceler!",
    Duration = 5
})
