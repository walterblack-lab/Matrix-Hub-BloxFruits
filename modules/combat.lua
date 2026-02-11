-- COMBAT MODULE (Matrix Hub - Auto-Equip Edition)
local combat = {}

function combat.attack(targetNpc, weaponType)
    local char = game.Players.LocalPlayer.Character
    local backpack = game.Players.LocalPlayer.Backpack
    if not char or not targetNpc then return end
    
    -- Auto-Equip logika
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        -- Megkeressük a hátizsákban a megfelelő típusú eszközt
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") and (v.ToolTip == weaponType or weaponType == "Any") then
                char.Humanoid:EquipTool(v)
                break
            end
        end
    end

    -- Támadás és irányzék
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetNpc.HumanoidRootPart.Position
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then
            currentTool:Activate()
        end
    end
end

return combat
