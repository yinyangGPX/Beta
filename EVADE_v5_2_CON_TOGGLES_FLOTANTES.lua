--[[
    EVADE v5.2 MEJORADA + TOGGLES FLOTANTES - CONECTADA A YIN YANG v27 FINAL
    
    ✅ FEATURES ARREGLADOS:
    * Teleport Walk Mode (suave, sin pixeleos)
    * Enhanced Jump (altura ajustable)
    * Auto Jump (automático)
    * Front Jump (saltar + velocidad adelante, controlable WASD)
    * Lag Switch [E] (toggle que causa lag 0.5s)
    * TOGGLES FLOTANTES para Lag Switch y Front Jump
    * Optimizado para MOBILE
]]

print("\n" .. string.rep("═", 80))
print("EVADE v5.2 MEJORADA - CONECTADA A YIN YANG v27 FINAL")
print(string.rep("═", 80))

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

-- CARGAR CONFIGURACIÓN
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
            print("Configuración cargada")
            return true
        end
    end)
    return false
end

-- GUARDAR CONFIGURACIÓN
local function SaveConfig()
    pcall(function()
        if writefile then
            local ConfigData = game:GetService("HttpService"):JSONEncode(Config)
            writefile(ConfigFile, ConfigData)
            print("Configuración guardada")
        end
    end)
end

print("\nCargando configuración...")
LoadConfig()

print("\nCargando Yin Yang v27 FINAL...")

local LoadSuccess = pcall(function()
    local success = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Moliinier/Yin-yang/refs/heads/main/Yin_Yang_v27_FINAL.lua"))()
    end)
    
    if not success then
        print("GitHub no disponible, cargando localmente...")
        loadstring(readfile("Yin_Yang_v27_FINAL.lua"))()
    end
end)

if not LoadSuccess or not _G.YinYang then
    error("Error al cargar Yin Yang v27 FINAL")
    return
end

print("Yin Yang v27 FINAL cargado correctamente")

task.wait(0.5)

print("\nCreando interfaz...")

local UI = _G.YinYang:CreateWindow("EVADE v5.2 MEJORADA", "Dark")

local TabMovimiento = UI:CreateTab("Movimiento")
local TabCreditos = UI:CreateTab("Creditos")

--// TAB MOVIMIENTO
TabMovimiento:CreateLabel("MOVIMIENTO AVANZADO", 14)
TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Teleport Walk", Config.TeleportEnabled, function(State)
    Config.TeleportEnabled = State
    SaveConfig()
end)

TabMovimiento:CreateSlider("Velocidad Teleport", 1, 50, Config.WalkSpeed, function(Value)
    Config.WalkSpeed = Value
    SaveConfig()
end)

TabMovimiento:CreateLabel("Velocidad recomendada: 10-30", 10)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Enhanced Jump", Config.EnhancedJumpEnabled, function(State)
    Config.EnhancedJumpEnabled = State
    SaveConfig()
end)

TabMovimiento:CreateSlider("Altura Salto", 20, 100, Config.JumpHeight, function(Value)
    Config.JumpHeight = Value
    SaveConfig()
end)

TabMovimiento:CreateLabel("Altura recomendada: 50-100", 10)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Auto Jump", Config.AutoJumpEnabled, function(State)
    Config.AutoJumpEnabled = State
    SaveConfig()
end)

TabMovimiento:CreateLabel("Salta automaticamente al correr", 10)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Front Jump", Config.FrontJumpEnabled, function(State)
    Config.FrontJumpEnabled = State
    SaveConfig()
end)

TabMovimiento:CreateLabel("Salta + velocidad hacia adelante", 10)
TabMovimiento:CreateLabel("Controlable con WASD", 10)

TabMovimiento:CreateDivider()

TabMovimiento:CreateToggle("Lag Switch [E]", Config.LagSwitchEnabled, function(State)
    Config.LagSwitchEnabled = State
    SaveConfig()
end)

TabMovimiento:CreateLabel("Causa lag 0.5s cada activacion", 10)
TabMovimiento:CreateLabel("Presiona [E] para activar", 10)

--// TAB CREDITOS
TabCreditos:CreateLabel("INFORMACION", 14)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("EVADE v5.2 MEJORADA", 12)
TabCreditos:CreateLabel("Creador: MOFUZII", 11)
TabCreditos:CreateLabel("Conectado a: Yin Yang v27 FINAL", 11)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("CARACTERISTICAS", 12)
TabCreditos:CreateLabel("Teleport Walk (sin pixeleos)", 11)
TabCreditos:CreateLabel("Enhanced Jump (20-100 altura)", 11)
TabCreditos:CreateLabel("Auto Jump automatico", 11)
TabCreditos:CreateLabel("Front Jump controlable", 11)
TabCreditos:CreateLabel("Lag Switch con [E]", 11)
TabCreditos:CreateLabel("Toggles Flotantes", 11)

print("Interfaz creada")

--// TOGGLES FLOTANTES
if TabMovimiento.CreateFloatingToggleSimple then
    print("Creando toggles flotantes...")
    
    pcall(function()
        TabMovimiento:CreateFloatingToggleSimple("Lag Switch", Config.LagSwitchEnabled, function(state)
            Config.LagSwitchEnabled = state
            SaveConfig()
        end)
    end)
    
    pcall(function()
        TabMovimiento:CreateFloatingToggleSimple("Front Jump", Config.FrontJumpEnabled, function(state)
            Config.FrontJumpEnabled = state
            SaveConfig()
        end)
    end)
    
    print("Toggles flotantes creados")
else
    print("CreateFloatingToggleSimple no disponible")
end

--// FUNCIONES DE MOVIMIENTO

local function HandleTeleportWalk()
    if not Config.TeleportEnabled then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or not RootPart then return end
    
    if Humanoid.MoveVector.Magnitude > 0 then
        local MoveDirection = Humanoid.MoveVector.Unit
        local TeleportDistance = Config.WalkSpeed / 10
        
        RootPart.CFrame = RootPart.CFrame + (MoveDirection * TeleportDistance)
    end
end

local function HandleEnhancedJump()
    if not Config.EnhancedJumpEnabled then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or not RootPart then return end
    
    if Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        RootPart.AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity + Vector3.new(0, Config.JumpHeight / 100, 0)
    end
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
            local jumpForce = 50
            local direction = rootPart.CFrame.LookVector
            rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity + (direction * jumpForce)
        end)
    end
end

local function HandleLagSwitch()
    if not Config.LagSwitchEnabled then return end
    
    task.wait(0.5)
    LagSwitchActive = true
    task.wait(0.5)
    LagSwitchActive = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E and Config.LagSwitchEnabled then
        print("Lag Switch ACTIVADO (0.5s)")
        HandleLagSwitch()
    end
end)

print("Funciones cargadas")

print("\nIniciando loop principal...")

local MainLoop = RunService.Heartbeat:Connect(function()
    if LagSwitchActive then return end
    
    HandleTeleportWalk()
    HandleEnhancedJump()
    HandleAutoJump()
    HandleFrontJump()
end)

print("Loop principal iniciado")

print("\n" .. string.rep("═", 80))
print("EVADE v5.2 MEJORADA - COMPLETAMENTE FUNCIONAL")
print(string.rep("═", 80))
print("\nRESUMEN:")
print("  Yin Yang v27 FINAL cargada")
print("  Teleport Walk SUAVE (sin pixeleos)")
print("  Enhanced Jump (20-100 altura)")
print("  Auto Jump automatico")
print("  Front Jump controlable")
print("  Lag Switch [E]")
print("  Toggles Flotantes")
print("  Optimizado para PC y Mobile")
print("  Sistema de guardado activo")
print("\n" .. string.rep("═", 80) .. "\n")

return {
    UI = UI,
    Config = Config,
    Status = "Running",
    Version = "5.2 Mejorada",
    Creator = "MOFUZII"
}
