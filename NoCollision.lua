if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local RANGE = 15
local CHECK_SPEED = 0.05

local collisionState = {}

local function isRagdolled(player)
    return Workspace:FindFirstChild(player.Name .. ":Ragdoll") ~= nil
end

local function setOtherCollision(char, enabled)
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if collisionState[char] == enabled then return end
    collisionState[char] = enabled

    root.CanCollide = enabled
end

task.spawn(function()
    while true do
        if getgenv().NoCollisionPlayer then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if myRoot then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local char = player.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")

                        if root then
                            if isRagdolled(player) then
                                setOtherCollision(char, true)
                            else
                                local dist = (myRoot.Position - root.Position).Magnitude
                                setOtherCollision(char, dist > RANGE)
                            end
                        end
                    end
                end
            end
        else
            for char in pairs(collisionState) do
                if char and char.Parent then
                    setOtherCollision(char, true)
                end
            end
            collisionState = {}
        end

        task.wait(CHECK_SPEED)
    end
end)
