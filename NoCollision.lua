local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local groupName = "UltraGhost"

-- 1. Setup the Group once (No CPU cost)
pcall(function()
    if not PhysicsService:IsCollisionGroupRegistered(groupName) then
        PhysicsService:RegisterCollisionGroup(groupName)
    end
end)

-- 2. Define the Rule: Your group ignores the 'Default' group (all other players/NPCs)
PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)

local function makeMeGhost(state)
    local char = LP.Character
    if not char then return end
    
    local targetGroup = state and groupName or "Default"
    
    -- We ONLY touch your parts. This prevents the 'Freezing' and 'FPS Lag' 
    -- because we aren't fighting the game's scripts on other players.
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = targetGroup
        end
    end
end

-- 3. The "Low Impact" Listener: Only runs when YOU respawn
LP.CharacterAdded:Connect(function(char)
    if getgenv().NoCollisionPlayer then
        task.wait(1) -- Wait for the game's 'Collisions' folder to load
        makeMeGhost(true)
    end
end)

-- RAYFIELD TOGGLE HOOK
-- You can put this in your toggle callback:
-- getgenv().NoCollisionPlayer = Value
-- makeMeGhost(Value)
