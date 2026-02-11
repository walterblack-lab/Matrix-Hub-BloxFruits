-- MAIN.LUA (Matrix Hub - Final Bugfix)
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

-- Spy biztonságos indítása
local logLabel = SpyTab:CreateLabel("Status: Ready")
if modules and modules.spy then
    modules.spy.init(logLabel)
end

_G.AutoFarm = false
_G.SelectedWeapon = "Melee"
local currentTarget = nil

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

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                local myHrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local targetHrp = npc.HumanoidRootPart
                local distance = (myHrp.Position - targetHrp.Position).Magnitude
                
                if distance > 3.5 then
                    if modules.spy then modules.spy.log("Teleporting to: " .. npc.Name) end
                    modules.tween.To(targetHrp.CFrame * CFrame.new(0, 0, 1.5), 300)
                else
                    -- ÜTÉS FÁZIS
                    modules.tween.Stop()
                    if modules.spy then modules.spy.log("Attacking: " .. npc.Name) end
                    
                    -- Itt hívjuk a javított combatot
                    modules.combat.attack(npc, _G.SelectedWeapon)
                    task.wait(0.05)
                end
            else
                currentTarget = nil
            end
            task.wait(0.1)
        end
    end)
end

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
      if Value then startFarm() else modules.tween.Stop() end
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
