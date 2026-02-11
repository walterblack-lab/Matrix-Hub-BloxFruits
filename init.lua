-- INIT.LUA (High-Speed & Safe Loader)
_G.Matrix_Modules = {}

local function loadModule(name)
    local url = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/" .. name .. ".lua?cache=" .. math.random(1, 999)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success and result then 
        _G.Matrix_Modules[name] = result 
        print("[MATRIX] " .. name .. " betöltve.")
        return true
    else
        warn("[MATRIX] Hiba a modul betöltésekor (" .. name .. "): " .. tostring(result))
        return false
    end
end

-- Szigorú sorrend a nil hibák ellen
local modulesToLoad = {"tween", "net", "combat"}
for _, mod in ipairs(modulesToLoad) do
    local loaded = false
    repeat
        loaded = loadModule(mod)
        if not loaded then task.wait(0.5) end 
    until loaded
end

print("[MATRIX] Minden modul kész. Fő szkript indítása...")
task.wait(0.1)
loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/main.lua?cache=" .. math.random(1, 999)))()
