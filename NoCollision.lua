local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Settings
local RANGE = 15 
local CHECK_SPEED = 0.060 

-- R6 Specific Parts
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local function setCollision(char, noCol)
    if not char then return end
    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            -- We change CanCollide because it is allowed on the Client (Executor)
            -- This only affects your screen, so you walk through them
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
                -- Only affect OTHER players, never yourself (or you fall through the floor)
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
            -- If toggle is OFF, reset everyone EXCEPT yourself
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    setCollision(player.Character, false)
                end
            end
        end
        task.wait(CHECK_SPEED)
    end
end)
