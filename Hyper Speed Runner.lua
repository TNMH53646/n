task.wait(1)
getgenv().AutoRun = false
getgenv().Automoney = false
getgenv().AutoRebirth = false

local Player = game:GetService("Players").LocalPlayer
local char = Player.Character or Player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function run()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StepTaken"):FireServer(1.8e308, false)
end

-- รอ character ใหม่เมื่อ respawn
Player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
end)
    
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "BlackCrown-X",
    Icon = "door-open",
    Author = "by wdashsuicnsc and timxq_n.",
    KeySystem = {
        Key = { "" },                   -- กำหนดคีย์ที่ใช้ได้
        Note = "Enter your unlock key to open UI.",    -- ข้อความเตือน
        URL = "https://discord.gg/FzdCqV22Y",   -- ลิงก์ขอคีย์
        SaveKey = true,                                -- จดจำคีย์อัตโนมัติ
    },
    -- Open UI Button
    OpenButton = {
        Title = "Open UI",
        Icon = "monitor",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            Color3.fromHex("FF0F7B"),
            Color3.fromHex("F89B29")
        ),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true
    }
})


local Tab = Window:Tab({
    Title = "Main",
    Icon = "bird",
    Locked = false
})

-- Toggle Auto Run
Tab:Toggle({
    Title = "Auto Run",
    Default = false,
    Callback = function(v)
	getgenv().AutoRun = v
		if v then
			task.spawn(function()
				while getgenv().AutoRun do
            		run()
            	task.wait(0.1)
            	end		
        	end)
  		end
   	end
})

-- Toggle Auto Run
Tab:Toggle({
    Title = "Auto money",
    Default = false,
    Callback = function(v)
	getgenv().Automoney = v
		if v then
			task.spawn(function()
				while getgenv().Automoney do
            		hrp.CFrame = CFrame.new(-5.63876893e-06, 2, -9076, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            	task.wait(1)
            	end		
        	end)
  		end
   	end
})

Tab:Toggle({
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(v)
		getgenv().AutoRebirth = v
			if v then
				task.spawn(function()
					while getgenv().Automoney do
            			ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestRebirth"):FireServer("free")
            	task.wait(0.1)
            	end		
        	end)
  		end
	end
})
