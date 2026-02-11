-- COMBAT MODULE (Pro Final - Weapon Handler Only) [cite: 2026-02-11]
local combat = {}
local lp = game.Players.LocalPlayer

-- Ez a függvény felel kizárólag a fegyver kezeléséért [cite: 2026-02-11]
function combat.attack(targetNpc)
    local char = lp.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    
    -- A SCAN alapján fixen a 'Combat' nevet használjuk, nincs több találgatás [cite: 2026-02-11]
    local tool = char:FindFirstChild("Combat")
    
    -- Ha nincs a kézben, elovesszük a táskából
    if not tool then
        local bpTool = lp.Backpack:FindFirstChild("Combat")
        if bpTool then 
            char.Humanoid:EquipTool(bpTool)
        end
    end
    
    -- Megjegyzés: Az ütés (Activate/FireServer) átkerült a main.lua-ba 
    -- a Fast Attack (debug.getupvalues) logika mellé a maximális sebességért. [cite: 2026-02-11]
end

return combat
