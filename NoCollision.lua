local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local groupName = "LockedGhost"

-- 1. Create the "Ghost Layer" (Only runs once)
pcall(function()
    if not PhysicsService:IsCollisionGroupRegistered(groupName) then
        PhysicsService:RegisterCollisionGroup(groupName)
    end
end)
-- This makes anyone in this group unable to touch anyone in "Default"
PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

-- 2. The "Lock" Function
local function lockCollision(char, state)
    if not char then return end
    local targetGroup = state and groupName or "Default"
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            -- We only touch it if the group is wrong, preventing constant updates
            if part.CollisionGroup ~= targetGroup then
                part.CollisionGroup = targetGroup
            end
        end
    end
end

-- 3. The Low-Impact Monitor (Runs every 2 seconds)
task.spawn(function()
    while true do
        if getgenv().NoCollisionPlayer then
            for _, player in ipairs(Players:GetPlayers()) do
                -- Lock EVERY player into the ghost group
                if player.Character then
                    lockCollision(player.Character, true)
                end
            end
        end
        task.wait(2) -- Huge delay = 240 FPS stability
    end
end)
