local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local DIST_THRESHOLD = 20 
local CHECK_SPEED = 0.1 -- Runs 10 times a second instead of 60 (Huge FPS gain)
local lastCheck = 0

local npcCache = {}

-- Function to refresh the list of NPCs (Runs slowly in background)
local function updateNPCCache()
    local newCache = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= LocalPlayer.Character then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp then table.insert(newCache, obj) end
        end
    end
    npcCache = newCache
end

-- Refresh NPC list every 5 seconds so we don't scan Workspace constantly
task.spawn(function()
    while true do
        updateNPCCache()
        task.wait(5)
    end
end)

local function fixModelCollision(model, localPos, state)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - localPos).Magnitude
    local shouldCollide = (dist >= DIST_THRESHOLD) or (not state)

    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            -- ONLY change if the state is different (Crucial for FPS)
            if part.CanCollide ~= shouldCollide then
                part.CanCollide = shouldCollide
            end
        end
    end
end

-- MAIN LOOP
RunService.Heartbeat:Connect(function()
    if not getgenv().NoCollisionPlayer then return end
    
    -- Throttle the check speed
    local now = tick()
    if now - lastCheck < CHECK_SPEED then return end
    lastCheck = now

    local char = LocalPlayer.Character
    local localHRP = char and char:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end
    local localPos = localHRP.Position

    -- 1. Check Players
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            fixModelCollision(plr.Character, localPos, true)
        end
    end

    -- 2. Check Cached NPCs (Fastest way)
    for _, npc in ipairs(npcCache) do
        if npc and npc.Parent then
            fixModelCollision(npc, localPos, true)
        end
    end
end)
