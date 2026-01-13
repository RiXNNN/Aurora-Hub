local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local groupName = "AuroraLazy"
local Range = 25

-- Setup Group once
pcall(function()
    if not PhysicsService:IsCollisionGroupRegistered(groupName) then
        PhysicsService:RegisterCollisionGroup(groupName)
    end
end)
PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)

local function setCharGroup(char, isGhost)
    if not char then return end
    local group = isGhost and groupName or "Default"
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.CollisionGroup ~= group then
            part.CollisionGroup = group
        end
    end
end

-- This loop is the "Brain" - it runs slowly to save FPS
task.spawn(function()
    while true do
        task.wait(0.8) -- Slow check (Huge FPS boost)
        
        if getgenv().NoCollisionPlayer then
            local myChar = LP.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            
            if myRoot then
                local foundAnyone = false
                
                -- Check if ANYONE is close
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character then
                        local hisRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if hisRoot and (myRoot.Position - hisRoot.Position).Magnitude < Range then
                            foundAnyone = true
                            break
                        end
                    end
                end
                
                -- Only change YOUR character's physics if someone is actually near
                if foundAnyone then
                    setCharGroup(myChar, true)
                else
                    setCharGroup(myChar, false)
                end
            end
        end
    end
end)

-- Rayfield Toggle just sets the variable
-- Callback = function(Value) getgenv().NoCollisionPlayer = Value end
