-- MAIN.LUA (Baganito5 Edition - Target Lock & Unload)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules
_G.AutoFarm = false
_G.SelectedWeapon = "Melee"

local currentTarget = nil -- Célpont rögzítése

local Window = Rayfield:CreateWindow({ Name = "MATRIX HUB | PRO", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm")
local SettingsTab = Window:CreateTab("Settings")

-- Fegyver választó
FarmTab:CreateDropdown({
   Name = "Weapon Type",
   Options = {"Melee", "Sword", "Blox Fruit"},
   CurrentOption = {"Melee"},
   MultipleOptions = false,
   Callback = function(Option) _G.SelectedWeapon = Option[1] end,
})

local function getClosestNPC()
    -- Ha már van célpontunk és él, ne keressünk újat
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
    currentTarget = target -- Rögzítjük az új célpontot
    return target
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                local dist = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                
                -- Közelebbi megállás (4 egység), hogy az ököl biztosan elérje
                if dist > 4 then
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300)
                else
                    modules.tween.Stop()
                    modules.combat.attack(npc, _G.SelectedWeapon)
                end
            else
                if modules.tween then modules.tween.Stop() end
            end
            task.wait(0.05)
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else if modules.tween then modules.tween.Stop() end end
   end,
})

-- UNLOAD (Soha nem felejtjük el!)
SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      if modules.tween then modules.tween.Stop() end
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})
