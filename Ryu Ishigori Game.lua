getgenv().AutoLarp = false
getgenv().AutoBuyOutput = false
getgenv().AutoBuyLarpGain = false
getgenv().AutoRebirth = false


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

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    print("✅ Anti AFK triggered")
end)


local function Larp()
    game:GetService("ReplicatedStorage"):WaitForChild("LarpRE"):FireServer(hrp.CFrame)
end

local function BuyOutput()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRE"):FireServer("Output",true)
end

local function BuyLarpGain()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRE"):FireServer("LarpGain",true)
end

local function Rebirth()
    game:GetService("ReplicatedStorage"):WaitForChild("RebirthRE"):FireServer("REBIRTH")
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

local Character = Window:Tab({
    Title = "Character",
    Icon = "person",
    Locked = false
})


Tab:Toggle({
    Title = "Auto Larp",
    Default = false,
    Callback = function(v)
        getgenv().AutoLarp = v
        if getgenv().AutoLarp then
            task.spawn(function()
                while getgenv().AutoLarp do
                    Larp()
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto Buy Output",
    Default = false,
    Callback = function(v)
        getgenv().AutoBuyOutput = v
            if getgenv().AutoBuyOutput then
                task.spawn(function()
                    while getgenv().AutoBuyOutput do
                        BuyOutput()
                        task.wait(0.1)
                    end
                end)
            end
        end
})

Tab:Toggle({
    Title = "Auto Buy Larp Gain",
    Default = false,
    Callback = function(v)
        getgenv().AutoBuyLarpGain = v
            if getgenv().AutoBuyLarpGain then
                task.spawn(function()
                    while getgenv().AutoBuyLarpGain do
                        BuyLarpGain()
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
                task.spawn(function()
                    while getgenv().AutoRebirth do
                        Rebirth()
                        task.wait(0.1)
                    end
                end)
            end
        end
})