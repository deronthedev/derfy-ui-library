local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ============================================
-- UI CREATION
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DerfyUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- 1. The Main Container
local mainContainer = Instance.new("Frame")
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

-- Main Title Text
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -150, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, -5) -- Adjusted for the second line
titleText.BackgroundTransparency = 1
titleText.Text = "Derfy Windows"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextYAlignment = Enum.TextYAlignment.Bottom
titleText.Parent = titleBar

-- Small "Example" Text underneath
local subTitle = Instance.new("TextLabel")
subTitle.Name = "SubTitle"
subTitle.Size = UDim2.new(1, -150, 1, 0)
subTitle.Position = UDim2.new(0, 20, 0, 10)
subTitle.BackgroundTransparency = 1
subTitle.Text = "Example"
subTitle.TextColor3 = Color3.fromRGB(150, 150, 150) -- Lighter grey
subTitle.TextSize = 12
subTitle.Font = Enum.Font.Gotham
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.TextYAlignment = Enum.TextYAlignment.Top
subTitle.Parent = titleBar

-- 3. Control Dots (On the Right)
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
local greenDot = createDot(Color3.fromRGB(50, 255, 90), 60, function() openSideButton() end)

-- 4. The Side Open Button
local openSideBtn = Instance.new("TextButton")
openSideBtn.Name = "OpenSideBtn"
openSideBtn.Size = UDim2.new(0, 60, 0, 60)
openSideBtn.Position = UDim2.new(0, 10, 0.5, -30) 
openSideBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 90) 
openSideBtn.Text = "Open"
openSideBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
openSideBtn.Font = Enum.Font.GothamBold
openSideBtn.TextSize = 14
openSideBtn.AutoButtonColor = false
openSideBtn.Visible = false 
openSideBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0) 
openCorner.Parent = openSideBtn

openSideBtn.MouseEnter:Connect(function()
    TweenService:Create(openSideBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 70, 0, 70)}):Play()
end)
openSideBtn.MouseLeave:Connect(function()
    TweenService:Create(openSideBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)

openSideBtn.MouseButton1Click:Connect(function() openWindow() end)

-- 5. Content Body
local contentBody = Instance.new("Frame")
contentBody.Name = "Content"
contentBody.Size = UDim2.new(1, 0, 1, -50) 
contentBody.Position = UDim2.new(0, 0, 0, 50) 
contentBody.BackgroundTransparency = 1
contentBody.Parent = mainContainer

local innerBody = Instance.new("Frame")
innerBody.Size = UDim2.new(1, 0, 1, 0)
innerBody.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
innerBody.BackgroundTransparency = 0
innerBody.Parent = contentBody
local innerCorner = Instance.new("UICorner") 
innerCorner.CornerRadius = UDim.new(0, 20)
innerCorner.Parent = innerBody

-- 6. Notification System (Bottom Left)
local function showNotification()
    local notifGui = Instance.new("ScreenGui") -- Separate GUI for notification
    notifGui.Name = "NotifGui"
    notifGui.ResetOnSpawn = false
    notifGui.Parent = PlayerGui

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 300, 0, 50)
    container.Position = UDim2.new(0, -320, 1, -70) -- Start off-screen left
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.Parent = notifGui

    local contCorner = Instance.new("UICorner")
    contCorner.CornerRadius = UDim.new(0, 10)
    contCorner.Parent = container

    local contStroke = Instance.new("UIStroke")
    contStroke.Color = Color3.fromRGB(50, 255, 90) -- Green stroke
    contStroke.Thickness = 1
    contStroke.Parent = container

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Derfy Windows [Example]"
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
    msgLabel.Text = "Welcome"
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 12
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Parent = container

    -- Slide In
    local slideIn = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 20, 1, -70)
    })
    slideIn:Play()

    -- Wait 3 seconds then Slide Out and Destroy
    task.delay(3, function()
        local slideOut = TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0, -320, 1, -70)
        })
        slideOut:Play()
        slideOut.Completed:Wait()
        notifGui:Destroy()
    end)
end


-- ============================================
-- LOGIC & ANIMATION
-- ============================================

local isMinimized = false 
local isOpen = true 

local tweenInfo = TweenInfo.new(
    0.4, 
    Enum.EasingStyle.Quart, 
    Enum.EasingDirection.Out
)

function openWindow()
    openSideBtn.Visible = false
    mainContainer.Visible = true
    
    local tweenIn = TweenService:Create(mainContainer, tweenInfo, {
        Size = UDim2.new(0, 500, 0, 380),
        Position = UDim2.new(0.5, -250, mainContainer.Position.Y.Scale, mainContainer.Position.Y.Offset)
    })
    tweenIn:Play()
    isOpen = true
end

function openSideButton()
    local tweenOut = TweenService:Create(mainContainer, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 50),
        Position = mainContainer.Position + UDim2.new(0, 250, 0, 0)
    })
    tweenOut:Play()
    tweenOut.Completed:Wait()
    mainContainer.Visible = false
    isOpen = false
    
    openSideBtn.Visible = true
end

function closeWindow()
    openSideButton()
end

function toggleMinimize()
    if not isOpen then return end 
    isMinimized = not isMinimized

    if isMinimized then
        local tweenMin = TweenService:Create(mainContainer, tweenInfo, {
            Size = UDim2.new(0, 500, 0, 50) 
        })
        tweenMin:Play()
    else
        local tweenMax = TweenService:Create(mainContainer, tweenInfo, {
            Size = UDim2.new(0, 500, 0, 380) 
        })
        tweenMax:Play()
    end
end

-- KEYBOARD (K)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end 
    if input.KeyCode == Enum.KeyCode.K then
        if isOpen then
            closeWindow() 
        else
            openWindow() 
        end
    end
end)

-- DRAGGING
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
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        update(dragInput)
    end
end)

-- ============================================
-- INTRO & NOTIFICATION
-- ============================================
task.wait(0.1) 

mainContainer.Size = UDim2.new(0, 500, 0, 50) 
mainContainer.Position = UDim2.new(0.5, -250, 0, -300) 

local introTween = TweenService:Create(mainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 500, 0, 380),
    Position = UDim2.new(0.5, -250, 0.5, -190)
})
introTween:Play()

isMinimized = false

-- Show Notification shortly after intro finishes
introTween.Completed:Wait()
task.wait(0.2)
showNotification()
