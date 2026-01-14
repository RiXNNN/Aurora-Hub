local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Settings
local RANGE = 15 
local CHECK_SPEED = 0.05 -- Slightly faster check to prevent physics glitches

-- R6 Specific Parts
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}

local function setCollision(char, noCol)
    if not char then return end
    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.CanCollide = not noCol
            -- ANTI-FLING ADDITIONS:
            part.CanTouch = not noCol -- Stops touch-based physics recoil
            if noCol then
                part.Massless = true -- Makes them weightless so they can't "push" you
                part.Velocity = Vector3.new(0,0,0) -- Zeroes out momentum
                part.RotVelocity = Vector3.new(0,0,0)
            else
                part.Massless = false
            end
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
                        
                        if distance <= RANGE then
                            setCollision(otherPlayer.Character, true)
                        else
                            setCollision(otherPlayer.Character, false)
                        end
                    end
                end
            end
        else
            -- Cleanup: Reset everyone when toggle is OFF
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    setCollision(player.Character, false)
                end
            end
        end
        task.wait(CHECK_SPEED)
    end
end)
