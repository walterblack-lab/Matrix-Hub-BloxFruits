-- MAIN.LUA (Precíziós Célpont Választó)
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
    -- Ha van rögzített célpont és még él, maradunk rajta
    if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
        return currentTarget
    end

    local target, dist = nil, math.huge
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    
    if enemiesFolder then
        -- Végigfésüljük a mappát a valódi NPC-kért
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            -- Ellenőrizzük, hogy valódi karakter-e (van Humanoid és RootPart)
            local humanoid = enemy:FindFirstChild("Humanoid")
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            
            if humanoid and hrp and humanoid.Health > 0 then
                local d = (hrp.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    target = enemy
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
            
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                local myHrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local targetHrp = npc.HumanoidRootPart
                local distance = (myHrp.Position - targetHrp.Position).Magnitude
                
                if distance > 5 then
                    modules.spy.log("Teleporting to NPC: " .. npc.Name)
                    -- Teleport az NPC fölé, hogy ne akadjunk el
                    modules.tween.To(targetHrp.CFrame * CFrame.new(0, 5, 0), 300)
                else
                    modules.spy.log("Target reached! Attacking...")
                    modules.tween.Stop()
                    modules.combat.attack(npc, _G.SelectedWeapon)
                end
            else
                modules.spy.log("Waiting for NPC to spawn...")
                currentTarget = nil
            end
            task.wait(0.1)
        end
    end)
end

-- UI Beállítások
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
