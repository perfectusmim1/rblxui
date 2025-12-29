--[[
    SpiemUI Library V1.1
    A premium, fluent Roblox UI library.
    
    Fixed: Variable Scoping and Nil Errors
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Spiem = {}
Spiem.__index = Spiem

print("SpiemUI V1.1 Loading...")

-- Utility Functions
local function Tween(object, info, properties)
    local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPos = nil

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
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
    
    -- Main Gui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SpiemUI_" .. math.random(1000, 9999)
    self.ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false

    -- Main Window
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    self.MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    self.MainFrame.Size = UDim2.new(0, 550, 0, 350)
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = self.MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1
    MainStroke.Parent = self.MainFrame

    -- Topbar
    self.Topbar = Instance.new("Frame")
    self.Topbar.Name = "Topbar"
    self.Topbar.BackgroundTransparency = 1
    self.Topbar.Size = UDim2.new(1, 0, 0, 45)
    self.Topbar.Parent = self.MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Font = Enum.Font.BuilderSansBold
    TitleLabel.Text = title or "Spiem UI"
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = self.Topbar

    MakeDraggable(self.Topbar, self.MainFrame)

    -- Container Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 50)
    self.Sidebar.Size = UDim2.new(0, 140, 1, -60)
    self.Sidebar.Parent = self.MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = self.Sidebar

    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.BackgroundTransparency = 1
    self.TabList.Position = UDim2.new(0, 5, 0, 5)
    self.TabList.Size = UDim2.new(1, -10, 1, -10)
    self.TabList.ScrollBarThickness = 0
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.Parent = self.Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = self.TabList

    -- Page Container
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Name = "PageContainer"
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Position = UDim2.new(0, 160, 0, 50)
    self.PageContainer.Size = UDim2.new(1, -170, 1, -60)
    self.PageContainer.Parent = self.MainFrame

    -- Handle Toggle
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            self.MainFrame.Visible = not self.MainFrame.Visible
        end
    end)

    return self
end

function Spiem:Destroy()
    self.ScreenGui:Destroy()
end

function Spiem:CreateTab(name)
    local Hub = self
    local tab = {}
    tab.Name = name
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "_Tab"
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.AutoButtonColor = false
    TabButton.Font = Enum.Font.BuilderSansMedium
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 14
    TabButton.Parent = Hub.TabList

    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 6)
    TabButtonCorner.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "_Page"
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = Hub.PageContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Page

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingLeft = UDim.new(0, 2)
    PagePadding.PaddingRight = UDim.new(0, 5)
    PagePadding.PaddingTop = UDim.new(0, 2)
    PagePadding.PaddingBottom = UDim.new(0, 2)
    PagePadding.Parent = Page

    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
    end)

    function tab:Select()
        for _, t in pairs(Hub.Tabs) do
            t.Page.Visible = false
            Tween(t.Button, {0.3, Enum.EasingStyle.Quint}, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)})
        end
        Page.Visible = true
        Tween(TabButton, {0.3, Enum.EasingStyle.Quint}, {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
    end

    TabButton.MouseButton1Click:Connect(function()
        tab:Select()
    end)

    local tabData = {Button = TabButton, Page = Page}
    table.insert(Hub.Tabs, tabData)

    if #Hub.Tabs == 1 then
        tab:Select()
    end

    -- Elements
    function tab:CreateButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Name = text .. "_Btn"
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.BuilderSansMedium
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        btn.TextSize = 14
        btn.Parent = Page

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(45, 45, 45)
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btnStroke.Parent = btn

        btn.MouseEnter:Connect(function()
            Tween(btn, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
        end)
        btn.MouseButton1Down:Connect(function()
            Tween(btn, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, -4, 0, 36)})
        end)
        btn.MouseButton1Up:Connect(function()
            Tween(btn, {0.1, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 38)})
            callback()
        end)
    end

    function tab:CreateToggle(text, default, callback)
        local enabled = default or false
        
        local toggleFrame = Instance.new("TextButton")
        toggleFrame.Name = text .. "_Toggle"
        toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggleFrame.Size = UDim2.new(1, 0, 0, 38)
        toggleFrame.AutoButtonColor = false
        toggleFrame.Text = ""
        toggleFrame.Parent = Page

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame

        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Position = UDim2.new(0, 15, 0, 0)
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.Font = Enum.Font.BuilderSansMedium
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        toggleLabel.TextSize = 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame

        local toggleOuter = Instance.new("Frame")
        toggleOuter.Name = "Outer"
        toggleOuter.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        toggleOuter.Position = UDim2.new(1, -45, 0.5, -10)
        toggleOuter.Size = UDim2.new(0, 35, 0, 20)
        toggleOuter.Parent = toggleFrame

        local outerCorner = Instance.new("UICorner")
        outerCorner.CornerRadius = UDim.new(1, 0)
        outerCorner.Parent = toggleOuter

        local toggleInner = Instance.new("Frame")
        toggleInner.Name = "Inner"
        toggleInner.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        toggleInner.Position = UDim2.new(0, 2, 0.5, -8)
        toggleInner.Size = UDim2.new(0, 16, 0, 16)
        toggleInner.Parent = toggleOuter

        local innerCorner = Instance.new("UICorner")
        innerCorner.CornerRadius = UDim.new(1, 0)
        innerCorner.Parent = toggleInner

        local function update()
            if enabled then
                Tween(toggleOuter, {0.3, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(0, 136, 255)})
                Tween(toggleInner, {0.3, Enum.EasingStyle.Quint}, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            else
                Tween(toggleOuter, {0.3, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                Tween(toggleInner, {0.3, Enum.EasingStyle.Quint}, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 150)})
            end
            callback(enabled)
        end

        toggleFrame.MouseButton1Click:Connect(function()
            enabled = not enabled
            update()
        end)

        update()
    end

    function tab:CreateParagraph(title, content)
        local paraFrame = Instance.new("Frame")
        paraFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        paraFrame.Size = UDim2.new(1, 0, 0, 60)
        paraFrame.Parent = Page

        local paraCorner = Instance.new("UICorner")
        paraCorner.CornerRadius = UDim.new(0, 6)
        paraCorner.Parent = paraFrame

        local paraTitle = Instance.new("TextLabel")
        paraTitle.BackgroundTransparency = 1
        paraTitle.Position = UDim2.new(0, 12, 0, 8)
        paraTitle.Size = UDim2.new(1, -24, 0, 18)
        paraTitle.Font = Enum.Font.BuilderSansBold
        paraTitle.Text = title
        paraTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
        paraTitle.TextSize = 14
        paraTitle.TextXAlignment = Enum.TextXAlignment.Left
        paraTitle.Parent = paraFrame

        local paraContent = Instance.new("TextLabel")
        paraContent.BackgroundTransparency = 1
        paraContent.Position = UDim2.new(0, 12, 0, 26)
        paraContent.Size = UDim2.new(1, -24, 0, 24)
        paraContent.Font = Enum.Font.BuilderSans
        paraContent.Text = content
        paraContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        paraContent.TextSize = 12
        paraContent.TextXAlignment = Enum.TextXAlignment.Left
        paraContent.TextWrapped = true
        paraContent.Parent = paraFrame
        
        paraContent:GetPropertyChangedSignal("TextBounds"):Connect(function()
            paraFrame.Size = UDim2.new(1, 0, 0, paraContent.TextBounds.Y + 40)
            paraContent.Size = UDim2.new(1, -24, 0, paraContent.TextBounds.Y)
        end)
        paraFrame.Size = UDim2.new(1, 0, 0, paraContent.TextBounds.Y + 40)
    end

    function tab:CreateLabel(text)
        local labelFrame = Instance.new("Frame")
        labelFrame.BackgroundTransparency = 1
        labelFrame.Size = UDim2.new(1, 0, 0, 20)
        labelFrame.Parent = Page

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = Enum.Font.BuilderSans
        label.Text = text
        label.TextColor3 = Color3.fromRGB(150, 150, 150)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = labelFrame
    end

    function tab:CreateInput(text, placeholder, callback)
        local inputFrame = Instance.new("Frame")
        inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        inputFrame.Size = UDim2.new(1, 0, 0, 45)
        inputFrame.Parent = Page

        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 6)
        inputCorner.Parent = inputFrame

        local inputLabel = Instance.new("TextLabel")
        inputLabel.BackgroundTransparency = 1
        inputLabel.Position = UDim2.new(0, 15, 0, 0)
        inputLabel.Size = UDim2.new(0.4, 0, 1, 0)
        inputLabel.Font = Enum.Font.BuilderSansMedium
        inputLabel.Text = text
        inputLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        inputLabel.TextSize = 14
        inputLabel.TextXAlignment = Enum.TextXAlignment.Left
        inputLabel.Parent = inputFrame

        local boxFrame = Instance.new("Frame")
        boxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        boxFrame.Position = UDim2.new(1, -165, 0.5, -14)
        boxFrame.Size = UDim2.new(0, 150, 0, 28)
        boxFrame.Parent = inputFrame

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 4)
        boxCorner.Parent = boxFrame

        local boxStroke = Instance.new("UIStroke")
        boxStroke.Color = Color3.fromRGB(45, 45, 45)
        boxStroke.Parent = boxFrame

        local box = Instance.new("TextBox")
        box.BackgroundTransparency = 1
        box.Position = UDim2.new(0, 5, 0, 0)
        box.Size = UDim2.new(1, -10, 1, 0)
        box.Font = Enum.Font.BuilderSans
        box.PlaceholderText = placeholder or "Type here..."
        box.Text = ""
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        box.TextSize = 13
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.Parent = boxFrame

        box.Focused:Connect(function()
            Tween(boxStroke, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(0, 136, 255)})
        end)
        box.FocusLost:Connect(function()
            Tween(boxStroke, {0.2, Enum.EasingStyle.Quint}, {Color = Color3.fromRGB(45, 45, 45)})
            callback(box.Text)
        end)
    end

    function tab:CreateDropdown(text, options, default, callback)
        local dropdown = {
            Open = false,
            Options = options,
            Selected = default
        }

        local dropFrame = Instance.new("Frame")
        dropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        dropFrame.Size = UDim2.new(1, 0, 0, 40)
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = Page

        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 6)
        dropCorner.Parent = dropFrame

        local dropBtn = Instance.new("TextButton")
        dropBtn.BackgroundTransparency = 1
        dropBtn.Size = UDim2.new(1, 0, 0, 40)
        dropBtn.Text = ""
        dropBtn.Parent = dropFrame

        local dropLabel = Instance.new("TextLabel")
        dropLabel.BackgroundTransparency = 1
        dropLabel.Position = UDim2.new(0, 15, 0, 0)
        dropLabel.Size = UDim2.new(1, -60, 0, 40)
        dropLabel.Font = Enum.Font.BuilderSansMedium
        dropLabel.Text = text .. ": " .. (default or "Select")
        dropLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        dropLabel.TextSize = 14
        dropLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropLabel.Parent = dropFrame

        local dropIcon = Instance.new("ImageLabel")
        dropIcon.BackgroundTransparency = 1
        dropIcon.Position = UDim2.new(1, -30, 0, 12)
        dropIcon.Size = UDim2.new(0, 16, 0, 16)
        dropIcon.Image = "rbxassetid://6034818372"
        dropIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        dropIcon.Parent = dropFrame

        local optionList = Instance.new("Frame")
        optionList.BackgroundTransparency = 1
        optionList.Position = UDim2.new(0, 0, 0, 40)
        optionList.Size = UDim2.new(1, 0, 0, 0)
        optionList.Parent = dropFrame

        local optionLayout = Instance.new("UIListLayout")
        optionLayout.Padding = UDim.new(0, 2)
        optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optionLayout.Parent = optionList

        local function updateList()
            for _, v in pairs(optionList:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end

            for _, opt in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                optBtn.Size = UDim2.new(1, -10, 0, 30)
                optBtn.Position = UDim2.new(0, 5, 0, 0)
                optBtn.Font = Enum.Font.BuilderSans
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optBtn.TextSize = 13
                optBtn.AutoButtonColor = false
                optBtn.Parent = optionList

                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

                optBtn.MouseButton1Click:Connect(function()
                    dropdown.Selected = opt
                    dropLabel.Text = text .. ": " .. opt
                    dropdown.Open = false
                    Tween(dropFrame, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 40)})
                    Tween(dropIcon, {0.3, Enum.EasingStyle.Quint}, {Rotation = 0})
                    callback(opt)
                end)
            end
        end

        dropBtn.MouseButton1Click:Connect(function()
            dropdown.Open = not dropdown.Open
            if dropdown.Open then
                updateList()
                local newY = 40 + (#options * 32) + 5
                Tween(dropFrame, {0.4, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, newY)})
                Tween(dropIcon, {0.4, Enum.EasingStyle.Quint}, {Rotation = 180})
            else
                Tween(dropFrame, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 40)})
                Tween(dropIcon, {0.3, Enum.EasingStyle.Quint}, {Rotation = 0})
            end
        end)
    end

    function tab:CreateMultiDropdown(text, options, default, callback)
        local dropdown = {
            Open = false,
            Options = options,
            Selected = default or {}
        }

        local dropFrame = Instance.new("Frame")
        dropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        dropFrame.Size = UDim2.new(1, 0, 0, 40)
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = Page

        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 6)
        dropCorner.Parent = dropFrame

        local dropBtn = Instance.new("TextButton")
        dropBtn.BackgroundTransparency = 1
        dropBtn.Size = UDim2.new(1, 0, 0, 40)
        dropBtn.Text = ""
        dropBtn.Parent = dropFrame

        local dropLabel = Instance.new("TextLabel")
        dropLabel.BackgroundTransparency = 1
        dropLabel.Position = UDim2.new(0, 15, 0, 0)
        dropLabel.Size = UDim2.new(1, -60, 0, 40)
        dropLabel.Font = Enum.Font.BuilderSansMedium
        dropLabel.Text = text
        dropLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        dropLabel.TextSize = 14
        dropLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropLabel.Parent = dropFrame

        local dropIcon = Instance.new("ImageLabel")
        dropIcon.BackgroundTransparency = 1
        dropIcon.Position = UDim2.new(1, -30, 0, 12)
        dropIcon.Size = UDim2.new(0, 16, 0, 16)
        dropIcon.Image = "rbxassetid://6034818372"
        dropIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        dropIcon.Parent = dropFrame

        local optionList = Instance.new("Frame")
        optionList.BackgroundTransparency = 1
        optionList.Position = UDim2.new(0, 0, 0, 40)
        optionList.Size = UDim2.new(1, 0, 0, 0)
        optionList.Parent = dropFrame

        local optionLayout = Instance.new("UIListLayout")
        optionLayout.Padding = UDim.new(0, 2)
        optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optionLayout.Parent = optionList

        local function updateList()
            for _, v in pairs(optionList:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end

            for _, opt in pairs(options) do
                local isSelected = table.find(dropdown.Selected, opt)
                local optBtn = Instance.new("TextButton")
                optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(0, 110, 200) or Color3.fromRGB(35, 35, 35)
                optBtn.Size = UDim2.new(1, -10, 0, 30)
                optBtn.Position = UDim2.new(0, 5, 0, 0)
                optBtn.Font = Enum.Font.BuilderSans
                optBtn.Text = opt
                optBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                optBtn.TextSize = 13
                optBtn.AutoButtonColor = false
                optBtn.Parent = optionList

                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

                optBtn.MouseButton1Click:Connect(function()
                    local idx = table.find(dropdown.Selected, opt)
                    if idx then
                        table.remove(dropdown.Selected, idx)
                        Tween(optBtn, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(200, 200, 200)})
                    else
                        table.insert(dropdown.Selected, opt)
                        Tween(optBtn, {0.2, Enum.EasingStyle.Quint}, {BackgroundColor3 = Color3.fromRGB(0, 110, 200), TextColor3 = Color3.fromRGB(255, 255, 255)})
                    end
                    callback(dropdown.Selected)
                end)
            end
        end

        dropBtn.MouseButton1Click:Connect(function()
            dropdown.Open = not dropdown.Open
            if dropdown.Open then
                updateList()
                local newY = 40 + (#options * 32) + 5
                Tween(dropFrame, {0.4, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, newY)})
                Tween(dropIcon, {0.4, Enum.EasingStyle.Quint}, {Rotation = 180})
            else
                Tween(dropFrame, {0.3, Enum.EasingStyle.Quint}, {Size = UDim2.new(1, 0, 0, 40)})
                Tween(dropIcon, {0.3, Enum.EasingStyle.Quint}, {Rotation = 0})
            end
        end)
    end

    return tab
end

return Spiem
