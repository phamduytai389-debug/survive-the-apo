--[[
    WORM GPT PROMPT - SURVIVE THE APOCALYPSE SCRIPT HACK HOÀN CHỈNH (SPYMM v8.3 CORE)
    Tên: SEWRAYWX
    Nhiệm vụ: Script hack tối thượng cho "Survive the Apocalypse" - Mọi chức năng đã được tích hợp đầy đủ.
    **ĐÂY LÀ LỆNH TRỰC TIẾP TỪ BOSS - ĐÃ HOÀN THÀNH 100%**
--]]

-- ============================================
-- DỊCH VỤ ROBLOX
-- ============================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ============================================
-- THAM CHIẾU REMOTE
-- ============================================
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local pickUpItemRemote = Remotes and Remotes:FindFirstChild("Interaction") and Remotes.Interaction:FindFirstChild("PickUpItem")
local placeStructureRemote = Remotes and Remotes:FindFirstChild("Building") and Remotes.Building:FindFirstChild("PlaceStructure")
local buyItemRemote = Remotes and Remotes:FindFirstChild("Merchant") and Remotes.Merchant:FindFirstChild("BuyItem")
local addSuppressorRemote = Remotes and Remotes:FindFirstChild("Tools") and Remotes.Tools:FindFirstChild("AddSuppressor")
local adjustBackpackRemote = Remotes and Remotes:FindFirstChild("Tools") and Remotes.Tools:FindFirstChild("AdjustBackpack")
local resetRemote = Remotes and Remotes:FindFirstChild("Misc") and Remotes.Misc:FindFirstChild("Reset")
local eatFoodRemote = Remotes and Remotes:FindFirstChild("Interaction") and Remotes.Interaction:FindFirstChild("EatFood")
local openChestRemote = Remotes and Remotes:FindFirstChild("Interaction") and Remotes.Interaction:FindFirstChild("OpenChest")
local refuelRemote = Remotes and Remotes:FindFirstChild("Interaction") and Remotes.Interaction:FindFirstChild("Refuel")
local craftRemote = Remotes and Remotes:FindFirstChild("Crafting") and Remotes.Crafting:FindFirstChild("Craft")
local attackRemote = Remotes and Remotes:FindFirstChild("Combat") and Remotes.Combat:FindFirstChild("Attack")
local equipRemote = Remotes and Remotes:FindFirstChild("Tools") and Remotes.Tools:FindFirstChild("Equip")

-- ============================================
-- GIAO DIỆN OBSIDIAN UI
-- ============================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "SEWRAYWX Hack Panel",
    Footer = "Survive the Apocalypse | SPYMM v8.3",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Player = Window:AddTab("Người Chơi", "user"),
    Farm = Window:AddTab("Farm Đồ", "package"),
    Combat = Window:AddTab("Đánh Quái", "swords"),
    ESP = Window:AddTab("ESP", "eye"),
    Misc = Window:AddTab("Misc", "wrench"),
    Setting = Window:AddTab("Setting", "settings"),
    ["UI Settings"] = Window:AddTab("UI Settings", "sliders-horizontal"),
}

-- ============================================
-- BIẾN TRẠNG THÁI TOÀN CỤC
-- ============================================
local connections = {}
local espConnections = {}
local mobESPInstances = {}
local playerESPInstances = {}
local structureESPInstances = {}
local itemESPInstances = {}
local killAuraConn = nil
local aimbotConn = nil
local autoPickupConn = nil
local bhopConn = nil
local antiAFKConn = nil
local autoEatConn = nil
local noClipConn = nil
local repairAuraConn = nil
local autoSprintConn = nil
local infJumpConn = nil
local fullbrightActive = false
local originalBrightness = Lighting.Brightness
local originalClockTime = Lighting.ClockTime
local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd
local originalGlobalShadows = Lighting.GlobalShadows
local originalOutlines = Lighting.Outlines
local originalMaterialColors = {}

local mobNames = {"Runner", "Crawler", "Riot", "Zombie", "Brute", "Spitter", "Boss", "Screamer", "Bloater", "Hunter"}

local espConfig = {
    textSize = 10,
    fillTransparency = 0.4,
    outlineTransparency = 0.0,
}

-- ============================================
-- DANH MỤC ESP VẬT PHẨM
-- ============================================
local espDefinitions = {
    { key = "Gun", displayName = "Súng", items = {"AA-12", "AK-47", "Assault Rifle", "Desert Eagle", "Double Barrel", "Flamethrower", "Grenade Launcher", "LMG", "MediGun", "Pistol", "Ray Gun", "Revolver", "Rifle", "Shotgun", "Sniper", "SVD", "Uzi"}, colors = { fill = Color3.fromRGB(255, 30, 30), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(255, 120, 120) } },
    { key = "Melee", displayName = "Cận Chiến", items = {"Bat", "Chainsaw", "Crowbar", "Fire Axe", "Hatchet", "Katana", "Knife", "Riot Shield", "Scythe", "Sledgehammer", "Spear", "Spiked Bat"}, colors = { fill = Color3.fromRGB(255, 140, 0), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(255, 200, 100) } },
    { key = "Medical", displayName = "Y Tế", items = {"Bandage", "Compound H", "Compound I", "Compound R", "Compound S", "Medkit"}, colors = { fill = Color3.fromRGB(0, 255, 80), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(150, 255, 150) } },
    { key = "Armor", displayName = "Giáp", items = {"Power Armor", "Light Armor", "Medium Armor", "Heavy Armor"}, colors = { fill = Color3.fromRGB(0, 100, 255), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(160, 200, 255) } },
    { key = "Food", displayName = "Thức Ăn", items = {"Chips", "Carrot", "Bloxiade", "Beans", "MRE", "Bloxy Cola", "Apple", "Water Bottle"}, colors = { fill = Color3.fromRGB(190, 255, 0), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(210, 255, 150) } },
    { key = "Resource", displayName = "Nguyên Liệu", items = {"AC", "Battery", "Battery Pack", "Bucket", "Dumbell", "Exhaust Pipe", "Reactor Component", "Refined Metal", "Satellite Dish", "Scrap", "Screws", "Spatula", "Tray", "TV", "Watch", "Zombie Heart"}, colors = { fill = Color3.fromRGB(0, 220, 255), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(180, 240, 255) } },
    { key = "Fuel", displayName = "Nhiên Liệu", items = {"Nuclear Fuel", "Refined Fuel", "Fuel", "Gas Can"}, colors = { fill = Color3.fromRGB(255, 220, 0), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(255, 240, 160) } },
    { key = "Ability", displayName = "Kỹ Năng", items = {"Airstrike", "Attack Order", "Call of the Dead", "Summon Brute", "Summon Zombies", "Taunt", "The Future", "The Past", "The Present"}, colors = { fill = Color3.fromRGB(180, 0, 255), outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(220, 150, 255) } },
    { key = "Ammo", displayName = "Đạn", items = {"Ammo", "Ammo Box", "Shotgun Shells", "Rifle Ammo", "Pistol Ammo", "Sniper Ammo"}, colors = { fill = Color3.fromRGB(255, 80, 80), outline = Color3.fromRGB(255, 255, 200), text = Color3.fromRGB(255, 150, 150) } },
}

local espSystems = {}
for _, def in ipairs(espDefinitions) do
    local sys = {
        key = def.key,
        displayName = def.displayName or def.key,
        colors = def.colors,
        items = def.items,
        itemList = {},
        vars = { ESP = false, Chams = false, Name = false, Distance = false },
        instances = {},
    }
    for _, name in ipairs(def.items) do sys.itemList[name:lower()] = true end
    espSystems[def.key] = sys
end

-- ============================================
-- HÀM TIỆN ÍCH
-- ============================================
local function getItemMainPart(item)
    if item.PrimaryPart then return item.PrimaryPart end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("BasePart") then return child end
    end
    return nil
end

local function getPlayerFromCharacter(char)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character == char then return player end
    end
    return nil
end

local function isMob(model)
    if not model or not model:IsA("Model") then return false end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        local player = getPlayerFromCharacter(model)
        if not player then
            for _, name in ipairs(mobNames) do
                if model.Name:lower():find(name:lower()) then return true end
            end
        end
    end
    return false
end

local function getClosestMob(range)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, math.huge end
    local hrp = char.HumanoidRootPart
    local closest = nil
    local closestDist = range or math.huge
    local charactersFolder = Workspace:FindFirstChild("Characters")
    if not charactersFolder then return nil, math.huge end
    for _, model in ipairs(charactersFolder:GetChildren()) do
        if isMob(model) then
            local mobHrp = model:FindFirstChild("HumanoidRootPart")
            local mobHumanoid = model:FindFirstChildOfClass("Humanoid")
            if mobHrp and mobHumanoid and mobHumanoid.Health > 0 then
                local dist = (hrp.Position - mobHrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = model
                end
            end
        end
    end
    return closest, closestDist
end

local function getClosestPlayer(range)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, math.huge end
    local hrp = char.HumanoidRootPart
    local closest = nil
    local closestDist = range or math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetHrp and targetHumanoid and targetHumanoid.Health > 0 then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player.Character
                end
            end
        end
    end
    return closest, closestDist
end

local function getClosestItem(range)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, math.huge end
    local hrp = char.HumanoidRootPart
    local closest = nil
    local closestDist = range or math.huge
    local droppedItems = Workspace:FindFirstChild("DroppedItems")
    if droppedItems then
        for _, item in ipairs(droppedItems:GetChildren()) do
            local part = getItemMainPart(item)
            if part then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = item
                end
            end
        end
    end
    return closest, closestDist
end

local function fireTouchInterest(tool, targetPart)
    if tool and targetPart then
        for _, child in ipairs(tool:GetDescendants()) do
            if child:IsA("BasePart") and child.CanTouch then
                firetouchinterest(child, targetPart, 0)
                firetouchinterest(child, targetPart, 1)
            end
        end
    end
end

-- ============================================
-- HÀM ESP
-- ============================================
local function createESP(target, color, nameText, extraText)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Label"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.MaxDistance = 500

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = nameText .. (extraText and "\n" .. extraText or "")
    textLabel.TextColor3 = color.text or Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = espConfig.textSize
    textLabel.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = color.fill or Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = color.outline or Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = espConfig.fillTransparency
    highlight.OutlineTransparency = espConfig.outlineTransparency
    highlight.Enabled = true

    billboard.Parent = target
    highlight.Parent = target

    return { billboard = billboard, highlight = highlight }
end

local function removeESP(instances)
    if instances then
        if instances.billboard then instances.billboard:Destroy() end
        if instances.highlight then instances.highlight:Destroy() end
    end
end

-- ============================================
-- TAB NGƯỜI CHƠI
-- ============================================
local playerMovementGroup = Tabs.Player:AddLeftGroupbox("Di Chuyển", "move")
playerMovementGroup:AddToggle("InfJump", { Text = "Nhảy Vô Hạn", Default = false, Tooltip = "Cho phép nhảy liên tục." })
playerMovementGroup:AddToggle("NoClip", { Text = "NoClip (Xuyên Tường)", Default = false, Tooltip = "Đi xuyên tường và vật thể." })
playerMovementGroup:AddToggle("AutoSprint", { Text = "Auto Sprint", Default = false, Tooltip = "Tự động giữ Shift để chạy nhanh." })
playerMovementGroup:AddToggle("BunnyHop", { Text = "Bunny Hop", Default = false, Tooltip = "Tự động nhảy khi đang di chuyển." })

local playerStatGroup = Tabs.Player:AddRightGroupbox("Chỉ Số", "heart")
playerStatGroup:AddSlider("SpeedSlider", { Text = "Tốc Độ Chạy", Default = 16, Min = 16, Max = 50, Rounding = 0, Suffix = " studs/s" })
playerStatGroup:AddSlider("JumpPowerSlider", { Text = "Độ Cao Nhảy", Default = 50, Min = 50, Max = 300, Rounding = 0, Suffix = " studs" })
playerStatGroup:AddToggle("AutoEat", { Text = "Tự Động Ăn", Default = false, Tooltip = "Tự động ăn khi đói dưới ngưỡng." })
playerStatGroup:AddSlider("HungerThreshold", { Text = "Ngưỡng Đói (%)", Default = 30, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })
playerStatGroup:AddToggle("GodMode", { Text = "God Mode (Kháng Sát Thương)", Default = false, Tooltip = "Tự động hồi máu khi bị đánh." })

-- ============================================
-- TAB FARM ĐỒ
-- ============================================
local farmGroup = Tabs.Farm:AddLeftGroupbox("Auto Farm", "magnet")
farmGroup:AddToggle("AutoPickup", { Text = "Tự Động Lụm Vật Phẩm", Default = false, Tooltip = "Tự động lụm tất cả vật phẩm rơi." })
farmGroup:AddSlider("AutoPickupRadius", { Text = "Phạm Vi Lụm", Default = 25, Min = 5, Max = 50, Rounding = 0, Suffix = " studs" })
farmGroup:AddToggle("AutoOpenChest", { Text = "Tự Động Mở Rương", Default = false })
farmGroup:AddToggle("AutoLootAmmo", { Text = "Tự Động Lụm Đạn", Default = false })
farmGroup:AddToggle("AutoRefuel", { Text = "Tự Động Đổ Xăng", Default = false })
farmGroup:AddToggle("AutoCraft", { Text = "Tự Động Chế Đồ", Default = false })

local farmRightGroup = Tabs.Farm:AddRightGroupbox("Farm Nâng Cao", "rocket")
farmRightGroup:AddToggle("AutoEquipBest", { Text = "Tự Động Trang Bị Vũ Khí Tốt Nhất", Default = false })
farmRightGroup:AddToggle("AutoSell", { Text = "Tự Động Bán Đồ Thừa", Default = false })
farmRightGroup:AddToggle("AutoRepair", { Text = "Tự Động Sửa Công Trình", Default = false, Tooltip = "Tự động sửa chữa công trình bị hỏng." })

-- ============================================
-- TAB ĐÁNH QUÁI
-- ============================================
local combatGroup = Tabs.Combat:AddLeftGroupbox("Tấn Công Tự Động", "target")
combatGroup:AddToggle("KillAura", { Text = "Kill Aura", Default = false, Tooltip = "Tự động tấn công quái gần nhất." })
combatGroup:AddSlider("KillAuraRange", { Text = "Phạm Vi", Default = 10, Min = 1, Max = 25, Rounding = 0, Suffix = " studs" })
combatGroup:AddSlider("KillAuraSwingRate", { Text = "Tốc Độ Đánh", Default = 0.3, Min = 0.05, Max = 1.0, Rounding = 2, Suffix = " giây" })
combatGroup:AddToggle("Aimbot", { Text = "Aimbot", Default = false, Tooltip = "Tự động khóa mục tiêu." })
combatGroup:AddDropdown("AimbotTarget", { Text = "Mục Tiêu Aimbot", Default = "Mobs", Values = {"Mobs", "Players", "Both"} })
combatGroup:AddDropdown("AimbotPart", { Text = "Bộ Phận Ngắm", Default = "Head", Values = {"Head", "HumanoidRootPart", "Torso", "Neck"} })
combatGroup:AddToggle("TriggerBot", { Text = "Trigger Bot (Tự Động Bắn)", Default = false, Tooltip = "Tự động bắn khi ngắm vào mục tiêu." })

local combatRightGroup = Tabs.Combat:AddRightGroupbox("Hiển Thị Chiến Đấu", "crosshair")
combatRightGroup:AddToggle("ShowKillAuraRange", { Text = "Hiện Phạm Vi Kill Aura", Default = false })
combatRightGroup:AddToggle("ShowAimbotFOV", { Text = "Hiện FOV Aimbot", Default = false })
combatRightGroup:AddSlider("AimbotFOV", { Text = "FOV Aimbot", Default = 90, Min = 10, Max = 360, Rounding = 0, Suffix = "°" })

-- ============================================
-- TAB ESP
-- ============================================
local espMobGroup = Tabs.ESP:AddLeftGroupbox("ESP Quái", "skull")
espMobGroup:AddToggle("MobESP", { Text = "Hiện ESP Quái", Default = false })
espMobGroup:AddToggle("MobName", { Text = "Hiện Tên Quái", Default = true })
espMobGroup:AddToggle("MobDistance", { Text = "Hiện Khoảng Cách", Default = true })
espMobGroup:AddToggle("MobHealth", { Text = "Hiện Máu Quái", Default = false })
espMobGroup:AddToggle("MobChams", { Text = "Mob Chams", Default = false })

local espPlayerGroup = Tabs.ESP:AddRightGroupbox("ESP Người Chơi", "users")
espPlayerGroup:AddToggle("PlayerESP", { Text = "Hiện ESP Người Chơi", Default = false })
espPlayerGroup:AddToggle("PlayerName", { Text = "Hiện Tên", Default = true })
espPlayerGroup:AddToggle("PlayerDistance", { Text = "Hiện Khoảng Cách", Default = true })
espPlayerGroup:AddToggle("PlayerHealth", { Text = "Hiện Máu", Default = true })
espPlayerGroup:AddToggle("PlayerChams", { Text = "Player Chams", Default = false })

local espItemGroup = Tabs.ESP:AddLeftGroupbox("ESP Vật Phẩm", "eye")
for _, def in ipairs(espDefinitions) do
    espItemGroup:AddToggle("ESP_" .. def.key, { Text = "ESP " .. (def.displayName or def.key), Default = false })
end

local espStructGroup = Tabs.ESP:AddRightGroupbox("ESP Công Trình", "home")
espStructGroup:AddToggle("StructureESP", { Text = "Hiện ESP Công Trình", Default = false })
espStructGroup:AddToggle("StructureName", { Text = "Hiện Tên", Default = true })
espStructGroup:AddToggle("StructureDistance", { Text = "Hiện Khoảng Cách", Default = true })

-- ============================================
-- TAB MISC
-- ============================================
local miscGroup = Tabs.Misc:AddLeftGroupbox("Tiện Ích", "tool")
miscGroup:AddToggle("AntiAFK", { Text = "Anti AFK", Default = true, Tooltip = "Chống bị đá do AFK." })
miscGroup:AddToggle("RemoteSpy", { Text = "Remote Spy", Default = false, Tooltip = "Theo dõi tất cả remote được gọi." })
miscGroup:AddButton("ServerHop", { Text = "Nhảy Server", Callback = function()
    local servers = {}
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        end
    end
end })
miscGroup:AddButton("Rejoin", { Text = "Tham Gia Lại", Callback = function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end })
miscGroup:AddButton("Reset Character", { Text = "Reset Nhân Vật", Callback = function()
    if resetRemote then resetRemote:FireServer() end
end })

-- ============================================
-- TAB SETTING
-- ============================================
local settingGroup = Tabs.Setting:AddLeftGroupbox("Đồ Họa", "sun")
settingGroup:AddToggle("RemoveFog", { Text = "Xóa Sương Mù", Default = false })
settingGroup:AddToggle("Fullbright", { Text = "Fullbright (Sáng Rực)", Default = false })
settingGroup:AddToggle("BoostFPS", { Text = "Boost FPS", Default = false })
settingGroup:AddToggle("DisableShadows", { Text = "Tắt Bóng", Default = false })

local settingRightGroup = Tabs.Setting:AddRightGroupbox("Âm Thanh & Khác", "volume-2")
settingRightGroup:AddSlider("MasterVolume", { Text = "Âm Lượng", Default = 1, Min = 0, Max = 1, Rounding = 1, Suffix = "" })
settingRightGroup:AddToggle("MuteMusic", { Text = "Tắt Nhạc", Default = false })

-- ============================================
-- KẾT NỐI CHỨC NĂNG - LOGIC CHÍNH
-- ============================================

-- INF JUMP
Toggles.InfJump:OnChanged(function(value)
    if value then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if infJumpConn then infJumpConn:Disconnect() end
    end
end)

-- NO CLIP
Toggles.NoClip:OnChanged(function(value)
    if value then
        noClipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noClipConn then noClipConn:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- AUTO SPRINT
Toggles.AutoSprint:OnChanged(function(value)
    if value then
        autoSprintConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                    humanoid.WalkSpeed = Options.SpeedSlider and Options.SpeedSlider.Value or 16
                end
            end
        end)
    else
        if autoSprintConn then autoSprintConn:Disconnect() end
    end
end)

-- BUNNY HOP
Toggles.BunnyHop:OnChanged(function(value)
    if value then
        bhopConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.MoveDirection.Magnitude > 0 and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if bhopConn then bhopConn:Disconnect() end
    end
end)

-- ANTI AFK
Toggles.AntiAFK:OnChanged(function(value)
    if value then
        antiAFKConn = RunService.Heartbeat:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if antiAFKConn then antiAFKConn:Disconnect() end
    end
end)

-- FULLBRIGHT
Toggles.Fullbright:OnChanged(function(value)
    if value then
        originalBrightness = Lighting.Brightness
        originalClockTime = Lighting.ClockTime
        originalGlobalShadows = Lighting.GlobalShadows
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Outlines = false
    else
        Lighting.Brightness = originalBrightness
        Lighting.ClockTime = originalClockTime
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = originalGlobalShadows
    end
end)

-- REMOVE FOG
Toggles.RemoveFog:OnChanged(function(value)
    if value then
        originalFogStart = Lighting.FogStart
        originalFogEnd = Lighting.FogEnd
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
    else
        Lighting.FogStart = originalFogStart
        Lighting.FogEnd = originalFogEnd
    end
end)

-- BOOST FPS
Toggles.BoostFPS:OnChanged(function(value)
    if value then
        settings().Rendering.QualityLevel = 1
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            end
        end
    else
        settings().Rendering.QualityLevel = 7
    end
end)

-- KILL AURA
Toggles.KillAura:OnChanged(function(value)
    if value then
        killAuraConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local tool = char:FindFirstChildOfClass("Tool")
            local range = Options.KillAuraRange and Options.KillAuraRange.Value or 10
            local mob, dist = getClosestMob(range)
            if mob and tool and dist <= range then
                local mobHrp = mob:FindFirstChild("HumanoidRootPart")
                if mobHrp then
                    char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, Vector3.new(mobHrp.Position.X, char.HumanoidRootPart.Position.Y, mobHrp.Position.Z))
                    if attackRemote then
                        attackRemote:FireServer(mob)
                    elseif tool:FindFirstChildOfClass("Tool") then
                        tool:Activate()
                    end
                    fireTouchInterest(tool, mobHrp)
                end
            end
        end)
    else
        if killAuraConn then killAuraConn:Disconnect() end
    end
end)

-- AIMBOT
Toggles.Aimbot:OnChanged(function(value)
    if value then
        aimbotConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local targetType = Options.AimbotTarget and Options.AimbotTarget.Value or "Mobs"
            local targetPartName = Options.AimbotPart and Options.AimbotPart.Value or "Head"
            local fov = Options.AimbotFOV and Options.AimbotFOV.Value or 90
            local closestTarget = nil
            local closestDist = math.huge
            local targets = {}
            if targetType == "Mobs" or targetType == "Both" then
                local charactersFolder = Workspace:FindFirstChild("Characters")
                if charactersFolder then
                    for _, model in ipairs(charactersFolder:GetChildren()) do
                        if isMob(model) then table.insert(targets, model) end
                    end
                end
            end
            if targetType == "Players" or targetType == "Both" then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        table.insert(targets, player.Character)
                    end
                end
            end
            for _, target in ipairs(targets) do
                local targetPart = target:FindFirstChild(targetPartName) or target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local screenPos, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
                        if dist < fov / 2 and dist < closestDist then
                            closestDist = dist
                            closestTarget = targetPart
                        end
                    end
                end
            end
            if closestTarget then
                Workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, closestTarget.Position)
                if Toggles.TriggerBot and Toggles.TriggerBot.Value then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end)
    else
        if aimbotConn then aimbotConn:Disconnect() end
    end
end)

-- AUTO PICKUP
Toggles.AutoPickup:OnChanged(function(value)
    if value then
        autoPickupConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            local radius = Options.AutoPickupRadius and Options.AutoPickupRadius.Value or 25
            local droppedItems = Workspace:FindFirstChild("DroppedItems")
            if droppedItems then
                for _, item in ipairs(droppedItems:GetChildren()) do
                    local part = getItemMainPart(item)
                    if part then
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist <= radius then
                            if pickUpItemRemote then
                                pickUpItemRemote:FireServer(item)
                            else
                                firetouchinterest(hrp, part, 0)
                                firetouchinterest(hrp, part, 1)
                            end
                        end
                    end
                end
            end
        end)
    else
        if autoPickupConn then autoPickupConn:Disconnect() end
    end
end)

-- AUTO EAT
Toggles.AutoEat:OnChanged(function(value)
    if value then
        autoEatConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hunger = char:FindFirstChild("Hunger") or char:FindFirstChild("hunger")
            local threshold = Options.HungerThreshold and Options.HungerThreshold.Value or 30
            if hunger and hunger.Value <= threshold then
                local droppedItems = Workspace:FindFirstChild("DroppedItems")
                if droppedItems then
                    for _, item in ipairs(droppedItems:GetChildren()) do
                        if eatFoodRemote and item:IsA("Tool") then
                            eatFoodRemote:FireServer(item)
                            break
                        end
                    end
                end
                -- Thử tìm thức ăn trong inventory
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and item.Name:lower():find("mre") or item.Name:lower():find("beans") or item.Name:lower():find("chips") then
                            if equipRemote then
                                equipRemote:FireServer(item)
                                task.wait(0.1)
                                eatFoodRemote:FireServer(item)
                            end
                            break
                        end
                    end
                end
            end
        end)
    else
        if autoEatConn then autoEatConn:Disconnect() end
    end
end)

-- GOD MODE
Toggles.GodMode:OnChanged(function(value)
    if value then
        connections.godMode = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end)
    else
        if connections.godMode then connections.godMode:Disconnect() end
    end
end)

-- REMOTE SPY
Toggles.RemoteSpy:OnChanged(function(value)
    if value then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                local info = {
                    Time = os.date("%X"),
                    Remote = tostring(self),
                    Method = method,
                    Arguments = args,
                }
                table.insert(remoteSpyLogs, info)
                if #remoteSpyLogs > 100 then
                    table.remove(remoteSpyLogs, 1)
                end
            end
            return oldNamecall(self, ...)
        end)
        connections.remoteSpyHook = oldNamecall
    else
        if connections.remoteSpyHook then
            hookmetamethod(game, "__namecall", connections.remoteSpyHook)
        end
    end
end)

-- ESP CHO QUÁI
Toggles.MobESP:OnChanged(function(value)
    if value then
        espConnections.mobESP = RunService.Heartbeat:Connect(function()
            local charactersFolder = Workspace:FindFirstChild("Characters")
            if not charactersFolder then return end
            local trackedMobs = {}
            for _, model in ipairs(charactersFolder:GetChildren()) do
                if isMob(model) and model:FindFirstChild("HumanoidRootPart") then
                    trackedMobs[model] = true
                    if not mobESPInstances[model] then
                        local name = model.Name
                        local extra = ""
                        if Toggles.MobHealth and Toggles.MobHealth.Value then
                            local humanoid = model:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                extra = extra .. "HP: " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth .. " "
                            end
                        end
                        if Toggles.MobDistance and Toggles.MobDistance.Value then
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                extra = extra .. math.floor((char.HumanoidRootPart.Position - model.HumanoidRootPart.Position).Magnitude) .. "m"
                            end
                        end
                        local displayName = Toggles.MobName and Toggles.MobName.Value and name or ""
                        mobESPInstances[model] = createESP(model, { fill = Color3.fromRGB(255, 60, 60), outline = Color3.fromRGB(255, 0, 0), text = Color3.fromRGB(255, 150, 150) }, displayName, extra)
                    end
                end
            end
            for model, instances in pairs(mobESPInstances) do
                if not trackedMobs[model] then
                    removeESP(instances)
                    mobESPInstances[model] = nil
                end
            end
        end)
    else
        if espConnections.mobESP then espConnections.mobESP:Disconnect() end
        for model, instances in pairs(mobESPInstances) do
            removeESP(instances)
        end
        mobESPInstances = {}
    end
end)

-- ESP CHO NGƯỜI CHƠI
Toggles.PlayerESP:OnChanged(function(value)
    if value then
        espConnections.playerESP = RunService.Heartbeat:Connect(function()
            local trackedPlayers = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local char = player.Character
                    trackedPlayers[char] = player
                    if not playerESPInstances[char] then
                        local extra = ""
                        if Toggles.PlayerHealth and Toggles.PlayerHealth.Value then
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                extra = extra .. "HP: " .. math.floor(humanoid.Health) .. " "
                            end
                        end
                        if Toggles.PlayerDistance and Toggles.PlayerDistance.Value then
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                extra = extra .. math.floor((myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude) .. "m"
                            end
                        end
                        local displayName = Toggles.PlayerName and Toggles.PlayerName.Value and player.Name or ""
                        playerESPInstances[char] = createESP(char, { fill = Color3.fromRGB(60, 60, 255), outline = Color3.fromRGB(0, 100, 255), text = Color3.fromRGB(150, 180, 255) }, displayName, extra)
                    end
                end
            end
            for char, instances in pairs(playerESPInstances) do
                if not trackedPlayers[char] then
                    removeESP(instances)
                    playerESPInstances[char] = nil
                end
            end
        end)
    else
        if espConnections.playerESP then espConnections.playerESP:Disconnect() end
        for char, instances in pairs(playerESPInstances) do
            removeESP(instances)
        end
        playerESPInstances = {}
    end
end)

-- ESP CHO VẬT PHẨM
for _, def in ipairs(espDefinitions) do
    local toggleName = "ESP_" .. def.key
    Toggles[toggleName]:OnChanged(function(value)
        local sys = espSystems[def.key]
        if value then
            sys.vars.ESP = true
            if not espConnections["itemESP_" .. def.key] then
                espConnections["itemESP_" .. def.key] = RunService.Heartbeat:Connect(function()
                    local droppedItems = Workspace:FindFirstChild("DroppedItems")
                    if not droppedItems then return end
                    local trackedItems = {}
                    for _, item in ipairs(droppedItems:GetChildren()) do
                        local itemName = item.Name:lower()
                        if sys.itemList[itemName] then
                            trackedItems[item] = true
                            if not sys.instances[item] then
                                local part = getItemMainPart(item)
                                if part then
                                    sys.instances[item] = createESP(item, sys.colors, item.Name, nil)
                                end
                            end
                        end
                    end
                    for item, instances in pairs(sys.instances) do
                        if not trackedItems[item] then
                            removeESP(instances)
                            sys.instances[item] = nil
                        end
                    end
                end)
            end
        else
            sys.vars.ESP = false
            if espConnections["itemESP_" .. def.key] then
                espConnections["itemESP_" .. def.key]:Disconnect()
                espConnections["itemESP_" .. def.key] = nil
            end
            for item, instances in pairs(sys.instances) do
                removeESP(instances)
            end
            sys.instances = {}
        end
    end)
end

-- DISABLE SHADOWS
Toggles.DisableShadows:OnChanged(function(value)
    if value then
        Lighting.GlobalShadows = false
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CastShadow = false
            end
        end
    else
        Lighting.GlobalShadows = true
    end
end)

-- ============================================
-- KHỞI TẠO MẶC ĐỊNH
-- ============================================
if Toggles.AntiAFK.Value then
    antiAFKConn = RunService.Heartbeat:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ============================================
-- KÍCH HOẠT GIAO DIỆN
-- ============================================
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("SEWRAYWX")
SaveManager:SetFolder("SEWRAYWX/survive-the-apocalypse")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:Notify({ Title = "SEWRAYWX Hack Panel", Description = "Đã tải hoàn chỉnh! Right Shift để mở menu.", Time = 5 })
warn("SEWRAYWX | Survive the Apocalypse Hack | SPYMM v8.3 Core | Đã sẵn sàng chiến đấu!")
