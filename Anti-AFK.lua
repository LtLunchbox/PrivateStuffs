-- a simple anti afk gui made by DD2#1810

local ScreenGui = Instance.new("ScreenGui")
local antiafk = Instance.new("Frame")
local panel = Instance.new("TextLabel")
local line = Instance.new("TextLabel")
local togglebutton = Instance.new("TextButton")
local GUI = Instance.new("TextLabel")
local antiafk_2 = Instance.new("TextLabel")
local onoff = Instance.new("TextButton")
--Properties:
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

antiafk.Name = "anti-afk"
antiafk.Parent = ScreenGui
antiafk.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
antiafk.BorderSizePixel = 0
antiafk.Position = UDim2.new(0.0375939831, 0, 0.0788643509, 0)
antiafk.Size = UDim2.new(0, 150, 0, 60)

panel.Name = "panel"
panel.Parent = antiafk
panel.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
panel.BorderSizePixel = 0
panel.Size = UDim2.new(0, 150, 0, 20)
panel.Font = Enum.Font.GothamSemibold
panel.Text = ""
panel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
panel.TextSize = 12
panel.TextXAlignment = Enum.TextXAlignment.Left

line.Name = "line"
line.Parent = antiafk
line.BackgroundColor3 = Color3.new(0, 1, 0.498039)
line.BorderSizePixel = 0
line.Position = UDim2.new(0, 0, 0.333333313, 0)
line.Size = UDim2.new(0, 150, 0, 1)
line.Font = Enum.Font.GothamSemibold
line.Text = ""
line.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
line.TextSize = 12
line.TextXAlignment = Enum.TextXAlignment.Left

togglebutton.Name = "togglebutton"
togglebutton.Parent = antiafk
togglebutton.BackgroundColor3 = Color3.new(1, 1, 1)
togglebutton.BackgroundTransparency = 1
togglebutton.BorderSizePixel = 0
togglebutton.Position = UDim2.new(0.866666675, 0, 0, 0)
togglebutton.Size = UDim2.new(0, 20, 0, 20)
togglebutton.Font = Enum.Font.SourceSans
togglebutton.Text = "-"
togglebutton.TextColor3 = Color3.new(0.980392, 0.980392, 0.980392)
togglebutton.TextSize = 20

GUI.Name = "GUI"
GUI.Parent = antiafk
GUI.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
GUI.BorderSizePixel = 0
GUI.Position = UDim2.new(0.13333334, 0, 0, 0)
GUI.Size = UDim2.new(0, 110, 0, 20)
GUI.Font = Enum.Font.GothamSemibold
GUI.Text = "GUI"
GUI.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
GUI.TextSize = 12

antiafk_2.Name = "antiafk"
antiafk_2.Parent = antiafk
antiafk_2.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
antiafk_2.BackgroundTransparency = 1
antiafk_2.BorderSizePixel = 0
antiafk_2.Position = UDim2.new(0.0199999996, 0, 0.483333319, 0)
antiafk_2.Size = UDim2.new(0, 60, 0, 20)
antiafk_2.Font = Enum.Font.GothamSemibold
antiafk_2.Text = "Anti Afk"
antiafk_2.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
antiafk_2.TextSize = 12

onoff.Name = "onoff"
onoff.Parent = antiafk
onoff.BackgroundColor3 = Color3.new(1, 1, 1)
onoff.BackgroundTransparency = 1
onoff.BorderSizePixel = 0
onoff.Position = UDim2.new(0.713333309, 0, 0.466666669, 0)
onoff.Size = UDim2.new(0, 40, 0, 21)
onoff.Font = Enum.Font.GothamSemibold
onoff.Text = "OFF"
onoff.TextColor3 = Color3.new(1, 0, 0)
onoff.TextSize = 12
onoff.MouseButton1Click:connect(function()
	if onoff.Text == "OFF" then
		onoff.Text = "ON"
		onoff.TextColor3 = Color3.new(0, 1, 0.498039)
		end
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
end)

-- Scripts:
function SCRIPT_MLWU85_FAKESCRIPT() -- antiafk.drag script 
	local script = Instance.new('LocalScript')
	script.Parent = antiafk
	local UserInputService = game:GetService("UserInputService")
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_MLWU85_FAKESCRIPT))

-- end guys