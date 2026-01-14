if not game:IsLoaded() then
    game.Loaded:Wait()
end

local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local groupName = "AuroraNoCol"

pcall(function()
    PhysicsService:CreateCollisionGroup(groupName)
end)

-- IMPORTANT FIX:
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)
PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)
PhysicsService:CollisionGroupSetCollidable("Default", groupName, false)

local function applyCollisionState(char, state)
    local group = state and groupName or "Default"
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = group
        end
    end
end

-- PLAYER (LOCAL ONLY)
local function updateLocalPlayer()
    local char = LocalPlayer.Character
    if char then
        applyCollisionState(char, getgenv().NoCollisionPlayer)
    end
end

-- NPC SUPPORT
local function isNPC(model)
    return model:IsA("Model")
        and model:FindFirstChildOfClass("Humanoid")
        and not Players:GetPlayerFromCharacter(model)
end

local function updateNPCs()
    for _, obj in ipairs(workspace:GetChildren()) do
        if isNPC(obj) then
            applyCollisionState(obj, getgenv().NoCollisionNPC)
        end
    end
end

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    updateLocalPlayer()
end)

-- Watch for NPC spawns
workspace.ChildAdded:Connect(function(child)
    task.wait(0.2)
    if getgenv().NoCollisionNPC and isNPC(child) then
        applyCollisionState(child, true)
    end
end)

-- Toggle watcher (low cost)
task.spawn(function()
    local lastPlayer = getgenv().NoCollisionPlayer
    local lastNPC = getgenv().NoCollisionNPC

    while true do
        if getgenv().NoCollisionPlayer ~= lastPlayer then
            lastPlayer = getgenv().NoCollisionPlayer
            updateLocalPlayer()
        end

        if getgenv().NoCollisionNPC ~= lastNPC then
            lastNPC = getgenv().NoCollisionNPC
            updateNPCs()
        end

        task.wait(0.1)
    end
end)

-- Initial apply
updateLocalPlayer()
updateNPCs()
