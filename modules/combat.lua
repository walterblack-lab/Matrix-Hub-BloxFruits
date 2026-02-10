-- COMBAT MODULE (Matrix Hub - RAM Optimized)
local combat = {}

function combat.attack(targetNpc)
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    local npcHrp = targetNpc and targetNpc:FindFirstChild("HumanoidRootPart")
    
    if hrp and humanoid and npcHrp then
        -- RAM/CPU optimalizálás: Csak akkor váltunk állapotot, ha kell
        if humanoid:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics then
            humanoid:ChangeState(11)
        end

        -- Irányba állítás és stabilizálás
        hrp.CFrame = CFrame.lookAt(hrp.Position, npcHrp.Position)
        hrp.Velocity = Vector3.new(0, 0, 0)

        -- Támadás
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
            local net = _G.Matrix_Modules.net
            if net and net.Remotes and net.Remotes.Attack then
                net.Remotes.Attack:FireServer(0)
            end
        end
    end
end

return combat
