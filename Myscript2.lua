-- Mod Menú Ultra OP Legends of Speed - Auto farm +500 pasos y gemas con toggles (Android Touch + Scroll)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Flags para activar/desactivar
local flags = {
    farmSteps = false,
    farmGems = false
}

-- GUI base
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "UltraOPFarmMenu"
gui.ResetOnSpawn = false

-- Botón flotante para abrir/cerrar menú
local dragButton = Instance.new("TextButton", gui)
dragButton.Size = UDim2.new(0, 50, 0, 50)
dragButton.Position = UDim2.new(0, 20, 0.5, -25)
dragButton.BackgroundColor3 = Color3.new(0, 0, 0)
dragButton.Text = "≡"
dragButton.TextColor3 = Color3.new(1, 1, 1)
dragButton.TextScaled = true
dragButton.ZIndex = 10

-- Scroll Frame para opciones
local scrollFrame = Instance.new("ScrollingFrame", gui)
scrollFrame.Size = UDim2.new(0, 200, 0, 150)
scrollFrame.Position = UDim2.new(0, 80, 0.5, -75)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
scrollFrame.ScrollBarThickness = 4
scrollFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
scrollFrame.Visible = false
scrollFrame.ZIndex = 9

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, (#scrollFrame:GetChildren() - 1) * 45)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name .. ": OFF"
    btn.TextScaled = true
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        flags[name] = not flags[name]
        btn.Text = name .. ": " .. (flags[name] and "ON" or "OFF")
        callback(flags[name])
    end)
end

local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function tpTo(obj)
    local char = getChar()
    local HRP = char:WaitForChild("HumanoidRootPart")
    if obj and obj:IsA("BasePart") then
        HRP.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
    end
end

-- Auto farm pasos +500
spawn(function()
    while true do
        task.wait(0.2)
        if flags.farmSteps then
            local char = getChar()
            local HRP = char:WaitForChild("HumanoidRootPart")
            for _, orb in pairs(workspace:GetDescendants()) do
                if orb.Name:match("%+500") and orb:IsA("BasePart") then
                    tpTo(orb)
                    task.wait(0.15)
                end
            end
        else
            task.wait(0.5)
        end
    end
end)

-- Auto farm gemas
spawn(function()
    while true do
        task.wait(0.3)
        if flags.farmGems then
            local char = getChar()
            local HRP = char:WaitForChild("HumanoidRootPart")
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent.Name:lower():find("gem") then
                    firetouchinterest(HRP, v.Parent, 0)
                    firetouchinterest(HRP, v.Parent, 1)
                    task.wait(0.1)
                end
            end
        else
            task.wait(0.5)
        end
    end
end)

-- Dragging funcional para botón
local dragging, dragInput, dragStart, startPos
local function clamp(x,y)
    local sw, sh = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
    local bw, bh = dragButton.AbsoluteSize.X, dragButton.AbsoluteSize.Y
    return math.clamp(x, 0, sw - bw), math.clamp(y, 0, sh - bh)
end
local function update(input)
    local delta = input.Position - dragStart
    local x, y = clamp(startPos.X + delta.X, startPos.Y + delta.Y)
    dragButton.Position = UDim2.new(0, x, 0, y)
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

-- Crear botones toggle
createToggle("farmSteps", function(_) end)
createToggle("farmGems", function(_) end)
