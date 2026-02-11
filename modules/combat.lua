-- COMBAT MODULE (Final Stable Attack)
local combat = {}

function combat.attack(targetNpc, weaponType)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char or not targetNpc then return end
    
    -- Auto-Equip (Backpack-ből kézbe)
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        local bpTool = lp.Backpack:FindFirstChild(weaponType) or lp.Backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    -- Célzás és Támadás
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        -- NPC felé nézés
        local targetPos = targetNpc.HumanoidRootPart.Position
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        
        -- Fizikai és szerver oldali ütés kombinálva
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RigControllerEvent", true)
        if remote then
            remote:FireServer("WeaponClick")
        end
        
        if tool then 
            tool:Activate() 
        end
    end
end

return combat
