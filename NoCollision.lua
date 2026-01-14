local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local groupName = "AuroraNoCol"

-- Settings
local RANGE = 15 -- Adjust this number for how close you need to be
local CHECK_SPEED = 0.060 -- 17 checks per second

-- Create Collision Group
pcall(function()
    PhysicsService:RegisterCollisionGroup(groupName)
end)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

-- R6 Specific Parts
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local function setCollision(char, noCol)
    if not char then return end
    local group = noCol and groupName or "Default"
    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.CollisionGroup = group
        end
    end
end

-- Main Loop
task.spawn(function()
    while true do
        if getgenv().NoCollisionPlayer then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    
                    if myRoot and otherRoot then
                        local distance = (myRoot.Position - otherRoot.Position).Magnitude
                        
                        -- Apply no-collision if within range
                        if distance <= RANGE then
                            setCollision(otherPlayer.Character, true)
                        else
                            setCollision(otherPlayer.Character, false)
                        end
                    end
                end
            end
        else
            -- If toggle is OFF, reset everyone
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    setCollision(player.Character, false)
                end
            end
        end
        task.wait(CHECK_SPEED)
    end
end)
