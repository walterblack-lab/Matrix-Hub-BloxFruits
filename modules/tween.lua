-- TWEEN MODULE (FIXED & STABLE)
local tween = {}
local TweenService = game:GetService("TweenService")
local currentTween = nil 

function tween.To(targetCFrame, speed)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    
    -- JAVÍTÁS: Biztonságos törlés külön sorokban
    if currentTween ~= nil then 
        currentTween:Cancel() 
        currentTween:Destroy() 
        currentTween = nil
    end
    
    -- Új tween létrehozása
    local info = TweenInfo.new(dist/speed, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
    currentTween:Play()
end

function tween.Stop()
    -- JAVÍTÁS: Szigorú ellenőrzés a nil értékre
    if typeof(currentTween) == "Instance" then 
        currentTween:Cancel()
        currentTween:Destroy()
    end
    currentTween = nil
end

return tween
