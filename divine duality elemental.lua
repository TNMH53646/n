getgenv().AutoSpin1 = false
getgenv().SelectedTarget = nil
getgenv().AutoSkill1 = false
getgenv().AutoDive = false
getgenv().AutoDun = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local char = Player.Character

if not char then
    repeat task.wait() until Player.Character
    char = Player.Character
end

local hrp = char:WaitForChild("HumanoidRootPart")
local hp = char:WaitForChild("Humanoid")

local SpinEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpinEvent")
local SkillEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SkillEvent")

local essenceModels = ReplicatedStorage.EssenceModels
local essenceList = {}

for _, category in ipairs(essenceModels:GetChildren()) do
    for _, essence in ipairs(category:GetChildren()) do
        table.insert(essenceList, essence.Name)
    end
end


local function FilterEssenceModels()
    local ElementalModels = workspace.GachaTower.EssenceModel
    for _, model in pairs(ElementalModels:GetChildren()) do
        if getgenv().SelectedEssences then
            if not getgenv().SelectedEssences[model.Name] then
                model:Destroy()
            end
        end
    end
end

local function SpinOne()
    local slot = Player.Essences:FindFirstChild("Essence1")
    if slot then
        local currentValue = slot.Value
        if getgenv().SelectedEssences and getgenv().SelectedEssences[currentValue] then
            print("Slot 1 ตรงแล้ว: " .. currentValue)
        else
            FilterEssenceModels()
            SpinEvent:FireServer(1, false)
        end
    end
end

local function SpinTwo()
    local slot = Player.Essences:FindFirstChild("Essence2")
    if slot then
        local currentValue = slot.Value
        if getgenv().SelectedEssences and getgenv().SelectedEssences[currentValue] then
            print("Slot 2 ตรงแล้ว: " .. currentValue)
        else
            FilterEssenceModels()
            SpinEvent:FireServer(2, false)
        end
    end
end

local function GetPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            table.insert(list, p.Name)
        end
    end
    return list
end

local function GetTargetHRP()
    local targetName = getgenv().SelectedTarget
    if not targetName then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name == targetName and p.Character then
            return p.Character:FindFirstChild("HumanoidRootPart")
        end
    end
    return nil
end

local function GetNearestEntity()
    local nearestHRP = nil
    local nearestDistance = math.huge
    for _, entity in pairs(workspace.Entities:GetChildren()) do
        local entityHRP = entity:FindFirstChild("HumanoidRootPart")
        local entityHP = entity:FindFirstChild("Humanoid")
        if entityHRP and entityHP and entityHP.Health > 0 then
            local distance = (hrp.Position - entityHRP.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestHRP = entityHRP
            end
        end
    end
    return nearestHRP
end

-- ✅ Hook Mouse.Hit
local mouse = Player:GetMouse()
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if self == mouse and key == "Hit" and getgenv().AutoSkill1 then
        local targetHRP = GetTargetHRP()
        if targetHRP then
            return CFrame.new(targetHRP.Position)
        end
    end
    return oldIndex(self, key)
end)

-- ✅ Auto Skill
local function AimSkill(slot)
    local targetHRP = GetTargetHRP()
    if not targetHRP then return end

    local pos = targetHRP.Position
    local cf = CFrame.lookAt(hrp.Position, pos)
    hrp.CFrame = cf

    SkillEvent:FireServer("E", pos, cf, slot)
    task.wait(0.1)
    SkillEvent:FireServer("R", pos, cf, slot)
    task.wait(0.1)
    SkillEvent:FireServer("F", pos, cf, slot)
end

-- ✅ Auto Dive ช้าๆ ไปใต้เท้ามอน
local function DiveToEntity()
    local target = GetNearestEntity()
    if not target then return end

    local targetPos = target.Position - Vector3.new(0, 3, 0)
    local stepSize = 2
    local delay = 0.1

    while (hrp.Position - targetPos).Magnitude > 5 do
        if not getgenv().AutoDive then break end
        local direction = (targetPos - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position + direction * stepSize)
        task.wait(delay)
    end

    if getgenv().AutoDive then
        local pos = target.Position
        local cf = CFrame.lookAt(hrp.Position, pos)
        hrp.CFrame = cf

        SkillEvent:FireServer("E", pos, cf, 1)
        task.wait(0.1)
        SkillEvent:FireServer("R", pos, cf, 1)
        task.wait(0.1)
        SkillEvent:FireServer("F", pos, cf, 1)
        task.wait(0.2)
        SkillEvent:FireServer("E", pos, cf, 2)
        task.wait(0.1)
        SkillEvent:FireServer("R", pos, cf, 2)
        task.wait(0.1)
        SkillEvent:FireServer("F", pos, cf, 2)
    end
end

-- ✅ Auto Dun
local function Autodun()
    local PveQueue = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PveQueue")
    PveQueue:FireServer("CreateParty", {Private = false, Difficulty = 1})
    task.wait(0.5)
    PveQueue:FireServer("Start")
end

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

local targetDropdown = Tab:Dropdown({
    Title = "Lock Target",
    Values = GetPlayerList(),
    AllowNone = true,
    Callback = function(v)
        getgenv().SelectedTarget = v
    end
})

Players.PlayerAdded:Connect(function()
    targetDropdown:Refresh(GetPlayerList(), true)
end)

Players.PlayerRemoving:Connect(function()
    targetDropdown:Refresh(GetPlayerList(), true)
end)

Tab:Toggle({
    Title = "Auto Skill",
    Default = false,
    Callback = function(v)
        getgenv().AutoSkill1 = v  -- ✅ ลบ StartMouseHook() ออก
        if v then
            task.spawn(function()
                while getgenv().AutoSkill1 do
                    AimSkill(1)
                    task.wait(0.2)
                    AimSkill(2)
                    task.wait(0.5)
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto Dive",
    Default = false,
    Callback = function(v)
        getgenv().AutoDive = v
        if v then
            task.spawn(function()
                while getgenv().AutoDive do
                    DiveToEntity()
                    task.wait(1)
                end
            end)
        end
    end
})

Tab:Toggle({
    Title = "Auto Dun",
    Default = false,
    Callback = function(v)
        getgenv().AutoDun = v
        if v then
            task.spawn(function()
                while getgenv().AutoDun do
                    Autodun()
                    task.wait(3)
                end
            end)
        end
    end
})

Tab:Dropdown({
    Title = "Elemental",
    Values = essenceList,
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        getgenv().SelectedEssences = option
    end
})

Tab:Dropdown({
    Title = "Essences",
    Values = { "Essence1", "Essence2" },
    AllowNone = true,
    Callback = function(v)
        getgenv().SelectedEssence = v
    end
})

Tab:Toggle({
    Title = "Auto Spin",
    Default = false,
    Callback = function(v)
        getgenv().AutoSpin1 = v
        if v then
            task.spawn(function()
                while getgenv().AutoSpin1 do
                    local slot = getgenv().SelectedEssence
                    if slot == "Essence1" then
                        SpinOne()
                    elseif slot == "Essence2" then
                        SpinTwo()
                    end
                    task.wait()
                end
            end)
        end
    end
})
