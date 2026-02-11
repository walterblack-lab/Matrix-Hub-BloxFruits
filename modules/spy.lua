-- SPY MODULE (Matrix Hub - Logger)
local spy = {}
spy.label = nil

function spy.init(labelElement)
    spy.label = labelElement
    spy.log("Spy System Active")
end

function spy.log(text)
    local timestamp = os.date("%H:%M:%S")
    if spy.label then
        spy.label:Set("Status: " .. text)
    end
    print("[MATRIX SPY " .. timestamp .. "]: " .. text)
end

return spy
