Tab:CreateToggle({
   Name = "Zero-Lag Ghost Mode",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().NoCollisionPlayer = Value
      if Value then
          -- One-time force update for everyone currently in game
          for _, player in ipairs(Players:GetPlayers()) do
              setCharacterGhost(player.Character)
          end
      else
          -- Reset everyone to Default
          for _, player in ipairs(Players:GetPlayers()) do
              if player.Character then
                  for _, part in ipairs(player.Character:GetChildren()) do
                      if part:IsA("BasePart") then part.CollisionGroup = "Default" end
                  end
              end
          end
      end
   end,
})
