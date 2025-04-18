-- Soilebss.lua (KRNL uyumlu, debug prints & GUI koruma eklendi)

local Players       = game:GetService("Players")
local LocalPlayer   = Players.LocalPlayer
local PlayerGui     = LocalPlayer:WaitForChild("PlayerGui")

-- ===== SCREEN GUI OLUŞTUR =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name              = "AtlasBoostGui"
ScreenGui.Parent            = PlayerGui
ScreenGui.ResetOnSpawn      = false
ScreenGui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling

-- Exploit GUI koruma
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
elseif gethui then
    ScreenGui.Parent = gethui()
end

print("[AtlasBoost] GUI yüklendi")  -- Debug: GUI yaratıldı

-- ===== AÇMA BUTONU =====
local openButton = Instance.new("TextButton")
openButton.Name              = "OpenButton"
openButton.Size              = UDim2.new(0,100,0,30)
openButton.Position          = UDim2.new(0,10,0,10)
openButton.Text              = "🚀 AtlasBoost"
openButton.BackgroundColor3  = Color3.fromRGB(35,35,255)
openButton.TextColor3        = Color3.fromRGB(255,255,255)
openButton.Parent            = ScreenGui

-- ===== MENÜ KUTUSU =====
local menu = Instance.new("Frame")
menu.Name                   = "MenuFrame"
menu.Size                   = UDim2.new(0,200,0,100)
menu.Position               = UDim2.new(0,10,0,50)
menu.BackgroundColor3       = Color3.fromRGB(50,50,50)
menu.Visible                = false
menu.Parent                 = ScreenGui

-- ===== BAŞLAT BUTONU =====
local startButton = Instance.new("TextButton")
startButton.Size               = UDim2.new(1,-20,0,40)
startButton.Position           = UDim2.new(0,10,0,10)
startButton.Text               = "🎯 Boost Al ve Kasıl"
startButton.BackgroundColor3   = Color3.fromRGB(100,200,100)
startButton.TextColor3         = Color3.fromRGB(0,0,0)
startButton.Parent             = menu

print("[AtlasBoost] Menüler oluşturuldu")  -- Debug

openButton.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    print("[AtlasBoost] Menu.Visible =", menu.Visible)
end)

-- ===== BOOST LOKASYONLARI =====
local boostLocations = {
    ["Blue HQ"] = CFrame.new(-483, 45, 272),
    ["Red HQ"]  = CFrame.new(324,  52, 149),
    ["Mountain"] = CFrame.new(-116,174,-231),
}

-- ===== RED CANNON =====
local redCannon = CFrame.new(200,60,210)

-- ===== FONKSİYONLAR =====
local function goTo(posCFrame)
    LocalPlayer.Character:PivotTo(posCFrame)
    wait(1)
end

local function getBoosts()
    for name, cf in pairs(boostLocations) do
        print("[AtlasBoost] Boost almak için gidiliyor:", name)
        goTo(cf)
        wait(0.5)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and (v.Parent.Position - cf.Position).Magnitude < 15 then
                fireproximityprompt(v)
                print("[AtlasBoost] E bastı:", name)
                wait(1)
            end
        end
    end
end

local function detectBoostedField()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
    if not gui then return nil end
    for _, icon in pairs(gui:GetDescendants()) do
        if icon:IsA("ImageLabel") and icon.Name:lower():find("boost") then
            local f = icon.Name:gsub("Boost",""):gsub("_"," ") .. " Field"
            print("[AtlasBoost] Boost field tespit edildi:", f)
            return f
        end
    end
    return nil
end

local function goToField(fieldName)
    local zones = workspace:FindFirstChild("FlowerZones")
    if zones and zones:FindFirstChild(fieldName) then
        print("[AtlasBoost] Field'a gidiliyor:", fieldName)
        goTo(zones[fieldName].CFrame + Vector3.new(0,5,0))
    end
end

local function farmField(fieldName, duration)
    goToField(fieldName)
    local t0 = tick()
    while tick() - t0 < duration do
        wait(1)
    end
    print("[AtlasBoost] Farm süresi doldu:", fieldName)
end

local function goToFieldWithCannon()
    print("[AtlasBoost] Red Cannon'a gidiliyor")
    goTo(redCannon)
    wait(1)
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.5)
    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
end

-- ===== ANA AKIŞ =====
startButton.MouseButton1Click:Connect(function()
    menu.Visible = false
    print("[AtlasBoost] Başlatıldı")
    getBoosts()
    wait(2)
    local bf = detectBoostedField()
    if bf then
        goToFieldWithCannon()
        wait(5)
        farmField(bf, 15*60)  -- 15 dk
    else
        warn("[AtlasBoost] Boost field bulunamadı!")
    end
end)
