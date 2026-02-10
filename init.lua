-- MATRIX HUB LOADER
-- Description: Modular loader for the Blox Fruits project.

local github = "https://raw.githubusercontent.com/FELHASZNALONEVED/Matrix-Hub-BloxFruits/main/"

_G.Matrix_Modules = {
    Net = loadstring(game:HttpGet(github .. "modules/net.lua"))(),
    Tween = loadstring(game:HttpGet(github .. "modules/tween.lua"))(),
    Farm = loadstring(game:HttpGet(github .. "modules/farm.lua"))()
}

loadstring(game:HttpGet(github .. "main.lua"))()
