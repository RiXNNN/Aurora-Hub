if getgenv().__ANTI_DEBUFF_LOADED then return end
getgenv().__ANTI_DEBUFF_LOADED = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function removeDebuffs()
    local character = LP.Character
    if not character or not character.Parent then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    -- [[ JUMPPOWER FIX ]]
    if humanoid then
        -- Forces JumpPower so debuffs don't keep you on the ground
        humanoid.JumpPower = 60 -- Set to 60 if you want the extra boost
        humanoid.UseJumpPower = true
    end

    for _, obj in ipairs(character:GetChildren()) do
        local n = obj.Name
        
        -- [[ BACKGROUND: ALWAYS REMOVE ]]
        if n == "Ragdoll" or n == "Down" or n == "Stun" or n == "Combat" 
        or n == "Aggro" or n == "Health" or n == "Stamina" 
        or n:lower():find("cooldown") or n:lower():find("activate") or n:lower():find("slow") then
            pcall(function() obj:Destroy() end)
        end

        -- [[ TOGGLE CONTROLLED: BUSY ]]
        if getgenv().NoStun and n == "Busy" then
            pcall(function() obj:Destroy() end)
        end
    end
end

-- Your 0.3s Loop
task.spawn(function()
    while true do
        removeDebuffs()
        task.wait(0.3)
    end
end)

-- Your Fall Damage bypass
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    if getnamecallmethod() == "FireServer" and args[2] == "FallDamageServer" then
        return task.wait(9e9)
    end
    return old(self, ...)
end))
