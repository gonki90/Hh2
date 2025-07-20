-- MOD MENU COMPLETO ANDROID (Touch + Scroll) Mejorado
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local flags = {
    noclip = false,
    speed = false,
    autoCollect = false,
    autoBuy = false,
    killAura = false,
    godMode = false,
    bypassZones = false
}

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenuPro"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Botón flotante (abrir/cerrar) ajustado para que quede accesible y no se salga
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(0, 50, 0, 50)
dragButton.Position = UDim2.new(0, 20, 0.5, -25)
dragButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dragButton.Text = "≡"
dragButton.TextColor3 = Color3.new(1, 1, 1)
dragButton.TextScaled = true
dragButton.ZIndex = 10
dragButton.Parent = gui

-- Marco con scroll mejorado para pantallas Android
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 220, 0, 300)
scrollFrame.Position = UDim2.new(0, 80, 0.5, -150)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.Visible = false
scrollFrame.ZIndex = 9
scrollFrame.Parent = gui

-- Contenedor para botones para mejor control de layout
local buttonsHolder = Instance.new("Frame")
buttonsHolder.Size = UDim2.new(1, 0, 0, 600)
buttonsHolder.BackgroundTransparency = 1
buttonsHolder.Parent = scrollFrame

local buttonCount = 0
local function createToggle(name, callback)
    buttonCount += 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, (buttonCount - 1) * 45)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name .. ": OFF"
    btn.TextScaled = true
    btn.Parent = buttonsHolder
    btn.ZIndex = 10

    btn.MouseButton1Click:Connect(function()
        flags[name] = not flags[name]
        btn.Text = name .. ": " .. (flags[name] and "ON" or "OFF")
        callback(flags[name])
    end)
end

-- Variables actualizadas por personaje
local function updateCharacter()
    local character = getCharacter()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    return character, humanoid, hrp
end

-- Variables globales de personaje
local Character, Humanoid, HRP = updateCharacter()

-- Reconectar cuando respawnea
LocalPlayer.CharacterAdded:Connect(function(char)
    Character, Humanoid, HRP = updateCharacter()
end)

-- Noclip loop mejorado, desactivando física de colisiones y bloqueando empujones
RunService.Stepped:Connect(function()
    if flags.noclip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                -- Resetear velocidad lineal para evitar empujones
                if part:IsA("BasePart") and part.Velocity.Magnitude > 0 then
                    part.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    elseif Character then
        -- Volver a activar colisiones cuando noclip está OFF
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Speed loop con fallback para evitar bugs si Humanoid no existe (seguro)
RunService.Heartbeat:Connect(function()
    if Humanoid then
        Humanoid.WalkSpeed = flags.speed and 100 or 16
    end
end)

-- Auto Collect
spawn(function()
    while true do
        task.wait(0.5)
        if flags.autoCollect and HRP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("collect") then
                    firetouchinterest(HRP, v.Parent, 0)
                    firetouchinterest(HRP, v.Parent, 1)
                end
            end
        else
            task.wait(1)
        end
    end
end)

-- Auto Buy
spawn(function()
    while true do
        task.wait(1)
        if flags.autoBuy and HRP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("buy") then
                    firetouchinterest(HRP, v.Parent, 0)
                    firetouchinterest(HRP, v.Parent, 1)
                end
            end
        else
            task.wait(1)
        end
    end
end)

-- Kill Aura
spawn(function()
    while true do
        task.wait(0.3)
        if flags.killAura then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local pHumanoid = p.Character:FindFirstChild("Humanoid")
                    if pHumanoid and pHumanoid.Health > 0 then
                        pHumanoid.Health = 0
                    end
                end
            end
        else
            task.wait(1)
        end
    end
end)

-- God Mode
if Humanoid then
    Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if flags.godMode and Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
end

-- Bypass barreras rojas más robusto
RunService.Heartbeat:Connect(function()
    if flags.bypassZones then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide and (v.BrickColor == BrickColor.Red() or v.Name:lower():find("barrier") or v.Transparency < 1) then
                v.CanCollide = false
                v.Transparency = 0.8
            end
        end
    end
end)

-- Teleport a base (mejorado para evitar errores)
local function teleportToBase()
    local tycoon = workspace:FindFirstChild(LocalPlayer.Name.."'s Tycoon")
    if tycoon and tycoon:FindFirstChild("SpawnLocation") and HRP then
        HRP.CFrame = tycoon.SpawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
end

-- Crear botones toggle
createToggle("noclip", function(_) end)
createToggle("speed", function(_) end)
createToggle("autoCollect", function(_) end)
createToggle("autoBuy", function(_) end)
createToggle("killAura", function(_) end)
createToggle("godMode", function(_) end)
createToggle("bypassZones", function(_) end)

-- Botón TP extra
buttonCount += 1
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, (buttonCount - 1) * 45)
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Text = "TP to Base"
tpBtn.TextScaled = true
tpBtn.ZIndex = 10
tpBtn.Parent = buttonsHolder
tpBtn.MouseButton1Click:Connect(teleportToBase)

-- Función para limitar posición al arrastrar (no salirse de pantalla)
local dragging, dragInput, dragStart, startPos

local function clampPosition(posX, posY)
    local screenW, screenH = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
    local btnW, btnH = dragButton.AbsoluteSize.X, dragButton.AbsoluteSize.Y

    local x = math.clamp(posX, 0, screenW - btnW)
    local y = math.clamp(posY, 0, screenH - btnH)
    return x, y
end

local function update(input)
    local delta = input.Position - dragStart
    local newX, newY = clampPosition(startPos.X + delta.X, startPos.Y + delta.Y)
    dragButton.Position = UDim2.new(0, newX, 0, newY)
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

-- Mostrar / ocultar menú con botón
dragButton.MouseButton1Click:Connect(function()
    scrollFrame.Visible = not scrollFrame.Visible
end)
