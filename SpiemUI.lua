--[[
    SpiemUI Library V1.2
    A premium, fluent Roblox UI library for perfectusmim1/rblxui.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Spiem = {}
Spiem.__index = Spiem

print("--- SpiemUI V1.2 (Optimized) Loaded ---")

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

function Spiem.new(title)
    local self = setmetatable({}, Spiem)
    self.Tabs = {}
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SpiemUI_" .. math.random(1000, 9999)
    self.ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
    self.ScreenGui.ResetOnSpawn = false

    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    self.MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    self.MainFrame.Size = UDim2.new(0, 550, 0, 350)
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 10)
    local MS = Instance.new("UIStroke", self.MainFrame)
    MS.Color, MS.Thickness = Color3.fromRGB(40, 40, 40), 1

    self.Topbar = Instance.new("Frame", self.MainFrame)
    self.Topbar.Name, self.Topbar.BackgroundTransparency, self.Topbar.Size = "Topbar", 1, UDim2.new(1, 0, 0, 45)

    local TL = Instance.new("TextLabel", self.Topbar)
    TL.BackgroundTransparency, TL.Position, TL.Size, TL.Font = 1, UDim2.new(0, 20, 0, 0), UDim2.new(1, -120, 1, 0), Enum.Font.BuilderSansBold
    TL.Text, TL.TextColor3, TL.TextSize, TL.TextXAlignment = title or "Spiem UI", Color3.fromRGB(240, 240, 240), 16, Enum.TextXAlignment.Left

    MakeDraggable(self.Topbar, self.MainFrame)

    self.Sidebar = Instance.new("Frame", self.MainFrame)
    self.Sidebar.BackgroundColor3, self.Sidebar.Position, self.Sidebar.Size = Color3.fromRGB(20, 20, 20), UDim2.new(0, 10, 0, 50), UDim2.new(0, 140, 1, -60)
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 8)

    self.TabList = Instance.new("ScrollingFrame", self.Sidebar)
    self.TabList.BackgroundTransparency, self.TabList.Position, self.TabList.Size = 1, UDim2.new(0, 5, 0, 5), UDim2.new(1, -10, 1, -10)
    self.TabList.ScrollBarThickness, self.TabList.CanvasSize = 0, UDim2.new(0, 0, 0, 0)
    local TLL = Instance.new("UIListLayout", self.TabList)
    TLL.Padding, TLL.SortOrder = UDim.new(0, 5), Enum.SortOrder.LayoutOrder

    self.PageContainer = Instance.new("Frame", self.MainFrame)
    self.PageContainer.BackgroundTransparency, self.PageContainer.Position, self.PageContainer.Size = 1, UDim2.new(0, 160, 0, 50), UDim2.new(1, -170, 1, -60)

    UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.RightControl then self.MainFrame.Visible = not self.MainFrame.Visible end
    end)
    return self
end

function Spiem:Destroy() self.ScreenGui:Destroy() end

function Spiem:CreateTab(name)
    local Hub, tab = self, {Name = name}
    local BTN = Instance.new("TextButton", Hub.TabList)
    BTN.BackgroundColor3, BTN.BackgroundTransparency, BTN.Size, BTN.AutoButtonColor = Color3.fromRGB(25, 25, 25), 1, UDim2.new(1, 0, 0, 32), false
    BTN.Font, BTN.Text, BTN.TextColor3, BTN.TextSize = Enum.Font.BuilderSansMedium, name, Color3.fromRGB(180, 180, 180), 14
    Instance.new("UICorner", BTN).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", Hub.PageContainer)
    Page.BackgroundTransparency, Page.Size, Page.Visible, Page.ScrollBarThickness = 1, UDim2.new(1, 0, 1, 0), false, 2
    Page.ScrollBarImageColor3, Page.CanvasSize = Color3.fromRGB(50, 50, 50), UDim2.new(0, 0, 0, 0)
    local PL = Instance.new("UIListLayout", Page)
    PL.Padding, PL.SortOrder = UDim.new(0, 8), Enum.SortOrder.LayoutOrder
    local PPD = Instance.new("UIPadding", Page)
    PPD.PaddingLeft, PPD.PaddingTop = UDim.new(0, 2), UDim.new(0, 2)
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

    function tab:CreateButton(t, c)
        local b = Instance.new("TextButton", Page)
        b.BackgroundColor3, b.Size, b.AutoButtonColor, b.Font = Color3.fromRGB(30, 30, 30), UDim2.new(1, 0, 0, 38), false, Enum.Font.BuilderSansMedium
        b.Text, b.TextColor3, b.TextSize = t, Color3.fromRGB(230, 230, 230), 14
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local s = Instance.new("UIStroke", b)
        s.Color, s.ApplyStrokeMode = Color3.fromRGB(45, 45, 45), Enum.ApplyStrokeMode.Border
        b.MouseButton1Up:Connect(function() Tween(b, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 38)}); c() end)
        b.MouseButton1Down:Connect(function() Tween(b, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, -4, 0, 36)}) end)
    end

    function tab:CreateToggle(t, d, c)
        local en = d or false
        local f = Instance.new("TextButton", Page)
        f.BackgroundColor3, f.Size, f.AutoButtonColor, f.Text = Color3.fromRGB(30, 30, 30), UDim2.new(1, 0, 0, 38), false, ""
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left
        local ot = Instance.new("Frame", f)
        ot.BackgroundColor3, ot.Position, ot.Size = Color3.fromRGB(40, 40, 40), UDim2.new(1, -45, 0.5, -10), UDim2.new(0, 35, 0, 20)
        Instance.new("UICorner", ot).CornerRadius = UDim.new(1, 0)
        local inr = Instance.new("Frame", ot)
        inr.BackgroundColor3, inr.Position, inr.Size = Color3.fromRGB(150, 150, 150), UDim2.new(0, 2, 0.5, -8), UDim2.new(0, 16, 0, 16)
        Instance.new("UICorner", inr).CornerRadius = UDim.new(1, 0)
        local function upd()
            Tween(ot, {0.3, Enum.EasingStyle.Quint}, {BackgroundColor3 = en and Color3.fromRGB(0, 136, 255) or Color3.fromRGB(40, 40, 40)})
            Tween(inr, {0.3, Enum.EasingStyle.Quint}, {Position = en and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = en and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)})
            if c then c(en) end
        end
        f.MouseButton1Click:Connect(function() en = not en; upd() end)
        upd()
    end

    function tab:CreateLabel(t)
        local f = Instance.new("Frame", Page)
        f.BackgroundTransparency, f.Size = 1, UDim2.new(1, 0, 0, 20)
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Size, l.Font = 1, UDim2.new(1, 0, 1, 0), Enum.Font.BuilderSans
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = t, Color3.fromRGB(150, 150, 150), 13, Enum.TextXAlignment.Left
    end

    function tab:CreateParagraph(title, content)
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(25, 25, 25), UDim2.new(1, 0, 0, 60)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local t = Instance.new("TextLabel", f)
        t.BackgroundTransparency, t.Position, t.Size, t.Font = 1, UDim2.new(0, 12, 0, 8), UDim2.new(1, -24, 0, 18), Enum.Font.BuilderSansBold
        t.Text, t.TextColor3, t.TextSize, t.TextXAlignment = title, Color3.fromRGB(240, 240, 240), 14, Enum.TextXAlignment.Left
        local c = Instance.new("TextLabel", f)
        c.BackgroundTransparency, c.Position, c.Size, c.Font = 1, UDim2.new(0, 12, 0, 26), UDim2.new(1, -24, 0, 24), Enum.Font.BuilderSans
        c.Text, c.TextColor3, c.TextSize, c.TextXAlignment, c.TextWrapped = content, Color3.fromRGB(180, 180, 180), 12, Enum.TextXAlignment.Left, true
        c:GetPropertyChangedSignal("TextBounds"):Connect(function()
            f.Size = UDim2.new(1, 0, 0, c.TextBounds.Y + 40)
            c.Size = UDim2.new(1, -24, 0, c.TextBounds.Y)
        end)
    end
    
    function tab:CreateInput(text, placeholder, callback)
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size = Color3.fromRGB(30, 30, 30), UDim2.new(1, 0, 0, 45)
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(0.4, 0, 1, 0), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = text, Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left
        local bf = Instance.new("Frame", f)
        bf.BackgroundColor3, bf.Position, bf.Size = Color3.fromRGB(20, 20, 20), UDim2.new(1, -165, 0.5, -14), UDim2.new(0, 150, 0, 28)
        Instance.new("UICorner", bf).CornerRadius = UDim.new(0, 4)
        local s = Instance.new("UIStroke", bf)
        s.Color = Color3.fromRGB(45, 45, 45)
        local box = Instance.new("TextBox", bf)
        box.BackgroundTransparency, box.Position, box.Size, box.Font = 1, UDim2.new(0, 5, 0, 0), UDim2.new(1, -10, 1, 0), Enum.Font.BuilderSans
        box.PlaceholderText, box.Text, box.TextColor3, box.PlaceholderColor3, box.TextSize = placeholder or "...", "", Color3.fromRGB(255, 255, 255), Color3.fromRGB(100, 100, 100), 13
        box.TextXAlignment, box.ClearTextOnFocus = Enum.TextXAlignment.Left, false
        box.Focused:Connect(function() Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(0, 136, 255)}) end)
        box.FocusLost:Connect(function() Tween(s, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(45, 45, 45)}); if callback then callback(box.Text) end end)
    end

    function tab:CreateDropdown(text, options, default, callback)
        local op = false
        local f = Instance.new("Frame", Page)
        f.BackgroundColor3, f.Size, f.ClipsDescendants = Color3.fromRGB(30, 30, 30), UDim2.new(1, 0, 0, 40), true
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local b = Instance.new("TextButton", f)
        b.BackgroundTransparency, b.Size, b.Text = 1, UDim2.new(1, 0, 0, 40), ""
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency, l.Position, l.Size, l.Font = 1, UDim2.new(0, 15, 0, 0), UDim2.new(1, -60, 0, 40), Enum.Font.BuilderSansMedium
        l.Text, l.TextColor3, l.TextSize, l.TextXAlignment = text .. ": " .. (default or "Seç"), Color3.fromRGB(230, 230, 230), 14, Enum.TextXAlignment.Left
        local ic = Instance.new("ImageLabel", f)
        ic.BackgroundTransparency, ic.Position, ic.Size, ic.Image = 1, UDim2.new(1, -30, 0, 12), UDim2.new(0, 16, 0, 16), "rbxassetid://6034818372"
        ic.ImageColor3 = Color3.fromRGB(180, 180, 180)
        local ol = Instance.new("Frame", f)
        ol.BackgroundTransparency, ol.Position, ol.Size = 1, UDim2.new(0, 0, 0, 40), UDim2.new(1, 0, 0, 0)
        local oll = Instance.new("UIListLayout", ol)
        oll.Padding, oll.SortOrder = UDim.new(0, 2), Enum.SortOrder.LayoutOrder
        b.MouseButton1Click:Connect(function()
            op = not op
            if op then
                for _, v in pairs(ol:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                for _, o in pairs(options) do
                    local ob = Instance.new("TextButton", ol)
                    ob.BackgroundColor3, ob.Size, ob.Font, ob.Text = Color3.fromRGB(35, 35, 35), UDim2.new(1, -10, 0, 30), Enum.Font.BuilderSans, o
                    ob.TextColor3, ob.TextSize, ob.AutoButtonColor = Color3.fromRGB(200, 200, 200), 13, false
                    Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 4)
                    ob.MouseButton1Click:Connect(function()
                        l.Text = text .. ": " .. o; op = false
                        Tween(f, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 40)})
                        Tween(ic, {0.3, Enum.EasingStyle.Quint}, {Rotation = 0})
                        if callback then callback(o) end
                    end)
                end
                Tween(f, {0.4, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 40 + (#options * 32) + 5)})
                Tween(ic, {0.4, Enum.EasingStyle.Quint}, {Rotation = 180})
            else
                Tween(f, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 40)})
                Tween(ic, {0.3, Enum.EasingStyle.Quint}, {Rotation = 0})
            end
        end)
    end

    return tab
end

return Spiem
