local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Range = 20 -- Studs

local proximityConnection

local function toggleProximityNoCol(state)
    getgenv().NoCollisionPlayer = state
    
    -- Cleanup if toggled off
    if not state then
        if proximityConnection then proximityConnection:Disconnect() end
        -- Reset everyone one last time
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                for _, part in ipairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
        return
    end

    -- Optimized Loop
    proximityConnection = RunService.Heartbeat:Connect(function()
        local myChar = LP.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        
        local myPos = myChar.HumanoidRootPart.Position

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local distance = (myPos - otherRoot.Position).Magnitude
                    
                    -- Only affect parts if within range
                    local canCollide = distance > Range
                    
                    -- Only update if state actually needs to change (Prevents Lag)
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.CanCollide ~= canCollide then
                            part.CanCollide = canCollide
                        end
                    end
                end
            end
        end
    end)
end
