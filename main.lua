
-- Global
getgenv().AutoXP = false
getgenv().AutoCoin = false
getgenv().GetAllSword = false 
getgenv().ReStat = false
-- Add XP Function (เหมือนโครงสร้าง Rebirth)
local SwordsEvent = game:GetService("ReplicatedStorage")
    :WaitForChild("ReplicatedStorageHolders")
    :WaitForChild("Events")
    :WaitForChild("AddToInventory")

local SwordList = {
    "Sword",
    "Axe",
    "Scythe",
    "WarAxe",
    "EmeraldBlade",
    "ShadowKatana",
    "SorrowsEdge",
    "MoonFang",
    "LionSword",
    "BoneFang",
    "GoldenSword",
    "InfernoAxe",
    "Obsidian",
    "CrimsonFang",
    "BloodreignSaber",
    "WarlordsFang",
    "Trident",
    "SunpiercerAxe",
    "AzureBlade",
    "VoidwingReaver",
    "SandWeaver",
    "SharkspineReaver"
}

local function AddXP()
    game:GetService("ReplicatedStorage")
        :WaitForChild("ReplicatedStorageHolders")
        :WaitForChild("Events")
        :WaitForChild("AddXP")
        :FireServer(99999)
end
local function AddCoins()
game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedStorageHolders"):WaitForChild("Events"):WaitForChild("AddCoins"):FireServer(999999)
end


local function GetAllSwords()
    for _, swordName in ipairs(SwordList) do
        SwordsEvent:FireServer(swordName)
        task.wait(0.1) -- กัน server ป้องกัน spam
    end
end

local function ReStats()
game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedStorageHolders"):WaitForChild("Events"):WaitForChild("ResetStats"):FireServer(false)

end
-- Load WindUI
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
    Title = "Auto Coins",
    Default = false,
    Callback = function(v)
        getgenv().AutoCoin = v

        if v then
            task.spawn(function()
                while getgenv().AutoCoin do
                    AddCoins()
                    task.wait(0.5) -- ปรับความเร็วตรงนี้
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto XP",
    Default = false,
    Callback = function(v)
        getgenv().AutoXP = v

        if v then
            task.spawn(function()
                while getgenv().AutoXP do
                    AddXP()
                    task.wait(0.5) -- ปรับความเร็วตรงนี้
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Get All Sword",
    Default = false,
    Callback = function(v)
        getgenv().GetAllSword = v

        if v then
            task.spawn(function()
                while getgenv().GetAllSword do
                    GetAllSwords()
                    task.wait(10)
                end
            end)
        end
    end
})

Tab:Button({
    Title = "Reset Stats",
    Callback = function()
        ReStats()
    end
})
