--[[
    Spiem Universal Hub
    A complete universal script for Roblox including Aimbot, ESP, and Player features.
    Powered by SpiemUI
]]

-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Load Library
local Spiem = loadstring(readfile("SpiemUI.lua"))() or loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua?v=" .. tick()))()
local Options = Spiem.Options

-- Create Window
local Window = Spiem.new({
    Title = "Spiem Universal Hub | V" .. Spiem.Version,
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Welcome Notification
Spiem:Notify({
    Title = "Spiem Universal",
    Content = "Universal Script Loaded Successfully!\nPress RightControl to hide the menu.",
    Duration = 5
})

-- Tabs
local Tabs = {
    Aimbot = Window:AddTab({ Title = "Aimbot" }),
    Visuals = Window:AddTab({ Title = "Visuals" }),
    Player = Window:AddTab({ Title = "Player" }),
    Teleport = Window:AddTab({ Title = "Teleport" }),
    Misc = Window:AddTab({ Title = "Misc" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

-- ============================================
-- AIMBOT SECTION
-- ============================================
do
    local AimbotTab = Tabs.Aimbot
    AimbotTab:AddSection("Main Settings")

    AimbotTab:AddToggle("AimbotEnabled", {
        Title = "Enable Aimbot",
        Default = false,
        Callback = function() end
    })

    AimbotTab:AddToggle("AimbotSmoothing", {
        Title = "Smooth Aim",
        Default = true,
        Callback = function() end
    })

    AimbotTab:AddSlider("AimbotSmoothValue", {
        Title = "Smoothing Amount",
        Min = 1,
        Max = 20,
        Default = 5,
        Rounding = 1,
        Callback = function() end
    })

    AimbotTab:AddDropdown("AimPart", {
        Title = "Target Part",
        Values = {"Head", "HumanoidRootPart", "Torso"},
        Default = "Head",
        Multi = false,
        Callback = function() end
    })

    AimbotTab:AddKeybind("AimbotKey", {
        Title = "Aimbot Key",
        Default = "F",
        Callback = function() end
    })

    AimbotTab:AddSection("FOV Settings")

    AimbotTab:AddToggle("ShowFOV", {
        Title = "Show FOV Circle",
        Default = true,
        Callback = function() end
    })

    AimbotTab:AddSlider("FOVRadius", {
        Title = "FOV Radius",
        Min = 10,
        Max = 600,
        Default = 100,
        Rounding = 1,
        Callback = function() end
    })

    AimbotTab:AddColorpicker("FOVColor", {
        Title = "FOV Circle Color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function() end
    })

    -- FOV Drawing
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 100
    FOVCircle.Radius = 100
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)

    -- Aimbot Logic
    local function GetClosestPlayer()
        local closest = nil
        local shortestDistance = Options.FOVRadius.Value

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(Options.AimPart.Value) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character[Options.AimPart.Value].Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if distance < shortestDistance then
                        closest = v
                        shortestDistance = distance
                    end
                end
            end
        end
        return closest
    end

    local lockedTarget = nil

    RunService.RenderStepped:Connect(function()
        if Options.ShowFOV and Options.ShowFOV.Value then
            FOVCircle.Visible = true
            FOVCircle.Radius = Options.FOVRadius.Value
            FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
            FOVCircle.Color = Options.FOVColor.Value
        else
            FOVCircle.Visible = false
        end

        local aimKey = Options.AimbotKey and Options.AimbotKey.Value or "F"
        local isPressed = false
        
        -- Check if it's a mouse button or keyboard key
        if string.find(aimKey, "MouseButton") then
            isPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType[aimKey])
        else
            isPressed = UserInputService:IsKeyDown(Enum.KeyCode[aimKey])
        end

        if Options.AimbotEnabled and Options.AimbotEnabled.Value and isPressed then
            -- Sticky Target Logic
            if lockedTarget then
                -- Check if target is still valid
                local character = lockedTarget.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                local part = character and character:FindFirstChild(Options.AimPart.Value)
                
                if not (character and humanoid and humanoid.Health > 0 and part) then
                    lockedTarget = nil
                end
            end

            -- If no target, find a new one
            if not lockedTarget then
                lockedTarget = GetClosestPlayer()
            end

            -- Aim at target
            if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild(Options.AimPart.Value) then
                local targetPos = lockedTarget.Character[Options.AimPart.Value].Position
                if Options.AimbotSmoothing.Value then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), 1 / Options.AimbotSmoothValue.Value)
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                end
            end
        else
            -- Key released, clear target
            lockedTarget = nil
        end
    end)
end

-- ============================================
-- VISUALS SECTION (ESP)
-- ============================================
do
    local VisualsTab = Tabs.Visuals
    VisualsTab:AddSection("ESP Settings")

    VisualsTab:AddToggle("ESPEnabled", {
        Title = "Enable ESP",
        Default = false,
        Callback = function() end
    })

    VisualsTab:AddToggle("ESP_Boxes", {
        Title = "Boxes",
        Default = true,
        Callback = function() end
    })

    VisualsTab:AddToggle("ESP_Names", {
        Title = "Names",
        Default = true,
        Callback = function() end
    })

    VisualsTab:AddToggle("ESP_Tracers", {
        Title = "Tracers",
        Default = false,
        Callback = function() end
    })

    VisualsTab:AddToggle("ESP_Health", {
        Title = "Health Bar",
        Default = false,
        Callback = function() end
    })

    VisualsTab:AddColorpicker("ESP_Color", {
        Title = "ESP Color",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function() end
    })

    VisualsTab:AddSection("Environment")

    VisualsTab:AddToggle("Fullbright", {
        Title = "Fullbright",
        Default = false,
        Callback = function(enabled)
            if enabled then
                task.spawn(function()
                    while Options.Fullbright and Options.Fullbright.Value do
                        Lighting.Brightness = 2
                        Lighting.ClockTime = 14
                        Lighting.FogEnd = 100000
                        Lighting.GlobalShadows = false
                        task.wait(1)
                    end
                end)
            else
                Lighting.Brightness = 1
                Lighting.ClockTime = 14
                Lighting.FogEnd = 10000
                Lighting.GlobalShadows = true
            end
        end
    })

    -- Simple ESP Handler
    local players = {}

    local function createESP(plr)
        local esp = {
            box = Drawing.new("Square"),
            name = Drawing.new("Text"),
            tracer = Drawing.new("Line"),
            healthBar = Drawing.new("Square"),
            healthOutline = Drawing.new("Square")
        }
        
        esp.box.Thickness = 1
        esp.box.Filled = false
        esp.box.Transparency = 1
        
        esp.name.Size = 16
        esp.name.Center = true
        esp.name.Outline = true
        
        esp.tracer.Thickness = 1
        esp.tracer.Transparency = 1
        
        esp.healthBar.Filled = true
        esp.healthOutline.Thickness = 1
        esp.healthOutline.Filled = false
        
        players[plr] = esp
    end

    local function removeESP(plr)
        if players[plr] then
            for _, v in pairs(players[plr]) do
                v:Remove()
            end
            players[plr] = nil
        end
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then createESP(v) end
    end

    Players.PlayerAdded:Connect(createESP)
    Players.PlayerRemoving:Connect(removeESP)

    RunService.RenderStepped:Connect(function()
        for plr, esp in pairs(players) do
            if Options.ESPEnabled and Options.ESPEnabled.Value and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                local rootPos = plr.Character.HumanoidRootPart.Position
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPos)
                
                if onScreen then
                    local size = (Camera:WorldToViewportPoint(rootPos + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPos + Vector3.new(0, -3.5, 0)).Y)
                    local width = size / 2
                    
                    -- Box
                    esp.box.Visible = Options.ESP_Boxes.Value
                    esp.box.Size = Vector2.new(width, size)
                    esp.box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - size/2)
                    esp.box.Color = Options.ESP_Color.Value
                    
                    -- Name
                    esp.name.Visible = Options.ESP_Names.Value
                    esp.name.Text = plr.Name
                    esp.name.Position = Vector2.new(screenPos.X, screenPos.Y - size/2 - 20)
                    esp.name.Color = Color3.fromRGB(255, 255, 255)
                    
                    -- Tracer
                    esp.tracer.Visible = Options.ESP_Tracers.Value
                    esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y + size/2)
                    esp.tracer.Color = Options.ESP_Color.Value
                    
                    -- Health
                    if Options.ESP_Health.Value then
                        local healthPercent = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth
                        esp.healthOutline.Visible = true
                        esp.healthOutline.Size = Vector2.new(2, size)
                        esp.healthOutline.Position = Vector2.new(screenPos.X - width/2 - 5, screenPos.Y - size/2)
                        
                        esp.healthBar.Visible = true
                        esp.healthBar.Size = Vector2.new(2, size * healthPercent)
                        esp.healthBar.Position = Vector2.new(screenPos.X - width/2 - 5, screenPos.Y + size/2 - (size * healthPercent))
                        esp.healthBar.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
                    else
                        esp.healthOutline.Visible = false
                        esp.healthBar.Visible = false
                    end
                else
                    for _, v in pairs(esp) do v.Visible = false end
                end
            else
                for _, v in pairs(esp) do v.Visible = false end
            end
        end
    end)
end

-- ============================================
-- PLAYER SECTION
-- ============================================
do
    local PlayerTab = Tabs.Player
    PlayerTab:AddSection("Movement")

    PlayerTab:AddToggle("WS_Enabled", {
        Title = "Enable WalkSpeed",
        Default = false,
        Callback = function() end
    })

    PlayerTab:AddSlider("WS_Value", {
        Title = "WalkSpeed",
        Min = 16,
        Max = 500,
        Default = 50,
        Rounding = 1,
        Callback = function() end
    })

    PlayerTab:AddToggle("JP_Enabled", {
        Title = "Enable JumpPower",
        Default = false,
        Callback = function() end
    })

    PlayerTab:AddSlider("JP_Value", {
        Title = "JumpPower",
        Min = 50,
        Max = 500,
        Default = 100,
        Rounding = 1,
        Callback = function() end
    })

    PlayerTab:AddToggle("InfiniteJump", {
        Title = "Infinite Jump",
        Default = false,
        Callback = function() end
    })

    PlayerTab:AddSection("Fly & Noclip")

    PlayerTab:AddToggle("Fly_Enabled", {
        Title = "Fly",
        Default = false,
        Callback = function() end
    })

    PlayerTab:AddSlider("Fly_Speed", {
        Title = "Fly Speed",
        Min = 10,
        Max = 300,
        Default = 50,
        Rounding = 1,
        Callback = function() end
    })

    local noclipLoop
    PlayerTab:AddToggle("NoclipEnabled", {
        Title = "Noclip",
        Default = false,
        Callback = function(enabled)
            if enabled then
                noclipLoop = RunService.Stepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if noclipLoop then noclipLoop:Disconnect() end
            end
        end
    })

    PlayerTab:AddSection("Character")

    PlayerTab:AddToggle("Invisibility", {
        Title = "Local Invisibility",
        Default = false,
        Callback = function(enabled)
            local char = LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Decal") then
                        v.Transparency = enabled and 1 or 0
                        if v.Name == "HumanoidRootPart" then v.Transparency = 1 end
                    end
                end
            end
        end
    })

    -- Player Hooks
    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Options.WS_Enabled and Options.WS_Enabled.Value then
                LocalPlayer.Character.Humanoid.WalkSpeed = Options.WS_Value.Value
            end
            if Options.JP_Enabled and Options.JP_Enabled.Value then
                LocalPlayer.Character.Humanoid.JumpPower = Options.JP_Value.Value
            end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if Options.InfiniteJump and Options.InfiniteJump.Value then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end
    end)

    -- Fly Logic
    local flying = false
    RunService.RenderStepped:Connect(function()
        if Options.Fly_Enabled and Options.Fly_Enabled.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            flying = true
            local root = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character.Humanoid
            
            hum.PlatformStand = true
            
            local velocity = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + (Camera.CFrame.LookVector * Options.Fly_Speed.Value)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - (Camera.CFrame.LookVector * Options.Fly_Speed.Value)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - (Camera.CFrame.RightVector * Options.Fly_Speed.Value)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + (Camera.CFrame.RightVector * Options.Fly_Speed.Value)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, Options.Fly_Speed.Value, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, Options.Fly_Speed.Value, 0)
            end
            
            root.Velocity = velocity
        elseif flying then
            flying = false
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.PlatformStand = false
            end
        end
    end)
end

-- ============================================
-- TELEPORT SECTION
-- ============================================
do
    local TeleportTab = Tabs.Teleport
    TeleportTab:AddSection("Target Teleport")

    local function getPlayerNames()
        local names = {}
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer then table.insert(names, v.Name) end
        end
        return names
    end

    local TeleportDropdown = TeleportTab:AddDropdown("TeleportTarget", {
        Title = "Select Player",
        Values = getPlayerNames(),
        Multi = false,
        Callback = function() end
    })

    TeleportTab:AddButton({
        Title = "Refresh Players",
        Callback = function()
            TeleportDropdown:Refresh(getPlayerNames())
        end
    })

    TeleportTab:AddButton({
        Title = "Teleport to Target",
        Callback = function()
            local targetName = Options.TeleportTarget.Value
            local target = Players:FindFirstChild(targetName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end
    })

    TeleportTab:AddSection("Quick Teleport")
    
    TeleportTab:AddButton({
        Title = "Teleport to Click (Tool)",
        Callback = function()
            local tool = Instance.new("Tool")
            tool.Name = "Click TP"
            tool.RequiresHandle = false
            tool.Parent = LocalPlayer.Backpack
            
            tool.Activated:Connect(function()
                local pos = Mouse.Hit.p
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                end
            end)
            
            Spiem:Notify({Title = "Misc", Content = "TP Tool added to backpack", Duration = 3})
        end
    })
end

-- ============================================
-- MISC SECTION
-- ============================================
do
    local MiscTab = Tabs.Misc
    MiscTab:AddSection("Utils")

    MiscTab:AddButton({
        Title = "Anti AFK",
        Callback = function()
            local vu = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
            end)
            Spiem:Notify({Title = "Misc", Content = "Anti-AFK Activated", Duration = 3})
        end
    })

    MiscTab:AddButton({
        Title = "Rejoin Server",
        Callback = function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    })

    MiscTab:AddButton({
        Title = "Server Hop",
        Callback = function()
            local servers = {}
            local res = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local data = HttpService:JSONDecode(res)
            
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
            
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
            else
                Spiem:Notify({Title = "Error", Content = "No other servers found", Duration = 3})
            end
        end
    })
end

-- ============================================
-- SETTINGS SECTION
-- ============================================
do
    local SettingsTab = Tabs.Settings
    local SaveManager = Spiem.SaveManager
    local InterfaceManager = Spiem.InterfaceManager

    SaveManager:SetLibrary(Spiem)
    InterfaceManager:SetLibrary(Spiem)
    
    SaveManager:SetFolder("SpiemUniversal")
    InterfaceManager:SetFolder("SpiemUniversal")
    
    SaveManager:IgnoreThemeSettings()
    SaveManager:BuildConfigSection(SettingsTab)
    InterfaceManager:BuildInterfaceSection(SettingsTab)

    SaveManager:LoadAutoloadConfig()
end

-- Set Premium Theme & Acrylic by default for a WOW effect
task.spawn(function()
    task.wait(0.5)
    Spiem.CurrentTheme = "Spiem Premium"
    Spiem.Acrylic = true
    Window:UpdateTheme()
end)

Spiem:Notify({
    Title = "Ready!",
    Content = "All features are active.\nEnjoy using Spiem Universal Hub.",
    Duration = 3
})
