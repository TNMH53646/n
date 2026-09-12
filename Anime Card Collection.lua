getgenv().collectEggAllCurrency = false
getgenv().autoCollect = false
getgenv().autoBuyPack = false

local Player = game.Players.LocalPlayer
local char = Player.Character
local hrp = char:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Mutations = require(game:GetService("ReplicatedStorage").Modules.Config.Core.Mutations)
local plot = tostring(game:GetService("Players").LocalPlayer:GetAttribute("Plot"))
local Packs = {}
local Tiers = {}
local PacksMap = {} -- { ["Clover"] = "10-1", ["Pirate"] = "4-1" }
local AllPacks = {}
local PacksInPlot = {}
local selectedPacks = {}
local selectedTier = nil
local blacklist = {"Bottom", "Top"}
local PackDropdown = nil

if not char then
    repeat task.wait() until Player.Character
    char = Player.Character
end

for _, pack in pairs(game:GetService("ReplicatedStorage").Assets.Packs:GetChildren()) do
    table.insert(AllPacks, pack.Name)
    print("Pack found:", pack.Name)
end

print("Total packs:", #AllPacks)
for tierName, _ in pairs(Mutations) do
    table.insert(Tiers, tierName)
end
table.sort(Tiers, function(a, b)
    return Mutations[a].Chance > Mutations[b].Chance
end)

local refreshDebounce = false

local function refreshPacks()
    if refreshDebounce then return end
    refreshDebounce = true
    task.wait(1)
    PacksInPlot = {}
    for _, pack in pairs(workspace.Client.Packs:GetChildren()) do
        local splitName = pack.Name:split("-")
        if #splitName >= 2 and splitName[2] == plot then
            for _, mesh in pairs(pack:GetChildren()) do
                if mesh:IsA("MeshPart") and not table.find(blacklist, mesh.Name) and not table.find(PacksInPlot, mesh.Name) then
                    table.insert(PacksInPlot, mesh.Name)
                end
            end
        end
    end
if PackDropdown then
    local validSelected = {}
    for _, name in pairs(selectedPacks) do
        if table.find(PacksInPlot, name) then
            table.insert(validSelected, name)
        end
    end
    selectedPacks = validSelected
    PackDropdown:Refresh(PacksInPlot)
    task.wait(0.1) -- รอให้ Refresh เสร็จก่อน
    PackDropdown:Select(selectedPacks)
end
end
refreshPacks()

local function collectEggs()
    for i = 1, 80 do
        local egg = workspace.VFX:FindFirstChild(i .. "-Egg")
        if egg and egg:IsA("MeshPart") then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Easter"):FireServer("Collect", tostring(i))
        end
    end
end

local function collectTravelToken()
    local tokens = {"TravelToken1", "TravelToken2"}
    for _, tokenName in pairs(tokens) do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Potion"):FireServer("Collect", tokenName)
    end
end

local function collectPotion()
    local potions = {"Luck", "HatchTime"}
    for _, potionName in pairs(potions) do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Potion"):FireServer("Collect", potionName)
    end
end

local function collectCardTokens()
    for i = 1, 80 do
        local token = workspace.Items.Tokens.Client:FindFirstChild(tostring(i))
        if token then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Card"):FireServer("CollectToken", tostring(i))
        end
    end
end

local function collectAllCurrency()
    collectEggs()
    collectTravelToken()
    collectPotion()
    collectCardTokens()
end

local function collectAllCards()
    local display = workspace.Plots[plot].Map.Display
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Card")
    local totalPages = #game:GetService("ReplicatedStorage").Assets.Packs:GetChildren()

    for page = 1, totalPages do
        for _, side in pairs({"Left", "Right"}) do
            for _, card in pairs(display[side]:GetChildren()) do
                remote:FireServer("Collect", card)
            end
        end
        task.wait(0.3)
        if page < totalPages then
            remote:FireServer("Page", "RightArrow")
            task.wait(0.3)
        end
    end

    -- กลับหน้าแรกโดยกด LeftArrow totalPages-1 ครั้ง
    for i = 1, totalPages - 1 do
        remote:FireServer("Page", "LeftArrow")
        task.wait(0.1)
    end
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


Tab:Toggle({
    Title = "Collect All Currency",
    Default = false,
    Callback = function(v)
        getgenv().collectEggAllCurrency = v
        if getgenv().collectEggAllCurrency then
            while getgenv().collectEggAllCurrency do
                task.spawn(function()
                    collectAllCurrency()
                end)
                task.wait(1)
            end
        end
    end
})

Tab:Toggle({
    Title = "Auto Collect Cards",
    Default = false,
    Callback = function(v)
        getgenv().autoCollect = v
        if getgenv().autoCollect then
            while getgenv().autoCollect do
                collectAllCards()
                task.wait(1)
            end
        end
    end
})

Tab:Dropdown({
    Title = "Select Pack",
    Values = AllPacks,
    Value = { AllPacks[1] },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedPacks = option
    end
})

Tab:Dropdown({
    Title = "Tier",
    Values = Tiers,
    Value = { Tiers[1] },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedTier = option[1]
    end
})

Tab:Toggle({
    Title = "Auto Buy Pack",
    Desc = "Automatically buys the selected pack in market.",
    Default = false,
    Callback = function(v)
        getgenv().autoBuyPack = v
        if getgenv().autoBuyPack then
            while getgenv().autoBuyPack do
                for _, packName in pairs(selectedPacks) do
                    local packWithTier = packName .. "-" .. (selectedTier or "")
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Stock"):FireServer("Buy", packWithTier)
                end
                task.wait(0.1)
            end
        end
    end
})

Tab:Dropdown({
    Title = "Select Pack",
    Values = AllPacks,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedPacks = option
    end
})

Tab:Toggle({
    Title = "Auto Buy Pack",
    Default = false,
    Callback = function(v)
        getgenv().autoBuyPack = v
        if getgenv().autoBuyPack then
            while getgenv().autoBuyPack do
                for _, pack in pairs(workspace.Client.Packs:GetChildren()) do
                    local splitName = pack.Name:split("-")
                    if #splitName >= 2 and splitName[2] == plot then
                        for _, mesh in pairs(pack:GetChildren()) do
                            -- เช็คว่าชื่อ MeshPart ตรงกับที่เลือกใน Dropdown
                            if mesh:IsA("MeshPart") and not table.find(blacklist, mesh.Name) and table.find(selectedPacks, mesh.Name) then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Card"):FireServer("BuyPack", pack.Name)
                                break
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end
    end
})
