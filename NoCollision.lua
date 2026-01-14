if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local RANGE = 15
local CHECK_SPEED = 0.055

local localPartsCache = {}

local function cacheLocalParts(char)
    localPartsCache = {}
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            localPartsCache[obj] = obj.CanCollide
        end
    end
end

local function setLocalCollision(state)
    local char = LocalPlayer.Character
    if not char then return end

    for part, original in pairs(localPartsCache) do
        if part and part.Parent then
            part.CanCollide = state and original or false
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    cacheLocalParts(char)
end)

task.spawn(function()
    while true do
        if getgenv().NoCollisionPlayer then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if myRoot then
                local nearPlayer = false

                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local root = player.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            if (myRoot.Position - root.Position).Magnitude <= RANGE then
                                nearPlayer = true
                                break
                            end
                        end
                    end
                end

                setLocalCollision(not nearPlayer)
            end
        else
            setLocalCollision(true)
        end

        task.wait(CHECK_SPEED)
    end
end)
