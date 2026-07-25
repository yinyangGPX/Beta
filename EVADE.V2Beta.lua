--[[
    ═══════════════════════════════════════════════════════════════════════════
    EVADE v5.2 BETA - JUMP FRONTAL + BETA NEW RAINBOW
    ═══════════════════════════════════════════════════════════════════════════
]]

print("\n" .. string.rep("=", 80))
print("EVADE v5.2 BETA - JUMP FRONTAL + BETA NEW")
print(string.rep("=", 80))

--// SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

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
}

--// Variables de Frontal Jump
local camera = Workspace.CurrentCamera
getgenv().FrontalJumpSpeed = 42
getgenv().RampMultiplier = 1.55
local maxExtraSpeed = 80
local currentSpeed = getgenv().FrontalJumpSpeed
local airAccumulator = 0
local lastTick = tick()
local wasAir = false
local activeBV = nil
local lastJumpTime = tick()
local jumpInterval = 0.65

--// Variables para guardar estado de opciones
local savedOptions = {
    EnableTeleportWalk = false,
    EnableEnhancedJump = false,
    EnableGravityMod = false,
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
--// EFECTO RAINBOW INVERSO PARA TÍTULO
--// ═════════════════════════════════════════════════════════════════════════════

local function setupRainbowInversedTitle()
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    task.wait(0.8)
    
    if PlayerGui:FindFirstChild("Yin") then
        local ScreenGui = PlayerGui.Yin
        local TitleLabel = ScreenGui:FindFirstChild("TitleLabel")
        
        if TitleLabel then
            print("✨ Creando efecto rainbow inverso con dos TextLabels...")
            
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
            
            print("✅ Labels creados: EvadeLabel + BetaLabel")
            
            --// Animar colores INVERSOS
            local cycleCount = 0
            local rainbow = RunService.RenderStepped:Connect(function()
                if not EvadeLabel or not EvadeLabel.Parent or not BetaLabel or not BetaLabel.Parent then
                    rainbow:Disconnect()
                    return
                end
                
                cycleCount = cycleCount + 1
                local progress = (cycleCount % 120) / 120
                
                if progress < 0.5 then
                    local t = progress * 2
                    
                    local evadeBrightness = 1 - t
                    EvadeLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness)
                    )
                    
                    local betaBrightness = t
                    BetaLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness)
                    )
                else
                    local t = (progress - 0.5) * 2
                    
                    local evadeBrightness = t
                    EvadeLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness),
                        math.floor(255 * evadeBrightness)
                    )
                    
                    local betaBrightness = 1 - t
                    BetaLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness),
                        math.floor(255 * betaBrightness)
                    )
                end
            end)
            
            print("✅ Efecto rainbow inverso activado")
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
    print(state and "✅ Teleport Walk ACTIVADO" or "❌ Teleport Walk DESACTIVADO")
end)

TabMovement:CreateSlider(
    "Velocidad Teleport",
    1, 50, 5,
    function(value)
        Config.TeleportMovementSpeed = value
        print("✓ Velocidad teleport: " .. value)
    end
)

TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Enhanced Jump", false, function(state)
    Config.EnableEnhancedJump = state
    print(state and "✅ Enhanced Jump ACTIVADO" or "❌ Enhanced Jump DESACTIVADO")
end)

TabMovement:CreateSlider(
    "Altura Salto",
    20, 300, 50,
    function(value)
        Config.JumpHeight = value
        print("✓ Altura salto: " .. value)
    end
)

TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Auto Jump", false, function(state)
    Config.AutoJump = state
    print(state and "✅ Auto Jump ACTIVADO" or "❌ Auto Jump DESACTIVADO")
end)

TabMovement:CreateDivider()

--// JUMP FRONTAL CON BETA NEW RAINBOW
TabMovement:CreateLabel("JUMP FRONTAL", 14)
TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Jump Frontal", false, function(state)
    Config.EnableFrontalJump = state
    if state then
        --// GUARDAR ESTADO ACTUAL DE LAS OPCIONES
        savedOptions.EnableTeleportWalk = Config.EnableTeleportWalk
        savedOptions.EnableEnhancedJump = Config.EnableEnhancedJump
        savedOptions.EnableGravityMod = Config.EnableGravityMod
        
        --// DESACTIVAR LAS OPCIONES CONFLICTIVAS
        Config.EnableTeleportWalk = false
        Config.EnableEnhancedJump = false
        Config.EnableGravityMod = false
        
        --// INICIALIZAR JUMP FRONTAL
        lastJumpTime = tick()
        currentSpeed = getgenv().FrontalJumpSpeed
        airAccumulator = 0
        
        print("✅ Jump Frontal ACTIVADO - Beta")
        print("   - Teleport Walk desactivado")
        print("   - Enhanced Jump desactivado")
        print("   - Gravity Mod desactivado")
    else
        --// RESTAURAR LAS OPCIONES GUARDADAS
        Config.EnableTeleportWalk = savedOptions.EnableTeleportWalk
        Config.EnableEnhancedJump = savedOptions.EnableEnhancedJump
        Config.EnableGravityMod = savedOptions.EnableGravityMod
        
        if activeBV then activeBV:Destroy() end
        activeBV = nil
        currentSpeed = getgenv().FrontalJumpSpeed
        
        print("❌ Jump Frontal DESACTIVADO")
        print("   - Opciones restauradas")
    end
end)

TabMovement:CreateSlider(
    "Velocidad Movimiento",
    50, 110, 42,
    function(value)
        getgenv().FrontalJumpSpeed = value
        currentSpeed = value
        print("✓ Velocidad Jump Frontal: " .. value)
    end
)

TabMovement:CreateSlider(
    "Multiplicador Rampas",
    1.0, 5.0, 1.55,
    function(value)
        getgenv().RampMultiplier = value
        print("✓ Multiplicador Rampas: " .. value)
    end
)

TabMovement:CreateDivider()
TabMovement:CreateLabel("GRAVITY MODIFICATION", 14)
TabMovement:CreateDivider()

TabMovement:CreateFloatingToggle("Gravity Mod Enabled", false, function(state)
    Config.EnableGravityMod = state
    print(state and "✅ Gravity Mod ACTIVADO" or "❌ Gravity Mod DESACTIVADO")
end)

TabMovement:CreateSlider(
    "Gravity Scale",
    0.1, 2, 0.5,
    function(value)
        Config.GravityScale = value
        print("✓ Gravity Scale: " .. value)
    end
)

print("✅ MOVIMIENTO: Pestaña completada")

--// CREAR EFECTO RAINBOW AMARILLO-NEGRO PARA "Beta New"
local function setupBetaNewRainbow()
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    task.wait(1.2)
    
    if PlayerGui:FindFirstChild("Yin") then
        local ScreenGui = PlayerGui.Yin
        
        --// Buscar el toggle de "Jump Frontal" en TabMovement
        for _, child in pairs(ScreenGui:GetDescendants()) do
            if child:IsA("TextLabel") and child.Text:find("Jump Frontal") then
                local parentFrame = child.Parent
                
                if parentFrame then
                    --// Crear label para "Beta" con rainbow
                    local BetaNewLabel = Instance.new("TextLabel")
                    BetaNewLabel.Name = "BetaLabel"
                    BetaNewLabel.Text = "Beta"
                    BetaNewLabel.Font = Enum.Font.GothamBold
                    BetaNewLabel.TextSize = 12
                    BetaNewLabel.BackgroundTransparency = 1
                    BetaNewLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    BetaNewLabel.Size = UDim2.new(0.25, 0, 1, 0)
                    BetaNewLabel.Position = UDim2.new(0.7, 0, 0, 0)
                    BetaNewLabel.TextXAlignment = Enum.TextXAlignment.Right
                    BetaNewLabel.ZIndex = child.ZIndex + 2
                    BetaNewLabel.Parent = parentFrame
                    
                    print("✨ Creando efecto rainbow Amarillo-Negro para Beta...")
                    
                    --// Animar colores Amarillo ↔ Negro
                    local cycleCount = 0
                    local rainbowBetaNew = RunService.RenderStepped:Connect(function()
                        if not BetaNewLabel or not BetaNewLabel.Parent then
                            rainbowBetaNew:Disconnect()
                            return
                        end
                        
                        cycleCount = cycleCount + 1
                        local progress = (cycleCount % 120) / 120
                        
                        if progress < 0.5 then
                            --// Amarillo (255, 255, 0) → Negro (0, 0, 0)
                            local t = progress * 2
                            local brightness = 1 - t
                            
                            BetaNewLabel.TextColor3 = Color3.fromRGB(
                                math.floor(255 * brightness),
                                math.floor(255 * brightness),
                                0
                            )
                        else
                            --// Negro (0, 0, 0) → Amarillo (255, 255, 0)
                            local t = (progress - 0.5) * 2
                            local brightness = t
                            
                            BetaNewLabel.TextColor3 = Color3.fromRGB(
                                math.floor(255 * brightness),
                                math.floor(255 * brightness),
                                0
                            )
                        end
                    end)
                    
                    print("✅ Efecto rainbow Amarillo-Negro activado para Beta")
                    return
                end
            end
        end
    end
end

task.delay(1.5, setupBetaNewRainbow)

--// ═════════════════════════════════════════════════════════════════════════════
--// TAB: CREDITOS
--// ═════════════════════════════════════════════════════════════════════════════

print("\nConfigurando pestaña Creditos...")

TabCreditos:CreateLabel("EVADE v5.2 Beta", 14)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("Desarrollado por: MOFUZII", 12)
TabCreditos:CreateLabel("Framework: Yin Yang v27 Final", 11)
TabCreditos:CreateLabel("Estado: Completamente Funcional ✅", 11)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("Caracteristicas:", 12)
TabCreditos:CreateLabel("✓ Teleport Walk (Floating)", 11)
TabCreditos:CreateLabel("✓ Enhanced Jump (Floating)", 11)
TabCreditos:CreateLabel("✓ Auto Jump (Floating)", 11)
TabCreditos:CreateLabel("✓ Jump Frontal (Floating) NUEVO", 11)
TabCreditos:CreateLabel("✓ Gravity Modification (Floating)", 11)
TabCreditos:CreateDivider()
TabCreditos:CreateLabel("EFECTO ESPECIAL:", 12)
TabCreditos:CreateLabel("🌈 Título Rainbow Inverso", 11)
TabCreditos:CreateLabel("🌈 Beta New (Amarillo ↔ Negro)", 11)

print("✅ CREDITOS: Pestaña completada")

print("\n✅ OK: INTERFAZ COMPLETAMENTE CONFIGURADA")

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

--// FRONTAL JUMP FUNCTION
local function ActivateFrontalJump()
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        
        if root and humanoid then
            local humanoidState = humanoid:GetState()
            local isOnGround = (humanoidState == Enum.HumanoidStateType.Landed or humanoidState == Enum.HumanoidStateType.Running)
            
            if isOnGround then
                --// Detectar si hay estructura adelante para aplicar impulso vertical
                local lookDir = camera.CFrame.LookVector
                lookDir = Vector3.new(lookDir.X, 0, lookDir.Z)
                if lookDir.Magnitude ~= 0 then
                    lookDir = lookDir.Unit
                end
                
                local rayOriginFront = root.Position
                local rayDirectionFront = lookDir * 10
                local raycastParamsFront = RaycastParams.new()
                raycastParamsFront.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParamsFront.FilterDescendantsInstances = {char}
                
                local raycastResultFront = Workspace:Raycast(rayOriginFront, rayDirectionFront, raycastParamsFront)
                
                if raycastResultFront then
                    --// Hay estructura adelante - hacer salto más potente
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    
                    --// Aplicar impulso vertical después de un pequeño delay
                    task.delay(0.1, function()
                        if char and root then
                            local jumpBoost = getgenv().FrontalJumpSpeed * getgenv().RampMultiplier * 0.8
                            pcall(function()
                                root.AssemblyLinearVelocity = Vector3.new(
                                    root.AssemblyLinearVelocity.X,
                                    jumpBoost,
                                    root.AssemblyLinearVelocity.Z
                                )
                            end)
                        end
                    end)
                else
                    --// Sin estructura, salto normal
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                
                lastJumpTime = tick()
            end
        end
    end
end

local function applyFrontalJump()
    if not Config.EnableFrontalJump then return end
    
    local deltaTime = tick() - lastTick
    lastTick = tick()
    
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        
        if root and humanoid then
            local isAir = humanoid.FloorMaterial == Enum.Material.Air
            local humanoidState = humanoid:GetState()
            local isOnGround = (humanoidState == Enum.HumanoidStateType.Landed or humanoidState == Enum.HumanoidStateType.Running) and not isAir
            
            local hitObject = false
            if wasAir and isOnGround then
                hitObject = true
                currentSpeed = getgenv().FrontalJumpSpeed
                airAccumulator = 0
            end
            wasAir = isAir
            
            if isAir then
                if activeBV then activeBV:Destroy() end
                
                local lookDir = camera.CFrame.LookVector
                lookDir = Vector3.new(lookDir.X, 0, lookDir.Z)
                
                if lookDir.Magnitude ~= 0 then
                    lookDir = lookDir.Unit
                end
                
                --// Detectar impacto frontal con estructuras MIENTRAS está en el aire
                local rayOriginFront = root.Position
                local rayDirectionFront = lookDir * 10
                local raycastParamsFront = RaycastParams.new()
                raycastParamsFront.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParamsFront.FilterDescendantsInstances = {char}
                
                local raycastResultFront = Workspace:Raycast(rayOriginFront, rayDirectionFront, raycastParamsFront)
                
                if raycastResultFront then
                    --// Hay una estructura adelante MIENTRAS ESTÁ EN AIRE
                    local impactForce = currentSpeed * getgenv().RampMultiplier
                    
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(
                        lookDir.X * impactForce,
                        impactForce * 1.2,  --// Impulso vertical también
                        lookDir.Z * impactForce
                    )
                    bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
                    bv.P = 1250
                    bv.Parent = root
                    
                    Debris:AddItem(bv, 0.1)
                    activeBV = bv
                else
                    --// Sin estructura, impulso normal
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = lookDir * currentSpeed
                    bv.MaxForce = Vector3.new(4e5, 0, 4e5)
                    bv.P = 1250
                    bv.Parent = root
                    
                    Debris:AddItem(bv, 0.1)
                    activeBV = bv
                end
            else
                --// En el suelo: Aplicar impulso Y acelerar para ganar potencia
                airAccumulator = airAccumulator + deltaTime
                while airAccumulator >= 0.04 do
                    airAccumulator = airAccumulator - 0.04
                    --// Acelerar lentamente pero CAPPED en velocidad base
                    currentSpeed = math.min(getgenv().FrontalJumpSpeed + 10, currentSpeed + 0.3)
                end
                
                if activeBV then activeBV:Destroy() end
                
                local lookDir = camera.CFrame.LookVector
                lookDir = Vector3.new(lookDir.X, 0, lookDir.Z)
                
                if lookDir.Magnitude ~= 0 then
                    lookDir = lookDir.Unit
                end
                
                --// RAYCAST FRONTAL - Detectar CUALQUIER estructura adelante
                local rayOrigin = root.Position
                local rayDirection = Vector3.new(0, -5, 0)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {char}
                
                local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                --// RAYCAST FRONTAL - Detectar estructuras adelante (autos, rampas, etc)
                local rayOriginFront = root.Position
                local rayDirectionFront = lookDir * 8
                local raycastParamsFront = RaycastParams.new()
                raycastParamsFront.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParamsFront.FilterDescendantsInstances = {char}
                
                local raycastResultFront = Workspace:Raycast(rayOriginFront, rayDirectionFront, raycastParamsFront)
                
                local impulsePower = currentSpeed
                local hasStructureAhead = false
                
                --// Si hay estructura adelante, usar multiplicador
                if raycastResultFront then
                    hasStructureAhead = true
                    impulsePower = currentSpeed * getgenv().RampMultiplier
                end
                
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = lookDir * impulsePower
                bv.MaxForce = Vector3.new(4e5, 0, 4e5)
                bv.P = 1250
                bv.Parent = root
                
                Debris:AddItem(bv, 0.1)
                activeBV = bv
                
                currentSpeed = math.max(getgenv().FrontalJumpSpeed, currentSpeed - 2.5 * deltaTime)
                
                if tick() - lastJumpTime >= jumpInterval then
                    ActivateFrontalJump()
                end
            end
        end
    end
end

print("✅ MOVIMIENTO: Funciones cargadas correctamente")

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

print("✅ LOOP: Loop principal iniciado")

print("\n" .. string.rep("=", 80))
print("OK: EVADE v5.2 BETA - COMPLETAMENTE FUNCIONAL")
print(string.rep("=", 80))

print("\nRESUMEN:")
print("   ✅ Libreria Yin Yang v27 Final cargada")
print("   ✅ UI con 2 pestañas (Movimiento + Créditos)")
print("   ✅ FloatingToggle en todas las opciones")
print("   ✅ Jump Frontal AGREGADO a Movimiento")
print("   ✅ Beta con rainbow Amarillo-Negro")
print("   ✅ Funciones de movimiento COMPLETAS")

print("\nCOMO USAR:")
print("   1. Ve a la pestaña MOVIMIENTO")
print("   2. Activa 'Jump Frontal' (verás 'Beta' en amarillo-negro)")
print("   3. El efecto rainbow se mantiene al cambiar de tema")
print("   4. Los FloatingToggle se pueden mover libremente")

print("\n" .. string.rep("=", 80) .. "\n")

return UI
