-- NoClip + Speed x100 con menú táctil y botón arrastrable (Android OK)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Estados
local noclipEnabled = false
local speedEnabled = false

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "ModMenuGUI"

-- Botón flotante
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(0, 50, 0, 50)
dragButton.Position = UDim2.new(0, 20, 0.5, -25)
dragButton.BackgroundColor3 = Color3.new(0, 0, 0)
dragButton.Text = "■"
dragButton.TextColor3 = Color3.new(1, 1, 1)
dragButton.TextScaled = true
dragButton.ZIndex = 10
dragButton.Parent = ScreenGui

-- Marco del menú
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 200, 0, 120)
menuFrame.Position = UDim2.new(0, 80, 0.5, -60)
menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menuFrame.Visible = false
menuFrame.ZIndex = 9
menuFrame.Parent = ScreenGui

-- Botón Noclip
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(1, -20, 0, 45)
noclipButton.Position = UDim2.new(0, 10, 0, 10)
noclipButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.Text = "Toggle Noclip: OFF"
noclipButton.TextScaled = true
noclipButton.ZIndex = 10
noclipButton.Parent = menuFrame

-- Botón Speed
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -20, 0, 45)
speedButton.Position = UDim2.new(0, 10, 0, 65)
speedButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Text = "Toggle Speed: OFF"
speedButton.TextScaled = true
speedButton.ZIndex = 10
speedButton.Parent = menuFrame

-- Abrir/cerrar menú
dragButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Noclip activo en bucle
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Toggle Noclip
noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = "Toggle Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Toggle Speed
speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedButton.Text = "Toggle Speed: " .. (speedEnabled and "ON" or "OFF")
	if speedEnabled then
		Humanoid.WalkSpeed = 100
	else
		Humanoid.WalkSpeed = 16
	end
end)

-- Reforzar velocidad
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	if speedEnabled and Humanoid.WalkSpeed ~= 100 then
		Humanoid.WalkSpeed = 100
	end
end)

-- Drag del botón flotante
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	dragButton.Position = UDim2.new(
		0, startPos.X + delta.X,
		0, startPos.Y + delta.Y
	)
end

dragButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = dragButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

dragButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)
