local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules
_G.AutoFarm = false

local Window = Rayfield:CreateWindow({ Name = "MATRIX HUB | PRO", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm")
local SettingsTab = Window:CreateTab("Settings") -- Itt lesz az Unload

local function getClosestNPC()
    local target, dist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies") or workspace
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; target = v end
        end
    end
    return target
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                -- Nagyon közel megyünk (5 egység), hogy sebezzen
                if dist > 5 then
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300)
                else
                    modules.tween.Stop()
                    modules.combat.attack(npc)
                end
            end
            task.wait(0.05)
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else modules.tween.Stop() end
   end,
})

-- UNLOAD FUNKCIÓ (VISSZATÉRT ÉS JEGYEZTEM)
SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      modules.tween.Stop()
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
      print("[MATRIX] Unloaded.")
   end,
})
