local Net = {}
local RS = game:GetService("ReplicatedStorage")

-- Atombiztos elérés
local function getRemote()
    return RS:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
end

Net.Remotes = {
    Attack = getRemote()
}

return Net
