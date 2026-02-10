local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- Biztonságos fegyver elővétel
local function equipWeapon()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    
    -- Ha már van valami a kezünkben, nem csinálunk semmit
    if char:FindFirstChildOfClass("Tool") then return end
    
    -- Megkeressük az 1-es sloton lévő fegyvert (Combat/Fist)
    for _, tool in pairs(p.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            char.Humanoid:EquipTool(tool)
            break
        end
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
               local success, err = pcall(function()
                  local target = nil
                  local dist = math.huge
                  
                  -- NPC keresés
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        local d = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     equipWeapon()
                     -- POZÍCIÓ: 5 egységgel az NPC FÖLÉ megyünk, hogy ne lökjön el
                     local farmPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                     
                     -- Csak akkor teleportálunk, ha messze vagyunk, hogy ne rángasson
                     if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - farmPos.p).Magnitude > 3 then
                        Modules.Tween.To(farmPos, 300)
                     end
                     
                     -- TÁMADÁS: Gyors egymásutánban többször
                     Modules.Net.Remotes.Attack:FireServer()
                  end
               end)
               if not success then warn("Farm Error: " .. err) end
               task.wait(0.15) -- Kicsit lassabb ciklus a stabilitásért
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
