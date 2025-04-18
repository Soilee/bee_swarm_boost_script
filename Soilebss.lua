-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 100, 0, 30)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.Text = "🚀 AtlasBoost"
openButton.BackgroundColor3 = Color3.fromRGB(35, 35, 255)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Parent = ScreenGui

local menu = Instance.new("Frame", ScreenGui)
menu.Size = UDim2.new(0, 200, 0, 100)
menu.Position = UDim2.new(0, 10, 0, 50)
menu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
menu.Visible = false

local startButton = Instance.new("TextButton", menu)
startButton.Size = UDim2.new(1, -20, 0, 40)
startButton.Position = UDim2.new(0, 10, 0, 10)
startButton.Text = "🎯 Boost Al ve Kasıl"
startButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
startButton.TextColor3 = Color3.fromRGB(0, 0, 0)

openButton.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Boost alma noktaları
local boostLocations = {
	["Blue HQ"] = CFrame.new(-483, 45, 272),
	["Red HQ"] = CFrame.new(324, 52, 149),
	["Mountain"] = CFrame.new(-116, 174, -231)
}

-- Red cannon konumu
local redCannon = CFrame.new(200, 60, 210)

-- Field’a gitme fonksiyonu (Red cannon + paraşüt)
local function goToFieldWithCannon()
	game.Players.LocalPlayer.Character:PivotTo(redCannon)
	wait(1)
	-- Space + paraşüt simülasyonu
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	wait(0.5)
	humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
end

-- Boost alma fonksiyonu
local function getBoosts()
	for name, cframe in pairs(boostLocations) do
		game.Players.LocalPlayer.Character:PivotTo(cframe)
		wait(2)
		-- Simüle E tuşu (proximityprompt varsa)
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") and (v.Parent.Position - cframe.Position).Magnitude < 15 then
				fireproximityprompt(v)
				wait(1)
			end
		end
	end
end

-- Boost field'ını bulma
local function detectBoostedField()
	local boostsGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
	if not boostsGui then return nil end

	for _, icon in pairs(boostsGui:GetDescendants()) do
		if icon:IsA("ImageLabel") and icon.Name:lower():find("boost") then
			local fieldName = icon.Name:gsub("Boost", ""):gsub("_", " ") -- örnek: "CloverBoost" -> "Clover"
			return fieldName .. " Field"
		end
	end
	return nil
end

-- Field’a gitme
local function goToField(fieldName)
	local fields = workspace:FindFirstChild("FlowerZones")
	if not fields then return end
	local target = fields:FindFirstChild(fieldName)
	if target then
		game.Players.LocalPlayer.Character:PivotTo(target.CFrame + Vector3.new(0, 5, 0))
	end
end

-- Belirli süre boyunca kasılma
local function farmField(fieldName, duration)
	goToField(fieldName)
	local startTime = tick()
	while tick() - startTime < duration do
		wait(1)
	end
end

-- Ana işlem
startButton.MouseButton1Click:Connect(function()
	menu.Visible = false
	getBoosts()
	wait(2)
	local boostedField = detectBoostedField()
	if boostedField then
		goToFieldWithCannon()
		wait(5)
		farmField(boostedField, 15 * 60) -- 15 dakika boyunca farm
	end
end)
