local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local groupName = "AuroraStatic"

-- 1. Create the Group once
pcall(function()
    if not PhysicsService:IsCollisionGroupRegistered(groupName) then
        PhysicsService:RegisterCollisionGroup(groupName)
    end
end)
PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

-- 2. Ultra-Fast Assignment (No checks, no loops through Accessories)
local function setCharacterGhost(char)
    if not char then return end
    -- We only target the main body parts to save the engine from stress
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = groupName
        end
    end
end

-- 3. Event-Based logic (This uses 0% CPU when no one is spawning)
local function onCharacterAdded(character)
    if getgenv().NoCollisionPlayer then
        -- Wait for the game's health script to finish its setup
        task.wait(2) 
        setCharacterGhost(character)
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then onCharacterAdded(player.Character) end
end

-- Start listening
Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
