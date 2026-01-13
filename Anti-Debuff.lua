if getgenv().__ANTI_DEBUFF_LOADED then return end
getgenv().__ANTI_DEBUFF_LOADED = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

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
        -- Background removals (Always On)
        if BACKGROUND_DEBUFFS[n] or n:lower():find("cooldown") then
            pcall(function() obj:Destroy() end)
        end
        -- Toggle removals (Only if NoStun is true)
        if getgenv().NoStun then
            if n == "Stun" or n:lower():find("activate") then
                pcall(function() obj:Destroy() end)
            end
        end
    end
end

-- Hook Fall Damage
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    if getnamecallmethod() == "FireServer" and args[2] == "FallDamageServer" then
        return nil 
    end
    return old(self, ...)
end))

-- Main Loop
task.spawn(function()
    while true do
        if LP.Character then
            removeDebuffs(LP.Character)
        end
        task.wait(0.1)
    end
end)
