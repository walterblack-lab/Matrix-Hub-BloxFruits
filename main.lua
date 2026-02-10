--[[
    MATRIX HUB - JAVÍTOTT VERZIÓ (Baganito5)
    Fix: Case-sensitive folder names (modules)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- MODULOK BIZTONSÁGI BETÖLTÉSE (Kisbetűs 'modules' mappával)
if not _G.Matrix_Modules then
    _G.Matrix_Modules = {
        -- Itt is kisbetűsre javítva a path: /modules/
        tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/tween.lua"))(),
        net = loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/net.lua"))()
    }
end

local modules = _G.Matrix_Modules -- Kisbetűs változónév a konzisztencia miatt
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

_G.AutoFarm = false

local Window = Rayfield:CreateWindow({
   Name = "MATRIX HUB | BLOX FRUITS",
   Theme = "Bloom", 
   ConfigurationSaving = { Enabled = false }
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

local function getClosestNPC()
    local target = nil
    local dist = math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, v in pairs(enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local npc = getClosestNPC()
            if npc then
                local npcHrp = npc.HumanoidRootPart
                local targetPos = npcHrp.CFrame * CFrame.new(0, 5, 0)
                
                if (hrp.Position - targetPos.Position).Magnitude > 10 then
                    -- Javítva: modules.tween
                    modules.tween.To(targetPos, 300)
                else
                    modules.tween.Stop()
                    
                    char.Humanoid:ChangeState(11)
                    hrp.CFrame = CFrame.lookAt(hrp.Position, npcHrp.Position)
                    hrp.Velocity = Vector3.new(0,0,0)
                    
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                        -- Javítva: modules.net
                        if modules.net and modules.net.Remotes then
                            modules.net.Remotes.Attack:FireServer(0)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

FarmTab:CreateToggle({
   Name = "Auto Farm (Baganito5 Mode)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then 
         startFarm() 
      else 
         if modules.tween then modules.tween.Stop() end 
      end
   end,
})
