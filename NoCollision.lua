local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local DIST_THRESHOLD = 20 
local THROTTLE_TIME = 0.2 
local lastUpdate = 0
local collisionStates = {} 

-- Specific names used in Demonfall for katanas
local KatanaNames = {["Katana"] = true, ["Katana2"] = true, ["Blade"] = true}

local function toggleCollisions(char, shouldCollide)
    if not char then return end
    
    -- 1. Fast sweep of main body parts
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if part.CanCollide ~= shouldCollide then
                part.CanCollide = shouldCollide
            end
        -- 2. Specifically target the Katana Model if it's found
        elseif part:IsA("Model") or part:IsA("Tool") then
            if KatanaNames[part.Name] then
                for _, kPart in ipairs(part:GetDescendants()) do
                    if kPart:IsA("BasePart") then
                        kPart.CanCollide = shouldCollide
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not getgenv().NoCollisionPlayer then 
        if next(collisionStates) ~= nil then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then toggleCollisions(player.Character, true) end
            end
            collisionStates = {}
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
                local inRange = distance < DIST_THRESHOLD
                
                if collisionStates[player] ~= inRange then
                    collisionStates[player] = inRange
                    toggleCollisions(char, not inRange)
                end
            end
        end
    end
end)
