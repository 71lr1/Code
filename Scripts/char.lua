local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local id = "rbxassetid://12307583853"

for _, v in ipairs(c:GetDescendants()) do

    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then

        for _, f in ipairs(Enum.NormalId:GetEnumItems()) do

            local d = Instance.new("Decal")
            d.Texture = id
            d.Face = f
            d.Parent = v
        end

    end

end