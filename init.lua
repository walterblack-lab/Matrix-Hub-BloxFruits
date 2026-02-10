-- Matrix Hub Loader V7.1
local base = "https://raw.githubusercontent.com/walterblack-lab/matrixv2/main/"
local function get(f) return game:HttpGet(base .. f .. "?cb=" .. math.random(1,999)) end

_G.Matrix_Modules = {
    Net = loadstring(get("modules/net.lua"))(),
    Tween = loadstring(get("modules/tween.lua"))()
}
loadstring(get("main.lua"))()
