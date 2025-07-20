-- MOD MENU COMPLETO ANDROID (Touch + Scroll)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Estados
local flags = {
    noclip = false,
    speed = false,
    autoCollect = false,
    autoBuy = false,
    killAura = false,
    godMode = false,
    bypassZones = false
}

-- GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "ModMenuPro"

-- Botón flotante (abrir/cerrar)
local dragButton = Instance.new("TextButton", gui)
dragButton.Size = UDim2.new(0, 50, 0, 50)
dragButton.Position = UDim2.new(0, 20, 0.5, -25)
dragButton.BackgroundColor3 = Color3.new(0, 0, 0)
dragButton.Text = "≡"
dragButton.TextColor3 = Color3.new(1, 1, 1)
dragButton.TextScaled = true
dragButton.ZIndex = 10

-- Marco con scroll
local scrollFrame = Instance.new("ScrollingFrame", gui)
scrollFrame.Size = UDim2.new(0, 200, 0, 260)
scrollFrame.Position = UDim2.new(0, 80, 0.5, -130)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.ScrollBarThickness = 4
scrollFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
scrollFrame.Visible = false
scrollFrame.ZIndex = 9

-- Función para crear botones del menú
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, (#scrollFrame:GetChildren() - 1) * 45)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name .. ": OFF"
    btn.TextScaled = true
    btn.Parent = scrollFrame
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        flags[name] = not flags[name]
        btn.Text = name .. ": " .. (flags[name] and "ON" or "OFF")
        callback(flags[name])
    end)
end

-- Noclip loop
RunService.Stepped:Connect(function()
    if flags.noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- Speed loop
RunService.Heartbeat:Connect(function()
    if flags.speed then
        Humanoid.WalkSpeed = 100
    else
        Humanoid.WalkSpeed = 16
    end
end)

-- Auto Collect
spawn(function()
    while true do
        task.wait(0.5)
        if flags.autoCollect then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("collect") then
                    firetouchinterest(HRP, v.Parent, 0)
                    firetouchinterest(HRP, v.Parent, 1)
                end
            end
        end
    end
end)

-- Auto Buy
spawn(function()
    while true do
        task.wait(1)
        if flags.autoBuy then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("buy") then
                    firetouchinterest(HRP, v.Parent, 0)
                    firetouchinterest(HRP, v.Parent, 1)
                end
            end
        end
    end
end)

-- Kill Aura
spawn(function()
    while true do
        task.wait(0.3)
        if flags.killAura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid.Health = 0
                end
            end
        end
    end
end)

-- God Mode
Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
    if flags.godMode and Humanoid.Health < 100 then
        Humanoid.Health = 100
    end
end)

-- Bypass barreras rojas
RunService.Heartbeat:Connect(function()
    if flags.bypassZones then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide and v.BrickColor == BrickColor.Red() then
                v.CanCollide = false
                v.Transparency = 0.8
            end
        end
    end
end)

-- TP a base (simple versión)
local function teleportToBase()
    if workspace:FindFirstChild(LocalPlayer.Name.."'s Tycoon") then
        HRP.CFrame = workspace[LocalPlayer.Name.."'s Tycoon"].SpawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
end

-- Añadir botones
createToggle("noclip", function(_) end)
createToggle("speed", function(_) end)
createToggle("autoCollect", function(_) end)
createToggle("autoBuy", function(_) end)
createToggle("killAura", function(_) end)
createToggle("godMode", function(_) end)
createToggle("bypassZones", function(_) end)

-- TP Button extra
local tpBtn = Instance.new("TextButton", scrollFrame)
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, (#scrollFrame:GetChildren() - 1) * 45)
tpBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Text = "TP to Base"
tpBtn.TextScaled = true
tpBtn.ZIndex = 10
tpBtn.MouseButton1Click:Connect(teleportToBase)

-- Drag funcional
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    dragButton.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
end

dragButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = dragButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

dragButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- Toggle menú
dragButton.MouseButton1Click:Connect(function()
    scrollFrame.Visible = not scrollFrame.Visible
end)
