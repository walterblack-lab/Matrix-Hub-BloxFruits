-- MAIN.LUA (Matrix Hub - Precise Target Fix)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

local Window = Rayfield:CreateWindow({ Name = "MATRIX HUB | PRO", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm")
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

local logLabel = SpyTab:CreateLabel("Status: Ready")
if modules.spy then modules.spy.init(logLabel) end

_G.AutoFarm = false
_G.SelectedWeapon = "Melee"
local currentTarget = nil

local function getClosestNPC()
    if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
        return currentTarget
    end

    local target, dist = nil, math.huge
    -- JAVÍTÁS: Megkeressük a valódi NPC-ket az Enemies mappában
    local enemyFolder = workspace:FindFirstChild("Enemies")
    if enemyFolder then
        for _, v in pairs(enemyFolder:GetChildren()) do
            -- Csak azt nézzük, aminek van élete és teste
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                local d = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then 
                    dist = d
                    target = v 
                end
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
            if npc then
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local targetHRP = npc:FindFirstChild("HumanoidRootPart")
                
                if targetHRP then
                    local dist = (hrp.Position - targetHRP.Position).Magnitude
                    
                    if dist > 5 then
                        modules.spy.log("Teleporting to: " .. npc.Name)
                        -- Teleport az NPC fölé 5 egységgel
                        modules.tween.To(targetHRP.CFrame * CFrame.new(0, 5, 0), 300)
                    else
                        modules.spy.log("Attacking: " .. npc.Name)
                        modules.tween.Stop()
                        modules.combat.attack(npc, _G.SelectedWeapon)
                    end
                end
            else
                modules.spy.log("No NPC found in range.")
            end
            task.wait(0.1)
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
      if Value then startFarm() else modules.tween.Stop() end
   end,
})

SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      modules.tween.Stop()
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})
