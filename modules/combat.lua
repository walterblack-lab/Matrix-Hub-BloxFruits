-- COMBAT MODULE (Final Fix)
local combat = {}

function combat.attack(targetNpc, weaponType)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local spy = _G.Matrix_Modules.spy -- Spy elérése
    
    if not char or not targetNpc then return end
    
    -- Auto-Equip
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool and tool.ToolTip ~= weaponType) then
        if spy then spy.log("Equipping: " .. weaponType) end
        local bpTool = lp.Backpack:FindFirstChild(weaponType) or lp.Backpack:FindFirstChildOfClass("Tool")
        if bpTool then char.Humanoid:EquipTool(bpTool) end
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and targetNpc:FindFirstChild("HumanoidRootPart") then
        -- Pontos célzás
        local targetPos = targetNpc.HumanoidRootPart.Position
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        
        -- ÜTÉS KÉNYSZERÍTÉSE (Mivel manuálisan működik neked, ezt a kettőt kombináljuk)
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
