local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local groupName = "AuroraNoCol"

pcall(function()
    PhysicsService:RegisterCollisionGroup(groupName)
end)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

local function applyCollisionState(char, state)
    if not char then return end
    local group = state and groupName or "Default"
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = group
        elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
            part.Handle.CollisionGroup = group
        end
    end
end

local function toggleNoClip(state)
    getgenv().NoCollisionPlayer = state
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            applyCollisionState(player.Character, state)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if getgenv().NoCollisionPlayer then
            task.wait(0.1) 
            applyCollisionState(character, true)
        end
    end)
end)
