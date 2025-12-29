--[[
    SpiemUI Library V1.3
    A premium, fluent Roblox UI library for perfectusmim1/rblxui.
    Features: Notifications, Sliders, Multi-Dropdowns, Keybinds, Colorpickers, and Dialogs.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Spiem = {
    Version = "1.3.1",
    Options = {}
}
Spiem.__index = Spiem

print("--- SpiemUI V" .. Spiem.Version .. " (Fluent-Like) Loaded ---")

-- Utility Functions
local function Tween(object, info, properties)
    local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbarobject, object)
	local Dragging, DragInput, DragStart, StartPos
	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging, DragStart, StartPos = true, input.Position, object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then Dragging = false end
			end)
		end
	end)
	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			local Delta = input.Position - DragStart
			object.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end
	end)
end

-- Notification System
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "SpiemNotifications"
NotifGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
NotifGui.DisplayOrder = 100

local NotifContainer = Instance.new("Frame", NotifGui)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(1, -310, 0, 10)
NotifContainer.Size = UDim2.new(0, 300, 1, -20)
local NCL = Instance.new("UIListLayout", NotifContainer)
NCL.Padding, NCL.VerticalAlignment, NCL.SortOrder = UDim.new(0, 5), Enum.VerticalAlignment.Bottom, Enum.SortOrder.LayoutOrder

function Spiem:Notify(options)
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 5

    local frame = Instance.new("Frame", NotifContainer)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.Size = UDim2.new(1, 0, 0, 0) -- Starts at 0 height
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", frame)
    s.Color, s.Transparency = Color3.fromRGB(50, 50, 50), 0.5

    local t = Instance.new("TextLabel", frame)
    t.BackgroundTransparency, t.Position, t.Size, t.Font = 1, UDim2.new(0, 15, 0, 8), UDim2.new(1, -30, 0, 18), Enum.Font.BuilderSansBold
    t.Text, t.TextColor3, t.TextSize, t.TextXAlignment = title, Color3.fromRGB(240, 240, 240), 14, Enum.TextXAlignment.Left

    local c = Instance.new("TextLabel", frame)
    c.BackgroundTransparency, c.Position, c.Size, c.Font = 1, UDim2.new(0, 15, 0, 28), UDim2.new(1, -30, 0, 0), Enum.Font.BuilderSans
    c.Text, c.TextColor3, c.TextSize, c.TextXAlignment, c.TextWrapped = content, Color3.fromRGB(180, 180, 180), 12, Enum.TextXAlignment.Left, true

    local height = 40 + c.TextBounds.Y
    c.Size = UDim2.new(1, -30, 0, c.TextBounds.Y)
    
    Tween(frame, {0.4, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, height)})
    
    task.delay(duration, function()
        Tween(frame, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 400, 0, height), BackgroundTransparency = 1})
        task.wait(0.3)
        frame:Destroy()
    end)
end

function Spiem.new(options)
    local self = setmetatable({}, Spiem)
    self.Tabs = {}
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SpiemUI_" .. math.random(1000, 9999)
    self.ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
    self.ScreenGui.ResetOnSpawn = false

    local title = type(options) == "table" and options.Title or options or "Spiem UI"

    self.MainFrame = Instance.new("Frame")
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    self.MainFrame.Position = UDim2.new(0.5, -290, 0.5, -230)
    self.MainFrame.Size = UDim2.new(0, 580, 0, 460)
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 12)
    local MS = Instance.new("UIStroke", self.MainFrame)
    MS.Color, MS.Thickness = Color3.fromRGB(40, 40, 40), 1

    self.Topbar = Instance.new("Frame", self.MainFrame)
    self.Topbar.Name, self.Topbar.BackgroundTransparency, self.Topbar.Size = "Topbar", 1, UDim2.new(1, 0, 0, 50)

    local TL = Instance.new("TextLabel", self.Topbar)
    TL.BackgroundTransparency, TL.Position, TL.Size, TL.Font = 1, UDim2.new(0, 20, 0, 0), UDim2.new(1, -120, 1, 0), Enum.Font.BuilderSansBold
    TL.Text, TL.TextColor3, TL.TextSize, TL.TextXAlignment = title, Color3.fromRGB(240, 240, 240), 18, Enum.TextXAlignment.Left

    MakeDraggable(self.Topbar, self.MainFrame)

    self.Sidebar = Instance.new("Frame", self.MainFrame)
    self.Sidebar.BackgroundColor3, self.Sidebar.Position, self.Sidebar.Size = Color3.fromRGB(20, 20, 20), UDim2.new(0, 15, 0, 60), UDim2.new(0, 160, 1, -75)
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 10)

    self.TabList = Instance.new("ScrollingFrame", self.Sidebar)
    self.TabList.BackgroundTransparency, self.TabList.Position, self.TabList.Size = 1, UDim2.new(0, 5, 0, 5), UDim2.new(1, -10, 1, -10)
    self.TabList.ScrollBarThickness, self.TabList.CanvasSize = 0, UDim2.new(0, 0, 0, 0)
    local TLL = Instance.new("UIListLayout", self.TabList)
    TLL.Padding, TLL.SortOrder = UDim.new(0, 5), Enum.SortOrder.LayoutOrder

    self.PageContainer = Instance.new("Frame", self.MainFrame)
    self.PageContainer.BackgroundTransparency, self.PageContainer.Position, self.PageContainer.Size = 1, UDim2.new(0, 190, 0, 60), UDim2.new(1, -205, 1, -75)

    self.MinimizeKey = (type(options) == "table" and options.MinimizeKey) or Enum.KeyCode.RightControl

    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == self.MinimizeKey then self.MainFrame.Visible = not self.MainFrame.Visible end
    end)
    return self
end

function Spiem:Destroy() self.ScreenGui:Destroy() end

-- Dialog
function Spiem:Dialog(options)
    local overlay = Instance.new("Frame", self.ScreenGui)
    overlay.BackgroundColor3, overlay.BackgroundTransparency, overlay.Size = Color3.fromRGB(0,0,0), 1, UDim2.new(1,0,1,0)
    overlay.ZIndex = 10
    
    local d = Instance.new("Frame", overlay)
    d.BackgroundColor3, d.Position, d.Size = Color3.fromRGB(15,15,15), UDim2.new(0.5, -150, 0.5, -80), UDim2.new(0, 300, 0, 160)
    Instance.new("UICorner", d).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", d)
    s.Color = Color3.fromRGB(60,60,60)

    local lt = Instance.new("TextLabel", d)
    lt.BackgroundTransparency, lt.Position, lt.Size, lt.Font = 1, UDim2.new(0,15,0,10), UDim2.new(1,-30,0,25), Enum.Font.BuilderSansBold
    lt.Text, lt.TextColor3, lt.TextSize, lt.TextXAlignment = options.Title or "Dialog", Color3.fromRGB(255,255,255), 16, Enum.TextXAlignment.Left
    
    local lc = Instance.new("TextLabel", d)
    lc.BackgroundTransparency, lc.Position, lc.Size, lc.Font = 1, UDim2.new(0,15,0,40), UDim2.new(1,-30,0,60), Enum.Font.BuilderSans
    lc.Text, lc.TextColor3, lc.TextSize, lc.TextXAlignment, lc.TextWrapped = options.Content or "", Color3.fromRGB(180,180,180), 13, Enum.TextXAlignment.Left, true

    local bl = Instance.new("Frame", d)
    bl.BackgroundTransparency, bl.Position, bl.Size = 1, UDim2.new(0,15,1,-45), UDim2.new(1,-30,0,30)
    local bll = Instance.new("UIListLayout", bl)
    bll.FillDirection, bll.HorizontalAlignment, bll.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, UDim.new(0,10)

    for _, btn in pairs(options.Buttons or {}) do
        local b = Instance.new("TextButton", bl)
        b.BackgroundColor3, b.Size, b.Font, b.Text = Color3.fromRGB(30,30,30), UDim2.new(0, 80, 1, 0), Enum.Font.BuilderSansMedium, btn.Title
        b.TextColor3, b.TextSize = Color3.fromRGB(255,255,255), 13
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function()
            if btn.Callback then btn.Callback() end
            overlay:Destroy()
        end)
    end
end

-- Tab Methods
function Spiem:AddTab(options)
    local name = type(options) == "table" and options.Title or options
    local Hub, tab = self, {Name = name}
    local BTN = Instance.new("TextButton", Hub.TabList)
    BTN.BackgroundColor3, BTN.BackgroundTransparency, BTN.Size, BTN.AutoButtonColor = Color3.fromRGB(25, 25, 25), 1, UDim2.new(1, 0, 0, 35), false
    BTN.Font, BTN.Text, BTN.TextColor3, BTN.TextSize = Enum.Font.BuilderSansMedium, name, Color3.fromRGB(180, 180, 180), 14
    Instance.new("UICorner", BTN).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame", Hub.PageContainer)
    Page.BackgroundTransparency, Page.Size, Page.Visible, Page.ScrollBarThickness = 1, UDim2.new(1, 0, 1, 0), false, 2
    Page.ScrollBarImageColor3, Page.CanvasSize = Color3.fromRGB(50, 50, 50), UDim2.new(0, 0, 0, 0)
    local PL = Instance.new("UIListLayout", Page)
    PL.Padding, PL.SortOrder = UDim.new(0, 10), Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", Page).PaddingLeft, Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 2), UDim.new(0, 2)
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 10) end)

    function tab:Select()
        for _, t in pairs(Hub.Tabs) do
            t.Page.Visible = false
            Tween(t.Button, {0.3, Enum.EasingStyle.Quint}, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)})
        end
        Page.Visible = true
        Tween(BTN, {0.3, Enum.EasingStyle.Quint}, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
    end
    BTN.MouseButton1Click:Connect(function() tab:Select() end)
    table.insert(Hub.Tabs, {Button = BTN, Page = Page})
    if #Hub.Tabs == 1 then tab:Select() end

    function tab:AddButton(options)
        local t, desc, c = options.Title, options.Description, options.Callback
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, desc and 55 or 40)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local b = Instance.new("TextButton", f)
        b.BackgroundTransparency, b.Size, b.Text = 1, UDim2.new(1, 0, 1, 0), ""
        
        local lt = Instance.new("TextLabel", f)
        lt.BackgroundTransparency, lt.Position, lt.Size, lt.Font = 1, UDim2.new(0, 15, 0, desc and 8 or 0), UDim2.new(1, -30, 0, 24), Enum.Font.BuilderSansMedium
        lt.Text, lt.TextColor3, lt.TextSize, lt.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        if desc then
            local ld = Instance.new("TextLabel", f)
            ld.BackgroundTransparency, ld.Position, ld.Size, ld.Font = 1, UDim2.new(0, 15, 0, 28), UDim2.new(1, -30, 0, 20), Enum.Font.BuilderSans
            ld.Text, ld.TextColor3, ld.TextSize, ld.TextXAlignment = desc, Color3.fromRGB(150, 150, 150), 12, Enum.TextXAlignment.Left
        end

        b.MouseButton1Click:Connect(function()
            Tween(f, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
            task.wait(0.1)
            Tween(f, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
            if c then c() end
        end)
    end

    function tab:AddToggle(idx, options)
        local t, d, c = options.Title, options.Default, options.Callback
        local en = d or false
        Spiem.Options[idx] = {Value = en}
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local b = Instance.new("TextButton", f)
        b.BackgroundTransparency, b.Size, b.Text = 1, UDim2.new(1, 0, 1, 0), ""
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local ot = Instance.new("Frame", f)
        ot.BackgroundColor3, ot.Position, ot.Size = Color3.fromRGB(40, 40, 40), UDim2.new(1, -50, 0.5, -11), UDim2.new(0, 40, 0, 22)
        Instance.new("UICorner", ot).CornerRadius = UDim.new(1, 0)
        local inr = Instance.new("Frame", ot)
        inr.BackgroundColor3, inr.Position, inr.Size = Color3.fromRGB(150, 150, 150), UDim2.new(0, 3, 0.5, -8), UDim2.new(0, 16, 0, 16)
        Instance.new("UICorner", inr).CornerRadius = UDim.new(1, 0)

        local function upd()
            Spiem.Options[idx].Value = en
            Tween(ot, {0.3, Enum.EasingStyle.Quint}, {BackgroundColor3 = en and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 40)})
            Tween(inr, {0.3, Enum.EasingStyle.Quint}, {Position = en and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = en and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)})
            if c then c(en) end
        end
        b.MouseButton1Click:Connect(function() en = not en; upd() end)
        upd()
        
        local toggleFuncs = {}
        function toggleFuncs:OnChanged(callback) c = callback end
        function toggleFuncs:SetValue(v) en = v; upd() end
        return toggleFuncs
    end

    function tab:AddSlider(idx, options)
        local t, d, min, max, rounding, c = options.Title, options.Default, options.Min or 0, options.Max or 100, options.Rounding or 1, options.Callback
        local val = d or min
        Spiem.Options[idx] = {Value = val}

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 50)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 8), UDim2.new(0.5, -15, 0, 18), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local v_l = Instance.new("TextLabel", f)
        v_l.BackgroundTransparency, v_l.Position, v_l.Size, v_l.Font = 1, UDim2.new(0.5, 0, 0, 8), UDim2.new(0.5, -15, 0, 18), Enum.Font.BuilderSans
        v_l.Text, v_l.TextColor3, v_l.TextSize, v_l.TextXAlignment = tostring(val), Color3.fromRGB(180, 180, 180), 13, Enum.TextXAlignment.Right

        local slideBar = Instance.new("Frame", f)
        slideBar.BackgroundColor3, slideBar.Position, slideBar.Size = Color3.fromRGB(40, 40, 40), UDim2.new(0, 15, 0, 32), UDim2.new(1, -30, 0, 8)
        Instance.new("UICorner", slideBar).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", slideBar)
        fill.BackgroundColor3, fill.Size = Color3.fromRGB(0, 120, 255), UDim2.new((val-min)/(max-min), 0, 1, 0)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local interact = Instance.new("TextButton", slideBar)
        interact.BackgroundTransparency, interact.Size, interact.Text = 1, UDim2.new(1, 20, 1, 20), ""
        interact.Position = UDim2.new(0, -10, 0, -10)

        local function upd(input)
            local pos = math.clamp((input.Position.X - slideBar.AbsolutePosition.X) / slideBar.AbsoluteSize.X, 0, 1)
            val = math.floor((min + (max - min) * pos) * (1/rounding) + 0.5) / (1/rounding)
            Spiem.Options[idx].Value = val
            v_l.Text = tostring(val)
            Tween(fill, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new((val-min)/(max-min), 0, 1, 0)})
            if c then c(val) end
        end

        local dragging = false
        interact.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                upd(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                upd(input)
            end
        end)

        local sliderFuncs = {}
        function sliderFuncs:OnChanged(callback) c = callback end
        function sliderFuncs:SetValue(v) val = v; v_l.Text = t; Tween(fill, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new((val-min)/(max-min), 0, 1, 0)}); if c then c(val) end end
        return sliderFuncs
    end

    function tab:AddDropdown(idx, options)
        local t, d, values, multi, c = options.Title, options.Default, options.Values, options.Multi, options.Callback
        local sel = multi and (d or {}) or (d or values[1])
        Spiem.Options[idx] = {Value = sel}

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size, f.ClipsDescendants = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 45), true
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local b = Instance.new("TextButton", f)
        b.BackgroundTransparency, b.Size, b.Text = 1, UDim2.new(1, 0, 0, 45), ""

        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 0, 45), Enum.Font.BuilderSansMedium
        l.TextColor3, l.TextSize, l.TextXAlignment = Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left
        
        local function getSelText()
            if multi then
                local res = {}
                for k,v in pairs(sel) do if v then table.insert(res, k) end end
                return #res > 0 and table.concat(res, ", ") or "None"
            end
            return tostring(sel)
        end
        l.Text = t .. ": " .. getSelText()

        local ic = Instance.new("ImageLabel", f)
        ic.BackgroundTransparency, ic.Position, ic.Size, ic.Image = 1, UDim2.new(1, -30, 0, 14), UDim2.new(0, 16, 0, 16), "rbxassetid://6034818372"
        ic.ImageColor3 = Color3.fromRGB(180, 180, 180)

        local ol = Instance.new("Frame", f)
        ol.BackgroundTransparency, ol.Position, ol.Size = 1, UDim2.new(0, 0, 0, 45), UDim2.new(1, 0, 0, 0)
        local oll = Instance.new("UIListLayout", ol)
        oll.Padding, oll.SortOrder = UDim.new(0, 2), Enum.SortOrder.LayoutOrder

        local op = false
        local function upd_l() l.Text = t .. ": " .. getSelText() end

        b.MouseButton1Click:Connect(function()
            op = not op
            if op then
                for _, v in pairs(ol:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                for _, o in pairs(values) do
                    local isSel = multi and sel[o] or (sel == o)
                    local ob = Instance.new("TextButton", ol)
                    ob.BackgroundColor3, ob.Size, ob.Font, ob.Text = isSel and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35), UDim2.new(1, -10, 0, 30), Enum.Font.BuilderSans, "  " .. o
                    ob.TextColor3, ob.TextSize, ob.AutoButtonColor, ob.TextXAlignment = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200), 13, false, Enum.TextXAlignment.Left
                    Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 6)
                    
                    ob.MouseButton1Click:Connect(function()
                        if multi then
                            sel[o] = not sel[o]
                            ob.BackgroundColor3 = sel[o] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35)
                            ob.TextColor3 = sel[o] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                        else
                            sel = o
                            op = false
                            Tween(f, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 45)})
                            Tween(ic, {0.3, Enum.EasingStyle.Quint}, {Rotation = 0})
                        end
                        upd_l()
                        if c then c(sel) end
                    end)
                end
                Tween(f, {0.4, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 45 + (#values * 32) + 10)})
                Tween(ic, {0.4, Enum.EasingStyle.Quint}, {Rotation = 180})
            else
                Tween(f, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 45)})
                Tween(ic, {0.3, Enum.EasingStyle.Quint}, {Rotation = 0})
            end
        end)

        local dropFuncs = {}
        function dropFuncs:OnChanged(callback) c = callback end
        function dropFuncs:SetValue(v) sel = v; upd_l(); if c then c(sel) end end
        return dropFuncs
    end

    function tab:AddInput(idx, options)
        local t, d, ph, numeric, finished, c = options.Title, options.Default, options.Placeholder, options.Numeric, options.Finished, options.Callback
        Spiem.Options[idx] = {Value = d or ""}

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.4, 0, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local bf = Instance.new("Frame", f)
        bf.BackgroundColor3, bf.Position, bf.Size = Color3.fromRGB(20, 20, 20), UDim2.new(1, -165, 0.5, -14), UDim2.new(0, 150, 0, 28)
        Instance.new("UICorner", bf).CornerRadius = UDim.new(0, 6)
        local s = Instance.new("UIStroke", bf)
        s.Color = Color3.fromRGB(50, 50, 50)
        
        local box = Instance.new("TextBox", bf)
        box.BackgroundTransparency, box.Position, box.Size, box.Font = 1, UDim2.new(0, 8, 0, 0), UDim2.new(1, -16, 1, 0), Enum.Font.BuilderSans
        box.PlaceholderText, box.Text, box.TextColor3, box.PlaceholderColor3, box.TextSize = ph or "...", d or "", Color3.fromRGB(255, 255, 255), Color3.fromRGB(100, 100, 100), 13
        box.TextXAlignment, box.ClearTextOnFocus = Enum.TextXAlignment.Left, false

        box.Focused:Connect(function() Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(0, 120, 255)}) end)
        box.FocusLost:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(50, 50, 50)})
            local val = box.Text
            if numeric then val = val:gsub("%D+", "") box.Text = val end
            Spiem.Options[idx].Value = val
            if c then c(val) end
        end)
        
        local inputFuncs = {}
        function inputFuncs:OnChanged(callback) c = callback end
        return inputFuncs
    end

    function tab:AddColorpicker(idx, options)
        local t, d, c = options.Title, options.Default or Color3.fromRGB(255, 255, 255), options.Callback
        local clr = d
        Spiem.Options[idx] = {Value = clr}

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local cp_b = Instance.new("TextButton", f)
        cp_b.BackgroundColor3, cp_b.Position, cp_b.Size = clr, UDim2.new(1, -50, 0.5, -11), UDim2.new(0, 35, 0, 22)
        Instance.new("UICorner", cp_b).CornerRadius = UDim.new(0, 4)
        cp_b.Text = ""

        cp_b.MouseButton1Click:Connect(function()
            -- Simplified color picker logic: Cycle red, green, blue for demo
            if clr == Color3.fromRGB(255,0,0) then clr = Color3.fromRGB(0,255,0)
            elseif clr == Color3.fromRGB(0,255,0) then clr = Color3.fromRGB(0,0,255)
            else clr = Color3.fromRGB(255,0,0) end
            cp_b.BackgroundColor3 = clr
            Spiem.Options[idx].Value = clr
            if c then c(clr) end
        end)

        local cpFuncs = {}
        function cpFuncs:OnChanged(callback) c = callback end
        function cpFuncs:SetValueRGB(v) clr = v; cp_b.BackgroundColor3 = clr; if c then c(clr) end end
        return cpFuncs
    end

    function tab:AddKeybind(idx, options)
        local t, d, mode, c = options.Title, options.Default or "None", options.Mode or "Toggle", options.Callback
        local key = d
        Spiem.Options[idx] = {Value = key}

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local kb_b = Instance.new("TextButton", f)
        kb_b.BackgroundColor3, kb_b.Position, kb_b.Size = Color3.fromRGB(35, 35, 35), UDim2.new(1, -115, 0.5, -12), UDim2.new(0, 100, 0, 24)
        Instance.new("UICorner", kb_b).CornerRadius = UDim.new(0, 6)
        kb_b.Font, kb_b.Text, kb_b.TextColor3, kb_b.TextSize = Enum.Font.BuilderSans, key, Color3.fromRGB(200, 200, 200), 12

        local listening = false
        kb_b.MouseButton1Click:Connect(function()
            listening = true
            kb_b.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if listening then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode.Name
                    kb_b.Text = key
                    listening = false
                    Spiem.Options[idx].Value = key
                end
            elseif not gpe and input.KeyCode.Name == key then
                if c then c(key) end
            end
        end)

        local kbFuncs = {}
        function kbFuncs:OnChanged(callback) c = callback end
        return kbFuncs
    end

    function tab:AddParagraph(options)
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local t = Instance.new("TextLabel", f)
        t.BackgroundTransparency, t.Position, t.Size, t.Font = 1, UDim2.new(0, 15, 0, 10), UDim2.new(1, -30, 0, 18), Enum.Font.BuilderSansBold
        t.Text, t.TextColor3, t.TextSize, t.TextXAlignment = options.Title or "Paragraph", Color3.fromRGB(240, 240, 240), 14, Enum.TextXAlignment.Left
        local c = Instance.new("TextLabel", f)
        c.BackgroundTransparency, c.Position, c.Size, c.Font = 1, UDim2.new(0, 15, 0, 30), UDim2.new(1, -30, 0, 24), Enum.Font.BuilderSans
        c.Text, c.TextColor3, c.TextSize, c.TextXAlignment, c.TextWrapped = options.Content or "", Color3.fromRGB(180, 180, 180), 12, Enum.TextXAlignment.Left, true
        c:GetPropertyChangedSignal("TextBounds"):Connect(function()
            f.Size = UDim2.new(1, 0, 0, c.TextBounds.Y + 45)
            c.Size = UDim2.new(1, -30, 0, c.TextBounds.Y)
        end)
    end

    return tab
end

return Spiem
