local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local groupName = "AuroraNoCol"

-- Engine Setup: Creates the collision group if it doesn't exist
pcall(function()
    PhysicsService:RegisterCollisionGroup(groupName)
end)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

-- R6 Optimized Function: Only targets the 6 main limbs
local function applyCollisionState(char, state)
    if not char then return end
    local group = state and groupName or "Default"
    
    -- Standard R6 Body Parts
    local r6Parts = {
        "Head", 
        "Torso", 
        "Left Arm", 
        "Right Arm", 
        "Left Leg", 
        "Right Leg"
    }

    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.CollisionGroup = group
        end
    end
end

-- Efficiently updates all players currently in the server
local function updateAllCollisions()
    local state = getgenv().NoCollisionPlayer
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            applyCollisionState(player.Character, state)
        end
    end
end

-- Listener: Handles players joining or respawning
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if getgenv().NoCollisionPlayer then
            -- Small wait to ensure R6 joints are fully initialized
            character:WaitForChild("HumanoidRootPart", 5)
            applyCollisionState(character, true)
        end
    end)
end)

-- Main Loop: Checks for toggle changes
task.spawn(function()
    local lastState = getgenv().NoCollisionPlayer
    while true do
        if getgenv().NoCollisionPlayer ~= lastState then
            lastState = getgenv().NoCollisionPlayer
            updateAllCollisions()
        end
        -- 0.1 is very fast (10 times a second) but uses almost zero CPU
        task.wait(0.06) 
    end
end)

-- Initial run to apply to existing players
updateAllCollisions()
