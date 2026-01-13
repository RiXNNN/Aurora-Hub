local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local groupName = "HighFPS_Ghost"

-- 1. Setup the Group once
pcall(function()
    if not PhysicsService:IsCollisionGroupRegistered(groupName) then
        PhysicsService:RegisterCollisionGroup(groupName)
    end
end)

-- 2. The Logic: Your group will NOT collide with the 'Default' group (everyone else)
PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)

local function makeMeGhost(state)
    local char = LP.Character
    if not char then return end
    
    local targetGroup = state and groupName or "Default"
    
    -- We only change YOUR parts. This prevents other players from freezing.
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = targetGroup
        end
    end
end

-- 3. The "No-Loop" Listener: Only runs when YOU respawn
LP.CharacterAdded:Connect(function(char)
    if getgenv().NoCollisionPlayer then
        task.wait(1) -- Wait for the game's 'Collisions' folder to setup
        makeMeGhost(true)
    end
end)

-- RAYFIELD TOGGLE CONNECTION
-- Callback = function(Value)
--    getgenv().NoCollisionPlayer = Value
--    makeMeGhost(Value)
-- end
