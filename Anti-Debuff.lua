if getgenv().__ANTI_DEBUFF_LOADED then return end
getgenv().__ANTI_DEBUFF_LOADED = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Background Always-On Debuffs (Works 24/7 once loaded)
local BACKGROUND_DEBUFFS = {
    ["Busy"] = true,
    ["Ragdoll"] = true,
    ["Down"] = true,
    ["Combat"] = true,
    ["Aggro"] = true,
    ["Health"] = true,
    ["Stamina"] = true
}

local function removeDebuffs(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        local n = obj.Name
        
        -- 1. Background Removal (Everything except Stun)
        if BACKGROUND_DEBUFFS[n] or n:lower():find("cooldown") then
            pcall(function() obj:Destroy() end)
        end
        
        -- 2. Toggle Specific (Stun)
        if getgenv().NoStun then
            if n == "Stun" or n:lower():find("activate") then
                pcall(function() obj:Destroy() end)
            end
        end
    end
end

-- BACKGROUND: Fall Damage Bypass
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    if getnamecallmethod() == "FireServer" and args[2] == "FallDamageServer" then
        return nil 
    end
    return old(self, ...)
end))

-- Continuous Loop (0.1s for high FPS performance)
task.spawn(function()
    while true do
        removeDebuffs(LP.Character)
        task.wait(0.1)
    end
end)
