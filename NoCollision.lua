local Players = game:GetService("Players")

-- Applies no collision to a character
local function applyCollisionState(char, state)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- Updates all player collisions based on global toggle
local function updateAllCollisions()
    local state = getgenv().NoCollisionPlayer
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            applyCollisionState(player.Character, state)
        end
    end
end

-- Apply no collision to newly added characters
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if getgenv().NoCollisionPlayer then
            task.wait(0.5) -- Wait for character to load
            applyCollisionState(character, true)
        end
    end)
end)

-- Continuously watch for toggle changes
task.spawn(function()
    local lastState = getgenv().NoCollisionPlayer
    while true do
        if getgenv().NoCollisionPlayer ~= lastState then
            lastState = getgenv().NoCollisionPlayer
            updateAllCollisions()
        end
        task.wait(0.1)
    end
end)

-- Initial run
updateAllCollisions()
