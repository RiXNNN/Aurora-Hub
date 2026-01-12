local PhysicsService = game:GetService("PhysicsService")
local groupName = "AuroraNoCol"

pcall(function()
    PhysicsService:RegisterCollisionGroup(groupName)
end)
PhysicsService:CollisionGroupSetCollidable(groupName, groupName, false)

local function applyGroup(char, state)
    local group = state and groupName or "Default"
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = group
        end
    end
end

Bug:CreateToggle({
    Name = "No Player Collision",
    CurrentValue = false,
    Flag = "NoCol_F",
    Callback = function(Value)
        getgenv().NoCollisionPlayer = Value
        
        if LocalPlayer.Character then
            applyGroup(LocalPlayer.Character, Value)
        end 
            
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                applyGroup(plr.Character, Value)
            end
        end
    end,
})

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if getgenv().NoCollisionPlayer then
        applyGroup(char, true)
    end
end)
