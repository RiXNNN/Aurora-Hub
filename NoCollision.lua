if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local RANGE = 15
local CHECK_SPEED = 0.05

local localPartsCache = {}
local ragdolled = false

local function cacheLocalParts(char)
    localPartsCache = {}
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            localPartsCache[obj] = obj.CanCollide
        end
    end
end

local function setLocalCollision(enabled)
    local char = LocalPlayer.Character
    if not char then return end

    for part, original in pairs(localPartsCache) do
        if part and part.Parent then
            part.CanCollide = enabled and original or false
        end
    end
end

local function ragdollExists()
    return Workspace:FindFirstChild(LocalPlayer.Name .. ":Ragdoll") ~= nil
end

local function hookRagdollWatcher()
    ragdolled = ragdollExists()
    if ragdolled then
        setLocalCollision(true)
    end

    Workspace.ChildAdded:Connect(function(child)
        if child.Name == LocalPlayer.Name .. ":Ragdoll" then
            ragdolled = true
            setLocalCollision(true)
        end
    end)

    Workspace.ChildRemoved:Connect(function(child)
        if child.Name == LocalPlayer.Name .. ":Ragdoll" then
            ragdolled = false
        end
    end)
end

local function hasClearPath(fromPos, toPos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = Workspace:Raycast(fromPos, toPos - fromPos, params)
    if not result then
        return true
    end

    if result.Instance:IsDescendantOf(Players) then
        return true
    end

    return false
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    cacheLocalParts(char)
    task.wait(0.05)
    hookRagdollWatcher()
end)

task.spawn(function()
    while true do
        if getgenv().NoCollisionPlayer then
            if not ragdolled then
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

                if myRoot then
                    local allowNoclip = false

                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                local dist = (myRoot.Position - root.Position).Magnitude
                                if dist <= RANGE then
                                    if hasClearPath(myRoot.Position, root.Position) then
                                        allowNoclip = true
                                        break
                                    end
                                end
                            end
                        end
                    end

                    setLocalCollision(not allowNoclip)
                end
            end
        else
            setLocalCollision(true)
        end

        task.wait(CHECK_SPEED)
    end
end)
