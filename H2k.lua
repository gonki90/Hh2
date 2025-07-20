-- Script: Noclip + Speed 100 con menú táctil flotante (Android)
-- Autor: ChatGPT
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Estado de funciones
local noclipEnabled = false
local speedEnabled = false

-- Crear GUI principal
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

-- Botón flotante (abrir/cerrar menú)
local toggleButton = Instance.new("TextButton")
toggleButton.Text = "■"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 0, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Parent = ScreenGui
toggleButton.ZIndex = 10

-- Marco del menú
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 180, 0, 100)
menuFrame.Position = UDim2.new(0, 45, 0.5, -50)
menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menuFrame.Visible = false
menuFrame.Parent = ScreenGui
menuFrame.ZIndex = 9

-- Botón Noclip
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(1, -10, 0, 40)
noclipButton.Position = UDim2.new(0, 5, 0, 5)
noclipButton.Text = "Toggle Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.TextScaled = true
noclipButton.Parent = menuFrame

-- Botón Speed
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -10, 0, 40)
speedButton.Position = UDim2.new(0, 5, 0, 50)
speedButton.Text = "Toggle Speed: OFF"
speedButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.TextScaled = true
speedButton.Parent = menuFrame

-- Alternar menú
toggleButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Noclip Loop
RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Activar / desactivar noclip
noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipButton.Text = "Toggle Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

-- Activar / desactivar speed
speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedButton.Text = "Toggle Speed: " .. (speedEnabled and "ON" or "OFF")
	if speedEnabled then
		Humanoid.WalkSpeed = 100
	else
		Humanoid.WalkSpeed = 16
	end
end)

-- Evitar que WalkSpeed se resetee
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	if speedEnabled and Humanoid.WalkSpeed ~= 100 then
		Humanoid.WalkSpeed = 100
	end
end)
