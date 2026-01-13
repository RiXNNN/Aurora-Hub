local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local DIST_THRESHOLD = 6 
local THROTTLE_TIME = 0.150 
local lastUpdate = 0
local inRangePlayers = {} 
local katanaCache = {} -- Stores the Katana model so we don't have to "search" every 0.1s

local function toggleCollisions(char, shouldCollide, player)
    if not char then return end
    
    -- 1. Body Parts sweep
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if part.CanCollide ~= shouldCollide then
                part.CanCollide = shouldCollide
            end
        end
    end

    -- 2. Optimized Katana sweep
    local katana = katanaCache[player]
    
    -- If no cache or the katana was deleted (swapped), find it again
    if not katana or not katana.Parent then
        local guard = char:FindFirstChild("Guard", true)
        katana = guard and guard.Parent
        katanaCache[player] = katana
    end

    if katana then
        for _, kPart in ipairs(katana:GetDescendants()) do
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
                if player.Character then toggleCollisions(player.Character, true, player) end
            end
            inRangePlayers = {}
            katanaCache = {}
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
                    toggleCollisions(char, false, player)
                    inRangePlayers[player] = true
                elseif inRangePlayers[player] then
                    toggleCollisions(char, true, player)
                    inRangePlayers[player] = nil
                    -- Don't clear cache here so it's ready if they walk back in range
                end
            end
        end
    end
end)
