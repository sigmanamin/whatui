do  local ui =  game:GetService("CoreGui"):FindFirstChild("WhatUI-Lib")  if ui then ui:Destroy() end end
do  local blur =  game:GetService("Lighting"):FindFirstChild("WhatUIBlur")  if blur then blur:Destroy() end end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local WhatUI = Instance.new("ScreenGui")

-- Colors and Theme
local Theme = {
    Primary = Color3.fromRGB(32, 32, 42),
    Secondary = Color3.fromRGB(25, 25, 35), 
    Accent = Color3.fromRGB(114, 137, 218), -- Discord-like purple
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(87, 242, 135),
    Error = Color3.fromRGB(242, 87, 87),
}

-- Utility Functions
local function tablefound(ta, object)
    for i,v in pairs(ta) do
        if v == object then
            return true
        end
    end
    return false
end

local function CreateTween(instance, properties, style, duration)
    if style == nil then style = "Quad" end
    if duration == nil then duration = 0.5 end
    return TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle[style]), properties)
end

local function CircleAnim(GuiObject, EndColour, StartColour)
    local PX, PY = GetXY(GuiObject)
    local Circle = Objects.new("Circle")
    Circle.Size = UDim2.fromScale(0,0)
    Circle.Position = UDim2.fromScale(PX,PY)
    Circle.ImageColor3 = StartColour or GuiObject.ImageColor3
    Circle.ZIndex = 200
    Circle.Parent = GuiObject
    local Size = GuiObject.AbsoluteSize.X
    TweenService:Create(Circle, TweenInfo.new(0.5), {Position = UDim2.fromScale(PX,PY) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, ImageColor3 = EndColour, Size = UDim2.fromOffset(Size,Size)}):Play()
    spawn(function()
        wait(0.5)
        Circle:Destroy()
    end)
end

local function GetXY(GuiObject)
    local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
    return Px/Max, Py/May
end

-- Components Definition
local ActualTypes = {
    RoundFrame = "ImageLabel",
    Shadow = "ImageLabel",
    Circle = "ImageLabel",
    CircleButton = "ImageButton",
    Frame = "Frame",
    Label = "TextLabel",
    Button = "TextButton",
    SmoothButton = "ImageButton",
    Box = "TextBox",
    ScrollingFrame = "ScrollingFrame",
    Menu = "ImageButton",
    NavBar = "ImageButton",
    Notification = "Frame"
}

local Properties = {
    RoundFrame = {
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100,100,100,100),
        SliceScale = 0.02
    },
    SmoothButton = {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100,100,100,100),
        SliceScale = 0.02
    },
    Shadow = {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49,49,450,450),
        Size = UDim2.fromScale(1,1) + UDim2.fromOffset(30,30),
        Position = UDim2.fromOffset(-15,-15)
    },
    Circle = {
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554831670"
    },
    CircleButton = {
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Image = "rbxassetid://5554831670"
    },
    Frame = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1,1)
    },
    Label = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(5,0),
        Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left
    },
    Button = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(5,0),
        Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left
    },
    Box = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(5,0),
        Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left
    },
    ScrollingFrame = {
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.fromScale(0,0),
        Size = UDim2.fromScale(1,1)
    },
    Menu = {
        Name = "More",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031091001",
        Size = UDim2.fromOffset(20,20),
        Position = UDim2.fromScale(1,0.5) - UDim2.fromOffset(25,10)
    },
    NavBar = {
        Name = "SheetToggle",
        Image = "rbxassetid://8997386995",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(20,20),
        Position = UDim2.fromOffset(5,5),
        AutoButtonColor = false
    }
}

local Types = {
    "RoundFrame",
    "Shadow",
    "Circle",
    "CircleButton",
    "Frame",
    "Label",
    "Button",
    "SmoothButton",
    "Box",
    "ScrollingFrame",
    "Menu",
    "NavBar",
    "Notification"
}

function FindType(String)
    for _, Type in next, Types do
        if Type:sub(1, #String):lower() == String:lower() then
            return Type
        end
    end
    return false
end

local Objects = {}

function Objects.new(Type)
    local TargetType = FindType(Type)
    if TargetType then
        local NewImage = Instance.new(ActualTypes[TargetType])
        if Properties[TargetType] then
            for Property, Value in next, Properties[TargetType] do
                NewImage[Property] = Value
            end
        end
        return NewImage
    else
        return Instance.new(Type)
    end
end

WhatUI.Name = "WhatUI-Lib"
WhatUI.Parent = game.CoreGui
WhatUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local whatui = {}

function whatui:Create(options)
    options = options or {}
    local title = options.title or "WhatUI"
    local subtitle = options.subtitle or "A Modern UI Library"
    local blur = options.blur or true
    local theme = options.theme or Theme
    
    if blur then
        local blurEffect = Instance.new('BlurEffect')
        blurEffect.Name = "WhatUIBlur"
        blurEffect.Parent = game.Lighting
        blurEffect.Size = 0
        
        TweenService:Create(
            blurEffect,
            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = 15}
        ):Play()
    end
    
    -- Create Main UI Container
    local MainUI = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local HeaderBar = Instance.new("Frame")
    local HeaderUICorner = Instance.new("UICorner")
    local TitleLabel = Instance.new("TextLabel")
    local SubtitleLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("ImageButton")
    
    MainUI.Name = "MainUI"
    MainUI.Parent = WhatUI
    MainUI.AnchorPoint = Vector2.new(0.5, 0.5)
    MainUI.BackgroundColor3 = theme.Primary
    MainUI.ClipsDescendants = true
    MainUI.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainUI.Size = UDim2.new(0, 0, 0, 0)
    
    TweenService:Create(
        MainUI, 
        TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 650, 0, 500)} -- Reduced width to accommodate TabContainer
    ):Play()
    
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainUI
    
    -- Create Shadow
    local Shadow = Objects.new("Shadow")
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.Parent = MainUI
    
    -- Header with title
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Parent = MainUI
    HeaderBar.BackgroundColor3 = theme.Secondary
    HeaderBar.Size = UDim2.new(1, 0, 0, 50)
    
    HeaderUICorner.CornerRadius = UDim.new(0, 10)
    HeaderUICorner.Parent = HeaderBar
    
    -- Create header corner fixer
    local HeaderFixer = Instance.new("Frame")
    HeaderFixer.Name = "HeaderFixer"
    HeaderFixer.Parent = HeaderBar
    HeaderFixer.BackgroundColor3 = theme.Secondary
    HeaderFixer.BorderSizePixel = 0
    HeaderFixer.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderFixer.Size = UDim2.new(1, 0, 0.5, 0)
    
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = HeaderBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.Size = UDim2.new(0, 200, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.TextSize = 20.000
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    SubtitleLabel.Name = "SubtitleLabel"
    SubtitleLabel.Parent = HeaderBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 15, 0, 27)
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 20)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = subtitle
    SubtitleLabel.TextColor3 = theme.TextDark
    SubtitleLabel.TextSize = 14.000
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = HeaderBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 10)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Image = "rbxassetid://6031094678"
    CloseButton.ImageColor3 = theme.TextDark
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(
            CloseButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {ImageColor3 = theme.Error}
        ):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(
            CloseButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {ImageColor3 = theme.TextDark}
        ):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(
            MainUI,
            TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Size = UDim2.new(0, 0, 0, 0)}
        ):Play()
        
        if blur then
            TweenService:Create(
                game.Lighting:FindFirstChild("WhatUIBlur"),
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = 0}
            ):Play()
        end
        
        wait(0.6)
        WhatUI:Destroy()
    end)
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    local TabContainer = Instance.new("Frame")
    local TabScrollingFrame = Instance.new("ScrollingFrame")
    local TabList = Instance.new("UIListLayout")
    local TabPadding = Instance.new("UIPadding")
    local PageFolder = Instance.new("Folder")
    local PageUIPageLayout = Instance.new("UIPageLayout")
    
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainUI
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 150, 0, 50) -- Start 150 pixels from the left to avoid TabContainer
    ContentArea.Size = UDim2.new(1, -150, 1, -50) -- Reduce width by 150 pixels to account for TabContainer
    
    -- Create a completely separate floating tab container
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = WhatUI -- Parent directly to WhatUI instead of ContentArea
    TabContainer.BackgroundColor3 = theme.Secondary
    TabContainer.BackgroundTransparency = 0.1
    TabContainer.Size = UDim2.new(0, 150, 0, 400) -- Fixed size
    TabContainer.Position = UDim2.new(0, -150, 0.5, -200) -- Position off-screen initially
    TabContainer.AnchorPoint = Vector2.new(0, 0.5) -- Anchor to middle left
    
    -- Make tab container float to the side of main UI
    TweenService:Create(
        TabContainer,
        TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.2), -- Delayed animation
        {Position = UDim2.new(0, -30, 0.5, -200)} -- Show 30 pixels in from left edge
    ):Play()
    
    -- Create Shadow for TabContainer
    local TabContainerShadow = Objects.new("Shadow")
    TabContainerShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    TabContainerShadow.ImageTransparency = 0.4
    TabContainerShadow.Parent = TabContainer
    
    -- Create a UICorner for TabContainer
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 10)
    TabContainerCorner.Parent = TabContainer
    
    -- Create a hover detector for tab container
    local TabHoverDetector = Instance.new("TextButton")
    TabHoverDetector.Name = "TabHoverDetector"
    TabHoverDetector.Parent = TabContainer
    TabHoverDetector.BackgroundTransparency = 1
    TabHoverDetector.Text = ""
    TabHoverDetector.Size = UDim2.fromScale(1, 1)
    
    -- Add hover effect to expand tab container on hover
    TabHoverDetector.MouseEnter:Connect(function()
        TweenService:Create(
            TabContainer,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, 0, 0.5, -200)} -- Show fully on hover
        ):Play()
    end)
    
    -- Return to partially hidden state when not hovering
    TabHoverDetector.MouseLeave:Connect(function()
        TweenService:Create(
            TabContainer,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, -30, 0.5, -200)} -- Show partial on leave
        ):Play()
    end)
    
    TabScrollingFrame.Name = "TabScrollingFrame"
    TabScrollingFrame.Parent = TabContainer
    TabScrollingFrame.Active = true
    TabScrollingFrame.BackgroundTransparency = 1
    TabScrollingFrame.BorderSizePixel = 0
    TabScrollingFrame.Position = UDim2.new(0, 0, 0, 5)
    TabScrollingFrame.Size = UDim2.new(1, 0, 1, -10)
    TabScrollingFrame.ScrollBarThickness = 4
    TabScrollingFrame.ScrollBarImageColor3 = theme.Accent
    TabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    TabList.Name = "TabList"
    TabList.Parent = TabScrollingFrame
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    
    TabPadding.Name = "TabPadding"
    TabPadding.Parent = TabScrollingFrame
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 10)
    
    PageFolder.Name = "PageFolder"
    PageFolder.Parent = ContentArea
    
    PageUIPageLayout.Name = "PageUIPageLayout"
    PageUIPageLayout.Parent = PageFolder
    PageUIPageLayout.FillDirection = Enum.FillDirection.Vertical
    PageUIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageUIPageLayout.EasingDirection = Enum.EasingDirection.Out
    PageUIPageLayout.EasingStyle = Enum.EasingStyle.Quint
    PageUIPageLayout.TweenTime = 0.3
    PageUIPageLayout.Padding = UDim.new(0, 10)
    
    -- Close UI with right control key
    local uihide = false
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            if uihide == false then
                uihide = true
                TweenService:Create(
                    MainUI,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                    {Size = UDim2.new(0, 0, 0, 0)}
                ):Play()
                
                if blur then
                    TweenService:Create(
                        game.Lighting:FindFirstChild("WhatUIBlur"),
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Size = 0}
                    ):Play()
                end
            else
                uihide = false
                TweenService:Create(
                    MainUI,
                    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 650, 0, 500)}
                ):Play()
                
                if blur then
                    TweenService:Create(
                        game.Lighting:FindFirstChild("WhatUIBlur"),
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Size = 15}
                    ):Play()
                end
            end
        end
    end)
    
    -- Make UI draggable
    local dragging, dragInput, dragStart, startPosition
    
    HeaderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = MainUI.Position
        end
    end)
    
    HeaderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainUI.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab System
    local TabsSystem = {}
    
    function TabsSystem:Tab(options)
        options = options or {}
        local tabTitle = options.title or "Tab"
        local tabIcon = options.icon or "rbxassetid://8666601749"
        
        -- Tab Button
        local TabButton = Instance.new("Frame")
        local TabUICorner = Instance.new("UICorner")
        local TabIcon = Instance.new("ImageLabel")
        local TabText = Instance.new("TextLabel")
        local TabBtn = Instance.new("TextButton")
        local TabSelection = Instance.new("Frame")
        local TabSelectionUICorner = Instance.new("UICorner")
        
        TabButton.Name = tabTitle.."Tab"
        TabButton.Parent = TabScrollingFrame
        TabButton.BackgroundColor3 = theme.Primary
        TabButton.Size = UDim2.new(1, -20, 0, 40)
        
        TabUICorner.CornerRadius = UDim.new(0, 8)
        TabUICorner.Parent = TabButton
        
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 5, 0, 5)
        TabIcon.Size = UDim2.new(0, 30, 0, 30)
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = theme.TextDark
        
        TabText.Name = "TabText"
        TabText.Parent = TabButton
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 40, 0, 0)
        TabText.Size = UDim2.new(1, -40, 1, 0)
        TabText.Font = Enum.Font.GothamSemibold
        TabText.Text = tabTitle
        TabText.TextColor3 = theme.TextDark
        TabText.TextSize = 14.000
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        
        TabBtn.Name = "TabBtn"
        TabBtn.Parent = TabButton
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 1, 0)
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.Text = ""
        TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabBtn.TextSize = 14.000
        
        TabSelection.Name = "TabSelection"
        TabSelection.Parent = TabButton
        TabSelection.BackgroundColor3 = theme.Accent
        TabSelection.Position = UDim2.new(0, 0, 0.5, 0)
        TabSelection.Size = UDim2.new(0, 0, 0, 0)
        TabSelection.AnchorPoint = Vector2.new(0, 0.5)
        
        TabSelectionUICorner.CornerRadius = UDim.new(1, 0)
        TabSelectionUICorner.Parent = TabSelection
        
        -- Tab Page
        local TabPage = Instance.new("ScrollingFrame")
        local TabPageList = Instance.new("UIListLayout")
        local TabPagePadding = Instance.new("UIPadding")
        
        TabPage.Name = tabTitle.."Page"
        TabPage.Parent = PageFolder
        TabPage.Active = true
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.Position = UDim2.new(0, 0, 0, 0) -- Start from left edge of ContentArea
        TabPage.Size = UDim2.new(1, 0, 1, 0) -- Take full ContentArea
        TabPage.ClipsDescendants = true -- Ensure content doesn't overflow
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = theme.Accent
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        TabPageList.Name = "TabPageList"
        TabPageList.Parent = TabPage
        TabPageList.SortOrder = Enum.SortOrder.LayoutOrder
        TabPageList.Padding = UDim.new(0, 10)
        
        TabPagePadding.Name = "TabPagePadding"
        TabPagePadding.Parent = TabPage
        TabPagePadding.PaddingLeft = UDim.new(0, 20) -- Add padding to keep elements inside
        TabPagePadding.PaddingTop = UDim.new(0, 20)
        TabPagePadding.PaddingRight = UDim.new(0, 20)
        TabPagePadding.PaddingBottom = UDim.new(0, 20)
        
        -- Tab Button Selection Logic
        local selected = false
        TabBtn.MouseButton1Click:Connect(function()
            -- Deselect all tabs
            for _, tab in pairs(TabScrollingFrame:GetChildren()) do
                if tab:IsA("Frame") and tab:FindFirstChild("TabSelection") and tab ~= TabButton then
                    TweenService:Create(
                        tab.TabSelection,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, 0, 0, 0)}
                    ):Play()
                    
                    TweenService:Create(
                        tab.TabIcon,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {ImageColor3 = theme.TextDark}
                    ):Play()
                    
                    TweenService:Create(
                        tab.TabText,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextColor3 = theme.TextDark}
                    ):Play()
                end
            end
            
            -- Select current tab
            TweenService:Create(
                TabSelection,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 4, 0.8, 0)}
            ):Play()
            
            TweenService:Create(
                TabIcon,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {ImageColor3 = theme.Accent}
            ):Play()
            
            TweenService:Create(
                TabText,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {TextColor3 = theme.Accent}
            ):Play()
            
            -- Change page
            PageUIPageLayout:JumpTo(TabPage)
        end)
        
        -- Mouse hover effects
        TabBtn.MouseEnter:Connect(function()
            if not selected then
                TweenService:Create(
                    TabButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = theme.Secondary}
                ):Play()
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if not selected then
                TweenService:Create(
                    TabButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = theme.Primary}
                ):Play()
            end
        end)
        
        -- Auto-update canvas size
        RunService.RenderStepped:Connect(function()
            TabScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 20)
            TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPageList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Select first tab by default
        if #TabScrollingFrame:GetChildren() == 3 then -- UIListLayout, UIPadding, and this tab
            TweenService:Create(
                TabSelection,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 4, 0.8, 0)}
            ):Play()
            
            TweenService:Create(
                TabIcon,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {ImageColor3 = theme.Accent}
            ):Play()
            
            TweenService:Create(
                TabText,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {TextColor3 = theme.Accent}
            ):Play()
            
            selected = true
            wait()
            PageUIPageLayout:JumpToIndex(0)
        end
        
        -- Tab Content System
        local TabElements = {}

        function TabElements:Button(options)
            options = options or {}
            local buttonTitle = options.title or "Button"
            local buttonDescription = options.description or "Button description"
            local buttonIcon = options.icon or "rbxassetid://8666601749"
            local callback = options.callback or function() end
            
            -- Button UI
            local ButtonFrame = Instance.new("Frame")
            local ButtonUICorner = Instance.new("UICorner")
            local ButtonTitle = Instance.new("TextLabel")
            local ButtonDescription = Instance.new("TextLabel")
            local ButtonIcon = Instance.new("ImageLabel")
            local ButtonActivation = Instance.new("Frame")
            local ButtonActivationUICorner = Instance.new("UICorner")
            local ButtonActivationIcon = Instance.new("ImageLabel")
            local ButtonActivationText = Instance.new("TextLabel")
            local ButtonClickRegion = Instance.new("TextButton")
            
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Parent = TabPage
            ButtonFrame.BackgroundColor3 = theme.Secondary
            ButtonFrame.Size = UDim2.new(1, 0, 0, 100)
            
            ButtonUICorner.CornerRadius = UDim.new(0, 8)
            ButtonUICorner.Parent = ButtonFrame
            
            ButtonTitle.Name = "ButtonTitle"
            ButtonTitle.Parent = ButtonFrame
            ButtonTitle.BackgroundTransparency = 1
            ButtonTitle.Position = UDim2.new(0, 15, 0, 10)
            ButtonTitle.Size = UDim2.new(0.5, 0, 0, 25)
            ButtonTitle.Font = Enum.Font.GothamBold
            ButtonTitle.Text = buttonTitle
            ButtonTitle.TextColor3 = theme.Text
            ButtonTitle.TextSize = 18.000
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            ButtonDescription.Name = "ButtonDescription"
            ButtonDescription.Parent = ButtonFrame
            ButtonDescription.BackgroundTransparency = 1
            ButtonDescription.Position = UDim2.new(0, 15, 0, 35)
            ButtonDescription.Size = UDim2.new(0.5, 0, 0, 40)
            ButtonDescription.Font = Enum.Font.Gotham
            ButtonDescription.Text = buttonDescription
            ButtonDescription.TextColor3 = theme.TextDark
            ButtonDescription.TextSize = 14.000
            ButtonDescription.TextWrapped = true
            ButtonDescription.TextXAlignment = Enum.TextXAlignment.Left
            ButtonDescription.TextYAlignment = Enum.TextYAlignment.Top
            
            ButtonIcon.Name = "ButtonIcon"
            ButtonIcon.Parent = ButtonFrame
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Position = UDim2.new(0.75, 0, 0, 10)
            ButtonIcon.Size = UDim2.new(0, 80, 0, 80)
            ButtonIcon.Image = buttonIcon
            ButtonIcon.ImageTransparency = 0.5
            
            ButtonActivation.Name = "ButtonActivation"
            ButtonActivation.Parent = ButtonFrame
            ButtonActivation.BackgroundColor3 = theme.Primary
            ButtonActivation.Position = UDim2.new(0, 15, 0, 70)
            ButtonActivation.Size = UDim2.new(0.5, -20, 0, 20)
            
            ButtonActivationUICorner.CornerRadius = UDim.new(0, 6)
            ButtonActivationUICorner.Parent = ButtonActivation
            
            ButtonActivationIcon.Name = "ButtonActivationIcon"
            ButtonActivationIcon.Parent = ButtonActivation
            ButtonActivationIcon.BackgroundTransparency = 1
            ButtonActivationIcon.Position = UDim2.new(0, 5, 0, 0)
            ButtonActivationIcon.Size = UDim2.new(0, 20, 0, 20)
            ButtonActivationIcon.Image = "rbxassetid://9034159958" -- Click icon
            ButtonActivationIcon.ImageColor3 = theme.TextDark
            
            ButtonActivationText.Name = "ButtonActivationText"
            ButtonActivationText.Parent = ButtonActivation
            ButtonActivationText.BackgroundTransparency = 1
            ButtonActivationText.Position = UDim2.new(0, 25, 0, 0)
            ButtonActivationText.Size = UDim2.new(1, -25, 1, 0)
            ButtonActivationText.Font = Enum.Font.GothamSemibold
            ButtonActivationText.Text = "Click to activate"
            ButtonActivationText.TextColor3 = theme.TextDark
            ButtonActivationText.TextSize = 12.000
            ButtonActivationText.TextTransparency = 0.2
            
            ButtonClickRegion.Name = "ButtonClickRegion"
            ButtonClickRegion.Parent = ButtonFrame
            ButtonClickRegion.BackgroundTransparency = 1
            ButtonClickRegion.Size = UDim2.new(1, 0, 1, 0)
            ButtonClickRegion.Font = Enum.Font.SourceSans
            ButtonClickRegion.Text = ""
            ButtonClickRegion.TextColor3 = Color3.fromRGB(0, 0, 0)
            ButtonClickRegion.TextSize = 14.000
            ButtonClickRegion.ClipsDescendants = true
            
            -- Button hover effect
            ButtonClickRegion.MouseEnter:Connect(function()
                TweenService:Create(
                    ButtonFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(
                        math.min(theme.Secondary.R * 255 + 15, 255),
                        math.min(theme.Secondary.G * 255 + 15, 255),
                        math.min(theme.Secondary.B * 255 + 15, 255)
                    )}
                ):Play()
                
                TweenService:Create(
                    ButtonActivationText,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextTransparency = 0}
                ):Play()
            end)
            
            ButtonClickRegion.MouseLeave:Connect(function()
                TweenService:Create(
                    ButtonFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = theme.Secondary}
                ):Play()
                
                TweenService:Create(
                    ButtonActivationText,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextTransparency = 0.2}
                ):Play()
            end)
            
            -- Ripple effect on click
            ButtonClickRegion.MouseButton1Down:Connect(function()
                -- Create ripple
                local ripple = Instance.new("Frame")
                local rippleUICorner = Instance.new("UICorner")
                
                local mouse = game.Players.LocalPlayer:GetMouse()
                local px, py = mouse.X - ButtonClickRegion.AbsolutePosition.X, mouse.Y - ButtonClickRegion.AbsolutePosition.Y
                
                ripple.Name = "Ripple"
                ripple.Parent = ButtonClickRegion
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.8
                ripple.Position = UDim2.new(0, px, 0, py)
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.ZIndex = 5
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                
                rippleUICorner.CornerRadius = UDim.new(1, 0)
                rippleUICorner.Parent = ripple
                
                local maxSize = math.max(ButtonClickRegion.AbsoluteSize.X, ButtonClickRegion.AbsoluteSize.Y)
                
                TweenService:Create(
                    ripple,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, maxSize * 2, 0, maxSize * 2), BackgroundTransparency = 1}
                ):Play()
                
                TweenService:Create(
                    ButtonActivation,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = theme.Accent}
                ):Play()
                
                TweenService:Create(
                    ButtonActivationText,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = theme.Text}
                ):Play()
                
                TweenService:Create(
                    ButtonActivationIcon,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {ImageColor3 = theme.Text}
                ):Play()
                
                -- Remove ripple after animation
                spawn(function()
                    wait(0.5)
                    ripple:Destroy()
                end)
                
                -- Call the callback
                callback()
            end)
            
            ButtonClickRegion.MouseButton1Up:Connect(function()
                TweenService:Create(
                    ButtonActivation,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = theme.Primary}
                ):Play()
                
                TweenService:Create(
                    ButtonActivationText,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = theme.TextDark}
                ):Play()
                
                TweenService:Create(
                    ButtonActivationIcon,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {ImageColor3 = theme.TextDark}
                ):Play()
            end)
            
            local ButtonFunctions = {}
            
            function ButtonFunctions:SetTitle(title)
                ButtonTitle.Text = title
            end
            
            function ButtonFunctions:SetDescription(description)
                ButtonDescription.Text = description
            end
            
            function ButtonFunctions:SetCallback(newCallback)
                callback = newCallback
            end
            
            return ButtonFunctions
        end
        
        function TabElements:Toggle(options)
            options = options or {}
            local toggleTitle = options.title or "Toggle"
            local toggleDescription = options.description or "Toggle description"
            local toggleIcon = options.icon or "rbxassetid://8666601749"
            local default = options.default or false
            local callback = options.callback or function() end
            
            -- Toggle UI
            local ToggleFrame = Instance.new("Frame")
            local ToggleUICorner = Instance.new("UICorner")
            local ToggleTitle = Instance.new("TextLabel")
            local ToggleDescription = Instance.new("TextLabel")
            local ToggleIcon = Instance.new("ImageLabel")
            local ToggleSwitch = Instance.new("Frame")
            local ToggleSwitchUICorner = Instance.new("UICorner")
            local ToggleIndicator = Instance.new("Frame")
            local ToggleIndicatorUICorner = Instance.new("UICorner")
            local ToggleClickRegion = Instance.new("TextButton")
            local ToggleStatus = Instance.new("TextLabel")
            
            -- Set initial toggle state
            local toggled = default
            
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = theme.Secondary
            ToggleFrame.Size = UDim2.new(1, 0, 0, 100)
            
            ToggleUICorner.CornerRadius = UDim.new(0, 8)
            ToggleUICorner.Parent = ToggleFrame
            
            ToggleTitle.Name = "ToggleTitle"
            ToggleTitle.Parent = ToggleFrame
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 15, 0, 10)
            ToggleTitle.Size = UDim2.new(0.5, 0, 0, 25)
            ToggleTitle.Font = Enum.Font.GothamBold
            ToggleTitle.Text = toggleTitle
            ToggleTitle.TextColor3 = theme.Text
            ToggleTitle.TextSize = 18.000
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleDescription.Name = "ToggleDescription"
            ToggleDescription.Parent = ToggleFrame
            ToggleDescription.BackgroundTransparency = 1
            ToggleDescription.Position = UDim2.new(0, 15, 0, 35)
            ToggleDescription.Size = UDim2.new(0.5, 0, 0, 40)
            ToggleDescription.Font = Enum.Font.Gotham
            ToggleDescription.Text = toggleDescription
            ToggleDescription.TextColor3 = theme.TextDark
            ToggleDescription.TextSize = 14.000
            ToggleDescription.TextWrapped = true
            ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
            ToggleDescription.TextYAlignment = Enum.TextYAlignment.Top
            
            ToggleIcon.Name = "ToggleIcon"
            ToggleIcon.Parent = ToggleFrame
            ToggleIcon.BackgroundTransparency = 1
            ToggleIcon.Position = UDim2.new(0.75, 0, 0, 10)
            ToggleIcon.Size = UDim2.new(0, 80, 0, 80)
            ToggleIcon.Image = toggleIcon
            ToggleIcon.ImageTransparency = 0.5
            
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.Parent = ToggleFrame
            ToggleSwitch.BackgroundColor3 = toggled and theme.Accent or theme.Primary
            ToggleSwitch.Position = UDim2.new(0, 15, 0, 70)
            ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
            
            ToggleSwitchUICorner.CornerRadius = UDim.new(1, 0)
            ToggleSwitchUICorner.Parent = ToggleSwitch
            
            ToggleIndicator.Name = "ToggleIndicator"
            ToggleIndicator.Parent = ToggleSwitch
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.Position = toggled and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            
            ToggleIndicatorUICorner.CornerRadius = UDim.new(1, 0)
            ToggleIndicatorUICorner.Parent = ToggleIndicator
            
            ToggleStatus.Name = "ToggleStatus"
            ToggleStatus.Parent = ToggleFrame
            ToggleStatus.BackgroundTransparency = 1
            ToggleStatus.Position = UDim2.new(0, 65, 0, 70)
            ToggleStatus.Size = UDim2.new(0, 100, 0, 20)
            ToggleStatus.Font = Enum.Font.GothamSemibold
            ToggleStatus.Text = toggled and "Enabled" or "Disabled"
            ToggleStatus.TextColor3 = toggled and theme.Success or theme.Error
            ToggleStatus.TextSize = 14.000
            ToggleStatus.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleClickRegion.Name = "ToggleClickRegion"
            ToggleClickRegion.Parent = ToggleFrame
            ToggleClickRegion.BackgroundTransparency = 1
            ToggleClickRegion.Size = UDim2.new(1, 0, 1, 0)
            ToggleClickRegion.Font = Enum.Font.SourceSans
            ToggleClickRegion.Text = ""
            ToggleClickRegion.TextColor3 = Color3.fromRGB(0, 0, 0)
            ToggleClickRegion.TextSize = 14.000
            ToggleClickRegion.ClipsDescendants = true
            
            -- Initialize toggle if default is true
            if default then
                callback(true)
            end
            
            -- Toggle hover effect
            ToggleClickRegion.MouseEnter:Connect(function()
                TweenService:Create(
                    ToggleFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(
                        math.min(theme.Secondary.R * 255 + 15, 255),
                        math.min(theme.Secondary.G * 255 + 15, 255),
                        math.min(theme.Secondary.B * 255 + 15, 255)
                    )}
                ):Play()
            end)
            
            ToggleClickRegion.MouseLeave:Connect(function()
                TweenService:Create(
                    ToggleFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = theme.Secondary}
                ):Play()
            end)
            
            -- Toggle click behavior
            ToggleClickRegion.MouseButton1Down:Connect(function()
                -- Create ripple
                local ripple = Instance.new("Frame")
                local rippleUICorner = Instance.new("UICorner")
                
                local mouse = game.Players.LocalPlayer:GetMouse()
                local px, py = mouse.X - ToggleClickRegion.AbsolutePosition.X, mouse.Y - ToggleClickRegion.AbsolutePosition.Y
                
                ripple.Name = "Ripple"
                ripple.Parent = ToggleClickRegion
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.8
                ripple.Position = UDim2.new(0, px, 0, py)
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.ZIndex = 5
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                
                rippleUICorner.CornerRadius = UDim.new(1, 0)
                rippleUICorner.Parent = ripple
                
                local maxSize = math.max(ToggleClickRegion.AbsoluteSize.X, ToggleClickRegion.AbsoluteSize.Y)
                
                TweenService:Create(
                    ripple,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, maxSize * 2, 0, maxSize * 2), BackgroundTransparency = 1}
                ):Play()
                
                -- Toggle the switch
                toggled = not toggled
                
                -- Animate the toggle
                TweenService:Create(
                    ToggleSwitch,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = toggled and theme.Accent or theme.Primary}
                ):Play()
                
                TweenService:Create(
                    ToggleIndicator,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = toggled and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)}
                ):Play()
                
                TweenService:Create(
                    ToggleStatus,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = toggled and theme.Success or theme.Error}
                ):Play()
                
                ToggleStatus.Text = toggled and "Enabled" or "Disabled"
                
                -- Remove ripple after animation
                spawn(function()
                    wait(0.5)
                    ripple:Destroy()
                end)
                
                -- Call the callback
                callback(toggled)
            end)
            
            local ToggleFunctions = {}
            
            function ToggleFunctions:SetState(state)
                toggled = state
                TweenService:Create(
                    ToggleSwitch,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = toggled and theme.Accent or theme.Primary}
                ):Play()
                
                TweenService:Create(
                    ToggleIndicator,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = toggled and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)}
                ):Play()
                
                TweenService:Create(
                    ToggleStatus,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = toggled and theme.Success or theme.Error}
                ):Play()
                
                ToggleStatus.Text = toggled and "Enabled" or "Disabled"
                callback(toggled)
            end
            
            function ToggleFunctions:GetState()
                return toggled
            end
            
            function ToggleFunctions:Lock()
                ToggleClickRegion.Active = false
                TweenService:Create(
                    ToggleFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 0.5}
                ):Play()
                
                -- Create lock icon
                local lockIcon = Instance.new("ImageLabel")
                lockIcon.Name = "LockIcon"
                lockIcon.Parent = ToggleFrame
                lockIcon.BackgroundTransparency = 1
                lockIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                lockIcon.Size = UDim2.new(0, 30, 0, 30)
                lockIcon.Image = "rbxassetid://3926305904"
                lockIcon.ImageRectOffset = Vector2.new(4, 684)
                lockIcon.ImageRectSize = Vector2.new(36, 36)
                lockIcon.ImageColor3 = Color3.fromRGB(255, 75, 75)
                lockIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            end
            
            function ToggleFunctions:Unlock()
                ToggleClickRegion.Active = true
                TweenService:Create(
                    ToggleFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 0}
                ):Play()
                
                -- Remove lock icon if it exists
                local lockIcon = ToggleFrame:FindFirstChild("LockIcon")
                if lockIcon then
                    lockIcon:Destroy()
                end
            end
            
            return ToggleFunctions
        end
        
        function TabElements:Slider(options)
            options = options or {}
            local sliderTitle = options.title or "Slider"
            local sliderDescription = options.description or "Slider description"
            local min = options.min or 0
            local max = options.max or 100
            local default = options.default or min
            local precise = options.precise or false
            local callback = options.callback or function() end
            
            -- Slider UI
            local SliderFrame = Instance.new("Frame")
            local SliderUICorner = Instance.new("UICorner")
            local SliderTitle = Instance.new("TextLabel")
            local SliderDescription = Instance.new("TextLabel")
            local SliderValue = Instance.new("TextBox")
            local SliderValueUICorner = Instance.new("UICorner")
            local SliderBar = Instance.new("Frame")
            local SliderBarUICorner = Instance.new("UICorner")
            local SliderFill = Instance.new("Frame")
            local SliderFillUICorner = Instance.new("UICorner")
            local SliderDrag = Instance.new("Frame")
            local SliderDragUICorner = Instance.new("UICorner")
            
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Parent = TabPage
            SliderFrame.BackgroundColor3 = theme.Secondary
            SliderFrame.Size = UDim2.new(1, 0, 0, 120)
            
            SliderUICorner.CornerRadius = UDim.new(0, 8)
            SliderUICorner.Parent = SliderFrame
            
            SliderTitle.Name = "SliderTitle"
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 15, 0, 10)
            SliderTitle.Size = UDim2.new(0.5, 0, 0, 25)
            SliderTitle.Font = Enum.Font.GothamBold
            SliderTitle.Text = sliderTitle
            SliderTitle.TextColor3 = theme.Text
            SliderTitle.TextSize = 18.000
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            SliderDescription.Name = "SliderDescription"
            SliderDescription.Parent = SliderFrame
            SliderDescription.BackgroundTransparency = 1
            SliderDescription.Position = UDim2.new(0, 15, 0, 35)
            SliderDescription.Size = UDim2.new(0.6, 0, 0, 40)
            SliderDescription.Font = Enum.Font.Gotham
            SliderDescription.Text = sliderDescription
            SliderDescription.TextColor3 = theme.TextDark
            SliderDescription.TextSize = 14.000
            SliderDescription.TextWrapped = true
            SliderDescription.TextXAlignment = Enum.TextXAlignment.Left
            SliderDescription.TextYAlignment = Enum.TextYAlignment.Top
            
            SliderValue.Name = "SliderValue"
            SliderValue.Parent = SliderFrame
            SliderValue.BackgroundColor3 = theme.Primary
            SliderValue.Position = UDim2.new(0.75, 0, 0, 20)
            SliderValue.Size = UDim2.new(0.2, 0, 0, 30)
            SliderValue.Font = Enum.Font.GothamSemibold
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = theme.Text
            SliderValue.TextSize = 14.000
            
            SliderValueUICorner.CornerRadius = UDim.new(0, 6)
            SliderValueUICorner.Parent = SliderValue
            
            SliderBar.Name = "SliderBar"
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = theme.Primary
            SliderBar.Position = UDim2.new(0, 15, 0, 85)
            SliderBar.Size = UDim2.new(1, -30, 0, 10)
            
            SliderBarUICorner.CornerRadius = UDim.new(1, 0)
            SliderBarUICorner.Parent = SliderBar
            
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = theme.Accent
            -- Calculate initial position based on default value
            local initialScale = (default - min) / (max - min)
            SliderFill.Size = UDim2.new(initialScale, 0, 1, 0)
            
            SliderFillUICorner.CornerRadius = UDim.new(1, 0)
            SliderFillUICorner.Parent = SliderFill
            
            SliderDrag.Name = "SliderDrag"
            SliderDrag.Parent = SliderFill
            SliderDrag.AnchorPoint = Vector2.new(1, 0.5)
            SliderDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderDrag.Position = UDim2.new(1, 0, 0.5, 0)
            SliderDrag.Size = UDim2.new(0, 16, 0, 16)
            
            SliderDragUICorner.CornerRadius = UDim.new(1, 0)
            SliderDragUICorner.Parent = SliderDrag
            
            -- Initialize with default value
            if default ~= min then
                callback(default)
            end
            
            -- Slider dragging functionality
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            SliderDrag.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    updateSlider(input)
                end
            end)
            
            -- Value changed through TextBox
            SliderValue.FocusLost:Connect(function()
                local inputValue = tonumber(SliderValue.Text)
                if inputValue then
                    -- Clamp the value
                    inputValue = math.clamp(inputValue, min, max)
                    
                    -- Update the slider
                    local scale = (inputValue - min) / (max - min)
                    SliderFill.Size = UDim2.new(scale, 0, 1, 0)
                    
                    -- Format and update the value display
                    if precise then
                        SliderValue.Text = tostring(inputValue)
                    else
                        SliderValue.Text = tostring(math.floor(inputValue))
                    end
                    
                    -- Call the callback
                    callback(inputValue)
                else
                    -- Revert to previous value
                    local currentScale = SliderFill.Size.X.Scale
                    local currentValue = min + (max - min) * currentScale
                    
                    if precise then
                        SliderValue.Text = tostring(currentValue)
                    else
                        SliderValue.Text = tostring(math.floor(currentValue))
                    end
                end
            end)
            
            -- Function to update slider position and value
            function updateSlider(input)
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local sliderPos = SliderBar.AbsolutePosition
                local sliderSize = SliderBar.AbsoluteSize
                
                local relX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
                local scale = relX / sliderSize.X
                
                SliderFill:TweenSize(
                    UDim2.new(scale, 0, 1, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.1,
                    true
                )
                
                local value = min + (max - min) * scale
                
                if precise then
                    SliderValue.Text = tostring(value)
                else
                    SliderValue.Text = tostring(math.floor(value))
                end
                
                callback(value)
            end
            
            local SliderFunctions = {}
            
            function SliderFunctions:SetValue(value)
                value = math.clamp(value, min, max)
                local scale = (value - min) / (max - min)
                
                SliderFill:TweenSize(
                    UDim2.new(scale, 0, 1, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quad,
                    0.1,
                    true
                )
                
                if precise then
                    SliderValue.Text = tostring(value)
                else
                    SliderValue.Text = tostring(math.floor(value))
                end
                
                callback(value)
            end
            
            function SliderFunctions:GetValue()
                return tonumber(SliderValue.Text)
            end
            
            return SliderFunctions
        end
        
        function TabElements:Dropdown(options)
            options = options or {}
            local dropdownTitle = options.title or "Dropdown"
            local dropdownDescription = options.description or "Dropdown description"
            local items = options.items or {}
            local default = options.default or nil
            local callback = options.callback or function() end
            
            -- Dropdown UI
            local DropdownFrame = Instance.new("Frame")
            local DropdownUICorner = Instance.new("UICorner")
            local DropdownTitle = Instance.new("TextLabel")
            local DropdownDescription = Instance.new("TextLabel")
            local DropdownButton = Instance.new("Frame")
            local DropdownButtonUICorner = Instance.new("UICorner")
            local DropdownSelectedText = Instance.new("TextLabel")
            local DropdownIcon = Instance.new("ImageLabel")
            local DropdownClickRegion = Instance.new("TextButton")
            
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.Parent = TabPage
            DropdownFrame.BackgroundColor3 = theme.Secondary
            DropdownFrame.Size = UDim2.new(1, 0, 0, 100)
            DropdownFrame.ClipsDescendants = true
            
            DropdownUICorner.CornerRadius = UDim.new(0, 8)
            DropdownUICorner.Parent = DropdownFrame
            
            DropdownTitle.Name = "DropdownTitle"
            DropdownTitle.Parent = DropdownFrame
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Position = UDim2.new(0, 15, 0, 10)
            DropdownTitle.Size = UDim2.new(0.5, 0, 0, 25)
            DropdownTitle.Font = Enum.Font.GothamBold
            DropdownTitle.Text = dropdownTitle
            DropdownTitle.TextColor3 = theme.Text
            DropdownTitle.TextSize = 18.000
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            DropdownDescription.Name = "DropdownDescription"
            DropdownDescription.Parent = DropdownFrame
            DropdownDescription.BackgroundTransparency = 1
            DropdownDescription.Position = UDim2.new(0, 15, 0, 35)
            DropdownDescription.Size = UDim2.new(0.6, 0, 0, 40)
            DropdownDescription.Font = Enum.Font.Gotham
            DropdownDescription.Text = dropdownDescription
            DropdownDescription.TextColor3 = theme.TextDark
            DropdownDescription.TextSize = 14.000
            DropdownDescription.TextWrapped = true
            DropdownDescription.TextXAlignment = Enum.TextXAlignment.Left
            DropdownDescription.TextYAlignment = Enum.TextYAlignment.Top
            
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundColor3 = theme.Primary
            DropdownButton.Position = UDim2.new(0, 15, 0, 70)
            DropdownButton.Size = UDim2.new(1, -30, 0, 20)
            
            DropdownButtonUICorner.CornerRadius = UDim.new(0, 6)
            DropdownButtonUICorner.Parent = DropdownButton
            
            DropdownSelectedText.Name = "DropdownSelectedText"
            DropdownSelectedText.Parent = DropdownButton
            DropdownSelectedText.BackgroundTransparency = 1
            DropdownSelectedText.Position = UDim2.new(0, 10, 0, 0)
            DropdownSelectedText.Size = UDim2.new(1, -30, 1, 0)
            DropdownSelectedText.Font = Enum.Font.GothamSemibold
            DropdownSelectedText.Text = default or "Select an option..."
            DropdownSelectedText.TextColor3 = theme.Text
            DropdownSelectedText.TextSize = 14.000
            DropdownSelectedText.TextXAlignment = Enum.TextXAlignment.Left
            
            DropdownIcon.Name = "DropdownIcon"
            DropdownIcon.Parent = DropdownButton
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Position = UDim2.new(1, -20, 0, 2)
            DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
            DropdownIcon.Image = "rbxassetid://6031094670"
            DropdownIcon.ImageColor3 = theme.TextDark
            DropdownIcon.Rotation = 0
            
            DropdownClickRegion.Name = "DropdownClickRegion"
            DropdownClickRegion.Parent = DropdownFrame
            DropdownClickRegion.BackgroundTransparency = 1
            DropdownClickRegion.Size = UDim2.new(1, 0, 0, 100)
            DropdownClickRegion.Font = Enum.Font.SourceSans
            DropdownClickRegion.Text = ""
            DropdownClickRegion.TextColor3 = Color3.fromRGB(0, 0, 0)
            DropdownClickRegion.TextSize = 14.000
            
            -- Dropdown Items Container
            local DropdownItemsContainer = Instance.new("Frame")
            local DropdownItemsUICorner = Instance.new("UICorner")
            local DropdownItemsList = Instance.new("ScrollingFrame")
            local DropdownItemsListLayout = Instance.new("UIListLayout")
            local DropdownItemsPadding = Instance.new("UIPadding")
            
            DropdownItemsContainer.Name = "DropdownItemsContainer"
            DropdownItemsContainer.Parent = DropdownFrame
            DropdownItemsContainer.BackgroundColor3 = theme.Primary
            DropdownItemsContainer.Position = UDim2.new(0, 15, 0, 100)
            DropdownItemsContainer.Size = UDim2.new(1, -30, 0, 0)
            DropdownItemsContainer.Visible = false
            DropdownItemsContainer.ZIndex = 2
            
            DropdownItemsUICorner.CornerRadius = UDim.new(0, 6)
            DropdownItemsUICorner.Parent = DropdownItemsContainer
            
            DropdownItemsList.Name = "DropdownItemsList"
            DropdownItemsList.Parent = DropdownItemsContainer
            DropdownItemsList.Active = true
            DropdownItemsList.BackgroundTransparency = 1
            DropdownItemsList.BorderSizePixel = 0
            DropdownItemsList.Size = UDim2.new(1, 0, 1, 0)
            DropdownItemsList.ScrollBarThickness = 4
            DropdownItemsList.ScrollBarImageColor3 = theme.Accent
            DropdownItemsList.ZIndex = 3
            
            DropdownItemsListLayout.Name = "DropdownItemsListLayout"
            DropdownItemsListLayout.Parent = DropdownItemsList
            DropdownItemsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownItemsListLayout.Padding = UDim.new(0, 5)
            
            DropdownItemsPadding.Name = "DropdownItemsPadding"
            DropdownItemsPadding.Parent = DropdownItemsList
            DropdownItemsPadding.PaddingLeft = UDim.new(0, 5)
            DropdownItemsPadding.PaddingTop = UDim.new(0, 5)
            DropdownItemsPadding.PaddingRight = UDim.new(0, 5)
            DropdownItemsPadding.PaddingBottom = UDim.new(0, 5)
            
            -- Dropdown state
            local isOpen = false
            local selected = default
            
            -- Initialize with default value if provided
            if default then
                callback(default)
            end
            
            -- Function to toggle dropdown
            local function toggleDropdown()
                isOpen = not isOpen
                
                if isOpen then
                    -- Show dropdown
                    DropdownFrame:TweenSize(
                        UDim2.new(1, 0, 0, 100 + math.min(150, #items * 30 + 10)),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    
                    DropdownItemsContainer.Visible = true
                    
                    DropdownItemsContainer:TweenSize(
                        UDim2.new(1, -30, 0, math.min(140, #items * 30)),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    
                    TweenService:Create(
                        DropdownIcon,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Rotation = 180}
                    ):Play()
                else
                    -- Hide dropdown
                    DropdownFrame:TweenSize(
                        UDim2.new(1, 0, 0, 100),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    
                    DropdownItemsContainer:TweenSize(
                        UDim2.new(1, -30, 0, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                    
                    TweenService:Create(
                        DropdownIcon,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Rotation = 0}
                    ):Play()
                    
                    -- Delay hiding dropdown items until animation completes
                    spawn(function()
                        wait(0.2)
                        if not isOpen then
                            DropdownItemsContainer.Visible = false
                        end
                    end)
                end
            end
            
            -- Dropdown hover effect
            DropdownClickRegion.MouseEnter:Connect(function()
                TweenService:Create(
                    DropdownFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(
                        math.min(theme.Secondary.R * 255 + 15, 255),
                        math.min(theme.Secondary.G * 255 + 15, 255),
                        math.min(theme.Secondary.B * 255 + 15, 255)
                    )}
                ):Play()
            end)
            
            DropdownClickRegion.MouseLeave:Connect(function()
                TweenService:Create(
                    DropdownFrame,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = theme.Secondary}
                ):Play()
            end)
            
            -- Toggle dropdown on click
            DropdownClickRegion.MouseButton1Click:Connect(toggleDropdown)
            
            -- Create dropdown items
            local function populateDropdown()
                -- Clear existing items
                for _, child in pairs(DropdownItemsList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Create new items
                for i, item in pairs(items) do
                    local DropdownItem = Instance.new("TextButton")
                    local DropdownItemUICorner = Instance.new("UICorner")
                    
                    DropdownItem.Name = "DropdownItem"
                    DropdownItem.Parent = DropdownItemsList
                    DropdownItem.BackgroundColor3 = theme.Secondary
                    DropdownItem.BackgroundTransparency = 0.5
                    DropdownItem.Size = UDim2.new(1, 0, 0, 25)
                    DropdownItem.Font = Enum.Font.GothamSemibold
                    DropdownItem.Text = tostring(item)
                    DropdownItem.TextColor3 = item == selected and theme.Accent or theme.Text
                    DropdownItem.TextSize = 14.000
                    DropdownItem.ZIndex = 3
                    
                    DropdownItemUICorner.CornerRadius = UDim.new(0, 4)
                    DropdownItemUICorner.Parent = DropdownItem
                    
                    -- Item click behavior
                    DropdownItem.MouseButton1Click:Connect(function()
                        selected = item
                        DropdownSelectedText.Text = tostring(item)
                        toggleDropdown()
                        callback(item)
                    end)
                    
                    -- Item hover effect
                    DropdownItem.MouseEnter:Connect(function()
                        TweenService:Create(
                            DropdownItem,
                            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundTransparency = 0.2}
                        ):Play()
                    end)
                    
                    DropdownItem.MouseLeave:Connect(function()
                        TweenService:Create(
                            DropdownItem,
                            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundTransparency = 0.5}
                        ):Play()
                    end)
                end
                
                -- Update ScrollingFrame canvas size
                DropdownItemsList.CanvasSize = UDim2.new(0, 0, 0, DropdownItemsListLayout.AbsoluteContentSize.Y + 10)
            end
            
            -- Initial population
            populateDropdown()
            
            local DropdownFunctions = {}
            
            function DropdownFunctions:Refresh(newItems)
                items = newItems or items
                populateDropdown()
            end
            
            function DropdownFunctions:Add(item)
                table.insert(items, item)
                populateDropdown()
            end
            
            function DropdownFunctions:Remove(item)
                for i, v in pairs(items) do
                    if v == item then
                        table.remove(items, i)
                        break
                    end
                end
                populateDropdown()
                
                -- Update selected value if the removed item was selected
                if selected == item then
                    selected = nil
                    DropdownSelectedText.Text = "Select an option..."
                end
            end
            
            function DropdownFunctions:Clear()
                items = {}
                selected = nil
                DropdownSelectedText.Text = "Select an option..."
                populateDropdown()
            end
            
            function DropdownFunctions:SetValue(value)
                if table.find(items, value) then
                    selected = value
                    DropdownSelectedText.Text = tostring(value)
                    callback(value)
                end
            end
            
            return DropdownFunctions
        end
        
        return TabElements
    end
    
    return TabsSystem
end


return whatui

-- Sirhurt Usage Example:
-- First, save this file as whatui.lua
-- Then use this code to load it:

--[[
-- Put this code in your script:
local whatui = loadstring(readfile("whatui.lua"))()
local ui = whatui:Create({
    title = "My UI",
    subtitle = "Created with WhatUI",
    blur = true
})

local mainTab = ui:Tab({title = "Main"})
local settingsTab = ui:Tab({title = "Settings"})

-- Add elements
mainTab:Button({
    title = "Click Me",
    description = "This is a button",
    callback = function()
        print("Button clicked!")
    end
})

mainTab:Toggle({
    title = "Auto Farm",
    description = "Enable auto farming",
    default = false,
    callback = function(enabled)
        print("Auto farm:", enabled)
    end
})

mainTab:Slider({
    title = "Walk Speed",
    description = "Adjust your walking speed",
    min = 16,
    max = 100,
    default = 16,
    callback = function(value)
        print("Speed set to:", value)
    end
})

mainTab:Dropdown({
    title = "Select Option",
    description = "Choose from the list",
    items =
