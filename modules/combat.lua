-- modules/combat.lua
local Combat = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer

function Combat.Attack(target)
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool or not target:FindFirstChild("Humanoid") then return end

    -- Correct sequence for Blox Fruits damage registration
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local validator = remotes and remotes:FindFirstChild("Validator")
    local register = remotes and remotes:FindFirstChild("RegisterAttack")

    if validator and register then
        -- 1. Sync orientation
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
            LocalPlayer.Character.HumanoidRootPart.Position,
            target.HumanoidRootPart.Position
        )
        
        -- 2. Attack execution
        tool:Activate()
        validator:FireServer(0.1, tool.Name, target.Humanoid)
        register:FireServer(target.HumanoidRootPart)
    end
end

return Combat
