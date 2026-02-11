-- TWEEN MODULE (Matrix Hub - Stable & RAM Optimized)
local tween = {}

local TweenService = game:GetService("TweenService")
local lp = game.Players.LocalPlayer
local currentTween = nil -- Egy változóban tároljuk a mozgást

function tween.To(targetCFrame, speed)
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed
    
    -- JAVÍTÁS: Csak akkor törlünk, ha van mit (így nem dob hibát az elején)
    if currentTween ~= nil then
        currentTween:Cancel()
        currentTween:Destroy() -- RAM felszabadítása
        currentTween = nil
    end
    
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    -- Új tween objektum létrehozása
    currentTween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
    
    -- Automatikus takarítás a mozgás végén
    currentTween.Completed:Connect(function()
        if currentTween then
            currentTween:Destroy()
            currentTween = nil
        end
    end)
    
    currentTween:Play()
end

function tween.Stop()
    -- Biztonságos megállítás: ellenőrizzük, létezik-e a tween
    if currentTween ~= nil then
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
end

return tween
