local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "AmberGlow",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- FEGYVER KEZELÉS
local function equipAndAttack()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    
    -- 1. Fegyver kézbevétele, ha nincs ott semmi
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        tool = p.Backpack:FindFirstChild("Combat") or p.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            char.Humanoid:EquipTool(tool)
        end
    end
    
    -- 2. KÖZVETLEN AKTIVÁLÁS (Ez helyettesíti a kattintást)
    if tool then
        tool:Activate() -- Meghívja a fegyver saját támadó funkcióját
    end
end

FarmTab:CreateToggle({
   Name = "Auto Farm (Starter Island)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         task.spawn(function()
            while _G.AutoFarm do
               pcall(function()
                  local lp = game.Players.LocalPlayer
                  local hrp = lp.Character.HumanoidRootPart
                  
                  -- NPC keresés
                  local target = nil
                  local dist = math.huge
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     -- Pozíció fixálása (6 méter magasban, hogy ne pattogj)
                     local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                     
                     if (hrp.Position - targetPos.p).Magnitude > 8 then
                        Modules.Tween.To(targetPos, 300)
                     else
                        -- MEGÁLLÍTÁS ÉS TÁMADÁS
                        hrp.CFrame = targetPos
                        hrp.Velocity = Vector3.new(0,0,0)
                        
                        equipAndAttack() -- Itt hívjuk meg az aktiválást
                        Modules.Net.Remotes.Attack:FireServer() -- Plusz a hálózati csomag
                     end
                  end
               end)
               task.wait(0.05) -- Gyors ciklus az ütésekhez
            end
         end)
      end
   end,
})

-- System Tab
local SystemTab = Window:CreateTab("System", 4483362458)
SystemTab:CreateButton({
   Name = "Destroy Script (Unload)",
   Callback = function()
      _G.AutoFarm = false
      task.wait(0.2)
      Rayfield:Destroy()
   end,
})
