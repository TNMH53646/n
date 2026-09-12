-- ==================== GLOBAL VARIABLES ====================
getgenv().ActiveNoCooldownPrompt = false
getgenv().ActiveDistanceEsp = false
getgenv().ActiveBigPrompt = false
getgenv().DisableLimitRangerEsp = false
getgenv().LimitRangerEsp = 1000
getgenv().ValueRunSpeed = getgenv().ValueRunSpeed or 24
getgenv().ActiveSpeedBoost = false
getgenv().ValueWalkSpeed = getgenv().ValueWalkSpeed or 15
getgenv().ActiveSpeedBoost2 = false
getgenv().ActiveEspKillers = false
getgenv().ActiveEspSurvivors = false
getgenv().ActiveEspGen = false
getgenv().AutoEscape = false
getgenv().AutoGen = false
getgenv().ActiveEspFuseBoxes = false
getgenv().FighterAutoParry = false
getgenv().ActiveEspBattery = false
getgenv().AutoBarricade = false
getgenv().AutoSafeSpot = false
getgenv().HitboxExpender = false
getgenv().ValueHE = getgenv().ValueHE or 15
getgenv().ActiveEspTraps = false
getgenv().ActiveEspWireEyes = false
getgenv().AutoShakeWireEyes = false
getgenv().ActiveInfiniteStamina = false
getgenv().CanShake = true
getgenv().NoBlindness = false
getgenv().LineESPEnabled = false
getgenv().SavedCFrame = nil
getgenv().Teleported = false
getgenv().CanParry = true
getgenv().ESPs = {}
getgenv().Camera = nil
getgenv().FullBright = false
getgenv().NoFog = false
getgenv().OriginalLighting = {}

-- ==================== SERVICES ====================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

task.spawn(function()
    getgenv().Camera = workspace.CurrentCamera
end)

-- ==================== LOAD WINDUI ====================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Create Window
local Window = WindUI:CreateWindow({
    Title = "Bite by night by BlackCrown-X",
    Icon = "cross",
    Author = "by wdashsuicnsc and timxq_n.",
    KeySystem = {
        Key = { "" },
        Note = "Enter your unlock key to open UI.",
        URL = "https://discord.gg/E2TqYRsRP4",
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

-- Create Tabs
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "flame",
    Locked = false
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
    Locked = false
})

local EspTab = Window:Tab({
    Title = "Esp",
    Icon = "eye",
    Locked = false
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "cog",
    Locked = false
})

local DiscordTab = Window:Tab({
    Title = "Discord",
    Icon = "link",
    Locked = false
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Locked = false
})

-- ==================== HELPER FUNCTIONS ====================

local function doShake(wireyesUI)
    task.spawn(function()
        local wireyesClient = wireyesUI:WaitForChild("WireyesClient")
        if wireyesClient then
            local remote = wireyesClient:WaitForChild("WireyesEvent")
            if remote then
                getgenv().CanShake = false
                task.spawn(function() 
                    task.wait(0.5)
                    getgenv().CanShake = true
                end)
                pcall(function() remote:FireServer("Shaking") end)
                task.wait(0.05)
                pcall(function() remote:FireServer("TakeOff", workspace:GetServerTimeNow()) end)
            end
        end
    end)
end

local function getNewestDot()
    local newest = nil
    for _, child in ipairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
        if child.Name == "Dot" then
            newest = child
        end
    end
    return newest
end

local function CreateEsp(Char, Color, Text, Parent)
    if not Char or not Parent then return end
    if Char:FindFirstChild("ESP") and Char:FindFirstChildOfClass("Highlight") then return end

    local highlight = Char:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = Char

    local billboard = Char:FindFirstChild("ESP") or Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(10, 0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = Parent
    billboard.Enabled = false
    billboard.Parent = Parent

    local background = billboard:FindFirstChild("Background") or Instance.new("TextLabel")
    background.Name = "Background"
    background.Size = UDim2.new(1.2, 0, 1.15, 0)
    background.Position = UDim2.new(-0.1, 0, -0.075, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.TextTransparency = 1
    background.BorderSizePixel = 1
    background.BorderColor3 = Color
    background.Parent = billboard

    local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.TextStrokeTransparency = 0.3
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.ZIndex = 2
    label.Parent = billboard

    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color
    line.Thickness = 2
    line.Transparency = 0.7

    table.insert(getgenv().ESPs, {
        Char = Char,
        Highlight = highlight,
        Billboard = billboard,
        Label = label,
        Background = background,
        Part = Parent,
        Line = line,
        Text = Text,
        Color = Color
    })
end

local function KeepEsp(Char, Parent)
    if not Char or not Char:FindFirstChildOfClass("Highlight") then return end
    if not Parent or not Parent:FindFirstChildOfClass("BillboardGui") then return end

    for i = #getgenv().ESPs, 1, -1 do 
        local esp = getgenv().ESPs[i]
        if esp.Char == Char then 
            if esp.Highlight then pcall(function() esp.Highlight:Destroy() end) end
            if esp.Billboard then pcall(function() esp.Billboard:Destroy() end) end
            if esp.Background then pcall(function() esp.Background:Destroy() end) end
            if esp.Line then pcall(function() esp.Line:Destroy() end) end
            table.remove(getgenv().ESPs, i) 
        end
    end
end

local function SetupCharacter(child, Map, Part)
    if not child:IsA("Model") then return end
    child.AncestryChanged:Connect(function(_, newParent)
        if not child:IsDescendantOf(Map) then
            KeepEsp(child, Part)
        end
    end)
end

local function ScanForSurvivors()
    if workspace:FindFirstChild("PLAYERS") and workspace.PLAYERS:FindFirstChild("ALIVE") then
        for _, char in ipairs(workspace.PLAYERS.ALIVE:GetChildren()) do
            if char:IsA("Model") and char:FindFirstChild("PrimaryPart") or char:FindFirstChild("HumanoidRootPart") then
                local part = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                local name = char.Name
                if not part:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(char, Color3.fromRGB(0,255,0), name, part)
                    SetupCharacter(char, workspace.PLAYERS.ALIVE, part)
                end
            end
        end
    end
end

local function ScanForKillers()
    if workspace:FindFirstChild("PLAYERS") and workspace.PLAYERS:FindFirstChild("KILLER") then
        for _, char in ipairs(workspace.PLAYERS.KILLER:GetChildren()) do
            if char:IsA("Model") and char:FindFirstChild("RootPart") then
                local part = char.RootPart
                local name = char.Name
                if not part:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(char, Color3.fromRGB(255,0,0), name, part)
                    SetupCharacter(char, workspace.PLAYERS.KILLER, part)
                end
            end
        end
    end
end

local function ScanForGenerators()
    if workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("Generators") then
        for _, gen in ipairs(workspace.MAPS["GAME MAP"].Generators:GetChildren()) do
            if gen:IsA("Model") and gen:FindFirstChild("PrimaryPart") or gen:FindFirstChildOfClass("Part") then
                local part = gen.PrimaryPart or gen:FindFirstChildOfClass("Part")
                if part and not part:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(gen, Color3.fromRGB(255,255,0), "Generator", part)
                end
            end
        end
    end
end

local function ScanForFuseBoxes()
    if workspace:FindFirstChild("MAPS") and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("FuseBoxes") then
        for _, fuse in ipairs(workspace.MAPS["GAME MAP"].FuseBoxes:GetChildren()) do
            if fuse:IsA("Model") and fuse:FindFirstChild("PrimaryPart") or fuse:FindFirstChildOfClass("Part") then
                local part = fuse.PrimaryPart or fuse:FindFirstChildOfClass("Part")
                if part and not part:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(fuse, Color3.fromRGB(0,0,255), "Fuse Box", part)
                end
            end
        end
    end
end

local function ScanForBattery()
    if workspace:FindFirstChild("IGNORE") then
        for _, battery in ipairs(workspace.IGNORE:GetChildren()) do
            if battery.Name == "Battery" and battery:IsA("BasePart") and not battery:FindFirstChildOfClass("BillboardGui") then
                CreateEsp(battery, Color3.fromRGB(0,0,255), "Battery", battery)
            end
        end
    end
end

local function ScanForTraps()
    if workspace:FindFirstChild("IGNORE") then
        for _, trap in ipairs(workspace.IGNORE:GetChildren()) do
            if trap.Name == "Trap" and trap:IsA("Model") and trap:FindFirstChild("PrimaryPart") then
                local part = trap.PrimaryPart
                if part and not part:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(trap, Color3.fromRGB(255,0,0), "Trap", part)
                end
            end
        end
    end
end

local function ScanForWireEyes()
    if workspace:FindFirstChild("IGNORE") then
        for _, minion in ipairs(workspace.IGNORE:GetChildren()) do
            if minion.Name == "Minion" and minion:IsA("Model") and minion:FindFirstChild("PrimaryPart") then
                local part = minion.PrimaryPart
                if part and not part:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(minion, Color3.fromRGB(255,0,0), "Wire Eyes", part)
                    SetupCharacter(minion, workspace.IGNORE, part)
                end
            end
        end
    end
end

local function ClearESPs()
    for i = #getgenv().ESPs, 1, -1 do
        local esp = getgenv().ESPs[i]
        if esp.Highlight then pcall(function() esp.Highlight:Destroy() end) end
        if esp.Billboard then pcall(function() esp.Billboard:Destroy() end) end
        if esp.Background then pcall(function() esp.Background:Destroy() end) end
        if esp.Line then 
            pcall(function() 
                esp.Line.Visible = false
                esp.Line:Remove()
            end) 
        end
        table.remove(getgenv().ESPs, i)
    end
end

-- ==================== MAIN LOOP ====================

RunService.RenderStepped:Connect(function()
    if getgenv().Camera then
        local cameraPosition = getgenv().Camera.CFrame.Position
        local screenCenter = Vector2.new(getgenv().Camera.ViewportSize.X / 2, getgenv().Camera.ViewportSize.Y / 2)
        
        for _, esp in ipairs(getgenv().ESPs) do
            local part = esp.Part
            local highlight = esp.Highlight
            local billboard = esp.Billboard
            local label = esp.Label
            local background = esp.Background
            local line = esp.Line
            
            if not part or not highlight or not billboard or not label then continue end
            if part and part.Parent and highlight and billboard then
                local distance = (cameraPosition - part.Position).Magnitude
                local screenPos, onScreen = getgenv().Camera:WorldToViewportPoint(part.Position)
                local withinRange = getgenv().DisableLimitRangerEsp or distance <= getgenv().LimitRangerEsp

                highlight.Enabled = withinRange and onScreen
                billboard.Enabled = withinRange and onScreen
                
                if background then
                    background.Visible = withinRange and onScreen
                end

                if getgenv().ActiveDistanceEsp then
                    label.Text = esp.Text .. " (" .. math.floor(distance + 0.5) .. "m)"
                else
                    label.Text = esp.Text
                end

                if getgenv().LineESPEnabled then
                    if onScreen and withinRange then
                        line.Visible = true
                        line.From = screenCenter
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            else
                if line then line.Visible = false end
            end
        end
    end

    if game.Players.LocalPlayer.Character then
        if getgenv().AutoBarricade then
            local dot = getNewestDot()
            if dot then 
                local container = dot:FindFirstChild("Container")
                if container then
                    local frame = container:FindFirstChild("Frame")
                    local box = container:FindFirstChild("Box")
                    if frame and box then
                        local boxAbs = box.AbsolutePosition
                        local boxSize = box.AbsoluteSize
                        local conAbs = container.AbsolutePosition
                        frame.Position = UDim2.new(
                            0, (boxAbs.X + boxSize.X * 0.5) - conAbs.X,
                            0, (boxAbs.Y + boxSize.Y * 0.5) - conAbs.Y
                        )
                    end
                end
            end
        end

        if getgenv().ActiveInfiniteStamina then
            local mx = game.Players.LocalPlayer.Character:GetAttribute("MaxStamina") or 100
            if (game.Players.LocalPlayer.Character:GetAttribute("Stamina") or mx) < mx then
                game.Players.LocalPlayer.Character:SetAttribute("Stamina", mx)
            end
        end

        if getgenv().AutoShakeWireEyes and getgenv().CanShake then
            local existing = game.Players.LocalPlayer.PlayerGui:FindFirstChild("WireyesUI")
            if existing then
                doShake(existing)
            end
        end

        if getgenv().NoBlindness then
            if game:GetService("ReplicatedStorage").Modules.BlindnessModule:FindFirstChildOfClass("Atmosphere") then
                local atm = game:GetService("ReplicatedStorage").Modules.BlindnessModule:FindFirstChildOfClass("Atmosphere")
                atm.Glare = 0
                atm.Offset = 0
                atm.Density = 0
                atm.Haze = 0
            end
        end

        if getgenv().FullBright then
            local Lighting = game:GetService("Lighting")
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            if Lighting:FindFirstChildOfClass("Atmosphere") then
                Lighting:FindFirstChildOfClass("Atmosphere").Density = 0
            end
        end

        if getgenv().NoFog then
            local Atmosphere = Instance.new("Atmosphere")
            Atmosphere.Density = 0
            Atmosphere.Glare = 0
            Atmosphere.Parent = workspace
        end

        if getgenv().AutoSafeSpot then
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 35 then
                getgenv().SavedCFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
            end
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 35 then
                game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(0,500,0)
            end
        end

        if getgenv().ActiveSpeedBoost then
            game.Players.LocalPlayer.Character:SetAttribute("RunSpeed", getgenv().ValueRunSpeed)
        end

        if getgenv().ActiveSpeedBoost2 then
            game.Players.LocalPlayer.Character:SetAttribute("WalkSpeed", getgenv().ValueWalkSpeed)
        end

        if getgenv().AutoGen then
            if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Gen") then
                game:GetService("Players").LocalPlayer.PlayerGui.Gen.GeneratorMain.Event:FireServer(true)
            end
        end

        if getgenv().AutoEscape and not getgenv().Teleported and workspace.GAME.CAN_ESCAPE.Value == true then
            if workspace.MAPS:FindFirstChild("GAME MAP") then
                if game.Players.LocalPlayer.Character.Parent == workspace.PLAYERS.ALIVE then
                    for _, Part in pairs(workspace.MAPS:FindFirstChild("GAME MAP"):FindFirstChild("Escapes"):GetChildren()) do
                        if Part and Part:IsA("BasePart") and Part:GetAttribute("Enabled") and Part:FindFirstChildOfClass("Highlight") and Part:FindFirstChildOfClass("Highlight").Enabled then
                            if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                getgenv().Teleported = true
                                game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                                game.Players.LocalPlayer.Character.PrimaryPart.CFrame = Part.CFrame
                                task.spawn(function()
                                    task.wait(0.15)
                                    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
                                end)
                                task.wait(10)
                                getgenv().Teleported = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ==================== EVENT LISTENERS ====================

workspace.DescendantAdded:Connect(function(child) 
    local HrpPlayer = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if child:IsA("BoxHandleAdornment") then
        local Character = game.Players.LocalPlayer.Character
        if getgenv().FighterAutoParry and HrpPlayer and getgenv().CanParry and Character and not Character:GetAttribute("IFrames") and not Character:GetAttribute("InAbility") and not Character:GetAttribute("Stun") and Character:GetAttribute("Team") == "Survivor" and Character:GetAttribute("Character") == "Survivor-Fighter" then
            local Distance = (child.CFrame.Position - HrpPlayer.Position).Magnitude
            if Distance <= 10 then
                getgenv().CanParry = false
                task.spawn(function()
                    task.spawn(function()
                        task.wait(0.5)
                        getgenv().CanParry = true
                    end)
                    local Module = require(game:GetService("ReplicatedStorage").Modules.Warp).Client("Input")
                    if Module then
                        Module:Fire(true,{"Ability",2})
                    end
                end)
            end
        end
        
        if getgenv().HitboxExpender then
            child.Size = Vector3.new(getgenv().ValueHE, getgenv().ValueHE, getgenv().ValueHE)
        end
    end

    task.spawn(function()
        task.wait(0.75)

        if getgenv().ActiveNoCooldownPrompt then
            if child:IsA("ProximityPrompt") and child.HoldDuration ~= 0.1 then
                child:SetAttribute("HoldDurationOld", child.HoldDuration)
                child.HoldDuration = 0.1
            end  
        end
    end)

    if getgenv().ActiveEspSurvivors then 
        local GetPByChar = game:GetService("Players"):GetPlayerFromCharacter(child)
        if child.Parent == workspace.PLAYERS.ALIVE and child:IsA("Model") and child.PrimaryPart and not child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
            if GetPByChar then
                if child:FindFirstChildOfClass("Highlight") then
                    child:FindFirstChildOfClass("Highlight"):Destroy()
                end
                SetupCharacter(child, workspace.PLAYERS.ALIVE, child.PrimaryPart)
                CreateEsp(child, Color3.fromRGB(0,255,0), child.Name, child.PrimaryPart)
            end
        end
    end

    if getgenv().ActiveEspKillers then
        local GetPByChar = game:GetService("Players"):GetPlayerFromCharacter(child)
        if child.Parent and child.Parent == workspace.PLAYERS.KILLER and child:IsA("Model") and child:FindFirstChild("RootPart") and not child.RootPart:FindFirstChildOfClass("BillboardGui") then
            if GetPByChar then
                if child:FindFirstChildOfClass("Highlight") then
                    child:FindFirstChildOfClass("Highlight"):Destroy()
                end
                SetupCharacter(child, workspace.PLAYERS.KILLER, child.RootPart)
                CreateEsp(child, Color3.fromRGB(255,0,0), child.Name, child.RootPart)
            end
        end
    end

    if getgenv().ActiveEspGen then
        if workspace.MAPS:FindFirstChild("GAME MAP") then
            if child.Parent and child.Parent == workspace.MAPS["GAME MAP"].Generators and child:IsA("Model") and child.PrimaryPart and not child:FindFirstChildOfClass("Highlight") and not child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                CreateEsp(child, Color3.fromRGB(255,255,0), "Generator", child.PrimaryPart)
            end
        end
    end

    if getgenv().ActiveEspFuseBoxes then
        if workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("FuseBoxes") then
            if child.Parent and child.Parent == workspace.MAPS["GAME MAP"].FuseBoxes and child:IsA("Model") and child.PrimaryPart and not child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                if child:FindFirstChildOfClass("Highlight") then
                    child:FindFirstChildOfClass("Highlight"):Destroy()
                end
                CreateEsp(child, Color3.fromRGB(0,0,255), "Fuse Boxe", child.PrimaryPart)
            end
        end
    end

    if getgenv().ActiveEspTraps then
        if child.Parent and child.Name == "Trap" and child.Parent == workspace.IGNORE and child:IsA("Model") and child.PrimaryPart and not child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
            if child:FindFirstChildOfClass("Highlight") then
                child:FindFirstChildOfClass("Highlight"):Destroy()
            end
            CreateEsp(child, Color3.fromRGB(255,0,0), "Trap", child.PrimaryPart)
        end
    end

    if getgenv().ActiveEspWireEyes then
        if child.Parent and child.Name == "Minion" and child.Parent == workspace.IGNORE and child:IsA("Model") and child.PrimaryPart and not child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
            if child:FindFirstChildOfClass("Highlight") then
                child:FindFirstChildOfClass("Highlight"):Destroy()
            end
            SetupCharacter(child, workspace.IGNORE, child.PrimaryPart)
            CreateEsp(child, Color3.fromRGB(255,0,0), "Wire Eyes", child.PrimaryPart)
        end
    end

    if getgenv().ActiveEspBattery then
        if child.Parent and child.Name == "Battery" and child.Parent == workspace.IGNORE and child:IsA("BasePart") and not child:FindFirstChildOfClass("BillboardGui") then
            if child:FindFirstChildOfClass("Highlight") then
                child:FindFirstChildOfClass("Highlight"):Destroy()
            end
            CreateEsp(child, Color3.fromRGB(0,0,255), "Battery", child)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(child)
    if child:IsA("Model") then
        if getgenv().ActiveEspSurvivors then
            if child:IsDescendantOf(workspace.PLAYERS.ALIVE) and child.PrimaryPart then
                if child:FindFirstChildOfClass("Highlight") and child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(child, child.PrimaryPart)
                end
            end
        end

        if getgenv().ActiveEspKillers then
            if child:IsDescendantOf(workspace.PLAYERS.KILLER) and child:FindFirstChild("RootPart") then
                if child:FindFirstChildOfClass("Highlight") and child.RootPart:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(child, child.RootPart)
                end
            end
        end

        if getgenv().ActiveEspGen and workspace.MAPS:FindFirstChild("GAME MAP") then
            local map = workspace.MAPS["GAME MAP"]
            if child:IsDescendantOf(map.Generators) and child.PrimaryPart then
                if child:FindFirstChildOfClass("Highlight") and child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(child, child.PrimaryPart)
                end
            end
        end

        if getgenv().ActiveEspFuseBoxes and workspace.MAPS:FindFirstChild("GAME MAP") and workspace.MAPS["GAME MAP"]:FindFirstChild("FuseBoxes") then
            local map = workspace.MAPS["GAME MAP"]
            if child:IsDescendantOf(map.FuseBoxes) and child.PrimaryPart then
                if child:FindFirstChildOfClass("Highlight") and child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(child, child.PrimaryPart)
                end
            end
        end

        if getgenv().ActiveEspTraps then
            if child:IsDescendantOf(workspace.IGNORE) and child.Name == "Trap" and child.PrimaryPart then
                if child:FindFirstChildOfClass("Highlight") and child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(child, child.PrimaryPart)
                end
            end
        end

        if getgenv().ActiveEspWireEyes then
            if child:IsDescendantOf(workspace.IGNORE) and child.Name == "Minion" and child.PrimaryPart then
                if child:FindFirstChildOfClass("Highlight") and child.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(child, child.PrimaryPart)
                end
            end
        end
    elseif child:IsA("BasePart") then
        if getgenv().ActiveEspBattery then
            if child:IsDescendantOf(workspace.IGNORE) and child.Name == "Battery" then
                if child:FindFirstChildOfClass("Highlight") and child:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(child, child)
                end
            end
        end
    end
end)


-- ==================== MAIN TAB ====================

MainTab:Button({
    Title = "Delete Doors",
    Callback = function()
        if workspace.MAPS:FindFirstChild("GAME MAP") then
            if game.Workspace.MAPS["GAME MAP"].Doors then 
                game.Workspace.MAPS["GAME MAP"].Doors:Destroy()
            end
        end
    end,
})

MainTab:Toggle({
    Title = "Auto Generator",
    Default = false,
    Callback = function(v)
        getgenv().AutoGen = v
    end
})

MainTab:Toggle({
    Title = "Fighter - Auto Parry",
    Default = false,
    Callback = function(v)
        getgenv().FighterAutoParry = v
    end
})

MainTab:Toggle({
    Title = "Auto Barricade",
    Default = false,
    Callback = function(v)
        getgenv().AutoBarricade = v
    end
})

MainTab:Toggle({
    Title = "Auto Safe spot",
    Default = false,
    Callback = function(v)
        getgenv().AutoSafeSpot = v
        if not v and game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = getgenv().SavedCFrame
        end
    end
})

MainTab:Toggle({
    Title = "Instant Prompt",
    Default = false,
    Callback = function(v)
        getgenv().ActiveNoCooldownPrompt = v 
    end
})

MainTab:Slider({
    Title = "Hitbox Size",
    Min = 15,
    Max = 30,
    Default = getgenv().ValueHE,
    Callback = function(v)
        getgenv().ValueHE = v
    end,
})

MainTab:Toggle({
    Title = "Active Hitbox Expender",
    Default = false,
    Callback = function(v)
        getgenv().HitboxExpender = v
    end,
})

MainTab:Toggle({
    Title = "Big Distance Prompt",
    Default = false,
    Callback = function(v)
        getgenv().ActiveBigPrompt = v 
    end
})

MainTab:Toggle({
    Title = "Auto Escape",
    Default = false,
    Callback = function(v)
        getgenv().AutoEscape = v 
    end
})

MainTab:Toggle({
    Title = "Auto Shake Wire Eyes",
    Default = false,
    Callback = function(v)
        getgenv().AutoShakeWireEyes = v 
    end
})

-- ==================== PLAYER TAB ====================

PlayerTab:Slider({
    Title = "Run Speed",
    Min = 24,
    Max = 50,
    Default = getgenv().ValueRunSpeed,
    Callback = function(v)
        getgenv().ValueRunSpeed = v
        game.Players.LocalPlayer.Character:SetAttribute("RunSpeed", v)
    end,
})

PlayerTab:Toggle({
    Title = "Active Modifying Run Speed",
    Default = false,
    Callback = function(v)
        getgenv().ActiveSpeedBoost = v
    end,
})

PlayerTab:Slider({
    Title = "Walk Speed",
    Min = 15,
    Max = 50,
    Default = getgenv().ValueWalkSpeed,
    Callback = function(v)
        getgenv().ValueWalkSpeed = v
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

PlayerTab:Toggle({
    Title = "Active Modifying Walk Speed",
    Default = false,
    Callback = function(v)
        getgenv().ActiveSpeedBoost2 = v
    end,
})

PlayerTab:Toggle({
    Title = "Infinite Stamina",
    Default = false,
    Callback = function(v)
        getgenv().ActiveInfiniteStamina = v
    end,
})

-- ==================== ESP TAB ====================

EspTab:Toggle({
    Title = "Esp Survivors",
    Default = false,
    Callback = function(v)
        getgenv().ActiveEspSurvivors = v
        if v then
            ScanForSurvivors()
        else
            ClearESPs()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Killers",
    Default = false,
    Callback = function(v)
        getgenv().ActiveEspKillers = v
        if v then
            ScanForKillers()
        else
            ClearESPs()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Generators",
    Default = false,
    Callback = function(v)
        getgenv().ActiveEspGen = v 
        if v then
            ScanForGenerators()
        else
            ClearESPs()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Fuse Boxes",
    Default = false,
    Callback = function(v)
        getgenv().ActiveEspFuseBoxes = v 
        if v then
            ScanForFuseBoxes()
        else
            ClearESPs()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Battery",
    Default = false,
    Callback = function(v)
        getgenv().ActiveEspBattery = v 
        if v then
            ScanForBattery()
        else
            ClearESPs()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Traps",
    Default = false,
    Callback = function(v)
        getgenv().ActiveEspTraps = v 
        if v then
            ScanForTraps()
        else
            ClearESPs()
        end
    end
})

EspTab:Toggle({
    Title = "Esp Wire Eyes",
    Default = false,
    Callback = function(v)
        getgenv().ActiveEspWireEyes = v 
        if v then
            ScanForWireEyes()
        else
            ClearESPs()
        end
    end
})

-- ==================== DISCORD TAB ====================

DiscordTab:Button({
    Title = "Copy Discord Link",
    Callback = function() 	
        if setclipboard then
            setclipboard("https://discord.gg/E2TqYRsRP4")
        end
    end
})

-- ==================== SETTINGS TAB ====================

SettingsTab:Button({
    Title = "Unload Cheat",
    Callback = function()
        Window:Destroy()
    end,
})

SettingsTab:Slider({
    Title = "Limit Ranger for esp",
    Min = 25,
    Max = 1000,
    Default = 100,
    Callback = function(v)
        getgenv().LimitRangerEsp = v
    end,
})

SettingsTab:Toggle({
    Title = "Activate Distance For Esp",
    Default = false,
    Callback = function(v)
        getgenv().ActiveDistanceEsp = v 
    end
})

SettingsTab:Toggle({
    Title = "Line ESP",
    Default = false,
    Callback = function(v)
        getgenv().LineESPEnabled = v 
    end
})

SettingsTab:Button({
    Title = "Refresh ESP Quality",
    Callback = function()
        ClearESPs()
        if getgenv().ActiveEspSurvivors then ScanForSurvivors() end
        if getgenv().ActiveEspKillers then ScanForKillers() end
        if getgenv().ActiveEspGen then ScanForGenerators() end
        if getgenv().ActiveEspFuseBoxes then ScanForFuseBoxes() end
        if getgenv().ActiveEspBattery then ScanForBattery() end
        if getgenv().ActiveEspTraps then ScanForTraps() end
        if getgenv().ActiveEspWireEyes then ScanForWireEyes() end
    end,
})

MiscTab:Toggle({
    Title = "Full Bright",
    Default = false,
    Callback = function(v)
        getgenv().FullBright = v
        if not v then
            local Lighting = game:GetService("Lighting")
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.Brightness = 1
        end
    end
})

MiscTab:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(v)
        getgenv().NoFog = v
        if not v then
            local Atm = workspace:FindFirstChildOfClass("Atmosphere")
            if Atm then
                Atm:Destroy()
            end
        end
    end
})

MiscTab:Toggle({
    Title = "No Blindness",
    Default = false,
    Callback = function(v)
        getgenv().NoBlindness = v
        local atm = game:GetService("ReplicatedStorage").Modules.BlindnessModule:FindFirstChildOfClass("Atmosphere")
        if atm then
            if v then
                atm.Glare = 0
                atm.Offset = 0
                atm.Density = 0
                atm.Haze = 0
            else
                -- คืนค่าเดิมเมื่อปิด
                atm.Glare = 0.4
                atm.Offset = 0.25
                atm.Density = 0.3
                atm.Haze = 0
            end
        end
    end
})

MiscTab:Toggle({
    Title = "Disable Limit Ranger Esp",
    Default = false,
    Callback = function(v)
        getgenv().DisableLimitRangerEsp = v 
    end
})
