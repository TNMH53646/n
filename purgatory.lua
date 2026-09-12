getgenv().Immortal = false
getgenv().kill = false

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

Tab:Toggle({
    Title = "heal",
    Default = false,
    Callback = function(v)
    getgenv().Immortal = v
        spawn(function()
            if v then
                while getgenv().Immortal do
                    pcall(function ()
                        game:GetService("ReplicatedStorage"):WaitForChild("OnServerEvents"):WaitForChild("PlrDamaged"):FireServer(-500)
                        end)
                    task.wait(0.1)
                end
            end
        end)
    end
})

Tab:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(v)
        getgenv().kill = v
        task.spawn(function()
            while getgenv().kill do
                pcall(function()
                    local enemies = workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, enemy in ipairs(enemies:GetChildren()) do
                            if enemy:FindFirstChild("HumanoidRootPart") then
                                game:GetService("ReplicatedStorage"):WaitForChild("OnServerEvents"):WaitForChild("CombatServer"):FireServer(enemy.HumanoidRootPart,"Melee",{riposte = false,backstab = false})
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)

    end
})


