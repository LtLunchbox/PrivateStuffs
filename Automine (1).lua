local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Global = require(ReplicatedStorage.SharedModules.Global)
local Loot,Pathes,Running,WalkPoint = {
"Amethyst","CoalOre",
"CopperOre","Diamond",
"Emerald","GoldBar",
"GoldOre","IronOre",
"Limestone","Ruby",
"Sapphire","SilverOre",
"ZincOre"},{},false

local function UpdatePathes() Pathes = {}
    for Index,File in pairs(listfiles("Automine") or {}) do
        local PathTable = loadfile(File)()
        File = File:gsub("Automine\\","")
        File = File:gsub(".lua","")
        Pathes[File] = PathTable
    end
end

local function GetPathList() local PathList = {}
    if not isfolder("Automine") then makefolder("Automine") end
    for Index,File in pairs(listfiles("Automine") or {}) do
        File = File:gsub("Automine\\","")
        File = File:gsub(".lua","")
        PathList[Index] = {Name = File,Mode = "Button",
        Callback = UpdatePathes}
    end return PathList
end

local Bracket = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Bracket/main/BracketV32.lua"))()
local Window = Bracket:Window({Name = "The Wild West | Automine | AlexR32#0157",Color = Color3.fromRGB(145,140,100),
Position = UDim2.new(0.05,0,0.5,-248),Size = UDim2.new(0,296,0,296)})

local Main = Window:Tab({Name = "Main"})
Main:Toggle({Name = "Enabled",Side = "Left",Flag = "Automine/Enabled"})
local SelectedPath = Main:Dropdown({Name = "List",Side = "Right",
Flag = "Automine/Path",List = GetPathList()})

Main:Button({Name = "Update List",Side = "Right",Callback = function()
    local PathList = GetPathList()

    SelectedPath:Clear()
    SelectedPath:BulkAdd(PathList)
    SelectedPath:SetValue(#PathList > 0
    and {PathList[1].Name} or nil)
end})

--[[local function GetCharacterInfo()
    local Player = Global.PlayerCharacter
    local Character = Player.Character
    if not Character then return end
    local RootPart = Player.RootPart
    local Human = Player.Human
    return {Player,Character,RootPart,Human}
end

local function EquipPickaxe()
    for Index,Item in pairs(Global.PlayerData.InventoryContainer.Items) do
        if string.find(Item.Type,"Pickaxe") then
            Global.PlayerCharacter:EquipItem(Item)
            break
        end
    end
end]]

local function NewThreadLoop(Wait,Function)
    task.spawn(function()
        while task.wait(Wait) do
            local Success, Error = pcall(Function)
            if not Success then
                warn("thread error " .. Error)
            end
        end
    end)
end

local function WalkTo(Position)
    local Player = Global.PlayerCharacter
    local Character = Player.Character
    if not Character then return end
    local RootPart = Player.RootPart
    local Human = Player.Human

    Human:MoveTo(Position
    or RootPart.Position)
end

local function SetWalkPoint(Position)
    local Player = Global.PlayerCharacter
    local Character = Player.Character
    if not Character then return end
    local RootPart = Player.RootPart
    local Human = Player.Human

    WalkPoint = Position
    while task.wait() do
        if (Vector2.new(RootPart.Position.X,RootPart.Position.Z) - Vector2.new(Position.X,Position.Z)).Magnitude < 2 or not Running then
            break
        end
    end
end

local function GetNearestDeposit(Type)
    local Player = Global.PlayerCharacter
    local Character = Player.Character
    if not Character then return end
    local RootPart = Player.RootPart
    
    local OreDeposit = Workspace.WORKSPACE_Interactables.Mining.OreDeposits:FindFirstChild(Type)
    for Index,Deposit in pairs(OreDeposit:GetChildren()) do
        if (Deposit[Type.."Ore"].Position - RootPart.Position).Magnitude < 10 then
            return Deposit,Deposit[Type.."Ore"]
        end
    end
end

local function ReadPath(Path)
    for Index,Command in pairs(Path) do
        if not Running then break end
        if Command[1] == "Walk" then SetWalkPoint(Command[2])
        elseif Command[1] == "Mine" then SetWalkPoint(Command[2])
            local NearestDeposit,OreBase = GetNearestDeposit(Command[3])
            local Pickaxe = Global.PlayerCharacter:GetEquippedItem()
            if NearestDeposit and string.find(Pickaxe.Name,"Pickaxe") then
                --print("Mine " .. Table[2] .. " Deposit")
                Global.FaceMouse.CharacterSpring:Disable(true)
                Global.PlayerCharacter.RootPart.CFrame = CFrame.new(
                Global.PlayerCharacter.RootPart.Position,OreBase.Position)
                Pickaxe.IsActivated = true
                while task.wait() do
                    if NearestDeposit.DepositInfo.OreRemaining.Value == 0 then
                        --print("Deposit Empty")
                        break
                    end
                end
                Pickaxe.IsActivated = false
                Global.FaceMouse.CharacterSpring:Disable(false)
            end
        elseif Command[1] == "Sell" then SetWalkPoint(Command[2]) task.wait(0.5)
            for Index,Item in pairs(Global.PlayerData.InventoryContainer.Items) do
                if table.find(Loot,Item.Type) then
                    ReplicatedStorage.Communication.Events.ContainerSellItem:FireServer("Inventory", Item.Id)
                end
            end
        end
    end
end

if not PathLoaded then
    local OldIndex
    OldIndex = hookmetamethod(game,"__index",function(Self, Index)
        local Humanoid = Global.PlayerCharacter.Human
        local RootPart = Global.PlayerCharacter.RootPart
        
        if Humanoid and Self == Humanoid
        and Index == "MoveDirection" then
            Global.PlayerCharacter.IsSprintButtonDown
            = RootPart.Velocity.Magnitude > 6
            return Vector3.one
        end
        return OldIndex(Self, Index)
    end)
end

getgenv().PathLoaded = true
NewThreadLoop(0,function()
    if Window.Flags["Automine/Enabled"]
    and Window.Flags["Automine/Path"]
    and Pathes[Window.Flags["Automine/Path"][1]] then Running = true
        ReadPath(Pathes[Window.Flags["Automine/Path"][1]])
    end
end)

NewThreadLoop(0,function()
    if not Window.Flags["Automine/Enabled"] and Running then
        Running = false WalkTo()
    elseif Window.Flags["Automine/Enabled"] and Running then
        WalkTo(WalkPoint)
    end
end)
