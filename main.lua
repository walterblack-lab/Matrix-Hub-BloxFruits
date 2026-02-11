-- MAIN.LUA (Matrix Hub - Framework Integrated)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | PRO",
   LoadingTitle = "Matrix Hub Loading...",
   LoadingSubtitle = "by WalterBlack",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

-- Spy biztonságos inicializálása [cite: 2026-02-10]
local logLabel = SpyTab:CreateLabel("Status: Systems Standby")
if modules and modules.spy then
    modules.spy.init(logLabel)
    modules.spy.log("Framework Spy Connected")
end

_G.AutoFarm = false
_G.SelectedWeapon = "Melee"
local currentTarget = nil

-- Célpont keresés logikája [cite: 2026-02-10]
local function getClosestNPC()
    if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
        return currentTarget
    end
    local target, dist = nil, math.huge
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local d = (enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; target = enemy end
            end
        end
    end
    currentTarget = target
    return target
end

-- Fő Farm Hurok [cite: 2026-02-10]
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                local myHrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local targetHrp = npc.HumanoidRootPart
                local distance = (myHrp.Position - targetHrp.Position).Magnitude
                
                -- Karakter irányba állítása az ütéshez [cite: 2026-02-10]
                myHrp.CFrame = CFrame.lookAt(myHrp.Position, Vector3.new(targetHrp.Position.X, myHrp.Position.Y, targetHrp.Position.Z))

                if distance > 4 then
                    if modules.spy then modules.spy.log("Approaching: " .. npc.Name) end
                    -- Távolság tartása (kb. 2.8 egység, hogy a Framework elérje) [cite: 2026-02-10]
                    modules.tween.To(targetHrp.CFrame * CFrame.new(0, 0, 2.8), 300)
                else
                    modules.tween.Stop()
                    -- TÁMADÁS: Framework hívás hibakezeléssel [cite: 2026-02-10]
                    local success, err = pcall(function()
                        modules.combat.attack(npc, _G.SelectedWeapon)
                    end)
                    
                    if success then
                        if modules.spy then modules.spy.log("Framework Attack: Active") end
                    else
                        if modules.spy then modules.spy.log("Combat Error: " .. tostring(err)) end
                    end
                end
            else
                if modules.spy then modules.spy.log("Searching for Targets...") end
                currentTarget = nil
            end
            task.wait(0.01) -- Extra gyors ciklus a folyamatos ütésért [cite: 2026-02-10]
        end
    end)
end

-- UI Interakciók [cite: 2026-02-09, 2026-02-10]
FarmTab:CreateDropdown({
   Name = "Weapon Type",
   Options = {"Melee", "Sword", "Blox Fruit"},
   CurrentOption = {"Melee"},
   Callback = function(Option) _G.SelectedWeapon = Option[1] end,
})

FarmTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then 
          startFarm() 
      else 
          if modules.tween then modules.tween.Stop() end
          if modules.spy then modules.spy.log("Farm Paused") end
      end
   end,
})

SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      if modules.tween then modules.tween.Stop() end
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})
