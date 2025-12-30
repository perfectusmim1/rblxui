--[[
    ModernSpiem UI Library
    Inspired by Fryzer Hub / SilentSpy UI.
    A modern, sleek, and dark UI library for Roblox.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local ModernSpiem = {
    Version = "2.0",
    Options = {} -- Store config objects here
}
ModernSpiem.__index = ModernSpiem

-- Configuration for Colors and Styles
local Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(25, 25, 25),
    Content = Color3.fromRGB(20, 20, 20),
    ElementBackground = Color3.fromRGB(32, 32, 32),
    ElementHover = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(0, 160, 255), -- Blue accent
    TextMain = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(160, 160, 160),
    Stroke = Color3.fromRGB(50, 50, 50),
    StrokeFocused = Color3.fromRGB(80, 80, 80),
    StatusGreen = Color3.fromRGB(40, 200, 80),
    StatusRed = Color3.fromRGB(255, 60, 60)
}

-- Utility Functions
local function Tween(object, info, properties)
    local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(dragHandle, dragObject)
    local Dragging, DragInput, DragStart, StartPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging, DragStart, StartPos = true, input.Position, dragObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            dragObject.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
local NotifGui = Instance.new("ScreenGui")
ModernSpiem.NotifGui = NotifGui
NotifGui.Name = "ModernSpiemNotifications"
NotifGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
NotifGui.DisplayOrder = 1000

local NotifContainer = Instance.new("Frame", NotifGui)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(1, -320, 0, 20)
NotifContainer.Size = UDim2.new(0, 300, 1, -40)
local NCL = Instance.new("UIListLayout", NotifContainer)
NCL.Padding, NCL.VerticalAlignment, NCL.SortOrder = UDim.new(0, 10), Enum.VerticalAlignment.Bottom, Enum.SortOrder.LayoutOrder

function ModernSpiem:Notify(options)
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 5
    if not NotifGui.Parent then NotifGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui end

    local frame = Instance.new("Frame", NotifContainer)
    frame.BackgroundColor3 = Theme.ElementBackground
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color, stroke.Transparency = Theme.Stroke, 0
    stroke.Thickness = 1

    local t = Instance.new("TextLabel", frame)
    t.BackgroundTransparency, t.Position, t.Size, t.Font = 1, UDim2.new(0, 15, 0, 10), UDim2.new(1, -30, 0, 20), Enum.Font.GothamBold
    t.Text, t.TextColor3, t.TextSize, t.TextXAlignment = title, Theme.TextMain, 14, Enum.TextXAlignment.Left

    local c = Instance.new("TextLabel", frame)
    c.BackgroundTransparency, c.Position, c.Size, c.Font = 1, UDim2.new(0, 15, 0, 30), UDim2.new(1, -30, 0, 0), Enum.Font.Gotham
    c.Text, c.TextColor3, c.TextSize, c.TextXAlignment, c.TextWrapped = content, Theme.TextDim, 13, Enum.TextXAlignment.Left, true

    c.Size = UDim2.new(1, -30, 0, TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(270, math.huge)).Y)
    
    local height = 45 + c.Size.Y.Offset
    Tween(frame, {0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, height)})
    
    task.delay(duration, function()
        Tween(frame, {0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        Tween(stroke, {0.5, Enum.EasingStyle.Quint}, {Transparency = 1})
        Tween(t, {0.4, Enum.EasingStyle.Quint}, {TextTransparency = 1})
        Tween(c, {0.4, Enum.EasingStyle.Quint}, {TextTransparency = 1})
        task.wait(0.5)
        frame:Destroy()
    end)
end

-- ============================================
-- MAIN LIBRARY
-- ============================================
function ModernSpiem.new(options)
    local self = setmetatable({}, ModernSpiem)
    self.Tabs = {}
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernSpiem_" .. math.random(1000, 9999)
    self.ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true

    local title = type(options) == "table" and options.Title or options or "Modern UI"
    self.MinimizeKey = (type(options) == "table" and options.MinimizeKey) or Enum.KeyCode.RightControl

    -- Main Window
    self.MainFrame = Instance.new("Frame", self.ScreenGui)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    self.MainFrame.Size = UDim2.new(0, 700, 0, 500)
    self.MainFrame.ClipsDescendants = true
    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 12)
    
    local MainStroke = Instance.new("UIStroke", self.MainFrame)
    MainStroke.Color, MainStroke.Thickness = Color3.fromRGB(40, 40, 40), 1

    local Shadow = Instance.new("ImageLabel", self.MainFrame)
    Shadow.BackgroundTransparency, Shadow.Position, Shadow.Size = 1, UDim2.new(0, -30, 0, -30), UDim2.new(1, 60, 1, 60)
    Shadow.Image, Shadow.ImageColor3, Shadow.SliceCenter = "rbxassetid://6015897843", Color3.fromRGB(0, 0, 0), Rect.new(49, 49, 450, 450)
    Shadow.ImageTransparency, Shadow.ZIndex = 0.4, -1

    -- Sidebar
    self.Sidebar = Instance.new("Frame", self.MainFrame)
    self.Sidebar.BackgroundColor3 = Theme.Sidebar
    self.Sidebar.Size = UDim2.new(0, 200, 1, 0)
    self.Sidebar.ZIndex = 2
    local SidebarCorner = Instance.new("UICorner", self.Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    -- Fix corner to only round left side visually if needed, but for now simple round is fine
    -- Actually, to match the image, the sidebar seems integrated. 
    -- Let's just keep it simple.

    -- Topbar (Drag Area)
    self.Topbar = Instance.new("Frame", self.MainFrame)
    self.Topbar.BackgroundTransparency = 1
    self.Topbar.Size = UDim2.new(1, 0, 0, 40)
    self.Topbar.ZIndex = 10
    MakeDraggable(self.Topbar, self.MainFrame)

    -- Window Controls
    local Controls = Instance.new("Frame", self.Topbar)
    Controls.BackgroundTransparency = 1
    Controls.Position, Controls.Size = UDim2.new(1, -90, 0, 0), UDim2.new(0, 90, 1, 0)
    
    local function CreateControl(icon, callback)
        local btn = Instance.new("TextButton", Controls)
        btn.BackgroundTransparency, btn.Size, btn.Text = 1, UDim2.new(0, 40, 1, 0), ""
        local img = Instance.new("ImageLabel", btn)
        img.BackgroundTransparency, img.Position, img.Size, img.Image = 1, UDim2.new(0.5, -8, 0.5, -8), UDim2.new(0, 16, 0, 16), icon
        img.ImageColor3 = Theme.TextDim
        
        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function() Tween(img, {0.15, Enum.EasingStyle.Quint}, {ImageColor3 = Theme.TextMain}) end)
        btn.MouseLeave:Connect(function() Tween(img, {0.15, Enum.EasingStyle.Quint}, {ImageColor3 = Theme.TextDim}) end)
        
        -- Layout
        if #Controls:GetChildren() == 1 then btn.Position = UDim2.new(0.5, 5, 0, 0) else btn.Position = UDim2.new(0, 5, 0, 0) end
    end
    
    CreateControl("rbxassetid://6034818372", function() self:Destroy() end) -- Close (using random icon for now, should be X)
    -- Better icons
    Controls:ClearAllChildren()
    local CloseBtn = Instance.new("TextButton", Controls)
    CloseBtn.BackgroundTransparency, CloseBtn.Size, CloseBtn.Text = 1, UDim2.new(0, 40, 1, 0), "✕"
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Font, CloseBtn.TextColor3, CloseBtn.TextSize = Enum.Font.GothamBold, Theme.TextDim, 16
    CloseBtn.MouseButton1Click:Connect(function() self:Destroy() end)

    local MinBtn = Instance.new("TextButton", Controls)
    MinBtn.BackgroundTransparency, MinBtn.Size, MinBtn.Text = 1, UDim2.new(0, 40, 1, 0), "—"
    MinBtn.Position = UDim2.new(1, -80, 0, 0)
    MinBtn.Font, MinBtn.TextColor3, MinBtn.TextSize = Enum.Font.GothamBold, Theme.TextDim, 16
    
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(self.MainFrame, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(0, 700, 0, 40)})
            self.Sidebar.Visible = false
            self.PageContainer.Visible = false
        else
            Tween(self.MainFrame, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(0, 700, 0, 500)})
            task.delay(0.2, function()
                self.Sidebar.Visible = true
                self.PageContainer.Visible = true
            end)
        end
    end)

    -- Sidebar Content
    local TitleLabel = Instance.new("TextLabel", self.Sidebar)
    TitleLabel.BackgroundTransparency, TitleLabel.Position, TitleLabel.Size = 1, UDim2.new(0, 15, 0, 15), UDim2.new(1, -30, 0, 25)
    TitleLabel.Font, TitleLabel.Text, TitleLabel.TextColor3, TitleLabel.TextSize, TitleLabel.TextXAlignment = Enum.Font.GothamBold, title, Theme.TextMain, 16, Enum.TextXAlignment.Left

    local SearchFrame = Instance.new("Frame", self.Sidebar)
    SearchFrame.BackgroundColor3 = Theme.ElementBackground
    SearchFrame.Position, SearchFrame.Size = UDim2.new(0, 12, 0, 50), UDim2.new(1, -24, 0, 32)
    Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 8)
    local SearchIcon = Instance.new("ImageLabel", SearchFrame)
    SearchIcon.BackgroundTransparency, SearchIcon.Image, SearchIcon.ImageColor3 = 1, "rbxassetid://6031154871", Theme.TextDim
    SearchIcon.Position, SearchIcon.Size = UDim2.new(0, 8, 0.5, -7), UDim2.new(0, 14, 0, 14)
    
    local SearchBox = Instance.new("TextBox", SearchFrame)
    SearchBox.BackgroundTransparency, SearchBox.Position, SearchBox.Size = 1, UDim2.new(0, 30, 0, 0), UDim2.new(1, -30, 1, 0)
    SearchBox.Font, SearchBox.PlaceholderText, SearchBox.Text, SearchBox.TextColor3, SearchBox.PlaceholderColor3 = Enum.Font.Gotham, "Search", "", Theme.TextMain, Theme.TextDim
    SearchBox.TextSize, SearchBox.TextXAlignment = 13, Enum.TextXAlignment.Left
    
    local TabList = Instance.new("ScrollingFrame", self.Sidebar)
    TabList.BackgroundTransparency, TabList.Position, TabList.Size = 1, UDim2.new(0, 0, 0, 95), UDim2.new(1, 0, 1, -100)
    TabList.ScrollBarThickness, TabList.CanvasSize = 0, UDim2.new(0, 0, 0, 0)
    local TL = Instance.new("UIListLayout", TabList)
    TL.Padding, TL.SortOrder = UDim.new(0, 5), Enum.SortOrder.LayoutOrder

    -- Content Area
    self.PageContainer = Instance.new("Frame", self.MainFrame)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Position, self.PageContainer.Size = UDim2.new(0, 210, 0, 15), UDim2.new(1, -220, 1, -30)

    -- Toggle Hotkey
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.MinimizeKey then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end)
    
    -- Search Logic
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = SearchBox.Text:lower()
        if text == "" then
            -- Show all tabs
            for _, t in pairs(self.Tabs) do t.Button.Visible = true end
        else
            for _, t in pairs(self.Tabs) do
                if t.Name:lower():find(text) then t.Button.Visible = true else t.Button.Visible = false end
            end
        end
    end)

    return self
end

function ModernSpiem:Destroy()
    self.ScreenGui:Destroy()
end

-- ============================================
-- TAB & ELEMENTS
-- ============================================

function ModernSpiem:AddTab(options)
    local name = type(options) == "table" and options.Title or options
    local icon = type(options) == "table" and options.Icon or "rbxassetid://6031097225" -- default icon
    local Hub, tab = self, {Name = name}
    
    local TabButton = Instance.new("TextButton", Hub.Sidebar:FindFirstChild("ScrollingFrame"))
    TabButton.BackgroundColor3, TabButton.BackgroundTransparency = Theme.ElementBackground, 1
    TabButton.Size = UDim2.new(1, -24, 0, 36)
    -- Center it in sidebar
    -- The ScrollingFrame is full width.
    -- We want specific padding.
    -- Let's put a UIPadding in the list?
    -- No, just set textbutton pos/size.
    -- Let's assume UIListLayout.
    -- To add padding left/right, we can use an indent in the button or a frame container.
    -- Let's stick with button.
    
    local TabCorner = Instance.new("UICorner", TabButton)
    TabCorner.CornerRadius = UDim.new(0, 8)
    
    local TabIcon = Instance.new("ImageLabel", TabButton)
    TabIcon.BackgroundTransparency, TabIcon.Position, TabIcon.Size, TabIcon.Image = 1, UDim2.new(0, 12, 0.5, -8), UDim2.new(0, 16, 0, 16), icon
    TabIcon.ImageColor3 = Theme.TextDim
    
    local TabTitle = Instance.new("TextLabel", TabButton)
    TabTitle.BackgroundTransparency, TabTitle.Position, TabTitle.Size = 1, UDim2.new(0, 38, 0, 0), UDim2.new(1, -38, 1, 0)
    TabTitle.Font, TabTitle.Text, TabTitle.TextColor3, TabTitle.TextSize, TabTitle.TextXAlignment = Enum.Font.GothamMedium, name, Theme.TextDim, 13, Enum.TextXAlignment.Left

    -- Add Padding to List
    local pl = Hub.Sidebar:FindFirstChild("ScrollingFrame"):FindFirstChildOfClass("UIPadding") or Instance.new("UIPadding", Hub.Sidebar:FindFirstChild("ScrollingFrame"))
    pl.PaddingLeft = UDim.new(0, 12)

    local Page = Instance.new("ScrollingFrame", Hub.PageContainer)
    Page.BackgroundTransparency, Page.Size, Page.Visible = 1, UDim2.new(1, 0, 1, 0), false
    Page.ScrollBarThickness, Page.ScrollBarImageColor3 = 2, Theme.Stroke
    local PL = Instance.new("UIListLayout", Page)
    PL.Padding, PL.SortOrder = UDim.new(0, 12), Enum.SortOrder.LayoutOrder
    
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 20)
    end)

    -- Tab Selection Logic
    tab.Button = TabButton
    tab.Page = Page
    
    function tab:Select()
        if Hub.CurrentTab then
            local prev = Hub.CurrentTab
            Tween(prev.Button, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 1})
            Tween(prev.Button.TextLabel, {0.2, Enum.EasingStyle.Quint}, {TextColor3 = Theme.TextDim})
            Tween(prev.Button.ImageLabel, {0.2, Enum.EasingStyle.Quint}, {ImageColor3 = Theme.TextDim})
            prev.Page.Visible = false
        end
        Hub.CurrentTab = tab
        Page.Visible = true
        Tween(TabButton, {0.2, Enum.EasingStyle.Quint}, {BackgroundTransparency = 0}) -- Selected BG
        TabButton.BackgroundColor3 = Theme.ElementBackground -- Set color
        Tween(TabTitle, {0.2, Enum.EasingStyle.Quint}, {TextColor3 = Theme.TextMain})
        Tween(TabIcon, {0.2, Enum.EasingStyle.Quint}, {ImageColor3 = Theme.Accent})
    end

    TabButton.MouseButton1Click:Connect(function() tab:Select() end)
    
    table.insert(Hub.Tabs, tab)
    if #Hub.Tabs == 1 then tab:Select() end

    -- Element Methods
    
    function tab:AddSection(title)
        local l = Instance.new("TextLabel", Page)
        l.BackgroundTransparency, l.Size, l.Font = 1, UDim2.new(1, 0, 0, 30), Enum.Font.GothamBold
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = title, Theme.TextMain, 18, Enum.TextXAlignment.Left
        -- Add padding left
        local p = Instance.new("UIPadding", l)
        p.PaddingLeft = UDim.new(0, 5)
    end
    
    function tab:AddCard(options)
        -- Special "Blue Card" from image
        -- Options: Title, Description, Color
        local t, content, col = options.Title, options.Content, options.Color or Theme.Accent
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = col, UDim2.new(1, 0, 0, 0)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        
        local tl = Instance.new("TextLabel", f)
        tl.BackgroundTransparency, tl.Position, tl.Size, tl.Font = 1, UDim2.new(0, 15, 0, 15), UDim2.new(1, -30, 0, 20), Enum.Font.GothamBold
        tl.Text, tl.TextColor3, tl.TextSize, tl.TextXAlignment = t, Color3.fromRGB(255, 255, 255), 16, Enum.TextXAlignment.Left
        
        local cl = Instance.new("TextLabel", f)
        cl.BackgroundTransparency, cl.Position, cl.Size, cl.Font = 1, UDim2.new(0, 15, 0, 40), UDim2.new(1, -30, 0, 0), Enum.Font.Gotham
        cl.Text, cl.TextColor3, cl.TextSize, cl.TextXAlignment, cl.TextWrapped = content, Color3.fromRGB(255, 255, 255), 13, Enum.TextXAlignment.Left, true
        
        -- Auto height
        cl.Size = UDim2.new(1, -30, 0, TextService:GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(420, math.huge)).Y)
        f.Size = UDim2.new(1, 0, 0, cl.Size.Y.Offset + 55)
    end

    function tab:AddToggle(idx, options)
        local title, default, callback = options.Title, options.Default, options.Callback
        local enabled = default or false
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Theme.ElementBackground, UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 12), UDim2.new(1, -80, 0, 20), Enum.Font.GothamBold
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = title, Theme.TextMain, 14, Enum.TextXAlignment.Left
        
        local d = Instance.new("TextLabel", f)
        d.BackgroundTransparency, d.Position, d.Size, d.Font = 1, UDim2.new(0, 15, 0, 32), UDim2.new(1, -80, 0, 15), Enum.Font.Gotham
        d.Text, d.TextColor3, d.TextSize, d.TextXAlignment = options.Description or "Toggle description", Theme.TextDim, 12, Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", f)
        btn.BackgroundTransparency, btn.Size, btn.Text = 1, UDim2.new(1, 0, 1, 0), ""
        
        -- Switch Visual
        local switchBase = Instance.new("Frame", f)
        switchBase.BackgroundColor3, switchBase.Size, switchBase.Position = Theme.Stroke, UDim2.new(0, 44, 0, 24), UDim2.new(1, -60, 0.5, -12)
        Instance.new("UICorner", switchBase).CornerRadius = UDim.new(1, 0)
        
        local switchKnob = Instance.new("Frame", switchBase)
        switchKnob.BackgroundColor3, switchKnob.Size, switchKnob.Position = Theme.TextMain, UDim2.new(0, 18, 0, 18), UDim2.new(0, 3, 0.5, -9)
        Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(1, 0)
        
        local toggleFuncs = {Type = "Toggle", Value = enabled}
        
        local function Update()
            toggleFuncs.Value = enabled
            Tween(switchBase, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = enabled and Theme.Accent or Theme.Stroke})
            Tween(switchKnob, {0.2, Enum.EasingStyle.Quint}, {Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)})
            if callback then callback(enabled) end
        end
        
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Update()
        end)
        
        -- Hover
        btn.MouseEnter:Connect(function() Tween(f, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Theme.ElementHover}) end)
        btn.MouseLeave:Connect(function() Tween(f, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Theme.ElementBackground}) end)

        if enabled then Update() end

        function toggleFuncs:SetValue(val)
            enabled = val
            Update()
        end
        function toggleFuncs:OnChanged(func) callback = func end
        
        ModernSpiem.Options[idx] = toggleFuncs
        return toggleFuncs
    end
    
    function tab:AddButton(options)
        local title, desc, callback = options.Title, options.Description, options.Callback
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Theme.ElementBackground, UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 12), UDim2.new(1, -60, 0, 20), Enum.Font.GothamBold
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = title, Theme.TextMain, 14, Enum.TextXAlignment.Left
        
        local d = Instance.new("TextLabel", f)
        d.BackgroundTransparency, d.Position, d.Size, d.Font = 1, UDim2.new(0, 15, 0, 32), UDim2.new(1, -60, 0, 15), Enum.Font.Gotham
        d.Text, d.TextColor3, d.TextSize, d.TextXAlignment = desc or "Click to execute", Theme.TextDim, 12, Enum.TextXAlignment.Left
        
        local icon = Instance.new("ImageLabel", f)
        icon.BackgroundTransparency, icon.Image, icon.ImageColor3 = 1, "rbxassetid://6031094670", Theme.TextDim
        icon.Size, icon.Position = UDim2.new(0, 20, 0, 20), UDim2.new(1, -35, 0.5, -10)
        
        local btn = Instance.new("TextButton", f)
        btn.BackgroundTransparency, btn.Size, btn.Text = 1, UDim2.new(1, 0, 1, 0), ""
        
        btn.MouseButton1Click:Connect(function()
            Tween(f, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Theme.Stroke})
            task.wait(0.1)
            Tween(f, {0.1, Enum.EasingStyle.Quint}, {BackgroundColor3 = Theme.ElementHover})
            if callback then callback() end
        end)
        
        btn.MouseEnter:Connect(function() 
            Tween(f, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Theme.ElementHover})
            Tween(icon, {0.2, Enum.EasingStyle.Quint}, {ImageColor3 = Theme.TextMain})
        end)
        btn.MouseLeave:Connect(function() 
            Tween(f, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Theme.ElementBackground})
            Tween(icon, {0.2, Enum.EasingStyle.Quint}, {ImageColor3 = Theme.TextDim})
        end)
        
        local btnFuncs = {}
        function btnFuncs:SetDesc(txt) d.Text = txt end
        return btnFuncs
    end
    
    function tab:AddSlider(idx, options)
        -- Simplified slider for modern look
        local title, default, min, max, rounding, callback = options.Title, options.Default, options.Min, options.Max, options.Rounding, options.Callback
        local value = default or min
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Theme.ElementBackground, UDim2.new(1, 0, 0, 65)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 10), UDim2.new(1, -30, 0, 20), Enum.Font.GothamBold
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = title, Theme.TextMain, 14, Enum.TextXAlignment.Left
        
        local vl = Instance.new("TextLabel", f)
        vl.BackgroundTransparency, vl.Position, vl.Size, vl.Font = 1, UDim2.new(1, -60, 0, 10), UDim2.new(0, 45, 0, 20), Enum.Font.Gotham
        vl.Text, vl.TextColor3, vl.TextSize, vl.TextXAlignment = tostring(value), Theme.TextDim, 13, Enum.TextXAlignment.Right
        
        local slideBar = Instance.new("Frame", f)
        slideBar.BackgroundColor3, slideBar.Position, slideBar.Size = Theme.Stroke, UDim2.new(0, 15, 0, 40), UDim2.new(1, -30, 0, 6)
        Instance.new("UICorner", slideBar).CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame", slideBar)
        fill.BackgroundColor3, fill.Size = Theme.Accent, UDim2.new((value - min) / (max - min), 0, 1, 0)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        
        local knob = Instance.new("Frame", fill)
        knob.BackgroundColor3, knob.Size, knob.Position = Color3.new(1,1,1), UDim2.new(0, 12, 0, 12), UDim2.new(1, -6, 0.5, -6)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        
        local slideBtn = Instance.new("TextButton", slideBar)
        slideBtn.BackgroundTransparency, slideBtn.Size, slideBtn.Text = 1, UDim2.new(1, 0, 1, 0), ""
        
        local sliderFuncs = {Type = "Slider", Value = value}
        
        local function Update(input)
            local pos = math.clamp((input.Position.X - slideBar.AbsolutePosition.X) / slideBar.AbsoluteSize.X, 0, 1)
            value = math.floor((min + (max - min) * pos) * (1 / rounding) + 0.5) / (1 / rounding)
            
            Tween(fill, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)})
            vl.Text = tostring(value)
            sliderFuncs.Value = value
            if callback then callback(value) end
        end
        
        slideBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local dragging = true
                Update(input)
                local connection
                connection = UserInputService.InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement then
                        Update(i)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        function sliderFuncs:SetValue(v)
            value = v
            Tween(fill, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)})
            vl.Text = tostring(value)
            sliderFuncs.Value = value
            if callback then callback(value) end
        end
        
        ModernSpiem.Options[idx] = sliderFuncs
        return sliderFuncs
    end
    
    function tab:AddDropdown(idx, options)
        -- ... implementation details similar to AddButton but with popup ...
        local title, default, values, callback = options.Title, options.Default, options.Values, options.Callback
        local open = false
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Theme.ElementBackground, UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.Font.GothamBold
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = title, Theme.TextMain, 14, Enum.TextXAlignment.Left

        local selected = default or values[1]
        
        local dropBtn = Instance.new("TextButton", f)
        dropBtn.BackgroundColor3, dropBtn.Position, dropBtn.Size = Theme.Background, UDim2.new(0.5, 5, 0.5, -15), UDim2.new(0.5, -20, 0, 30)
        Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
        dropBtn.Text, dropBtn.Font, dropBtn.TextColor3, dropBtn.TextSize = " " .. tostring(selected), Enum.Font.Gotham, Theme.TextMain, 13
        dropBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local arrow = Instance.new("ImageLabel", dropBtn)
        arrow.BackgroundTransparency, arrow.Image, arrow.Size, arrow.Position = 1, "rbxassetid://6034818372", UDim2.new(0, 16, 0, 16), UDim2.new(1, -20, 0.5, -8)
        
        local dropFuncs = {Type = "Dropdown", Value = selected}
        
        -- Popup
        local popup = Instance.new("Frame", Hub.ScreenGui)
        popup.Visible, popup.BackgroundColor3, popup.Size = false, Theme.ElementBackground, UDim2.new(0, 200, 0, 0)
        popup.ZIndex = 200
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 8)
        local pl = Instance.new("ScrollingFrame", popup)
        pl.BackgroundTransparency, pl.Size = 1, UDim2.new(1, 0, 1, 0)
        pl.ScrollBarThickness = 2
        local list = Instance.new("UIListLayout", pl)
        list.Padding = UDim.new(0, 2)
        
        local function RefreshVals()
            for _, v in pairs(pl:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
            for _, val in pairs(values) do
                local b = Instance.new("TextButton", pl)
                b.BackgroundColor3, b.Size = Theme.Background, UDim2.new(1, -10, 0, 28)
                b.Position = UDim2.new(0, 5, 0, 0) -- managed by layout
                b.Text = val
                b.TextColor3 = Theme.TextDim
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
                b.MouseButton1Click:Connect(function()
                    selected = val
                    dropBtn.Text = " " .. tostring(selected)
                    dropFuncs.Value = selected
                    if callback then callback(selected) end
                    popup.Visible = false
                    open = false
                    Tween(arrow, {0.2, Enum.EasingStyle.Quint}, {Rotation = 0})
                end)
            end
        end
        RefreshVals()
        
        dropBtn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                popup.Visible = true
                popup.Position = UDim2.fromOffset(dropBtn.AbsolutePosition.X, dropBtn.AbsolutePosition.Y + 35)
                popup.Size = UDim2.fromOffset(dropBtn.AbsoluteSize.X, math.min(#values*30 + 10, 200))
                pl.CanvasSize = UDim2.new(0, 0, 0, #values*30)
                Tween(arrow, {0.2, Enum.EasingStyle.Quint}, {Rotation = 180})
            else
                popup.Visible = false
                Tween(arrow, {0.2, Enum.EasingStyle.Quint}, {Rotation = 0})
            end
        end)
        
        function dropFuncs:SetValue(v)
            selected = v
            dropBtn.Text = " " .. tostring(v)
            dropFuncs.Value = v
            if callback then callback(v) end
        end
        
        ModernSpiem.Options[idx] = dropFuncs
        return dropFuncs
    end
    
    function tab:AddInput(idx, options)
         local title, default, placeholder, callback = options.Title, options.Default, options.Placeholder, options.Callback
         
         local f = Instance.new("Frame", Page)
         f.BackgroundColor3, f.Size = Theme.ElementBackground, UDim2.new(1, 0, 0, 60)
         Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
         
         local l = Instance.new("TextLabel", f)
         l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.Font.GothamBold
         l.Text, l.TextColor3, l.TextXAlignment = title, Theme.TextMain, Enum.TextXAlignment.Left
         
         local box = Instance.new("TextBox", f)
         box.BackgroundColor3, box.Position, box.Size = Theme.Background, UDim2.new(0.5, 5, 0.5, -15), UDim2.new(0.5, -20, 0, 30)
         Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
         box.Font, box.Text, box.PlaceholderText, box.TextColor3 = Enum.Font.Gotham, default or "", placeholder or "...", Theme.TextMain
         
         local inputFuncs = {Type = "Input", Value = default or ""}
         
         box.FocusLost:Connect(function(enter)
             inputFuncs.Value = box.Text
             if callback then callback(box.Text) end
         end)
         
         function inputFuncs:SetValue(v)
             box.Text = v
             inputFuncs.Value = v
         end
         
         ModernSpiem.Options[idx] = inputFuncs
         return inputFuncs
    end

    function tab:AddColorpicker(idx, options)
        local title, default, callback = options.Title, options.Default, options.Callback
        local color = default or Color3.fromRGB(255, 255, 255)
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Theme.ElementBackground, UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.Font.GothamBold
        l.Text, l.TextColor3, l.TextXAlignment = title, Theme.TextMain, Enum.TextXAlignment.Left
        
        local pickerBtn = Instance.new("TextButton", f)
        pickerBtn.BackgroundColor3 = color
        pickerBtn.Position, pickerBtn.Size = UDim2.new(1, -65, 0.5, -12), UDim2.new(0, 50, 0, 24)
        Instance.new("UICorner", pickerBtn).CornerRadius = UDim.new(0, 6)
        pickerBtn.Text = ""
        
        local cpFuncs = {Type = "Colorpicker", Value = color}
        
        pickerBtn.MouseButton1Click:Connect(function()
            -- Simple demo cycle: Red -> Green -> Blue -> White
            if color == Color3.fromRGB(255, 255, 255) then color = Color3.fromRGB(255, 0, 0)
            elseif color == Color3.fromRGB(255, 0, 0) then color = Color3.fromRGB(0, 255, 0)
            elseif color == Color3.fromRGB(0, 255, 0) then color = Color3.fromRGB(0, 0, 255)
            else color = Color3.fromRGB(255, 255, 255) end
            
            pickerBtn.BackgroundColor3 = color
            cpFuncs.Value = color
            if callback then callback(color) end
        end)
        
        function cpFuncs:SetValue(v)
            if type(v) == "table" and v.r then v = Color3.new(v.r, v.g, v.b) end
            color = v
            pickerBtn.BackgroundColor3 = color
            cpFuncs.Value = color
            if callback then callback(color) end
        end
        
        ModernSpiem.Options[idx] = cpFuncs
        return cpFuncs
    end

    function tab:AddKeybind(idx, options)
        local title, default, callback = options.Title, options.Default, options.Callback
        
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Theme.ElementBackground, UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.6, 0, 1, 0), Enum.Font.GothamBold
        l.Text, l.TextColor3, l.TextXAlignment = title, Theme.TextMain, Enum.TextXAlignment.Left
        
        local btn = Instance.new("TextButton", f)
        btn.BackgroundColor3 = Theme.Background
        btn.Position, btn.Size = UDim2.new(1, -95, 0.5, -15), UDim2.new(0, 80, 0, 30)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.Text, btn.TextColor3 = default or "None", Theme.TextDim
        
        local listening = false
        local key = default
        local keybindFuncs = {Type = "Keybind", Value = key}
        
        btn.MouseButton1Click:Connect(function()
            listening = true
            btn.Text = "..."
        end)
        
        UserInputService.InputBegan:Connect(function(input, gpe)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode.Name
                btn.Text = key
                listening = false
                keybindFuncs.Value = key
                if callback then callback(key, true) end
            elseif not listening and not gpe and input.KeyCode.Name == key then
                if callback then callback(key, false) end
            end
        end)
        
        function keybindFuncs:SetValue(v)
            key = v
            btn.Text = v
        end
        
        ModernSpiem.Options[idx] = keybindFuncs
        return keybindFuncs
    end

    return tab
end

-- ============================================
-- SAVE MANAGER (Unified)
-- ============================================
local SaveManager = {}
SaveManager.Folder = "ModernSpiemSettings"
SaveManager.Ignore = {}
SaveManager.Options = ModernSpiem.Options

function SaveManager:SetLibrary(library)
    self.Library = library
    self.Options = library.Options
end

function SaveManager:IgnoreThemeSettings()
    self.Ignore["SaveManager_ConfigList"] = true
    self.Ignore["SaveManager_ConfigName"] = true
end

function SaveManager:BuildFolderTree()
    if not isfolder(self.Folder) then makefolder(self.Folder) end
    if not isfolder(self.Folder .. "/settings") then makefolder(self.Folder .. "/settings") end
end

SaveManager.Parser = {
    Toggle = { Save = function(idx, obj) return {type="Toggle", idx=idx, value=obj.Value} end, Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end },
    Slider = { Save = function(idx, obj) return {type="Slider", idx=idx, value=obj.Value} end, Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end },
    Dropdown = { Save = function(idx, obj) return {type="Dropdown", idx=idx, value=obj.Value} end, Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end },
    Input = { Save = function(idx, obj) return {type="Input", idx=idx, value=obj.Value} end, Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end },
    Keybind = { Save = function(idx, obj) return {type="Keybind", idx=idx, value=obj.Value} end, Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end },
}

function SaveManager:Save(name)
    local path = self.Folder .. "/settings/" .. name .. ".json"
    local data = {objects = {}}
    for idx, opt in pairs(self.Options) do
        if self.Parser[opt.Type] and not self.Ignore[idx] then
            table.insert(data.objects, self.Parser[opt.Type].Save(idx, opt))
        end
    end
    writefile(path, game:GetService("HttpService"):JSONEncode(data))
    return true
end

function SaveManager:Load(name)
    local path = self.Folder .. "/settings/" .. name .. ".json"
    if not isfile(path) then return false end
    local data = game:GetService("HttpService"):JSONDecode(readfile(path))
    for _, opt in pairs(data.objects) do
        if self.Parser[opt.type] then self.Parser[opt.type].Load(opt.idx, opt) end
    end
    return true
end

function SaveManager:BuildConfigSection(tab)
    tab:AddSection("Configuration")
    tab:AddInput("SaveManager_ConfigName", {Title = "Config Name"})
    tab:AddDropdown("SaveManager_ConfigList", {Title = "Configs", Values = listfiles(self.Folder.."/settings"), Callback = function() end})
    
    tab:AddButton({Title = "Create Config", Callback = function() 
        local name = self.Options.SaveManager_ConfigName.Value 
        self:Save(name)
        self.Library:Notify({Title="Saved", Content="Config saved: "..name})
    end})
    tab:AddButton({Title = "Load Config", Callback = function()
        local name = self.Options.SaveManager_ConfigList.Value
        self:Load(name:match("([^/\\]+)$"):gsub("%.json", ""))
        self.Library:Notify({Title="Loaded", Content="Config loaded"})
    end})
end

ModernSpiem.SaveManager = SaveManager

return ModernSpiem
