local Net = {}
local RS = game:GetService("ReplicatedStorage")

-- Biztonságos távoli esemény kereső
local function getRemote(path)
    local obj = RS
    for _, name in pairs(path:split("/")) do
        obj = obj:WaitForChild(name, 5)
        if not obj then return nil end
    end
    return obj
end

Net.Remotes = {
    Attack = getRemote("Modules/Net/RE/RegisterAttack"),
    Quest = getRemote("Modules/Net/RF/StartSubclassQuest")
}

return Net
