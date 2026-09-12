getgenv().AutoClick = false
getgenv().AutoPollinate = false
getgenv().AutoSell = false
getgenv().autobuysee = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local char = Player.Character or Player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hp = char:WaitForChild("Humanoid")

local Communication = ReplicatedStorage:WaitForChild("Communication")
local ClickPlantEvent = Communication:WaitForChild("ClickPlant")
local PollinateEvent = Communication:WaitForChild("PollinatePlant")
local DoRoll = Communication:WaitForChild("DoRoll")
local BuySeeds = Communication:WaitForChild("BuySeeds") -- ✅ แก้จาก BuyStump → BuySeeds
local VirtualUser = game:GetService("VirtualUser")
-- ดึงชื่อผลไม้ทั้งหมดจาก Storage
local FruitList = {}
local FruitModels = ReplicatedStorage:WaitForChild("Storage"):WaitForChild("Fruit"):GetChildren()
for _, fruit in ipairs(FruitModels) do
    local name = fruit.Name:gsub(" Seeds", "") -- ✅ เก็บแยกก่อน
    table.insert(FruitList, name)
end


game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    print("✅ Anti AFK triggered")
end)

-- Tiles
local Tiles = workspace
    :WaitForChild("Plots")
    :WaitForChild(Player.Name)
    :WaitForChild("Tiles")
    :GetChildren()

local function FireForAllTiles(event)
    for _, tile in pairs(Tiles) do
        event:FireServer(tile)
        task.wait(0.1)
    end
end

-- หา Stump ทั้งหมด
local function GetAllStumps()
    local plot = workspace:WaitForChild("Plots"):WaitForChild(Player.Name)
    local stumps = {}

    if plot:FindFirstChild("Stump") then
        table.insert(stumps, { index = 1, stump = plot.Stump })
    end
    for i = 2, 7 do
        local name = "Stump_" .. i
        if plot:FindFirstChild(name) then
            table.insert(stumps, { index = i, stump = plot[name] })
        end
    end
    return stumps
end

local function GetStumpTitle(stump)
    local ok, display = pcall(function()
        return stump:WaitForChild("Model", 2):WaitForChild("BuyableDisplay", 2)
    end)
    if not ok or not display then return nil end

    local title = display:FindFirstChild("Title")
    if title and title:IsA("TextLabel") then
        -- ✅ ตัด " Seeds" ออกให้เหลือแค่ชื่อผลไม้
        return title.Text:gsub(" Seeds", "")
    end
    return nil
end

local function AutoBuyAllStumps()
    local selected = getgenv().SelectedSeed
    if not selected then 
        print("❌ ไม่มี SelectedSeed")
        return 
    end

    local stumps = GetAllStumps()
    for _, data in ipairs(stumps) do
        local currentFruit = GetStumpTitle(data.stump)
        print("🔍 Stump_" .. data.index .. " = [" .. tostring(currentFruit) .. "]")

        if currentFruit then
            for _, seed in ipairs(selected) do  -- ✅ เปลี่ยนเป็น ipairs แทน pairs
                print("   🌱 Checking: [" .. tostring(seed) .. "] Match? " .. tostring(currentFruit == seed))
                if currentFruit == seed then
                    BuySeeds:FireServer(data.index)
                    print("✅ ซื้อแล้ว Stump_" .. data.index .. ": " .. currentFruit)
                    task.wait(0.1)
                    break
                end
            end
        end
    end
end

local function AutoRoll()
    DoRoll:InvokeServer()
end

local function AutoBuyCycle()
    AutoRoll()
    task.wait(0.1)
    AutoBuyAllStumps()
end

local function ClickPlant()
    FireForAllTiles(ClickPlantEvent)
end

local function PollinatePlant()
    FireForAllTiles(PollinateEvent)
end

local function sell()
    Communication:WaitForChild("SellCrate"):FireServer()
end


local function Autoup()
    game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("BuyUpgrade"):FireServer("MutationMultiplier")
    game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("BuyUpgrade"):FireServer("UpgradeCaps")
end

-- GUI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "BlackCrown-X",
    Icon = "door-open",
    Author = "by wdashsuicnsc and timxq_n.",
    KeySystem = {
        Key = { "" },
        Note = "Enter your unlock key to open UI.",
        URL = "https://discord.gg/FzdCqV22Y",
        SaveKey = true,
    },
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

local up = Window:Tab({
    Title = "Upgrade",
    Icon = "arrow-up",
    Locked = false
})

Tab:Dropdown({
    Title = "Select Seed",
    Values = FruitList,
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        getgenv().SelectedSeed = option
    end
})

Tab:Toggle({
    Title = "Auto Buy",
    Default = false,
    Callback = function(v)
        getgenv().autobuysee = v
        if v then
            task.spawn(function()
                while getgenv().autobuysee do
                    AutoBuyCycle()
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto Click",
    Default = false,
    Callback = function(v)
        getgenv().AutoClick = v
        if v then
            task.spawn(function() -- ✅ เพิ่ม task.spawn ป้องกัน UI ค้าง
                while getgenv().AutoClick do
                    ClickPlant()
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto Pollinate",
    Default = false,
    Callback = function(v)
        getgenv().AutoPollinate = v
        if v then
            task.spawn(function() -- ✅ เพิ่ม task.spawn
                while getgenv().AutoPollinate do
                    PollinatePlant()
                    task.wait(0.1)
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(v)
        getgenv().AutoSell = v
        if v then
            task.spawn(function() -- ✅ เพิ่ม task.spawn
                while getgenv().AutoSell do
                    sell()
                    task.wait(0.1)
                end
            end)
        end
    end
})

up:Toggle({
    Title = "Auto Upgrade",
    Default = false,
    Callback = function(v)
        getgenv().AutoUpgrade = v
        if v then
            task.spawn(function() -- ✅ เพิ่ม task.spawn
                while getgenv().AutoUpgrade do
                    Autoup()
                    task.wait(0.1)
                end
            end)
        end
    end
})
