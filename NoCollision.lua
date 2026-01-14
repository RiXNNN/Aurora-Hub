local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RANGE = 15 
local CHECK_SPEED = 0.055 
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}

-- This cache stops the script from "re-setting" collision every frame if nothing changed
local activeCollisionMap = {} 

local function setCollision(char, noCol)
    if not char then return end
    local charName = char.Name
    
    -- Optimization: Only run if the state actually needs to change
    if activeCollisionMap[charName] == noCol then return end 
    activeCollisionMap[charName] = noCol

    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.CanCollide = not noCol
            part.CanTouch = not noCol
            if noCol then
                part.Massless = true
            else
                part.Massless = false
            end
        end
    end
end

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
                            -- Only calculate if the distance check passes
                            setCollision(otherPlayer.Character, distance <= RANGE)
                        end
                    end
                end
            end
        else
            -- Clean reset and clear cache when toggled off
            if next(activeCollisionMap) ~= nil then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        setCollision(player.Character, false)
                    end
                end
                activeCollisionMap = {}
            end
        end
        task.wait(CHECK_SPEED)
    end
end)
