--[[
    SpiemUI Library v1.0.0
    Modern Fluent-style UI Library for Roblox
    
    Kullanım:
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/perfectusmim1/rblxui/refs/heads/main/SpiemUI.lua"))()
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Library = {
    Version = "1.0.0",
    Options = {},
    Themes = {"Dark", "Darker", "Light", "Aqua", "Rose", "Amethyst"},
    Theme = "Dark",
    Unloaded = false,
    DialogOpen = false,
    UseAcrylic = false,
    Transparency = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    GUI = nil,
    Window = nil,
    WindowFrame = nil
}

-- Tema renkleri
Library.ThemeColors = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 35),
        Secondary = Color3.fromRGB(40, 40, 48),
        Tertiary = Color3.fromRGB(50, 50, 60),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        Accent = Color3.fromRGB(96, 205, 255),
        Border = Color3.fromRGB(60, 60, 70)
    },
    Darker = {
        Primary = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(28, 28, 35),
        Tertiary = Color3.fromRGB(38, 38, 48),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 160),
        Accent = Color3.fromRGB(96, 205, 255),
        Border = Color3.fromRGB(45, 45, 55)
    },
    Light = {
        Primary = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(235, 235, 242),
        Tertiary = Color3.fromRGB(225, 225, 235),
        Text = Color3.fromRGB(30, 30, 35),
        SubText = Color3.fromRGB(100, 100, 110),
        Accent = Color3.fromRGB(50, 150, 255),
        Border = Color3.fromRGB(200, 200, 210)
    },
    Aqua = {
        Primary = Color3.fromRGB(25, 35, 45),
        Secondary = Color3.fromRGB(30, 45, 55),
        Tertiary = Color3.fromRGB(40, 55, 68),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 200, 210),
        Accent = Color3.fromRGB(0, 200, 200),
        Border = Color3.fromRGB(50, 70, 85)
    },
    Rose = {
        Primary = Color3.fromRGB(40, 28, 35),
        Secondary = Color3.fromRGB(50, 35, 45),
        Tertiary = Color3.fromRGB(65, 45, 58),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(210, 180, 195),
        Accent = Color3.fromRGB(255, 100, 150),
        Border = Color3.fromRGB(80, 55, 70)
    },
    Amethyst = {
        Primary = Color3.fromRGB(35, 28, 50),
        Secondary = Color3.fromRGB(45, 38, 65),
        Tertiary = Color3.fromRGB(58, 48, 80),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 180, 220),
        Accent = Color3.fromRGB(180, 100, 255),
        Border = Color3.fromRGB(70, 55, 95)
    }
}

local function GetTheme()
    return Library.ThemeColors[Library.Theme] or Library.ThemeColors.Dark
end

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(inst, props, dur, style)
    local t = TweenService:Create(inst, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function AddCorner(p, r)
    return Create("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p})
end

local function AddStroke(p, c, t)
    return Create("UIStroke", {Color = c or GetTheme().Border, Thickness = t or 1, Parent = p})
end

local function Ripple(parent)
    local r = Create("Frame", {
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 0.8,
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        Parent = parent
    })
    AddCorner(r, 999)
    local s = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    Tween(r, {Size = UDim2.new(0,s,0,s), BackgroundTransparency = 1}, 0.5)
    task.delay(0.5, function() r:Destroy() end)
end

-- Notification
local function CreateNotification(opts)
    local theme = GetTheme()
    opts = opts or {}
    local container = Library.GUI:FindFirstChild("NotifContainer") or Create("Frame", {
        Name = "NotifContainer", BackgroundTransparency = 1, Size = UDim2.new(0, 300, 1, -20),
        Position = UDim2.new(1, -310, 0, 10), Parent = Library.GUI
    })
    if not container:FindFirstChildOfClass("UIListLayout") then
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = container})
    end
    local h = opts.SubContent and 70 or 55
    local frame = Create("Frame", {BackgroundColor3 = theme.Primary, Size = UDim2.new(1, 0, 0, h), Position = UDim2.new(1, 50, 0, 0), Parent = container})
    AddCorner(frame, 10); AddStroke(frame, theme.Border, 1)
    Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new(0, 4, 1, -10), Position = UDim2.new(0, 5, 0, 5), Parent = frame})
    Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -35, 0, 20), Position = UDim2.new(0, 15, 0, 5), Text = opts.Title or "Notification", TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
    Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 15, 0, 27), Text = opts.Content or "", TextColor3 = theme.SubText, TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
    local function close() Tween(frame, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3); task.delay(0.3, function() frame:Destroy() end) end
    task.delay(0.05, function() Tween(frame, {Position = UDim2.new(0, 0, 0, 0)}, 0.3) end)
    if opts.Duration then task.delay(opts.Duration, close) end
    return frame
end

-- Dialog
local function CreateDialog(parent, opts)
    local theme = GetTheme()
    Library.DialogOpen = true
    local overlay = Create("Frame", {BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 100, Parent = Library.GUI})
    local dialog = Create("Frame", {BackgroundColor3 = theme.Primary, Size = UDim2.new(0, 320, 0, 0), Position = UDim2.new(0.5, -160, 0.5, -80), ZIndex = 101, Parent = overlay})
    AddCorner(dialog, 12); AddStroke(dialog, theme.Border, 1)
    Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -30, 0, 24), Position = UDim2.new(0, 15, 0, 15), Text = opts.Title or "Dialog", TextColor3 = theme.Text, TextSize = 16, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101, Parent = dialog})
    local btnFrame = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -30, 0, 36), Position = UDim2.new(0, 15, 1, -50), ZIndex = 101, Parent = dialog})
    Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 10), Parent = btnFrame})
    local function close() Tween(overlay, {BackgroundTransparency = 1}, 0.2); Tween(dialog, {Size = UDim2.new(0, 320, 0, 0)}, 0.2); task.delay(0.2, function() overlay:Destroy(); Library.DialogOpen = false end) end
    for i, cfg in ipairs(opts.Buttons or {}) do
        local btn = Create("TextButton", {BackgroundColor3 = i==1 and theme.Accent or theme.Tertiary, Size = UDim2.new(0, 90, 0, 32), Text = cfg.Title or "Button", TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamMedium, ZIndex = 101, Parent = btnFrame})
        AddCorner(btn, 8); btn.MouseButton1Click:Connect(function() close(); if cfg.Callback then cfg.Callback() end end)
    end
    Tween(overlay, {BackgroundTransparency = 0.5}, 0.2); Tween(dialog, {Size = UDim2.new(0, 320, 0, 160)}, 0.25, Enum.EasingStyle.Back)
end

-- Element Creators
local function CreateButton(parent, opts)
    local theme = GetTheme()
    local h = opts.Description and 50 or 36
    local frame = Create("Frame", {BackgroundColor3 = theme.Secondary, Size = UDim2.new(1, 0, 0, h), Parent = parent})
    AddCorner(frame, 8)
    local btn = Create("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = "", Parent = frame})
    Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -40, 0, 20), Position = opts.Description and UDim2.new(0, 10, 0, 6) or UDim2.new(0, 10, 0.5, -10), Text = opts.Title or "Button", TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
    btn.MouseButton1Click:Connect(function() Ripple(frame); if opts.Callback then opts.Callback() end end)
    return {SetTitle = function(self, t) frame.TextLabel.Text = t end}, frame
end

local function CreateToggle(parent, idx, opts)
    local theme = GetTheme()
    local value = opts.Default or false
    local frame = Create("Frame", {BackgroundColor3 = theme.Secondary, Size = UDim2.new(1, 0, 0, opts.Description and 50 or 36), Parent = parent})
    AddCorner(frame, 8)
    local switch = Create("Frame", {BackgroundColor3 = value and theme.Accent or theme.Tertiary, Size = UDim2.new(0, 44, 0, 24), Position = UDim2.new(1, -54, 0.5, -12), Parent = frame})
    AddCorner(switch, 12)
    local knob = Create("Frame", {BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 18, 0, 18), Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), Parent = switch})
    AddCorner(knob, 9)
    local btn = Create("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = "", Parent = frame})
    local function update() Tween(switch, {BackgroundColor3 = value and theme.Accent or theme.Tertiary}, 0.2); Tween(knob, {Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.2) end
    local api = {Value = value, Type = "Toggle"}
    function api:SetValue(v) value = v; self.Value = v; update(); if opts.Callback then opts.Callback(v) end end
    function api:OnChanged(cb) self.Changed = cb end
    btn.MouseButton1Click:Connect(function() api:SetValue(not value); if api.Changed then api.Changed(value) end end)
    Library.Options[idx] = api
    return api, frame
end

local function CreateSlider(parent, idx, opts)
    local theme = GetTheme()
    local value = math.clamp(opts.Default or 0, opts.Min or 0, opts.Max or 100)
    local frame = Create("Frame", {BackgroundColor3 = theme.Secondary, Size = UDim2.new(1, 0, 0, 56), Parent = parent})
    AddCorner(frame, 8)
    local track = Create("Frame", {BackgroundColor3 = theme.Tertiary, Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 1, -16), Parent = frame})
    local fill = Create("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new((value-(opts.Min or 0))/((opts.Max or 100)-(opts.Min or 0)), 0, 1, 0), Parent = track})
    local knob = Create("Frame", {BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(fill.Size.X.Scale, -8, 0.5, -8), Parent = track})
    AddCorner(knob, 8)
    local api = {Value = value, Type = "Slider"}
    function api:SetValue(v)
        value = math.clamp(v, opts.Min or 0, opts.Max or 100)
        local pct = (value-(opts.Min or 0))/((opts.Max or 100)-(opts.Min or 0))
        fill.Size = UDim2.new(pct, 0, 1, 0); knob.Position = UDim2.new(pct, -8, 0.5, -8)
        self.Value = value; if opts.Callback then opts.Callback(value) end
        if self.Changed then self.Changed(value) end
    end
    track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then local d = true; local c; c = UserInputService.InputEnded:Connect(function(e) if e.UserInputType == Enum.UserInputType.MouseButton1 then d = false; c:Disconnect() end end) while d do local m = UserInputService:GetMouseLocation(); local p = math.clamp((m.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) api:SetValue((opts.Min or 0) + ((opts.Max or 100) - (opts.Min or 0)) * p) task.wait() end end end)
    Library.Options[idx] = api
    return api, frame
end

local function CreateDropdown(parent, idx, opts)
    local theme = GetTheme()
    local frame = Create("Frame", {BackgroundColor3 = theme.Secondary, Size = UDim2.new(1, 0, 0, 36), ClipsDescendants = true, Parent = parent})
    AddCorner(frame, 8)
    local api = {Value = opts.Default, Type = "Dropdown", Multi = opts.Multi}
    function api:SetValue(v) self.Value = v; if opts.Callback then opts.Callback(v) end; if self.Changed then self.Changed(v) end end
    function api:SetValues(v) opts.Values = v end
    Library.Options[idx] = api
    return api, frame
end

local function CreateInput(parent, idx, opts)
    local theme = GetTheme()
    local frame = Create("Frame", {BackgroundColor3 = theme.Secondary, Size = UDim2.new(1, 0, 0, 56), Parent = parent})
    AddCorner(frame, 8)
    local box = Create("TextBox", {BackgroundTransparency = 0.5, BackgroundColor3 = theme.Tertiary, Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 1, -34), Text = opts.Default or "", TextColor3 = theme.Text, Parent = frame})
    AddCorner(box, 6)
    local api = {Value = box.Text, Type = "Input"}
    box.FocusLost:Connect(function() api.Value = box.Text; if opts.Callback then opts.Callback(box.Text) end; if api.Changed then api.Changed(box.Text) end end)
    Library.Options[idx] = api
    return api, frame
end

-- Tab & Window
local function CreateTab(container, list, opts)
    local theme = GetTheme()
    local btn = Create("TextButton", {BackgroundColor3 = theme.Secondary, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Text = opts.Title or "Tab", TextColor3 = theme.SubText, Parent = list})
    AddCorner(btn, 8)
    local page = Create("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, CanvasSize = UDim2.new(0,0,0,0), Parent = container})
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = page})
    local api = {Page = page, Button = btn}
    function api:AddButton(o) return CreateButton(page, o) end
    function api:AddToggle(i, o) return CreateToggle(page, i, o) end
    function api:AddSlider(i, o) return CreateSlider(page, i, o) end
    function api:AddDropdown(i, o) return CreateDropdown(page, i, o) end
    function api:AddInput(i, o) return CreateInput(page, i, o) end
    function api:AddParagraph(o) local f = Create("Frame", {BackgroundColor3 = theme.Secondary, Size = UDim2.new(1,0,0,60), Parent = page}); AddCorner(f, 8); Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1,-20,1,-10), Position = UDim2.new(0,10,0,5), Text = (o.Title or "").."\n"..(o.Content or ""), TextColor3 = theme.Text, TextWrapped = true, Parent = f}) end
    function api:AddSection(t)
        local s = Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,24), Text = t, TextColor3 = theme.SubText, Font = Enum.Font.GothamBold, Parent = page})
        return api
    end
    return api
end

function Library:CreateWindow(opts)
    local theme = GetTheme()
    self.Theme = opts.Theme or "Dark"
    local gui = Create("ScreenGui", {Name = "SpiemUI", ResetOnSpawn = false})
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    self.GUI = gui
    local main = Create("Frame", {BackgroundColor3 = theme.Primary, Size = opts.Size or UDim2.fromOffset(580, 460), Position = UDim2.new(0.5, -290, 0.5, -230), Parent = gui})
    AddCorner(main, 12); AddStroke(main, theme.Border, 1); self.WindowFrame = main
    local list = Create("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.new(0, 160, 1, -60), Position = UDim2.new(0, 10, 0, 55), Parent = main})
    Create("UIListLayout", {Padding = UDim.new(0, 4), Parent = list})
    local container = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -185, 1, -60), Position = UDim2.new(0, 175, 0, 55), Parent = main})
    local tabs = {}
    local window = {}
    function window:AddTab(o)
        local t = CreateTab(container, list, o)
        table.insert(tabs, t)
        t.Button.MouseButton1Click:Connect(function()
            for _, v in pairs(tabs) do v.Page.Visible = false; v.Button.BackgroundTransparency = 1 end
            t.Page.Visible = true; t.Button.BackgroundTransparency = 0
        end)
        if #tabs == 1 then t.Page.Visible = true; t.Button.BackgroundTransparency = 0 end
        return t
    end
    function window:Dialog(o) return CreateDialog(main, o) end
    function window:SelectTab(i) if tabs[i] then tabs[i].Page.Visible = true end end
    return window
end

function Library:Notify(o) return CreateNotification(o) end
function Library:ToggleTransparency(v) if self.WindowFrame then self.WindowFrame.BackgroundTransparency = v and 0.1 or 0 end end
function Library:Destroy() if self.GUI then self.GUI:Destroy() end end

return Library
