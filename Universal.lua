--[[
    SpiemUI V1.4.1 - Advanced Universal Script
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
    ClickTP = false,
    TPDelay = 1
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
    Player = Window:AddTab("Player"),
    Visuals = Window:AddTab("Visuals"),
    Teleport = Window:AddTab("Teleport"),
    Misc = Window:AddTab("Misc"),
    Settings = Window:AddTab("Settings")
}

-- Notify on Load
Spiem:Notify({
    Title = "Spiem Universal",
    Content = "Script loaded successfully!\nLeft CTRL to toggle menu.",
    Duration = 5
})

-- ============================================
-- PLAYER TAB
-- ============================================
do
    Tabs.Player:AddParagraph({
        Title = "Movement Settings",
        Content = "Adjust your character's speed and jump values."
    })

    Tabs.Player:AddSlider("WalkSpeed", {
        Title = "Walk Speed",
        Min = 16,
        Max = 500,
        Default = 16,
        Rounding = 1,
        Callback = function(v) Config.WalkSpeed = v end
    })

    Tabs.Player:AddSlider("JumpPower", {
        Title = "Jump Power",
        Min = 50,
        Max = 500,
        Default = 50,
        Rounding = 1,
        Callback = function(v) Config.JumpPower = v end
    })

    Tabs.Player:AddSlider("Gravity", {
        Title = "Gravity",
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
        Title = "Infinite Jump",
        Default = false,
        Callback = function(v)
            Config.InfiniteJump = v
            Spiem:Notify({Title = "Infinite Jump", Content = v and "Enabled!" or "Disabled.", Duration = 2})
        end
    })

    Tabs.Player:AddToggle("Noclip", {
        Title = "Noclip (Walk Through Walls)",
        Default = false,
        Callback = function(v)
            Config.Noclip = v
            Spiem:Notify({Title = "Noclip", Content = v and "Enabled!" or "Disabled.", Duration = 2})
        end
    })

    Tabs.Player:AddToggle("FlyToggle", {
        Title = "Fly",
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
            Spiem:Notify({Title = "Fly", Content = v and "WASD + Space/Shift to fly!" or "Disabled.", Duration = 2})
        end
    })

    Tabs.Player:AddSlider("FlySpeed", {
        Title = "Fly Speed",
        Min = 10,
        Max = 300,
        Default = 50,
        Rounding = 1,
        Callback = function(v) Config.FlySpeed = v end
    })

    Tabs.Player:AddButton({
        Title = "Respawn Character",
        Callback = function()
            LP.Character:FindFirstChildOfClass("Humanoid").Health = 0
            Spiem:Notify({Title = "Character", Content = "Respawning...", Duration = 2})
        end
    })
end

-- ============================================
-- VISUALS TAB
-- ============================================
do
    Tabs.Visuals:AddParagraph({Title = "ESP Settings", Content = "See other players through walls."})

    Tabs.Visuals:AddToggle("ESPToggle", {
        Title = "Player ESP",
        Default = false,
        Callback = function(v)
            Config.ESP = v
            Spiem:Notify({Title = "ESP", Content = v and "Enabled!" or "Disabled.", Duration = 2})
        end
    })

    Tabs.Visuals:AddColorpicker("ESPColor", {
        Title = "ESP Color",
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
            Spiem:Notify({Title = "Fullbright", Content = v and "Enabled!" or "Disabled.", Duration = 2})
        end
    })

    Tabs.Visuals:AddToggle("NoFog", {
        Title = "Remove Fog",
        Default = false,
        Callback = function(v)
            Config.NoFog = v
            Lighting.FogEnd = v and 100000 or 1000
            Spiem:Notify({Title = "Fog", Content = v and "Removed!" or "Restored.", Duration = 2})
        end
    })

    Tabs.Visuals:AddDropdown("TimeOfDay", {
        Title = "Time of Day",
        Values = {"Morning", "Noon", "Evening", "Night"},
        Default = "Noon",
        Multi = false,
        Callback = function(v)
            local times = {Morning = 6, Noon = 12, Evening = 18, Night = 0}
            Lighting.ClockTime = times[v] or 12
        end
    })
end

-- ============================================
-- TELEPORT TAB
-- ============================================
local SelectedPlayers = {}
local TPPlayerDropdown

do
    Tabs.Teleport:AddParagraph({Title = "Teleport", Content = "Teleport to players or coordinates."})

    Tabs.Teleport:AddToggle("ClickTP", {
        Title = "Click Teleport (Ctrl + Click)",
        Default = false,
        Callback = function(v)
            Config.ClickTP = v
            Spiem:Notify({Title = "Click TP", Content = v and "CTRL + Mouse to teleport!" or "Disabled.", Duration = 2})
        end
    })

    -- Get player names
    local function getPlayerNames()
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(names, p.Name) end
        end
        return names
    end

    -- Single player teleport
    Tabs.Teleport:AddDropdown("TPPlayer", {
        Title = "Teleport to Player",
        Values = getPlayerNames(),
        Default = getPlayerNames()[1] or "None",
        Multi = false,
        Callback = function(v)
            local target = Players:FindFirstChild(v)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                Spiem:Notify({Title = "Teleport", Content = "Teleported to " .. v .. "!", Duration = 2})
            end
        end
    })

    -- Multi-select players for sequential TP
    TPPlayerDropdown = Tabs.Teleport:AddDropdown("MultiTPPlayers", {
        Title = "Select Players (Multi)",
        Values = getPlayerNames(),
        Multi = true,
        Default = {},
        Callback = function(selected)
            SelectedPlayers = {}
            for name, isSelected in pairs(selected) do
                if isSelected then table.insert(SelectedPlayers, name) end
            end
        end
    })

    Tabs.Teleport:AddSlider("TPDelay", {
        Title = "TP Delay (seconds)",
        Min = 0.5,
        Max = 10,
        Default = 1,
        Rounding = 0.5,
        Callback = function(v) Config.TPDelay = v end
    })

    Tabs.Teleport:AddButton({
        Title = "Sequential Teleport",
        Description = "Teleport to all selected players with delay",
        Callback = function()
            if #SelectedPlayers == 0 then
                Spiem:Notify({Title = "Error", Content = "No players selected!", Duration = 2})
                return
            end

            Spiem:Notify({Title = "Sequential TP", Content = "Starting teleport to " .. #SelectedPlayers .. " players...", Duration = 3})

            task.spawn(function()
                for i, playerName in ipairs(SelectedPlayers) do
                    local target = Players:FindFirstChild(playerName)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                        Spiem:Notify({Title = "Teleport " .. i .. "/" .. #SelectedPlayers, Content = "Teleported to " .. playerName, Duration = Config.TPDelay})
                        task.wait(Config.TPDelay)
                    end
                end
                Spiem:Notify({Title = "Complete", Content = "Sequential teleport finished!", Duration = 3})
            end)
        end
    })

    Tabs.Teleport:AddButton({
        Title = "Refresh Player List",
        Callback = function()
            local newNames = getPlayerNames()
            TPPlayerDropdown:Refresh(newNames)
            Spiem.Options.TPPlayer:Refresh(newNames)
            Spiem:Notify({Title = "Refreshed", Content = "Player list updated!", Duration = 2})
        end
    })

    Tabs.Teleport:AddButton({
        Title = "Teleport to Spawn",
        Callback = function()
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
            Spiem:Notify({Title = "Teleport", Content = "Teleported to spawn.", Duration = 2})
        end
    })

    Tabs.Teleport:AddInput("CustomTP", {
        Title = "Coordinates (X,Y,Z)",
        Placeholder = "0,50,0",
        Callback = function(v)
            local coords = string.split(v, ",")
            if #coords == 3 then
                local x, y, z = tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3])
                if x and y and z then
                    LP.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
                    Spiem:Notify({Title = "Teleport", Content = "Teleported to coordinates!", Duration = 2})
                end
            end
        end
    })
end

-- ============================================
-- MISC TAB
-- ============================================
do
    Tabs.Misc:AddParagraph({Title = "Extra Features", Content = "Anti-AFK, server tools and more."})

    Tabs.Misc:AddToggle("AntiAFK", {
        Title = "Anti-AFK",
        Default = true,
        Callback = function(v)
            Config.AntiAFK = v
            Spiem:Notify({Title = "Anti-AFK", Content = v and "You won't be kicked!" or "Disabled.", Duration = 2})
        end
    })

    Tabs.Misc:AddButton({
        Title = "List All Players",
        Callback = function()
            local list = ""
            for _, p in pairs(Players:GetPlayers()) do list = list .. p.Name .. "\n" end
            Spiem:Notify({Title = "Players (" .. #Players:GetPlayers() .. ")", Content = list, Duration = 8})
        end
    })

    Tabs.Misc:AddButton({
        Title = "Server Info",
        Callback = function()
            local info = "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
            info = info .. "\nPlaceId: " .. game.PlaceId
            info = info .. "\nPlayers: " .. #Players:GetPlayers()
            Spiem:Notify({Title = "Server", Content = info, Duration = 10})
        end
    })

    Tabs.Misc:AddButton({
        Title = "Rejoin",
        Description = "Reconnect to the same server",
        Callback = function()
            Spiem:Notify({Title = "Rejoin", Content = "Reconnecting...", Duration = 2})
            task.wait(1)
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end
    })

    Tabs.Misc:AddButton({
        Title = "Server Hop",
        Description = "Jump to another server",
        Callback = function()
            Spiem:Notify({Title = "Server Hop", Content = "Finding server...", Duration = 2})
            task.wait(1)
            local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LP)
                    return
                end
            end
            Spiem:Notify({Title = "Error", Content = "No suitable server found!", Duration = 3})
        end
    })
end

-- ============================================
-- SETTINGS TAB - Config & Interface
-- ============================================
do
    -- Interface Section
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)

    -- Config Section
    SaveManager:BuildConfigSection(Tabs.Settings)

    Tabs.Settings:AddButton({
        Title = "Close Script",
        Description = "Disables all features and removes menu",
        Callback = function() Window:Destroy() end
    })

    Tabs.Settings:AddParagraph({
        Title = "About",
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

Spiem:Notify({Title = "Ready!", Content = "All features active. Have fun!", Duration = 3})
