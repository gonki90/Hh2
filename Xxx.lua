-- Legends of Speed – ModMenu Pro (Android Touch & Scroll)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Función para obtener Character actualizado
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- Flags globales
local flags = {
    autoRunOrbs = false,
    autoGems = false,
    teleportZones = false,
    speedHack = false,
    superJump = false,
    noclip = false,
    godMode = false,
    antiLag = false,
    bypassZones = false,
    autoRebirth = false,
    autoBuyCrystals = false,
    fly = false
}

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LoS_ModMenu"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Botón flotante
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(0,60,0,60)
dragButton.Position = UDim2.new(0,20,0.5,-30)
dragButton.BackgroundColor3 = Color3.fromRGB(15,15,15)
dragButton.Text = "≡"
dragButton.TextColor3 = Color3.new(1,1,1)
dragButton.TextScaled = true
dragButton.ZIndex = 10
dragButton.Parent = gui

-- ScrollFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0,240,0,350)
scrollFrame.Position = UDim2.new(0,100,0.5,-175)
scrollFrame.CanvasSize = UDim2.new(0,0,0,800)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
scrollFrame.Visible = false
scrollFrame.ZIndex = 9
scrollFrame.Parent = gui

-- Holder de botones
local holder = Instance.new("Frame", scrollFrame)
holder.Size = UDim2.new(1,0,0,800)
holder.BackgroundTransparency = 1

-- Contador botones
local btnCount = 0
local function createToggle(name, callback)
    btnCount += 1
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,(btnCount-1)*45)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = name .. ": OFF"
    b.TextScaled = true
    b.Parent = holder
    b.ZIndex = 10
    b.MouseButton1Click:Connect(function()
        flags[name] = not flags[name]
        b.Text = name .. ": " .. (flags[name] and "ON" or "OFF")
        callback(flags[name])
    end)
end

-- Refs al personaje
local Character, Humanoid, HRP = getCharacter(), nil, nil
local function refreshChar()
    Character = getCharacter()
    Humanoid = Character:WaitForChild("Humanoid")
    HRP = Character:WaitForChild("HumanoidRootPart")
end
LocalPlayer.CharacterAdded:Connect(refreshChar)
refreshChar()

-- Implementación de funcionalidades

-- Auto run through orbs
spawn(function()
    while true do
        task.wait(0.6)
        if flags.autoRunOrbs and HRP then
            for _, orb in ipairs(workspace:GetDescendants()) do
                if orb.Name:lower():find("orb") then
                    HRP.CFrame = orb.CFrame + Vector3.new(0,2,0)
                    task.wait(0.15)
                end
            end
        end
    end
end)

-- Auto collect gems
spawn(function()
    while true do
        task.wait(1)
        if flags.autoGems and HRP then
            for _, gem in ipairs(workspace:GetDescendants()) do
                if gem.Name:lower():find("gem") and gem:IsA("TouchTransmitter") then
                    firetouchinterest(HRP, gem.Parent, 0)
                    firetouchinterest(HRP, gem.Parent, 1)
                end
            end
        end
    end
end)

-- Teleport zones (predefinir zonas si conoces sus CFrames)
local zones = {
    ["Spawn"] = CFrame.new(0,10,0),
    ["Race"] = CFrame.new(100,5,100),
    ["Shop"] = CFrame.new(50,5,-30)
}

createToggle("teleportZones", function(on)
    if on then
        for name, cf in pairs(zones) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-40,0,30)
            btn.Position = UDim2.new(0,20,0,btnCount*45 + 10)
            btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Text = "TP: " .. name
            btn.TextScaled = true
            btn.Parent = holder
            btn.ZIndex = 10
            btn.MouseButton1Click:Connect(function()
                if HRP then HRP.CFrame = cf end
            end)
            btnCount += 1
        end
    else
        -- podés reiniciar el menú aquí si querés
    end
end)

-- Speed hack
createToggle("speedHack", function(on)
    spawn(function()
        while on and Humanoid do
            Humanoid.WalkSpeed = 200
            task.wait(0.1)
        end
        if Humanoid then Humanoid.WalkSpeed = 16 end
    end)
end)

-- Super Jump
createToggle("superJump", function(on)
    Humanoid.JumpPower = on and 150 or 50
end)

-- Noclip
createToggle("noclip", function(on)
    spawn(function()
        while on do
            local char = getCharacter()
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                    p.Velocity = Vector3.new()
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- God mode ante caídas
createToggle("godMode", function(on)
    if on then
        Humanoid.Health = Humanoid.MaxHealth
        Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if flags.godMode and Humanoid.Health < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    end
end)

-- AntiLag: reducir gráficos de partículas u objetos pesados
createToggle("antiLag", function(on)
    if on then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Beam") then
                v.Enabled = false
            end
        end
    end
end)

-- Bypass zonas
createToggle("bypassZones", function(on)
    spawn(function()
        while on do
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.BrickColor == BrickColor.Red() then
                    v.CanCollide = false
                    v.Transparency = 0.6
                end
            end
            task.wait(0.2)
        end
    end)
end)

-- AutoRebirth (ejecutar rebirth API del juego)
createToggle("autoRebirth", function(on)
    spawn(function()
        while on do
            -- Reemplaza con call correcto del juego
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Rebirth:FireServer()
            end)
            task.wait(5)
        end
    end)
end)

-- AutoBuy Crystals (igualmente via eventos del juego)
createToggle("autoBuyCrystals", function(on)
    spawn(function()
        while on do
            pcall(function()
                game:GetService("ReplicatedStorage").Events.BuyCrystal:FireServer("Basic")
            end)
            task.wait(10)
        end
    end)
end)

-- Fly
createToggle("fly", function(on)
    if on and HRP then
        local flyLoop; flyLoop = RunService.Heartbeat:Connect(function()
            HRP.CFrame = HRP.CFrame * CFrame.new(0,0, (UIS:IsKeyDown(Enum.KeyCode.W) and 2 or 0))
        end)
        flags.flyLoop = flyLoop
    else
        if flags.flyLoop then flags.flyLoop:Disconnect() end
    end
end)

-- Crear botones mediante createToggle
createToggle("autoRunOrbs", function(_) end)
createToggle("autoGems", function(_) end)
createToggle("speedHack", function(_) end)
createToggle("superJump", function(_) end)
createToggle("noclip", function(_) end)
createToggle("godMode", function(_) end)
createToggle("antiLag", function(_) end)
createToggle("bypassZones", function(_) end)
createToggle("autoRebirth", function(_) end)
createToggle("autoBuyCrystals", function(_) end)
createToggle("fly", function(_) end)

-- Botón reset
btnCount += 1
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1,-20,0,40)
resetBtn.Position = UDim2.new(0,10,0,(btnCount-1)*45)
resetBtn.BackgroundColor3 = Color3.fromRGB(90,20,20)
resetBtn.TextColor3 = Color3.new(1,1,1)
resetBtn.Text = "Reset Character"
resetBtn.TextScaled = true
resetBtn.Parent = holder
resetBtn.ZIndex = 10
resetBtn.MouseButton1Click:Connect(function()
    LocalPlayer:LoadCharacter()
end)

-- Arrastrar botón y toggle visibility
local dragging, dragInput, dragStart, startPos
local function clamp(x,y)
    local sw,sh = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
    local bw,bh = dragButton.AbsoluteSize.X, dragButton.AbsoluteSize.Y
    return math.clamp(x,0,sw-bw), math.clamp(y,0,sh-bh)
end
local function update(input)
    local delta = input.Position - dragStart
    local x,y = clamp(startPos.X+delta.X, startPos.Y+delta.Y)
    dragButton.Position = UDim2.new(0,x,0,y)
end
dragButton.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=input.Position; startPos=dragButton.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
dragButton.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement then
        dragInput=input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input==dragInput and dragging then update(input) end
end)
dragButton.MouseButton1Click:Connect(function()
    scrollFrame.Visible = not scrollFrame.Visible
end)
