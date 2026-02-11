-- TWEEN MODULE (Stable & RAM Optimized)
local tween = {}
local TweenService = game:GetService("TweenService")
local currentTween = nil 

function tween.To(targetCFrame, speed)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed
    
    if currentTween ~= nil then
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
    
    currentTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    currentTween.Completed:Connect(function()
        if currentTween then currentTween:Destroy() currentTween = nil end
    end)
    currentTween:Play()
end

function tween.Stop()
    if currentTween ~= nil then
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
end

return tween
