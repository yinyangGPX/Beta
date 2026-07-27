-- Infinite Slide (extraído de Draconic Hub X - Evade)
-- Esta función permite deslizarse indefinidamente modificando la fricción del personaje.

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local infiniteSlideEnabled = true -- Cambiar a false para desactivar
local slideFrictionValue = -8     -- Valor de fricción para el deslizamiento infinito
local movementTables = {}

local requiredKeys = {
    "Friction", "AirStrafeAcceleration", "JumpHeight", "RunDeaccel",
    "JumpSpeedMultiplier", "JumpCap", "SprintCap", "WalkSpeedMultiplier",
    "BhopEnabled", "Speed", "AirAcceleration", "RunAccel", "SprintAcceleration"
}

local function hasRequiredFields(tbl)
    if typeof(tbl) ~= "table" then return false end
    for _, key in ipairs(requiredKeys) do
        if rawget(tbl, key) == nil then return false end
    end
    return true
end

local function findMovementTables()
    movementTables = {}
    for _, obj in ipairs(getgc(true)) do
        if hasRequiredFields(obj) then
            table.insert(movementTables, obj)
        end
    end
    return #movementTables > 0
end

local function setSlideFriction(value)
    for _, tbl in ipairs(movementTables) do
        pcall(function()
            tbl.Friction = value
        end)
    end
end

local function updatePlayerModel()
    local gameFolder = workspace:FindFirstChild("Game")
    if not gameFolder then return nil end
    local playersFolder = gameFolder:FindFirstChild("Players")
    if not playersFolder then return nil end
    return playersFolder:FindFirstChild(player.Name)
end

local function infiniteSlideHeartbeatFunc()
    if not infiniteSlideEnabled then return end
    
    local playerModel = updatePlayerModel()
    if not playerModel then return end
    
    local state = playerModel:GetAttribute("State")
    
    if state == "Slide" then
        pcall(function()
            playerModel:SetAttribute("State", "EmotingSlide")
        end)
    elseif state == "EmotingSlide" then
        setSlideFriction(slideFrictionValue)
    else
        setSlideFriction(5) -- Fricción normal
    end
end

-- Inicialización
findMovementTables()
RunService.Heartbeat:Connect(infiniteSlideHeartbeatFunc)

print("Infinite Slide Cargado - Draconic Hub X")
