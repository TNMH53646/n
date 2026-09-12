getgenv().AutoHealth = false

local Player = game.Players.LocalPlayer
local char = Player.Character or Player.CharacterAdded:Wait()
local rs = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
if not char then
    repeat task.wait() until Player.Character
    char = Player.Character
end
local hrp = char:WaitForChild("HumanoidRootPart")
local hp = char:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = workspace:GetChildren()
local EggModels = game:GetService("ReplicatedStorage").Assets.Eggs
local eggList = {}

for _, egg in pairs(EggModels:GetChildren()) do
    if egg:IsA("Model") then
        table.insert(eggList, egg.Name)
    end
end

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    print("✅ Anti AFK triggered")
end)

local function Health()
    for _, value in pairs(t) do
        if value:IsA("Folder") and value.Name == "Train Area" then
            for _, v in pairs(value:GetChildren()) do
                if v:IsA("Part") and v.Name == "Singularity" then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Gain Hp From Tredmill"):FireServer(v)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("MHP"):FireServer()
                end
            end
        end
    end
end

local function Rebirth()
    game:GetService("ReplicatedStorage"):WaitForChild("RebirthRemote"):FireServer()
end


local function AutoSpin()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEventWheel"):FireServer(2)
end

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

local Spin = Window:Tab({
    Title = "Spin",
    Icon = "gift",
    Locked = false
})

local tp = Window:Tab({
    Title = "Teleports",
    Icon = "location",
    Locked = false
})


Tab:Toggle({
    Title = "Auto Health",
    Default = false,
    Callback = function(v)
        getgenv().AutoHealth = v
            if getgenv().AutoHealth then
                spawn(function()
                    while getgenv().AutoHealth do
                        Health()
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto Win",
    Default = false,
    Callback = function(v)
        getgenv().AutoWin = v
        if getgenv().AutoWin then
            spawn(function()
                while getgenv().AutoWin do
                    hrp.CFrame = CFrame.new(5176.82666, 0.434425354, 24.2043457, 0, 0, 1, 0, 1, -0, -1, 0, 0)
                    task.wait(0.1)
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
            if getgenv().AutoRebirth then
                spawn(function()
                    while getgenv().AutoRebirth do
                        Rebirth()
                    task.wait(0.1)
                end
            end)
        end
    end
})




Spin:Dropdown({
    Title = "Select Egg",
    Values = eggList,
    AllowNone = false,
    Callback = function(Option)
        getgenv().SelectedEgg = Option

    end
})

Spin:Input({
    Title = "Spin Amount",
    Default = "1",
    Numeric = true,
    Callback = function(Value)
        getgenv().SpinAmount = tonumber(Value) or 1
    end
})

Spin:Toggle({
    Title = "Auto Spin",
    Default = false,
    Callback = function(v)
        getgenv().AutoSpin = v
            if getgenv().AutoSpin then
                spawn(function()
                    while getgenv().AutoSpin do
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Function"):WaitForChild("Luck"):WaitForChild("[C-S]DoLuck"):InvokeServer(getgenv().SelectedEgg, getgenv().SpinAmount)
                    task.wait(0.1)
                end
            end)
        end
    end
})


Spin:Toggle({
    Title = "Auto Spin",
    Default = false,
    Callback = function(v)
        getgenv().AutoSpin = v
            if getgenv().AutoSpin then
                spawn(function()
                    while getgenv().AutoSpin do
                        AutoSpin()
                    task.wait(0.1)
                end
            end)
        end
    end
})

tp:Button({
    Title = "Tp to World2",
    Default = false,
    Callback = function(v)
        getgenv().AutoWin = v
        if getgenv().AutoWin then
            spawn(function()
                hrp.CFrame = CFrame.new(5187.7124, 13.0999994, 7.38469219, -1, 0, 0, 0, 1, 0, 0, 0, -1)
            end)
        end
    end
})