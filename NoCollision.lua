local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RANGE = 15 
local CHECK_SPEED = 0.05 
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}

local activeCollisionMap = {} 

local function setCollision(char, noCol)
    if not char then return end
    local charName = char.Name
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
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if myRoot then
            -- Loop through EVERYTHING in Workspace to find NPCs and Players
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= LocalPlayer.Character then
                    local isPlayer = Players:GetPlayerFromCharacter(obj)
                    local otherRoot = obj:FindFirstChild("HumanoidRootPart")
                    
                    if otherRoot then
                        local distance = (myRoot.Position - otherRoot.Position).Magnitude
                        local shouldNoCol = false
                        
                        -- Check if it's a player and if player-no-col is on
                        if isPlayer and getgenv().NoCollisionPlayer and distance <= RANGE then
                            shouldNoCol = true
                        -- Check if it's an NPC and if npc-no-col is on
                        elseif not isPlayer and getgenv().NoCollisionNPC and distance <= RANGE then
                            shouldNoCol = true
                        end
                        
                        setCollision(obj, shouldNoCol)
                    end
                end
            end
        end
        task.wait(CHECK_SPEED)
    end
end)
