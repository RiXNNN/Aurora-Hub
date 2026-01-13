local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local DIST_THRESHOLD = 6 -- Your preferred range
local THROTTLE_TIME = 0.2 -- Checks 5 times a second
local lastUpdate = 0
local inRangePlayers = {} -- Keeps track of who is currently "No-Col"

local KatanaNames = {["Katana"] = true, ["Katana2"] = true, ["Blade"] = true}

local function toggleCollisions(char, shouldCollide)
    if not char then return end
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            -- Only change if it's currently wrong (saves performance)
            if part.CanCollide ~= shouldCollide then
                part.CanCollide = shouldCollide
            end
        elseif part:IsA("Model") or part:IsA("Tool") then
            if KatanaNames[part.Name] then
                for _, kPart in ipairs(part:GetDescendants()) do
                    if kPart:IsA("BasePart") then
                        if kPart.CanCollide ~= shouldCollide then
                            kPart.CanCollide = shouldCollide
                        end
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not getgenv().NoCollisionPlayer then 
        -- Reset everyone if feature is toggled off
        if next(inRangePlayers) ~= nil then
            for player, _ in pairs(inRangePlayers) do
                if player.Character then toggleCollisions(player.Character, true) end
            end
            inRangePlayers = {}
        end
        return 
    end
    
    local now = tick()
    if now - lastUpdate < THROTTLE_TIME then return end
    lastUpdate = now

    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local char = player.Character
            local hisRoot = char:FindFirstChild("HumanoidRootPart")
            
            if hisRoot then
                local distance = (myPos - hisRoot.Position).Magnitude
                
                if distance < DIST_THRESHOLD then
                    -- ALWAYS enforce No-Col while in range
                    -- This prevents the game from resetting them to solid
                    toggleCollisions(char, false)
                    inRangePlayers[player] = true
                else
                    -- If they WERE in range but now they are far away
                    if inRangePlayers[player] then
                        toggleCollisions(char, true)
                        inRangePlayers[player] = nil
                    end
                end
            end
        end
    end
end)
