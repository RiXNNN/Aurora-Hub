local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Settings
local RANGE = 15 
local CHECK_SPEED = 0.060 

-- Only limbs (Root stays solid to prevent freezing)
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local function setCollision(char, noCol)
    if not char then return end
    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            -- 1. YOUR LOGIC
            part.CanCollide = not noCol
            
            -- 2. THE ANTI-FLING FIX (Zero Friction & No Touch)
            if noCol then
                part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0) -- Makes them "slippery" so no fling
                local touch = part:FindFirstChildOfClass("TouchTransmitter")
                if touch then touch:Destroy() end -- Removes the "hit" detection
            else
                part.CustomPhysicalProperties = nil -- Resets to normal
            end
        end
    end
end

-- Main Loop (The CPU-Friendly task.spawn you like)
task.spawn(function()
    while true do
        if getgenv().NoCollisionPlayer then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if myRoot then
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                        local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if otherRoot then
                            local distance = (myRoot.Position - otherRoot.Position).Magnitude
                            
                            if distance <= RANGE then
                                setCollision(otherPlayer.Character, true)
                            else
                                setCollision(otherPlayer.Character, false)
                            end
                        end
                    end
                end
            end
        else
            -- Clean reset
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    setCollision(player.Character, false)
                end
            end
        end
        task.wait(CHECK_SPEED)
    end
end)
