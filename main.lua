local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Modules = _G.Matrix_Modules

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- MEGBÍZHATÓ FEGYVER ELŐVÉTEL
local function equipWeapon()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if not char then return end
    
    -- Megnézzük, van-e már valami a kezünkben
    if char:FindFirstChildOfClass("Tool") then return end
    
    -- Ha nincs, kikeressük az öklöt (Combat) vagy bármilyen fegyvert
    local tool = p.Backpack:FindFirstChild("Combat") or p.Backpack:FindFirstChildOfClass("Tool")
    if tool then
        char.Humanoid:EquipTool(tool)
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
                  local target = nil
                  local dist = math.huge
                  local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                  
                  -- Legközelebbi NPC megkeresése
                  for _, v in pairs(workspace.Enemies:GetChildren()) do
                     if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < dist then dist = d; target = v end
                     end
                  end

                  if target then
                     equipWeapon()
                     local targetPos = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                     
                     -- JAVÍTÁS: Csak akkor teleportál, ha 10 méternél messzebb van!
                     -- Ez megakadályozza a rángatózást.
                     if (hrp.Position - targetPos.p).Magnitude > 10 then
                        Modules.Tween.To(targetPos, 300)
                        task.wait(0.5) -- Időt hagyunk a megérkezésre
                     else
                        -- Ha már ott vagyunk, csak fixáljuk a pozíciót és ÜTÜNK
                        hrp.CFrame = targetPos
                        Modules.Net.Remotes.Attack:FireServer()
                     end
                  end
               end)
               task.wait(0.1) -- Fontos szünet a stabilitáshoz
            end
         end)
      end
   end,
})

-- System Tab az Unloadhoz
local SystemTab = Window:CreateTab("System", 4483362458)
SystemTab:CreateButton({
   Name = "Destroy Script (Unload)",
   Callback = function()
      _G.AutoFarm = false
      task.wait(0.2)
      Rayfield:Destroy()
   end,
})
