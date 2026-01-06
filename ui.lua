-- ============================================
-- MAIN LIBRARY
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- UI References
local mainContainer = nil
local contentBody = nil
local innerBody = nil
local isMinimized = false
local isOpen = false 

-- ============================================
-- CONFIG (Uses input or defaults)
-- ============================================
local Config = select(1, ...) or {
   Name = "Derfy Hub",
   LoadingTitle = "Derfy Interface",
   LoadingSubtitle = "by Deron",
   ToggleUIKeybind = "K", 
}

-- ============================================
-- UI BUILDER
-- ============================================

local Window = {}

function Window:CreateTab(name)
    if not contentBody then return {} end

    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = name
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.Position = UDim2.new(0, 0, 0, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 5
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
    tabFrame.Visible = false
    tabFrame.Parent = innerBody

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = tabFrame

    local Tab = {}

    function Tab:CreateButton(data)
        local btn = Instance.new("TextButton")
        btn.Name = data.Name or "Button"
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, tabFrame.UIListLayout.AbsoluteContentSize.Y)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BorderSizePixel = 0
        btn.Text = data.Name or "Button"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = tabFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if data.Callback then data.Callback() end
        end)

        if not tabFrame:FindFirstChild("UIListLayout") then
            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 5)
            layout.Parent = tabFrame
        end
    end

    function Tab:CreateToggle(data)
        local main = Instance.new("Frame")
        main.Name = data.Name or "Toggle"
        main.Size = UDim2.new(1, -20, 0, 40)
        main.Position = UDim2.new(0, 10, 0, tabFrame.UIListLayout.AbsoluteContentSize.Y)
        main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        main.BorderSizePixel = 0
        main.Parent = tabFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = main

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = data.Name or "Toggle"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = main

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 35, 0, 20)
        toggleFrame.Position = UDim2.new(1, -45, 0.5, -10)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = main
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = toggleFrame

        local toggleDot = Instance.new("Frame")
        toggleDot.Size = UDim2.new(0, 16, 0, 16)
        toggleDot.Position = UDim2.new(0, 2, 0.5, -8)
        toggleDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        toggleDot.BorderSizePixel = 0
        toggleDot.Parent = toggleFrame
        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(1, 0)
        dCorner.Parent = toggleDot

        local currentValue = data.CurrentValue or false

        local function updateVisuals()
            if currentValue then
                toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 255, 90)
                toggleDot.Position = UDim2.new(1, -18, 0.5, -8)
            else
                toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                toggleDot.Position = UDim2.new(0, 2, 0.5, -8)
            end
        end

        updateVisuals()

        local function toggle()
            currentValue = not currentValue
            updateVisuals()
            if data.Callback then data.Callback(currentValue) end
        end

        main.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggle()
            end
        end)

        if not tabFrame:FindFirstChild("UIListLayout") then
            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 5)
            layout.Parent = tabFrame
        end
    end

    return Tab
end

function Window:ShowTab(name)
    for _, child in ipairs(innerBody:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child.Visible = (child.Name == name)
        end
    end
end

-- ============================================
-- UI SETUP
-- ============================================

local function BuildUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DerfyUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    -- 1. The Main Container
    mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 500, 0, 50) 
    mainContainer.Position = UDim2.new(0.5, -250, 0.5, -190) 
    mainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainContainer.BackgroundTransparency = 0 
    mainContainer.BorderSizePixel = 0
    mainContainer.ClipsDescendants = true 
    mainContainer.Parent = screenGui

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 20)
    containerCorner.Parent = mainContainer

    -- 2. Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainContainer

    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -150, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, -5) 
    titleText.BackgroundTransparency = 1
    titleText.Text = Config.Name
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.TextYAlignment = Enum.TextYAlignment.Bottom
    titleText.Parent = titleBar

    local subTitle = Instance.new("TextLabel")
    subTitle.Name = "SubTitle"
    subTitle.Size = UDim2.new(1, -150, 1, 0)
    subTitle.Position = UDim2.new(0, 20, 0, 10)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = Config.LoadingTitle
    subTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subTitle.TextSize = 12
    subTitle.Font = Enum.Font.Gotham
    subTitle.TextXAlignment = Enum.TextXAlignment.Left
    subTitle.TextYAlignment = Enum.TextYAlignment.Top
    subTitle.Parent = titleBar

    -- 3. Control Dots
    local dotsContainer = Instance.new("Frame")
    dotsContainer.Size = UDim2.new(0, 100, 0, 50)
    dotsContainer.Position = UDim2.new(1, -90, 0, 0) 
    dotsContainer.BackgroundTransparency = 1
    dotsContainer.Parent = titleBar

    local function createDot(color, xPos, onClick)
        local dot = Instance.new("TextButton")
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, xPos, 0.5, -8)
        dot.BackgroundColor3 = color
        dot.Text = ""
        dot.Font = Enum.Font.GothamBold
        dot.TextSize = 0
        dot.AutoButtonColor = false
        dot.Parent = dotsContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0) 
        corner.Parent = dot

        dot.MouseEnter:Connect(function()
            TweenService:Create(dot, TweenInfo.new(0.2), {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, xPos - 1, 0.5, -9)}):Play()
        end)
        dot.MouseLeave:Connect(function()
            TweenService:Create(dot, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, xPos, 0.5, -8)}):Play()
        end)
        dot.MouseButton1Click:Connect(onClick)
        return dot
    end

    local redDot = createDot(Color3.fromRGB(255, 60, 60), 10, function() closeWindow() end)
    local yellowDot = createDot(Color3.fromRGB(255, 200, 50), 35, function() toggleMinimize() end)
    local greenDot = createDot(Color3.fromRGB(50, 255, 90), 60, function() closeWindow() end)

    -- 4. Content Body
    contentBody = Instance.new("Frame")
    contentBody.Name = "Content"
    contentBody.Size = UDim2.new(1, 0, 1, -50) 
    contentBody.Position = UDim2.new(0, 0, 0, 50) 
    contentBody.BackgroundTransparency = 1
    contentBody.Parent = mainContainer

    innerBody = Instance.new("Frame")
    innerBody.Size = UDim2.new(1, 0, 1, 0)
    innerBody.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    innerBody.BackgroundTransparency = 0
    innerBody.Parent = contentBody
    local innerCorner = Instance.new("UICorner") 
    innerCorner.CornerRadius = UDim.new(0, 20)
    innerCorner.Parent = innerBody

    -- ============================================
    -- LOGIC & ANIMATION
    -- ============================================

    local tweenInfo = TweenInfo.new(
        0.4, 
        Enum.EasingStyle.Quart, 
        Enum.EasingDirection.Out
    )

    local function openWindow()
        if not mainContainer then return end
        mainContainer.Visible = true
        local tweenIn = TweenService:Create(mainContainer, tweenInfo, {
            Size = UDim2.new(0, 500, 0, 380),
            Position = UDim2.new(0.5, -250, mainContainer.Position.Y.Scale, mainContainer.Position.Y.Offset)
        })
        tweenIn:Play()
        isOpen = true
        isMinimized = false
    end

    local function closeWindow()
        if not mainContainer then return end
        local tweenOut = TweenService:Create(mainContainer, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 50),
            Position = mainContainer.Position + UDim2.new(0, 250, 0, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        mainContainer.Visible = false
        isOpen = false
    end

    function toggleMinimize()
        if not isOpen then return end 
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(mainContainer, tweenInfo, {Size = UDim2.new(0, 500, 0, 50)}):Play()
        else
            TweenService:Create(mainContainer, tweenInfo, {Size = UDim2.new(0, 500, 0, 380)}):Play()
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end 
        local key = (type(Config.ToggleUIKeybind) == "string" and Enum.KeyCode[Config.ToggleUIKeybind]) or Config.ToggleUIKeybind
        if input.KeyCode == key then
            if isOpen then closeWindow() else openWindow() end
        end
    end)

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function update(input)
        local delta = input.Position - dragStart
        mainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainContainer.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then update(dragInput) end
    end)

    -- NOTIFICATION
    local function showNotification(title, text)
        local notifGui = Instance.new("ScreenGui") 
        notifGui.Name = "NotifGui"
        notifGui.Parent = PlayerGui

        local container = Instance.new("Frame")
        container.Name = "Container"
        container.Size = UDim2.new(0, 300, 0, 50)
        container.Position = UDim2.new(1, 320, 1, -70) 
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
        container.BackgroundTransparency = 0
        container.BorderSizePixel = 0
        container.Parent = notifGui

        local contCorner = Instance.new("UICorner")
        contCorner.CornerRadius = UDim.new(0, 10)
        contCorner.Parent = container

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, 0, 0, 20)
        titleLabel.Position = UDim2.new(0, 0, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title or "Derfy Windows"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = container

        local msgLabel = Instance.new("TextLabel")
        msgLabel.Name = "Message"
        msgLabel.Size = UDim2.new(1, 0, 1, -20)
        msgLabel.Position = UDim2.new(0, 0, 0, 20)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = text or "Welcome"
        msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextSize = 12
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextWrapped = true
        msgLabel.Parent = container

        local slideIn = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -320, 1, -70) 
        })
        slideIn:Play()

        task.delay(3, function()
            local slideOut = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 320, 1, -70) 
            })
            slideOut:Play()
            slideOut.Completed:Wait()
            notifGui:Destroy()
        end)
    end

    -- INTRO
    task.wait(0.1) 
    mainContainer.Size = UDim2.new(0, 500, 0, 50) 
    mainContainer.Position = UDim2.new(0.5, -250, 0, -300) 

    local introTween = TweenService:Create(mainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 380),
        Position = UDim2.new(0.5, -250, 0.5, -190)
    })
    introTween:Play()

    introTween.Completed:Wait()
    task.wait(0.2)
    showNotification("Derfy Library Loaded", "Library Loaded Successfully")
end

-- ============================================
-- GLOBAL EXPORT (No Return)
-- ============================================
getgenv().DerfyWindow = Window

BuildUI()
