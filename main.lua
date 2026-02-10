local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Fegyver és Ütés kényszerítése
local function startPunching()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChild("Combat") or p.Backpack:FindFirstChildOfClass("Tool")
    if tool and tool.Parent ~= char then 
        char.Humanoid:EquipTool(tool) 
    end
    
    if tool then
        tool:Activate()
        -- Közvetlen hívás a te net modulodból kinyerve
        Modules.Net.Remotes.Attack:FireServer(0) 
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
                  
                  local target = nil
                  local dist = math.huge
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     -- MÓDOSÍTOTT POZÍCIÓ: 5 méterrel az NPC elé, nem a fejére!
                     local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                     
                     if (hrp.Position - targetPos.p).Magnitude > 7 then
                        Modules.Tween.To(targetPos, 300)
                     else
                        -- MEGÁLLÍTÁS: Ez a kulcs! Ha nem mozogsz, a szerver engedi a sebzést.
                        Modules.Tween.Stop()
                        hrp.CFrame = targetPos
                        hrp.Velocity = Vector3.new(0,0,0)
                        
                        startPunching()
                     end
                  end
               end)
               task.wait(0.1) -- Hagyni kell időt a szervernek regisztrálni
            end
         end)
      end
   end,
})

local SystemTab = Window:CreateTab("System", 4483362458)
SystemTab:CreateButton({
   Name = "Destroy Script (Unload)",
   Callback = function()
      _G.AutoFarm = false
      task.wait(0.2)
      Rayfield:Destroy()
   end,
})
