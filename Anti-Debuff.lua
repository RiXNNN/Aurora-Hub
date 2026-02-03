if getgenv().__ANTI_DEBUFF_LOADED then return end
getgenv().__ANTI_DEBUFF_LOADED = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local TargetRemote = game:GetService("ReplicatedStorage").Remotes.Async

local function removeDebuffs()
    local character = LP.Character
    if not character or not character.Parent then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    -- [[ JUMPPOWER FIX ]]
    if humanoid then
        humanoid.JumpPower = 60 
        humanoid.UseJumpPower = true
    end

    for _, obj in ipairs(character:GetChildren()) do
        local n = obj.Name
        
        -- [[ ALWAYS REMOVE (Non-Toggle) ]]
        -- Removed "Stun" from here so the toggle can control it
        if n == "Combat" or n == "Aggro" or n == "Health" or n == "Stamina" 
        or n:lower():find("cooldown") or n:lower():find("activate") or n:lower():find("slow") then
            pcall(function() obj:Destroy() end)
        end

        -- [[ TOGGLE CONTROLLED: BUSY & STUN ]]
        -- Now checking the toggle for both debuffs
        if getgenv().NoStun and (n == "Busy" or n == "Stun") then
            pcall(function() obj:Destroy() end)
        end
    end
end

-- Loop
task.spawn(function()
    while true do
        removeDebuffs()
        task.wait(0.150)
    end
end)

-- Fall Damage Hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = table.pack(...)
    
    if self.Name == "Async" and args[2] == "FallDamageServer" then
        args[3] = 0
        return oldNamecall(self, table.unpack(args))
    end
    
    return oldNamecall(self, ...)
end)
