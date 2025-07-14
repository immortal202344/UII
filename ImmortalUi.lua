loadstring(game:HttpGet('https://sirius.menu/sirius'))()
wait(3)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Rayfield",
   LoadingTitle = "Rayfield Ui",
   LoadingSubtitle = "by Immortal",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = ImmortalUI, -- Create a custom folder for your hub/game
      FileName = "RayFlield"
   },
   Discord = {
      Enabled = true,
      Invite = "https://t.me/Xsoqqviperr", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = True, -- Set this to true to use our key system
   KeySettings = {
      Title = "Immortal secure",
      Subtitle = "Key System",
      Note = "Join Telegram chanel https://t.me/Xsoqqviperr",
      FileName = "Immortalll", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"ImmortalTheBest"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Aimlock")

local Toggle = Tab:CreateToggle({
   Name = "AimLock",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(state)
    if state then
        -- Enable Script
_G.AimBotEnabled = true

local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local user = players.LocalPlayer
local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local predictionFactor, aimSpeed = 0.042, 10
local holding = false

if not user then return warn("LocalPlayer не найден!") end

-- Создаем FOV круг
if not _G.FOVCircle then
    _G.FOVCircle = Drawing.new("Circle")
    _G.FOVCircle.Radius, _G.FOVCircle.Filled, _G.FOVCircle.Thickness = 200, false, 1 -- Начальный радиус: 200
    _G.FOVCircle.Color, _G.FOVCircle.Transparency, _G.FOVCircle.Visible = Color3.new(1, 1, 1), 0.7, true
end

-- Получение ближайшего игрока
local function getClosestPlayer()
    local closest, minDist = nil, math.huge
    local currentRadius = _G.FOVCircle and _G.FOVCircle.Radius or 200 -- Используем текущий радиус FOV
    for _, player in pairs(players:GetPlayers()) do
        if player ~= user and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local head = player.Character:FindFirstChild("Head")
            local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - inputService:GetMouseLocation()).Magnitude
            if onScreen and distance <= currentRadius and distance < minDist then
                closest, minDist = player, distance
            end
        end
    end
    return closest
end

-- Предсказание позиции
local function predictHead(target)
    local head = target.Character.Head
    local velocity = target.Character.HumanoidRootPart.AssemblyLinearVelocity or Vector3.zero
    return head.Position + velocity * predictionFactor
end

-- Обработчики ввода
inputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holding = true end
end)

inputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holding = false end
end)

-- Основной цикл
runService.RenderStepped:Connect(function()
    if not _G.AimBotEnabled then return end
    if _G.FOVCircle then
        _G.FOVCircle.Position = inputService:GetMouseLocation()
    end
    if holding then
        local target = getClosestPlayer()
        if target then
            local predicted = predictHead(target)
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, predicted), aimSpeed * 0.1)
        end
    end
end)
    else
        -- Disable Script
_G.AimBotEnabled = false -- Отключаем функционал аимбота

-- Удаляем FOV круг, если он существует
if _G.FOVCircle then
    _G.FOVCircle:Remove() -- Удаляем объект
    _G.FOVCircle = nil    -- Очищаем переменную
end

-- Очищаем глобальные переменные, если требуется
_G.PredictionFactor = nil
_G.AimSpeed = nil
    end
   end,
})

local Input = Tab:CreateInput({
   Name = "AimLock Fov",
   PlaceholderText = "FOV Radius set to:",
   RemoveTextAfterFocusLost = false,
   Callback = function(txt)
-- Настройка FOV через текстбокс
    local newRadius = tonumber(txt) -- Преобразуем введенный текст в число
    if newRadius and _G.FOVCircle then
        _G.FOVCircle.Radius = math.clamp(newRadius, 10, 500) -- Ограничиваем значение от 10 до 500
        print("FOV Radius set to:", _G.FOVCircle.Radius)
    else
        warn("Invalid input! Please enter a number.")
    end
   end,
})

-- Define spinSpeed at a higher scope so both toggle and slider can access it
local spinSpeed = 10
local spinConnection = nil

local function startSpinning()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:WaitForChild("HumanoidRootPart", 1)
    if not rootPart then
        warn("HumanoidRootPart not found!")
        return
    end
    
    -- Disconnect any existing connection to prevent duplicates
    if spinConnection then
        spinConnection:Disconnect()
    end
    
    spinConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed * deltaTime * 60), 0)
    end)
end

local function stopSpinning()
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
end

-- Create the toggle
local Toggle = Tab:CreateToggle({
    Name = "Spin-Bot",
    CurrentValue = false,
    Flag = "SpinToggle",
    Callback = function(Enabled)
        if Enabled then
            -- Handle existing character
            if game.Players.LocalPlayer.Character then
                startSpinning()
            end
            -- Set up future characters
            game.Players.LocalPlayer.CharacterAdded:Connect(function()
                if Toggle.CurrentValue then
                    startSpinning()
                end
            end)
        else
            stopSpinning()
        end
    end
})

-- Create the speed slider
local Slider = Tab:CreateSlider({
    Name = "Spin-Bot Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "° per second",
    CurrentValue = spinSpeed,
    Flag = "SpinSpeed",
    Callback = function(Value)
        spinSpeed = Value
        -- If spinning is active, restart with new speed
        if Toggle.CurrentValue then
            startSpinning()
        end
    end
})

local Section = Tab:CreateSection("MainTabs")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- UI Toggle (добавьте в вашу UI систему)
local Toggle = Tab:CreateToggle({
    Name = "Bunnyhop",
    CurrentValue = false,
    Flag = "AirBoostToggle",
    Callback = function(Value)
        -- Включаем/выключаем систему ускорения
        _G.AirBoostEnabled = Value
    end
})

-- Основные настройки
local BASE_WALK_SPEED = 16
local AIR_BOOST_SPEED = 40
local BOOST_FORCE = 90
local BOOST_COOLDOWN = 0.1
local JUMP_POWER = 50

-- Инициализация персонажа
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    humanoid.WalkSpeed = BASE_WALK_SPEED
    humanoid.JumpPower = JUMP_POWER
    
    local isSpacePressed = false
    local isGrounded = false
    local lastBoostTime = 0

    -- Проверка земли
    local function checkIfGrounded()
        if not rootPart then return false end
        
        local rayOrigin = rootPart.Position
        local rayDirection = Vector3.new(0, -3.5, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        return workspace:Raycast(rayOrigin, rayDirection, raycastParams) ~= nil
    end

    -- Обновление скорости
    local function updateSpeed()
        if not humanoid then return end
        
        if isSpacePressed and _G.AirBoostEnabled then
            humanoid.WalkSpeed = isGrounded and BASE_WALK_SPEED or AIR_BOOST_SPEED
        else
            humanoid.WalkSpeed = BASE_WALK_SPEED
        end
    end

    -- Система ускорения
    local function boostLoop()
        while isSpacePressed and humanoid and rootPart and _G.AirBoostEnabled do
            isGrounded = checkIfGrounded()
            updateSpeed()
            
            if not isGrounded and os.clock() - lastBoostTime > BOOST_COOLDOWN then
                local direction = rootPart.CFrame.LookVector
                rootPart:ApplyImpulse(direction * BOOST_FORCE)
                lastBoostTime = os.clock()
            end
            
            task.wait()
        end
    end

    -- Обработка ввода
    local spaceConnection
    spaceConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
            isSpacePressed = true
            if _G.AirBoostEnabled then
                boostLoop()
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space then
            isSpacePressed = false
            updateSpeed()
        end
    end)

    -- Очистка при смерти
    humanoid.Died:Connect(function()
        spaceConnection:Disconnect()
    end)
end

-- Инициализация
player.CharacterAdded:Connect(setupCharacter)
if player.Character then
    setupCharacter(player.Character)
end

-- По умолчанию включено
_G.AirBoostEnabled = true


local UserInputService = game:GetService("UserInputService")
local jumpConnection = nil  -- Храним соединение здесь

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Храним соединение глобально
local jumpConnection = nil

local Toggle = Tab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Flag = "ToggleJump",
    Callback = function(Value)
        -- Всегда сначала отключаем предыдущее соединение
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end

        -- Если включено - создаем новое соединение
        if Value then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                local character = Players.LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState("Jumping")
                    end
                end
            end)
        end
        
    end
})

local Slider = Tab:CreateSlider({
   Name = "HipHeight",
   Range = {0, 50},
   Increment = 1,
   Suffix = "HipHeight",
   CurrentValue = 0,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(s)
game.Players.LocalPlayer.Character.Humanoid.HipHeight = s
   end,
})

local Button = Tab:CreateButton({
   Name = "AntiFling",
   Callback = function()

local Services = setmetatable({}, {__index = function(Self, Index)
    local NewService = game.GetService(game, Index)
    if NewService then
        Self[Index] = NewService
    end
    return NewService
end})

-- [ LocalPlayer ] --
local LocalPlayer = Services.Players.LocalPlayer

-- // Functions \\ --
local function PlayerAdded(Player)
    local Detected = false
    local Character;
    local PrimaryPart;

    local function CharacterAdded(NewCharacter)
        Character = NewCharacter
        repeat
            wait()
            PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
        until PrimaryPart
        Detected = false
    end

    CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
    Player.CharacterAdded:Connect(CharacterAdded)
    Services.RunService.Heartbeat:Connect(function()
        if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
            if PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                if Detected == false then
                    -- game.StarterGui:SetCore("ChatMakeSystemMessage", { -- Removed chat message
                    --     Text = "Fling Exploit detected, Player: " .. tostring(Player);
                    --     Color = Color3.fromRGB(255, 200, 0);
                    -- })
                end
                Detected = true
                for i,v in ipairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                    end
                end
                PrimaryPart.CanCollide = false
                PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
            end
        end
    end)
end

-- // Event Listeners \\ --
for i,v in ipairs(Services.Players:GetPlayers()) do
    if v ~= LocalPlayer then
        PlayerAdded(v)
    end
end
Services.Players.PlayerAdded:Connect(PlayerAdded)

local LastPosition = nil
Services.RunService.Heartbeat:Connect(function()
    pcall(function()
        local PrimaryPart = LocalPlayer.Character.PrimaryPart
        if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.CFrame = LastPosition

            -- game.StarterGui:SetCore("ChatMakeSystemMessage", { -- Removed self-fling message
            --     Text = "You were flung. Neutralizing velocity. :3";
            --     Color = Color3.fromRGB(255, 0, 0);
            -- })
        elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 then
            LastPosition = PrimaryPart.CFrame
        end
    end)
end)

   end,
})  


local Button = Tab:CreateButton({
   Name = "Float Pad",
   Callback = function()
		local name = game.Players.LocalPlayer.Name
local p = Instance.new("Part")
p.Parent = workspace
p.Locked = true
p.BrickColor = BrickColor.new("White")
p.BrickColor = BrickColor.new(104)
local pcolor = Color3.fromRGB(255, 0, 137)
p.Size = Vector3.new(8, 1.2, 8)
p.Anchored = true
local m = Instance.new("CylinderMesh")
m.Scale = Vector3.new(1, 0.5, 1)
m.Parent = p
while true do
	p.CFrame = CFrame.new(game.Players:findFirstChild(name).Character.HumanoidRootPart.CFrame.x, game.Players:findFirstChild(name).Character.HumanoidRootPart.CFrame.y - 4, game.Players:findFirstChild(name).Character.HumanoidRootPart.CFrame.z)
	wait()
end
end,
})



local Slider = Tab:CreateSlider({
   Name = "Gravity",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Gravity",
   CurrentValue = 196.2,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(s)
workspace.Gravity = s
   end,
})


local Tab = Window:CreateTab("Visual", 4483362458) -- Title, Image
local Section = Tab:CreateSection("WallHack")

local Toggle = Tab:CreateToggle({
   Name = "Chams",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(state)
    if state then
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/ChamsTeamColor/refs/heads/main/ChamsColorTeam.lua"))()
    else
        _G.ESP_Enabled = false

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    if player.Character then
        for _, v in ipairs(player.Character:GetChildren()) do
            if v:IsA("Highlight") then
                v:Destroy()
            end
        end
    end
end
    end   -- The variable (Value) is a boolean on whether the toggle is true or false
   end,
})

local Button = Tab:CreateButton({
   Name = "Skelet Esp",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/ESPSkeletMod/refs/heads/main/ESPSkelet.lua"))()
   end,
})  

local Button = Tab:CreateButton({
   Name = "Esp",
   Callback = function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/ESPteamcolor/refs/heads/main/ESP.lua"))()
   end,
})  

local Section = Tab:CreateSection("Visual")

local Slider = Tab:CreateSlider({
   Name = "Zoom",
   Range = {5, 2000},
   Increment = 5,
   Suffix = "CameraMaxZoomDistance",
   CurrentValue = 124,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(s)
    game.Players.LocalPlayer.CameraMaxZoomDistance = s
end,
})
 

local Button = Tab:CreateButton({
   Name = "Ghost",
   Callback = function()
		function nob(who,tra,hat)
c=who.Character
pcall(function()u=c["Body Colors"]
u.HeadColor=BrickColor.new("Black")
u.LeftLegColor=BrickColor.new("Black")
u.RightLegolor=BrickColor.new("Black")
u.LeftArmColor=BrickColor.new("Black")
u.TorsoColor=BrickColor.new("Black")
u.RightArmColor=BrickColor.new("Black")
end)
pcall(function()c.Shirt:Destroy() c.Pants:Destroy() end)
for i,v in pairs(c:GetChildren()) do
if v:IsA("BasePart") then
v.Transparency=tra
if v.Name=="HumanoidRootPart" or v.Name=="Head" then
v.Transparency=1
end
wait()
v.BrickColor=BrickColor.new("Black")
elseif v:IsA("Hat") then
v:Destroy()
end
end
xx=game:service("InsertService"):LoadAsset(hat)
xy=game:service("InsertService"):LoadAsset(47433)["LinkedSword"]
xy.Parent=who.Backpack
for a,hat in pairs(xx:children()) do
hat.Parent=c
end
xx:Destroy()
h=who.Character.Humanoid
h.MaxHealth=50000
wait(1.5)
h.Health=50000
h.WalkSpeed=32
end
nob(game.Players.LocalPlayer,0.6,21070012)
   end,
})  

local Button = Tab:CreateButton({
   Name = "Chiken Hand",
   Callback = function()
local Chicken = game.Players.LocalPlayer.Name
game.Workspace[Chicken].Torso["Left Shoulder"].C0 = CFrame.new(-1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(0,math.pi/2,0) * CFrame.fromEulerAnglesXYZ(math.pi/2, 0, 0) * CFrame.fromEulerAnglesXYZ(0,-math.pi/2,0)
game.Workspace[Chicken].Torso["Left Shoulder"].C1 = CFrame.new(0, 0.5, 0)
game.Workspace[Chicken].Torso["Right Shoulder"].C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(0,-math.pi/2,0) * CFrame.fromEulerAnglesXYZ(math.pi/2, 0, 0) * CFrame.fromEulerAnglesXYZ(0,-math.pi/2,0)
game.Workspace[Chicken].Torso["Right Shoulder"].C1 = CFrame.new(0, 0.5, 0)
   end,
})  

local Button = Tab:CreateButton({
   Name = "Rainbow Fog",
   Callback = function()
    basics = {Color3.new(255/255,0/255,0/255),Color3.new(255/255,85/255,0/255),Color3.new(218/255,218/255,0/255),Color3.new(0/255,190/255,0/255),Color3.new(0/255,85/255,255/255),Color3.new(0/255,0/255,127/255),Color3.new(170/255,0/255,255/255),Color3.new(0/255,204/255,204/255),Color3.new(255/255,85/255,127/255),Color3.new(0/255,0/255,0/255),Color3.new(255/255,255/255,255/255)}
game.Lighting.FogStart = 25
game.Lighting.FogEnd = 300
while true do
wait(0.5)
game.Lighting.FogColor = basics[math.random(1,#basics)]
end
   -- The function that takes place when the button is pressed
   end,
})  

local Button = Tab:CreateButton({
   Name = "Rainbow Character",
   Callback = function()
	local presets = {
    "Bright red",
    "Bright yellow",
    "Bright orange",
    "Bright violet",
    "Bright blue",
    "Bright bluish green",
    "Bright green"
}

while true do
    wait(0.5)
    local character = game.Players.LocalPlayer.Character
    if character then
        -- Проверяем все части персонажа
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.BrickColor = BrickColor.new(presets[math.random(1, #presets)])
            end
        end
    end
end
   end,
}) 


local Toggle = Tab:CreateToggle({
   Name = "Blur",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(state)
    if state then
        local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/Blur/refs/heads/main/blur.lua"))()
    else
        game:GetService("Lighting"):ClearAllChildren()
    end
   end,
})

local Slider = Tab:CreateSlider({
   Name = "Resolution",
   Range = {0, 1},
   Increment = 0.1,
   Suffix = "Resolution",
   CurrentValue = 1,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
getgenv().Resolution = {
    [".gg/scripters"] = Value
}

local Camera = workspace.CurrentCamera
if getgenv().gg_scripters == nil then
    game:GetService("RunService").RenderStepped:Connect(
        function()
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
        end
    )
end
getgenv().gg_scripters = "Aori0001"
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(state)
    if state then
        _G.LightingEnabled = true

local Lighting = game:GetService("Lighting")

if _G.LightingEnabled then
  
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.FogEnd = 1e10

   
    Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
        if _G.LightingEnabled then
            Lighting.Ambient = Color3.new(1, 1, 1)
        end
    end)

    Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
        if _G.LightingEnabled then
            Lighting.Brightness = 2
        end
    end)

    Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
        if _G.LightingEnabled then
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        end
    end)

    Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
        if _G.LightingEnabled then
            Lighting.FogEnd = 1e10
        end
    end)
end

    else
        _G.LightingEnabled = false

local Lighting = game:GetService("Lighting")

-- Устанавливаем чуть более светлый нейтральный свет
Lighting.Ambient = Color3.new(0.7, 0.7, 0.7) -- Легкий серый оттенок
Lighting.Brightness = 1 -- Стандартная яркость
Lighting.OutdoorAmbient = Color3.new(0.7, 0.7, 0.7) -- Тот же светлый серый
Lighting.FogEnd = 100000 -- Ограничение на дальность тумана

    end
   end,
})


local Players = game:GetService("Players")
local player = Players.LocalPlayer
local coneColor = Color3.fromRGB(255, 0, 137) -- Нежно-голубой цвет
local coneCreated = true -- Конус ещё не создан

-- Функция для создания конуса
local function createCone(character)
    if not coneColor then return end -- Создаём конус только если цвет выбран

    local head = character:FindFirstChild("Head")
    if not head then return end

    local cone = Instance.new("Part")
    cone.Size = Vector3.new(1, 1, 1)
    cone.BrickColor = BrickColor.new("White")
    cone.Transparency = 0.3
    cone.Anchored = false
    cone.CanCollide = false

    local mesh = Instance.new("SpecialMesh", cone)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1033714"
    mesh.Scale = Vector3.new(1.7, 1.1, 1.7)

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = cone
    weld.C0 = CFrame.new(0, 0.9, 0)

    cone.Parent = character
    weld.Parent = cone

    -- Добавляем Highlight
    local highlight = Instance.new("Highlight", cone)
    highlight.FillColor = coneColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = coneColor
    highlight.OutlineTransparency = 0

    coneCreated = true -- Помечаем, что конус создан
end

-- Пересоздаём конус после респавна
local function onCharacterAdded(character)
    if coneCreated then -- Если конус уже был создан, пересоздаём
        createCone(character)
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

-- Если персонаж уже существует
if player.Character then
    onCharacterAdded(player.Character)
end

-- ColorPicker
local ColorPicker = Tab:CreateColorPicker({
    Name = "China hat",
    Color = Color3.fromRGB(255,255,255),
    Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(color)
    coneColor = color -- Обновляем цвет для конуса
    if player.Character and not coneCreated then
        createCone(player.Character) -- Создаём конус только после выбора цвета
    elseif player.Character and coneCreated then
        -- Обновляем цвет существующего конуса
        for _, v in ipairs(player.Character:GetChildren()) do
            if v:IsA("Part") and v:FindFirstChild("Highlight") then
                local highlight = v:FindFirstChild("Highlight")
                highlight.FillColor = coneColor
                highlight.OutlineColor = coneColor
            end
        end
    end   
end
})

local Tab = Window:CreateTab("Misc", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Character")

local Button = Tab:CreateButton({
   Name = "Reset",
   Callback = function()
    game.workspace[game.Players.LocalPlayer.Name].Head:Destroy()
end,
})  

local Button = Tab:CreateButton({
   Name = "Destroy shirt and paints",
   Callback = function()
game.Players.LocalPlayer.Character.Shirt:destroy()
game.Players.LocalPlayer.Character.Pants:destroy()
end,
})  

local Section = Tab:CreateSection("Tools")

local Button = Tab:CreateButton({
   Name = "JerkOff (r6)",
   Callback = function()
loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("Spider Script")
end,
})  

local Button = Tab:CreateButton({
   Name = "Click TP",
   Callback = function()
mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Click Teleport"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
end,
})  

local Section = Tab:CreateSection("Scripts")

local Button = Tab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end,
})  

local Button = Tab:CreateButton({
   Name = "System Broken",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
end,
})  

local Tab = Window:CreateTab("Sky", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Sky Custom")

local Button = Tab:CreateButton({
   Name = "Moon Sky",
   Callback = function()
local sky = Instance.new("Sky")
sky.Name = "ColorfulSky"
sky.SkyboxBk = "rbxassetid://159454299"
sky.SkyboxDn = "rbxassetid://159454296"
sky.SkyboxFt = "rbxassetid://159454293"
sky.SkyboxLf = "rbxassetid://159454286"
sky.SkyboxRt = "rbxassetid://159454300"
sky.SkyboxUp = "rbxassetid://159454288"
sky.SunAngularSize = 21
sky.SunTextureId = ""
sky.MoonTextureId = ""
sky.Parent = game.Lighting

-- Texto no canto superior esquerdo
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkyboxChangerLabelUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 230, 0, 18)
nameLabel.Position = UDim2.new(0, 10, 0, 8)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = ""
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Font = Enum.Font.Code
nameLabel.TextSize = 13
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = screenGui
end,
}) 

local Tab = Window:CreateTab("Settings/Credits", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Credits")

local Label = Tab:CreateLabel("Created by Immortal")
local Label = Tab:CreateLabel("Version 1.16 Beta")

local Section = Tab:CreateSection("Settings")



local Button = Tab:CreateButton({
   Name = "Unlock Camera",
   Callback = function()
Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end,
    })


local Button = Tab:CreateButton({
    Name = "Keystrokes",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/TheXploiterYT/scripts/raw/main/keystrokes",true))()
    end,
})
