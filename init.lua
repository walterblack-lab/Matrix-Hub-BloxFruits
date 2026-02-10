-- INIT.LUA (A motor)
_G.Matrix_Modules = {}

local function loadModule(name)
    local url = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/modules/" .. name .. ".lua?cache=" .. math.random(1, 999)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then 
        _G.Matrix_Modules[name] = result 
        print("[MATRIX] " .. name .. " betöltve.")
    end
end

loadModule("tween")
loadModule("net")
loadModule("combat")

task.wait(0.5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/main.lua?cache=" .. math.random(1, 999)))()
