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
    Version = "1.5",
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
Spiem.NotifGui = NotifGui
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
    if not Spiem.NotifGui or not Spiem.NotifGui.Parent then return end

    local frame = Instance.new("Frame", NotifContainer)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", frame)
    s.Color, s.Transparency = Color3.fromRGB(70, 70, 70), 0.5

    local t = Instance.new("TextLabel", frame)
    t.BackgroundTransparency, t.Position, t.Size, t.Font = 1, UDim2.new(0, 15, 0, 8), UDim2.new(1, -30, 0, 18), Enum.Font.BuilderSansBold
    t.Text, t.TextColor3, t.TextSize, t.TextXAlignment = title, Color3.fromRGB(240, 240, 240), 14, Enum.TextXAlignment.Left

    local c = Instance.new("TextLabel", frame)
    c.BackgroundTransparency, c.Position, c.Size, c.Font = 1, UDim2.new(0, 15, 0, 28), UDim2.new(1, -30, 0, 0), Enum.Font.BuilderSans
    c.Text, c.TextColor3, c.TextSize, c.TextXAlignment, c.TextWrapped = content, Color3.fromRGB(180, 180, 180), 12, Enum.TextXAlignment.Left, true

    local height = 40 + c.TextBounds.Y
    c.Size = UDim2.new(1, -30, 0, c.TextBounds.Y)
    
    -- Smooth open animation
    Tween(frame, {0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, height)})
    
    task.delay(duration, function()
        -- Smooth close: slide right + fade out
        Tween(frame, {0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In}, {Position = UDim2.new(1, 50, 0, 0)})
        Tween(s, {0.3, Enum.EasingStyle.Quint}, {Transparency = 1})
        task.wait(0.15)
        Tween(t, {0.25, Enum.EasingStyle.Quint}, {TextTransparency = 1})
        Tween(c, {0.25, Enum.EasingStyle.Quint}, {TextTransparency = 1})
        task.wait(0.3)
        Tween(frame, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 0)})
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
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainFrame.Position = UDim2.new(0.5, -290, 0.5, -230)
    self.MainFrame.Size = UDim2.new(0, 580, 0, 460)
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 10)
    local MS = Instance.new("UIStroke", self.MainFrame)
    MS.Color, MS.Thickness = Color3.fromRGB(60, 60, 60), 1

    self.Topbar = Instance.new("Frame", self.MainFrame)
    self.Topbar.Name, self.Topbar.BackgroundTransparency, self.Topbar.Size = "Topbar", 1, UDim2.new(1, 0, 0, 50)

    local TL = Instance.new("TextLabel", self.Topbar)
    TL.BackgroundTransparency, TL.Position, TL.Size, TL.Font = 1, UDim2.new(0, 20, 0, 0), UDim2.new(1, -120, 1, 0), Enum.Font.BuilderSansBold
    TL.Text, TL.TextColor3, TL.TextSize, TL.TextXAlignment = title, Color3.fromRGB(240, 240, 240), 18, Enum.TextXAlignment.Left

    MakeDraggable(self.Topbar, self.MainFrame)

    self.Sidebar = Instance.new("Frame", self.MainFrame)
    self.Sidebar.BackgroundColor3, self.Sidebar.Position, self.Sidebar.Size = Color3.fromRGB(24, 24, 24), UDim2.new(0, 15, 0, 60), UDim2.new(0, 160, 1, -75)
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 8)
    local SS = Instance.new("UIStroke", self.Sidebar)
    SS.Color, SS.Transparency = Color3.fromRGB(50, 50, 50), 0.5

    self.TabList = Instance.new("ScrollingFrame", self.Sidebar)
    self.TabList.BackgroundTransparency, self.TabList.Position, self.TabList.Size = 1, UDim2.new(0, 5, 0, 5), UDim2.new(1, -10, 1, -10)
    self.TabList.ScrollBarThickness, self.TabList.CanvasSize = 0, UDim2.new(0, 0, 0, 0)
    local TLL = Instance.new("UIListLayout", self.TabList)
    TLL.Padding, TLL.SortOrder = UDim.new(0, 5), Enum.SortOrder.LayoutOrder

    self.PageContainer = Instance.new("Frame", self.MainFrame)
    self.PageContainer.BackgroundTransparency, self.PageContainer.Position, self.PageContainer.Size = 1, UDim2.new(0, 190, 0, 60), UDim2.new(1, -205, 1, -75)
    self.PageContainer.ClipsDescendants = true

    self.MinimizeKey = (type(options) == "table" and options.MinimizeKey) or Enum.KeyCode.LeftControl

    -- Topbar Buttons
    local BtnContainer = Instance.new("Frame", self.Topbar)
    BtnContainer.BackgroundTransparency, BtnContainer.Position, BtnContainer.Size = 1, UDim2.new(1, -70, 0.5, -12), UDim2.new(0, 60, 0, 24)
    local BCL = Instance.new("UIListLayout", BtnContainer)
    BCL.FillDirection, BCL.HorizontalAlignment, BCL.Padding = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, UDim.new(0, 8)

    local function CreateTopbarBtn(icon, hoverColor, callback)
        local b = Instance.new("TextButton", BtnContainer)
        b.BackgroundTransparency, b.Size, b.Text = 1, UDim2.new(0, 24, 0, 24), ""
        
        local ic = Instance.new("ImageLabel", b)
        ic.BackgroundTransparency, ic.Size, ic.Position, ic.Image = 1, UDim2.new(0, 16, 0, 16), UDim2.new(0.5, -8, 0.5, -8), icon
        ic.ImageColor3 = Color3.fromRGB(140, 140, 140)
        
        b.MouseEnter:Connect(function()
            Tween(ic, {0.15, Enum.EasingStyle.Quint}, {ImageColor3 = hoverColor})
        end)
        b.MouseLeave:Connect(function()
            Tween(ic, {0.15, Enum.EasingStyle.Quint}, {ImageColor3 = Color3.fromRGB(140, 140, 140)})
        end)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    local minimized = false
    local function ToggleMinimize()
        minimized = not minimized
        if minimized then
            Tween(self.MainFrame, {0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In}, {Size = UDim2.new(0, 580, 0, 0), BackgroundTransparency = 1})
            task.delay(0.2, function() if minimized then self.MainFrame.Visible = false end end)
        else
            self.MainFrame.Visible = true
            Tween(self.MainFrame, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 580, 0, 460), BackgroundTransparency = 0})
        end
    end

    CreateTopbarBtn("rbxassetid://7072706663", Color3.fromRGB(200, 200, 200), ToggleMinimize) -- Minimize
    CreateTopbarBtn("rbxassetid://7072725342", Color3.fromRGB(255, 80, 80), function() self:Destroy() end) -- Close

    self.ToggleConnection = UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == self.MinimizeKey then ToggleMinimize() end
    end)
    return self
end

function Spiem:Destroy()
    if self.ToggleConnection then self.ToggleConnection:Disconnect() end
    
    -- Shutdown animation
    Tween(self.MainFrame, {0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In}, {Size = UDim2.new(0, 580, 0, 0), Position = UDim2.new(0.5, -290, 0.5, 0), BackgroundTransparency = 1})
    
    task.wait(0.3)
    self.ScreenGui:Destroy()
    if Spiem.NotifGui then Spiem.NotifGui:Destroy() end
end

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
    BTN.BackgroundColor3, BTN.BackgroundTransparency, BTN.Size, BTN.AutoButtonColor = Color3.fromRGB(60, 60, 60), 1, UDim2.new(1, 0, 0, 34), false
    BTN.Font, BTN.Text, BTN.TextColor3, BTN.TextSize = Enum.Font.BuilderSansMedium, name, Color3.fromRGB(180, 180, 180), 14
    Instance.new("UICorner", BTN).CornerRadius = UDim.new(0, 6)
    
    local Indicator = Instance.new("Frame", BTN)
    Indicator.BackgroundColor3, Indicator.Position, Indicator.Size = Color3.fromRGB(0, 120, 255), UDim2.new(0, 2, 0.5, -8), UDim2.new(0, 3, 0, 16)
    Indicator.BackgroundTransparency = 1
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local Page = Instance.new("ScrollingFrame", Hub.PageContainer)
    Page.BackgroundTransparency, Page.Size, Page.Visible, Page.ScrollBarThickness = 1, UDim2.new(1, 0, 1, 0), false, 6
    Page.ScrollBarImageColor3, Page.CanvasSize = Color3.fromRGB(120, 120, 120), UDim2.new(0, 0, 0, 0)
    Page.ScrollBarImageTransparency = 0.4
    
    local CG = Instance.new("CanvasGroup", Page.Parent)
    CG.BackgroundTransparency, CG.Size, CG.Visible = 1, UDim2.new(1, 0, 1, 0), false
    Page.Parent = CG
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = true -- FIX: Internal page must be visible

    local PL = Instance.new("UIListLayout", Page)
    PL.Padding, PL.SortOrder = UDim.new(0, 10), Enum.SortOrder.LayoutOrder
    local PAdd = Instance.new("UIPadding", Page)
    PAdd.PaddingLeft, PAdd.PaddingTop, PAdd.PaddingRight = UDim.new(0, 5), UDim.new(0, 5), UDim.new(0, 15)
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 20) end)

    local PageTitle = Instance.new("TextLabel", Page)
    PageTitle.BackgroundTransparency, PageTitle.Size, PageTitle.Font = 1, UDim2.new(1, 0, 0, 40), Enum.Font.BuilderSansBold
    PageTitle.Text, PageTitle.TextColor3, PageTitle.TextSize, PageTitle.TextXAlignment = name, Color3.fromRGB(255, 255, 255), 24, Enum.TextXAlignment.Left
    PageTitle.LayoutOrder = -1 

    function tab:Select()
        for _, t in pairs(Hub.Tabs) do
            local otherCG = t.Page.Parent
            if otherCG.Visible and otherCG ~= Page.Parent then
                Tween(otherCG, {0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {GroupTransparency = 1, Position = UDim2.new(0, -15, 0, 0)})
                task.delay(0.15, function() otherCG.Visible = false end)
            end
            Tween(t.Button, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)})
            local ind = t.Button:FindFirstChild("Frame")
            if ind then Tween(ind, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 1}) end
        end
        
        local myCG = Page.Parent
        myCG.Visible = true
        myCG.GroupTransparency = 1
        myCG.Position = UDim2.new(0, 15, 0, 0) -- Slide in from right
        Tween(myCG, {0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
        
        Tween(BTN, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(255, 255, 255)})
        Tween(Indicator, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 0})
    end
    BTN.MouseEnter:Connect(function()
        if not Page.Parent.Visible then
            Tween(BTN, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 0.8})
        end
    end)
    BTN.MouseLeave:Connect(function()
        if not Page.Parent.Visible then
            Tween(BTN, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 1})
        end
    end)
    BTN.MouseButton1Down:Connect(function()
        Tween(BTN, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, -5, 0, 32)})
    end)
    BTN.MouseButton1Up:Connect(function()
        Tween(BTN, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 34)})
    end)
    BTN.MouseButton1Click:Connect(function() tab:Select() end)
    table.insert(Hub.Tabs, {Button = BTN, Page = Page})
    if #Hub.Tabs == 1 then tab:Select() end

    function tab:AddSection(text)
        local f = Instance.new("Frame", Page)
        f.BackgroundTransparency, f.Size = 1, UDim2.new(1, 0, 0, 30)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 5, 0, 10), UDim2.new(1, -5, 0, 20), Enum.Font.BuilderSansBold
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = text, Color3.fromRGB(200, 200, 200), 13, Enum.TextXAlignment.Left

        local line = Instance.new("Frame", f)
        line.BackgroundColor3, line.Position, line.Size = Color3.fromRGB(80, 80, 80), UDim2.new(0, 5, 1, 0), UDim2.new(1, -5, 0, 1)
        line.BackgroundTransparency = 0.5
        Instance.new("UIGradient", line).Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    end

    function tab:AddButton(options)
        local t, desc, c = options.Title, options.Description, options.Callback
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, desc and 55 or 40)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color, s.Transparency = Color3.fromRGB(65, 65, 65), 0.5
        local b = Instance.new("TextButton", f)
        b.BackgroundTransparency, b.Size, b.Text = 1, UDim2.new(1, 0, 1, 0), ""
        
        local lt = Instance.new("TextLabel", f)
        lt.BackgroundTransparency, lt.Position, lt.Size, lt.Font = 1, UDim2.new(0, 15, 0, desc and 8 or 0), UDim2.new(1, -30, 0, 24), Enum.Font.BuilderSansMedium
        lt.Text, lt.TextColor3, lt.TextSize, lt.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local ld = nil
        if desc then
            ld = Instance.new("TextLabel", f)
            ld.BackgroundTransparency, ld.Position, ld.Size, ld.Font = 1, UDim2.new(0, 15, 0, 28), UDim2.new(1, -30, 0, 20), Enum.Font.BuilderSans
            ld.Text, ld.TextColor3, ld.TextSize, ld.TextXAlignment = desc, Color3.fromRGB(150, 150, 150), 12, Enum.TextXAlignment.Left
        end

        b.MouseButton1Click:Connect(function()
            Tween(f, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
            task.wait(0.1)
            Tween(f, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(38, 38, 38)})
            if c then c() end
        end)
        b.MouseEnter:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(80, 80, 80)})
        end)
        b.MouseLeave:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(65, 65, 65)})
        end)

        local btnFuncs = {}
        function btnFuncs:SetDesc(newDesc)
            if ld then
                ld.Text = newDesc
            else
                -- Create description label if it doesn't exist
                ld = Instance.new("TextLabel", f)
                ld.BackgroundTransparency, ld.Position, ld.Size, ld.Font = 1, UDim2.new(0, 15, 0, 28), UDim2.new(1, -30, 0, 20), Enum.Font.BuilderSans
                ld.Text, ld.TextColor3, ld.TextSize, ld.TextXAlignment = newDesc, Color3.fromRGB(150, 150, 150), 12, Enum.TextXAlignment.Left
                lt.Position = UDim2.new(0, 15, 0, 8)
                f.Size = UDim2.new(1, 0, 0, 55)
            end
        end
        return btnFuncs
    end

    function tab:AddToggle(idx, options)
        local t, d, c = options.Title, options.Default, options.Callback
        local en = d or false
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color, s.Transparency = Color3.fromRGB(65, 65, 65), 0.5
        
        local b = Instance.new("TextButton", f)
        b.BackgroundTransparency, b.Size, b.Text = 1, UDim2.new(1, 0, 1, 0), ""
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local ot = Instance.new("Frame", f)
        ot.BackgroundColor3, ot.Position, ot.Size = Color3.fromRGB(50, 50, 50), UDim2.new(1, -50, 0.5, -11), UDim2.new(0, 40, 0, 22)
        Instance.new("UICorner", ot).CornerRadius = UDim.new(1, 0)
        local ost = Instance.new("UIStroke", ot)
        ost.Color, ost.Transparency = Color3.fromRGB(70, 70, 70), 0.5

        local inr = Instance.new("Frame", ot)
        inr.BackgroundColor3, inr.Position, inr.Size = Color3.fromRGB(150, 150, 150), UDim2.new(0, 3, 0.5, -8), UDim2.new(0, 16, 0, 16)
        Instance.new("UICorner", inr).CornerRadius = UDim.new(1, 0)

        local toggleFuncs = {Type = "Toggle", Value = en}
        
        local function upd()
            toggleFuncs.Value = en
            Tween(ot, {0.3, Enum.EasingStyle.Quint}, {BackgroundColor3 = en and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)})
            Tween(ost, {0.3, Enum.EasingStyle.Quint}, {Color = en and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 70, 70)})
            Tween(inr, {0.3, Enum.EasingStyle.Quint}, {Position = en and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = en and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)})
            if c then c(en) end
        end
        b.MouseButton1Click:Connect(function() en = not en; upd() end)
        b.MouseEnter:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(80, 80, 80)})
        end)
        b.MouseLeave:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(65, 65, 65)})
        end)
        upd()
        
        function toggleFuncs:OnChanged(callback) c = callback end
        function toggleFuncs:SetValue(v) en = v; upd() end
        
        Spiem.Options[idx] = toggleFuncs
        return toggleFuncs
    end

    function tab:AddSlider(idx, options)
        local t, d, min, max, rounding, c = options.Title, options.Default, options.Min or 0, options.Max or 100, options.Rounding or 1, options.Callback
        local val = d or min

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, 50)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color, s.Transparency = Color3.fromRGB(65, 65, 65), 0.5

        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 8), UDim2.new(0.5, -15, 0, 18), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local v_l = Instance.new("TextLabel", f)
        v_l.BackgroundTransparency, v_l.Position, v_l.Size, v_l.Font = 1, UDim2.new(0.5, 0, 0, 8), UDim2.new(0.5, -15, 0, 18), Enum.Font.BuilderSans
        v_l.Text, v_l.TextColor3, v_l.TextSize, v_l.TextXAlignment = tostring(val), Color3.fromRGB(180, 180, 180), 13, Enum.TextXAlignment.Right

        local slideBar = Instance.new("Frame", f)
        slideBar.BackgroundColor3, slideBar.Position, slideBar.Size = Color3.fromRGB(50, 50, 50), UDim2.new(0, 15, 0, 32), UDim2.new(1, -30, 0, 8)
        Instance.new("UICorner", slideBar).CornerRadius = UDim.new(1, 0)
        local sbs = Instance.new("UIStroke", slideBar)
        sbs.Color, sbs.Transparency = Color3.fromRGB(70, 70, 70), 0.5

        local fill = Instance.new("Frame", slideBar)
        fill.BackgroundColor3, fill.Size = Color3.fromRGB(0, 120, 255), UDim2.new((val-min)/(max-min), 0, 1, 0)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local interact = Instance.new("TextButton", slideBar)
        interact.BackgroundTransparency, interact.Size, interact.Text = 1, UDim2.new(1, 20, 1, 20), ""
        interact.Position = UDim2.new(0, -10, 0, -10)

        local sliderFuncs = {Type = "Slider", Value = val}

        local function upd(input)
            local pos = math.clamp((input.Position.X - slideBar.AbsolutePosition.X) / slideBar.AbsoluteSize.X, 0, 1)
            val = math.floor((min + (max - min) * pos) * (1/rounding) + 0.5) / (1/rounding)
            sliderFuncs.Value = val
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

        interact.MouseEnter:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(80, 80, 80)})
        end)
        interact.MouseLeave:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(65, 65, 65)})
        end)

        function sliderFuncs:OnChanged(callback) c = callback end
        function sliderFuncs:SetValue(v)
            val = v
            sliderFuncs.Value = val
            v_l.Text = tostring(val)
            Tween(fill, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new((val-min)/(max-min), 0, 1, 0)})
            if c then c(val) end
        end
        
        Spiem.Options[idx] = sliderFuncs
        return sliderFuncs
    end

    function tab:AddDropdown(idx, options)
        local t, d, values, multi, c = options.Title, options.Default, options.Values, options.Multi, options.Callback
        local sel = multi and (d or {}) or (d or values[1])

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color, s.Transparency = Color3.fromRGB(65, 65, 65), 0.5

        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.5, -15, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local function getSelText()
            if multi then
                local res = {}
                for k,v in pairs(sel) do if v then table.insert(res, k) end end
                return #res > 0 and table.concat(res, ", ") or "None"
            end
            return tostring(sel)
        end

        -- Dropdown Button (right side)
        local dropBtn = Instance.new("TextButton", f)
        dropBtn.BackgroundColor3, dropBtn.Position, dropBtn.Size = Color3.fromRGB(32, 32, 32), UDim2.new(0.5, 0, 0.5, -14), UDim2.new(0.5, -15, 0, 28)
        dropBtn.Font, dropBtn.TextColor3, dropBtn.TextSize, dropBtn.AutoButtonColor = Enum.Font.BuilderSans, Color3.fromRGB(200, 200, 200), 13, false
        dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
        dropBtn.Text = "  " .. getSelText()
        dropBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
        local dbs = Instance.new("UIStroke", dropBtn)
        dbs.Color, dbs.Transparency = Color3.fromRGB(60, 60, 60), 0.5

        local ic = Instance.new("ImageLabel", dropBtn)
        ic.BackgroundTransparency, ic.Position, ic.Size, ic.Image = 1, UDim2.new(1, -22, 0.5, -6), UDim2.new(0, 12, 0, 12), "rbxassetid://6034818372"
        ic.ImageColor3 = Color3.fromRGB(140, 140, 140)

        -- Floating Popup
        local popup = Instance.new("Frame", Hub.ScreenGui)
        popup.Name = "DropdownPopup_" .. idx
        popup.BackgroundColor3, popup.Size, popup.Visible = Color3.fromRGB(30, 30, 30), UDim2.new(0, 180, 0, 0), false
        popup.ZIndex, popup.ClipsDescendants = 100, true
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
        local ps = Instance.new("UIStroke", popup)
        ps.Color, ps.Transparency = Color3.fromRGB(60, 60, 60), 0.5

        local popupList = Instance.new("ScrollingFrame", popup)
        popupList.BackgroundTransparency, popupList.Size, popupList.Position = 1, UDim2.new(1, -10, 1, -10), UDim2.new(0, 5, 0, 5)
        popupList.ScrollBarThickness, popupList.CanvasSize = 2, UDim2.new(0, 0, 0, 0)
        popupList.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        local pll = Instance.new("UIListLayout", popupList)
        pll.Padding, pll.SortOrder = UDim.new(0, 2), Enum.SortOrder.LayoutOrder

        local op = false
        local dropFuncs = {Type = multi and "MultiDropdown" or "Dropdown", Value = sel}

        local function upd_l()
            dropBtn.Text = "  " .. getSelText()
            dropFuncs.Value = sel
        end

        local function closePopup()
            op = false
            Tween(popup, {0.2, Enum.EasingStyle.Quint}, {Size = UDim2.new(0, 180, 0, 0)})
            task.delay(0.2, function() popup.Visible = false end)
            Tween(ic, {0.2, Enum.EasingStyle.Quint}, {Rotation = 0})
        end
        
        dropBtn.MouseEnter:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(80, 80, 80)})
        end)
        dropBtn.MouseLeave:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(65, 65, 65)})
        end)

        local function openPopup()
            op = true
            popup.Visible = true

            -- Position popup to the right of the button
            local absPos = dropBtn.AbsolutePosition
            local absSize = dropBtn.AbsoluteSize
            popup.Position = UDim2.fromOffset(absPos.X + absSize.X + 5, absPos.Y)

            -- Clear and rebuild options
            for _, v in pairs(popupList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end

            for _, o in pairs(values) do
                local isSel = multi and sel[o] or (sel == o)
                local ob = Instance.new("TextButton", popupList)
                ob.BackgroundColor3, ob.Size = isSel and Color3.fromRGB(0, 90, 190) or Color3.fromRGB(40, 40, 40), UDim2.new(1, 0, 0, 28)
                ob.Font, ob.Text = Enum.Font.BuilderSans, "  " .. o
                ob.TextColor3, ob.TextSize, ob.AutoButtonColor, ob.TextXAlignment = Color3.fromRGB(220, 220, 220), 13, false, Enum.TextXAlignment.Left
                ob.ZIndex = 101
                Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 6)

                ob.MouseEnter:Connect(function()
                    if not (multi and sel[o] or (sel == o)) then
                        Tween(ob, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                    end
                end)
                ob.MouseLeave:Connect(function()
                    if not (multi and sel[o] or (sel == o)) then
                        Tween(ob, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                    end
                end)

                ob.MouseButton1Click:Connect(function()
                    if multi then
                        sel[o] = not sel[o]
                        ob.BackgroundColor3 = sel[o] and Color3.fromRGB(0, 90, 190) or Color3.fromRGB(40, 40, 40)
                    else
                        sel = o
                        closePopup()
                    end
                    upd_l()
                    if c then c(sel) end
                end)
            end

            popupList.CanvasSize = UDim2.new(0, 0, 0, pll.AbsoluteContentSize.Y)
            local popupHeight = math.min(#values * 30 + 10, 200)
            Tween(popup, {0.25, Enum.EasingStyle.Quint}, {Size = UDim2.new(0, 180, 0, popupHeight)})
            Tween(ic, {0.25, Enum.EasingStyle.Quint}, {Rotation = 180})
        end

        dropBtn.MouseButton1Click:Connect(function()
            if op then closePopup() else openPopup() end
        end)

        -- Close popup when clicking outside
        UserInputService.InputBegan:Connect(function(input)
            if op and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = input.Position
                local popupPos = popup.AbsolutePosition
                local popupSize = popup.AbsoluteSize
                local btnPos = dropBtn.AbsolutePosition
                local btnSize = dropBtn.AbsoluteSize

                local inPopup = mousePos.X >= popupPos.X and mousePos.X <= popupPos.X + popupSize.X and
                                mousePos.Y >= popupPos.Y and mousePos.Y <= popupPos.Y + popupSize.Y
                local inBtn = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and
                              mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y

                if not inPopup and not inBtn then
                    closePopup()
                end
            end
        end)

        function dropFuncs:OnChanged(callback) c = callback end
        function dropFuncs:SetValue(v)
            if multi then
                if type(v) == "table" then
                    sel = v
                end
            else
                if type(v) == "table" then
                    -- If it's a table but NOT multi, assume it's a list refresh
                    values = v
                    sel = v[1] or sel
                else
                    sel = v
                end
            end
            upd_l()
            if c then c(sel) end
        end
        function dropFuncs:Refresh(newValues)
            values = newValues
            upd_l()
        end
        function dropFuncs:GetValue()
            return sel
        end
        Spiem.Options[idx] = dropFuncs
        return dropFuncs
    end

    function tab:AddInput(idx, options)
        local t, d, ph, numeric, finished, c = options.Title, options.Default, options.Placeholder, options.Numeric, options.Finished, options.Callback

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s_out = Instance.new("UIStroke", f)
        s_out.Color, s_out.Transparency = Color3.fromRGB(65, 65, 65), 0.5
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.4, 0, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local bf = Instance.new("Frame", f)
        bf.BackgroundColor3, bf.Position, bf.Size = Color3.fromRGB(32, 32, 32), UDim2.new(1, -165, 0.5, -14), UDim2.new(0, 150, 0, 28)
        Instance.new("UICorner", bf).CornerRadius = UDim.new(0, 6)
        local s = Instance.new("UIStroke", bf)
        s.Color = Color3.fromRGB(60, 60, 60)
        
        local box = Instance.new("TextBox", bf)
        box.BackgroundTransparency, box.Position, box.Size, box.Font = 1, UDim2.new(0, 8, 0, 0), UDim2.new(1, -16, 1, 0), Enum.Font.BuilderSans
        box.PlaceholderText, box.Text, box.TextColor3, box.PlaceholderColor3, box.TextSize = ph or "...", d or "", Color3.fromRGB(255, 255, 255), Color3.fromRGB(100, 100, 100), 13
        box.TextXAlignment, box.ClearTextOnFocus = Enum.TextXAlignment.Left, false

        local inputFuncs = {Type = "Input", Value = d or ""}

        box.Focused:Connect(function() Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(0, 120, 255)}) end)
        box.FocusLost:Connect(function()
            Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(60, 60, 60)})
            local val = box.Text
            if numeric then val = val:gsub("%D+", "") box.Text = val end
            inputFuncs.Value = val
            if c then c(val) end
        end)
        f.MouseEnter:Connect(function()
            Tween(s_out, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(80, 80, 80)})
        end)
        f.MouseLeave:Connect(function()
            Tween(s_out, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(65, 65, 65)})
        end)
        
        function inputFuncs:OnChanged(callback) c = callback end
        function inputFuncs:SetValue(v)
            box.Text = v
            inputFuncs.Value = v
            if c then c(v) end
        end
        
        Spiem.Options[idx] = inputFuncs
        return inputFuncs
    end

    function tab:AddColorpicker(idx, options)
        local t, d, c = options.Title, options.Default or Color3.fromRGB(255, 255, 255), options.Callback
        local clr = d
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color, s.Transparency = Color3.fromRGB(65, 65, 65), 0.5
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local cp_b = Instance.new("TextButton", f)
        cp_b.BackgroundColor3, cp_b.Position, cp_b.Size = clr, UDim2.new(1, -50, 0.5, -11), UDim2.new(0, 35, 0, 22)
        Instance.new("UICorner", cp_b).CornerRadius = UDim.new(0, 4)
        cp_b.Text = ""

        local cpFuncs = {Type = "Colorpicker", Value = clr}

        cp_b.MouseButton1Click:Connect(function()
            -- Simplified color picker logic: Cycle red, green, blue for demo
            if clr == Color3.fromRGB(255,0,0) then clr = Color3.fromRGB(0,255,0)
            elseif clr == Color3.fromRGB(0,255,0) then clr = Color3.fromRGB(0,0,255)
            else clr = Color3.fromRGB(255,0,0) end
            cp_b.BackgroundColor3 = clr
            cpFuncs.Value = clr
            if c then c(clr) end
        end)

        function cpFuncs:OnChanged(callback) c = callback end
        function cpFuncs:SetValueRGB(v)
            clr = v
            cp_b.BackgroundColor3 = clr
            cpFuncs.Value = clr
            if c then c(clr) end
        end
        function cpFuncs:SetValue(v) -- For SaveManager
            if type(v) == "table" and v.r then -- Handle serialized color
                v = Color3.new(v.r, v.g, v.b)
            end
            self:SetValueRGB(v)
        end

        Spiem.Options[idx] = cpFuncs
        return cpFuncs
    end

    function tab:AddKeybind(idx, options)
        local t, d, mode, c = options.Title, options.Default or "None", options.Mode or "Toggle", options.Callback
        local key = d

        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color, s.Transparency = Color3.fromRGB(65, 65, 65), 0.5
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left

        local kb_b = Instance.new("TextButton", f)
        kb_b.BackgroundColor3, kb_b.Position, kb_b.Size = Color3.fromRGB(32, 32, 32), UDim2.new(1, -115, 0.5, -12), UDim2.new(0, 100, 0, 24)
        Instance.new("UICorner", kb_b).CornerRadius = UDim.new(0, 6)
        local kbs = Instance.new("UIStroke", kb_b)
        kbs.Color, kbs.Transparency = Color3.fromRGB(60, 60, 60), 0.5
        kb_b.Font, kb_b.Text, kb_b.TextColor3, kb_b.TextSize = Enum.Font.BuilderSans, key, Color3.fromRGB(200, 200, 200), 12

        local kbFuncs = {Type = "Keybind", Value = key}

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
                    kbFuncs.Value = key
                    if c then c(key, true) end -- true means it's a CHANGE
                end
            elseif not gpe and input.KeyCode.Name == key then
                if c then c(key, false) end -- false means it's a PRESS
            end
        end)

        function kbFuncs:OnChanged(callback) c = callback end
        function kbFuncs:SetValue(v)
            key = v
            kb_b.Text = key
            kbFuncs.Value = key
            if c then c(key) end
        end
        
        Spiem.Options[idx] = kbFuncs
        return kbFuncs
    end

    function tab:AddParagraph(options)
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(38, 38, 38), UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color, s.Transparency = Color3.fromRGB(65, 65, 65), 0.5
        local titleLabel = Instance.new("TextLabel", f)
        titleLabel.BackgroundTransparency, titleLabel.Position, titleLabel.Size, titleLabel.Font = 1, UDim2.new(0, 15, 0, 10), UDim2.new(1, -30, 0, 18), Enum.Font.BuilderSansBold
        titleLabel.Text, titleLabel.TextColor3, titleLabel.TextSize, titleLabel.TextXAlignment = options.Title or "Paragraph", Color3.fromRGB(240, 240, 240), 14, Enum.TextXAlignment.Left
        local contentLabel = Instance.new("TextLabel", f)
        contentLabel.BackgroundTransparency, contentLabel.Position, contentLabel.Size, contentLabel.Font = 1, UDim2.new(0, 15, 0, 30), UDim2.new(1, -30, 0, 24), Enum.Font.BuilderSans
        contentLabel.Text, contentLabel.TextColor3, contentLabel.TextSize, contentLabel.TextXAlignment, contentLabel.TextWrapped = options.Content or "", Color3.fromRGB(180, 180, 180), 12, Enum.TextXAlignment.Left, true
        contentLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
            f.Size = UDim2.new(1, 0, 0, contentLabel.TextBounds.Y + 45)
            contentLabel.Size = UDim2.new(1, -30, 0, contentLabel.TextBounds.Y)
        end)

        local paragraphFuncs = {}
        function paragraphFuncs:SetTitle(newTitle) titleLabel.Text = newTitle end
        function paragraphFuncs:SetContent(newContent) contentLabel.Text = newContent end
        return paragraphFuncs
    end

    return tab
end

-- ============================================
-- SAVE MANAGER
-- ============================================
local HttpService = game:GetService("HttpService")

local SaveManager = {}
SaveManager.Folder = "SpiemSettings"
SaveManager.Ignore = {}
SaveManager.Options = Spiem.Options

SaveManager.Parser = {
    Toggle = {
        Save = function(idx, object) return { type = "Toggle", idx = idx, value = object.Value } end,
        Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
    },
    Slider = {
        Save = function(idx, object) return { type = "Slider", idx = idx, value = object.Value } end,
        Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
    },
    Dropdown = {
        Save = function(idx, object) return { type = "Dropdown", idx = idx, value = object.Value } end,
        Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
    },
    MultiDropdown = {
        Save = function(idx, object) return { type = "MultiDropdown", idx = idx, value = object.Value } end,
        Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
    },
    Input = {
        Save = function(idx, object) return { type = "Input", idx = idx, value = object.Value } end,
        Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
    },
    Keybind = {
        Save = function(idx, object) return { type = "Keybind", idx = idx, value = object.Value } end,
        Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
    },
    Colorpicker = {
        Save = function(idx, object) 
            local c = object.Value
            return { type = "Colorpicker", idx = idx, value = {r = c.R, g = c.G, b = c.B} } 
        end,
        Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
    },
}

function SaveManager:SetLibrary(library)
    self.Library = library
    self.Options = library.Options
end

function SaveManager:SetFolder(folder)
    self.Folder = folder
    self:BuildFolderTree()
end

function SaveManager:SetIgnoreIndexes(list)
    for _, key in next, list do self.Ignore[key] = true end
end

function SaveManager:IgnoreThemeSettings()
    self:SetIgnoreIndexes({"InterfaceTheme", "MenuKeybind", "SaveManager_ConfigList", "SaveManager_ConfigName"})
end

function SaveManager:BuildFolderTree()
    local paths = {self.Folder, self.Folder .. "/settings"}
    for i = 1, #paths do
        if not isfolder(paths[i]) then makefolder(paths[i]) end
    end
end

function SaveManager:Save(name)
    if not name or name:gsub(" ", "") == "" then return false, "Invalid name" end
    local fullPath = self.Folder .. "/settings/" .. name .. ".json"
    local data = {objects = {}}

    for idx, option in pairs(self.Options) do
        local optType = option.Type
        if self.Parser[optType] and not self.Ignore[idx] then
            table.insert(data.objects, self.Parser[optType].Save(idx, option))
        end
    end

    local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if not success then return false, "Encoding error" end
    writefile(fullPath, encoded)
    return true
end

function SaveManager:Load(name)
    if not name then return false, "No config selected" end
    local file = self.Folder .. "/settings/" .. name .. ".json"
    if not isfile(file) then return false, "File not found" end

    local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
    if not success then return false, "Decode error" end

    for _, option in pairs(decoded.objects) do
        if self.Parser[option.type] then
            task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)
        end
    end
    return true
end

function SaveManager:RefreshConfigList()
    local list = listfiles(self.Folder .. "/settings")
    local out = {}
    for i = 1, #list do
        local file = list[i]
        if file:sub(-5) == ".json" then
            local name = file:match("([^/\\]+)%.json$")
            if name and name ~= "options" then table.insert(out, name) end
        end
    end
    return out
end

function SaveManager:LoadAutoloadConfig()
    local autoloadPath = self.Folder .. "/settings/autoload.txt"
    if isfile(autoloadPath) then
        local name = readfile(autoloadPath)
        local success, err = self:Load(name)
        if success then
            self.Library:Notify({Title = "Config", Content = "Auto-loaded: " .. name, Duration = 3})
        end
    end
end

function SaveManager:BuildConfigSection(tab)
    assert(self.Library, "SaveManager.Library must be set!")

    tab:AddParagraph({Title = "Configuration", Content = "Save and load your settings."})

    tab:AddInput("SaveManager_ConfigName", {Title = "Config name", Placeholder = ""})

    local configList = tab:AddDropdown("SaveManager_ConfigList", {
        Title = "Config list",
        Values = self:RefreshConfigList(),
        Multi = false
    })

    tab:AddButton({
        Title = "Create config",
        Callback = function()
            local name = self.Options.SaveManager_ConfigName and self.Options.SaveManager_ConfigName.Value
            if not name or name == "" then
                return self.Library:Notify({Title = "Error", Content = "Invalid config name (empty)", Duration = 3})
            end
            local success, err = self:Save(name)
            if success then
                self.Library:Notify({Title = "Success", Content = "Created config: " .. name, Duration = 3})
                configList:Refresh(self:RefreshConfigList())
            else
                self.Library:Notify({Title = "Error", Content = err, Duration = 3})
            end
        end
    })

    tab:AddButton({
        Title = "Load config",
        Callback = function()
            local name = self.Options.SaveManager_ConfigList and self.Options.SaveManager_ConfigList.Value
            if not name then
                return self.Library:Notify({Title = "Error", Content = "No config selected", Duration = 3})
            end
            local success, err = self:Load(name)
            if success then
                self.Library:Notify({Title = "Success", Content = "Loaded config: " .. name, Duration = 3})
            else
                self.Library:Notify({Title = "Error", Content = err, Duration = 3})
            end
        end
    })

    tab:AddButton({
        Title = "Overwrite config",
        Callback = function()
            local name = self.Options.SaveManager_ConfigList and self.Options.SaveManager_ConfigList.Value
            if not name then
                return self.Library:Notify({Title = "Error", Content = "No config selected", Duration = 3})
            end
            local success, err = self:Save(name)
            if success then
                self.Library:Notify({Title = "Success", Content = "Overwrote config: " .. name, Duration = 3})
            else
                self.Library:Notify({Title = "Error", Content = err, Duration = 3})
            end
        end
    })

    tab:AddButton({
        Title = "Delete config",
        Callback = function()
            local name = self.Options.SaveManager_ConfigList and self.Options.SaveManager_ConfigList.Value
            if not name then
                return self.Library:Notify({Title = "Error", Content = "No config selected", Duration = 3})
            end
            local filePath = self.Folder .. "/settings/" .. name .. ".json"
            if isfile(filePath) then
                delfile(filePath)
                self.Library:Notify({Title = "Success", Content = "Deleted config: " .. name, Duration = 3})
                configList:Refresh(self:RefreshConfigList())
            else
                self.Library:Notify({Title = "Error", Content = "Config file not found", Duration = 3})
            end
        end
    })

    tab:AddButton({
        Title = "Refresh list",
        Callback = function()
            configList:Refresh(self:RefreshConfigList())
        end
    })

    -- Get current autoload name
    local currentAutoload = "none"
    local autoloadPath = self.Folder .. "/settings/autoload.txt"
    if isfile(autoloadPath) then
        currentAutoload = readfile(autoloadPath)
    end

    local autoloadBtn
    autoloadBtn = tab:AddButton({
        Title = "Set as autoload",
        Description = "Current autoload config: " .. currentAutoload,
        Callback = function()
            local name = self.Options.SaveManager_ConfigList and self.Options.SaveManager_ConfigList.Value
            if name then
                writefile(self.Folder .. "/settings/autoload.txt", name)
                self.Library:Notify({Title = "Success", Content = "Set " .. name .. " to auto load", Duration = 3})
                -- Update description (we need SetDesc method)
                if autoloadBtn and autoloadBtn.SetDesc then
                    autoloadBtn:SetDesc("Current autoload config: " .. name)
                end
            else
                self.Library:Notify({Title = "Error", Content = "No config selected", Duration = 3})
            end
        end
    })

    self:SetIgnoreIndexes({"SaveManager_ConfigList", "SaveManager_ConfigName"})
end

SaveManager:BuildFolderTree()

-- ============================================
-- INTERFACE MANAGER
-- ============================================
local InterfaceManager = {}
InterfaceManager.Folder = "SpiemSettings"
InterfaceManager.Settings = {
    MenuKeybind = "LeftControl"
}

function InterfaceManager:SetLibrary(library)
    self.Library = library
end

function InterfaceManager:SetFolder(folder)
    self.Folder = folder
    if not isfolder(folder) then makefolder(folder) end
end

function InterfaceManager:SaveSettings()
    writefile(self.Folder .. "/interface.json", HttpService:JSONEncode(self.Settings))
end

function InterfaceManager:LoadSettings()
    local path = self.Folder .. "/interface.json"
    if isfile(path) then
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(path))
        if success then
            for k, v in pairs(decoded) do self.Settings[k] = v end
        end
    end
end

function InterfaceManager:BuildInterfaceSection(tab)
    assert(self.Library, "InterfaceManager.Library must be set!")
    self:LoadSettings()

    tab:AddParagraph({Title = "Interface Settings", Content = "Menu keybind and other settings."})

    tab:AddKeybind("MenuKeybind", {
        Title = "Menu Toggle Key",
        Default = self.Settings.MenuKeybind,
        Callback = function(key)
            self.Settings.MenuKeybind = key
            self.Library.MinimizeKey = Enum.KeyCode[key]
            self:SaveSettings()
            self.Library:Notify({Title = "Settings", Content = "Menu key: " .. key, Duration = 2})
        end
    })
end

-- Attach to Spiem
Spiem.SaveManager = SaveManager
Spiem.InterfaceManager = InterfaceManager

return Spiem
