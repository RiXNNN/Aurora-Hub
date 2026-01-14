local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RANGE = 15 
local CHECK_SPEED = 0.05 
local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}

local activeCollisionMap = {} 

local function setCollision(char, noCol)
    if not char then return end
    -- Using GetFullName ensures NPCs with same names don't conflict
    local charID = char:GetFullName()
    
    if activeCollisionMap[charID] == noCol then return end 
    activeCollisionMap[charID] = noCol

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
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if myRoot then
            -- --- PART 1: PLAYERS ---
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if otherRoot then
                        local distance = (myRoot.Position - otherRoot.Position).Magnitude
                        local shouldNoCol = getgenv().NoCollisionPlayer and (distance <= RANGE)
                        setCollision(otherPlayer.Character, shouldNoCol)
                    end
                end
            end

            -- --- PART 2: NPCs ---
            -- We only run this loop if the NPC toggle is actually ON to save FPS
            if getgenv().NoCollisionNPC then
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        local npcRoot = obj:FindFirstChild("HumanoidRootPart")
                        if npcRoot then
                            local distance = (myRoot.Position - npcRoot.Position).Magnitude
                            setCollision(obj, distance <= RANGE)
                        end
                    end
                end
            end
        end

        -- --- PART 3: CLEANUP ---
        -- If both toggles are OFF, reset everything once
        if not getgenv().NoCollisionPlayer and not getgenv().NoCollisionNPC then
            if next(activeCollisionMap) ~= nil then
                -- Reset Players
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character then setCollision(player.Character, false) end
                end
                -- Reset NPCs in workspace
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                        setCollision(obj, false)
                    end
                end
                activeCollisionMap = {}
            end
        end

        task.wait(CHECK_SPEED)
    end
end)
