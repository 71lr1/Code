local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local id = "rbxassestid://12307583853"

for _, v in ipairs(c:GetDescendants()) do
    if  v:IsA("BasePart")
end