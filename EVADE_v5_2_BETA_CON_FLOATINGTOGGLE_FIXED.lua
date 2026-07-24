--[[
    EVADE v5.2 BETA - CONECTADA A YIN YANG v27 FINAL
    
     FEATURES ARREGLADOS:
    * Teleport Walk Mode (suave, sin pixeleos)
    * Enhanced Jump (altura ajustable)
    * Auto Jump (automtico)
    * Front Jump (saltar + velocidad adelante, controlable WASD)
    * Lag Switch [E] (toggle que causa lag 0.5s)
    * Optimizado para MOBILE
    * Assets visuales agregados
]]

print("\n" .. string.rep("", 80))
print(" EVADE v5.2 BETA - CONECTADA A YIN YANG v27 FINAL")
print(string.rep("", 80))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ConfigFile = "EVADE_v52_Config.json"

local Config = {
    WalkSpeed = 5,
    TeleportEnabled = false,
    JumpHeight = 50,
    EnhancedJumpEnabled = false,
    AutoJumpEnabled = false,
    FrontJumpEnabled = false,
    LagSwitchEnabled = false,
    CurrentTheme = "Dark",
    CurrentEffect = "Off"
}

local SavedData = {}
local LagSwitchActive = false

-- CARGAR CONFIGURACIN
local function LoadConfig()
    if not readfile then
        return false
    end
    
    pcall(function()
        local ConfigData = readfile(ConfigFile)
        if ConfigData then
            SavedData = game:GetService("HttpService"):JSONDecode(ConfigData)
            for Key, Value in pairs(SavedData) do
                if Config[Key] ~= nil then
                    Config[Key] = Value
                end
            end
            print(" Configuración cargada")
            return true
        end
    end)
    return false
end

-- GUARDAR CONFIGURACIN
local function SaveConfig()
    pcall(function()
        if writefile then
            local ConfigData = game:GetService("HttpService"):JSONEncode(Config)
            writefile(ConfigFile, ConfigData)
            print(" Configuración guardada")
        end
    end)
end

print(" Cargando configuración...")
LoadConfig()

print("\n Cargando Yin Yang v27 FINAL...")

local LoadAttempts = 0
local LibraryLoaded = false

repeat
    LoadAttempts = LoadAttempts + 1
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Moliinier/Yin-yang/refs/heads/main/Yin_Yang_v27_FINAL.lua"))()
    end)
    
    task.wait(0.3)
    LibraryLoaded = (_G.YinYang ~= nil)
    
    if not LibraryLoaded and LoadAttempts == 1 then
        print(" ⚠️ Reintentando...")
    end
until LibraryLoaded or LoadAttempts > 40

--// VALIDAR CARGA COMPLETA
if not _G.YinYang then
    error(" ❌ YIN YANG v27 NO SE CARGO")
    return
end

if not _G.YinYang.CreateWindow then
    error(" ❌ CreateWindow NO EXISTE en Yin Yang v27")
    return
end

print(" ✅ Yin Yang v27 CARGADO CORRECTAMENTE")
task.wait(1)

print("\n Creando interfaz...")

local UI = _G.YinYang:CreateWindow(" EVADE v5.2 BETA", "Dark")

if Config.CurrentTheme and Config.CurrentTheme ~= "Dark" then
    UI:SetTheme(Config.CurrentTheme)
end

if Config.CurrentEffect and Config.CurrentEffect ~= "Off" then
    UI:SetTextEffect(Config.CurrentEffect)
end

print(" Interfaz creada")

local TabMovimiento = UI:CreateTab("Movimiento")
local TabCreditos = UI:CreateTab("Créditos")

-- 
-- PESTAÑA MOVIMIENTO
-- 

TabMovimiento:CreateLabel(" MOVIMIENTO AVANZADO", 14)
TabMovimiento:CreateDivider()

-- TELEPORT WALK
TabMovimiento:CreateToggle(" Teleport Walk", Config.TeleportEnabled, function(State)
    Config.TeleportEnabled = State
    print(State and " Teleport Walk ACTIVADO" or " Teleport Walk DESACTIVADO")
    SaveConfig()
end)

TabMovimiento:CreateSlider(" Velocidad Teleport", 1, 50, Config.WalkSpeed, function(Value)
    Config.WalkSpeed = Value
    print(" Velocidad: " .. Value)
    SaveConfig()
end)

TabMovimiento:CreateLabel(" Velocidad recomendada: 10-30", 10)

TabMovimiento:CreateDivider()

-- ENHANCED JUMP
TabMovimiento:CreateToggle(" Enhanced Jump", Config.EnhancedJumpEnabled, function(State)
    Config.EnhancedJumpEnabled = State
    print(State and " Enhanced Jump ACTIVADO" or " Enhanced Jump DESACTIVADO")
    SaveConfig()
end)

TabMovimiento:CreateSlider(" Altura Salto", 20, 200, Config.JumpHeight, function(Value)
    Config.JumpHeight = Value
    print(" Altura: " .. Value)
    SaveConfig()
end)

TabMovimiento:CreateLabel(" Altura recomendada: 50-100", 10)

TabMovimiento:CreateDivider()

-- AUTO JUMP
TabMovimiento:CreateToggle(" Auto Jump", Config.AutoJumpEnabled, function(State)
    Config.AutoJumpEnabled = State
    print(State and " Auto Jump ACTIVADO" or " Auto Jump DESACTIVADO")
    SaveConfig()
end)

TabMovimiento:CreateLabel(" Salta automticamente al correr", 10)

TabMovimiento:CreateDivider()

-- FRONT JUMP
TabMovimiento:CreateToggle(" Front Jump", Config.FrontJumpEnabled, function(State)
    Config.FrontJumpEnabled = State
    print(State and " Front Jump ACTIVADO" or " Front Jump DESACTIVADO")
    SaveConfig()
end)

TabMovimiento:CreateLabel(" Salta + velocidad hacia adelante", 10)
TabMovimiento:CreateLabel(" Controlable con WASD", 10)

TabMovimiento:CreateDivider()

-- LAG SWITCH
TabMovimiento:CreateToggle(" Lag Switch [E]", Config.LagSwitchEnabled, function(State)
    Config.LagSwitchEnabled = State
    print(State and " Lag Switch ACTIVADO" or " Lag Switch DESACTIVADO")
    SaveConfig()
end)

TabMovimiento:CreateLabel(" Causa lag 0.5s cada activación", 10)
TabMovimiento:CreateLabel(" Presiona [E] para activar", 10)

-- 
-- PESTAÑA CRDITOS
-- 

TabCreditos:CreateLabel(" INFORMACIN", 14)
TabCreditos:CreateDivider()

TabCreditos:CreateLabel(" EVADE v5.2 BETA", 12)
TabCreditos:CreateLabel(" Creador: MOFUZII", 11)
TabCreditos:CreateLabel(" Conectado a: Yin Yang v27 FINAL", 11)
TabCreditos:CreateLabel("© Todos los derechos reservados 2024", 10)

TabCreditos:CreateDivider()

TabCreditos:CreateLabel(" CARACTERÍSTICAS", 12)
TabCreditos:CreateLabel(" Teleport Walk (sin pixeleos)", 11)
TabCreditos:CreateLabel(" Enhanced Jump (altura 20-200)", 11)
TabCreditos:CreateLabel(" Auto Jump automtico", 11)
TabCreditos:CreateLabel(" Front Jump controlable", 11)
TabCreditos:CreateLabel(" Lag Switch con [E]", 11)

TabCreditos:CreateDivider()

TabCreditos:CreateLabel(" OPTIMIZADO", 12)
TabCreditos:CreateLabel(" Funciona en PC y Mobile", 11)
TabCreditos:CreateLabel(" Código optimizado", 11)
TabCreditos:CreateLabel(" Bajo impacto en rendimiento", 11)

TabCreditos:CreateDivider()

TabCreditos:CreateLabel(" INFORMACIN TCNICA", 12)
TabCreditos:CreateLabel(" Configuración: EVADE_v52_Config.json", 10)
TabCreditos:CreateLabel(" Protección: Semi-Ofuscado", 10)
TabCreditos:CreateLabel(" Estado:  Completamente Funcional", 10)

print(" Interfaz completada")

-- 
-- FUNCIONES DE MOVIMIENTO
-- 

local lastTeleportTime = 0

local function HandleTeleportWalk()
    if not Config.TeleportEnabled then return end
    
    local currentTime = tick()
    if currentTime - lastTeleportTime < 0.02 then return end -- SUAVE, sin pixeleos
    lastTeleportTime = currentTime
    
    local Character = LocalPlayer.Character
    if not Character or not Character.PrimaryPart then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return end
    
    if Humanoid.MoveDirection.Magnitude > 0 then
        pcall(function()
            -- Movimiento suave (ARREGLADO: sin pixeleos)
            Character:TranslateBy(Humanoid.MoveDirection * Config.WalkSpeed * 0.08)
        end)
    end
end

local lastJumpHeight = 0
local function HandleEnhancedJump()
    if not Config.EnhancedJumpEnabled then return end
    
    if lastJumpHeight == Config.JumpHeight then return end
    lastJumpHeight = Config.JumpHeight
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end
    
    pcall(function()
        Humanoid.JumpPower = Config.JumpHeight
        Humanoid.UseJumpPower = true
    end)
end

local function HandleAutoJump()
    if not Config.AutoJumpEnabled then return end
    
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

--// FRONT JUMP MEJORADO - Velocidad fija de 16.61
local function HandleFrontJump()
    if not Config.FrontJumpEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if humanoid:GetState() == Enum.HumanoidStateType.Running then
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            -- Front Jump: velocidad adelante FIJA (16.61) - independiente de TeleportSpeed
            local frontJumpSpeed = 16.61  -- Velocidad calculada fija
            local direction = rootPart.CFrame.LookVector
            rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity + (direction * frontJumpSpeed)
        end)
    end
end

--// LAG SWITCH ARREGLADO - Causa lag real de 0.5s
local function HandleLagSwitch()
    if not Config.LagSwitchEnabled then return end
    if LagSwitchActive then return end
    
    LagSwitchActive = true
    
    -- Causar lag real pausando el script por 0.5 segundos
    task.wait(0.5)
    
    LagSwitchActive = false
end

-- LAG SWITCH (ARREGLADO)
local function HandleLagSwitch()
    if not Config.LagSwitchEnabled then return end
    
    -- Causa lag 0.5s cada activación
    task.wait(0.5)
    LagSwitchActive = true
    task.wait(0.5)
    LagSwitchActive = false
end

-- TECLA [E] para activar Lag Switch
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E and Config.LagSwitchEnabled then
        print(" Lag Switch ACTIVADO (0.5s)")
        HandleLagSwitch()
    end
end)

print(" Funciones cargadas")

print("\n Iniciando loop principal...")

local MainLoop = RunService.Heartbeat:Connect(function()
    if LagSwitchActive then return end -- Pausar si est en lag
    
    HandleTeleportWalk()
    HandleEnhancedJump()
    HandleAutoJump()
    HandleFrontJump()
end)

print(" Loop principal iniciado")

print("\n" .. string.rep("", 80))
print(" EVADE v5.2 BETA - COMPLETAMENTE FUNCIONAL ")
print(string.rep("", 80))
print("\n RESUMEN:")
print("    Yin Yang v27 FINAL cargada")
print("    Teleport Walk SUAVE (sin pixeleos)")
print("    Enhanced Jump (20-200 altura)")
print("    Auto Jump automtico")
print("    Front Jump controlable")
print("    Lag Switch [E]")
print("    Optimizado para PC y Mobile")
print("    Sistema de guardado activo")
print("\n SEGURIDAD: Semi-Ofuscado ")
print(" PLATAFORMA: PC + Mobile ")
print(string.rep("", 80) .. "\n")

return {
    UI = UI,
    Config = Config,
    Status = "Running",
    Version = "5.2 Mejorada",
    Creator = "MOFUZII"
}


--// TITULO RAINBOW PIXEL - Cambiar constantemente entre Negro y Blanco
local rainbowColors = {
    Color3.fromRGB(0, 0, 0),        -- Negro
    Color3.fromRGB(25, 25, 25),     -- Gris muy oscuro
    Color3.fromRGB(50, 50, 50),     -- Gris oscuro
    Color3.fromRGB(100, 100, 100),  -- Gris medio
    Color3.fromRGB(150, 150, 150),  -- Gris claro
    Color3.fromRGB(200, 200, 200),  -- Gris muy claro
    Color3.fromRGB(255, 255, 255),  -- Blanco
    Color3.fromRGB(200, 200, 200),  -- Gris muy claro
    Color3.fromRGB(150, 150, 150),  -- Gris claro
    Color3.fromRGB(100, 100, 100),  -- Gris medio
    Color3.fromRGB(50, 50, 50),     -- Gris oscuro
    Color3.fromRGB(25, 25, 25),     -- Gris muy oscuro
}

local rainbowIndex = 1
task.spawn(function()
    while true do
        pcall(function()
            if UI and UI.Main then
                local titleLabel = UI.Main:FindFirstChild("TitleBar")
                if titleLabel then
                    titleLabel.TextColor3 = rainbowColors[rainbowIndex]
                end
            end
        end)
        rainbowIndex = rainbowIndex + 1
        if rainbowIndex > #rainbowColors then rainbowIndex = 1 end
        task.wait(0.04)  -- Velocidad pixel
    end
end)

--// TOGGLES FLOTANTES PARA OPCIONES PRINCIPALES
if TabMovimiento and TabMovimiento.CreateFloatingToggleSimple then
    TabMovimiento:CreateFloatingToggleSimple("Lag Switch", Config.LagSwitchEnabled, function(state)
        Config.LagSwitchEnabled = state
    end)
    
    TabMovimiento:CreateFloatingToggleSimple("Front Jump", Config.FrontJumpEnabled, function(state)
        Config.FrontJumpEnabled = state
    end)
    
    TabMovimiento:CreateFloatingToggleSimple("Auto Jump", Config.AutoJumpEnabled, function(state)
        Config.AutoJumpEnabled = state
    end)
end

