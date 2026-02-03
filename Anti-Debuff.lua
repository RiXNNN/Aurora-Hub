--================================
--    THE "CRAZY MAN" HYBRID
--================================

getgenv().NoStun = false -- Linked to Rayfield Toggle
_G.FallCushion = true    -- Always on background

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local DEBUFFS = {
    Busy = true,
    Stun = true,
    Combat = true,
    Aggro = true,
    Health = true,
    Stamina = true,
}

local function removeDebuffs()
    if not getgenv().NoStun then return end -- BUTTON CHECK
    if not character or not character.Parent then return end

    for _, obj in ipairs(character:GetChildren()) do
        local n = obj.Name
        if DEBUFFS[n]
        or n:lower():find("cooldown")
        or n:lower():find("activate") then
            pcall(function()
                obj:Destroy()
            end)
        end
    end
end

-- 1. THE DEBUFF LOOP (Controlled by Button)
task.spawn(function()
    while true do
        if getgenv().NoStun then
            removeDebuffs()
        end
        task.wait(0.1) -- 10 times a second for speed
    end
end)

-- 2. THE "CRAZY MAN" FALL CUSHION (Always Background)
task.spawn(function()
    while task.wait() do
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if _G.FallCushion and root and root.Velocity.Y < -35 then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {character}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            
            local result = workspace:Raycast(root.Position, Vector3.new(0, -12, 0), rayParams)
            if result then
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                root.CFrame = root.CFrame * CFrame.new(0, 0.5, 0)
                task.wait(0.2)
            end
        end
    end
end)

-- 3. AUTO-ESCAPE (Background)
task.spawn(function()
    while task.wait(0.5) do
        if character and character:FindFirstChild("Down") then
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async")
            remote:FireServer("Character", "FallDamageServer", 10000)
            task.wait(2)
        end
    end
end)

-- Respawn Fix
player.CharacterAdded:Connect(function(char)
    character = char
end)
