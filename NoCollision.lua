local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local groupName = "OnlyMeNoCol"

-- 1. Setup the Group to ignore "Default" (everyone else)
pcall(function()
    if not PhysicsService:IsCollisionGroupRegistered(groupName) then
        PhysicsService:RegisterCollisionGroup(groupName)
    end
end)
-- This makes the group NOT collide with the standard 'Default' group
PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)
-- This makes sure you don't collide with yourself/other ghost parts
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

local function applyMyCollision(state)
    local char = LocalPlayer.Character
    if not char then return end
    
    local group = state and groupName or "Default"
    
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = group
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then handle.CollisionGroup = group end
        end
    end
end

-- 2. Handle Respawning (Since your game has custom respawn scripts)
LocalPlayer.CharacterAdded:Connect(function(character)
    if getgenv().NoCollisionPlayer then
        -- task.defer waits for the game's custom health/respawn scripts to finish
        task.defer(function()
            applyMyCollision(true)
        end)
    end
end)

-- 3. Rayfield Connection Function
local function toggleOnlyMe(state)
    getgenv().NoCollisionPlayer = state
    applyMyCollision(state)
end
