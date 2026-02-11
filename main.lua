-- MAIN.LUA (Matrix Hub - Stable Edition)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local modules = _G.Matrix_Modules

local Window = Rayfield:CreateWindow({ Name = "MATRIX HUB | PRO", Theme = "Bloom" })
local FarmTab = Window:CreateTab("Auto Farm") -- Visszahoztuk!
local SpyTab = Window:CreateTab("Debug Spy")
local SettingsTab = Window:CreateTab("Settings")

-- Spy inicializálása biztonságosan
local logLabel = SpyTab:CreateLabel("Status: Initializing...")
if modules and modules.spy then
    modules.spy.init(logLabel)
else
    warn("[MATRIX] Spy module not found in _G.Matrix_Modules")
end

_G.AutoFarm = false
_G.SelectedWeapon = "Melee"

-- UNLOAD GOMB (Fixálva, soha nem tűnik el)
SettingsTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      _G.AutoFarm = false
      if modules.tween then modules.tween.Stop() end
      Rayfield:Destroy()
      _G.Matrix_Modules = nil
   end,
})

FarmTab:CreateDropdown({
   Name = "Weapon Type",
   Options = {"Melee", "Sword", "Blox Fruit"},
   CurrentOption = {"Melee"},
   MultipleOptions = false,
   Callback = function(Option) _G.SelectedWeapon = Option[1] end,
})

FarmTab:CreateToggle({
   Name = "Start Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then 
          modules.spy.log("Farm Started")
          -- Itt hívd meg a farm függvényedet (startFarm)
      else 
          if modules.tween then modules.tween.Stop() end
          modules.spy.log("Farm Stopped")
      end
   end,
})
