getgenv().NoStun = false 
_G.FallCushion = true    

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local DEBUFFS = {
    ["Busy"] = true,
    ["Stun"] = true,
    ["Combat"] = true,
    ["Aggro"] = true,
    ["Health"] = true,
    ["Stamina"] = true,
    ["Ragdoll"] = true
}

-- [ THE FRAME-BY-FRAME KILLER ]
RunService.Heartbeat:Connect(function()
    if getgenv().NoStun and character then
        -- This is the fastest possible check in Roblox
        local children = character:GetChildren()
        for i = 1, #children do
            local obj = children[i]
            local name = obj.Name
            
            if DEBUFFS[name] or name:lower():find("cooldown") or name:lower():find("activate") then
                obj.Parent = nil -- Moving to nil is faster than Destroy() for bypassing stuns
                obj:Destroy()
            end
        end
    end
end)

-- [ THE "CRAZY MAN" FALL CUSHION ]
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

-- [ AUTO-ESCAPE ]
task.spawn(function()
    while task.wait(0.4) do
        if character and character:FindFirstChild("Down") then
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async")
            remote:FireServer("Character", "FallDamageServer", 10000)
            task.wait(2)
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
end)
