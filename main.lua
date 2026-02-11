-- MAIN.LUA (Matrix Hub - Manual-Style Distance Fix)
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

local logLabel = SpyTab:CreateLabel("Status: Ready")
if modules and modules.spy then modules.spy.init(logLabel) end

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
                
                -- Karakter NPC felé fordítása (hogy az ütés iránya jó legyen)
                myHrp.CFrame = CFrame.lookAt(myHrp.Position, Vector3.new(targetHrp.Position.X, myHrp.Position.Y, targetHrp.Position.Z))

                if distance > 4 then
                    if modules.spy then modules.spy.log("Approaching: " .. npc.Name) end
                    -- Távolság tartása: 2.5 egységre állunk meg tőle
                    modules.tween.To(targetHrp.CFrame * CFrame.new(0, 0, 2.5), 300)
                else
                    -- Megállunk és ütjük
                    modules.tween.Stop()
                    if modules.spy then modules.spy.log("In Range: Attacking...") end
                    modules.combat.attack(npc, _G.SelectedWeapon)
                end
            else
                currentTarget = nil
            end
            task.wait(0.05)
        end
    end)
end

-- UI elemek (Dropdown, Toggle, Unload) [cite: 2026-02-09, 2026-02-10]
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
      if Value then startFarm() else if modules.tween then modules.tween.Stop() end end
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
