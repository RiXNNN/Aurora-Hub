local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local nocolConnection = nil

local function startNoCollision()
    -- Disconnect any old version to prevent stacking lag
    if nocolConnection then nocolConnection:Disconnect() end

    nocolConnection = RunService.Stepped:Connect(function()
        local char = LP.Character
        if not char then return end
        
        -- Efficiently target only the main collision parts
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false 
                -- Note: This makes you walk through players/NPCs
                -- If you fall through the floor, we need to add a floor check
            end
        end
    end)
end

local function stopNoCollision()
    if nocolConnection then
        nocolConnection:Disconnect()
        nocolConnection = nil
    end
    -- Reset character collision to normal
    local char = LP.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- RAYFIELD TOGGLE FUNCTION
local function toggleGhost(Value)
    getgenv().NoCollisionPlayer = Value
    if Value then
        startNoCollision()
    else
        stopNoCollision()
    end
end
