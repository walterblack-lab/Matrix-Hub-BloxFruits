-- INIT.LUA (Matrix Hub - Pro Safe Loader)
_G.Matrix_Modules = {}

local function loadModule(name)
    local url = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/" .. name .. ".lua?cache=" .. math.random(1, 9999)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success and result then
        _G.Matrix_Modules[name] = result
        print("[MATRIX] " .. name .. " betöltve és kész.")
        return true
    else
        warn("[MATRIX] Hiba a modulnál (" .. name .. "): " .. tostring(result))
        return false
    end
end

-- Sorrendben betöltjük és ellenőrizzük őket
local modulesToLoad = {"tween", "net", "combat"}
local allLoaded = true

for _, m in ipairs(modulesToLoad) do
    if not loadModule(m) then
        allLoaded = false
    end
end

if allLoaded then
    print("[MATRIX] Minden modul kész. Fő szkript indítása...")
    task.wait(1) -- Biztonsági szünet
    loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/main.lua?cache=" .. math.random(1, 9999)))()
else
    warn("[MATRIX] Kritikus hiba: A betöltés megszakadt!")
end
