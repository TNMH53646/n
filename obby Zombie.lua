local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

getgenv().killAura = false
getgenv().killAuraDelay = 1
getgenv().KillRange = 50

local player = Players.LocalPlayer
local ZombieFolder = workspace:WaitForChild("AliveZombies")

local function getChar()
    local char = player.Character or player.CharacterAdded:Wait()
    return char, char:WaitForChild("HumanoidRootPart"), char:WaitForChild("Humanoid")
end

local function kill()
    local char, rootPart = getChar()
    if not char or not rootPart then return end

    for _, zombie in pairs(ZombieFolder:GetChildren()) do
        local zRoot = zombie:FindFirstChild("HumanoidRootPart")
        local zHum = zombie:FindFirstChild("Humanoid")

        if zRoot and zHum and zHum.Health > 0 then
            local dist = (rootPart.Position - zRoot.Position).Magnitude
            if dist <= getgenv().KillRange then
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        ReplicatedStorage.Remotes.Gunshot:FireServer(tool, {zombie}, true, rootPart.CFrame)
                    end
                end
            end
        end
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

Tab:Input({
    Title = "Delay (Seconds)",
    Value = tostring(getgenv().killAuraDelay),
    Callback = function(input)
        local n = tonumber(input)
        if n and n > 0 then
            getgenv().killAuraDelay = n
        end
    end
})



Tab:Input({
    Title = "Kill Range",
    Value = tostring(getgenv().KillRange),
    Type = "Input",
    InputIcon = "target",
    Callback = function(input)
        local v = tonumber(input)
        if v then
            getgenv().KillRange = math.clamp(v, 5, 200)
        end
    end
})
-- Toggle Kill Aura
Tab:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(v)
        getgenv().killAura = v

        if v then
            task.spawn(function()
                while getgenv().killAura do
                    pcall(kill)
                    task.wait(getgenv().killAuraDelay)
                end
            end)
        end
    end
})
