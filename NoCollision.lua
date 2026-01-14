local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local groupName = "AuroraNoCol"

-- Settings
local RANGE = 15 
local CHECK_WAIT = 0.060 -- Your requested speed

-- Engine Setup
pcall(function()
    PhysicsService:RegisterCollisionGroup(groupName)
end)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

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

-- RAYFIELD TOGGLE EXAMPLE
-- Replace your existing Toggle code with this:
local Toggle = Tab:CreateToggle({
   Name = "No Collision (Range)",
   CurrentValue = false,
   Flag = "NoColToggle", 
   Callback = function(Value)
       getgenv().NoCollisionPlayer = Value -- Sets the global variable
   end,
})

-- The Background Loop (Always running, waiting for the toggle)
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
                        
                        -- Apply no-collision only if within range
                        if distance <= RANGE then
                            setCollision(otherPlayer.Character, true)
                        else
                            setCollision(otherPlayer.Character, false)
                        end
                    end
                end
            end
        else
            -- If toggle is OFF, reset everyone to Default once
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    setCollision(player.Character, false)
                end
            end
        end
        
        task.wait(CHECK_WAIT)
    end
end)
