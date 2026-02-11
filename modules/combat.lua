-- COMBAT MODULE (Blox Fruits Damage Fix)
local combat = {}

function combat.attack(targetNpc, weaponType)
    local char = game.Players.LocalPlayer.Character
    local backpack = game.Players.LocalPlayer.Backpack
    if not char or not targetNpc or not targetNpc:FindFirstChild("HumanoidRootPart") then return end
    
    -- Auto-Equip
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        local bpTool = backpack:FindFirstChild(weaponType) or backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetPos = targetNpc.HumanoidRootPart.Position

    -- Pontos célzás (LookAt)
    hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))

    if tool then
        tool:Activate() -- Fizikai animáció
        
        -- BLOX FRUITS SEBZÉS FIX: Meghívjuk a játék belső eseményét
        -- Ez az, ami ténylegesen levonja a HP-t az NPC-től
        local net = _G.Matrix_Modules.net
        local combatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("RigControllerEvent", true)
        
        if combatRemote then
            combatRemote:FireServer("WeaponClick")
        end
    end
end

return combat
