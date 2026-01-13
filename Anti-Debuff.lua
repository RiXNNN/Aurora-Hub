if getgenv().__ANTI_DEBUFF_LOADED then return end
getgenv().__ANTI_DEBUFF_LOADED = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function removeDebuffs()
    local character = LP.Character
    if not character or not character.Parent then return end

    for _, obj in ipairs(character:GetChildren()) do
        local n = obj.Name
        
        -- [[ BACKGROUND: YOUR EXACT LIST ]]
        -- These are always removed instantly
        if n == "Ragdoll" or n == "Down" or n == "Stun" or n == "Combat" 
        or n == "Aggro" or n == "Health" or n == "Stamina" 
        or n:lower():find("cooldown") or n:lower():find("activate") or n:lower():find("slow") then
            pcall(function() obj:Destroy() end)
        end

        -- [[ TOGGLE CONTROLLED: BUSY ]]
        -- Only removed when the "No Stun" toggle is ON
        if getgenv().NoStun and n == "Busy" then
            pcall(function() obj:Destroy() end)
        end
    end
end

-- Your 0.1s Loop
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
