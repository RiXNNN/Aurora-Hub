local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local groupName = "AuroraNoCol"

-- Engine Setup (Internal)
pcall(function()
    PhysicsService:RegisterCollisionGroup(groupName)
end)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

local function applyCollisionState(char, state)
    local group = state and groupName or "Default"
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = group
        end
    end
end

-- This function replaces the laggy loop
local function updateAllCollisions()
    local state = getgenv().NoCollisionPlayer
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            applyCollisionState(player.Character, state)
        end
    end
end

-- Listener for new players joining while toggle is ON
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if getgenv().NoCollisionPlayer then
            task.wait(0.5) -- Wait for character to fully load
            applyCollisionState(character, true)
        end
    end)
end)

-- Main logic trigger
-- This checks if the global variable changed and updates accordingly
task.spawn(function()
    local lastState = getgenv().NoCollisionPlayer
    while true do
        if getgenv().NoCollisionPlayer ~= lastState then
            lastState = getgenv().NoCollisionPlayer
            updateAllCollisions()
        end
        task.wait(0.5) -- Only checks state twice a second (zero lag)
    end
end)

-- Initial run
updateAllCollisions()
