-- MATRIX HUB V6.2 - MAIN UI
-- Description: DarkBlue theme with modular integration.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Net = _G.Matrix_Modules.Net
local Tween = _G.Matrix_Modules.Tween

_G.AutoFarm = false
_G.FastAttack = true

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   LoadingTitle = "Dark Edition v6.2",
   Theme = "DarkBlue", -- Sötétkék téma
   ConfigurationSaving = { Enabled = true, Folder = "MatrixHub" }
})

local MainTab = Window:CreateTab("Farming", 4483362458)

-- GYORSBILLENTYŰ A REJTÉSHEZ
MainTab:CreateKeybind({
   Name = "Minimize UI",
   CurrentKeybind = "RightShift",
   HoldToInteract = false,
   Callback = function() Rayfield:ToggleUI() end,
})

MainTab:CreateSection("Level Farm")

MainTab:CreateToggle({
   Name = "Auto Farm (Bandit Island)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               pcall(function()
                  -- 1. KERESÜNK EGY ÉLŐ BANDITÁT
                  local enemy = nil
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v.Name == "Bandit" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        enemy = v
                        break
                     end
                  end
                  
                  if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                     -- 2. REPÜLÜNK HOZZÁ (A tween moduloddal)
                     Tween.To(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 250)
                     
                     -- 3. ÜTÉS (A net moduloddal)
                     if _G.FastAttack then
                        Net.Remotes.Attack:FireServer()
                     end
                  end
               end)
               task.wait(0.1)
            end
         end)
      end
   end,
})

local SettingsTab = Window:CreateTab("System", 4483362458)

SettingsTab:CreateButton({
   Name = "Stop Everything & Unload",
   Callback = function()
      _G.AutoFarm = false
      Rayfield:Destroy()
   end,
})
