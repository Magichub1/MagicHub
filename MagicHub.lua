local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем основной GUI
local MagicHub = Instance.new("ScreenGui")
MagicHub.Name = "MagicHub"
MagicHub.ResetOnSpawn = false

-- Кружочек-кнопка для открытия (черный фон, переливающаяся обводка)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Черный фон
ToggleButton.Text = ""
ToggleButton.BorderSizePixel = 0
ToggleButton.ZIndex = 10

-- Обводка для кнопки с анимацией
local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ButtonStroke.Color = Color3.fromRGB(255, 255, 0)
ButtonStroke.Thickness = 3
ButtonStroke.Parent = ToggleButton

-- Анимация переливания обводки (бело-желтая)
local buttonAnimation
buttonAnimation = RunService.Heartbeat:Connect(function()
    local time = tick() * 2
    local intensity = (math.sin(time) + 1) / 2  -- от 0 до 1
    -- Переход между желтым (1,1,0) и белым (1,1,1)
    local r = 1
    local g = 1
    local b = intensity  -- от 0 (желтый) до 1 (белый)
    ButtonStroke.Color = Color3.new(r, g, b)
end)

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = ToggleButton

-- Главный фрейм (изначально скрыт)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0, 80, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 5

-- Обводка с градиентом для главного фрейма
local MainStroke = Instance.new("UIStroke")
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Color = Color3.fromRGB(255, 255, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Анимация переливания для главного фрейма
local mainAnimation
mainAnimation = RunService.Heartbeat:Connect(function()
    local time = tick() * 2
    local intensity = (math.sin(time) + 1) / 2
    local r = 1
    local g = 1
    local b = intensity
    MainStroke.Color = Color3.new(r, g, b)
end)

-- Скругление углов для главного фрейма
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 6

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Название хаба
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Magic Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 7
Title.Parent = TopBar

-- Боковое меню
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 80, 0, 165)
SideBar.Position = UDim2.new(0, 0, 0, 35)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.BorderSizePixel = 0
SideBar.ZIndex = 6

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SideBar

-- Кнопки разделов
local buttons = {"Main", "Movement", "Visuals"}
local currentPage = "Main"

for i, buttonName in pairs(buttons) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 28)
    Button.Position = UDim2.new(0, 5, 0, 8 + (i-1)*32)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Button.BorderSizePixel = 0
    Button.Text = buttonName
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.Gotham
    Button.ZIndex = 7
    Button.
Parent = SideBar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Анимация при наведении
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        if currentPage ~= buttonName then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        currentPage = buttonName
        updateContent(buttonName)
    end)
end

-- Область контента
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 210, 0, 165)
ContentFrame.Position = UDim2.new(0, 90, 0, 35)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ContentFrame.BorderSizePixel = 0
ContentFrame.ZIndex = 6

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

-- Функция для обновления контента
function updateContent(page)
    -- Очищаем контент
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    if page == "Visuals" then
        -- Кнопка ESP Player
        local EspButton = Instance.new("TextButton")
        EspButton.Size = UDim2.new(1, -20, 0, 30)
        EspButton.Position = UDim2.new(0, 10, 0, 10)
        EspButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        EspButton.BorderSizePixel = 0
        EspButton.Text = "ESP Player"
        EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        EspButton.TextSize = 14
        EspButton.Font = Enum.Font.Gotham
        EspButton.ZIndex = 7
        EspButton.Parent = ContentFrame
        
        local EspCorner = Instance.new("UICorner")
        EspCorner.CornerRadius = UDim.new(0, 6)
        EspCorner.Parent = EspButton
        
        local espEnabled = false
        local espHighlights = {}
        
        EspButton.MouseButton1Click:Connect(function()
            espEnabled = not espEnabled
            
            if espEnabled then
                EspButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                EspButton.Text = "ESP Player: ON"
                startESP()
            else
                EspButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                EspButton.Text = "ESP Player"
                stopESP()
            end
        end)
        
        function startESP()
            -- Создаем Highlight для существующих игроков
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    createHighlight(otherPlayer.Character)
                end
            end
            
            -- Обработчик для новых игроков
            Players.PlayerAdded:Connect(function(otherPlayer)
                otherPlayer.CharacterAdded:Connect(function(character)
                    if espEnabled then
                        createHighlight(character)
                    end
                end)
            end)
            
            -- Обработчик для удаления Highlight при выходе игрока
            Players.PlayerRemoving:Connect(function(otherPlayer)
                if espHighlights[otherPlayer] then
                    espHighlights[otherPlayer]:Destroy()
                    espHighlights[otherPlayer] = nil
                end
            end)
        end
        
        function stopESP()
            for _, highlight in pairs(espHighlights) do
                highlight:Destroy()
            end
            espHighlights = {}
        end
        
        function createHighlight(character)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local highlight = Instance.new("Highlight")
                highlight.
FillColor = Color3.fromRGB(255, 255, 0) -- Желтый цвет
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.OutlineTransparency = 0
                highlight.Parent = character
                
                espHighlights[character] = highlight
                
                -- Удаляем Highlight при смерти/удалении персонажа
                character.Destroying:Connect(function()
                    if highlight then
                        highlight:Destroy()
                    end
                end)
            end
        end
    end
end

-- Функция переключения видимости меню
local isMenuOpen = false

ToggleButton.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    MainFrame.Visible = isMenuOpen
end)

-- Функция перемещения кнопки
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Собираем всё вместе
TopBar.Parent = MainFrame
SideBar.Parent = MainFrame
ContentFrame.Parent = MainFrame
MainFrame.Parent = MagicHub
ToggleButton.Parent = MagicHub
MagicHub.Parent = playerGui

-- Инициализируем контент
updateContent("Main")

print("Magic Hub loaded! Click the circle to open/close menu")
