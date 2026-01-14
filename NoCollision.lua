local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RANGE = 15 
local CHECK_SPEED = 0.050 

-- We EXCLUDE HumanoidRootPart to stop them from falling through the floor
local LimbParts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}

local activeCollisionMap = {} 

local function setCollision(char, noCol)
    if not char or not char.Parent then return end
    local charID = char:GetFullName()
    
    if activeCollisionMap[charID] == noCol then return end 
    activeCollisionMap[charID] = noCol

    for _, partName in ipairs(LimbParts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            -- ONLY change CanCollide. Do NOT touch Massless or CanTouch.
            part.CanCollide = not noCol
        end
    end
end

task.spawn(function()
    while true do
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then task.wait(1) continue end

        -- Handle Players
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if pRoot then
                    local dist = (myRoot.Position - pRoot.Position).Magnitude
                    local enabled = getgenv().NoCollisionPlayer and (dist <= RANGE)
                    setCollision(p.Character, enabled)
                end
            end
        end

        -- Handle NPCs
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                local nRoot = obj:FindFirstChild("HumanoidRootPart")
                if nRoot then
                    local dist = (myRoot.Position - nRoot.Position).Magnitude
                    local enabled = getgenv().NoCollisionNPC and (dist <= RANGE)
                    setCollision(obj, enabled)
                end
            end
        end

        task.wait(CHECK_SPEED)
    end
end)
