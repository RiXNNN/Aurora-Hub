if getgenv().__ANTI_DEBUFF_LOADED then return end
getgenv().__ANTI_DEBUFF_LOADED = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Background debuffs (Always on)
local BACKGROUND = {
    Ragdoll = true, Down = true, Combat = true, 
    Aggro = true, Health = true, Stamina = true,
    Stun= true
}

local function removeDebuffs()
    if not character or not character.Parent then return end

    for _, obj in ipairs(character:GetChildren()) do
        local n = obj.Name
        
        -- 1. YOUR BACKGROUND LOGIC
        if BACKGROUND[n] or n:lower():find("cooldown") then
            pcall(function() obj:Destroy() end)
        end

        -- 2. TOGGLE: BUSY (Testing if this fixes speed)
        if getgenv().NoBusy and n == "Busy" then
            pcall(function() obj:Destroy() end)
        end

        -- 3. TOGGLE: STUN
        if getgenv().NoStun and (n == "Stun" or n:lower():find("activate")) then
            pcall(function() obj:Destroy() end)
        end
        
        -- 4. TOGGLE: SLOW
        if getgenv().NoSlow and n:lower():find("slow") then
            pcall(function() obj:Destroy() end)
        end
    end
end

-- Your exact loop logic
task.spawn(function()
    while true do
        removeDebuffs()
        task.wait(0.1)
    end
end)

-- Your exact respawn logic
player.CharacterAdded:Connect(function(char)
    character = char
    task.wait(1)
    removeDebuffs()
end)

-- Your exact Fall Damage hook
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    if getnamecallmethod() == "FireServer" and args[2] == "FallDamageServer" then
        return task.wait(9e9)
    end
    return old(self, ...)
end))
