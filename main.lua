-- MAIN.LUA (Baganito5 Edition - Safe & Fixed)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

_G.AutoFarm = false

-- NPC Kereső függvény
local function getClosestNPC()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local target, dist = nil, math.huge
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; target = v end
        end
    end
    return target
end

-- A Farm logika
local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local char = game.Players.LocalPlayer.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distance = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                    
                    if distance > 7 then
                        -- Ha messze van, odamegyünk
                        if modules.tween then
                            modules.tween.To(npc.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0), 300)
                        end
                    else
                        -- Ha odaértünk, megállunk és ütünk
                        if modules.tween then modules.tween.Stop() end
                        if modules.combat then
                            modules.combat.attack(npc)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- UI
local Window = Rayfield:CreateWindow({ Name = "matrixakos", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm")

FarmTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then startFarm() else if modules.tween then modules.tween.Stop() end end
   end,
})
