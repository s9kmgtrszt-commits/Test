-- Kill All
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end
