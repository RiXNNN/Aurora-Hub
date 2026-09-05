local EmoteID = "9913135939"

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local animator = hum:FindFirstChildOfClass("Animator")

local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. EmoteID

local track = animator:LoadAnimation(anim)
track.Priority = Enum.AnimationPriority.Action
track:Play()
