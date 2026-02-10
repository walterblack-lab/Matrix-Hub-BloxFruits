local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Main Farm", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Farm + Quest (Bandit)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      task.spawn(function()
         while _G.AutoFarm do
            pcall(function()
               -- 1. KÜLDETÉS ELLENŐRZÉSE
               local hasQuest = game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
               if not hasQuest then
                  -- Ha nincs quest, felvesszük (NPC-hez repülünk)
                  Modules.Tween.To(CFrame.new(1059, 15, 1546), 300) -- Bandit NPC helye
                  Modules.Net.Remotes.Quest:InvokeServer("StartQuest", "BanditQuest1", 1)
               else
                  -- 2. FARMOLÁS
                  local enemy = nil
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v.Humanoid.Health > 0 then
                        enemy = v; break
                     end
                  end
                  
                  if enemy then
                     Modules.Tween.To(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300)
                     Modules.Net.Remotes.Attack:FireServer()
                  end
               end
            end)
            task.wait(0.1)
         end
      end)
   end,
})
