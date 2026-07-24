--[[
    EVADE v5.2 FINAL FIXED - CON TOGGLES FLOTANTES + INFINITE SLIDE
    
    ARREGLOS:
    * Eliminado Humanoid.MoveVector (causaba lag)
    * Toggles flotantes visibles y funcionales
    * Infinite Slide agregado
    * Front Jump optimizado (sin lag)
    * Auto Jump reparado
]]

print("\n" .. string.rep("═", 80))
print("EVADE v5.2 FINAL FIXED - CONECTADA A YIN YANG v27 FINAL")
print(string.rep("═", 80))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    WalkSpeed = 5,
    TeleportEnabled = false,
    JumpHeight = 50,
    EnhancedJumpEnabled = false,
    AutoJumpEnabled = false,
    FrontJumpEnabled = false,
    LagSwitchEnabled = false,
    InfiniteSlideEnabled = false
}

local LagSwitchActive = false
local isMoving = false

-- DETECTAR MOVIMIENTO (SIN Humanoid.MoveVector)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or 
       input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
        isMoving = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or 
       input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
        isMoving = false
    end
end)

-- LAG SWITCH
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E and Config.LagSwitchEnabled then
        print("Lag Switch ACTIVADO (0.5s)")
        LagSwitchActive = true
        task.wait(0.5)
        LagSwitchActive = false
    end
end)

print("\nCargando Yin Yang v27 FINAL...")

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Moliinier/Yin-yang/refs/heads/main/Yin_Yang_v27_FINAL.lua"))()
end)

if not _G.YinYang then
    error("Error al cargar Yin Yang v27")
    return
end

print("Yin Yang v27 FINAL cargado")

task.wait(0.5)

local UI = _G.YinYang:CreateWindow("EVADE v5.2 FINAL FIXED", "Dark")

local TabMovimiento = UI:CreateTab("Movimiento")
local TabOpciones = UI:CreateTab("Opciones")

--// TAB MOVIMIENTO
TabMovimiento:CreateLabel("MOVIMIENTO AVANZADO", 14)
TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Teleport Walk", Config.TeleportEnabled, function(State)
    Config.TeleportEnabled = State
end)

TabMovimiento:CreateSlider("Velocidad Teleport", 1, 30, Config.WalkSpeed, function(Value)
    Config.WalkSpeed = Value
end)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Enhanced Jump", Config.EnhancedJumpEnabled, function(State)
    Config.EnhancedJumpEnabled = State
end)

TabMovimiento:CreateSlider("Altura Salto", 20, 80, Config.JumpHeight, function(Value)
    Config.JumpHeight = Value
end)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Auto Jump", Config.AutoJumpEnabled, function(State)
    Config.AutoJumpEnabled = State
end)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Front Jump", Config.FrontJumpEnabled, function(State)
    Config.FrontJumpEnabled = State
end)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Lag Switch [E]", Config.LagSwitchEnabled, function(State)
    Config.LagSwitchEnabled = State
end)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Infinite Slide", Config.InfiniteSlideEnabled, function(State)
    Config.InfiniteSlideEnabled = State
end)

--// TAB OPCIONES - TOGGLES FLOTANTES
TabOpciones:CreateLabel("TOGGLES FLOTANTES", 14)
TabOpciones:CreateDivider()
TabOpciones:CreateLabel("Opciones flotantes para controlar rapido", 11)
TabOpciones:CreateDivider()

if TabMovimiento.CreateFloatingToggleSimple then
    print("Agregando toggles flotantes...")
    
    pcall(function()
        TabMovimiento:CreateFloatingToggleSimple("Lag Switch [E]", Config.LagSwitchEnabled, function(state)
            Config.LagSwitchEnabled = state
        end)
        print("Toggle Lag Switch agregado")
    end)
    
    pcall(function()
        TabMovimiento:CreateFloatingToggleSimple("Front Jump", Config.FrontJumpEnabled, function(state)
            Config.FrontJumpEnabled = state
        end)
        print("Toggle Front Jump agregado")
    end)
    
    pcall(function()
        TabMovimiento:CreateFloatingToggleSimple("Infinite Slide", Config.InfiniteSlideEnabled, function(state)
            Config.InfiniteSlideEnabled = state
        end)
        print("Toggle Infinite Slide agregado")
    end)
else
    print("CreateFloatingToggleSimple no disponible")
end

--// FUNCIONES

local function HandleTeleportWalk()
    if not Config.TeleportEnabled then return end
    if LagSwitchActive then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart or not isMoving then return end
    
    local direction = RootPart.CFrame.LookVector
    local distance = Config.WalkSpeed / 5
    
    RootPart.CFrame = RootPart.CFrame + (direction * distance)
end

local function HandleEnhancedJump()
    if not Config.EnhancedJumpEnabled then return end
    if LagSwitchActive then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or not RootPart then return end
    
    if Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        local jumpBoost = Config.JumpHeight / 50
        RootPart.AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity + Vector3.new(0, jumpBoost, 0)
    end
end

local function HandleAutoJump()
    if not Config.AutoJumpEnabled then return end
    if LagSwitchActive then return end
    if not isMoving then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return end
    
    if Humanoid:GetState() == Enum.HumanoidStateType.Running then
        pcall(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end

local lastFrontJumpTime = 0
local function HandleFrontJump()
    if not Config.FrontJumpEnabled then return end
    if LagSwitchActive then return end
    if not isMoving then return end
    
    local currentTime = tick()
    if currentTime - lastFrontJumpTime < 0.5 then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if humanoid:GetState() == Enum.HumanoidStateType.Running then
        lastFrontJumpTime = currentTime
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            local jumpForce = 40
            local direction = rootPart.CFrame.LookVector
            rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity + (direction * jumpForce)
        end)
    end
end

local movementTables = {}
local function findMovementTables()
    movementTables = {}
    local requiredKeys = {"Friction", "AirStrafeAcceleration", "JumpHeight"}
    
    for _, obj in ipairs(getgc(true)) do
        if typeof(obj) == "table" then
            local hasKeys = true
            for _, key in ipairs(requiredKeys) do
                if rawget(obj, key) == nil then
                    hasKeys = false
                    break
                end
            end
            if hasKeys then
                table.insert(movementTables, obj)
            end
        end
    end
end

local function setSlideFriction(value)
    for _, tbl in ipairs(movementTables) do
        pcall(function()
            tbl.Friction = value
        end)
    end
end

local function HandleInfiniteSlide()
    if not Config.InfiniteSlideEnabled then return end
    if #movementTables == 0 then return end
    
    local gameFolder = workspace:FindFirstChild("Game")
    if not gameFolder then return end
    
    local playersFolder = gameFolder:FindFirstChild("Players")
    if not playersFolder then return end
    
    local playerModel = playersFolder:FindFirstChild(LocalPlayer.Name)
    if not playerModel then return end
    
    local state = pcall(function() return playerModel:GetAttribute("State") end)
    if not state then return end
    
    pcall(function()
        if state == "Slide" then
            playerModel:SetAttribute("State", "EmotingSlide")
        elseif state == "EmotingSlide" then
            setSlideFriction(-8)
        else
            setSlideFriction(5)
        end
    end)
end

findMovementTables()

print("Funciones cargadas")
print("\nIniciando loop principal...")

local MainLoop = RunService.Heartbeat:Connect(function()
    if LagSwitchActive then return end
    
    HandleTeleportWalk()
    HandleEnhancedJump()
    HandleAutoJump()
    HandleFrontJump()
    HandleInfiniteSlide()
end)

print("Loop principal iniciado")

print("\n" .. string.rep("═", 80))
print("EVADE v5.2 FINAL FIXED - COMPLETAMENTE FUNCIONAL")
print(string.rep("═", 80))
print("\nCaracteristicas:")
print("  Teleport Walk SUAVE")
print("  Enhanced Jump")
print("  Auto Jump")
print("  Front Jump OPTIMIZADO")
print("  Lag Switch [E]")
print("  Infinite Slide")
print("  Toggles Flotantes")
print("\n" .. string.rep("═", 80) .. "\n")

return {
    UI = UI,
    Config = Config,
    Status = "Running"
}
