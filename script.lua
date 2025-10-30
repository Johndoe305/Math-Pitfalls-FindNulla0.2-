-- 🎮Math Pitfalls / @Find Nulla0.2 
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Configurações
local PLAYER_NAME = Players.LocalPlayer.Name
local REVIVE_REMOTE = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):FindFirstChild("Revive")
local TITLE_REMOTE = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):FindFirstChild("UseTitle")

-- === ScreenGui ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MathOrDieGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- === Frame principal (drag) ===
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200) -- Aumentado para acomodar TextBox e dois botões
frame.Position = UDim2.new(0.5, -100, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Cinza escuro
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0 -- Sem borda
frame.Parent = screenGui

-- === Título ===
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0) -- Ajustado para mais espaço
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Math Pitfalls"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- === TextBox para Tag ===
local tagTextBox = Instance.new("TextBox")
tagTextBox.Size = UDim2.new(0.8, 0, 0.2, 0)
tagTextBox.Position = UDim2.new(0.1, 0, 0.25, 0)
tagTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Cinza mais claro
tagTextBox.TextColor3 = Color3.new(1, 1, 1)
tagTextBox.PlaceholderText = "Tag (ex.: novisual)"
tagTextBox.Text = "novisual"
tagTextBox.Font = Enum.Font.SourceSansBold
tagTextBox.TextScaled = true
tagTextBox.TextWrapped = true
tagTextBox.Parent = frame

-- === Botão Tag ===
local tagButton = Instance.new("TextButton")
tagButton.Size = UDim2.new(0.7, 0, 0.2, 0)
tagButton.Position = UDim2.new(0.1, 0, 0.5, 0)
tagButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250) -- Azul
tagButton.Text = "Ativar Tag"
tagButton.TextColor3 = Color3.new(1, 1, 1)
tagButton.TextScaled = true
tagButton.Font = Enum.Font.SourceSansBold
tagButton.Parent = frame

-- === Botão Revive ===
local reviveButton = Instance.new("TextButton")
reviveButton.Size = UDim2.new(0.7, 0, 0.2, 0)
reviveButton.Position = UDim2.new(0.1, 0, 0.75, 0)
reviveButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Vermelho
reviveButton.Text = "Revive Now"
reviveButton.TextColor3 = Color3.new(1, 1, 1)
reviveButton.TextScaled = true
reviveButton.Font = Enum.Font.SourceSansBold
reviveButton.Parent = frame

-- === DRAG MOBILE/PC ===
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- === EFEITOS DE HOVER (PC) ===
if UserInputService.MouseEnabled then
    tagButton.MouseEnter:Connect(function()
        tagButton.BackgroundColor3 = Color3.fromRGB(70, 170, 255)
    end)
    tagButton.MouseLeave:Connect(function()
        tagButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    end)
    reviveButton.MouseEnter:Connect(function()
        reviveButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    end)
    reviveButton.MouseLeave:Connect(function()
        reviveButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
end

-- === AJUSTE PARA MOBILE ===
if UserInputService.TouchEnabled then
    frame.Size = UDim2.new(0, 240, 0, 240)
    tagTextBox.TextSize = 10
    tagButton.TextSize = 10
    reviveButton.TextSize = 10
end

-- === AÇÕES DOS BOTÕES ===
-- Botão Tag
tagButton.MouseButton1Click:Connect(function()
    if TITLE_REMOTE then
        local tagText = tagTextBox.Text
        if tagText == "" then
            tagText = "novisual" -- Default se vazio
        end
        pcall(function()
            TITLE_REMOTE:FireServer(tagText)
            title.Text = "Tag '" .. tagText .. "' enviada!"
            print("✅ Título enviado: " .. tagText)
            wait(2)
            title.Text = "Math Pitfalls"
        end)
    else
        title.Text = "UseTitle não encontrado!"
        warn("❌ RemoteEvent 'UseTitle' não encontrado.")
        wait(2)
        title.Text = "Math Pitfalls"
    end
end)

-- Botão Revive
reviveButton.MouseButton1Click:Connect(function()
    if REVIVE_REMOTE then
        pcall(function()
            REVIVE_REMOTE:FireServer()
            title.Text = "Revive enviado!"
            print("✅ Revive enviado!")
            wait(2)
            title.Text = "Math Pitfalls"
        end)
    else
        title.Text = "Revive não encontrado!"
        warn("❌ RemoteEvent 'Revive' não encontrado.")
        wait(2)
        title.Text = "Math Pitfalls"
    end
end)

-- Debug inicial
print("=== DEBUG INICIAL ===")
print("Verificando RemoteEvents:")
for _, r in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
    if r:IsA("RemoteEvent") then
        print(r:GetFullName())
    end
end
print("Sistema Math or Die v2.2 carregado para " .. PLAYER_NAME .. " em " .. os.date("%H:%M:%S %d/%m/%Y"))
