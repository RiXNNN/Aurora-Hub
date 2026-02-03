-- Global Toggle: Connect this to your Rayfield button via _G.AntiBusy = Value
_G.AntiBusy = _G.AntiBusy or false
_G.FallCushion = true 

local Player = game.Players.LocalPlayer

-- [ BACKGROUND DEBUFF CLEANER ]
-- This runs constantly to make sure you are never "Busy" or "Stunned"
task.spawn(function()
    while task.wait() do
        if _G.AntiBusy then
            local char = Player.Character
            if char then
                -- List of all common debuffs found in your game's library
                local debuffs = {"Busy", "Stun", "Aggro", "Health", "Stamina", "Combat"}
                
                for _, name in ipairs(debuffs) do
                    local effect = char:FindFirstChild(name)
                    if effect then
                        effect:Destroy()
                    end
                end
            end
        end
    end
end)

-- [ THE "CRAZY MAN" VELOCITY CUSHION ]
-- High speed fall, zero impact damage
task.spawn(function()
    while task.wait() do
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if _G.FallCushion and root and root.Velocity.Y < -35 then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            
            local result = workspace:Raycast(root.Position, Vector3.new(0, -12, 0), rayParams)
            
            if result then
                -- The magic "Cushion"
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                root.CFrame = root.CFrame * CFrame.new(0, 0.5, 0)
                task.wait(0.2)
            end
        end
    end
end)
