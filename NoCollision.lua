local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local DIST_THRESHOLD = 20 
local THROTTLE_TIME = 0.2 -- Runs 5 times a second (Zero impact on FPS)
local lastUpdate = 0

-- This stores the state so we don't spam the engine with changes
local collisionStates = {} 

local function toggleCollisions(char, shouldCollide)
    if not char then return end
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if part.CanCollide ~= shouldCollide then
                part.CanCollide = shouldCollide
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not getgenv().NoCollisionPlayer then return end
    
    local now = tick()
    if now - lastUpdate < THROTTLE_TIME then return end
    lastUpdate = now

    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local myPos = myRoot.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local char = player.Character
            local hisRoot = char:FindFirstChild("HumanoidRootPart")
            
            if hisRoot then
                local distance = (myPos - hisRoot.Position).Magnitude
                local inRange = distance < DIST_THRESHOLD
                
                -- ONLY update if the player's "InRange" status changed
                if collisionStates[player] ~= inRange then
                    collisionStates[player] = inRange
                    toggleCollisions(char, not inRange)
                end
            end
        end
    end
end)

-- Reset everyone when toggle is turned off
local function resetAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            toggleCollisions(player.Character, true)
        end
    end
    collisionStates = {}
end
