-- MAIN.LUA (Final Balanced Version)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "Bloom",
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- (Itt a getClosestNPC függvény, amit korábban használtunk)

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc and modules.tween and modules.combat then
                local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                if (hrp.Position - npc.HumanoidRootPart.Position).Magnitude > 12 then
                    modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0), 300)
                else
                    modules.tween.Stop()
                    modules.combat.attack(npc)
                end
            end
            task.wait(0.1)
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Auto Farm",
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
