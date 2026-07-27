local Success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success or not Rayfield then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local isMainMenu = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):FindFirstChild("Damage") == nil
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local P = _G
local Async = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async")
local RemoteAsync = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async")
local RemoteSync = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sync")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Async")
local HairsFolder, SpecialFolder, FamilyFolder, MarksFolder, MarksPower
local HornsFolder, ClothesFolder, SlayerClothesFolder, PlayerUniformFolder
local FacesFolder, MouthsFolder, NosesFolder, ScarsFolder, EffectsFolder
local EyesFolder, ToolsFolder, TargetRemote, TPs
local AnimationsFolder, SoundsFolder, AccessorysFolder, SyncRemote
local CraftableFolder, Nichirins, Miscellaneous, Guns

if not isMainMenu then
    HairsFolder = ReplicatedStorage:WaitForChild("Hairs")
    SpecialFolder = HairsFolder:WaitForChild("Special")
    FamilyFolder = ReplicatedStorage:WaitForChild("Models"):WaitForChild("Family")
    MarksFolder = ReplicatedStorage:WaitForChild("Models"):WaitForChild("Marks")
    MarksPower = ReplicatedStorage:WaitForChild("Models"):WaitForChild("MarksPower")
    HornsFolder = ReplicatedStorage:WaitForChild("Onis"):WaitForChild("Apparence"):WaitForChild("Horn")
    ClothesFolder = ReplicatedStorage:WaitForChild("Clothes")
    SlayerClothesFolder = ReplicatedStorage:WaitForChild("Slayers"):WaitForChild("Apparence"):WaitForChild("Clothes")
    PlayerUniformFolder = ReplicatedStorage:WaitForChild("Uniforms")
    FacesFolder = ReplicatedStorage:WaitForChild("Faces")
    MouthsFolder = FacesFolder:WaitForChild("Mouths")
    NosesFolder = FacesFolder:WaitForChild("Noses")
    ScarsFolder = ReplicatedStorage:WaitForChild("Scars")
    EffectsFolder = ReplicatedStorage:WaitForChild("Onis"):WaitForChild("Apparence"):WaitForChild("Faces"):WaitForChild("Effect")
    EyesFolder = ReplicatedStorage:WaitForChild("Faces"):WaitForChild("Eyes")
    ToolsFolder = ReplicatedStorage:WaitForChild("Tools")
    TargetRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Async")
    TPs = loadstring(game:HttpGet('https://raw.githubusercontent.com/RiXNNN/Aurora-Hub/refs/heads/main/TeleportMenu.lua'))()
    AnimationsFolder = ReplicatedStorage:WaitForChild("Animations")
    SoundsFolder = ReplicatedStorage:WaitForChild("Sounds")
    AccessorysFolder = ReplicatedStorage:WaitForChild("Accessorys")
    -- Assign the new Craftable folders ONLY when in-game
    CraftableFolder = ReplicatedStorage:WaitForChild("Craftable")
    Nichirins = CraftableFolder:WaitForChild("Nichirins")
    Miscellaneous = CraftableFolder:WaitForChild("Miscellaneous")
    Guns = CraftableFolder:WaitForChild("Guns")
end
local LowHealthThreshold = 25
local AutoBoulderEnabled = false
local CurrentSound = nil
local lastExecute = 0
local ActiveTracks = {}
local DemonCancel = false
local CONFIG = {
    KatanaNames = {"Katana", "Katana2"}, 
    TrailName = "TrailSword",
    TargetValueName = "Executed",
    CleanupDelay = 0.1
}

local F = Rayfield.Flags

local ItemData = {} 
local ItemNames = {} 

table.sort(ItemNames)

local selectedItemName = nil
local Dropdown
local angle = 0
local lastMineTick = 0

local Config = {
    Enabled = fase,
    MaxDistance = 40,
    StartDelay = 0.48,
    CloseRangeThreshold = 15,
    CloseRangeDelay = 0.25
}

local lastBreathTime = 0
local CurrentAccColor = Color3.fromRGB(255, 255, 255)
local EquippedCustomAcc = nil
local ManualDamageValue = 0
local EscapeThreshold = 15
local AutoEscapeEnabled = false
local SavedData = game:GetService("TeleportService"):GetTeleportSetting("Quasar_Config")
if SavedData then
    SavedState = SavedData
    print("💫 Quasar Hub: Settings restored from teleport!")
end

local TARGET_MOBS = {
    ["Green Demon"] = true, ["Blue Demon"] = true, ["GreenDemon"] = true,
    ["BlueDemon"] = true, ["BlueDemonEntertaiment"] = true,
    ["GreenDemonEntertaiment"] = true, ["Enemy"] = true, ["ShinobuRaid"] = true, 
    ["KokushiboRaid"] = true, ["RengokuRaid"] = true, ["Yoriichi"] = true, 
    ["Yorichi"] = true, ["Gyutaro"] = true, ["Kaigaku"] = true, 
    ["Akaza"] = true, ["Douma"] = true, ["Doma"] = true, ["Kokushibo"] = true,
    ["FrostyOni"] = true
}
local T_INFO = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
local isBusy = false
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local originalAtmosphere = {Density = 0, Offset = 0}
local originalSounds = {}
local lastExecute = 0 
local lootTimer = 0 
local LastDetectedNames = {}
local skillIndex = 1
local modifiedKatanas = {}
local activeKatanas = {}
local CurrentColor = Color3.fromRGB(0, 0, 0)
local CurrentMaterial = Enum.Material.Sand
local CurrentTransparency = 0
local CurrentHornColor = Color3.fromRGB(0, 0, 0)
local CurrentHornMaterial = Enum.Material.Glass
local DefaultSkinColor = Color3.fromRGB(255, 204, 153)
local CurrentSkinColor = DefaultSkinColor
local SpecialScarColor = Color3.fromRGB(255, 255, 255)
local HaoriSlot = nil
local DemonCancel = false
local TARGET_NAME = "ScreenGui"
local panicUsers = {
    "STSxEricky", "STSxDarkzs", "IIKrevaII", "Onii_Kusanagi", "c1tor",
    "WizTrixer", "iJustZek", "el_morsa", "000_iiiRxmiro", "Capitantozino_xd",
    "vztoki", "Restryck", "1erKreva", "Estrenger", "Vulgo_xFuinha",
    "AlphaClang", "VerdadeiroZayon456", "hininibuh", "a3qvn", "vulnone",
    "ExoTrope", "Nanerki", "TheSleepyMage", "mestrechifu0739", "2players345",
    "ekus4s", "badestone33", "Antrolthebest", "leticiaaleal", "22ia2",
    "ShidouuKun", "iYuzaru", "TzsemZ", "Ap0sentada", "claricrusoe",
    "tglznn", "Alphirex", "Xaudre0", "roger1950", "Arro_x", "xDarkNinja67x"
}
local panicEnabled = false
local panicConn = nil
local EyeLayerColors = {
    ["Pupil"] = Color3.fromRGB(255, 255, 255),
    ["Sombraceia"] = Color3.fromRGB(255, 255, 255),
    ["Bonor"] = Color3.fromRGB(255, 255, 255),
    ["FundoList"] = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)}
}
local AccessorySlots = {
    ["Slot1"] = nil,
    ["Slot2"] = nil
}
local WaitingForDemon = false
local NPC_Coords = {
    ["Kokushibo"] = {Pos = Vector3.new(1827,1116,-5956), Internal = "Kokushibo"},
    ["Shinobu"] = {Pos = Vector3.new(-1641, 908, -6493), Internal = "Shinobu"},
    ["Uzui"] = {Pos = Vector3.new(-1268, 871, -6435), Internal = "Uzui"},
    ["Sanemi"] = {Pos = Vector3.new(-2512, 1161, -1486), Internal = "Shinazugawa"},
    ["Tanjiro"] = {Pos = Vector3.new(390, 816, -424), Internal = "Tanjiro"},
    ["Mitsuri"] = {Pos = Vector3.new(1179, 1077, -1107), Internal = "Mitsuri"},
    ["Iguro"] = {Pos = Vector3.new(994, 1070, -1138), Internal = "Iguro"},
    ["Tsuyuri"] = {Pos = Vector3.new(-1320, 871, -6240), Internal = "Tsuyuri"},
    ["Akaza"] = {Pos = Vector3.new(2587, 1193, -7376), Internal = "Akaza"},
    ["Tokito"] = {Pos = Vector3.new(3242, 778, -4048), Internal = "Tokito"},
    ["Rengoku"] = {Pos = Vector3.new(1503, 1236, -356), Internal = "Rengoku"},
    ["Uncle Kohon"] = {Pos = Vector3.new(3188, 794, -811), Internal = "Uncle Kohon"}
}
local SavedState = {
    Haori = "None",
	ClothesID = "None",
    Eyes = 0,
    Mouth = 0,
    Nose = 0,
    Scar1 = 0,
    Scar2 = 0,
    SScar1 = 0,
    SScar2 = 0,
    Slot1 = "None",
    Slot2 = "None",
    Horns = "0",
    Hair = "None",
    Aura = "None",
    Mark = "None",
    SkinColor = Color3.fromRGB(255, 230, 200)
}
local tpwalking = nil
local tpSpeed = 0
local barriersDisabled = false
local SPAM_DURATION = 1.0
local args2 = {"Lunge", "Server"}
local autoLungeEnabled = false
local isSpamming = false
local lastFire = 0
local rushDetected = false
local monitorConnection = nil
local spamConnection = nil
local queueteleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or (electron and electron.queue_on_teleport) or (sentinel and sentinel.queue_on_teleport)
local notifiedNoOres = false
local lastRefresh = 0
local isSearching = false
local RenderPoints = {
    Vector3.new(-4130, 834, 767),
    Vector3.new(-3722, 938, 1338),
    Vector3.new(1740, 1207, -1585),
    Vector3.new(-3546, 1306, -2852),
    Vector3.new(-2148, 1161, -1675),
    Vector3.new(-1748, 874, -3117)
}
_G.AutoMineEnabled = false
_G.SelectedMineral = "Sun Ore"
_G.CurrentTarget = nil
P.ParryEnabled = false
P.ParryHoldTime = 0.15
_G.Refilling = false
_G.CounterEnabled = false
_G.P_LD, _G.P_HD = 0.10, 0.190
_G.C_LD, _G.C_HD = 0.051, 0.115
_G.C_Key = "Six"
_G.BladeColor = Color3.fromRGB(255, 255, 255)
_G.TrailColor = Color3.fromRGB(255, 255, 255)
_G.L_Range = 0
_G.L_Power = 0
_G.T_Lifetime = 0.5
_G.CustomTrailEnabled = true
_G.CurrentMaterial = "Neon"
_G.BreathBarVisible = true
_G.GodmodeTriggerEnabled = false
_G.GodmodeKeybind = Enum.KeyCode.LeftControl
_G.BridgeActive = false
_G.LastHealTime = _G.LastHealTime or 0
_G.InfM1Enabled = false
_G.InfM1KeyText = "X"
P.AutoFarmNPC = false
P.SelectedNPCs = {} 
P.FarmDistanceX = 0
P.FarmDistanceY = -6.5
P.FarmDistanceZ = 0
P.TweenSpeed = 0.25
P.AutoSkillsEnabled = false
P.SelectedSkills = {}
P.IsUsingSkill = false
P.Executing = false

_G.S6_String = "T"
_G.S7_String = "LeftAlt"
_G.ST_String = "Y"
_G.SY_String = "U"

getgenv().HB_Enabled = true
getgenv().HB_MobsEnabled = true
getgenv().HB_ShowPlayers = true    
getgenv().HB_ShowBar = true        
getgenv().HB_ShowNPCNames = true   
getgenv().HB_ShowHealth = true     
getgenv().HB_ShowMaxHealth = true  
getgenv().HB_MaxDistance = 600
getgenv().NoCollisionPlayer = false
getgenv().NoStun = false
getgenv().AutoLoot = false
getgenv().LootRange = 10

local function queueScript()
    local HubUrl = "" 
    
    local scriptSource = [[
        repeat task.wait() until game:IsLoaded()
        loadstring(game:HttpGet("]] .. HubUrl .. [["))()
    ]]
    
    if queueteleport then
        pcall(function()
            -- Save your Quasar Hub settings before the jump
            TeleportService:SetTeleportSetting("Quasar_Config", SavedState)
            queueteleport(scriptSource)
        end)
    end
end

local teleporting = false
LocalPlayer.OnTeleport:Connect(function(State)
    if (State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress) and not teleporting then
        teleporting = true
        queueScript()
    end
end)

local function scanCategory(folder, categoryName)
    if not folder then return end 
    for _, item in ipairs(folder:GetChildren()) do
        if item:IsA("Folder") then
            table.insert(ItemNames, item.Name)
            ItemData[item.Name] = {
                Instance = item,
                Category = categoryName
            }
        end
    end
end

scanCategory(Nichirins, "Forge")
scanCategory(Miscellaneous, "Forge")
scanCategory(Guns, "Forge")

local function updateExistingBarriers()
    local map = workspace:FindFirstChild("Map")
    if map then
        local barriers = map:FindFirstChild("Barriers")
        if barriers then
            for _, descendant in ipairs(barriers:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = not barriersDisabled
                end
            end
        end
    end
end

local function PlayEmote(name)
    local char = game.Players.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    local animObj = AnimationsFolder:FindFirstChild(name)
    if animator and animObj then
        for _, t in pairs(ActiveTracks) do
            if t.IsPlaying then t:Stop() end
        end
        table.clear(ActiveTracks)
        if CurrentSound then
            CurrentSound:Stop()
            CurrentSound = nil
        end
        if name == "Laugh" then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("HUD", "Emote", "Laugh")
            end)
        end
        local track = animator:LoadAnimation(animObj)
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
        table.insert(ActiveTracks, track)
        task.delay(0.5, function()
            local moveConn
            moveConn = hum.Running:Connect(function(speed)
                if speed > 2.0 then
                    if track.IsPlaying then track:Stop() end
                    moveConn:Disconnect()
                end
            end)
            table.insert(ActiveTracks, {Stop = function() moveConn:Disconnect() end})
        end)
    end
end

local function applyFacePart(id, partName, folderSource)
    local char = game.Players.LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    local faceBlock = head and head:FindFirstChild("FaceBlock")
    
    if faceBlock then
        local targetDecal = faceBlock:FindFirstChild(partName)
        local source = folderSource:FindFirstChild(tostring(id))
        
        if not targetDecal then
            targetDecal = Instance.new("Decal")
            targetDecal.Name = partName
            targetDecal.Parent = faceBlock
        end

        if targetDecal and source and source:IsA("Decal") then
            targetDecal.Transparency = 0 
            targetDecal.Texture = source.Texture
            
            if partName:find("Scar") then
                targetDecal.ZIndex = -999 
                if partName:find("Special") then
                    targetDecal.Color3 = SpecialScarColor
                else
                    targetDecal.Color3 = Color3.new(1,1,1)
                end
            else
                targetDecal.Color3 = Color3.new(1,1,1)
            end
        end
    end
end

local function clearScars(scarType)
    local char = game.Players.LocalPlayer.Character
    local faceBlock = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("FaceBlock")
    if faceBlock then
        if scarType == "Normal" then
            if faceBlock:FindFirstChild("TrueScar1") then faceBlock.TrueScar1:Destroy() end
            if faceBlock:FindFirstChild("TrueScar2") then faceBlock.TrueScar2:Destroy() end
        elseif scarType == "Special" then
            if faceBlock:FindFirstChild("SpecialScar1") then faceBlock.SpecialScar1:Destroy() end
            if faceBlock:FindFirstChild("SpecialScar2") then faceBlock.SpecialScar2:Destroy() end
        end
    end
end

local function applySkinColor(color)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local bodyParts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    
    for _, name in pairs(bodyParts) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            part.Color = color
        end
    end
end

local function equipCustomAccessory(id)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end

    -- Remove old one
    if EquippedCustomAcc then
        EquippedCustomAcc:Destroy()
        EquippedCustomAcc = nil
    end

    if id == "None" then return end

    local source = AccessorysFolder:FindFirstChild(tostring(id))
    if not source then
        warn("Accessory " .. tostring(id) .. " not found in Accessorys folder!")
        return
    end

    -- Clone the whole part/mesh
    local cloned = source:Clone()
    cloned.Name = "EquippedCustomAcc_" .. tostring(id)
    cloned.Parent = char

    -- Set transparency to 0 and apply color
    for _, p in pairs(cloned:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = 0
            p.Color = CurrentAccColor
            p.Anchored = false
            p.CanCollide = false
            p.Massless = true
        end
    end
    if cloned:IsA("BasePart") then
        cloned.Transparency = 0
        cloned.Color = CurrentAccColor
        cloned.Anchored = false
        cloned.CanCollide = false
        cloned.Massless = true
    end

    -- Find weld inside and connect to Head
    local weld = cloned:FindFirstChildOfClass("Weld") or cloned:FindFirstChildOfClass("ManualWeld")
    if weld then
        weld.Part0 = cloned:IsA("BasePart") and cloned or cloned:FindFirstChildWhichIsA("BasePart")
        weld.Part1 = char.Head
    else
        -- Create a weld if none exists
        local newWeld = Instance.new("Weld")
        newWeld.Part0 = cloned:IsA("BasePart") and cloned or cloned:FindFirstChildWhichIsA("BasePart")
        newWeld.Part1 = char.Head
        newWeld.Parent = cloned
    end

    EquippedCustomAcc = cloned
end

local function equipClothes(id, folderSource)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local folder = folderSource:FindFirstChild(tostring(id))
    if folder then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end
        end
        local shirt = folder:FindFirstChildWhichIsA("Shirt")
        local pants = folder:FindFirstChildWhichIsA("Pants")
        if shirt then shirt:Clone().Parent = char end
        if pants then pants:Clone().Parent = char end
    end
end

local function equipLegendary(npcName)
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    if npcName == "Yoriichi Tsugikuni" then
        for _, v in pairs(char:GetChildren()) do if v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end end
        local s = FamilyFolder:FindFirstChild("Yoriichi Shirt")
        local p = FamilyFolder:FindFirstChild("Yoriichi Pants")
        if s then s:Clone().Parent = char end
        if p then p:Clone().Parent = char end
        return
    end

    local target = workspace:FindFirstChild("Npcs") and workspace.Npcs:FindFirstChild(npcName)
    if not target then 
        Rayfield:Notify({Title = "Not Found", Content = npcName .. " isn't loaded.", Duration = 3})
        return 
    end
    for _, v in pairs(char:GetChildren()) do if v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end end
    for _, item in pairs(target:GetDescendants()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item.Name == "Clothing" then
            item:Clone().Parent = char
        end
    end
end

local function applyStyle(obj)
    if not obj then return end
    local function stylePart(p)
        if p:IsA("BasePart") and p.Name ~= "Handle" then
            for _, child in pairs(p:GetChildren()) do
                if child:IsA("Texture") or child:IsA("Decal") then child:Destroy() end
            end
            if p:IsA("UnionOperation") then p.UsePartColor = true end
            p.Color = CurrentColor
            p.Material = CurrentMaterial
            p.Transparency = CurrentTransparency
        end
    end
    stylePart(obj)
    for _, p in pairs(obj:GetDescendants()) do stylePart(p) end
end

local function applyHornStyle(obj)
    if not obj then return end
    for _, p in pairs(obj:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Color = CurrentHornColor
            p.Material = CurrentHornMaterial
        end
    end
    if obj:IsA("BasePart") then
        obj.Color = CurrentHornColor
        obj.Material = CurrentHornMaterial
    end
end

local function updateAll()
    local char = game.Players.LocalPlayer.Character
    if char then
        local custom = char:FindFirstChild("EquippedHair")
        local original = char:FindFirstChild("Hair")
        local horn = char:FindFirstChild("EquippedHorns")
        if custom then applyStyle(custom) end
        if original then applyStyle(original) end
        if horn then applyHornStyle(horn) end
        applySkinColor(CurrentSkinColor)
    end
end

local function equipHorns(hornName)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    
    -- Remove game's original horn
    local originalHorn = char:FindFirstChild("Horn")
    if originalHorn then originalHorn:Destroy() end
    
    for _, v in pairs(char:GetChildren()) do if v.Name == "EquippedHorns" then v:Destroy() end end
    if hornName == "0" then return end
    local target = HornsFolder:FindFirstChild(hornName)
    if target then
        local newHorn = target:Clone()
        newHorn.Name = "EquippedHorns"
        newHorn.Parent = char
        applyHornStyle(newHorn)
        for _, item in pairs(newHorn:GetDescendants()) do
            if item:IsA("BasePart") then
                item.Anchored = false
                item.CanCollide = false
                item.Massless = true
            end
            if item:IsA("Weld") or item:IsA("ManualWeld") then
                item.Part1 = char.Head
            end
        end
    end
end

local function equipAura(auraName)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do if v:GetAttribute("IsAura") then v:Destroy() end end
    if auraName == "None" then return end
    local source = MarksPower:FindFirstChild(auraName)
    if not source then return end
    local specialSpread = {["Beast"] = true, ["Flower"] = true, ["Love"] = true, ["Snake"] = true}
    local limbs = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    local function cloneEffects(from, to)
        for _, effect in pairs(from:GetChildren()) do
            if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Beam") or effect:IsA("Light") or effect:IsA("Attachment") then
                local clone = effect:Clone(); clone:SetAttribute("IsAura", true); clone.Parent = to
            end
        end
    end
    if specialSpread[auraName] and source:FindFirstChild("Head") then
        for _, limbName in pairs(limbs) do
            local targetLimb = char:FindFirstChild(limbName)
            if targetLimb then cloneEffects(source.Head, targetLimb) end
        end
    else
        for _, sourcePart in pairs(source:GetChildren()) do
            if sourcePart:IsA("BasePart") then
                local targetLimb = char:FindFirstChild(sourcePart.Name)
                if targetLimb then cloneEffects(sourcePart, targetLimb) end
            end
        end
    end
end

local function equipHair(name)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    if char:FindFirstChild("Hair") then char.Hair:Destroy() end
    for _, v in pairs(char:GetChildren()) do if v.Name == "EquippedHair" then v:Destroy() end end
    
    local target = nil
    
    if name == "Kokushibo" then
        local npc = workspace:FindFirstChild("Npcs") and workspace.Npcs:FindFirstChild("Kokushibo")
        if npc then
            local model = npc:FindFirstChild("Model") or npc:FindFirstChildWhichIsA("Model")
            if model then
                target = model:Clone()
                target.Name = "EquippedHair"
                target.Parent = char
                local ae = target:FindFirstChild("Ae")
                if ae then
                    local fa = ae:FindFirstChild("Fa")
                    if fa and (fa:IsA("Weld") or fa:IsA("ManualWeld")) then
                        fa.Part1 = char.Head
                    end
                end
                applyStyle(target)
                for _, p in pairs(target:GetDescendants()) do
                    if p:IsA("BasePart") then p.Anchored = false; p.CanCollide = false; p.Massless = true end
                end
                return 
            end
        end
    end

    target = HairsFolder:FindFirstChild(name) or SpecialFolder:FindFirstChild(name) or FamilyFolder:FindFirstChild(name)
    if target then
        local newHair = target:Clone(); newHair.Name = "EquippedHair"; newHair.Parent = char; applyStyle(newHair)
        local mainHairPart = newHair:FindFirstChild("Hair") or (newHair:IsA("BasePart") and newHair) or newHair:FindFirstChildWhichIsA("BasePart", true)
        for _, item in pairs(newHair:GetDescendants()) do
            if item:IsA("Weld") or item:IsA("ManualWeld") then
                item.Part0 = item.Parent 
                if item.Parent.Name == "Handle" then item.Part1 = mainHairPart else item.Part1 = char.Head end
            end
        end
    end
end

local function equipMark(markName)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    for _, v in pairs(char:GetChildren()) do if v.Name == "EquippedMark" then v:Destroy() end end
    if markName == "None" then return end
    local target = MarksFolder:FindFirstChild(markName)
    if target then
        local newMark = target:Clone(); newMark.Name = "EquippedMark"; newMark.Parent = char
        for _, item in pairs(newMark:GetDescendants()) do
            if item:IsA("Weld") or item:IsA("ManualWeld") or item.Name == "We" then
                item.Part0 = item.Parent; item.Part1 = char.Head
            end
        end
    end
end

local function applyEyes(id)
    local char = game.Players.LocalPlayer.Character
    local faceBlock = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("FaceBlock")
    if not faceBlock then return end

    local toDelete = {"Pupil", "Fundo", "Sombraceia", "Bonor", "Face", "Eye", "Eyes", "Eye_Left", "Eye_Right"}
    
    for _, v in pairs(faceBlock:GetChildren()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            for _, name in pairs(toDelete) do
                if v.Name:find(name) or v.Name == name then 
                    v:Destroy() 
                    break 
                end
            end
        end
    end

    local sourceFolder = EyesFolder:FindFirstChild(tostring(id))
    if not sourceFolder then return end

    local fundoCount = 0
    for _, sourceDecal in pairs(sourceFolder:GetChildren()) do
        if sourceDecal:IsA("Decal") then
            local newLayer = sourceDecal:Clone()
            newLayer.Parent = faceBlock
            newLayer.Transparency = 0
            
            if newLayer.Name == "Fundo" then
                fundoCount = fundoCount + 1
                newLayer.Color3 = EyeLayerColors.FundoList[fundoCount] or Color3.new(1,1,1)
            elseif EyeLayerColors[newLayer.Name] then
                newLayer.Color3 = EyeLayerColors[newLayer.Name]
            end
        end
    end
end

local function colorFundoByIndex(index, color)
    EyeLayerColors.FundoList[index] = color
    local char = game.Players.LocalPlayer.Character
    local faceBlock = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("FaceBlock")
    if faceBlock then
        local foundCount = 0
        for _, v in pairs(faceBlock:GetChildren()) do
            if v.Name == "Fundo" then
                foundCount = foundCount + 1
                if foundCount == index then
                    v.Color3 = color
                end
            end
        end
    end
end

local function colorGenericLayer(name, color)
    EyeLayerColors[name] = color
    local char = game.Players.LocalPlayer.Character
    local faceBlock = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("FaceBlock")
    if faceBlock then
        local target = faceBlock:FindFirstChild(name)
        if target then target.Color3 = color end
    end
end


local function getValidAccessories()
    local list = {"None"}
    for _, tool in pairs(ToolsFolder:GetChildren()) do
        if tool.Name:find("Mask") or tool.Name == "Nezuko Box" then
            table.insert(list, tool.Name)
        end
    end
    return list
end

local function equipAccessory(toolName, slot)
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    if AccessorySlots[slot] then 
        AccessorySlots[slot]:Destroy() 
        AccessorySlots[slot] = nil
    end

    if toolName == "None" then return end

    local tool = ToolsFolder:FindFirstChild(toolName)
    local hatModel = tool and tool:FindFirstChild("Hat")

    if hatModel then
        local newHat = hatModel:Clone()
        newHat.Name = "CustomAcc_" .. slot 
        newHat.Parent = char
        AccessorySlots[slot] = newHat

        local mainPart = newHat:FindFirstChild("Main")
        if mainPart then
            local weld = mainPart:FindFirstChild("Weld")
            if weld and weld:IsA("Weld") then
                weld.Part0 = mainPart
                
                if toolName:find("Box") or toolName:find("Nezuko") then
                    weld.Part1 = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                else
                    weld.Part1 = char:FindFirstChild("Head")
                end
                
                local meshCounter = 0
                for _, p in pairs(newHat:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.Anchored = false
                        p.CanCollide = false
                        p.Massless = true

                        if toolName:find("Box") or toolName:find("Nezuko") then
                            -- 1. TARGET THE MAIN UNION/PART
                            if p.Name == "Main" then
                                p.Material = Enum.Material.Plastic
                                p.Color = Color3.fromRGB(20, 20, 20)
                                p.Transparency = 0
                                if p:IsA("UnionOperation") then
                                    p.UsePartColor = true -- Force Union to show color
                                end
                            -- 2. TARGET THE WOOD PARTS
                            elseif p.Name == "Mesh" then
                                meshCounter = meshCounter + 1
                                p.Material = Enum.Material.Wood
                                p.Transparency = 0
                                p.Color = (meshCounter == 1) and Color3.fromRGB(110, 70, 40) or Color3.fromRGB(80, 50, 30)
                            end

                            -- 3. CLEANUP
                            if p:IsA("MeshPart") then p.TextureID = "" end
                            for _, child in pairs(p:GetChildren()) do
                                if child:IsA("Texture") or child:IsA("Decal") then
                                    child:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end
        -- 🛑 REMOVED: applyStyle(newHat) 
        -- This line was the glitch; it was forcing hair logic onto the box.
    end
end

local function getHaoriList()
    local list = {"None"}
    for _, tool in pairs(ToolsFolder:GetChildren()) do
        if tool.Name:find("Haori") then
            if tool.Name == "Sabito Haori" then
                table.insert(list, "Custom Haori")
            else
                table.insert(list, tool.Name)
            end
        end
    end
    return list
end

local function equipHaori(toolName)
    -- Map "Custom Haori" back to "Sabito Haori"
    if toolName == "Custom Haori" then toolName = "Sabito Haori" end

    local char = game.Players.LocalPlayer.Character
    if not char then return end

    -- Cleanup previous haori
    for _, child in pairs(char:GetChildren()) do
        if child.Name == "EquippedHaori" or child.Name == "Left Arm Mesh" or child.Name == "Right Arm Mesh" then
            child:Destroy()
        end
    end

    if toolName == "None" then return end

    local tool = ToolsFolder:FindFirstChild(toolName)
    local source = tool and (tool:FindFirstChild("Model") or tool:FindFirstChild("Haori") or tool:FindFirstChildWhichIsA("Model"))
    if not source then return end

    local newHaori = source:Clone()
    newHaori.Name = "EquippedHaori"
    newHaori.Parent = char

    -- == SABITO HAORI SPECIAL HANDLING ==
    if toolName:find("Sabito") then

        -- Remove unwanted meshes
        local toRemove = {"Torso_low.001", "Arm_low.001", "Arm_low"}
        for _, name in ipairs(toRemove) do
            local part = newHaori:FindFirstChild(name)
            if part then part:Destroy() end
        end

        -- Torso_low weld (Part0 = mesh, Part1 = Torso)
        local torsoMesh = newHaori:FindFirstChild("Torso_low")
        local torsoLimb = char:FindFirstChild("Torso")
        if torsoMesh and torsoLimb then
            local weld = torsoMesh:FindFirstChild("Torso")
            if weld then
                weld.Part0 = torsoMesh
                weld.Part1 = torsoLimb
            end
        end

        -- Weld legs + X size +0.11
        local function setupLeg(meshName, weldName, limbName)
            local mesh = newHaori:FindFirstChild(meshName)
            local limb = char:FindFirstChild(limbName)
            if mesh and limb then
                local weld = mesh:FindFirstChild(weldName)
                if weld then
                    weld.Part0 = limb
                    weld.Part1 = mesh
                end
                if mesh:IsA("BasePart") then
                    mesh.Size = mesh.Size + Vector3.new(0.11, 0, 0)
                else
                    for _, part in ipairs(mesh:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Size = part.Size + Vector3.new(0.11, 0, 0)
                        end
                    end
                end
            end
        end

        setupLeg("Leg_low", "Left Leg", "Left Leg")
        setupLeg("Leg_low.001", "Right Leg", "Right Leg")

        -- Duplicate legs for arms + X size +0.1
        local function duplicateForArm(sourceName, newMeshName, oldWeldName, newWeldName, limbName)
            local src = newHaori:FindFirstChild(sourceName)
            if not src then return end

            local armMesh = src:Clone()
            armMesh.Name = newMeshName
            armMesh.Parent = char

            local weld = armMesh:FindFirstChild(oldWeldName)
            if weld then
                weld.Name = newWeldName
                local limb = char:FindFirstChild(limbName)
                if limb then
                    weld.Part0 = limb
                    weld.Part1 = armMesh
                end
            end

            if armMesh:IsA("BasePart") then
                armMesh.Size = armMesh.Size + Vector3.new(0.1, 0, 0)
            else
                for _, part in ipairs(armMesh:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Size = part.Size + Vector3.new(0.1, 0, 0)
                    end
                end
            end
        end

        duplicateForArm("Leg_low",     "Left Arm Mesh",  "Left Leg",  "Left Arm",  "Left Arm")
        duplicateForArm("Leg_low.001", "Right Arm Mesh", "Right Leg", "Right Arm", "Right Arm")

        return -- skip generic logic below
    end

    -- == GENERIC HAORI HANDLING (all other haoris) ==
    local isKamado  = toolName:find("Kamado")
    local isMoon    = toolName:find("Moon")
    local isTomioka = toolName:find("Tomioka")

    for _, obj in pairs(newHaori:GetDescendants()) do
        if obj.Name == "Centre" or obj.Name == "Part" then
            if obj:IsA("BasePart") then obj.Transparency = 1 end
        end

        if obj:IsA("BasePart") then
            obj.Anchored = false
            obj.CanCollide = false
            obj.Massless = true
            obj.Color = Color3.new(1, 1, 1)

            if isTomioka and (obj.Name == "Right" or obj.Name == "Right Arm") then
                obj.Color = Color3.fromRGB(138, 0, 0)
            end

            if not (obj.Name == "Centre" or obj.Name == "Part") then
                obj.Transparency = 0
            end

            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Texture") or child:IsA("Decal") then
                    if isKamado then
                        if child.Name == "Eye" then child.Transparency = 0 else child:Destroy() end
                    elseif isMoon then
                        child.Transparency = 0
                    elseif isTomioka and (obj.Name == "Right" or obj.Name == "Right Arm") then
                        child:Destroy()
                    else
                        child:Destroy()
                    end
                end
            end
        end

        if obj:IsA("Weld") or obj:IsA("ManualWeld") then
            local targetName = obj.Name
            local targetLimb = char:FindFirstChild(targetName)
            if not targetLimb then
                if targetName == "TorsoHao" or targetName == "Torso" then
                    targetLimb = char:FindFirstChild("Torso")
                elseif targetName == "Right Arm" or targetName == "RightArm" then
                    targetLimb = char:FindFirstChild("Right Arm")
                elseif targetName == "Left Arm" or targetName == "LeftArm" then
                    targetLimb = char:FindFirstChild("Left Arm")
                end
            end
            if targetLimb then
                obj.Part0 = obj.Parent
                obj.Part1 = targetLimb
            end
        end
    end
end

local function reapplyEverything(char)
    print("═══════════════════════════════════════════════")
    print("🔄 Character Respawned - Waiting for default hair...")
    print("═══════════════════════════════════════════════")

    -- Wait for character essentials
    local head = char:WaitForChild("Head", 10)
    if not head then 
        warn("❌ Head not found!")
        return 
    end
    
    -- Wait for game's default hair to load
    local defaultHair = char:WaitForChild("Hair", 10)
    if defaultHair then
        print("✅ Default hair detected")
        task.wait(0.5)
    else
        warn("⚠️ No default hair, waiting anyway...")
        task.wait(2)
    end
    
    print("🎨 Restoring saved settings...")
    
    -- Restore hair settings FIRST
    CurrentColor = SavedState.HairColor or Color3.fromRGB(0, 0, 0)
    CurrentMaterial = SavedState.HairMaterial or Enum.Material.Sand
    CurrentTransparency = SavedState.HairTransparency or 0

    -- Apply saved customization
    applySkinColor(SavedState.SkinColor)
    
    if SavedState.Haori ~= "None" then 
        equipHaori(SavedState.Haori) 
    end
    
    if SavedState.Eyes ~= 0 then 
        applyEyes(SavedState.Eyes) 
    end
    
    if SavedState.Mouth ~= 0 then 
        applyFacePart(SavedState.Mouth, "Mouth", MouthsFolder) 
    end
    
    if SavedState.Nose ~= 0 then 
        applyFacePart(SavedState.Nose, "Nose", NosesFolder) 
    end

    if SavedState.LastClothesType and SavedState.LastClothesType ~= "None" and SavedState.LastClothesValue and SavedState.LastClothesValue > 0 then
        print("👕 Applying saved clothes:", SavedState.LastClothesType, "ID:", SavedState.LastClothesValue)
        
        if SavedState.LastClothesType == "Civilian" then
            equipClothes(SavedState.LastClothesValue, ClothesFolder)
        elseif SavedState.LastClothesType == "NPC" then
            equipClothes(SavedState.LastClothesValue, SlayerClothesFolder)
        elseif SavedState.LastClothesType == "Uniform" then
            equipClothes(SavedState.LastClothesValue, PlayerUniformFolder)
        end
        
        print("✅ Clothes applied!")
    else
        print("⚠️ No clothes saved")
    end

	task.wait(0.2)

	local char = game.Players.LocalPlayer.Character
	local faceBlock = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("FaceBlock")

	if faceBlock then
    	if faceBlock:FindFirstChild("TrueScar1") then faceBlock.TrueScar1:Destroy() end
    	if faceBlock:FindFirstChild("TrueScar2") then faceBlock.TrueScar2:Destroy() end
    	if faceBlock:FindFirstChild("SpecialScar1") then faceBlock.SpecialScar1:Destroy() end
    	if faceBlock:FindFirstChild("SpecialScar2") then faceBlock.SpecialScar2:Destroy() end
    
		if SavedState.Scar1 and SavedState.Scar1 > 0 then
        applyFacePart(SavedState.Scar1, "TrueScar1", ScarsFolder)
    	end
    	if SavedState.Scar2 and SavedState.Scar2 > 0 then
        applyFacePart(SavedState.Scar2, "TrueScar2", ScarsFolder)
    	end
    	if SavedState.SScar1 and SavedState.SScar1 > 0 then
        applyFacePart(SavedState.SScar1, "SpecialScar1", EffectsFolder)
    	end
    	if SavedState.SScar2 and SavedState.SScar2 > 0 then
        applyFacePart(SavedState.SScar2, "SpecialScar2", EffectsFolder)
    	end
	end
    
    equipAccessory(SavedState.Slot1, "Slot1")
    equipAccessory(SavedState.Slot2, "Slot2")

    -- Apply horns
    if SavedState.Horns ~= "0" and SavedState.Horns ~= "" then 
        equipHorns(SavedState.Horns) 
    end
    
    -- 💇 APPLY SAVED HAIR
    if SavedState.Hair and SavedState.Hair ~= "None" and SavedState.Hair ~= "" then
        print("💇 Applying saved hair:", SavedState.Hair)
        equipHair(SavedState.Hair)
        task.wait(0.3)
        updateAll()
        print("✅ Hair applied!")
    else
        print("⚠️ No hair saved:", SavedState.Hair)
    end
    
    -- Apply aura and mark
    if SavedState.Aura ~= "None" then 
        equipAura(SavedState.Aura) 
    end
    
    if SavedState.Mark ~= "None" then 
        equipMark(SavedState.Mark) 
    end
    
    local F = Rayfield.Flags
    if F.tpwalk_speed and F.tpwalk_speed.CurrentValue and F.tpwalk_speed.CurrentValue > 0 then
        tpSpeed = F.tpwalk_speed.CurrentValue
        startTpWalk()
    end

    print("═══════════════════════════════════════════════")
    print("✅ ALL DONE!")
    print("═══════════════════════════════════════════════")
end

game.Players.LocalPlayer.CharacterAdded:Connect(reapplyEverything)

local function RefreshHB()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BillboardGui") and (v.Name == "HealthBar" or v:FindFirstChild("HealthFrame")) then v:Destroy() end
    end
    local current = getgenv().HB_Enabled
    getgenv().HB_Enabled = false
    task.wait(0.1)
    getgenv().HB_Enabled = current
    if not getgenv().HealthBarRunning then
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RiXNNN/Aurora-Hub/refs/heads/main/HealthBars.lua"))() end) end)
    end
end

local function instantRemove(obj)
    if not obj or obj:GetAttribute("Gone") then return end
    obj:SetAttribute("Gone", true)
    for _, item in ipairs(obj:GetDescendants()) do
        if item:IsA("BasePart") then item.Transparency = 1 item.CanCollide = false end
    end
    task.wait(CONFIG.CleanupDelay)
    obj:Destroy()
end

task.spawn(function()
    while true do
        local decoy = workspace:FindFirstChild("Decoy")
        if decoy then decoy:Destroy() end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                local isExecuted = obj:FindFirstChild(CONFIG.TargetValueName)
                local customHealth = obj:FindFirstChild("Health")
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local isDead = (TARGET_MOBS[obj.Name] and ((customHealth and customHealth.Value <= 0) or (hum and hum.Health <= 0)))
                if isExecuted or isDead then instantRemove(obj) end
            end
        end
        task.wait(0.5)
    end
end)

local isParrying, isCountering = false, false
local function doParry(d)
    if isParrying or not P.ParryEnabled then return end
    isParrying = true
    
    task.wait(d)
    
    local char = LocalPlayer.Character
    local blockMode = "Katana" 
    
    if char then
        if char:FindFirstChild("Soryuu") then
            blockMode = "Soryuu"
        elseif char:FindFirstChild("Demon") then
            blockMode = "Combat"
        end
    end

    pcall(function()
        -- 1. Always Start the Block
        game:GetService("ReplicatedStorage").Remotes.Async:FireServer(blockMode, "Block", true)
        
        -- 2. Wait for your "Perfect Parry" window
        task.wait(P.ParryHoldTime or 0.15)
        
        -- 3. THE FIX: Only Stop Block if the player IS NOT manually holding F
        -- This prevents the script from "Unblocking" for you.
        if not UIS:IsKeyDown(Enum.KeyCode.F) then
            game:GetService("ReplicatedStorage").Remotes.Async:FireServer(blockMode, "Block", false)
        else
            warn("Manual Block detected: Skipping Auto-Unblock to keep guard up.")
        end
    end)

    isParrying = false
end

local function doCounter(d)
    if isCountering or not _G.CounterEnabled then return end
    isCountering = true task.wait(d)
    local s, k = pcall(function() return Enum.KeyCode[_G.C_Key] end)
    if s then 
        VIM:SendKeyEvent(true, k, false, game) task.wait(0.05) VIM:SendKeyEvent(false, k, false, game) 
        if _G.C_Key == "Six" then VIM:SendKeyEvent(true, Enum.KeyCode.KeypadSix, false, game) VIM:SendKeyEvent(false, Enum.KeyCode.KeypadSix, false, game) end
    end
    task.wait(0.5) isCountering = false
end

task.spawn(function()
    while true do
        task.wait(0.05)
        
        if not _G.ParryEnabled and not _G.CounterEnabled then continue end
        
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, m in ipairs(workspace:GetChildren()) do
                if m:IsA("Model") and m ~= char and (m:FindFirstChild("AttackAnnounce") or m:FindFirstChild("HeavyAnnounce")) then
                    local tRoot = m:FindFirstChild("HumanoidRootPart")
                    if tRoot and (root.Position - tRoot.Position).Magnitude <= 12 then
                        local h = m:FindFirstChild("HeavyAnnounce")
                        if _G.ParryEnabled then task.spawn(doParry, h and _G.P_HD or _G.P_LD) end
                        if _G.CounterEnabled then task.spawn(doCounter, h and _G.C_HD or _G.C_LD) end
                    end
                end
            end
        end
    end
end)

local function applyVisuals(katana)
    if activeKatanas[katana] then return end
    activeKatanas[katana] = true

    task.spawn(function()
        repeat task.wait(1) until Rayfield and Rayfield.Flags and Rayfield.Flags.BladeCol_F
        
        while katana and katana.Parent do
            local success, err = pcall(function()
                local blade = katana:FindFirstChild("Blade", true)
                if blade then
                    local flags = Rayfield.Flags
                    local bCol = flags.BladeCol_F.Color
                    local bMat = flags.Mat_F.CurrentOption[1]
                    local tCol = flags.TrailCol_F.Color
                    local tToggle = flags.TrailToggle_F.CurrentValue
                    local tLife = flags.TLife_F.CurrentValue
                    local lRange = flags.LRange_F.CurrentValue
                    local lPow = flags.LPow_F.CurrentValue

                    blade.Color = bCol
                    blade.Material = Enum.Material[bMat or "Neon"]
                    
                    local light = blade:FindFirstChild("SwordLight") or Instance.new("PointLight", blade)
                    light.Name = "SwordLight"
                    
                    local motor = katana:FindFirstChild("Equipped", true)
                    local isDrawn = motor and motor.Part1 ~= nil
                    
                    light.Enabled = isDrawn and (lPow > 0)
                    light.Color = bCol
                    light.Range = lRange
                    light.Brightness = lPow

                    local trail = blade:FindFirstChild("TrailSword")
                    if trail then
                        trail.Enabled = isDrawn and tToggle
                        trail.Color = ColorSequence.new(tCol)
                        trail.Lifetime = tLife
                    end
                end
                
                for _, part in ipairs(katana:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)

            if not success then
                warn("Katana Visuals waiting for UI: " .. tostring(err))
            end

            task.wait(1) 
        end
        activeKatanas[katana] = nil
    end)
end

local function setup(char)
    activeKatanas = {}
    for _, child in ipairs(char:GetDescendants()) do
        for _, name in pairs(CONFIG.KatanaNames) do
            if child.Name == name then applyVisuals(child) end
        end
    end
    char.DescendantAdded:Connect(function(descendant)
        for _, name in pairs(CONFIG.KatanaNames) do
            if descendant.Name == name then
                task.defer(function() applyVisuals(descendant) end)
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(5) -- Fast check for immediate noclip
        local char = game.Players.LocalPlayer.Character
        if char then
            -- Find all instances of Soryuu (MeshParts)
            for _, item in ipairs(char:GetChildren()) do
                if item.Name == "Soryuu" and item:IsA("BasePart") then
                    if item.CanCollide ~= false then
                        item.CanCollide = false
                    end
                end
            end
        end
    end
end)

local player = game.Players.LocalPlayer
if player.Character then setup(player.Character) end
player.CharacterAdded:Connect(setup)

local LootCache = {}
local LP = game.Players.LocalPlayer

task.spawn(function()
    while true do
        if getgenv().AutoLoot then
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local myPos = myRoot.Position
                
                for _, obj in ipairs(workspace:GetChildren()) do
                    if not LootCache[obj] and (obj.Name == "DropItem" or obj:FindFirstChild("PickableItem", true)) and not obj:FindFirstChildOfClass("Humanoid") then
                        
                        local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("ProximityPrompt", true)
                        local targetPart = obj:FindFirstChild("Main") or (obj:IsA("BasePart") and obj) or obj:FindFirstChildWhichIsA("BasePart", true)

                        if prompt and targetPart and (myPos - targetPart.Position).Magnitude <= 10 then
                            if LP:FindFirstChild("InteractCooldown") or LP:FindFirstChild("DroppedItemDelay") then
                                continue 
                            end
                            LootCache[obj] = true 
                            task.spawn(function()
                                prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                prompt.MaxActivationDistance = 10
                                prompt.HoldDuration = 0
                                task.wait(0.120) 
                                if obj and obj.Parent == workspace then
                                    fireproximityprompt(prompt)
                                    task.wait(0.1)
                                    if obj and obj.Parent == workspace then
                                        if obj.Name:find("Perfect Crystal") or obj:FindFirstChild("Perfect Crystal") then
                                            prompt.Enabled = false
                                            task.wait(1.5)
                                            if obj and obj.Parent then prompt.Enabled = true end
                                        else
                                            local originalCF = targetPart.CFrame
                                            targetPart.CFrame = originalCF * CFrame.new(100, 0, 0)
                                            targetPart.Transparency = 0.5
                                            
                                            task.wait(1.5)
                                            
                                            if obj and obj.Parent then
                                                targetPart.CFrame = originalCF
                                                targetPart.Transparency = 0
                                                if not getgenv().AutoLoot then prompt.Enabled = true end
                                            end
                                        end
                                    end
                                end
                                LootCache[obj] = nil
                            end)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Helper to check Multi-Select
local function IsSelected(mineralValue)
    if type(_G.SelectedMineral) == "table" then
        return table.find(_G.SelectedMineral, mineralValue)
    end
    return mineralValue == _G.SelectedMineral
end

-- Stability Function (Zero-G Fly)
local function RefreshStability(root)
    for _, v in pairs(root:GetChildren()) do
        if v.Name == "MineStability" then v:Destroy() end
    end
    local bg = Instance.new("BodyGyro")
    local bv = Instance.new("BodyVelocity")
    bg.Name = "MineStability"; bv.Name = "MineStability"
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 9e4
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0, 0, 0)
    bg.Parent = root; bv.Parent = root
end

-- Get nearest ore based on the dropdown selection
local function GetNearestMineral()
    local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end

    local BestMatch = nil
    local ClosestDist = math.huge
    local MineralFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Minerals")
    
    if MineralFolder then
        for _, v in pairs(MineralFolder:GetDescendants()) do
            if v:IsA("StringValue") and IsSelected(v.Value) then
                local Rock = v.Parent
                if Rock and Rock:IsA("BasePart") then
                    local d = (Root.Position - Rock.Position).Magnitude
                    if d < ClosestDist then
                        ClosestDist = d
                        BestMatch = Rock
                    end
                end
            end
        end
    end
    return BestMatch
end

local function RunRenderCycle(root)
    if isSearching then return end
    isSearching = true
    
    Rayfield:Notify({Title = "Auto-Mine", Content = "Searching Map for Ores...", Duration = 3})

    for i, point in ipairs(RenderPoints) do
        -- Check if an ore spawned while we were moving
        if GetNearestMineral() then break end
        
        -- Teleport to the point
        root.CFrame = CFrame.new(point + Vector3.new(0, 10, 0)) -- Hover slightly above the point
        task.wait(1.5) -- Wait for assets to load
    end
    
    isSearching = false
end

RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChild("Humanoid")

    -- [[ DISABLE LOGIC ]]
    if not _G.AutoMineEnabled then 
        if Root then 
            Root.Anchored = false 
            for _, v in pairs(Root:GetChildren()) do if v.Name == "MineStability" then v:Destroy() end end
        end
        return 
    end
    
    if not Root or not Hum or isSearching then return end

    -- 1. STABILITY REFRESH
    if tick() - lastRefresh > 2 then
        lastRefresh = tick()
        RefreshStability(Root)
    end

    -- 2. TARGET VALIDATION & SEARCH TRIGGER
    if not _G.CurrentTarget or not _G.CurrentTarget.Parent or not _G.CurrentTarget:IsDescendantOf(workspace) then
        _G.CurrentTarget = GetNearestMineral()
        if not _G.CurrentTarget then
            task.spawn(function() RunRenderCycle(Root) end)
            return
        end
    end

    -- 3. SMART PICKAXE
    if _G.CurrentTarget and _G.CurrentTarget.Parent then
        if tick() - lastMineTick > 0.25 then
            lastMineTick = tick()
            task.spawn(function()
                pcall(function() RemoteSync:InvokeServer("Pickaxe", "Server") end)
            end)
        end
    end

    -- 4. ORBIT & PHYSICS
    local radius, speed = 3, 5.5
    angle = angle + (speed * 0.01)
    local x, z = math.cos(angle) * radius, math.sin(angle) * radius
    
    local TargetPos = _G.CurrentTarget.Position + Vector3.new(x, -1.2, z)
    local LookAtCFrame = CFrame.lookAt(TargetPos, _G.CurrentTarget.Position)

    for _, p in ipairs(Char:GetChildren()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
    Root.CFrame = LookAtCFrame
    if Root:FindFirstChild("MineStability") and Root.MineStability:IsA("BodyGyro") then
        Root.MineStability.CFrame = LookAtCFrame
    end
end)

local function runBetterViewClean()
    for _, folder in ipairs(workspace:GetChildren()) do
        if folder.Name == "Folder" then
            folder:Destroy()
        end
    end

    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmosphere then
        if atmosphere.Density ~= 0.3 or atmosphere.Offset ~= 0.3 then
            atmosphere.Density = 0.3
            atmosphere.Offset = 0.3
        end
    end

    for _, soundName in ipairs({"Blizzard", "Wind1"}) do
        local s = workspace:FindFirstChild(soundName, true)
        if s and s:IsA("Sound") and s.Volume ~= 0 then
            s.Volume = 0
        end
    end
    
    local terrain = workspace.Terrain
    if terrain then
        local items = terrain:GetChildren()
        if #items > 0 then
            for _, item in ipairs(items) do
                item:Destroy()
            end
        end
    end
end

task.spawn(function()
    while true do
        if P.BetterView then
            runBetterViewClean()
        end
        task.wait(2.5)
    end
end)

local function notify(title, text)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = 5,
        Image = 4483362458,
    })
end

local function stabilizeCharacter(root, hum)
    if root and hum then
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end
end

local function isAreaClear(currentTarget)
    for _, v in pairs(workspace:GetChildren()) do
        if v ~= currentTarget and table.find(P.SelectedNPCs, v.Name) then
            local health = v:FindFirstChild("Health")
            local isDown = v:FindFirstChild("Down")
            if health and health.Value > 0 and not isDown then
                local eRoot = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if eRoot and currentTarget.PrimaryPart then
                    local dist = (currentTarget.PrimaryPart.Position - eRoot.Position).Magnitude
                    if dist < 15 then
                        return false 
                    end
                end
            end
        end
    end
    return true 
end

-- [[ HUD BRIDGE LOGIC ]]
local statsMapping = {
    ["Health"] = {current = "Health", max = "MaxHealth"},
    ["Stamina"] = {current = "Stamina", max = "MaxStamina"},
    ["Hunger"] = {current = "Hunger", max = "MaxHunger"},
    ["Experience"] = {current = "Experience", max = "MaxExperience"}
}

local function startHUDBridge()
    if _G.BridgeActive then return end
    _G.BridgeActive = true
    task.spawn(function()
        while true do
            pcall(function()
                local hudBars = LocalPlayer.PlayerGui.Interface.HUD.Bars
                for uiName, data in pairs(statsMapping) do
                    local c, m = LocalPlayer:FindFirstChild(data.current), LocalPlayer:FindFirstChild(data.max)
                    local ui = hudBars:FindFirstChild(uiName)
                    if c and m and ui then
                        local ratio = math.clamp(c.Value / m.Value, 0, 1)
                        ui.Bar.Size = UDim2.new(ratio, 0, 1, 0)
                        if ui:FindFirstChild("TextLabel") then
                            ui.TextLabel.Text = math.floor(c.Value) .. "/" .. math.floor(m.Value)
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

-- Create the Custom Breath Bar Instance
local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "BreathBarHUD"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999

local bg = Instance.new("Frame", sg)
bg.Name = "BG"
bg.Position = UDim2.new(0.5, 130, 0.5, -90)
bg.Size = UDim2.new(0, 10, 0, 180)
bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bg.BackgroundTransparency = 0.8
bg.BorderSizePixel = 0

local bgCorner = Instance.new("UICorner", bg)
bgCorner.CornerRadius = UDim.new(1, 0)

local bar = Instance.new("Frame", bg)
bar.Name = "Bar"
bar.Position = UDim2.new(0, 0, 1, 0)
bar.AnchorPoint = Vector2.new(0, 1)
bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bar.BackgroundTransparency = 0.7
bar.Size = UDim2.new(1, 0, 0, 0)

local barCorner = Instance.new("UICorner", bar)
barCorner.CornerRadius = UDim.new(1, 0)

-- Updates Breath Bar Visibility based on state
local function updateBreathBarVisibility()
    local targetBG = _G.BreathBarVisible and 0.8 or 1
    local targetBar = _G.BreathBarVisible and 0.7 or 1
    
    TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = targetBG}):Play()
    TweenService:Create(bar, TweenInfo.new(0.3), {BackgroundTransparency = targetBar}):Play()
end

local function monitorBreathing(breathVal)
    local function update()
        local r = math.clamp(breathVal.Value / 100, 0, 1)
        TweenService:Create(bar, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
            Size = UDim2.new(1, 0, r, 0)
        }):Play()
    end
    update()
    breathVal:GetPropertyChangedSignal("Value"):Connect(update)
end

-- Initialize breath listeners
LocalPlayer.ChildAdded:Connect(function(child)
    if child.Name == "Breathing" then monitorBreathing(child) end
end)
if LocalPlayer:FindFirstChild("Breathing") then monitorBreathing(LocalPlayer.Breathing) end

-- Background loop for breath particle disabler and HUD bridge
task.spawn(function()
    startHUDBridge()
    while true do
        pcall(function()
            local original = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Breath")
            if original then original.Enabled = false end
        end)
        task.wait(0.5)
    end
end)

-- Godmode Sync Mechanic
local function MasterSync()
    if tick() - _G.LastHealTime < 7.5 then return end
    _G.LastHealTime = tick()

    local lastPos = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.CFrame
    task.spawn(function() RemoteSync:InvokeServer("Player", "SpawnCharacter") end)

    if lastPos then
        task.spawn(function()
            local newChar = LocalPlayer.CharacterAdded:Wait()
            local newRoot = newChar:WaitForChild("HumanoidRootPart")
            task.wait(0.15)
            newRoot.CFrame = lastPos
        end)
    end
end

-- Input handler translating the input textbox string into real actions
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- Refiller Keybind Check
    if _G.GodmodeTriggerEnabled and input.KeyCode == _G.GodmodeKeybind then
        MasterSync()
    end
    
    -- Infinite M1 Keybind Check
    if _G.InfM1Enabled and input.KeyCode.Name == string.upper(_G.InfM1KeyText) then
        if tick() - lastFire > 0.2 then
            lastFire = tick()
            pcall(function()
                RemoteAsync:FireServer("Katana", "Block", "Attack")
            end)
        end
    end
end)

local function GetNearestNPC()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end

    local BestMatch = nil
    local ClosestDist = math.huge
    local PriorityTarget = nil
    local PriorityDist = math.huge

    for _, v in pairs(workspace:GetChildren()) do
        if table.find(P.SelectedNPCs, v.Name) and not game.Players:GetPlayerFromCharacter(v) then
            local isDead = v:FindFirstChild("Executed")
            local health = v:FindFirstChild("Health")
            local isDown = v:FindFirstChild("Down")
            
            if health and health.Value > 0 and not isDead then
                local eRoot = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if eRoot then
                    local d = (Root.Position - eRoot.Position).Magnitude
                    
                    if not isDown and d < 50 then 
                        if d < PriorityDist then
                            PriorityDist = d
                            PriorityTarget = v
                        end
                    else
                        if d < ClosestDist then
                            ClosestDist = d
                            BestMatch = v
                        end
                    end
                end
            end
        end
    end
    return PriorityTarget or BestMatch
end

RunService.Stepped:Connect(function()
    if not P.AutoFarmNPC then return end
    
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChild("Humanoid")
    if not Root or not Hum then return end

    stabilizeCharacter(Root, Hum)

    local t = P.CurrentNPCTarget
    
    -- Target switching logic
    if t and t:FindFirstChild("Down") then
        local threat = GetNearestNPC() 
        if threat and not threat:FindFirstChild("Down") then
            local threatRoot = threat:FindFirstChild("HumanoidRootPart") or threat.PrimaryPart
            if threatRoot and (Root.Position - threatRoot.Position).Magnitude < 50 then
                P.CurrentNPCTarget = threat
                t = threat
            end
        end
    end

    -- Target validation
    if not t or not t.Parent or t:FindFirstChild("Executed") then
        if lootTimer == 0 then lootTimer = tick() end
        if tick() - lootTimer >= 0.5 then
            P.CurrentNPCTarget = GetNearestNPC()
            lootTimer = 0
            if Root.Anchored then Root.Anchored = false end
        end
        return
    end

    local EnemyRoot = t:FindFirstChild("HumanoidRootPart") or t.PrimaryPart
    if EnemyRoot then
        local isDown = t:FindFirstChild("Down")
        local isRagdoll = t:FindFirstChild("Ragdoll")
        local isBlocking = t:FindFirstChild("Block")
        local readyToExecute = isDown and isAreaClear(t)

        local Offset = isDown and Vector3.new(0, 2, 0) or Vector3.new(P.FarmDistanceX, P.FarmDistanceY, P.FarmDistanceZ)
        local TargetPos = (EnemyRoot.CFrame * CFrame.new(Offset)).Position
        local LookAtCFrame = CFrame.lookAt(TargetPos, EnemyRoot.Position)

        local dist = (Root.Position - TargetPos).Magnitude
        if dist > 0.8 then
            Root.Anchored = false
            Root.CFrame = Root.CFrame:Lerp(LookAtCFrame, P.TweenSpeed)
        else
            Root.CFrame = LookAtCFrame
            Root.Anchored = true 
        end
        
        if readyToExecute and dist < 5 then
            if tick() - (lastExecute or 0) > 3 then
                lastExecute = tick()

                task.spawn(function()
                    if P.Executing then return end
                    P.Executing = true
                    
                    local args = {"Character", "Execute"}
                    
                    pcall(function()
                        ReplicatedStorage.Remotes.Sync:InvokeServer(unpack(args))
                    end)

                    task.wait(0.5) 
                    P.Executing = false
                end) -- Closes task.spawn
            end -- Closes the tick check
        end -- Closes the readyToExecute check

        -- Noclip logic
        for _, p in ipairs(Char:GetChildren()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

task.spawn(function()
    local lastBreathTime = 0
    while true do
        task.wait(0.5) 
        
        -- ONLY run if AutoFarm is ON AND AutoSkills is ON
        if P.AutoFarmNPC and P.AutoSkillsEnabled and LocalPlayer.Character then
            -- 1. Get the actual Breath Value
            local bValue = LocalPlayer.Character:FindFirstChild("Breathing", true)
            local currentBreath = bValue and bValue.Value or 0
            
            -- 2. SMART CHECK: Only charge if below 40 AND current breath is NOT 100
            if currentBreath < 40 and currentBreath < 100 and (tick() - lastBreathTime) > 6 then
                lastBreathTime = tick()
                
                -- This 'P.IsUsingSkill' blocks the SKILL loop, not the Katana loop
                P.IsUsingSkill = true 
                
                -- [[ AGGRESSIVE CHARGE ]]
                pcall(function()
                    ReplicatedStorage.Remotes.Async:FireServer("Character", "Breath", true)
                end)
                
                warn("AUTO-SKILLS ENABLED: CHARGING BREATH...")
                task.wait(3.2) 
                
                pcall(function()
                    ReplicatedStorage.Remotes.Async:FireServer("Character", "Breath", false)
                end)
                
                P.IsUsingSkill = false
                warn("BREATH FULL - RESUMING SKILLS")
            end
        end
    end
end)

local KeyMap = {
    ["Skill 1"] = Enum.KeyCode.One,
    ["Skill 2"] = Enum.KeyCode.Two,
    ["Skill 3"] = Enum.KeyCode.Three,
    ["Skill 4"] = Enum.KeyCode.Four,
    ["Skill 5"] = Enum.KeyCode.Five,
    ["Skill 6"] = Enum.KeyCode.Six,
    ["Skill 7"] = Enum.KeyCode.Seven,
    ["Skill T"] = Enum.KeyCode.T,
    ["Skill Y"] = Enum.KeyCode.Y
}

task.spawn(function()
    local skillIndex = 1
    while true do
        -- ULTRA RAPID CHECK (100 times per second)
        task.wait(0.1) 
        
        if P.AutoFarmNPC and P.AutoSkillsEnabled and P.SelectedSkills and P.CurrentNPCTarget then
            -- We ONLY pause skills if we are in the middle of a Breath Charge
            if P.IsUsingSkill then continue end 
            
            local t = P.CurrentNPCTarget
            local currentSkills = {}
            
            -- Re-build the list of active skills from your UI selection
            for _, name in pairs(P.SelectedSkills) do table.insert(currentSkills, name) end
            
            if #currentSkills > 0 then
                if skillIndex > #currentSkills then skillIndex = 1 end
                
                local chosenName = currentSkills[skillIndex]
                local targetKey = KeyMap[chosenName]
                
                if targetKey then
                    -- [[ THE AGGRESSIVE KEY STRIKE ]]
                    -- No more long waits. Just press, release, and move to the next.
                    pcall(function()
                        VIM:SendKeyEvent(true, targetKey, false, game)
                        task.wait(0.005) -- Micro-delay for the engine to register
                        VIM:SendKeyEvent(false, targetKey, false, game)
                    end)
                    
                    skillIndex = skillIndex + 1
                    
                    -- FAST TRANSITION
                    -- 0.05 allows the game to register the first skill before the next one hits
                    task.wait(0.05) 
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.25) -- Faster attack speed
        if P.AutoFarmNPC and not P.IsUsingSkill and P.CurrentNPCTarget then
            local t = P.CurrentNPCTarget
            local char = LocalPlayer.Character
            if not char or not t:FindFirstChild("HumanoidRootPart") then continue end

            -- 1. Identify Race
            local isDemon = char:FindFirstChild("Demon", true)
            local mode = isDemon and "Combat" or "Katana"

            -- 2. Check for Ragdoll (Don't waste attacks if they are flying)
            local isRagdoll = t:FindFirstChild("Ragdoll")
            if isRagdoll then continue end

            -- 3. Force Equip (Slayer Only - ensures sword is out)
            if not isDemon then
                game:GetService("ReplicatedStorage").Remotes.Async:FireServer("Katana", "EquippedEvents", true, true)
            end

            -- 4. Smart Attack Selection
            local isBlocking = t:FindFirstChild("Block", true)
            
            if isBlocking then
                -- Target is blocking, force Heavy Attack to break guard
                game:GetService("ReplicatedStorage").Remotes.Async:FireServer(mode, "Heavy")
            else
                -- Target is open, use regular Server attack
                game:GetService("ReplicatedStorage").Remotes.Async:FireServer(mode, "Server")
            end
        end
    end
end)

-- [[ STANDALONE AGGRESSIVE KILLER LOOP ]]
task.spawn(function()
    while true do
        task.wait(0.2)
        
        if P.AutoFarmNPC and P.CurrentNPCTarget then
            local t = P.CurrentNPCTarget
            local char = LocalPlayer.Character
            if not char or not t:FindFirstChild("HumanoidRootPart") then continue end
            local isDemon = char:FindFirstChild("Demon", true)
            local isSoryuu = char:FindFirstChild("Soryuu", true)

            if t:FindFirstChild("Executed") then continue end

            if not isDemon and not isSoryuu then
                pcall(function()
                    ReplicatedStorage.Remotes.Async:FireServer("Katana", "EquippedEvents", true, true)
                end)
            end

            pcall(function()
                -- 1. Main Hit
                if isSoryuu then
                    -- Soryuu mode — never use Combat or Katana
                    if t:FindFirstChild("Block") then
                        ReplicatedStorage.Remotes.Async:FireServer("Soryuu", "Heavy")
                    else
                        ReplicatedStorage.Remotes.Async:FireServer("Soryuu", "Server")
                    end
                elseif isDemon then
                    -- Demon mode
                    if t:FindFirstChild("Block") then
                        ReplicatedStorage.Remotes.Async:FireServer("Combat", "Heavy")
                    else
                        ReplicatedStorage.Remotes.Async:FireServer("Combat", "Server")
                    end
                else
                    -- Katana mode
                    if t:FindFirstChild("Block") then
                        ReplicatedStorage.Remotes.Async:FireServer("Katana", "Heavy")
                    else
                        ReplicatedStorage.Remotes.Async:FireServer("Katana", "Server")
                    end
                end
                
                -- 2. Lunge only if NPC is NOT ragdolled
                if not t:FindFirstChild("Ragdoll") then
                    ReplicatedStorage.Remotes.Async:FireServer("Lunge", "Server")
                end
            end)
        end
    end
end)

-- LOGIC CORE
local function executeTimedBlock(triggerDistance)
    task.defer(function()
        -- Safety check: don't double-trigger if already blocking
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Block") then 
            return 
        end

        local currentDelay = Config.StartDelay
        if triggerDistance <= Config.CloseRangeThreshold then
            currentDelay = Config.CloseRangeDelay
        end
        
        task.wait(currentDelay)
        if not Config.Enabled then return end
        
        -- Final safety check after the delay duration
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Block") then 
            return 
        end

        -- Infinite block execution (No unblock function follows)
        Remote:FireServer("Katana", "Block", true)
    end)
end

local function checkAndFire(targetPlayer)
    if not Config.Enabled then return end
    if not LocalPlayer.Character or not targetPlayer.Character then return end
    
    if LocalPlayer.Character:FindFirstChild("Block") then return end

    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local theirRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if myRoot and theirRoot then
        local distance = (myRoot.Position - theirRoot.Position).Magnitude
        if distance <= Config.MaxDistance then
            executeTimedBlock(distance)
        end
    end
end

local function monitorPlayer(player)
    if player == LocalPlayer then return end
    
    player.ChildAdded:Connect(function(child)
        if child.Name == "RushCooldown" then
            checkAndFire(player)
        end
    end)
    
    local function monitorCharacter(char)
        char.ChildAdded:Connect(function(child)
            if child.Name == "RushCooldown" then
                checkAndFire(player)
            end
        end)
    end
    
    if player.Character then
        monitorCharacter(player.Character)
    end
    
    player.CharacterAdded:Connect(monitorCharacter)
end

-- Initialize Loop
for _, player in ipairs(Players:GetPlayers()) do
    monitorPlayer(player)
end
Players.PlayerAdded:Connect(monitorPlayer)

-- Function to handle the movement logic
local function startTpWalk()
    if tpwalking then tpwalking:Disconnect() end
    
    if tpSpeed <= 0 then return end

    tpwalking = RunService.Heartbeat:Connect(function(delta)
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        
        if character and humanoid and humanoid.Parent then
            if humanoid.MoveDirection.Magnitude > 0 then
                character:TranslateBy(humanoid.MoveDirection * tpSpeed * delta * 10)
            end
        else
            if tpwalking then tpwalking:Disconnect() end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    if tpSpeed > 0 then
        startTpWalk()
    end
end)

local function startAutoEscape()
    task.spawn(function()
        while AutoEscapeEnabled do
            local lp = game.Players.LocalPlayer
            local healthObj = lp:FindFirstChild("Health") or (lp.Character and lp.Character:FindFirstChild("Humanoid"))
            
            if healthObj then
                local currentHealth = healthObj:IsA("Humanoid") and healthObj.Health or healthObj.Value
                if currentHealth <= EscapeThreshold and currentHealth > 0 then
                    local args = {
                        "Character",
                        "FallDamageServer",
                        4000000000000 
                    }
                    
                    TargetRemote:FireServer(unpack(args))
                    task.wait(2)
                end
            end
            task.wait(0.1)
        end
    end)
end

local function startGuiCleaner()
    local lp = game.Players.LocalPlayer
    local pGui = lp:WaitForChild("PlayerGui")

    -- Function to handle the deletion
    local function checkAndDestroy(obj)
        if obj.Name == TARGET_NAME and obj:IsA("ScreenGui") then
            obj:Destroy()
        end
    end

    -- 1. Clean up anything already there
    for _, child in pairs(pGui:GetChildren()) do
        checkAndDestroy(child)
    end

    -- 2. Listen for it being added again (on respawn or by game scripts)
    pGui.ChildAdded:Connect(function(child)
        checkAndDestroy(child)
    end)
end

-- Pure, unfiltered global fire logic
local function fireAtAllPlayers()
    local playersList = Players:GetPlayers()
    for i = 1, #playersList do
        local player = playersList[i]
        if player ~= LocalPlayer then
            Remote:FireServer(unpack(args2))
        end
    end
end

-- Toggles the background execution loops safely
local function setAuraState(state)
    autoLungeEnabled = state
    
    if autoLungeEnabled then
        -- Start monitoring frame-by-frame
        monitorConnection = RunService.Heartbeat:Connect(function()
            local hasCooldownObj = LocalPlayer:FindFirstChild("RushCooldown") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RushCooldown"))
            
            if hasCooldownObj then
                if not rushDetected and not isSpamming then
                    rushDetected = true
                    isSpamming = true
                    
                    local startTime = os.clock()
                    
                    -- Hook directly into Stepped for immediate execution
                    spamConnection = RunService.Stepped:Connect(function()
                        if os.clock() - startTime < SPAM_DURATION then
                            fireAtAllPlayers()
                        else
                            if spamConnection then
                                spamConnection:Disconnect()
                                spamConnection = nil
                            end
                            isSpamming = false
                        end
                    end)
                end
            else
                rushDetected = false
            end
        end)
    else
        -- Clean disconnect everything when toggled OFF to save resource usage
        if monitorConnection then
            monitorConnection:Disconnect()
            monitorConnection = nil
        end
        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end
        rushDetected = false
        isSpamming = false
    end
end

-- Run in background
task.spawn(startGuiCleaner)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5) -- Give the game time to load the health object
    if AutoEscapeEnabled then
        startAutoEscape()
    end
end)

if isMainMenu then
    local Window = Rayfield:CreateWindow({
        Name = "💫 Quasar Hub",
        LoadingTitle = "Demonfall OP GUI",
        LoadingSubtitle = "by 👑Mstu",
        ConfigurationSaving = { Enabled = false }
    })

    local Visual = Window:CreateTab("Character")
    Visual:CreateSection("Main Menu Character Customizer")

    Visual:CreateSlider({
        Name = "Clothes ID",
        Range = {0, 19},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 0,
        Flag = "Clothing_ID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "Clothes", Value)
            end)
        end,
    })

    Visual:CreateSlider({
        Name = "Eye ID",
        Range = {0, 18},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 1,
        Flag = "EyeID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "Eyes", Value)
            end)
        end,
    })

    Visual:CreateButton({
        Name = "Get Kokushibo Eyes",
        Callback = function()
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "Eyes", 99)
            end)
        end,
    })

    Visual:CreateColorPicker({
        Name = "Eyes Color",
        Color = Color3.fromRGB(255, 200, 150),
        Flag = "EyesColor",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sync"):InvokeServer("Character", "Customization", "Eyes", Value)
            end)
        end,
    })

    Visual:CreateSlider({
        Name = "Hair ID",
        Range = {0, 73},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 0,
        Flag = "Hair_ID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "Hair", Value)
            end)
        end,
    })

    Visual:CreateColorPicker({
        Name = "Hair Color",
        Color = Color3.fromRGB(255, 200, 150),
        Flag = "HairColor",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sync"):InvokeServer("Character", "Customization", "Hair", Value)
            end)
        end,
    })

    Visual:CreateSlider({
        Name = "Facial Hair ID",
        Range = {0, 11},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 0,
        Flag = "FacialHair_ID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "Facial Hair", Value)
            end)
        end,
    })

    Visual:CreateSlider({
        Name = "Mouth ID",
        Range = {0, 11},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 0,
        Flag = "Mouth_ID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "Mouth", Value)
            end)
        end,
    })

    Visual:CreateSlider({
        Name = "Nose ID",
        Range = {0, 16},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 0,
        Flag = "Nose_ID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "Nose", Value)
            end)
        end,
    })

    Visual:CreateSlider({
        Name = "True Scar 1 ID",
        Range = {0, 10},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 0,
        Flag = "TrueScar1_ID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "TrueScar1", Value)
            end)
        end,
    })

    Visual:CreateSlider({
        Name = "True Scar 2 ID",
        Range = {0, 10},
        Increment = 1,
        Suffix = "ID",
        CurrentValue = 0,
        Flag = "TrueScar2_ID",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Async"):FireServer("Character", "Customization", "TrueScar2", Value)
            end)
        end,
    })

    Visual:CreateColorPicker({
        Name = "Skin Color",
        Color = Color3.fromRGB(255, 200, 150),
        Flag = "SkinColor",
        Callback = function(Value)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sync"):InvokeServer("Character", "Customization", "Skin", Value)
            end)
        end,
    })

	Visual:CreateParagraph({
        Title = "👤 Gender & Name",
        Content = "Switch gender to randomize your first name. Current name updates live.\n (The First name also get changed when rolling clan)\n DOESNT WORK IN MAIN MENU U MUST BE WIPED OR PRESTIGED TO USE"
    })

    Visual:CreateButton({
        Name = "♂ Set Male",
        Callback = function()
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sync"):InvokeServer("Character", "Customization", "Gender", "Male")
            end)
        end,
    })

    Visual:CreateButton({
        Name = "♀ Set Female",
        Callback = function()
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sync"):InvokeServer("Character", "Customization", "Gender", "Female")
            end)
        end,
    })

	local firstNameLabel = Visual:CreateParagraph({
        Title = "First Name Viewer",
        Content = "Loading..."
    })

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Bridge").OnClientEvent:Connect(function(key, value)
        if key == "FirstName" then
            firstNameLabel:Set({
                Title = "First Name Viewer",
                Content = tostring(value)
            })
        end
    end)

	Visual:CreateParagraph({
        Title = "🎭 Live Customizer",
        Content = "Slide each category to change your look instantly!"
    })
    return
end

local Window = Rayfield:CreateWindow({
    Name = "💫 Quasar Hub",
    LoadingTitle = "Demonfall OP GUI",
    LoadingSubtitle = "by 👑Mstu",
    ConfigurationSaving = { Enabled = true, FolderName = "Ryzax", FileName = "MasterConfig" }
})

local Combat = Window:CreateTab("Combat")
local Bug = Window:CreateTab("Misc")
local Craft = Window:CreateTab("Crafting", 4483362458)
local MainTab = Window:CreateTab("Styling", 4483362458)
local WardrobeTab = Window:CreateTab("Wardrobe", 4483362458)
local KatTab = Window:CreateTab("Katana Config")
local TeleportTab = Window:CreateTab("Teleports")
local VisualsTab = Window:CreateTab("Visual")
local AF = Window:CreateTab("Auto Farm")

Combat:CreateSection("Smooth Walk speed set to 0.6 if you want iguro wind hybird speed")
Combat:CreateSlider({
    Name = "Tween Walk Speed",
    Range = {0, 5},
    Increment = 0.1,
    Suffix = "Speed",
    CurrentValue = 0,
    Flag = "tpwalk_speed",
    Callback = function(Value)
        tpSpeed = Value
        
        if tpSpeed > 0 then
            startTpWalk()
        else
            if tpwalking then tpwalking:Disconnect() end
        end
    end,
})

Combat:CreateToggle({Name = "No Stun / No Slow", CurrentValue = false, Flag = "AntiStun_F", Callback = function(v) 
    getgenv().NoStun = v 
    if v and not getgenv().__ANTI_DEBUFF_LOADED then loadstring(game:HttpGet("https://raw.githubusercontent.com/RiXNNN/Aurora-Hub/refs/heads/main/Anti-Debuff.lua"))() end
end})

Combat:CreateToggle({
   Name = "Auto Lunge On Rush",
   CurrentValue = false,
   Flag = "AutoLungeRushToggle",
   Callback = function(Value)
       setAuraState(Value)
       
       -- Visual confirmation notification
       Rayfield:Notify({
          Title = "Auto Lunge Status",
          Content = Value and "Auto Lunge Activated" or "Auto Lunge Deactivated.",
          Duration = 2,
          Image = 4483362458,
       })
   end,
})

Combat:CreateSection("Auto Parry For Rushes, Default Settings are for 40-60ms ping")
Combat:CreateToggle({
    Name = "Auto Parry Rushes",
    CurrentValue = false,
    Flag = "ToggleBlock", 
    Callback = function(Value)
        Config.Enabled = Value
    end,
})

Combat:CreateSlider({
    Name = "Normal Max Detection Range",
    Range = {10, 100},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 40,
    Flag = "SliderRange",
    Callback = function(Value)
        Config.MaxDistance = Value
    end,
})

Combat:CreateSlider({
    Name = "Normal Start Delay",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.48,
    Flag = "SliderDelay",
    Callback = function(Value)
        Config.StartDelay = Value
    end,
})

Combat:CreateSlider({
    Name = "Close Range Start Delay",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = 0.25,
    Flag = "SliderCloseDelay",
    Callback = function(Value)
        Config.CloseRangeDelay = Value
    end,
})

Combat:CreateSlider({
    Name = "Close Range Detection",
    Range = {5, 40},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 15,
    Flag = "SliderCloseThreshold",
    Callback = function(Value)
        Config.CloseRangeThreshold = Value
    end,
})

Combat:CreateSection("Damages yourself Enter ammount then hit the button dont go higher than 100 u will die (Doesnt Work with good executors) ")
Combat:CreateInput({
   Name = "Damage Amount",
   PlaceholderText = "Enter Number...",
   RemoveTextAfterFocusLost = false,
   Flag = "DamageInputFlag", -- This is how Rayfield stores the value
   Callback = function(Text)
      -- Rayfield calls this whenever the text changes
   end,
})

Combat:CreateButton({
   Name = "Damage Me!",
   Callback = function()
      -- We pull the text directly from the Rayfield Flag
      local rawText = Rayfield.Flags["DamageInputFlag"].CurrentValue
      local inputVal = tonumber(rawText)
      
      if inputVal then
         -- The exact arguments from your working script
         local calculatedArgs = {
            "Character",
            "FallDamageServer",
            inputVal * 4
         }
         
         TargetRemote:FireServer(unpack(calculatedArgs))
      else
         -- Rayfield Notification instead of just a warn
         Rayfield:Notify({
            Title = "Error",
            Content = "Please enter a valid number!",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})

Combat:CreateSection("Auto Escape kills urself to stay away from grips (xeno supported)")
Combat:CreateToggle({
   Name = "Auto Escape",
   CurrentValue = false,
   Flag = "AutoEscapeToggle",
   Callback = function(Value)
      AutoEscapeEnabled = Value
      if AutoEscapeEnabled then
         startAutoEscape()
      end
   end,
})
Combat:CreateSlider({
   Name = "Escape When Health is :",
   Range = {10, 50},
   Increment = 1,
   Suffix = "HP",
   CurrentValue = 15,
   Flag = "EscapeHP",
   Callback = function(Value)
      EscapeThreshold = Value
   end,
})

Combat:CreateSection("Auto Parry Settings can be used as Auto Block")
Combat:CreateToggle({
   Name = "Auto Dynamic Parry",
   CurrentValue = false,
   Flag = "ParryToggle",
   Callback = function(Value)
      P.ParryEnabled = Value
   end,
})

Combat:CreateSlider({
   Name = "Parry Hold Duration",
   Range = {0, 5},
   Increment = 0.15,
   Suffix = "s",
   CurrentValue = 0.15,
   Flag = "ParryHold",
   Callback = function(Value)
      P.ParryHoldTime = Value
   end,
})
Combat:CreateSlider({Name = "Parry Light Delay", Range = {0,0.5}, Increment = 0.001, CurrentValue = 0.1, Flag = "PLD_F", Callback = function(v) _G.P_LD = v end})
Combat:CreateSlider({Name = "Parry Heavy Delay", Range = {0,0.5}, Increment = 0.001, CurrentValue = 0.19, Flag = "PHD_F", Callback = function(v) _G.P_HD = v end})
Combat:CreateSection("Auto Counter Settings")
Combat:CreateToggle({Name = "Auto Counter", CurrentValue = false, Flag = "AutoCounter_F", Callback = function(v) _G.CounterEnabled = v end})
Combat:CreateSlider({Name = "Counter Light Delay", Range = {0,0.5}, Increment = 0.001, CurrentValue = 0.051, Flag = "CLD_F", Callback = function(v) _G.C_LD = v end})
Combat:CreateSlider({Name = "Counter Heavy Delay", Range = {0,0.5}, Increment = 0.001, CurrentValue = 0.115, Flag = "CHD_F", Callback = function(v) _G.C_HD = v end})
Combat:CreateInput({Name = "Counter Skill Key", CurrentValue = "Six", PlaceholderText = "Key Name", Flag = "CKey_F", Callback = function(v) _G.C_Key = v end})

local function SetupDropdown(sectionName, category)
    if not TPs.Data[category] then 
        warn("Warning: Category '" .. category .. "' not found in TeleportModule.Data")
        return 
    end

    TeleportTab:CreateSection(sectionName)
    
    local names = {}
    for name, _ in pairs(TPs.Data[category]) do 
        table.insert(names, name) 
    end
    
    table.sort(names)
    
    TeleportTab:CreateDropdown({
        Name = "Select " .. sectionName,
        Options = names,
        CurrentOption = {"Select..."},
        Callback = function(Option) 
            local coords = TPs.Data[category][Option[1]]
            if coords then
                TPs.To(coords)
            end
        end
    })
end

SetupDropdown("Main Places", "Places")
SetupDropdown("Perfect Crystal Spawns", "Perfect_Crystals")
SetupDropdown("NPC Trainers", "Trainers_NPCs")
SetupDropdown("Bosses", "Bosses")
SetupDropdown("Shops & Utility", "Shops_Utility")
SetupDropdown("Flowers", "Flowers")

VisualsTab:CreateSection("Health Bar Settings")
VisualsTab:CreateToggle({Name = "Enable Health Bars", CurrentValue = true, Flag = "HB_Enabled_F", Callback = function(v) getgenv().HB_Enabled = v RefreshHB() end})
VisualsTab:CreateToggle({Name = "Show Mobs/NPCs", CurrentValue = true, Flag = "HB_Mobs_F", Callback = function(v) getgenv().HB_MobsEnabled = v end})
VisualsTab:CreateToggle({Name = "Show Players", CurrentValue = true, Flag = "HB_Players_F", Callback = function(v) getgenv().HB_ShowPlayers = v end})
VisualsTab:CreateToggle({Name = "Show Health Frame", CurrentValue = true, Flag = "HB_Bar_F", Callback = function(v) getgenv().HB_ShowBar = v end})
VisualsTab:CreateToggle({Name = "Show NPC Names", CurrentValue = true, Flag = "HB_Names_F", Callback = function(v) getgenv().HB_ShowNPCNames = v end})
VisualsTab:CreateToggle({Name = "Show Health Text", CurrentValue = true, Flag = "HB_HText_F", Callback = function(v) getgenv().HB_ShowHealth = v end})
VisualsTab:CreateToggle({Name = "Show Max Health Text", CurrentValue = true, Flag = "HB_MText_F", Callback = function(v) getgenv().HB_ShowMaxHealth = v end})
VisualsTab:CreateSlider({Name = "Render Distance", Range = {100, 2000}, Increment = 50, CurrentValue = 600, Flag = "HB_Dist_F", Callback = function(v) getgenv().HB_MaxDistance = v end})
VisualsTab:CreateSlider({Name = "Health Bar Scale", Range = {0, 2}, Increment = 0.35, CurrentValue = 0.35, Flag = "HB_Scale_F", Callback = function(v) getgenv().HB_Scale = v end})

WardrobeTab:CreateSection("🎭 Face & Scars")

WardrobeTab:CreateSlider({
    Name = "Mouth Style (0-16)",
    Range = {0, 16},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 0,
    Callback = function(Value) 
        SavedState.Mouth = Value
        applyFacePart(Value, "Mouth", MouthsFolder) 
    end
})

WardrobeTab:CreateSlider({
    Name = "Nose Style (0-16)",
    Range = {0, 16},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 0,
    Callback = function(Value) 
        SavedState.Nose = Value
        applyFacePart(Value, "Nose", NosesFolder) 
    end
})

WardrobeTab:CreateSlider({
    Name = "TrueScar 1 (1-11)",
    Range = {1, 11},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 1,
    Callback = function(Value) 
        SavedState.Scar1 = Value
        applyFacePart(Value, "TrueScar1", ScarsFolder) 
    end
})

WardrobeTab:CreateSlider({
    Name = "TrueScar 2 (1-11)",
    Range = {1, 11},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 1,
    Callback = function(Value) 
        SavedState.Scar2 = Value
        applyFacePart(Value, "TrueScar2", ScarsFolder) 
    end
})

WardrobeTab:CreateButton({
    Name = "❌ Delete Normal Scars",
    Callback = function()
        if IsRestoring then return end

        SavedState.Scar1 = 0
        SavedState.Scar2 = 0

        clearScars("Normal")
    end
})


WardrobeTab:CreateSection("✨ Special Scars")

WardrobeTab:CreateColorPicker({
    Name = "Special Scar Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) 
        SpecialScarColor = Value 
        local char = game.Players.LocalPlayer.Character
        local faceBlock = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("FaceBlock")
        if faceBlock then
            local s1 = faceBlock:FindFirstChild("SpecialScar1")
            local s2 = faceBlock:FindFirstChild("SpecialScar2")
            if s1 then s1.Color3 = Value s1.ZIndex = -999 end
            if s2 then s2.Color3 = Value s2.ZIndex = -999 end
        end
    end
})

WardrobeTab:CreateSlider({
    Name = "Special Scar 1 (1-23)",
    Range = {1, 23},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 1,
    Callback = function(Value) 
        SavedState.SScar1 = Value
        applyFacePart(Value, "SpecialScar1", EffectsFolder) 
    end
})

WardrobeTab:CreateSlider({
    Name = "Special Scar 2 (1-23)",
    Range = {1, 23},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 1,
    Callback = function(Value) 
        SavedState.SScar2 = Value
        applyFacePart(Value, "SpecialScar2", EffectsFolder) 
    end
})

WardrobeTab:CreateButton({
    Name = "❌ Delete Special Scars",
    Callback = function()
        if IsRestoring then return end

        SavedState.SScar1 = 0
        SavedState.SScar2 = 0

        clearScars("Special")
    end
})


WardrobeTab:CreateSection("👑 Legendary NPC Clothes (Scanner)")
WardrobeTab:CreateDropdown({
    Name = "Steal Outfit",
    Options = {"Yoriichi Tsugikuni", "Rengoku", "Tokito", "Mitsuri", "Iguro", "Shinobu", "Sanemi", "Uzui", "Akaza", "Kokushibo", "Tsuyuri", "Uncle Kohon", "Tanjiro"},
    CurrentOption = {"Rengoku"},
    Callback = function(Option) equipLegendary(NPC_Coords[Option[1]] and NPC_Coords[Option[1]].Internal or Option[1]) end
})
WardrobeTab:CreateDropdown({
    Name = "TP, Wait & Grab (Returns to Last Pos)",
    Options = {"Kokushibo", "Rengoku", "Tokito", "Mitsuri", "Iguro", "Shinobu", "Sanemi", "Uzui", "Akaza", "Tsuyuri", "Uncle Kohon", "Tanjiro"},
    CurrentOption = {"Rengoku"},
    Callback = function(Option)
        local data = NPC_Coords[Option[1]]
        local char = game.Players.LocalPlayer.Character
        if data and char and char:FindFirstChild("HumanoidRootPart") then
            local oldPos = char.HumanoidRootPart.CFrame
            char:SetPrimaryPartCFrame(CFrame.new(data.Pos))
            task.wait(1)
            equipLegendary(data.Internal)
            char:SetPrimaryPartCFrame(oldPos)
        end
    end
})

WardrobeTab:CreateSection("🎭 Mask & Box Accessories")

local accList = getValidAccessories()
WardrobeTab:CreateDropdown({
    Name = "Accessory Slot 1",
    Options = accList,
    CurrentOption = {"None"},
    Callback = function(Option)
        SavedState.Slot1 = Option[1]
        equipAccessory(Option[1], "Slot1")
    end
})

WardrobeTab:CreateDropdown({
    Name = "Accessory Slot 2",
    Options = accList,
    CurrentOption = {"None"},
    Callback = function(Option)
        SavedState.Slot2 = Option[1]
        equipAccessory(Option[1], "Slot2")
    end
})

WardrobeTab:CreateButton({
    Name = "❌ Delete Both Accessories",
    Callback = function()
        if IsRestoring then return end

        SavedState.Slot1 = "None"
        SavedState.Slot2 = "None"

        equipAccessory("None", "Slot1")
        equipAccessory("None", "Slot2")

        if Slot1Dropdown then Slot1Dropdown:Set({"None"}) end
        if Slot2Dropdown then Slot2Dropdown:Set({"None"}) end
    end
})


WardrobeTab:CreateButton({
    Name = "🔄 Refresh Accessory List",
    Callback = function()
        local updatedList = getValidAccessories()
    end
})


WardrobeTab:CreateSection("💎 Custom Accessorys (yorichi earings at 9)")

WardrobeTab:CreateSlider({
    Name = "Custom Accessorys",
    Range = {1, 9},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 1,
    Callback = function(Value)
        if Value == 8 then return end -- skip 8
        equipCustomAccessory(tostring(Value))
    end
})

WardrobeTab:CreateColorPicker({
    Name = "Accessory Color",
    Color = Color3.fromRGB(155, 0, 0),
    Callback = function(Value)
        CurrentAccColor = Value
        if EquippedCustomAcc then
            for _, p in pairs(EquippedCustomAcc:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Color = Value
                end
            end
            if EquippedCustomAcc:IsA("BasePart") then
                EquippedCustomAcc.Color = Value
            end
        end
    end
})

WardrobeTab:CreateButton({
    Name = "❌ Remove Custom Accessory",
    Callback = function()
        if EquippedCustomAcc then
            EquippedCustomAcc:Destroy()
            EquippedCustomAcc = nil
        end
    end
})

WardrobeTab:CreateSection("🧥 Legendary Haoris")

WardrobeTab:CreateDropdown({
    Name = "Select Haori",
    Options = getHaoriList(),
    CurrentOption = {"None"},
    Callback = function(Option)
        SavedState.Haori = Option[1]
        equipHaori(Option[1])
    end
})

WardrobeTab:CreateButton({
    Name = "❌ Delete Haori",
    Callback = function()
        if IsRestoring then return end

        SavedState.Haori = "None"
        equipHaori("None")

        if HaoriDropdown then
            HaoriDropdown:Set({"None"})
        end
    end
})


WardrobeTab:CreateSection("👔 Normal Clothes")
WardrobeTab:CreateSlider({
    Name = "Civilian Outfits (0-32)",
    Range = {0, 32},
    Increment = 1,
    Suffix = "Set",
    CurrentValue = 0,
    Callback = function(Value)
        SavedState.LastClothesValue = Value
        SavedState.LastClothesType = "Civilian"
        equipClothes(Value, ClothesFolder)
    end
})

WardrobeTab:CreateSection("⚔️ NPC Slayer Clothes")
WardrobeTab:CreateSlider({
    Name = "NPC Outfits (1-13)",
    Range = {1, 13},
    Increment = 1,
    Suffix = "Style",
    CurrentValue = 1,
    Callback = function(Value)
        SavedState.LastClothesValue = Value
        SavedState.LastClothesType = "NPC"
        equipClothes(Value, SlayerClothesFolder)
    end
})

WardrobeTab:CreateSection("🎭 Slayer Corps Uniforms")
WardrobeTab:CreateSlider({
    Name = "Uniform IDs (1-41)",
    Range = {1, 41},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 1,
    Callback = function(Value)
        SavedState.LastClothesValue = Value
        SavedState.LastClothesType = "Uniform"
        equipClothes(Value, PlayerUniformFolder)
    end
})

MainTab:CreateSection("👹 Demon Horns")
MainTab:CreateSlider({
    Name = "Select Horns (0-9)",
    Range = {0,9},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(Value)
        if IsRestoring then return end
        SavedState.Horns = tostring(Value)
        equipHorns(tostring(Value))
    end
})

MainTab:CreateColorPicker({
    Name = "Horn Color",
    Color = Color3.fromRGB(0,0,0),
    Callback = function(Value)
        if IsRestoring then return end
        SavedState.HornColor = Value
        CurrentHornColor = Value
        updateAll()
    end
})

MainTab:CreateDropdown({
    Name = "Horn Material",
    Options = {"Plastic","Neon","ForceField","SmoothPlastic","Sand","Glass"},
    CurrentOption = {"Glass"},
    Callback = function(Option)
        if IsRestoring then return end
        SavedState.HornMaterial = Enum.Material[Option[1]]
        CurrentHornMaterial = Enum.Material[Option[1]]
        updateAll()
    end
})

MainTab:CreateSection("🔥 Power Auras and Marks")
MainTab:CreateDropdown({ Name = "Select Aura", Options = {"None", "Beast", "Flames", "Flower", "Insect", "Lightning", "Love", "Mist", "Snake", "Sound", "Stone", "Sun", "Water", "Wind"}, CurrentOption = {"None"}, Callback = function(Option) equipAura(Option[1]) end })
MainTab:CreateDropdown({ Name = "Select Mark", Options = {"None", "Beast", "Flames", "Flower", "Insect", "Lightning", "Love", "Mist", "Snake", "Sound", "Stone", "Sun", "Water", "Wind"}, CurrentOption = {"None"}, Callback = function(Option) equipMark(Option[1]) end })
MainTab:CreateSection("💇 Hair Selection ,Note if you want kokushibo hair u must render kokushibo npc")
MainTab:CreateSlider({
    Name = "Standard Hairs (1-73)",
    Range = {1,73},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value)
        if IsRestoring then return end
        SavedState.Hair = tostring(Value)
        equipHair(tostring(Value))
    end
})

MainTab:CreateDropdown({
    Name = "Special & Family Hairs",
    Options = {"Kokushibo","Yoriichi","Rengoku","Zenitsu","Douma","Obanai","Kaigaku"},
    CurrentOption = {},
    Callback = function(Option)
        if IsRestoring then return end
        SavedState.Hair = Option[1]
        equipHair(Option[1])
    end
})

MainTab:CreateSection("🎨 Global Style")
MainTab:CreateColorPicker({
    Name = "Skin Color",
    Color = DefaultSkinColor,
    Callback = function(Value) 
        SavedState.SkinColor = Value
        applySkinColor(Value) 
    end
})
MainTab:CreateButton({ Name = "Default Human Color", Callback = function() CurrentSkinColor = DefaultSkinColor applySkinColor(DefaultSkinColor) end })
MainTab:CreateColorPicker({ 
    Name = "Hair Color", 
    Color = Color3.fromRGB(0, 0, 0), 
    Callback = function(Value) 
        CurrentColor = Value 
        SavedState.HairColor = Value  -- 👈 SAVE IT!
        updateAll() 
    end 
})
MainTab:CreateDropdown({ 
    Name = "Hair Material", 
    Options = {"Plastic", "Neon", "ForceField", "SmoothPlastic", "Sand", "Glass"}, 
    CurrentOption = {"Sand"}, 
    Callback = function(Option) 
        CurrentMaterial = Enum.Material[Option[1]] 
        SavedState.HairMaterial = Enum.Material[Option[1]]
        updateAll() 
    end 
})

MainTab:CreateSection("👁️ Eye Customizer")

MainTab:CreateSlider({
    Name = "Eye Style (0-18, 99)",
    Range = {0, 99},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(Value)
        if (Value >= 0 and Value <= 18) or Value == 99 then 
            SavedState.Eyes = Value -- SAVE
            applyEyes(Value) 
        end
    end
})

MainTab:CreateSection("🎨 Eye Color Settings")

MainTab:CreateColorPicker({
    Name = "Pupil",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) colorGenericLayer("Pupil", Value) end
})

MainTab:CreateColorPicker({
    Name = "Fundo Layer 1",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) colorFundoByIndex(1, Value) end
})

MainTab:CreateColorPicker({
    Name = "Fundo Layer 2 (if exist)",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) colorFundoByIndex(2, Value) end
})

MainTab:CreateColorPicker({
    Name = "Fundo Layer 3 (if exist)",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) colorFundoByIndex(3, Value) end
})

MainTab:CreateColorPicker({
    Name = "Sombraceia (if exist)",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) colorGenericLayer("Sombraceia", Value) end
})

MainTab:CreateColorPicker({
    Name = "Bonor (if exist)",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Value) colorGenericLayer("Bonor", Value) end
})

MainTab:CreateSection("🔍 Search for your eye settings")

MainTab:CreateButton({
    Name = "Scan Eye Layers",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local faceBlock = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("FaceBlock")
        if faceBlock then
            local counts = {}
            for _, v in pairs(faceBlock:GetChildren()) do
                if v:IsA("Decal") and (v.Name == "Pupil" or v.Name == "Fundo" or v.Name == "Sombraceia" or v.Name == "Bonor") then
                    counts[v.Name] = (counts[v.Name] or 0) + 1
                end
            end
            
            local report = ""
            for name, count in pairs(counts) do
                report = report .. name .. " (x" .. count .. ") "
            end
            
            Rayfield:Notify({
                Title = "Eye Scanner",
                Content = report ~= "" and "Detected: " .. report or "No Eye Layers Found",
                Duration = 5
            })
        end
    end
})

Bug:CreateSection("Active Optimization Status")
Bug:CreateParagraph({
    Title = "✅ Background Processes Synchronized",
    Content = "• 🟢 **Anti-Debuffs Engine**\n• 🟢 **Fall Damage Bypass Xeno not supported**\n• 🟢 **No Katana Collision**\n• 🟢 **Automated Corpse Remover**\n• 🟢 **Global Collision Bypass**\n• 🟢 **infinite Double Jumps**"
})
Bug:CreateSection("Aura Loot, Loots Near by Trinket or Drop")
Bug:CreateToggle({
    Name = "Aura Loot",
    CurrentValue = false,
    Flag = "AutoLoot_F",
    Callback = function(Value)
        getgenv().AutoLoot = Value
        if not Value then
            table.clear(LootCache) 
        end
    end
})

Bug:CreateButton({
    Name = "Force Reset E button",
    Callback = function()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "DropItem" or obj:FindFirstChild("PickableItem", true) then
                local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("ProximityPrompt", true)
                local targetPart = obj:FindFirstChild("Main") or (obj:IsA("BasePart") and obj) or obj:FindFirstChildWhichIsA("BasePart", true)
                
                if prompt then prompt.Enabled = true end
                if targetPart then 
                    targetPart.Transparency = 0 
                end
            end
        end
        table.clear(LootCache)
        
        Rayfield:Notify({
            Title = "System",
            Content = "All prompts and items have been reset.",
            Duration = 2
        })
    end,
})

Bug:CreateSection("Chatwindow Enabler")
Bug:CreateToggle({
   Name = "Chat Window",
   CurrentValue = true,
   Flag = "ChatWindowToggle",
   Callback = function(Value)
      game:GetService("TextChatService").ChatWindowConfiguration.Enabled = Value
   end,
})

Bug:CreateToggle({
    Name = "Better View",
    CurrentValue = false,
    Flag = "BetterView_Tog",
    Callback = function(Value)
        P.BetterView = Value
        toggleBetterView(Value)
    end,
})

Bug:CreateToggle({
   Name = "Remove Demon Spawn Barriers",
   CurrentValue = false,
   Flag = "BarrierToggle",
   Callback = function(Value)
       barriersDisabled = Value
       -- Update all currently visible barriers immediately
       updateExistingBarriers()
   end,
})

-- Handle newly added parts dynamically (StreamingEnabled/Rendering)
task.spawn(function()
    -- Safely wait for the folders to exist without yielding/freezing the Rayfield UI
    local map = workspace:WaitForChild("Map", math.huge)
    local barriers = map:WaitForChild("Barriers", math.huge)

    -- Listen for new parts streaming into the Barriers folder
    barriers.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            -- If the toggle is ON, disable collisions for the newly rendered part
            if barriersDisabled then
                -- A brief yield ensures the engine has finished assigning default properties
                task.wait() 
                descendant.CanCollide = false
            end
        end
    end)
end)

Bug:CreateSection("Free Emotes Bypasser")
Bug:CreateToggle({
    Name = "Free Emotes Gamepass FOR PC",
    CurrentValue = false,
    Flag = "EmoteMenu_Toggle_PC",
    Callback = function(Value)
        if Value then
            -- Start forcing original frame invisible
            getgenv().EmoteMenuEnabled = true

            task.spawn(function()
                while getgenv().EmoteMenuEnabled do
                    task.wait(0.1) -- Fast check to keep it forced off
                    local ok, Emote = pcall(function()
                        return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
                    end)
                    if ok and Emote and Emote:IsA("GuiObject") then
                        Emote.Visible = false -- ONLY force the main frame invisible
                    end
                end
            end)

            -- Clone their Emote UI for our custom menu
            task.spawn(function()
                task.wait(0.5)
                local ok, originalEmote = pcall(function()
                    return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
                end)
                if not ok or not originalEmote then return end

                -- Remove old custom clone if it exists
                local oldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EmotesGui")
                if oldGui then oldGui:Destroy() end

                local cloned = originalEmote:Clone()
                
                -- Ensure our custom clone's children are visible
                for _, child in pairs(cloned:GetChildren()) do
                    if child:IsA("GuiObject") then
                        child.Visible = true
                    end
                end

                local ourGui = Instance.new("ScreenGui")
                ourGui.Name = "EmotesGui"
                ourGui.ResetOnSpawn = false
                ourGui.Parent = game.Players.LocalPlayer.PlayerGui

                cloned.Parent = ourGui
                cloned.Visible = false -- Hidden until 'H' is pressed

                -- Wire custom buttons to PlayEmote
                for _, child in pairs(cloned:GetChildren()) do
                    if child:IsA("GuiObject") then
                        local btn = child:FindFirstChildOfClass("TextButton") or child:FindFirstChildOfClass("ImageButton")
                        if btn then
                            btn.MouseButton1Click:Connect(function()
                                PlayEmote(child.Name)
                            end)
                        end
                        if child:IsA("TextButton") or child:IsA("ImageButton") then
                            child.MouseButton1Click:Connect(function()
                                PlayEmote(child.Name)
                            end)
                        end
                    end
                end

                getgenv().OurEmoteClone = cloned

                -- H key toggle for the CUSTOM menu
                if not getgenv().EmoteHKeyConnected then
                    getgenv().EmoteHKeyConnected = true
                    game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
                        if not gpe and input.KeyCode == Enum.KeyCode.H then
                            if getgenv().OurEmoteClone then
                                getgenv().OurEmoteClone.Visible = not getgenv().OurEmoteClone.Visible
                            end
                        end
                    end)
                end
            end)

        else
            -- Toggle OFF: Stop the forcing loop entirely
            getgenv().EmoteMenuEnabled = false

            -- Remove our custom UI
            local oldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EmotesGui")
            if oldGui then oldGui:Destroy() end
            getgenv().OurEmoteClone = nil

            -- Hand control back to the game completely
            local ok, Emote = pcall(function()
                return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
            end)
            if ok and Emote and Emote:IsA("GuiObject") then
                Emote.Visible = true -- Bring it back once, game handles it from here
            end
        end
    end,
})
Bug:CreateToggle({
    Name = "Free Emotes Gamepass FOR MOBILE",
    CurrentValue = false,
    Flag = "EmoteMenu_Toggle_Mobile",
    Callback = function(Value)
        if Value then
            -- Start forcing original frame invisible
            getgenv().EmoteMenuEnabled = true

            task.spawn(function()
                while getgenv().EmoteMenuEnabled do
                    task.wait(0.1) -- Fast check to keep it forced off
                    local ok, Emote = pcall(function()
                        return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
                    end)
                    if ok and Emote and Emote:IsA("GuiObject") then
                        Emote.Visible = false -- ONLY force the main frame invisible
                    end
                end
            end)

            -- Clone their Emote UI for our custom menu
            task.spawn(function()
                task.wait(0.5)
                local ok, originalEmote = pcall(function()
                    return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
                end)
                if not ok or not originalEmote then return end

                -- Remove old custom clone if it exists
                local oldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EmotesGui")
                if oldGui then oldGui:Destroy() end

                local cloned = originalEmote:Clone()
                
                -- Ensure our custom clone's children are visible
                for _, child in pairs(cloned:GetChildren()) do
                    if child:IsA("GuiObject") then
                        child.Visible = true
                    end
                end

                local ourGui = Instance.new("ScreenGui")
                ourGui.Name = "EmotesGui"
                ourGui.ResetOnSpawn = false
                ourGui.Parent = game.Players.LocalPlayer.PlayerGui

                cloned.Parent = ourGui
                cloned.Visible = false -- Hidden until toggled via the button

                -- Wire custom buttons to PlayEmote
                for _, child in pairs(cloned:GetChildren()) do
                    if child:IsA("GuiObject") then
                        local btn = child:FindFirstChildOfClass("TextButton") or child:FindFirstChildOfClass("ImageButton")
                        if btn then
                            btn.MouseButton1Click:Connect(function()
                                PlayEmote(child.Name)
                            end)
                        end
                        if child:IsA("TextButton") or child:IsA("ImageButton") then
                            child.MouseButton1Click:Connect(function()
                                PlayEmote(child.Name)
                            end)
                        end
                    end
                end

                getgenv().OurEmoteClone = cloned

                --- ON-SCREEN TOGGLE BUTTON ---
                local uiBtn = Instance.new("TextButton")
                uiBtn.Name = "EmoteToggleButton"
                uiBtn.Size = UDim2.new(0, 90, 0, 35)
                uiBtn.Position = UDim2.new(0.05, 0, 0.4, 0) -- Left side of screen
                uiBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                uiBtn.Text = "Emotes"
                uiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                uiBtn.Font = Enum.Font.SourceSansBold
                uiBtn.TextSize = 16
                uiBtn.Active = true 
                uiBtn.Parent = ourGui

                local uiCorner = Instance.new("UICorner")
                uiCorner.CornerRadius = UDim.new(0, 8)
                uiCorner.Parent = uiBtn

                --- DRAGGING & NO-CLICK LOGIC ---
                local UserInputService = game:GetService("UserInputService")
                local dragging = false
                local dragInput, dragStart, startPos
                local totalDelta = 0 -- Track drag distance to prevent click activation

                uiBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragStart = input.Position
                        startPos = uiBtn.Position
                        totalDelta = 0 -- Reset distance tracker

                        local connection
                        connection = input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                                connection:Disconnect()
                                
                                -- Only toggle the menu if the user tapped/clicked without shifting the button significantly
                                if totalDelta < 5 then
                                    if getgenv().OurEmoteClone then
                                        getgenv().OurEmoteClone.Visible = not getgenv().OurEmoteClone.Visible
                                    end
                                end
                            end
                        end)
                    end
                end)

                uiBtn.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        dragInput = input
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input == dragInput and dragging then
                        local delta = input.Position - dragStart
                        totalDelta = delta.Magnitude -- Calculate actual drag distance
                        
                        uiBtn.Position = UDim2.new(
                            startPos.X.Scale, 
                            startPos.X.Offset + delta.X, 
                            startPos.Y.Scale, 
                            startPos.Y.Offset + delta.Y
                        )
                    end
                end)
            end)

        else
            -- Toggle OFF: Stop the forcing loop entirely
            getgenv().EmoteMenuEnabled = false

            -- Remove our custom UI (Deletes the menu and the on-screen button instantly)
            local oldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EmotesGui")
            if oldGui then oldGui:Destroy() end
            getgenv().OurEmoteClone = nil

            -- Hand control back to the game completely
            local ok, Emote = pcall(function()
                return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
            end)
            if ok and Emote and Emote:IsA("GuiObject") then
                Emote.Visible = true
            end
        end
    end,
})

Bug:CreateToggle({
    Name = "Smart Auto Boulder",
    CurrentValue = false,
    Flag = "AutoBoulderFlag",
    Callback = function(Value)
        AutoBoulderEnabled = Value

        if AutoBoulderEnabled then
            startHUDBridge()

            -- 🔥 DEDICATED FAST SPAM LOOP (~50-60 times per second)
            task.spawn(function()
                while AutoBoulderEnabled do
                    local Character = player.Character
                    local BoulderPart = Character and Character:FindFirstChild("Boulder")
                    
                    if Character and BoulderPart and not _G.Refilling then
                        pcall(function()
                            RemoteAsync:FireServer("Boulder", "Server")
                        end)
                    end
                    task.wait()
                end
            end)

            -- 🔄 BAR REFILL LOOP (Fires every 7 seconds, cancels INSTANTLY on toggle off)
            task.spawn(function()
                task.wait(3) -- Initial wait for everything to load in

                while AutoBoulderEnabled do
                    local Character = player.Character
                    local BoulderPart = Character and Character:FindFirstChild("Boulder")

                    if BoulderPart and not _G.Refilling then
                        pcall(function()
                            RemoteSync:InvokeServer("Player", "SpawnCharacter")
                        end)
                        print("⚡ Bar Refill: SpawnCharacter fired")
                    end

                    -- 🛑 Responsive 7-second wait channel
                    local elapsed = 0
                    while AutoBoulderEnabled and elapsed < 7 do
                        task.wait(0.1)
                        elapsed = elapsed + 0.1
                    end
                end
            end)

            -- MAIN ACTION LOOP (Handles emergency low-HP structural refills)
            task.spawn(function()
                while AutoBoulderEnabled do
                    local Character = player.Character
                    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                    local BoulderPart = Character and Character:FindFirstChild("Boulder")
                    local HealthVal = player:FindFirstChild("Health")

                    -- 1. FORCE BOULDER ON (The "Enforcer")
                    if Character and not BoulderPart and not _G.Refilling then
                        pcall(function()
                            RemoteAsync:FireServer("Boulder", "Server")
                        end)
                        task.wait(0.5)
                    end

                    -- 2. EMERGENCY REFILL LOGIC
                    if HealthVal and Root and BoulderPart and not _G.Refilling then
                        if HealthVal.Value <= LowHealthThreshold then
                            local currentTime = tick()

                            if currentTime - _G.LastHealTime >= 7.5 then
                                _G.Refilling = true
                                _G.LastHealTime = currentTime

                                local lastPos = Root.CFrame
                                print("🚨 HP Low! Emergency Refilling...")

                                task.spawn(function()
                                    local timeout = 0
                                    while not player:FindFirstChild("Health") and timeout < 30 do
                                        timeout = timeout + 1
                                        task.wait(0.1)
                                    end

                                    local newChar = player.CharacterAdded:Wait()
                                    local newRoot = newChar:WaitForChild("HumanoidRootPart", 5)

                                    if newRoot then
                                        task.wait(0.4)
                                        newRoot.CFrame = lastPos
                                    end

                                    _G.Refilling = false
                                    print("✅ Emergency Refill Cycle Complete")
                                end)
                            end
                        end
                    end

                    task.wait(0.3)
                end
            end)

        else
            -- 🛑 TOGGLE TURNED OFF: CLEANUP SEQUENCE
            _G.Refilling = false
            _G.BridgeActive = false

            -- Run an instant check to kill the boulder immediately if left behind
            local Character = player.Character
            if Character and Character:FindFirstChild("Boulder") then
                pcall(function()
                    RemoteAsync:FireServer("Boulder", "Server")
                end)
                print("🛑 Toggle Off: Extra cleanup remote fired to remove leftover Boulder")
            end

            -- 3. FORCE REMOVAL BACKUP LOOP (Looping until fully gone)
            task.spawn(function()
                for i = 1, 10 do
                    local CurrentChar = player.Character
                    if CurrentChar and CurrentChar:FindFirstChild("Boulder") then
                        pcall(function()
                            RemoteAsync:FireServer("Boulder", "Server")
                        end)
                        task.wait(0.5)
                    else
                        break
                    end
                end
            end)
        end
    end,
})

Bug:CreateButton({
   Name = "Be Demon",
   Info = "Be Demon without Data Loss, Money / Lvls / Skills will stay with you",
   Interact = 'Click to Execute',
   Callback = function()
       if WaitingForDemon then
           DemonCancel = true
           WaitingForDemon = false
           Rayfield:Notify({
               Title = "Canceled",
               Content = "Process aborted. No changes made.",
               Duration = 3,
               Image = 4483362458,
           })
           return
       end

       WaitingForDemon = true
       DemonCancel = false
       
       Rayfield:Notify({
           Title = "Confirmation Required",
           Content = "Are you sure? Click again within 10s to CANCEL.",
           Duration = 10,
           Image = 4483362458,
       })

       task.delay(10, function()
           if WaitingForDemon and not DemonCancel then
               local args = {"Tutorial", "Finalize", false}
               
               pcall(function()
                   game:GetService("ReplicatedStorage").Remotes.Async:FireServer(unpack(args))
               end)

               Rayfield:Notify({
                   Title = "Success",
                   Content = "You are now a Demon. Data preserved!",
                   Duration = 5,
                   Image = 4483362458,
               })
               WaitingForDemon = false
           end
       end)
   end,
})

Bug:CreateParagraph({
    Title = "😈 Be Demon",
    Content = "✅ Be Demon without Losing Data, Money / Level / Skills will stay with you \n ⚠️ There is a Confirmation if u want to cancel press Be Demon Again within 10secs"
})
Bug:CreateButton({
    Name = "Insta Water Breathing WORKS AS DUAL BREATHING",
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer

        local queueteleport = queue_on_teleport 
            or (syn and syn.queue_on_teleport) 
            or (fluxus and fluxus.queue_on_teleport)
            or (electron and electron.queue_on_teleport)
            or (sentinel and sentinel.queue_on_teleport)

        if not queueteleport then
            warn("Executor does not support queue_on_teleport!")
            return
        end

        -- Step 1: Queue script for Water instance (no nested [[ ]])
        queueteleport([[
            repeat task.wait() until game:IsLoaded()
            task.wait(2)

            local RS = game:GetService("ReplicatedStorage")
            local Remote = RS:WaitForChild("Remotes"):WaitForChild("Async")
            local LocalPlayer = game:GetService("Players").LocalPlayer

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(12599.8223, 1976.23657, -1017.20435, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            end

            task.wait(1)

            local mapPart = workspace:WaitForChild("Map"):WaitForChild("WaterExam"):WaitForChild("Water2"):WaitForChild("Pedras")
            Remote:FireServer("WaterFinal", "FinishTest", mapPart)
            print("FinishTest fired!")
        ]])

        -- Step 2: Fire Server to get teleported
        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Async"):FireServer("WaterFinal", "Server")
        end)

        Rayfield:Notify({
            Title = "💧 Water Breathing",
            Content = "Heading to Water instance...",
            Duration = 4,
            Image = 4483362458,
        })
    end,
})
Bug:CreateSection("Collision Optimizer")
local r6Parts = {"Head", "Torso"}

Bug:CreateToggle({
    Name = "No Player Collision",
    CurrentValue = false,
    Flag = "NoCol_F",
    Callback = function(v)
        getgenv().NoCollisionPlayer = v 
        
        if v and not getgenv().CollisionLoopStarted then
            getgenv().CollisionLoopStarted = true
            task.spawn(function()
                while true do
                    if getgenv().NoCollisionPlayer then
                        local myChar = LocalPlayer.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                                if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if otherRoot then
                                        local dist = (myRoot.Position - otherRoot.Position).Magnitude
                                        for _, pName in ipairs(r6Parts) do
                                            local p = otherPlayer.Character:FindFirstChild(pName)
                                            if p and p:IsA("BasePart") then
                                                if dist <= 17 then
                                                    p.CanCollide = false
                                                    p.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                                                else
                                                    p.CanCollide = true
                                                    p.CustomPhysicalProperties = nil
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    else
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                for _, pName in ipairs(r6Parts) do
                                    local part = p.Character:FindFirstChild(pName)
                                    if part then part.CanCollide = true end
                                end
                            end
                        end
                    end
                    task.wait(0.060)
                end
            end)
        end
    end
})

Bug:CreateToggle({
    Name = "Auto Panic, Leaves game when Moderator joins",
    CurrentValue = false,
    Flag = "AutoPanic_F",
    Callback = function(v)
        panicEnabled = v
        if v then
            panicConn = Players.PlayerAdded:Connect(function(player)
                if not panicEnabled then return end
                for _, name in ipairs(panicUsers) do
                    if player.Name:lower() == name:lower() then
                        Rayfield:Notify({
                            Title = "⚠️ Auto Panic",
                            Content = player.Name .. " joined — leaving!",
                            Duration = 3,
                            Image = 4483362458,
                        })
                        task.wait(0.5)
                        game:GetService("Players").LocalPlayer:Kick("Auto Panic triggered.\n one of moderators joined the game !")
                        break
                    end
                end
            end)

            -- Also check players already in server when toggled on
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    for _, name in ipairs(panicUsers) do
                        if player.Name:lower() == name:lower() then
                            Rayfield:Notify({
                                Title = "⚠️ Auto Panic",
                                Content = player.Name .. " is already here — leaving!",
                                Duration = 3,
                                Image = 4483362458,
                            })
                            task.wait(0.5)
                            game:GetService("Players").LocalPlayer:Kick("Auto Panic triggered.")
                            break
                        end
                    end
                end
            end
        else
            if panicConn then
                panicConn:Disconnect()
                panicConn = nil
            end
        end
    end
})

Bug:CreateSection("Skills Keybind Changer")
Bug:CreateInput({
    Name = "Skill 6 Key",
    CurrentValue = "T",
    PlaceholderText = "Example: T",
    Flag = "S6_In",
    Callback = function(v) _G.S6_String = v end
})
Bug:CreateInput({
    Name = "Skill 7 Key",
    CurrentValue = "LeftAlt",
    PlaceholderText = "Example: LeftAlt",
    Flag = "S7_In",
    Callback = function(v) _G.S7_String = v end
})
Bug:CreateInput({
    Name = "Skill T Key",
    CurrentValue = "Y",
    PlaceholderText = "Example: Y",
    Flag = "ST_In",
    Callback = function(v) _G.ST_String = v end
})
Bug:CreateInput({
    Name = "Skill Y Key",
    CurrentValue = "U",
    PlaceholderText = "Example: U",
    Flag = "SY_In",
    Callback = function(v) _G.SY_String = v end
})

Dropdown = Craft:CreateDropdown({
    Name = "Select Item to Craft",
    Options = ItemNames,
    CurrentOption = {ItemNames[1] or ""},
    MultipleOptions = true, 
    Callback = function(Options)
        if #Options > 1 then
            local newestSelection = Options[#Options]
            Dropdown:Set({newestSelection}) 
            selectedItemName = newestSelection
        else
            selectedItemName = Options[1]
        end
        
        if _G.UpdateRequirements then
            _G.UpdateRequirements(selectedItemName)
        end
    end,
})

-- 2. MIDDLE ELEMENT: Requirements Paragraph
local RequirementsParagraph = Craft:CreateParagraph(
    {Title = "Requirements", Content = "Select an item to view requirements."}
)

-- Helper function to refresh the requirements display automatically
_G.UpdateRequirements = function(itemName)
    if not itemName or not ItemData[itemName] then
        RequirementsParagraph:Set({Title = "Error", Content = "Invalid item selected."})
        return
    end

    local itemInfo = ItemData[itemName]
    local itemFolder = itemInfo.Instance
    local reqList = {}

    -- Scan folder specifically for IntValues, ignoring models
    for _, obj in ipairs(itemFolder:GetChildren()) do
        if obj:IsA("IntValue") then
            table.insert(reqList, string.format("• %s: %d", obj.Name, obj.Value))
        end
    end

    if #reqList == 0 then
        RequirementsParagraph:Set({Title = itemName, Content = "No cost requirements found (or values missing)."})
    else
        RequirementsParagraph:Set({Title = itemName .. " Cost:", Content = table.concat(reqList, "\n")})
    end
end

-- Automatically trigger the requirement check for the first item on load
if ItemNames[1] then
    selectedItemName = ItemNames[1]
    _G.UpdateRequirements(selectedItemName)
end

-- 3. BOTTOM ELEMENT: Invoke Crafting Remote Button
Craft:CreateButton({
    Name = "Craft Selected Item",
    Callback = function()
        if not selectedItemName or not ItemData[selectedItemName] then
            Rayfield:Notify({
                Title = "Error",
                Content = "No item selected!",
                Duration = 3,
                Image = 4483362458,
            })
            return
        end

        local itemInfo = ItemData[selectedItemName]
        
        local success, err = pcall(function()
            RemoteSync:InvokeServer(
                "Craft",
                itemInfo.Category,
                itemInfo.Instance
            )
        end)

        if success then
            Rayfield:Notify({
                Title = "Success",
                Content = "Craft remote sent for " .. selectedItemName,
                Duration = 4,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Remote Error",
                Content = tostring(err),
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})

Craft:CreateParagraph(
    {Title = "How it works", Content = "its working even if u aint slayer\nNow There is no need to complete Slayer Exam only if u want inf castle\nUsing this u can get demon clothes but just dont complete slayer exam"}
)

KatTab:CreateSection("THESE ARE VISUAL-ONLY")
KatTab:CreateToggle({Name = "Custom Trail Toggle", CurrentValue = true, Flag = "TrailToggle_F", Callback = function(v) _G.CustomTrailEnabled = v end})
KatTab:CreateDropdown({Name = "Blade Material", Options = {"Neon", "Plastic", "ForceField", "Glass", "DiamondPlate"}, CurrentOption = {"Neon"}, Flag = "Mat_F", Callback = function(opt) _G.CurrentMaterial = opt[1] end})
KatTab:CreateColorPicker({Name = "Blade Color", Color = Color3.fromRGB(255,255,255), Flag = "BladeCol_F", Callback = function(v) _G.BladeColor = v end})
KatTab:CreateColorPicker({Name = "Trail Color", Color = Color3.fromRGB(255,255,255), Flag = "TrailCol_F", Callback = function(v) _G.TrailColor = v end})
KatTab:CreateSlider({Name = "Light Range", Range = {0, 100}, Increment = 1, CurrentValue = 0, Flag = "LRange_F", Callback = function(v) _G.L_Range = v end})
KatTab:CreateSlider({Name = "Light Power", Range = {0, 20}, Increment = 1, CurrentValue = 0, Flag = "LPow_F", Callback = function(v) _G.L_Power = v end})
KatTab:CreateSlider({Name = "Trail Lifetime", Range = {0.1, 5}, Increment = 0.1, CurrentValue = 0.5, Flag = "TLife_F", Callback = function(v) _G.T_Lifetime = v end})
task.spawn(function()
    Rayfield:LoadConfiguration()
    local F = Rayfield.Flags
    
	if F.S6_In and F.S6_In.CurrentValue ~= "" then _G.S6_String = F.S6_In.CurrentValue end
    if F.S7_In and F.S7_In.CurrentValue ~= "" then _G.S7_String = F.S7_In.CurrentValue end
    if F.ST_In and F.ST_In.CurrentValue ~= "" then _G.ST_String = F.ST_In.CurrentValue end
    if F.SY_In and F.SY_In.CurrentValue ~= "" then _G.SY_String = F.SY_In.CurrentValue end

	-- Existing katana stuff
    if F.BladeCol_F then _G.BladeColor = F.BladeCol_F.Color end
    if F.TrailCol_F then _G.TrailColor = F.TrailCol_F.Color end
    if F.Mat_F then _G.CurrentMaterial = F.Mat_F.CurrentOption[1] end
    if F.TrailToggle_F then _G.CustomTrailEnabled = F.TrailToggle_F.CurrentValue end
    if F.LRange_F then _G.L_Range = F.LRange_F.CurrentValue end
    if F.LPow_F then _G.L_Power = F.LPow_F.CurrentValue end
    if F.TLife_F then _G.T_Lifetime = F.TLife_F.CurrentValue end

    -- ✅ AUTO LOOT
    if F.AutoLoot_F and F.AutoLoot_F.CurrentValue then
        getgenv().AutoLoot = true
    end

    -- ✅ BETTER VIEW
    if F.BetterView_Tog and F.BetterView_Tog.CurrentValue then
        P.BetterView = true
        toggleBetterView(true)
    end

    -- ✅ NO PLAYER COLLISION
    if F.NoCol_F and F.NoCol_F.CurrentValue then
        getgenv().NoCollisionPlayer = true
        if not getgenv().CollisionLoopStarted then
            getgenv().CollisionLoopStarted = true
            task.spawn(function()
                while true do
                    if getgenv().NoCollisionPlayer then
                        local myChar = LocalPlayer.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                                if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if otherRoot then
                                        local dist = (myRoot.Position - otherRoot.Position).Magnitude
                                        for _, pName in ipairs(r6Parts) do
                                            local p = otherPlayer.Character:FindFirstChild(pName)
                                            if p and p:IsA("BasePart") then
                                                if dist <= 17 then
                                                    p.CanCollide = false
                                                    p.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
                                                else
                                                    p.CanCollide = true
                                                    p.CustomPhysicalProperties = nil
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    else
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                for _, pName in ipairs(r6Parts) do
                                    local part = p.Character:FindFirstChild(pName)
                                    if part then part.CanCollide = true end
                                end
                            end
                        end
                    end
                    task.wait(0.060)
                end
            end)
        end
    end

    local isPCOn = F.EmoteMenu_Toggle_PC and F.EmoteMenu_Toggle_PC.CurrentValue
    local isMobileOn = F.EmoteMenu_Toggle_Mobile and F.EmoteMenu_Toggle_Mobile.CurrentValue

    if isPCOn or isMobileOn then
        getgenv().EmoteMenuEnabled = true
        task.spawn(function()
            while getgenv().EmoteMenuEnabled do
                task.wait(0.5)
                local ok, Emote = pcall(function()
                    return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
                end)
                if ok and Emote then
                    Emote.Visible = true
                    for _, child in pairs(Emote:GetChildren()) do
                        if child:IsA("GuiObject") then child.Visible = false end
                    end
                end
            end
        end)
        task.spawn(function()
            task.wait(1)
            local oldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("OurEmoteGui")
            if oldGui then oldGui:Destroy() end
            local ok, originalEmote = pcall(function()
                return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
            end)
            if not ok or not originalEmote then return end
            local cloned = originalEmote:Clone()
            for _, child in pairs(cloned:GetChildren()) do
                if child:IsA("GuiObject") then child.Visible = true end
            end
            local ourGui = Instance.new("ScreenGui")
            ourGui.Name = "EmoteGui"
            ourGui.ResetOnSpawn = false
            ourGui.Parent = game.Players.LocalPlayer.PlayerGui
            cloned.Parent = ourGui
            cloned.Visible = false
            getgenv().OurEmoteClone = cloned
            for _, child in pairs(cloned:GetChildren()) do
                if child:IsA("GuiObject") then
                    local btn = child:FindFirstChildOfClass("TextButton") or child:FindFirstChildOfClass("ImageButton")
                    if btn then
                        btn.MouseButton1Click:Connect(function() PlayEmote(child.Name) end)
                    end
                    if child:IsA("TextButton") or child:IsA("ImageButton") then
                        child.MouseButton1Click:Connect(function() PlayEmote(child.Name) end)
                    end
                end
            end
            if not getgenv().EmoteHKeyConnected then
                getgenv().EmoteHKeyConnected = true
                game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
                    if not gpe and input.KeyCode == Enum.KeyCode.H then
                        if getgenv().EmoteMenuEnabled then
                            if getgenv().OurEmoteClone then
                                getgenv().OurEmoteClone.Visible = not getgenv().OurEmoteClone.Visible
                            end
                        else
                            local ok2, Emote = pcall(function()
                                return game.Players.LocalPlayer.PlayerGui.Interface.HUD.Emote
                            end)
                            if ok2 and Emote then
                                Emote.Visible = not Emote.Visible
                                for _, child in pairs(Emote:GetChildren()) do
                                    if child:IsA("GuiObject") then child.Visible = Emote.Visible end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end

    Rayfield:Notify({Title = "Quasar Hub", Content = "Configuration Loaded ✅", Duration = 3})
    task.wait(2)
    getgenv().__HB_RUNNING = false
    getgenv().HealthBarRunning = false
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/RiXNNN/Aurora-Hub/refs/heads/main/HealthBars.lua"))()
        end)
    end)
end)

AF:CreateSection("Auto Farm Ores")

AF:CreateDropdown({
   Name = "Select Ore..",
   Options = {"Iron Ore", "Sun Ore"},
   CurrentOption = {"Sun Ore"},
   MultipleOptions = true,
   Callback = function(Option)
      _G.SelectedMineral = Option
      _G.CurrentTarget = nil 
   end,
})

AF:CreateToggle({
   Name = "Auto Mine Ore",
   CurrentValue = false,
   Flag = "AutoMine_Toggle",
   Callback = function(Value)
      _G.AutoMineEnabled = Value
      
      local Char = LocalPlayer.Character
      local Root = Char and Char:FindFirstChild("HumanoidRootPart")
      
      if not Value then
          _G.CurrentTarget = nil
          if Root then 
              Root.Anchored = false 
          end
      end
   end,
})
AF:CreateSection("Auto Farm Mobs")
local NPCDropdown = AF:CreateDropdown({
    Name = "Select Mob(s) ...",
    Options = {"GenericSlayer", "GenericOni"},
    CurrentOption = {},
    MultipleOptions = true,
    Callback = function(Options)
        P.SelectedNPCs = Options
    end,
})

task.spawn(function()
    while true do
        if not P.AutoFarmNPC then
            local currentNames = {}
            local hasNewName = false
            
            for _, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Health") and not game.Players:GetPlayerFromCharacter(v) then
                    if not table.find(currentNames, v.Name) then
                        table.insert(currentNames, v.Name)
                        if not table.find(LastDetectedNames, v.Name) then
                            hasNewName = true
                        end
                    end
                end
            end
            
            if hasNewName then
                LastDetectedNames = currentNames
                table.sort(LastDetectedNames)
                
                NPCDropdown:Refresh(LastDetectedNames, true) 
            end
        end
        
        task.wait(7)
    end
end)

AF:CreateToggle({
    Name = "Auto Farm NPC",
    CurrentValue = false,
    Flag = "AutoFarmNPC_Tog",
    Callback = function(Value)
        P.AutoFarmNPC = Value
        local Hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if not Value then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
            if Hum then 
                Hum.AutoRotate = true 
                Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end,
})

AF:CreateToggle({
    Name = "Use Auto Skills With Auto Farm",
    CurrentValue = false,
    Flag = "AutoSkills_Tog",
    Callback = function(Value)
        P.AutoSkillsEnabled = Value
    end,
})

AF:CreateSection("U CAN CHOOSE MULTIPLE")
AF:CreateDropdown({
    Name = "Select Skills to Use",
    Options = {"Skill 1", "Skill 2", "Skill 3", "Skill 4", "Skill 5", "Skill 6", "Skill 7", "Skill T", "Skill Y"},
    CurrentOption = {},
    MultipleOptions = true,
    Callback = function(Options)
        P.SelectedSkills = Options
    end,
})

AF:CreateDropdown({
    Name = "Farm Position",
    Options = {"Top", "Bottom", "Back"},
    CurrentOption = {"Bottom"},
    MultipleOptions = false,
    Callback = function(Option)
        local Choice = type(Option) == "table" and Option[1] or Option
        
        if Choice == "Top" then
            P.FarmDistanceX = 0
            P.FarmDistanceY = 6.5
            P.FarmDistanceZ = 0
        elseif Choice == "Bottom" then
            P.FarmDistanceX = 0
            P.FarmDistanceY = -6.5
            P.FarmDistanceZ = 0
        elseif Choice == "Back" then
            P.FarmDistanceX = 0
            P.FarmDistanceY = 0
            P.FarmDistanceZ = 6.5
        end
    end,
})

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    local pressedKey = input.KeyCode.Name
    local function tryFire(assignedKey, targetKey)
        if pressedKey == assignedKey then
            VIM:SendKeyEvent(true, targetKey, false, game)
            task.wait()
            VIM:SendKeyEvent(false, targetKey, false, game)
        end
    end
    tryFire(_G.S6_String, Enum.KeyCode.Six)
    tryFire(_G.S7_String, Enum.KeyCode.Seven)
    tryFire(_G.ST_String, Enum.KeyCode.T)
    tryFire(_G.SY_String, Enum.KeyCode.Y)
end)
