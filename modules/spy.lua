-- SPY MODULE (Matrix Hub - Logger)
local spy = {}
local logLabel = nil

-- Inicializáljuk a Spy-t a UI elemmel
function spy.init(labelElement)
    logLabel = labelElement
    spy.log("Spy System Active")
end

-- Üzenet küldése a menübe és a konzolba
function spy.log(text)
    local timestamp = os.date("%H:%M:%S")
    local formattedText = "[" .. timestamp .. "] " .. text
    
    if logLabel then
        logLabel:Set("Status: " .. text)
    end
    
    print("[MATRIX SPY] " .. formattedText)
end

return spy
