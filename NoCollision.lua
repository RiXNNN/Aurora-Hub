local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local DIST_THRESHOLD = 6 
local THROTTLE_TIME = 0.1 
local lastUpdate = 0
local inRangePlayers = {} 

local function toggleCollisions(char, shouldCollide)
    if not char then return end
    
    -- 1. Disable main body parts (Fast)
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if part.CanCollide ~= shouldCollide then
                part.CanCollide = shouldCollide
            end
        end
    end

    -- 2. Target the Katana specifically via the "Guard" part
    -- We look for Guard because it's a unique part of the Demonfall sword models
    local swordPart = char:FindFirstChild("Guard", true)
    if swordPart and swordPart.Parent then
        local katanaModel = swordPart.Parent
        for _, kPart in ipairs(katanaModel:GetDescendants()) do
            if kPart:IsA("BasePart") then
                if kPart.CanCollide ~= shouldCollide then
                    kPart.CanCollide = shouldCollide
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not getgenv().NoCollisionPlayer then 
        if next(inRangePlayers) ~= nil then
            for player, _ in pairs(inRangePlayers) do
                if player.Character then toggleCollisions(player.Character, true) end
            end
            inRangePlayers = {}
        end
        return 
    end
    
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
                
                if distance < DIST_THRESHOLD then
                    -- Keep enforcing while in range so Demonfall scripts don't reset it
                    toggleCollisions(char, false)
                    inRangePlayers[player] = true
                else
                    if inRangePlayers[player] then
                        toggleCollisions(char, true)
                        inRangePlayers[player] = nil
                    end
                end
            end
        end
    end
end)
