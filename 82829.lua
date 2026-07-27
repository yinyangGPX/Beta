--[[
    ═══════════════════════════════════════════════════════════════════════════
    EVADE v5.2 BETA - FLOATING TOGGLES + FUNCIONES RESTAURADAS + RAINBOW INVERSO CORRECTO
    ═══════════════════════════════════════════════════════════════════════════
    
    ✅ TÍTULO RAINBOW INVERSO CORRECTO:
    - "EVADE" cambia: Blanco → Negro → Blanco
    - "Beta" cambia: Negro → Blanco → Negro (INVERTIDO)
    - Ambos textos sincronizados pero en colores opuestos
    
    ✅ FRONTAL JUMP AGREGADO:
    - Se activa cada 0.5 segundos
    - Impulso hacia adelante basado en dirección de cámara
    - Solo funciona en el aire
    
    ═══════════════════════════════════════════════════════════════════════════
]]

print("\n" .. string.rep("=", 80))
print("EVADE v5.2 BETA - RAINBOW INVERSO CORRECTO + FRONTAL JUMP")
print(string.rep("=", 80))

--// SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    error("ERROR: No hay jugador local disponible")
    return
end

print("\nSERVICIOS: Inicializados correctamente")

--// ═════════════════════════════════════════════════════════════════════════════
--// CONFIGURACION PRINCIPAL
--// ═════════════════════════════════════════════════════════════════════════════

local Config = {
    --// MOVIMIENTO BASICO
    TeleportMovementSpeed = 5,
    EnableTeleportWalk = false,
    JumpHeight = 50,
    EnableEnhancedJump = false,
    AutoJump = false,
    
    --// GRAVITY MODIFICATION
    EnableGravityMod = false,
    GravityScale = 0.5,
    
    --// FRONTAL JUMP
    EnableFrontalJump = false,
    FrontalJumpSpeed = 50,
}

print("CONFIGURACION: Inicializada")

--// ═════════════════════════════════════════════════════════════════════════════
--// CARGAR YIN YANG v27 FINAL
--// ═════════════════════════════════════════════════════════════════════════════

print("\nCargando Yin Yang v27 Final desde GitHub...")

local success = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Moliinier/Yin-yang/refs/heads/main/Yin_Yang_v27_FINAL.lua"))()
end)

if not success or not _G.YinYang then
    error("ERROR: Fallo al cargar Yin Yang v27 Final")
    return
end

print("LIBRERIA: Yin Yang v27 Final cargado correctamente")
task.wait(0.5)

print("SISTEMA: Inicializacion completada")

--// ═════════════════════════════════════════════════════════════════════════════
--// CREAR UI
--// ═════════════════════════════════════════════════════════════════════════════

print("\nCreando interfaz EVADE v5.2 Beta...")

local UI = _G.YinYang:CreateWindow("EVADE v5.2 Beta", "Dark")

--// ═════════════════════════════════════════════════════════════════════════════
--// 🌈 EFECTO RAINBOW INVERSO PARA TÍTULO - VERSION CORRECTA
--// ═════════════════════════════════════════════════════════════════════════════

local function setupRainbowInversedTitle()
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    task.wait(0.8)
    
    if PlayerGui:FindFirstChild("Yin") then
        local ScreenGui = PlayerGui.Yin
        local TitleLabel = ScreenGui:FindFirstChild("TitleLabel")
        
        if TitleLabel then
            print("Creando efecto rainbow inverso con dos TextLabels...")
            
            --// Obtener posición y tamaño del título original
            local origText = TitleLabel.Text
            local origSize = TitleLabel.Size
            local origPos = TitleLabel.Position
            local origFont = TitleLabel.Font
            local origTextSize = TitleLabel.TextSize
            
            --// Hacer invisible el título original
            TitleLabel.TextTransparency = 1
            
            --// Crear TextLabel para "EVADE" (Blanco → Negro)
            local EvadeLabel = Instance.new("TextLabel")
            EvadeLabel.Name = "EvadeLabel"
            EvadeLabel.Text = "EVADE"
            EvadeLabel.Font = origFont
            EvadeLabel.TextSize = origTextSize
            EvadeLabel.BackgroundTransparency = 1
            EvadeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            EvadeLabel.Size = UDim2.new(0.6, 0, 1, 0)
            EvadeLabel.Position = UDim2.new(0, 0, 0, 0)
            EvadeLabel.TextXAlignment = Enum.TextXAlignment.Left
            EvadeLabel.ZIndex = TitleLabel.ZIndex + 1
            EvadeLabel.Parent = TitleLabel.Parent
            
            --// Crear TextLabel para "Beta" (Negro → Blanco)
            local BetaLabel = Instance.new("TextLabel")
            BetaLabel.Name = "BetaLabel"
            BetaLabel.Text = "v5.2 Beta"
            BetaLabel.Font = origFont
            BetaLabel.TextSize = origTextSize
            BetaLabel.BackgroundTransparency = 1
            BetaLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            BetaLabel.Size = UDim2.new(0.4, 0, 1, 0)
            BetaLabel.Position = UDim2.new(0.6, 0, 0, 0)
            BetaLabel.TextXAlignment = Enum.TextXAlignment.Left
            BetaLabel.ZIndex = TitleLabel.ZIndex + 1
            BetaLabel.Parent = TitleLabel.Parent
            
            print("Labels creados: EvadeLabel + BetaLabel")
            
            --// Animar colores INVERSOS
            local cycleCount = 0
            local rainbow = RunService.RenderStepped:Connect(function()
                if not EvadeLabel or not EvadeLabel.Parent or not BetaLabel or not BetaLabel.Parent then
                    rainbow:Disconnect()
                    return
                end
                
                cycleCount = cycleCount + 1
                local progress = (cycleCount % 120) / 120  -- Ciclo de 120 frames (2 segundos)
                
                if progress < 0.5 then
                    -- Primer segundo (0-0.5): Transición lenta
                    local t = progress * 2  -- 0 a 1
                    
                    -- EVADE: Blanco (255) → Negro (0)
                    local evadeBrightness = 1 - t
                    EvadeLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness)
                    )
                    
                    -- Beta: Negro (0) → Blanco (255) [INVERTIDO]
                    local betaBrightness = t
                    BetaLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness)
                    )
                else
                    -- Segundo segundo (0.5-1): Transición inversa
                    local t = (progress - 0.5) * 2  -- 0 a 1
                    
                    -- EVADE: Negro (0) → Blanco (255)
                    local evadeBrightness = t
                    EvadeLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness)
                    )
                    
                    -- Beta: Blanco (255) → Negro (0) [INVERTIDO]
                    local betaBrightness = 1 - t
                    BetaLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness)
                    )
                end
            end)
            
            print("Efecto rainbow inverso activado - EVADE y Beta en colores opuestos")
        end
    end
end

task.delay(1, setupRainbowInversedTitle)

--// ════════════════════════════════════════════════════════════════════════════
--// CREAR PESTAÑAS
--// ════════════════════════════════════════════════════════════════════════════

local TabMovement = UI:CreateTab("Movimiento", "rbxassetid://130755202295151")
local TabCreditos = UI:CreateTab("Creditos", "rbxassetid://86797720103644")

print("PESTAÑAS: Creadas (Movimiento + Créditos)")

--// ═════════════════════════════════════════════════════════════════════════════
--// TAB: MOVIMIENTO
--// ═════════════════════════════════════════════════════════════════════════════

print("\nConfigurando pestaña Movimiento...")

TabMovement:CreateLabel("MOVIMIENTO BASICO", 14)
TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Teleport Walk", false, function(state)
    Config.EnableTeleportWalk = state
    print(state and "Teleport Walk ACTIVADO" or "Teleport Walk DESACTIVADO")
end)

TabMovement:CreateSlider(
    "Velocidad Teleport",
    1, 50, 5,
    function(value)
        Config.TeleportMovementSpeed = value
        print("Velocidad teleport: " .. value)
    end
)

TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Enhanced Jump", false, function(state)
    Config.EnableEnhancedJump = state
    print(state and "Enhanced Jump ACTIVADO" or "Enhanced Jump DESACTIVADO")
end)

TabMovement:CreateSlider(
    "Altura Salto",
    20, 300, 50,
    function(value)
        Config.JumpHeight = value
        print("Altura salto: " .. value)
    end
)

TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Auto Jump", false, function(state)
    Config.AutoJump = state
    print(state and "Auto Jump ACTIVADO" or "Auto Jump DESACTIVADO")
end)

TabMovement:CreateDivider()
TabMovement:CreateLabel("GRAVITY MODIFICATION", 14)
TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Gravity Mod Enabled", false, function(state)
    Config.EnableGravityMod = state
    print(state and "Gravity Mod ACTIVADO" or "Gravity Mod DESACTIVADO")
end)

TabMovement:CreateSlider(
    "Gravity Scale",
    0.1, 2, 0.5,
    function(value)
        Config.GravityScale = value
        print("Gravity Scale: " .. value)
    end
)

TabMovement:CreateDivider()
TabMovement:CreateLabel("FRONTAL JUMP", 14)
TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Frontal Jump", false, function(state)
    Config.EnableFrontalJump = state
    print(state and "Frontal Jump ACTIVADO" or "Frontal Jump DESACTIVADO")
end)

TabMovement:CreateSlider(
    "Frontal Jump Speed",
    10, 100, 50,
    function(value)
        Config.FrontalJumpSpeed = value
        print("Frontal Jump Speed: " .. value)
    end
)

print("MOVIMIENTO: Pestaña completada")

--// ═════════════════════════════════════════════════════════════════════════════
--// TAB: CREDITOS
--// ═════════════════════════════════════════════════════════════════════════════

print("\nConfigurando pestaña Creditos...")

TabCreditos:CreateLabel("EVADE v5.2 Beta", 14)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("Desarrollado por: MOFUZII", 12)
TabCreditos:CreateLabel("Framework: Yin Yang v27 Final", 11)
TabCreditos:CreateLabel("Estado: Completamente Funcional", 11)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("Caracteristicas:", 12)
TabCreditos:CreateLabel("- Teleport Walk (Floating)", 11)
TabCreditos:CreateLabel("- Enhanced Jump (Floating)", 11)
TabCreditos:CreateLabel("- Auto Jump (Floating)", 11)
TabCreditos:CreateLabel("- Gravity Modification (Floating)", 11)
TabCreditos:CreateLabel("- Frontal Jump (Floating)", 11)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("EFECTO ESPECIAL:", 12)
TabCreditos:CreateLabel("Titulo Rainbow Inverso", 11)
TabCreditos:CreateLabel("EVADE: Blanco - Negro", 11)
TabCreditos:CreateLabel("Beta: Negro - Blanco (INVERTIDO)", 11)

print("CREDITOS: Pestaña completada")

print("\nOK: INTERFAZ COMPLETAMENTE CONFIGURADA")

--// ═════════════════════════════════════════════════════════════════════════════
--// FUNCIONES DE MOVIMIENTO
--// ═════════════════════════════════════════════════════════════════════════════

print("\nCargando funciones de movimiento...")

local function applyTeleportWalk()
    if not Config.EnableTeleportWalk then return end
    
    local char = LocalPlayer.Character
    if not char or not char.PrimaryPart then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    if hum.MoveDirection.Magnitude > 0 then
        pcall(function()
            char:TranslateBy(hum.MoveDirection * Config.TeleportMovementSpeed * 0.1)
        end)
    end
end

local function applyEnhancedJump()
    if not Config.EnableEnhancedJump then return end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    local hum = char.Humanoid
    if hum.Health <= 0 then return end
    
    if hum:GetState() ~= Enum.HumanoidStateType.Jumping then
        pcall(function()
            hum.JumpPower = Config.JumpHeight
            hum.UseJumpPower = true
        end)
    end
end

local function applyAutoJump()
    if not Config.AutoJump then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    
    if hum:GetState() == Enum.HumanoidStateType.Running then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end

local function applyGravityModification()
    if not Config.EnableGravityMod then return end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hum = char.Humanoid
    local rootPart = char.HumanoidRootPart
    
    if hum.Health <= 0 then return end
    
    pcall(function()
        local velocity = rootPart.AssemblyLinearVelocity
        
        if velocity.Y < 0 then
            rootPart.AssemblyLinearVelocity = Vector3.new(
                velocity.X,
                velocity.Y * Config.GravityScale,
                velocity.Z
            )
        end
    end)
end

local lastFrontalJumpTime = 0
local function applyFrontalJump()
    if not Config.EnableFrontalJump then return end
    
    local currentTime = tick()
    if currentTime - lastFrontalJumpTime < 0.5 then return end
    lastFrontalJumpTime = currentTime
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if not root or not humanoid then return end
    
    if humanoid.FloorMaterial == Enum.Material.Air then
        pcall(function()
            local camera = Workspace.CurrentCamera
            local lookDir = camera.CFrame.LookVector
            lookDir = Vector3.new(lookDir.X, 0, lookDir.Z)
            
            if lookDir.Magnitude ~= 0 then
                lookDir = lookDir.Unit
            end
            
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = lookDir * Config.FrontalJumpSpeed
            bv.MaxForce = Vector3.new(4e5, 0, 4e5)
            bv.P = 1250
            bv.Parent = root
            
            Debris:AddItem(bv, 0.1)
        end)
    end
end

print("MOVIMIENTO: Funciones cargadas correctamente")

--// ═════════════════════════════════════════════════════════════════════════════
--// LOOP PRINCIPAL
--// ═════════════════════════════════════════════════════════════════════════════

print("\nActivando loop principal...")

local connection = RunService.Heartbeat:Connect(function()
    pcall(function()
        applyTeleportWalk()
        applyEnhancedJump()
        applyAutoJump()
        applyGravityModification()
        applyFrontalJump()
    end)
end)

print("LOOP: Loop principal iniciado")

print("\n" .. string.rep("=", 80))
print("OK: EVADE v5.2 BETA - COMPLETAMENTE FUNCIONAL CON FRONTAL JUMP")
print(string.rep("=", 80))

print("\nRESUMEN:")
print("   Libreria Yin Yang v27 Final cargada")
print("   UI con 2 pestañas (Movimiento + Creditos)")
print("   FloatingToggle en todas las opciones")
print("   Funciones de movimiento RESTAURADAS")
print("   Titulo con Rainbow Inverso CORRECTO")
print("   FRONTAL JUMP AGREGADO - Se activa cada 0.5 segundos")

print("\nCOMO USAR:")
print("   1. Activa Frontal Jump en la pestaña MOVIMIENTO")
print("   2. Ajusta 'Frontal Jump Speed' (10-100)")
print("   3. Salta y veras el impulso hacia adelante")
print("   4. Los FloatingToggle se pueden mover libremente")

print("\n" .. string.rep("=", 80) .. "\n")

return UI
