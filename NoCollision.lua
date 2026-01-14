local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RANGE = 15 
local CHECK_SPEED = 0.060 

local r6Parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local function setCollision(char, noCol)
    if not char then return end
    for _, partName in ipairs(r6Parts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.CanCollide = not noCol
            
            if noCol then
                part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                local touch = part:FindFirstChildOfClass("TouchTransmitter")
                if touch then touch:Destroy() end 
            else
                part.CustomPhysicalProperties = nil
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
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    setCollision(player.Character, false)
                end
            end
        end
        task.wait(CHECK_SPEED)
    end
end)
