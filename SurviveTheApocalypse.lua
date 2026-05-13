--[[
    SCRIPT HACK SURVIVE THE APOCALYPSE - ROBLOX
    Made by SEWRAYWX for BOSS
    Kích hoạt: Loadstring hoặc inject
]]

local SEWRAYWX_Hack = {
    Version = "1.0.0",
    GameName = "Survive The Apocalypse",
    ToggleUI = false,
    Minimized = false,
    Connections = {}
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configs
local Config = {
    -- Player
    SpeedBoost = false,
    SpeedValue = 30,
    InfiniteJump = false,
    HighJump = false,
    JumpPower = 150,
    AutoEat = false,
    HungerPercent = 30,
    
    -- Farm
    AutoCollectScrap = false,
    AutoCollectBattery = false,
    AutoCollectFuel = false,
    AutoCollectFood = false,
    AutoTeleportToMachine = false,
    AutoOpenChest = false,
    AutoCollectChestItems = false,
    ChestOpenDelay = 0,
    AutoCollectAmmo = false,
    
    -- Combat
    AutoAim = false,
    AimAtHead = true,
    AutoReload = false,
    AutoShoot = false,
    AutoMelee = false,
    AttackSpeed = -0.2,
    AttackRange = 30,
    
    -- System
    FOVRadius = 50,
    TeamCheck = false,
    WallCheck = false,
    
    -- UI Settings
    ToggleKey = Enum.KeyCode.RightShift
}

-- Variables
local ScrapItems = {}
local BatteryItems = {}
local FuelItems = {}
local FoodItems = {}
local AmmoItems = {}
local ZombieList = {}
local ChestList = {}
local DestroyableList = {}
local CurrentWeapon = nil
local IsReloading = false
local LastAttackTime = 0
local Machines = {}
local FuelMachines = {}

-- UI Creation
local function CreateUI()
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SEWRAYWX_HackGUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Logo Button (hiện khi minimized)
    local LogoButton = Instance.new("TextButton")
    LogoButton.Name = "LogoButton"
    LogoButton.Size = UDim2.new(0, 50, 0, 50)
    LogoButton.Position = UDim2.new(0, 10, 0.5, 0)
    LogoButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LogoButton.BorderSizePixel = 0
    LogoButton.Text = "S"
    LogoButton.TextColor3 = Color3.fromRGB(0, 255, 100)
    LogoButton.TextSize = 30
    LogoButton.Font = Enum.Font.GothamBold
    LogoButton.Visible = false
    LogoButton.Parent = ScreenGui
    
    Instance.new("UICorner", LogoButton).CornerRadius = UDim.new(0, 25)
    Instance.new("UIStroke", LogoButton).Color = Color3.fromRGB(0, 255, 100)
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 100)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, -20, 0, 40)
    TitleBar.Position = UDim2.new(0, 10, 0, 5)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "SEWRAYWX | Survive The Apocalypse"
    TitleText.TextColor3 = Color3.fromRGB(0, 255, 100)
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(0.85, 0, 0.5, -12)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 5)
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(0.92, 0, 0.5, -12)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 5)
    
    -- Tab Buttons Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 130, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    Instance.new("UICorner", TabContainer).CornerRadius = UDim.new(0, 8)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -155, 1, -60)
    ContentContainer.Position = UDim2.new(0, 145, 0, 50)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 8)
    
    -- Tabs
    local Tabs = {}
    local TabNames = {"Người Chơi", "Farm Đồ", "Đánh Quái", "Setting"}
    local ContentPages = {}
    
    for i, name in ipairs(TabNames) do
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)
        
        local ContentPage = Instance.new("ScrollingFrame")
        ContentPage.Size = UDim2.new(1, -10, 1, -10)
        ContentPage.Position = UDim2.new(0, 5, 0, 5)
        ContentPage.BackgroundTransparency = 1
        ContentPage.BorderSizePixel = 0
        ContentPage.Visible = (i == 1)
        ContentPage.ScrollBarThickness = 5
        ContentPage.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
        ContentPage.Parent = ContentContainer
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 5)
        UIListLayout.Parent = ContentPage
        
        table.insert(Tabs, TabButton)
        table.insert(ContentPages, ContentPage)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, page in ipairs(ContentPages) do
                page.Visible = false
            end
            ContentPage.Visible = true
            
            for _, tab in ipairs(Tabs) do
                tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        end)
    end
    
    -- Function to create toggle
    local function CreateToggle(parent, text, configKey, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parent
        Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 5)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 45, 0, 22)
        ToggleButton.Position = UDim2.new(0.85, 0, 0.5, -11)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleFrame
        Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 11)
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        ToggleIndicator.Position = UDim2.new(0, 3, 0.5, -8)
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.Parent = ToggleButton
        Instance.new("UICorner", ToggleIndicator).CornerRadius = UDim.new(0, 8)
        
        local isEnabled = false
        
        ToggleButton.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            Config[configKey] = isEnabled
            
            if isEnabled then
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}):Play()
            else
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end
            
            if callback then
                callback(isEnabled)
            end
        end)
        
        return ToggleButton
    end
    
    -- Function to create slider
    local function CreateSlider(parent, text, minVal, maxVal, configKey, defaultVal)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = parent
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 5)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.4, 0, 0, 20)
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 50, 0, 20)
        ValueLabel.Position = UDim2.new(0.85, 0, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(defaultVal)
        ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        ValueLabel.TextSize = 12
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.Parent = SliderFrame
        
        local SliderBg = Instance.new("Frame")
        SliderBg.Size = UDim2.new(0.85, 0, 0, 6)
        SliderBg.Position = UDim2.new(0, 10, 0, 30)
        SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SliderBg.BorderSizePixel = 0
        SliderBg.Parent = SliderFrame
        Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 3)
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBg
        Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)
        
        local SliderButton = Instance.new("TextButton")
        SliderButton.Size = UDim2.new(0, 14, 0, 14)
        SliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -7, 0, -4)
        SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderButton.BorderSizePixel = 0
        SliderButton.Text = ""
        SliderButton.Parent = SliderBg
        Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(0, 7)
        
        local dragging = false
        
        SliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = SliderBg.AbsolutePosition
                local sliderSize = SliderBg.AbsoluteSize
                local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
                local percent = relativeX / sliderSize.X
                local value = minVal + (maxVal - minVal) * percent
                value = math.round(value * 100) / 100
                
                Config[configKey] = value
                ValueLabel.Text = tostring(value)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderButton.Position = UDim2.new(percent, -7, 0, -4)
            end
        end)
    end
    
    -- Player Tab Content
    CreateToggle(ContentPages[1], "Tăng Tốc Chạy (Max 30)", "SpeedBoost")
    CreateSlider(ContentPages[1], "Giá Trị Tốc Độ:", 16, 30, "SpeedValue", 30)
    CreateToggle(ContentPages[1], "Nhảy Vô Hạn", "InfiniteJump")
    CreateToggle(ContentPages[1], "Tăng Độ Cao Nhảy", "HighJump")
    CreateSlider(ContentPages[1], "Độ Cao Nhảy:", 50, 300, "JumpPower", 150)
    CreateToggle(ContentPages[1], "Tự Động Ăn Khi Đói", "AutoEat")
    CreateSlider(ContentPages[1], "Mức % Đói:", 10, 100, "HungerPercent", 30)
    
    -- Farm Tab Content
    CreateToggle(ContentPages[2], "Tự Động Lụm Phế Liệu", "AutoCollectScrap")
    CreateToggle(ContentPages[2], "Tự Động Lụm Pin", "AutoCollectBattery")
    CreateToggle(ContentPages[2], "Tự Động Lụm Xăng", "AutoCollectFuel")
    CreateToggle(ContentPages[2], "Tự Động Lụm Đồ Ăn", "AutoCollectFood")
    CreateToggle(ContentPages[2], "Tele Vật Phẩm Vào Máy Chế Đồ", "AutoTeleportToMachine")
    CreateToggle(ContentPages[2], "Tự Động Mở Rương (Delay 0)", "AutoOpenChest")
    CreateToggle(ContentPages[2], "Tự Động Lụm Đồ Trong Rương", "AutoCollectChestItems")
    CreateToggle(ContentPages[2], "Tự Động Lụm Đạn", "AutoCollectAmmo")
    CreateSlider(ContentPages[2], "FOV Radius:", 20, 200, "FOVRadius", 50)
    
    -- Combat Tab Content
    CreateToggle(ContentPages[3], "Tự Động Aim", "AutoAim")
    CreateToggle(ContentPages[3], "Aim Vào Đầu", "AimAtHead")
    CreateToggle(ContentPages[3], "Tự Động Nạp Đạn", "AutoReload")
    CreateToggle(ContentPages[3], "Tự Động Bắn Khi Gặp Zombie", "AutoShoot")
    CreateToggle(ContentPages[3], "Tự Động Đánh Melee", "AutoMelee")
    CreateSlider(ContentPages[3], "Tốc Độ Đánh (Max -0.2):", -0.2, 1, "AttackSpeed", -0.2)
    CreateSlider(ContentPages[3], "Phạm Vi Đánh:", 10, 100, "AttackRange", 30)
    
    -- Settings Tab Content
    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Size = UDim2.new(1, 0, 0, 30)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Text = "Phím Tắt Hiện/Ẩn: " .. tostring(Config.ToggleKey)
    settingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsLabel.TextSize = 14
    settingsLabel.Font = Enum.Font.Gotham
    settingsLabel.Parent = ContentPages[4]
    
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Size = UDim2.new(1, 0, 0, 60)
    creditLabel.Position = UDim2.new(0, 0, 0, 100)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Text = "SEWRAYWX HACK SYSTEM\nMade for BOSS\nVersion: 1.0.0"
    creditLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    creditLabel.TextSize = 13
    creditLabel.Font = Enum.Font.GothamBold
    creditLabel.TextXAlignment = Enum.TextXAlignment.Center
    creditLabel.Parent = ContentPages[4]
    
    -- Minimize/Logo button logic
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        LogoButton.Visible = true
        SEWRAYWX_Hack.Minimized = true
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        LogoButton.Visible = true
        SEWRAYWX_Hack.Minimized = true
    end)
    
    LogoButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        LogoButton.Visible = false
        SEWRAYWX_Hack.Minimized = false
    end)
    
    -- Toggle UI Key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Config.ToggleKey then
            SEWRAYWX_Hack.ToggleUI = not SEWRAYWX_Hack.ToggleUI
            if SEWRAYWX_Hack.Minimized then
                MainFrame.Visible = SEWRAYWX_Hack.ToggleUI
                LogoButton.Visible = not SEWRAYWX_Hack.ToggleUI
            else
                MainFrame.Visible = SEWRAYWX_Hack.ToggleUI
                LogoButton.Visible = false
            end
        end
    end)
    
    return ScreenGui
end

-- HACK FUNCTIONS
local function findZombies()
    local zombies = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local humanoid = obj:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 and obj ~= Character then
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                if rootPart then
                    local distance = (rootPart.Position - RootPart.Position).Magnitude
                    if distance <= Config.AttackRange then
                        table.insert(zombies, {Model = obj, Humanoid = humanoid, RootPart = rootPart, Distance = distance})
                    end
                end
            end
        end
    end
    table.sort(zombies, function(a, b) return a.Distance < b.Distance end)
    return zombies
end

local function findNearbyItems(itemNames, radius)
    local items = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(Character) then
            for _, name in ipairs(itemNames) do
                if string.find(string.lower(obj.Name), string.lower(name)) then
                    local distance = (obj.Position - RootPart.Position).Magnitude
                    if distance <= radius then
                        table.insert(items, obj)
                    end
                    break
                end
            end
        end
    end
    return items
end

local function findChests(radius)
    local chests = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "chest") or string.find(name, "crate") or string.find(name, "ræ°æ¡ng") or string.find(name, "box") then
                local pos = obj:IsA("BasePart") and obj.Position or (obj:FindFirstChild("PrimaryPart") and obj.PrimaryPart.Position)
                if pos then
                    local distance = (pos - RootPart.Position).Magnitude
                    if distance <= radius then
                        table.insert(chests, obj)
                    end
                end
            end
        end
    end
    return chests
end

local function findMachines()
    local machines = {Crafting = {}, Fuel = {}}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = string.lower(obj.Name)
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if string.find(name, "craft") or string.find(name, "workbench") or string.find(name, "mÃ¡y") then
                local pos = obj:IsA("BasePart") and obj.Position or (obj:FindFirstChild("PrimaryPart") and obj.PrimaryPart.Position)
                if pos then
                    table.insert(machines.Crafting, {Object = obj, Position = pos})
                end
            end
            if string.find(name, "fuel") or string.find(name, "generator") or string.find(name, "nhiÃªn") then
                local pos = obj:IsA("BasePart") and obj.Position or (obj:FindFirstChild("PrimaryPart") and obj.PrimaryPart.Position)
                if pos then
                    table.insert(machines.Fuel, {Object = obj, Position = pos})
                end
            end
        end
    end
    return machines
end

local function getCurrentWeapon()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        local isGun = tool:FindFirstChild("Ammo") or tool:FindFirstChild("MaxAmmo") or tool:FindFirstChild("Bullets") or string.find(string.lower(tool.Name), "gun") or string.find(string.lower(tool.Name), "rifle") or string.find(string.lower(tool.Name), "pistol") or string.find(string.lower(tool.Name), "shotgun")
        local isMelee = string.find(string.lower(tool.Name), "knife") or string.find(string.lower(tool.Name), "bat") or string.find(string.lower(tool.Name), "axe") or string.find(string.lower(tool.Name), "pick") or string.find(string.lower(tool.Name), "sword") or string.find(string.lower(tool.Name), "stick") or string.find(string.lower(tool.Name), "hammer") or string.find(string.lower(tool.Name), "club")
        
        if isGun then
            return {Tool = tool, Type = "Gun"}
        elseif isMelee then
            return {Tool = tool, Type = "Melee"}
        else
            return {Tool = tool, Type = "Unknown"}
        end
    end
    return nil
end

local function teleportItem(item, targetPos)
    if item:IsA("BasePart") then
        item.CFrame = CFrame.new(targetPos)
    end
end

local function getHungerStatus()
    local hunger = Character:FindFirstChild("Hunger") or Character:FindFirstChild("hunger")
    if hunger and hunger:IsA("NumberValue") or hunger:IsA("IntValue") then
        return hunger.Value
    end
    return 100
end

-- Main Hack Loop
local function StartHackLoop()
    RunService.RenderStepped:Connect(function()
        if not Config then return end
        
        Character = LocalPlayer.Character
        if not Character then return end
        
        Humanoid = Character:FindFirstChild("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        
        -- Player Hacks
        if Config.SpeedBoost then
            Humanoid.WalkSpeed = Config.SpeedValue
        end
        
        if Config.InfiniteJump then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            Humanoid.JumpPower = Config.HighJump and Config.JumpPower or 50
        elseif Config.HighJump then
            Humanoid.JumpPower = Config.JumpPower
        end
        
        if Config.AutoEat then
            local hunger = getHungerStatus()
            if hunger <= Config.HungerPercent then
                local foodItems = findNearbyItems({"food", "apple", "meat", "bread", "candy", "thá»©c", "can", "soup", "water", "drink"}, Config.FOVRadius)
                for _, food in ipairs(foodItems) do
                    fireproximityprompt(food)
                    break
                end
            end
        end
        
        -- Farm Hacks
        local machines = findMachines()
        
        if Config.AutoCollectScrap then
            local scraps = findNearbyItems({"scrap", "metal", "iron", "pháº¿", "gear", "spring", "bolt"}, Config.FOVRadius)
            for _, scrap in ipairs(scraps) do
                scrap.CFrame = RootPart.CFrame
                if Config.AutoTeleportToMachine and machines.Crafting[1] then
                    task.wait(0.1)
                    teleportItem(scrap, machines.Crafting[1].Position + Vector3.new(0, 3, 0))
                end
            end
        end
        
        if Config.AutoCollectBattery then
            local batteries = findNearbyItems({"battery", "cell", "power", "pin"}, Config.FOVRadius)
            for _, battery in ipairs(batteries) do
                battery.CFrame = RootPart.CFrame
                if Config.AutoTeleportToMachine and machines.Crafting[1] then
                    task.wait(0.1)
                    teleportItem(battery, machines.Crafting[1].Position + Vector3.new(0, 3, 0))
                end
            end
        end
        
        if Config.AutoCollectFuel then
            local fuels = findNearbyItems({"fuel", "gas", "xÄƒng", "petrol", "oil"}, Config.FOVRadius)
            for _, fuel in ipairs(fuels) do
                fuel.CFrame = RootPart.CFrame
                if Config.AutoTeleportToMachine and machines.Fuel[1] then
                    task.wait(0.1)
                    teleportItem(fuel, machines.Fuel[1].Position + Vector3.new(0, 3, 0))
                end
            end
        end
        
        if Config.AutoCollectFood then
            local foods = findNearbyItems({"food", "apple", "meat", "bread", "candy", "can", "soup", "water", "drink"}, Config.FOVRadius)
            local hunger = getHungerStatus()
            for _, food in ipairs(foods) do
                if Config.AutoEat and hunger <= Config.HungerPercent then
                    food.CFrame = RootPart.CFrame
                    fireproximityprompt(food)
                elseif Config.AutoTeleportToMachine and machines.Fuel[1] then
                    food.CFrame = RootPart.CFrame
                    task.wait(0.1)
                    teleportItem(food, machines.Fuel[1].Position + Vector3.new(0, 3, 0))
                end
            end
        end
        
        if Config.AutoOpenChest then
            local chests = findChests(Config.FOVRadius)
            for _, chest in ipairs(chests) do
                local proximityPrompt = chest:FindFirstChildOfClass("ProximityPrompt") or (chest:IsA("Model") and chest:FindFirstChildWhichIsA("ProximityPrompt"))
                if proximityPrompt then
                    fireproximityprompt(proximityPrompt)
                    if Config.AutoCollectChestItems then
                        task.wait(Config.ChestOpenDelay)
                        local chestItems = {}
                        if chest:IsA("Model") then
                            for _, child in ipairs(chest:GetDescendants()) do
                                if child:IsA("BasePart") and child ~= chest.PrimaryPart then
                                    child.CFrame = RootPart.CFrame
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if Config.AutoCollectAmmo then
            local ammos = findNearbyItems({"ammo", "bullet", "shell", "mag", "áº¡n"}, Config.FOVRadius)
            for _, ammo in ipairs(ammos) do
                ammo.CFrame = RootPart.CFrame
            end
        end
        
        -- Combat Hacks
        local weapon = getCurrentWeapon()
        local zombies = findZombies()
        
        if weapon and weapon.Type == "Gun" and zombies[1] then
            local targetZombie = zombies[1]
            
            if Config.AutoAim then
                local aimTarget = targetZombie.RootPart
                if Config.AimAtHead then
                    aimTarget = targetZombie.Model:FindFirstChild("Head") or targetZombie.RootPart
                end
                if aimTarget then
                    RootPart.CFrame = CFrame.new(RootPart.Position, Vector3.new(aimTarget.Position.X, RootPart.Position.Y, aimTarget.Position.Z))
                end
            end
            
            if Config.AutoReload then
                local ammo = weapon.Tool:FindFirstChild("Ammo") or weapon.Tool:FindFirstChild("Bullets")
                if ammo and ammo:IsA("IntValue") and ammo.Value <= 0 then
                    local reloadEvent = weapon.Tool:FindFirstChild("Reload") or weapon.Tool:FindFirstChildOfClass("RemoteEvent")
                    if reloadEvent then
                        reloadEvent:FireServer()
                    end
                end
            end
            
            if Config.AutoShoot then
                local currentTime = tick()
                if currentTime - LastAttackTime >= math.abs(Config.AttackSpeed) then
                    local shootEvent = weapon.Tool:FindFirstChild("Shoot") or weapon.Tool:FindFirstChildOfClass("RemoteEvent")
                    if shootEvent then
                        shootEvent:FireServer(targetZombie.RootPart.Position)
                        LastAttackTime = currentTime
                    else
                        weapon.Tool:Activate()
                        task.wait(0.1)
                        weapon.Tool:Deactivate()
                        LastAttackTime = currentTime
                    end
                end
            end
        end
        
        if Config.AutoMelee and weapon and weapon.Type == "Melee" then
            local currentTime = tick()
            if currentTime - LastAttackTime >= math.abs(Config.AttackSpeed) then
                -- Đánh zombie hoặc vật phá hủy trong phạm vi
                local hasTarget = false
                
                if zombies[1] then
                    hasTarget = true
                    weapon.Tool:Activate()
                    task.wait(0.05)
                    weapon.Tool:Deactivate()
                end
                
                if not hasTarget then
                    local destroyables = findNearbyItems({"rock", "tree", "wall", "fence", "door", "barricade", "crate", "barrel"}, Config.AttackRange)
                    if destroyables[1] then
                        RootPart.CFrame = CFrame.new(RootPart.Position, Vector3.new(destroyables[1].Position.X, RootPart.Position.Y, destroyables[1].Position.Z))
                        weapon.Tool:Activate()
                        task.wait(0.05)
                        weapon.Tool:Deactivate()
                    end
                end
                
                LastAttackTime = currentTime
            end
        end
    end)
end

-- Fire proximity prompt helper
function fireproximityprompt(obj)
    if type(obj) == "string" then
        obj = Workspace:FindFirstChild(obj)
    end
    if not obj then return end
    
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
    if not prompt and obj:IsA("Model") then
        prompt = obj:FindFirstChildWhichIsA("ProximityPrompt")
    end
    if prompt then
        fireproximityprompt(prompt)
        return
    end
    
    if obj:IsA("ProximityPrompt") then
        local holdDuration = obj.HoldDuration or 0
        obj:InputHoldBegin()
        if holdDuration > 0 then
            task.wait(holdDuration)
        end
        obj:InputHoldEnd()
    end
end

-- Khởi tạo
local UI = CreateUI()
StartHackLoop()

-- Thông báo
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Parent = CoreGui
local NotifyFrame = Instance.new("Frame")
NotifyFrame.Size = UDim2.new(0, 300, 0, 40)
NotifyFrame.Position = UDim2.new(0.5, -150, 0, 10)
NotifyFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
NotifyFrame.BorderSizePixel = 0
NotifyFrame.Parent = NotifyGui
Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)

local NotifyText = Instance.new("TextLabel")
NotifyText.Size = UDim2.new(1, 0, 1, 0)
NotifyText.BackgroundTransparency = 1
NotifyText.Text = "SEWRAYWX HACK ĐÃ LOADED - PHÍM " .. tostring(Config.ToggleKey) .. " ĐỂ HIỆN/ẨN"
NotifyText.TextColor3 = Color3.fromRGB(0, 0, 0)
NotifyText.TextSize = 14
NotifyText.Font = Enum.Font.GothamBold
NotifyText.Parent = NotifyFrame

task.delay(5, function()
    NotifyFrame:Destroy()
end)

return SEWRAYWX_Hack
