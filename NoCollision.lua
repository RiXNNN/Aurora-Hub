local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Settings
local RANGE = 15 
local CHECK_SPEED = 0.060 

-- Only limbs (Removing HumanoidRootPart from here stops the freezing/stucking)
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local function setCollision(char, noCol)
    if not char then return end
    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            -- This is your logic: just simple CanCollide
            part.CanCollide = not noCol
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
                        
                        -- If close, turn off collision for limbs ONLY
                        if distance <= RANGE then
                            setCollision(otherPlayer.Character, true)
                        else
                            setCollision(otherPlayer.Character, false)
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
