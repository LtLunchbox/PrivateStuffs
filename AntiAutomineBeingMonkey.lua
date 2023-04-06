local oreTypes = {
    {"Coal", "CoalOre"},
    {"Copper", "CopperOre"},
    {"Iron", "IronOre"},
    {"Zinc", "ZincOre"}
}

while wait(5) do
    for _, oreType in ipairs(oreTypes) do
        for _, Deposit in ipairs(game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits[oreType[1]]:GetChildren()) do
            local orePosition = Deposit[oreType[2]].Position
            local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

            if (orePosition - playerPosition).Magnitude < 7.5 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(playerPosition, Vector3.new(orePosition.X, playerPosition.Y, orePosition.Z))
            end
        end
    end
end