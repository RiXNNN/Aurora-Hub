if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local DIST_THRESHOLD = 25
local UPDATE_RATE = 0.25

-- PUBLIC TOGGLES (Rayfield controls these)
getgenv().NC_Players = false
getgenv().NC_NPCs = false

-- INTERNAL
local loopRunning = false
local lastState = setmetatable({}, { __mode = "k" })

-- UTILS
local function getHRP(model)
    return model and (
        model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChildWhichIsA("BasePart")
    )
end

local function setCollision(part, state)
    if part and part:IsA("BasePart") then
        if lastState[part] ~= state then
            part.CanCollide = state
            lastState[part] = state
        end
    end
end

local function processModel(model, localPos, fullBody)
    local hrp = getHRP(model)
    if not hrp then return end

    local shouldCollide = (hrp.Position - localPos).Magnitude >= DIST_THRESHOLD

    if fullBody then
        for _, part in ipairs(model:GetChildren()) do
            if part:IsA("BasePart") then
                setCollision(part, shouldCollide)
            end
        end
    else
        for _, name in ipairs({"HumanoidRootPart","UpperTorso","LowerTorso","Head"}) do
            setCollision(model:FindFirstChild(name), shouldCollide)
        end
    end
end

-- MAIN LOOP (SINGLE INSTANCE)
task.spawn(function()
    loopRunning = true

    while loopRunning do
        if not getgenv().NC_Players and not getgenv().NC_NPCs then
            task.wait(0.4)
            continue
        end

        local char = LocalPlayer.Character
        local myHRP = getHRP(char)

        if myHRP then
            local myPos = myHRP.Position

            -- PLAYERS
            if getgenv().NC_Players then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        processModel(plr.Character, myPos, true)
                    end
                end
            end

            -- NPCs
            if getgenv().NC_NPCs then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Model")
                        and obj ~= char
                        and obj:FindFirstChildOfClass("Humanoid")
                        and not Players:GetPlayerFromCharacter(obj)
                    then
                        processModel(obj, myPos, false)
                    end
                end
            end
        end

        task.wait(UPDATE_RATE)
    end
end)

-- RESPAWN CLEANUP (NO NEW LOOP)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    lastState = setmetatable({}, { __mode = "k" })
end)
