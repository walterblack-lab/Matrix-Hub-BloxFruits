-- MAIN.LUA (Final Fix - Target Lock & Unload)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules
_G.AutoFarm = false
_G.SelectedWeapon = "Melee"

local currentTarget = nil -- Rögzített célpont

local Window = Rayfield:CreateWindow({ Name = "MATRIX HUB | PRO", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm")
local SettingsTab = Window:CreateTab("Settings")

FarmTab:CreateDropdown({
   Name = "Weapon Type",
   Options = {"Melee", "Sword", "Blox Fruit"},
   CurrentOption = {"Melee"},
   MultipleOptions = false,
   Callback = function(Option) _G.SelectedWeapon = Option[1] end,
})

local function getClosestNPC()
    -- Ha van célpont és él, maradunk rajta (Target Lock)
    if currentTarget and currentTarget:FindFirstChild("Humanoid") and currentTarget.Humanoid.Health > 0 then
        return currentTarget
    end
    
    local target, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies") or workspace
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; target = v end
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
                local dist = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                
                -- JAVÍTÁS: Közelebb (3.5) és alacsonyabbra (magasság: 2) megyünk
                if dist > 3.5 then
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0), 300)
                else
                    modules.tween.Stop()
                    modules.combat.attack(npc, _G.SelectedWeapon)
                end
            end
            task.wait(0.02) -- Gyorsabb frissítés a simább mozgásért
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else modules.tween.Stop() end
   end,
})

-- UNLOAD GOMB (Fixálva, nem fog eltűnni!)
SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      modules.tween.Stop()
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})
