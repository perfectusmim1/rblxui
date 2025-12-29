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

--[[
    NOTIFICATION COMPONENT
]]
local function CreateNotification(opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Notification"
    opts.Content = opts.Content or ""
    opts.SubContent = opts.SubContent
    opts.Duration = opts.Duration or 5

    if not Library.GUI then return end

    local container = Library.GUI:FindFirstChild("NotifContainer")
    if not container then
        container = Create("Frame", {
            Name = "NotifContainer",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 300, 1, -20),
            Position = UDim2.new(1, -310, 0, 10),
            Parent = Library.GUI
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = container
        })
    end

    local h = opts.SubContent and 70 or 55
    local frame = Create("Frame", {
        BackgroundColor3 = theme.Primary,
        Size = UDim2.new(1, 0, 0, h),
        Position = UDim2.new(1, 50, 0, 0),
        Parent = container
    })
    AddCorner(frame, 10)
    AddStroke(frame, theme.Border, 1)

    Create("Frame", {
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new(0, 4, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        Parent = frame
    }):FindFirstChildOfClass("UICorner") or AddCorner(frame:FindFirstChild("Frame"), 2)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -35, 0, 20),
        Position = UDim2.new(0, 15, 0, 5),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 15, 0, 27),
        Text = opts.Content,
        TextColor3 = theme.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame
    })

    if opts.SubContent then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 16),
            Position = UDim2.new(0, 15, 0, 47),
            Text = opts.SubContent,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.3,
            Parent = frame
        })
    end

    local closeBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0, 5),
        Text = "×",
        TextColor3 = theme.SubText,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = frame
    })

    local function close()
        Tween(frame, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function() frame:Destroy() end)
    end

    closeBtn.MouseButton1Click:Connect(close)
    task.delay(0.05, function() Tween(frame, {Position = UDim2.new(0, 0, 0, 0)}, 0.3) end)
    if opts.Duration then task.delay(opts.Duration, close) end

    return frame
end

--[[
    DIALOG COMPONENT
]]
local function CreateDialog(parent, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Dialog"
    opts.Content = opts.Content or ""
    opts.Buttons = opts.Buttons or {}

    Library.DialogOpen = true

    local overlay = Create("Frame", {
        Name = "DialogOverlay",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 100,
        Parent = Library.GUI
    })

    local dialog = Create("Frame", {
        BackgroundColor3 = theme.Primary,
        Size = UDim2.new(0, 320, 0, 0),
        Position = UDim2.new(0.5, -160, 0.5, -80),
        ZIndex = 101,
        Parent = overlay
    })
    AddCorner(dialog, 12)
    AddStroke(dialog, theme.Border, 1)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 0, 24),
        Position = UDim2.new(0, 15, 0, 15),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101,
        Parent = dialog
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 0, 50),
        Position = UDim2.new(0, 15, 0, 43),
        Text = opts.Content,
        TextColor3 = theme.SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = 101,
        Parent = dialog
    })

    local btnFrame = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 0, 36),
        Position = UDim2.new(0, 15, 1, -50),
        ZIndex = 101,
        Parent = dialog
    })

    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 10),
        Parent = btnFrame
    })

    local function closeDialog()
        Tween(overlay, {BackgroundTransparency = 1}, 0.2)
        Tween(dialog, {Size = UDim2.new(0, 320, 0, 0)}, 0.2)
        task.delay(0.2, function()
            overlay:Destroy()
            Library.DialogOpen = false
        end)
    end

    for i, cfg in ipairs(opts.Buttons) do
        local isPrimary = i == 1
        local btn = Create("TextButton", {
            BackgroundColor3 = isPrimary and theme.Accent or theme.Tertiary,
            Size = UDim2.new(0, 90, 0, 32),
            Text = cfg.Title or "Button",
            TextColor3 = theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            ZIndex = 101,
            LayoutOrder = #opts.Buttons - i + 1,
            Parent = btnFrame
        })
        AddCorner(btn, 8)

        btn.MouseButton1Click:Connect(function()
            closeDialog()
            if cfg.Callback then task.spawn(cfg.Callback) end
        end)

        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = isPrimary and theme.Accent:Lerp(Color3.new(1,1,1), 0.1) or theme.Secondary}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = isPrimary and theme.Accent or theme.Tertiary}, 0.15)
        end)
    end

    Tween(overlay, {BackgroundTransparency = 0.5}, 0.2)
    Tween(dialog, {Size = UDim2.new(0, 320, 0, 160)}, 0.25, Enum.EasingStyle.Back)

    return dialog
end

--[[
    BUTTON COMPONENT
]]
local function CreateButton(parent, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Button"
    opts.Description = opts.Description
    opts.Callback = opts.Callback or function() end

    local h = opts.Description and 50 or 36

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        Parent = parent
    })
    AddCorner(frame, 8)

    local btn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = frame
    })

    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 20),
        Position = opts.Description and UDim2.new(0, 10, 0, 6) or UDim2.new(0, 10, 0.5, -10),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if opts.Description then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 0, 16),
            Position = UDim2.new(0, 10, 0, 26),
            Text = opts.Description,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local arrow = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        Text = "›",
        TextColor3 = theme.SubText,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = frame
    })

    btn.MouseEnter:Connect(function()
        Tween(frame, {BackgroundColor3 = theme.Tertiary}, 0.15)
        Tween(arrow, {Position = UDim2.new(1, -20, 0.5, -10)}, 0.15)
    end)

    btn.MouseLeave:Connect(function()
        Tween(frame, {BackgroundColor3 = theme.Secondary}, 0.15)
        Tween(arrow, {Position = UDim2.new(1, -25, 0.5, -10)}, 0.15)
    end)

    btn.MouseButton1Click:Connect(function()
        Ripple(frame)
        task.spawn(opts.Callback)
    end)

    local api = {}
    function api:SetTitle(t) title.Text = t end
    function api:SetDesc(d) if opts.Description then frame:FindFirstChild("TextLabel", true).Text = d end end
    function api:Destroy() frame:Destroy() end

    return api, frame
end

--[[
    TOGGLE COMPONENT
]]
local function CreateToggle(parent, idx, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Toggle"
    opts.Description = opts.Description
    opts.Default = opts.Default or false
    opts.Callback = opts.Callback or function() end

    local h = opts.Description and 50 or 36
    local value = opts.Default
    local callbacks = {}

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        Parent = parent
    })
    AddCorner(frame, 8)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 0, 20),
        Position = opts.Description and UDim2.new(0, 10, 0, 6) or UDim2.new(0, 10, 0.5, -10),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if opts.Description then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -70, 0, 16),
            Position = UDim2.new(0, 10, 0, 26),
            Text = opts.Description,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local switchBG = Create("Frame", {
        BackgroundColor3 = value and theme.Accent or theme.Tertiary,
        Size = UDim2.new(0, 44, 0, 24),
        Position = UDim2.new(1, -54, 0.5, -12),
        Parent = frame
    })
    AddCorner(switchBG, 12)

    local knob = Create("Frame", {
        BackgroundColor3 = Color3.new(1,1,1),
        Size = UDim2.new(0, 18, 0, 18),
        Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        Parent = switchBG
    })
    AddCorner(knob, 9)

    local btn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = frame
    })

    local function update()
        Tween(switchBG, {BackgroundColor3 = value and theme.Accent or theme.Tertiary}, 0.2)
        Tween(knob, {Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.2)
    end

    local function setValue(v)
        value = v
        update()
        task.spawn(opts.Callback, value)
        for _, cb in ipairs(callbacks) do task.spawn(cb, value) end
    end

    btn.MouseButton1Click:Connect(function() setValue(not value) end)
    btn.MouseEnter:Connect(function() Tween(frame, {BackgroundColor3 = theme.Tertiary}, 0.15) end)
    btn.MouseLeave:Connect(function() Tween(frame, {BackgroundColor3 = theme.Secondary}, 0.15) end)

    local api = {Value = value, Type = "Toggle"}
    function api:SetValue(v) setValue(v); self.Value = v end
    function api:OnChanged(cb) table.insert(callbacks, cb) end
    function api:Destroy() frame:Destroy() end

    Library.Options[idx] = api
    return api, frame
end

--[[
    SLIDER COMPONENT
]]
local function CreateSlider(parent, idx, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Slider"
    opts.Description = opts.Description
    opts.Default = opts.Default or 0
    opts.Min = opts.Min or 0
    opts.Max = opts.Max or 100
    opts.Rounding = opts.Rounding or 1
    opts.Callback = opts.Callback or function() end

    local h = opts.Description and 70 or 56
    local value = math.clamp(opts.Default, opts.Min, opts.Max)
    local dragging = false
    local callbacks = {}

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        Parent = parent
    })
    AddCorner(frame, 8)

    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local valueLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -60, 0, 6),
        Text = tostring(value),
        TextColor3 = theme.Accent,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = frame
    })

    if opts.Description then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 14),
            Position = UDim2.new(0, 10, 0, 24),
            Text = opts.Description,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local track = Create("Frame", {
        BackgroundColor3 = theme.Tertiary,
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 1, -16),
        Parent = frame
    })
    AddCorner(track, 3)

    local fill = Create("Frame", {
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new((value - opts.Min) / (opts.Max - opts.Min), 0, 1, 0),
        Parent = track
    })
    AddCorner(fill, 3)

    local knob = Create("Frame", {
        BackgroundColor3 = Color3.new(1,1,1),
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((value - opts.Min) / (opts.Max - opts.Min), -8, 0.5, -8),
        Parent = track
    })
    AddCorner(knob, 8)

    local sliderBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 10),
        Position = UDim2.new(0, 0, 0, -5),
        Text = "",
        Parent = track
    })

    local function round(n, d)
        local m = 10 ^ d
        return math.floor(n * m + 0.5) / m
    end

    local function updateVal(v)
        v = math.clamp(v, opts.Min, opts.Max)
        v = round(v, opts.Rounding)
        value = v
        local pct = (value - opts.Min) / (opts.Max - opts.Min)
        Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
        Tween(knob, {Position = UDim2.new(pct, -8, 0.5, -8)}, 0.1)
        valueLabel.Text = tostring(value)
        task.spawn(opts.Callback, value)
        for _, cb in ipairs(callbacks) do task.spawn(cb, value) end
    end

    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            updateVal(opts.Min + (opts.Max - opts.Min) * pct)
        end
    end)

    local api = {Value = value, Type = "Slider"}
    function api:SetValue(v) updateVal(v); self.Value = value end
    function api:OnChanged(cb) table.insert(callbacks, cb) end
    function api:Destroy() frame:Destroy() end

    Library.Options[idx] = api
    return api, frame
end

--[[
    PARAGRAPH COMPONENT
]]
local function CreateParagraph(parent, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Paragraph"
    opts.Content = opts.Content or ""

    local lines = 1
    for _ in string.gmatch(opts.Content, "\n") do lines = lines + 1 end
    local ch = lines * 16 + 10
    local h = 30 + ch

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        Parent = parent
    })
    AddCorner(frame, 8)

    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local content = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, ch),
        Position = UDim2.new(0, 10, 0, 27),
        Text = opts.Content,
        TextColor3 = theme.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = frame
    })

    local api = {}
    function api:SetTitle(t) title.Text = t end
    function api:SetContent(c) content.Text = c end
    function api:Destroy() frame:Destroy() end

    return api, frame
end

--[[
    DROPDOWN COMPONENT
]]
local function CreateDropdown(parent, idx, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Dropdown"
    opts.Description = opts.Description
    opts.Values = opts.Values or {}
    opts.Multi = opts.Multi or false
    opts.Default = opts.Default
    opts.AllowNull = opts.AllowNull or false
    opts.Callback = opts.Callback or function() end

    local h = opts.Description and 50 or 36
    local value = opts.Multi and {} or nil
    local isOpen = false
    local callbacks = {}
    local optBtns = {}

    if opts.Multi and type(opts.Default) == "table" then
        for _, v in ipairs(opts.Default) do value[v] = true end
    elseif not opts.Multi and opts.Default then
        value = type(opts.Default) == "number" and opts.Values[opts.Default] or opts.Default
    end

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        ClipsDescendants = true,
        Parent = parent
    })
    AddCorner(frame, 8)

    local header = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, h),
        Parent = frame
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = opts.Description and UDim2.new(0, 10, 0, 6) or UDim2.new(0, 10, 0.5, -10),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    if opts.Description then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, 0, 0, 16),
            Position = UDim2.new(0, 10, 0, 26),
            Text = opts.Description,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = header
        })
    end

    local function getDisplayText()
        if opts.Multi then
            local sel = {}
            for k, v in pairs(value) do if v then table.insert(sel, k) end end
            return #sel > 0 and table.concat(sel, ", ") or "None"
        else
            return value or "Select..."
        end
    end

    local selLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, -20, 0, 20),
        Position = UDim2.new(0.55, 0, 0.5, -10),
        Text = getDisplayText(),
        TextColor3 = theme.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header
    })

    local arrow = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        Text = "▼",
        TextColor3 = theme.SubText,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        Parent = header
    })

    local optContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, h + 5),
        Parent = frame
    })

    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = optContainer
    })

    local headerBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = header
    })

    local function updateOpts()
        for _, b in ipairs(optBtns) do b:Destroy() end
        optBtns = {}

        for i, ov in ipairs(opts.Values) do
            local isSel = opts.Multi and value[ov] or value == ov
            local optBtn = Create("TextButton", {
                BackgroundColor3 = isSel and theme.Accent or theme.Tertiary,
                BackgroundTransparency = isSel and 0.7 or 0,
                Size = UDim2.new(1, 0, 0, 28),
                Text = ov,
                TextColor3 = theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                Parent = optContainer
            })
            AddCorner(optBtn, 6)
            table.insert(optBtns, optBtn)

            optBtn.MouseButton1Click:Connect(function()
                if opts.Multi then
                    value[ov] = not value[ov]
                else
                    value = ov
                end
                selLabel.Text = getDisplayText()
                updateOpts()
                task.spawn(opts.Callback, value)
                for _, cb in ipairs(callbacks) do task.spawn(cb, value) end

                if not opts.Multi then
                    isOpen = false
                    Tween(frame, {Size = UDim2.new(1, 0, 0, h)}, 0.2)
                    Tween(arrow, {Rotation = 0}, 0.2)
                end
            end)
        end

        optContainer.Size = UDim2.new(1, -20, 0, #opts.Values * 30)
    end

    local function toggle()
        isOpen = not isOpen
        updateOpts()
        local th = isOpen and (h + 10 + #opts.Values * 30) or h
        Tween(frame, {Size = UDim2.new(1, 0, 0, th)}, 0.2)
        Tween(arrow, {Rotation = isOpen and 180 or 0}, 0.2)
    end

    headerBtn.MouseButton1Click:Connect(toggle)

    local api = {Value = value, Multi = opts.Multi, Type = "Dropdown"}
    function api:SetValue(v) if opts.Multi then value = v or {} else value = v end; self.Value = value; selLabel.Text = getDisplayText(); updateOpts() end
    function api:SetValues(v) opts.Values = v; updateOpts() end
    function api:OnChanged(cb) table.insert(callbacks, cb) end
    function api:Destroy() frame:Destroy() end

    Library.Options[idx] = api
    return api, frame
end

--[[
    INPUT COMPONENT
]]
local function CreateInput(parent, idx, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Input"
    opts.Description = opts.Description
    opts.Default = opts.Default or ""
    opts.Placeholder = opts.Placeholder or "Enter text..."
    opts.Numeric = opts.Numeric or false
    opts.Finished = opts.Finished or false
    opts.Callback = opts.Callback or function() end

    local h = opts.Description and 70 or 56
    local value = opts.Default
    local callbacks = {}

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        Parent = parent
    })
    AddCorner(frame, 8)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if opts.Description then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 14),
            Position = UDim2.new(0, 10, 0, 24),
            Text = opts.Description,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local inputFrame = Create("Frame", {
        BackgroundColor3 = theme.Tertiary,
        Size = UDim2.new(1, -20, 0, 28),
        Position = UDim2.new(0, 10, 1, -34),
        Parent = frame
    })
    AddCorner(inputFrame, 6)

    local inputBox = Create("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = value,
        PlaceholderText = opts.Placeholder,
        PlaceholderColor3 = theme.SubText,
        TextColor3 = theme.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = inputFrame
    })

    local function updateVal(v)
        if opts.Numeric then v = v:gsub("[^%d%.%-]", "") end
        value = v
        inputBox.Text = value
        task.spawn(opts.Callback, value)
        for _, cb in ipairs(callbacks) do task.spawn(cb, value) end
    end

    inputBox.Focused:Connect(function() Tween(inputFrame, {BackgroundColor3 = theme.Accent}, 0.15) end)
    inputBox.FocusLost:Connect(function(enter)
        Tween(inputFrame, {BackgroundColor3 = theme.Tertiary}, 0.15)
        if opts.Finished and enter then updateVal(inputBox.Text) end
    end)

    if not opts.Finished then
        inputBox:GetPropertyChangedSignal("Text"):Connect(function() updateVal(inputBox.Text) end)
    end

    local api = {Value = value, Type = "Input"}
    function api:SetValue(v) value = v; inputBox.Text = v; self.Value = v end
    function api:OnChanged(cb) table.insert(callbacks, cb) end
    function api:Destroy() frame:Destroy() end

    Library.Options[idx] = api
    return api, frame
end

--[[
    KEYBIND COMPONENT
]]
local function CreateKeybind(parent, idx, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Keybind"
    opts.Description = opts.Description
    opts.Default = opts.Default or "None"
    opts.Mode = opts.Mode or "Toggle"
    opts.Callback = opts.Callback or function() end
    opts.ChangedCallback = opts.ChangedCallback or function() end

    local h = opts.Description and 50 or 36
    local value = opts.Default
    local mode = opts.Mode
    local binding = false
    local holding = false
    local toggled = false
    local callbacks = {}
    local clickCbs = {}

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        Parent = parent
    })
    AddCorner(frame, 8)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 0, 20),
        Position = opts.Description and UDim2.new(0, 10, 0, 6) or UDim2.new(0, 10, 0.5, -10),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    if opts.Description then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -100, 0, 16),
            Position = UDim2.new(0, 10, 0, 26),
            Text = opts.Description,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })
    end

    local keyBtn = Create("TextButton", {
        BackgroundColor3 = theme.Tertiary,
        Size = UDim2.new(0, 80, 0, 24),
        Position = UDim2.new(1, -90, 0.5, -12),
        Text = value,
        TextColor3 = theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        Parent = frame
    })
    AddCorner(keyBtn, 6)

    local function getKeyName(kc)
        local n = kc.Name
        if n == "LeftControl" then return "LCtrl" elseif n == "RightControl" then return "RCtrl"
        elseif n == "LeftShift" then return "LShift" elseif n == "RightShift" then return "RShift"
        elseif n == "LeftAlt" then return "LAlt" elseif n == "RightAlt" then return "RAlt"
        else return n end
    end

    local function updateDisplay() keyBtn.Text = binding and "..." or value end

    keyBtn.MouseButton1Click:Connect(function() binding = true; updateDisplay() end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                value = getKeyName(input.KeyCode)
                binding = false
                updateDisplay()
                task.spawn(opts.ChangedCallback, input.KeyCode)
                for _, cb in ipairs(callbacks) do task.spawn(cb, input.KeyCode) end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                value = "MB1"; binding = false; updateDisplay()
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                value = "MB2"; binding = false; updateDisplay()
            end
            return
        end

        local match = false
        if input.UserInputType == Enum.UserInputType.Keyboard then
            match = getKeyName(input.KeyCode) == value
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            match = value == "MB1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            match = value == "MB2"
        end

        if match and not gp then
            if mode == "Always" then
                task.spawn(opts.Callback, true)
                for _, cb in ipairs(clickCbs) do task.spawn(cb) end
            elseif mode == "Toggle" then
                toggled = not toggled
                task.spawn(opts.Callback, toggled)
                for _, cb in ipairs(clickCbs) do task.spawn(cb) end
            elseif mode == "Hold" then
                holding = true
                task.spawn(opts.Callback, true)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if mode == "Hold" and holding then
            local match = false
            if input.UserInputType == Enum.UserInputType.Keyboard then
                match = getKeyName(input.KeyCode) == value
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                match = value == "MB1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                match = value == "MB2"
            end
            if match then holding = false; task.spawn(opts.Callback, false) end
        end
    end)

    local api = {Value = value, Mode = mode, Type = "Keybind"}
    function api:SetValue(v, m) value = v; mode = m or mode; self.Value = v; self.Mode = mode; updateDisplay() end
    function api:GetState() if mode == "Always" then return true elseif mode == "Toggle" then return toggled else return holding end end
    function api:OnClick(cb) table.insert(clickCbs, cb) end
    function api:OnChanged(cb) table.insert(callbacks, cb) end
    function api:Destroy() frame:Destroy() end

    Library.Options[idx] = api
    return api, frame
end

--[[
    COLORPICKER COMPONENT
]]
local function CreateColorpicker(parent, idx, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Colorpicker"
    opts.Description = opts.Description
    opts.Default = opts.Default or Color3.fromRGB(255, 255, 255)
    opts.Transparency = opts.Transparency
    opts.Callback = opts.Callback or function() end

    local h = opts.Description and 50 or 36
    local value = opts.Default
    local transparency = opts.Transparency or 0
    local isOpen = false
    local pickerH = 150
    local callbacks = {}
    local hue, sat, val = value:ToHSV()

    local frame = Create("Frame", {
        BackgroundColor3 = theme.Secondary,
        Size = UDim2.new(1, 0, 0, h),
        ClipsDescendants = true,
        Parent = parent
    })
    AddCorner(frame, 8)

    local header = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, h),
        Parent = frame
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 0, 20),
        Position = opts.Description and UDim2.new(0, 10, 0, 6) or UDim2.new(0, 10, 0.5, -10),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    if opts.Description then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 0, 16),
            Position = UDim2.new(0, 10, 0, 26),
            Text = opts.Description,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = header
        })
    end

    local preview = Create("Frame", {
        BackgroundColor3 = value,
        Size = UDim2.new(0, 30, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        Parent = header
    })
    AddCorner(preview, 6)

    local pickerContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, pickerH),
        Position = UDim2.new(0, 10, 0, h + 10),
        Parent = frame
    })

    local satValPicker = Create("Frame", {
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
        Size = UDim2.new(1, -35, 0, 100),
        Parent = pickerContainer
    })
    AddCorner(satValPicker, 6)

    local satValGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = satValPicker
    })

    local blackOverlay = Create("Frame", {
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = satValPicker
    })
    AddCorner(blackOverlay, 6)
    Create("UIGradient", {
        Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90,
        Parent = blackOverlay
    })

    local satValCursor = Create("Frame", {
        BackgroundColor3 = Color3.new(1,1,1),
        Size = UDim2.new(0, 10, 0, 10),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(hue, 0, 1-sat, 0),
        Parent = satValPicker
    })
    AddCorner(satValCursor, 5)
    AddStroke(satValCursor, Color3.new(0,0,0), 2)

    local hueSlider = Create("Frame", {
        Size = UDim2.new(0, 20, 0, 100),
        Position = UDim2.new(1, -20, 0, 0),
        Parent = pickerContainer
    })
    AddCorner(hueSlider, 6)

    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
            ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
            ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
            ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
        }),
        Rotation = 90,
        Parent = hueSlider
    })

    local hueCursor = Create("Frame", {
        BackgroundColor3 = Color3.new(1,1,1),
        Size = UDim2.new(1, 4, 0, 6),
        Position = UDim2.new(0, -2, hue, -3),
        Parent = hueSlider
    })
    AddCorner(hueCursor, 3)
    AddStroke(hueCursor, Color3.new(0,0,0), 1)

    local rgbFrame = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 110),
        Parent = pickerContainer
    })

    local rgbInputs = {}
    for i, lbl in ipairs({"R", "G", "B"}) do
        local inputFrame = Create("Frame", {
            BackgroundColor3 = theme.Tertiary,
            Size = UDim2.new(0.3, -5, 1, 0),
            Position = UDim2.new((i-1) * 0.33, 0, 0, 0),
            Parent = rgbFrame
        })
        AddCorner(inputFrame, 6)

        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            Text = lbl,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Parent = inputFrame
        })

        local input = Create("TextBox", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            Text = tostring(math.floor(value[lbl] * 255)),
            TextColor3 = theme.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
            Parent = inputFrame
        })
        rgbInputs[lbl] = input
    end

    local headerBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = header
    })

    local draggingSatVal, draggingHue = false, false

    local function updateColor()
        value = Color3.fromHSV(hue, sat, val)
        preview.BackgroundColor3 = value
        satValPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        satValCursor.Position = UDim2.new(sat, 0, 1-val, 0)
        hueCursor.Position = UDim2.new(0, -2, hue, -3)

        rgbInputs.R.Text = tostring(math.floor(value.R * 255))
        rgbInputs.G.Text = tostring(math.floor(value.G * 255))
        rgbInputs.B.Text = tostring(math.floor(value.B * 255))

        task.spawn(opts.Callback, value, transparency)
        for _, cb in ipairs(callbacks) do task.spawn(cb, value, transparency) end
    end

    satValPicker.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSatVal = true end end)
    hueSlider.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSatVal = false
            draggingHue = false
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            if draggingSatVal then
                sat = math.clamp((i.Position.X - satValPicker.AbsolutePosition.X) / satValPicker.AbsoluteSize.X, 0, 1)
                val = 1 - math.clamp((i.Position.Y - satValPicker.AbsolutePosition.Y) / satValPicker.AbsoluteSize.Y, 0, 1)
                updateColor()
            elseif draggingHue then
                hue = math.clamp((i.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                updateColor()
            end
        end
    end)

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local th = isOpen and (h + pickerH + 20) or h
        Tween(frame, {Size = UDim2.new(1, 0, 0, th)}, 0.2)
    end)

    local api = {Value = value, Transparency = transparency, Type = "Colorpicker"}
    function api:SetValueRGB(c, t)
        value = c
        transparency = t or 0
        hue, sat, val = c:ToHSV()
        self.Value = value
        self.Transparency = transparency
        updateColor()
    end
    function api:OnChanged(cb) table.insert(callbacks, cb) end
    function api:Destroy() frame:Destroy() end

    Library.Options[idx] = api
    return api, frame
end

--[[
    TAB COMPONENT
]]
local function CreateTab(contentArea, tabList, opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "Tab"
    opts.Icon = opts.Icon or ""

    local tabBtn = Create("TextButton", {
        BackgroundColor3 = theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Text = "",
        Parent = tabList
    })
    AddCorner(tabBtn, 8)

    local iconText = opts.Icon == "settings" and "⚙" or (opts.Icon ~= "" and "◆" or "")
    
    if iconText ~= "" then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 8, 0.5, -10),
            Text = iconText,
            TextColor3 = theme.SubText,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Parent = tabBtn
        })
    end

    local tabTitle = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, iconText ~= "" and -36 or -16, 1, 0),
        Position = UDim2.new(0, iconText ~= "" and 32 or 8, 0, 0),
        Text = opts.Title,
        TextColor3 = theme.SubText,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabBtn
    })

    local indicator = Create("Frame", {
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = tabBtn
    })
    AddCorner(indicator, 2)

    local page = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        Visible = false,
        Parent = contentArea
    })

    local pageLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = page
    })

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = page
    })

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end)

    local selected = false

    local function select()
        selected = true
        Tween(tabBtn, {BackgroundTransparency = 0}, 0.15)
        Tween(tabTitle, {TextColor3 = theme.Text}, 0.15)
        Tween(indicator, {Size = UDim2.new(0, 3, 0.6, 0)}, 0.2)
        page.Visible = true
    end

    local function deselect()
        selected = false
        Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
        Tween(tabTitle, {TextColor3 = theme.SubText}, 0.15)
        Tween(indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
        page.Visible = false
    end

    tabBtn.MouseEnter:Connect(function()
        if not selected then Tween(tabBtn, {BackgroundTransparency = 0.5}, 0.15) end
    end)

    tabBtn.MouseLeave:Connect(function()
        if not selected then Tween(tabBtn, {BackgroundTransparency = 1}, 0.15) end
    end)

    local tabApi = {
        Button = tabBtn,
        Page = page,
        Select = select,
        Deselect = deselect
    }

    function tabApi:AddSection(title)
        local sectionFrame = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = page
        })

        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 24),
            Text = title,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sectionFrame
        })

        local sectionContent = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 28),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = sectionFrame
        })

        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = sectionContent
        })

        local sectionApi = {}
        function sectionApi:AddButton(o) return CreateButton(sectionContent, o) end
        function sectionApi:AddToggle(i, o) return CreateToggle(sectionContent, i, o) end
        function sectionApi:AddSlider(i, o) return CreateSlider(sectionContent, i, o) end
        function sectionApi:AddDropdown(i, o) return CreateDropdown(sectionContent, i, o) end
        function sectionApi:AddInput(i, o) return CreateInput(sectionContent, i, o) end
        function sectionApi:AddKeybind(i, o) return CreateKeybind(sectionContent, i, o) end
        function sectionApi:AddColorpicker(i, o) return CreateColorpicker(sectionContent, i, o) end
        function sectionApi:AddParagraph(o) return CreateParagraph(sectionContent, o) end
        return sectionApi
    end

    function tabApi:AddButton(o) return CreateButton(page, o) end
    function tabApi:AddToggle(i, o) return CreateToggle(page, i, o) end
    function tabApi:AddSlider(i, o) return CreateSlider(page, i, o) end
    function tabApi:AddDropdown(i, o) return CreateDropdown(page, i, o) end
    function tabApi:AddInput(i, o) return CreateInput(page, i, o) end
    function tabApi:AddKeybind(i, o) return CreateKeybind(page, i, o) end
    function tabApi:AddColorpicker(i, o) return CreateColorpicker(page, i, o) end
    function tabApi:AddParagraph(o) return CreateParagraph(page, o) end

    return tabApi
end

--[[
    WINDOW COMPONENT
]]
local function CreateWindow(opts)
    local theme = GetTheme()
    opts = opts or {}
    opts.Title = opts.Title or "SpiemUI"
    opts.SubTitle = opts.SubTitle or ""
    opts.TabWidth = opts.TabWidth or 160
    opts.Size = opts.Size or UDim2.fromOffset(580, 460)
    opts.Acrylic = opts.Acrylic or false
    opts.Theme = opts.Theme or "Dark"
    opts.MinimizeKey = opts.MinimizeKey or Enum.KeyCode.LeftControl

    Library.Theme = opts.Theme
    Library.UseAcrylic = opts.Acrylic
    Library.MinimizeKey = opts.MinimizeKey

    local gui = Create("ScreenGui", {
        Name = "SpiemUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local success = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not success then gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    Library.GUI = gui

    local main = Create("Frame", {
        BackgroundColor3 = theme.Primary,
        Size = opts.Size,
        Position = UDim2.new(0.5, -opts.Size.X.Offset/2, 0.5, -opts.Size.Y.Offset/2),
        Parent = gui
    })
    AddCorner(main, 12)
    AddStroke(main, theme.Border, 1)

    Library.WindowFrame = main

    -- Title bar
    local titleBar = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = main
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 0, 22),
        Position = UDim2.new(0, 10, 0, 8),
        Text = opts.Title,
        TextColor3 = theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    if opts.SubTitle ~= "" then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -100, 0, 16),
            Position = UDim2.new(0, 10, 0, 28),
            Text = opts.SubTitle,
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleBar
        })
    end

    local minimizeBtn = Create("TextButton", {
        BackgroundColor3 = theme.Tertiary,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -75, 0, 10),
        Text = "─",
        TextColor3 = theme.SubText,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = titleBar
    })
    AddCorner(minimizeBtn, 8)

    local closeBtn = Create("TextButton", {
        BackgroundColor3 = Color3.fromRGB(200, 60, 60),
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 10),
        Text = "×",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = titleBar
    })
    AddCorner(closeBtn, 8)

    Create("Frame", {
        BackgroundColor3 = theme.Border,
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 50),
        Parent = main
    })

    local content = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 55),
        Parent = main
    })

    local tabList = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, opts.TabWidth, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent,
        Parent = content
    })

    local tabListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabList
    })

    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y)
    end)

    local tabContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -opts.TabWidth - 15, 1, 0),
        Position = UDim2.new(0, opts.TabWidth + 15, 0, 0),
        Parent = content
    })

    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil

    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)

    titleBar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Minimize
    local minimized = false
    local origSize = opts.Size

    local function toggleMinimize()
        minimized = not minimized
        if minimized then
            Tween(main, {Size = UDim2.new(0, origSize.X.Offset, 0, 50)}, 0.3)
            content.Visible = false
        else
            Tween(main, {Size = origSize}, 0.3)
            task.delay(0.15, function() content.Visible = true end)
        end
    end

    minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

    UserInputService.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Library.MinimizeKey then toggleMinimize() end
    end)

    closeBtn.MouseButton1Click:Connect(function() Library:Destroy() end)

    minimizeBtn.MouseEnter:Connect(function() Tween(minimizeBtn, {BackgroundColor3 = theme.Secondary}, 0.15) end)
    minimizeBtn.MouseLeave:Connect(function() Tween(minimizeBtn, {BackgroundColor3 = theme.Tertiary}, 0.15) end)
    closeBtn.MouseEnter:Connect(function() Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}, 0.15) end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}, 0.15) end)

    local tabs = {}
    local selectedTab = nil

    local windowApi = {Tabs = tabs}

    function windowApi:AddTab(tabOpts)
        local tab = CreateTab(tabContainer, tabList, tabOpts)
        table.insert(tabs, tab)

        tab.Button.MouseButton1Click:Connect(function()
            if selectedTab then selectedTab.Deselect() end
            tab.Select()
            selectedTab = tab
        end)

        if #tabs == 1 then
            tab.Select()
            selectedTab = tab
        end

        return tab
    end

    function windowApi:SelectTab(index)
        if tabs[index] then
            if selectedTab then selectedTab.Deselect() end
            tabs[index].Select()
            selectedTab = tabs[index]
        end
    end

    function windowApi:Dialog(dialogOpts)
        return CreateDialog(main, dialogOpts)
    end

    Library.Window = windowApi

    -- Open animation
    main.Size = UDim2.new(0, 0, 0, 0)
    main.BackgroundTransparency = 1
    Tween(main, {Size = opts.Size, BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back)

    return windowApi
end

--[[
    LIBRARY API
]]
function Library:CreateWindow(config)
    return CreateWindow(config)
end

function Library:SetTheme(themeName)
    if self.ThemeColors[themeName] then
        self.Theme = themeName
    end
end

function Library:ToggleAcrylic(state)
    self.Acrylic = state
end

function Library:ToggleTransparency(state)
    self.Transparency = state
    if self.WindowFrame then
        Tween(self.WindowFrame, {BackgroundTransparency = state and 0.1 or 0}, 0.2)
    end
end

function Library:Notify(config)
    return CreateNotification(config)
end

function Library:Destroy()
    self.Unloaded = true
    if self.GUI then
        if self.WindowFrame then
            Tween(self.WindowFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
            task.delay(0.3, function() self.GUI:Destroy() end)
        else
            self.GUI:Destroy()
        end
    end
end

return Library
