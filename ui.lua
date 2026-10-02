-- ==================== BlackCrown-X v2 (UI Reorganized + Action Bottom Bar) ====================
-- Changes from v2:
--   1. LocalPlayerTab: รวม Fly Speed + flyToggle เข้า Movement Section เดียวกัน
--      ลำดับใหม่: Movement → Speed Lock → Auto-Save → Mobile Quick Actions
--   2. MiscTab: ย้าย SafetySection ไปท้ายสุด (Tools → Speed → Emote → Safety)
--   3. เพิ่ม SettingsTab: Quick Buttons + Action Bottom Bar + Keybind + Theme
--   4. ACTION BOTTOM BAR: ปุ่ม fixed ล่างจอ ลากไม่ได้ เพิ่ม/ลบจาก Settings ได้

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local rs = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ProximityService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local p = game:GetService("Players").LocalPlayer

-- Anti AFK
localPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
end)

-- Instant Proximity Prompt
ProximityService.PromptShown:Connect(function(prompt)
    prompt.HoldDuration = 0
end)

-- ==================== VARIABLES ====================
local selectedPlayerName = ""
local tweenBehindDistance = 5
local isTweeningBehind = false
local safeModeEnabled = false
local safeModeLocation = Vector3.new(0, 50, 0)

local defaultSpeed = 16
local customSpeed = nil
local speedConnection

task.spawn(function()
    local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then defaultSpeed = hum.WalkSpeed end
end)

local function setSpeedLock(speed)
    local char = localPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = speed
        if speedConnection then speedConnection:Disconnect() end
        speedConnection = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if hum.WalkSpeed ~= speed then hum.WalkSpeed = speed end
        end)
    end
end

local function getPlayerList()
    local list = {}
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= localPlayer then table.insert(list, plr.Name) end
    end
    if #list == 0 then table.insert(list, "None") end
    return list
end

-- ==================== EMOTE MIRROR SYSTEM ====================
local emoteTargetPlayerName = ""
local isCopyingPlayerEmote = false
local mirrorConnection = nil
local customEmoteIdInput = ""
local customTrack = nil
local isPlayingCustomEmote = false

local function stopMirroring()
    if mirrorConnection then mirrorConnection:Disconnect(); mirrorConnection = nil end
end

local function getMotors(character)
    local motors = {}
    if not character then return motors end
    for _, desc in ipairs(character:GetDescendants()) do
        if desc:IsA("Motor6D") then motors[desc.Name] = desc end
    end
    return motors
end

local function startMirroringTarget(targetPlayerName)
    stopMirroring()
    mirrorConnection = rs.RenderStepped:Connect(function()
        if not isCopyingPlayerEmote then stopMirroring(); return end
        local targetPlayer = players:FindFirstChild(targetPlayerName)
        local myChar = localPlayer.Character
        if targetPlayer and targetPlayer.Character and myChar then
            local targetMotors = getMotors(targetPlayer.Character)
            local myMotors = getMotors(myChar)
            for name, targetMotor in pairs(targetMotors) do
                local myMotor = myMotors[name]
                if myMotor then myMotor.Transform = targetMotor.Transform end
            end
        end
    end)
end

local function playEmoteById(animId)
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local animator = hum:FindFirstChildOfClass("Animator") or hum
    local cleanId = tostring(animId):gsub("%D", "")
    if cleanId == "" then return nil end
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. cleanId
    local success, track = pcall(function() return animator:LoadAnimation(anim) end)
    if success and track then track:Play(); return track end
    return nil
end

local function stopCustomEmotes()
    if customTrack then customTrack:Stop(); customTrack = nil end
end

-- ==================== TWEEN SYSTEM ====================
local tweenDirection = "Behind"
local tweenDistance = 5
local isTweeningRelative = false
local isAutoLooking = false
local createPlatform = true
local tempPlatform = nil

local function getTargetOffsetPosition(targetHRP, direction, distance)
    local targetCF = targetHRP.CFrame
    if direction == "Front"  then return (targetCF * CFrame.new(0, 0, -distance)).Position
    elseif direction == "Behind" then return (targetCF * CFrame.new(0, 0,  distance)).Position
    elseif direction == "Above"  then return (targetCF * CFrame.new(0,  distance, 0)).Position
    elseif direction == "Below"  then return (targetCF * CFrame.new(0, -distance, 0)).Position
    elseif direction == "Left"   then return (targetCF * CFrame.new(-distance, 0, 0)).Position
    elseif direction == "Right"  then return (targetCF * CFrame.new( distance, 0, 0)).Position
    end
    return (targetCF * CFrame.new(0, 0, distance)).Position
end

local function updatePlatform(targetPosition)
    if not createPlatform then
        if tempPlatform then tempPlatform:Destroy(); tempPlatform = nil end
        return
    end
    if not tempPlatform or not tempPlatform.Parent then
        tempPlatform = Instance.new("Part")
        tempPlatform.Name = "TweenPlatform"
        tempPlatform.Size = Vector3.new(6, 1, 6)
        tempPlatform.Anchored = true
        tempPlatform.CanCollide = true
        tempPlatform.Material = Enum.Material.SmoothPlastic
        tempPlatform.Color = Color3.fromRGB(0, 170, 255)
        tempPlatform.Transparency = 0.4
        tempPlatform.Parent = workspace
    end
    tempPlatform.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3.5, 0))
end

local function applyBodyVelocity(hrp, targetPos)
    local bv = hrp:FindFirstChild("TweenBodyVelocity")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "TweenBodyVelocity"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Parent = hrp
    end
    bv.Velocity = (targetPos - hrp.Position) * 5
end

local function removeBodyVelocity(hrp)
    if hrp then
        local bv = hrp:FindFirstChild("TweenBodyVelocity")
        if bv then bv:Destroy() end
    end
end

-- ==================== ANTI FLING ====================
local AntiFling = {}
AntiFling.Enabled = false
local MAX_VELOCITY = 90
local antiFlingConnection

local function getHRP()
    local char = localPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function AntiFling.Start()
    if antiFlingConnection then return end
    antiFlingConnection = RunService.Heartbeat:Connect(function()
        if not AntiFling.Enabled then return end
        local hrp = getHRP()
        if not hrp then return end
        if hrp.AssemblyLinearVelocity.Magnitude > MAX_VELOCITY then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function AntiFling.Stop()
    if antiFlingConnection then antiFlingConnection:Disconnect(); antiFlingConnection = nil end
end

-- ==================== NOCLIP ====================
local noclipEnabled = false
local noclipSteppedConn = nil

local function setNoclip(state)
    noclipEnabled = state
    if state then
        if not noclipSteppedConn then
            noclipSteppedConn = RunService.Stepped:Connect(function()
                if noclipEnabled and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA('BasePart') then part.CanCollide = false end
                    end
                end
            end)
        end
    else
        if noclipSteppedConn then noclipSteppedConn:Disconnect(); noclipSteppedConn = nil end
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass('Humanoid')
            if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end
    end
end

-- ==================== INFINITE JUMP ====================
local infiniteJumpEnabled = false
local jumpConnection = nil

local function setInfiniteJump(state)
    infiniteJumpEnabled = state
    if infiniteJumpEnabled then
        if not jumpConnection then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                if infiniteJumpEnabled and p and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        end
    else
        if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
    end
end

-- ==================== FLY SYSTEM ====================
local flySpeed = 50
local bodyGyro = nil
local bodyVelocity = nil
local flyConnection = nil
local flyControls = nil
local isFlying = false

local function startFly()
    if isFlying then return end
    isFlying = true
    local character = p.Character
    if not character or not character:FindFirstChild('HumanoidRootPart') then isFlying = false; return end
    local rootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    if humanoid then humanoid.PlatformStand = true end

    bodyGyro = Instance.new('BodyGyro', rootPart)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame

    bodyVelocity = Instance.new('BodyVelocity', rootPart)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    if not flyControls then
        local ok, result = pcall(function()
            return require(p.PlayerScripts:WaitForChild('PlayerModule', 5)):GetControls()
        end)
        if ok then flyControls = result end
    end

    flyConnection = RunService.RenderStepped:Connect(function()
        if not rootPart or not rootPart.Parent then return end
        if not bodyGyro or not bodyGyro.Parent then return end
        if not bodyVelocity or not bodyVelocity.Parent then return end
        local cam = workspace.CurrentCamera
        bodyGyro.CFrame = cam.CFrame
        if flyControls then
            local mv = flyControls:GetMoveVector()
            local dir = (cam.CFrame.LookVector * -mv.Z) + (cam.CFrame.RightVector * mv.X)
            bodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        end
    end)
end

local function stopFly()
    if not isFlying then return end
    isFlying = false
    local character = p.Character
    if character then
        local humanoid = character:FindFirstChildOfClass('Humanoid')
        if humanoid then humanoid.PlatformStand = false end
    end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
end

-- ==================== UI LOAD ====================
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then warn("Failed to load WindUI Library"); return end

local Window = WindUI:CreateWindow({
    Title = "BlackCrown-X",
    Icon = "door-open",
    Author = "by wdashsuicnsc and timxq_n.",
    Folder = "BlackCrown-X",
    OpenButton = {
        Title = "Open UI",
        Icon = "monitor",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true
    }
})

local ConfigManager = Window.ConfigManager
local mainConfig = ConfigManager:CreateConfig("settings")

-- ==================== TABS ====================
local MainTab       = Window:Tab({ Title = "Main",         Icon = "bird",       Locked = false })
local AimbotTab     = Window:Tab({ Title = "Aimbot",       Icon = "crosshair",  Locked = false })
local ESPTab        = Window:Tab({ Title = "ESP",          Icon = "eye",        Locked = false })
local TPTab         = Window:Tab({ Title = "Teleport",     Icon = "map-pin",    Locked = false })
local LocalPlayerTab = Window:Tab({ Title = "Local Player", Icon = "user" })
local MiscTab       = Window:Tab({ Title = "Misc",         Icon = "ellipsis",   Locked = false })
local SettingsTab   = Window:Tab({ Title = "Settings",     Icon = "settings" })

-- ==================== QUICK BUTTONS SYSTEM (DRAGGABLE) ====================
local QuickButtons = {}
local QuickButtonGui = nil
local quickButtonsLocked = false

local function saveQuickButtons()
    pcall(function()
        local data = {}
        for _, btn in ipairs(QuickButtons) do
            if btn.Frame and btn.Frame.Parent then
                table.insert(data, {
                    func  = btn.funcName,
                    x     = btn.Frame.Position.X.Offset,
                    y     = btn.Frame.Position.Y.Offset,
                    size  = btn.Frame.Size.X.Offset,
                    state = btn.state,
                })
            end
        end
        if writefile then writefile("BlackCrown-X/quickbuttons.json", game:GetService("HttpService"):JSONEncode(data)) end
    end)
end

local function createQuickButton(funcName, posX, posY, size, initState, onToggle)
    posX = posX or 100; posY = posY or 100; size = size or 65; initState = initState or false

    if not QuickButtonGui then
        QuickButtonGui = Instance.new("ScreenGui")
        QuickButtonGui.Name = "BCX_QuickButtons"
        QuickButtonGui.ResetOnSpawn = false
        QuickButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        QuickButtonGui.DisplayOrder = 999
        pcall(function() QuickButtonGui.Parent = game:GetService("CoreGui") end)
        if not QuickButtonGui.Parent then QuickButtonGui.Parent = p.PlayerGui end
    end

    local btnState = initState
    local btnData  = { funcName = funcName, state = btnState }

    local frame = Instance.new("Frame")
    frame.Name = "QB_" .. funcName
    frame.Size = UDim2.fromOffset(size, size)
    frame.Position = UDim2.fromOffset(posX, posY)
    frame.BackgroundColor3 = btnState and Color3.fromRGB(0,200,80) or Color3.fromRGB(35,35,45)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = QuickButtonGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = btnState and Color3.fromRGB(0,220,80) or Color3.fromRGB(80,80,100)
    stroke.Transparency = 0.5; stroke.Thickness = 1.5

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,-4, 0.72, 0)
    label.Position = UDim2.new(0, 2, 0.14, 0)
    label.BackgroundTransparency = 1
    label.Text = funcName
    label.TextColor3 = Color3.fromRGB(230,230,240)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    local dot = Instance.new("Frame", frame)
    dot.Size = UDim2.fromOffset(7, 7)
    dot.Position = UDim2.new(1,-10, 0, 4)
    dot.BackgroundColor3 = btnState and Color3.fromRGB(0,255,100) or Color3.fromRGB(100,100,120)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local dragging, dragStart, startPos = false, nil, nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos  = frame.Position
            dragging  = false
        end
    end)

    frame.InputChanged:Connect(function(input)
        if quickButtonsLocked then return end
        if (input.UserInputType == Enum.UserInputType.MouseMovement
        or  input.UserInputType == Enum.UserInputType.Touch) and startPos then
            local delta = input.Position - dragStart
            if delta.Magnitude > 8 then
                dragging = true
                frame.Position = UDim2.fromOffset(
                    startPos.X.Offset + delta.X,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false; startPos = nil
                saveQuickButtons()
            else
                -- tap = toggle
                btnState = not btnState
                btnData.state = btnState
                frame.BackgroundColor3 = btnState and Color3.fromRGB(0,200,80) or Color3.fromRGB(35,35,45)
                stroke.Color = btnState and Color3.fromRGB(0,220,80) or Color3.fromRGB(80,80,100)
                dot.BackgroundColor3 = btnState and Color3.fromRGB(0,255,100) or Color3.fromRGB(100,100,120)
                if onToggle then pcall(onToggle, btnState) end
                saveQuickButtons()
            end
            dragging = false; startPos = nil
        end
    end)

    btnData.Frame = frame
    table.insert(QuickButtons, btnData)
    return btnData
end

local function removeQuickButton(funcName)
    for i, btn in ipairs(QuickButtons) do
        if btn.funcName == funcName then
            pcall(function() btn.Frame:Destroy() end)
            table.remove(QuickButtons, i)
            saveQuickButtons(); return
        end
    end
end

local function removeAllQuickButtons()
    for _, btn in ipairs(QuickButtons) do pcall(function() btn.Frame:Destroy() end) end
    QuickButtons = {}
    saveQuickButtons()
end

local function loadQuickButtons(callbackMap)
    pcall(function()
        if not isfile or not isfile("BlackCrown-X/quickbuttons.json") then return end
        local raw = readfile("BlackCrown-X/quickbuttons.json")
        if not raw or #raw < 3 then return end
        local ok, data = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), raw)
        if not ok or type(data) ~= "table" then return end
        for _, btn in ipairs(QuickButtons) do pcall(function() btn.Frame:Destroy() end) end
        QuickButtons = {}
        for _, d in ipairs(data) do
            if d.func and callbackMap[d.func] then
                local btn = createQuickButton(d.func, d.x or 100, d.y or 100, d.size or 65, d.state or false, callbackMap[d.func])
                if d.state then pcall(callbackMap[d.func], d.state) end
            end
        end
    end)
end

-- ==================== ACTION BOTTOM BAR (NEW) ====================
-- Fixed ล่างจอ ลากไม่ได้ เรียงแนวนอน
local ActionBar = {}
local ActionBarGui = nil
local ActionBarFrame = nil
local ACTION_BTN_SIZE = 64
local ACTION_BTN_GAP  = 8
local ACTION_BAR_BOTTOM_OFFSET = 24  -- px จากขอบล่าง

local function saveActionBar()
    pcall(function()
        local data = {}
        for _, btn in ipairs(ActionBar) do
            table.insert(data, { func = btn.funcName, state = btn.state })
        end
        if writefile then writefile("BlackCrown-X/actionbar.json", game:GetService("HttpService"):JSONEncode(data)) end
    end)
end

local function rebuildActionBarLayout()
    if not ActionBarFrame then return end
    local count = #ActionBar
    if count == 0 then
        ActionBarFrame.Visible = false
        return
    end
    ActionBarFrame.Visible = true
    local totalW = count * ACTION_BTN_SIZE + (count - 1) * ACTION_BTN_GAP
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    ActionBarFrame.Size = UDim2.fromOffset(totalW, ACTION_BTN_SIZE)
    ActionBarFrame.Position = UDim2.fromOffset(
        math.floor((vp.X - totalW) / 2),
        vp.Y - ACTION_BTN_SIZE - ACTION_BAR_BOTTOM_OFFSET
    )
    -- reposition each child button
    for i, btn in ipairs(ActionBar) do
        if btn.BtnFrame then
            btn.BtnFrame.Position = UDim2.fromOffset((i-1) * (ACTION_BTN_SIZE + ACTION_BTN_GAP), 0)
        end
    end
end

local function createActionBarGui()
    if ActionBarGui then return end
    ActionBarGui = Instance.new("ScreenGui")
    ActionBarGui.Name = "BCX_ActionBar"
    ActionBarGui.ResetOnSpawn = false
    ActionBarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ActionBarGui.DisplayOrder = 998
    ActionBarGui.IgnoreGuiInset = true
    pcall(function() ActionBarGui.Parent = game:GetService("CoreGui") end)
    if not ActionBarGui.Parent then ActionBarGui.Parent = p.PlayerGui end

    ActionBarFrame = Instance.new("Frame", ActionBarGui)
    ActionBarFrame.Name = "BCX_ActionBarFrame"
    ActionBarFrame.BackgroundTransparency = 1
    ActionBarFrame.BorderSizePixel = 0
    ActionBarFrame.Visible = false
end

local function addActionBarButton(funcName, initState, onToggle)
    createActionBarGui()

    -- ป้องกันซ้ำ
    for _, btn in ipairs(ActionBar) do
        if btn.funcName == funcName then return end
    end

    local btnState = initState or false
    local btnData  = { funcName = funcName, state = btnState }

    local frame = Instance.new("Frame", ActionBarFrame)
    frame.Name = "AB_" .. funcName
    frame.Size = UDim2.fromOffset(ACTION_BTN_SIZE, ACTION_BTN_SIZE)
    frame.BackgroundColor3 = btnState and Color3.fromRGB(0,200,80) or Color3.fromRGB(28,28,38)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = btnState and Color3.fromRGB(0,220,80) or Color3.fromRGB(70,70,90)
    stroke.Transparency = 0.4; stroke.Thickness = 1.5

    -- background glow when active
    local glow = Instance.new("Frame", frame)
    glow.Name = "Glow"
    glow.Size = UDim2.new(1,0,1,0)
    glow.BackgroundColor3 = Color3.fromRGB(0,255,80)
    glow.BackgroundTransparency = btnState and 0.85 or 1
    glow.BorderSizePixel = 0
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,-4, 0.72, 0)
    label.Position = UDim2.new(0, 2, 0.15, 0)
    label.BackgroundTransparency = 1
    label.Text = funcName
    label.TextColor3 = Color3.fromRGB(225,225,235)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.ZIndex = 2

    local dot = Instance.new("Frame", frame)
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.new(1,-9, 0, 4)
    dot.BackgroundColor3 = btnState and Color3.fromRGB(0,255,100) or Color3.fromRGB(90,90,110)
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    -- NO DRAG — กดอย่างเดียว
    local tapStart = 0
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            tapStart = tick()
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if tick() - tapStart < 0.5 then
                btnState = not btnState
                btnData.state = btnState
                frame.BackgroundColor3 = btnState and Color3.fromRGB(0,200,80) or Color3.fromRGB(28,28,38)
                stroke.Color = btnState and Color3.fromRGB(0,220,80) or Color3.fromRGB(70,70,90)
                glow.BackgroundTransparency = btnState and 0.85 or 1
                dot.BackgroundColor3 = btnState and Color3.fromRGB(0,255,100) or Color3.fromRGB(90,90,110)
                if onToggle then pcall(onToggle, btnState) end
                saveActionBar()
            end
        end
    end)

    btnData.BtnFrame = frame
    table.insert(ActionBar, btnData)
    rebuildActionBarLayout()
    saveActionBar()
end

local function removeActionBarButton(funcName)
    for i, btn in ipairs(ActionBar) do
        if btn.funcName == funcName then
            pcall(function() btn.BtnFrame:Destroy() end)
            table.remove(ActionBar, i)
            rebuildActionBarLayout()
            saveActionBar()
            return
        end
    end
end

local function removeAllActionBar()
    for _, btn in ipairs(ActionBar) do pcall(function() btn.BtnFrame:Destroy() end) end
    ActionBar = {}
    rebuildActionBarLayout()
    saveActionBar()
end

-- อัปเดตตำแหน่ง ActionBar เมื่อ viewport เปลี่ยน
RunService.Heartbeat:Connect(function()
    if ActionBarFrame and ActionBarFrame.Visible then
        rebuildActionBarLayout()
    end
end)

-- ==================== ESP SYSTEM ====================
local espNameEnabled = false
local espBoxEnabled = false
local espTracerEnabled = false
local espHighlightEnabled = false
local espHealthBarEnabled = false
local espHealthTextEnabled = false
local espMicEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)
local friendColor = Color3.fromRGB(0, 255, 128)
local espObjects = {}
local friendCache = {}
local hasDrawingAPI = (typeof(Drawing) == "table" and typeof(Drawing.new) == "function")

local function checkIsFriend(plr)
    if friendCache[plr.UserId] ~= nil then return friendCache[plr.UserId] end
    local isFriend = false
    pcall(function() isFriend = localPlayer:IsFriendsWith(plr.UserId) end)
    friendCache[plr.UserId] = isFriend
    return isFriend
end

local function removeESP(plr)
    if espObjects[plr] then
        if espObjects[plr].connection then espObjects[plr].connection:Disconnect() end
        if espObjects[plr].highlight then espObjects[plr].highlight:Destroy() end
        for _, key in ipairs({"boxOutline","boxInline","healthBarOutline","healthBarBG","healthBarFill","healthText","nameText","micText","tracer"}) do
            if espObjects[plr][key] then pcall(function() espObjects[plr][key]:Remove() end) end
        end
        espObjects[plr] = nil
    end
end

-- หาตัวละครปัจจุบันของผู้เล่นทุกเฟรม (รองรับ StreamingEnabled)
local function resolveCharacter(plr)
    local char = plr.Character
    if not (char and char.Parent) then
        local w = workspace:FindFirstChild(plr.Name)
        char = (w and w:IsA("Model")) and w or nil
    end
    if not (char and char.Parent) then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    return char, hrp, hum
end

local function createESP(plr)
    if espObjects[plr] then return end

    local activeColor = checkIsFriend(plr) and friendColor or espColor
    local highlight -- สร้างใหม่อัตโนมัติเมื่อตัวละครถูกสตรีมกลับมา

    local boxOutline, boxInline, healthBarOutline, healthBarBG, healthBarFill, healthText, nameText, micText, tracer
    if hasDrawingAPI then
        pcall(function()
            boxOutline = Drawing.new("Square"); boxOutline.Visible = false; boxOutline.Color = Color3.new(0,0,0); boxOutline.Thickness = 3
            boxInline  = Drawing.new("Square"); boxInline.Visible  = false; boxInline.Color  = activeColor; boxInline.Thickness = 1
            healthBarOutline = Drawing.new("Square"); healthBarOutline.Visible = false; healthBarOutline.Color = Color3.new(0,0,0); healthBarOutline.Thickness = 1; healthBarOutline.Filled = false
            healthBarBG   = Drawing.new("Square"); healthBarBG.Visible   = false; healthBarBG.Color   = Color3.fromRGB(30,30,30); healthBarBG.Filled = true
            healthBarFill = Drawing.new("Square"); healthBarFill.Visible = false; healthBarFill.Color = Color3.fromRGB(0,255,0);  healthBarFill.Filled = true
            healthText = Drawing.new("Text"); healthText.Visible = false; healthText.Color = Color3.fromRGB(255,255,255); healthText.Size = 12; healthText.Center = false; healthText.Outline = true
            nameText   = Drawing.new("Text"); nameText.Visible   = false; nameText.Color   = activeColor; nameText.Size = 14; nameText.Center = true; nameText.Outline = true
            micText    = Drawing.new("Text"); micText.Visible    = false; micText.Color    = Color3.fromRGB(255,255,255); micText.Size = 16; micText.Center = false; micText.Outline = true
            tracer     = Drawing.new("Line"); tracer.Visible     = false; tracer.Color     = activeColor; tracer.Thickness = 1.5
        end)
    end

    local function hideAll()
        if highlight then pcall(function() highlight.Enabled = false end) end
        for _, d in ipairs({boxOutline,boxInline,healthBarOutline,healthBarBG,healthBarFill,healthText,nameText,micText,tracer}) do
            if d then d.Visible = false end
        end
    end

    local conn = rs.RenderStepped:Connect(function()
        local charModel, hrpTarget, humanoidTarget = resolveCharacter(plr)
        if not charModel or humanoidTarget.Health <= 0 then
            hideAll()
            return
        end

        -- ถ้า Highlight ถูกทำลาย/ย้ายที่ตอนสตรีม ให้สร้างใหม่บนตัวละครปัจจุบัน
        if not highlight or highlight.Parent ~= charModel then
            if highlight then pcall(function() highlight:Destroy() end) end
            highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Enabled = false
            highlight.Parent = charModel
            if espObjects[plr] then espObjects[plr].highlight = highlight end
        end

        local currentColor = checkIsFriend(plr) and friendColor or espColor
        highlight.FillColor = currentColor
        highlight.Enabled   = espHighlightEnabled
        if boxInline  then boxInline.Color  = currentColor end
        if nameText   then nameText.Color   = currentColor end
        if tracer     then tracer.Color     = currentColor end

        if hasDrawingAPI then
            local pos, onScreen = camera:WorldToViewportPoint(hrpTarget.Position)
            if onScreen then
                local top, tOn    = camera:WorldToViewportPoint(hrpTarget.Position + Vector3.new(0,  2.5, 0))
                local bottom, bOn = camera:WorldToViewportPoint(hrpTarget.Position - Vector3.new(0,  3,   0))
                if tOn and bOn then
                    local boxHeight = math.abs(bottom.Y - top.Y)
                    local boxWidth  = boxHeight * 0.65
                    local minX, minY = pos.X - (boxWidth/2), top.Y
                    if espBoxEnabled and boxOutline and boxInline then
                        boxOutline.Size = Vector2.new(boxWidth, boxHeight); boxOutline.Position = Vector2.new(minX, minY); boxOutline.Visible = true
                        boxInline.Size  = Vector2.new(boxWidth, boxHeight); boxInline.Position  = Vector2.new(minX, minY); boxInline.Visible  = true
                    else
                        if boxOutline then boxOutline.Visible = false end
                        if boxInline  then boxInline.Visible  = false end
                    end
                    if espHealthBarEnabled and healthBarOutline and healthBarBG and healthBarFill then
                        local hp = math.clamp(humanoidTarget.Health / humanoidTarget.MaxHealth, 0, 1)
                        local barX = minX - 9
                        local barColor = hp <= 0.2 and Color3.fromRGB(255,0,0) or hp <= 0.5 and Color3.fromRGB(255,200,0) or Color3.fromRGB(0,255,0)
                        local fillH = math.floor(boxHeight * hp)
                        healthBarBG.Size = Vector2.new(3, boxHeight); healthBarBG.Position = Vector2.new(barX, minY); healthBarBG.Visible = true
                        healthBarFill.Size = Vector2.new(3, fillH); healthBarFill.Position = Vector2.new(barX, minY+(boxHeight-fillH)); healthBarFill.Color = barColor; healthBarFill.Visible = true
                        healthBarOutline.Size = Vector2.new(5, boxHeight+2); healthBarOutline.Position = Vector2.new(barX-1, minY-1); healthBarOutline.Visible = true
                        if espHealthTextEnabled and healthText then
                            healthText.Text = string.format("%d%%", math.floor(hp*100))
                            healthText.Position = Vector2.new(barX-25, minY+(boxHeight-fillH)-4)
                            healthText.Color = barColor; healthText.Visible = true
                        elseif healthText then healthText.Visible = false end
                    else
                        for _, d in ipairs({healthBarOutline,healthBarBG,healthBarFill,healthText}) do if d then d.Visible = false end end
                    end
                    if espMicEnabled and micText then
                        local voiceInst = charModel:FindFirstChild("VoiceSource", true) or charModel:FindFirstChildWhichIsA("AudioEmitter", true)
                        if voiceInst then
                            micText.Text = "🎤"
                            micText.Color = (voiceInst:IsA("Sound") and voiceInst.PlaybackLoudness > 5) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,255,255)
                            micText.Position = Vector2.new(minX+boxWidth+4, minY); micText.Visible = true
                        else micText.Visible = false end
                    elseif micText then micText.Visible = false end
                    if espNameEnabled and nameText then
                        local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local dist = myHRP and math.floor((hrpTarget.Position - myHRP.Position).Magnitude) or 0
                        nameText.Text = string.format("%s [%dm]", plr.Name, dist)
                        nameText.Position = Vector2.new(pos.X, minY-18); nameText.Visible = true
                    elseif nameText then nameText.Visible = false end
                end
                if espTracerEnabled and tracer then
                    tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                    tracer.To = Vector2.new(pos.X, pos.Y); tracer.Visible = true
                elseif tracer then tracer.Visible = false end
            else
                for _, d in ipairs({boxOutline,boxInline,healthBarOutline,healthBarBG,healthBarFill,healthText,nameText,micText,tracer}) do
                    if d then d.Visible = false end
                end
            end
        end
    end)

    espObjects[plr] = {
        highlight=highlight, boxOutline=boxOutline, boxInline=boxInline,
        healthBarOutline=healthBarOutline, healthBarBG=healthBarBG, healthBarFill=healthBarFill,
        healthText=healthText, nameText=nameText, micText=micText, tracer=tracer, connection=conn
    }
end

-- คงชื่อเดิมไว้เผื่อที่อื่นเรียกใช้ (ตอนนี้ไม่ต้องรีเซ็ตทุกครั้งที่ตัวละครเปลี่ยน)
local function applyESPToCharacter(plr, charModel)
    createESP(plr)
end

for _, plr in ipairs(players:GetPlayers()) do
    if plr ~= localPlayer then createESP(plr) end
end
players.PlayerAdded:Connect(function(plr)
    if plr ~= localPlayer then createESP(plr) end
end)
players.PlayerRemoving:Connect(function(plr)
    friendCache[plr.UserId] = nil
    removeESP(plr)
end)

-- ==================== OBJECT SEARCH ESP ====================
local searchTargetText = ""
local exactMatchEnabled = false
local partialMatchEnabled = false
local objectEspColor = Color3.fromRGB(255, 255, 0)
local searchedObjects = {}

local function clearObjectESP()
    for obj, data in pairs(searchedObjects) do
        if data.highlight then pcall(function() data.highlight:Destroy() end) end
        for _, key in ipairs({"boxOutline","boxInline","nameText","tracer"}) do
            if data[key] then pcall(function() data[key]:Remove() end) end
        end
    end
    searchedObjects = {}
end

local function applyESPToObject(obj)
    if searchedObjects[obj] then return end
    local primaryPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
    if not primaryPart then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ObjESP_Highlight"
    highlight.FillColor = objectEspColor
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.Parent = obj
    local boxOutline, boxInline, nameText, tracer
    if hasDrawingAPI then
        pcall(function()
            boxOutline = Drawing.new("Square"); boxOutline.Visible = false; boxOutline.Color = Color3.new(0,0,0); boxOutline.Thickness = 3
            boxInline  = Drawing.new("Square"); boxInline.Visible  = false; boxInline.Color  = objectEspColor; boxInline.Thickness = 1
            nameText   = Drawing.new("Text");   nameText.Visible   = false; nameText.Color   = objectEspColor; nameText.Size = 14; nameText.Center = true; nameText.Outline = true
            tracer     = Drawing.new("Line");   tracer.Visible     = false; tracer.Color     = objectEspColor; tracer.Thickness = 1.5
        end)
    end
    searchedObjects[obj] = { highlight=highlight, boxOutline=boxOutline, boxInline=boxInline, nameText=nameText, tracer=tracer, part=primaryPart }
end

local function updateObjectESP()
    clearObjectESP()
    if searchTargetText == "" or (not exactMatchEnabled and not partialMatchEnabled) then return end
    local targetLower = string.lower(searchTargetText)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if localPlayer.Character and obj:IsDescendantOf(localPlayer.Character) then continue end
            local isMatch = false
            if exactMatchEnabled   then isMatch = obj.Name == searchTargetText
            elseif partialMatchEnabled then isMatch = string.find(string.lower(obj.Name), targetLower, 1, true) ~= nil end
            if isMatch then applyESPToObject(obj) end
        end
    end
end

rs.RenderStepped:Connect(function()
    if not (exactMatchEnabled or partialMatchEnabled) then return end
    for obj, data in pairs(searchedObjects) do
        if not obj or not obj.Parent or not data.part or not data.part.Parent then
            for _, key in ipairs({"boxOutline","boxInline","nameText","tracer"}) do
                if data[key] then pcall(function() data[key]:Remove() end) end
            end
            if data.highlight then pcall(function() data.highlight:Destroy() end) end
            searchedObjects[obj] = nil; continue
        end
        if hasDrawingAPI then
            local pos, onScreen = camera:WorldToViewportPoint(data.part.Position)
            if onScreen then
                local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                local dist  = myHRP and math.floor((data.part.Position - myHRP.Position).Magnitude) or 0
                local extents = obj:IsA("Model") and obj:GetExtentsSize() or data.part.Size
                local top, tOn    = camera:WorldToViewportPoint(data.part.Position + Vector3.new(0, extents.Y/2, 0))
                local bottom, bOn = camera:WorldToViewportPoint(data.part.Position - Vector3.new(0, extents.Y/2, 0))
                if tOn and bOn and data.boxOutline and data.boxInline then
                    local h = math.abs(top.Y - bottom.Y); local w = math.max(h*0.8, 15)
                    local tl = Vector2.new(pos.X-w/2, top.Y)
                    data.boxOutline.Size = Vector2.new(w,h); data.boxOutline.Position = tl; data.boxOutline.Visible = true
                    data.boxInline.Size  = Vector2.new(w,h); data.boxInline.Position  = tl; data.boxInline.Visible  = true
                end
                if data.nameText then data.nameText.Text = string.format("%s [%dm]", obj.Name, dist); data.nameText.Position = Vector2.new(pos.X, top.Y-18); data.nameText.Visible = true end
                if data.tracer   then data.tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); data.tracer.To = Vector2.new(pos.X, pos.Y); data.tracer.Visible = true end
            else
                for _, key in ipairs({"boxOutline","boxInline","nameText","tracer"}) do if data[key] then data[key].Visible = false end end
            end
        end
    end
end)

-- ==================== AIMBOT ====================
local aimbotEnabled = false
local aimbotTargetPart = "Head"
local aimbotSmoothness = 1
local wallCheckEnabled = false
local fovEnabled = false
local fovRadius = 150
local fovColor = Color3.fromRGB(255, 255, 255)

local fovCircle
if hasDrawingAPI then
    pcall(function()
        fovCircle = Drawing.new("Circle"); fovCircle.Visible = false; fovCircle.Thickness = 1.5
        fovCircle.NumSides = 64; fovCircle.Filled = false; fovCircle.Color = fovColor; fovCircle.Transparency = 0.8
    end)
end

local function isVisible(targetPart, targetCharacter)
    if not wallCheckEnabled then return true end
    local origin = camera.CFrame.Position
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = {localPlayer.Character, camera}
    rp.IgnoreWater = true
    local result = workspace:Raycast(origin, targetPart.Position - origin, rp)
    if result then
        local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
        return hitModel == targetCharacter
    end
    return true
end

local function getClosestPlayerToCursor()
    local closestPlayer, shortestDist = nil, math.huge
    local mouseLocation = UserInputService:GetMouseLocation()
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character then
            local targetPart = plr.Character:FindFirstChild(aimbotTargetPart)
            local humanoid   = plr.Character:FindFirstChild("Humanoid")
            if targetPart and humanoid and humanoid.Health > 0 then
                local sp, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(sp.X, sp.Y) - mouseLocation).Magnitude
                    if (not fovEnabled or dist <= fovRadius) and isVisible(targetPart, plr.Character) and dist < shortestDist then
                        shortestDist = dist; closestPlayer = plr
                    end
                end
            end
        end
    end
    return closestPlayer
end

rs.RenderStepped:Connect(function()
    local ml = UserInputService:GetMouseLocation()
    if fovCircle then fovCircle.Position = ml; fovCircle.Radius = fovRadius; fovCircle.Color = fovColor; fovCircle.Visible = aimbotEnabled and fovEnabled end
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerToCursor()
        if target and target.Character then
            local part = target.Character:FindFirstChild(aimbotTargetPart)
            if part then
                local cur = camera.CFrame
                camera.CFrame = cur:Lerp(CFrame.new(cur.Position, part.Position), 1 / math.max(aimbotSmoothness, 1))
            end
        end
    end
end)

-- ==================== DRAG PLAYER ====================
local dragTargetName = ""
local dragActive = false
local dragConn = nil

local function setTargetNoclip(targetName, state)
    local target = players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    for _, part in pairs(target.Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = not state end
    end
end

local function cleanTargetPhysics(targetName)
    local target = players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    local tgtHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not tgtHRP then return end
    for _, obj in pairs(tgtHRP:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") or obj:IsA("BodyPosition")
        or obj:IsA("BodyForce")    or obj:IsA("VectorForce") or obj:IsA("LinearVelocity") then obj:Destroy() end
    end
    pcall(function() tgtHRP.AssemblyLinearVelocity = Vector3.zero; tgtHRP.AssemblyAngularVelocity = Vector3.zero end)
end

local function startDrag(targetName)
    local target = players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    local myHRP  = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tgtHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP or not tgtHRP then return end
    myHRP.CFrame = tgtHRP.CFrame * CFrame.new(0, 0, 2)
    task.wait(0.2)
    setNoclip(true); setTargetNoclip(targetName, true); cleanTargetPhysics(targetName)
    if dragConn then dragConn:Disconnect(); dragConn = nil end
    dragConn = rs.Heartbeat:Connect(function()
        if not dragActive then return end
        local curHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local curTgt = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not curHRP or not curTgt then return end
        curTgt.CFrame = curHRP.CFrame * CFrame.new(0, 0, 2)
        setTargetNoclip(targetName, true)
    end)
    task.wait(0.1); startFly()
end

local function stopDrag(targetName)
    dragActive = false
    if dragConn then dragConn:Disconnect(); dragConn = nil end
    stopFly(); cleanTargetPhysics(targetName); setTargetNoclip(targetName, false); setNoclip(false)
end

-- ==================== WAYPOINT SYSTEM ====================
local HttpService = game:GetService("HttpService")
local PlaceId = tostring(game.PlaceId)
local FolderName = "Script_Waypoints"
local FilePath = FolderName .. "/" .. PlaceId .. ".json"
local waypointsData = {}
local currentInputName = ""
local selectedWaypointName = ""
local waypointDropdown = nil
local isRebuildingWaypoint = false

local function notify(title, desc, duration)
    if type(Notify) == "function" then Notify({ Title=title, Desc=desc, Duration=duration or 2 }) end
end

local function ensureFolder()
    if isfolder and not isfolder(FolderName) then pcall(makefolder, FolderName) end
end
local function saveWaypointsToFile()
    ensureFolder()
    if writefile then pcall(function() writefile(FilePath, HttpService:JSONEncode(waypointsData)) end) end
end
local function loadWaypointsFromFile()
    ensureFolder()
    if isfile and readfile and isfile(FilePath) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(FilePath))
            if type(decoded) == "table" then waypointsData = decoded end
        end)
    end
end
local function getWaypointNamesList()
    local names = {}
    for name in pairs(waypointsData) do table.insert(names, name) end
    table.sort(names)
    if #names == 0 then table.insert(names, "ไม่มีจุดเซฟ") end
    return names
end

loadWaypointsFromFile()

local refreshCooldown = false
local function safeRefresh(dropdown)
    if refreshCooldown then return end
    refreshCooldown = true
    task.delay(0.1, function() refreshCooldown = false end)
    local newList = getPlayerList()
    pcall(function() dropdown:Refresh(newList) end)
end

-- rebuildWaypointDropdown: ย้ายไปอยู่ใน UI section (WaypointSection) ด้านล่าง
-- ใช้ pattern destroy+recreate แทน :Refresh() — ดูใน rebuildWPDrop()

-- ==================== UI: AIMBOT TAB ====================
local AimbotSection = AimbotTab:Section({ Title = "Aimbot Core", Icon = "target" })
AimbotSection:Toggle({ Title="Enable Aimbot",    Desc="เปิดใช้งาน (คลิกขวาค้าง)", Default=false, Callback=function(s) aimbotEnabled=s end })
AimbotSection:Toggle({ Title="Wallcheck",        Desc="ไม่ล็อกเป้าถ้ามีกำแพงบัง",  Default=false, Callback=function(s) wallCheckEnabled=s end })
AimbotSection:Dropdown({ Title="Target Part",    Values={"Head","HumanoidRootPart"}, Value="Head", Callback=function(v) aimbotTargetPart=v end })
AimbotSection:Input({ Title="Smoothness",        Value="1", Placeholder="1=ล็อกทันที, 5=นุ่ม...", Callback=function(v) local n=tonumber(v); if n and n>0 then aimbotSmoothness=n end end })

-- FOV อยู่ใน section เดียวกับ Aimbot (ไม่แยก)
local FOVSection = AimbotTab:Section({ Title = "FOV Circle", Icon = "disc" })
FOVSection:Toggle({ Title="Enable FOV",        Default=false, Callback=function(s) fovEnabled=s end })
FOVSection:Input({  Title="FOV Radius",        Value="150",   Placeholder="เช่น 100, 150...", Callback=function(v) local n=tonumber(v); if n and n>0 then fovRadius=n end end })
FOVSection:Colorpicker({ Title="FOV Color",    Default=Color3.fromRGB(255,255,255), Callback=function(c) fovColor=c end })

-- ==================== UI: ESP TAB ====================
local ESPSettingsSection = ESPTab:Section({ Title = "Visual Toggles", Icon = "eye" })
ESPSettingsSection:Toggle({ Title="Name & Distance",  Default=false, Callback=function(s) espNameEnabled=s end })
ESPSettingsSection:Toggle({ Title="Box ESP",          Default=false, Callback=function(s) espBoxEnabled=s end })
ESPSettingsSection:Toggle({ Title="Health Bar",       Default=false, Callback=function(s) espHealthBarEnabled=s end })
ESPSettingsSection:Toggle({ Title="Health % Text",    Default=false, Callback=function(s) espHealthTextEnabled=s end })
ESPSettingsSection:Toggle({ Title="Tracer Line",      Default=false, Callback=function(s) espTracerEnabled=s end })
ESPSettingsSection:Toggle({ Title="Highlight",        Default=false, Callback=function(s) espHighlightEnabled=s end })
ESPSettingsSection:Toggle({ Title="Mic Indicator",    Default=false, Callback=function(s) espMicEnabled=s end })
-- สีอยู่ใน section เดียวกัน — ไม่แยก section ใหม่
ESPSettingsSection:Colorpicker({ Title="Enemy / Default Color", Default=Color3.fromRGB(255,0,0),   Callback=function(c) espColor=c end })
ESPSettingsSection:Colorpicker({ Title="Friend Color",          Default=Color3.fromRGB(0,255,128), Callback=function(c) friendColor=c end })

local ObjectSearchSection = ESPTab:Section({ Title = "Object Search ESP", Icon = "search" })
ObjectSearchSection:Input({ Title="Search Name", Placeholder="เช่น Door, Chest, Coin...", Callback=function(v) searchTargetText=v; updateObjectESP() end })
local exactToggle, partialToggle
exactToggle   = ObjectSearchSection:Toggle({ Title="Exact Match",   Default=false, Callback=function(s) exactMatchEnabled=s; if s and partialMatchEnabled then partialMatchEnabled=false; if partialToggle and partialToggle.SetValue then partialToggle:SetValue(false) end end; updateObjectESP() end })
partialToggle = ObjectSearchSection:Toggle({ Title="Partial Match", Default=false, Callback=function(s) partialMatchEnabled=s; if s and exactMatchEnabled then exactMatchEnabled=false; if exactToggle and exactToggle.SetValue then exactToggle:SetValue(false) end end; updateObjectESP() end })
ObjectSearchSection:Colorpicker({ Title="Search ESP Color", Default=Color3.fromRGB(255,255,0), Callback=function(c) objectEspColor=c; updateObjectESP() end })

-- ==================== UI: TELEPORT TAB ====================
-- Player TP + Tween ใช้ dropdown เดียวกัน
local TPSection = TPTab:Section({ Title = "Player Teleport & Tween", Icon = "navigation" })
local tpPlayerDropdown = TPSection:Dropdown({ Title="Select Target Player", Values=getPlayerList(), Value="", Callback=function(v) selectedPlayerName=v end })
TPSection:Button({ Title="Refresh Player List", Callback=function() safeRefresh(tpPlayerDropdown) end })
TPSection:Button({ Title="Teleport to Player",  Callback=function()
    local tp = players:FindFirstChild(selectedPlayerName)
    if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = localPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = tp.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    end
end })

-- Tween อยู่ใน section เดียวกัน (ใช้ dropdown ที่มีอยู่แล้ว)
local TweenSection = TPTab:Section({ Title = "Tween Tracking", Icon = "crosshair" })
local tweenPlayerDropdown = TweenSection:Dropdown({ Title="Select Player to Track", Values=getPlayerList(), Value="", Callback=function(v) selectedPlayerName=v end })
TweenSection:Button({ Title="Refresh",  Callback=function() safeRefresh(tweenPlayerDropdown) end })
TweenSection:Dropdown({ Title="Direction",    Values={"Behind","Front","Above","Below","Left","Right"}, Value="Behind", Callback=function(v) tweenDirection=v end })
TweenSection:Input({   Title="Distance",      Value="5",    Placeholder="เช่น 3, 5, 10...",  Callback=function(v) local n=tonumber(v); if n then tweenDistance=n end end })
TweenSection:Toggle({  Title="Auto Look",     Default=false, Callback=function(s) isAutoLooking=s end })
TweenSection:Toggle({  Title="Create Platform Under Feet", Default=true, Callback=function(s) createPlatform=s; if not s and tempPlatform then tempPlatform:Destroy(); tempPlatform=nil end end })
TweenSection:Toggle({  Title="Enable Relative Tween", Default=false, Callback=function(state)
    isTweeningRelative = state
    local myChar = localPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not isTweeningRelative then
        if tempPlatform then tempPlatform:Destroy(); tempPlatform=nil end
        if myHRP then removeBodyVelocity(myHRP) end
    end
    if isTweeningRelative then
        task.spawn(function()
            while isTweeningRelative do
                local targetPlayer = players:FindFirstChild(selectedPlayerName)
                local currentChar  = localPlayer.Character
                local currentHRP   = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and currentHRP then
                    local targetHRP = targetPlayer.Character.HumanoidRootPart
                    local targetPos = getTargetOffsetPosition(targetHRP, tweenDirection, tweenDistance)
                    local finalCF
                    if isAutoLooking then
                        local lookTarget = targetHRP.Position
                        if (lookTarget - targetPos).Magnitude > 0.001 then
                            local forward = (lookTarget - targetPos).Unit
                            local right = Vector3.new(0,1,0):Cross(forward)
                            if right.Magnitude < 0.001 then right = Vector3.new(1,0,0) else right = right.Unit end
                            local up = forward:Cross(right).Unit
                            finalCF = CFrame.fromMatrix(targetPos, right, up, -forward)
                        else finalCF = CFrame.new(targetPos) end
                    else finalCF = CFrame.new(targetPos) * (targetHRP.CFrame - targetHRP.CFrame.Position) end
                    updatePlatform(targetPos)
                    applyBodyVelocity(currentHRP, targetPos)
                    TweenService:Create(currentHRP, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {CFrame=finalCF}):Play()
                else if currentHRP then removeBodyVelocity(currentHRP) end end
                task.wait(0.15)
            end
        end)
    end
end })

-- Waypoints
-- FIX: ไม่ใช้ :Refresh() เพราะ WindUI ไม่ reliable
-- วิธีแก้: destroy Frame ของ dropdown เก่า → สร้าง Dropdown ใหม่ทันที
local WaypointSection = TPTab:Section({ Title = "Saved Waypoints", Icon = "bookmark" })
WaypointSection:Input({ Title="Waypoint Name", Placeholder="พิมพ์ชื่อจุด...", Callback=function(text) currentInputName=text end })

isRebuildingWaypoint = false
waypointDropdown = nil  -- จะสร้างใน rebuildWPDrop ด้านล่าง

local function rebuildWPDrop()
    if isRebuildingWaypoint then return end
    isRebuildingWaypoint = true

    -- destroy dropdown เก่า (Frame ที่ WindUI สร้าง)
    if waypointDropdown then
        pcall(function()
            if waypointDropdown.Frame and waypointDropdown.Frame.Parent then
                waypointDropdown.Frame:Destroy()
            end
        end)
        waypointDropdown = nil
    end

    selectedWaypointName = ""
    local names = getWaypointNamesList()

    -- สร้าง Dropdown ใหม่ใน WaypointSection เดิม
    waypointDropdown = WaypointSection:Dropdown({
        Title    = "Select Waypoint",
        Desc     = "เลือกจุดที่ต้องการเทเลพอร์ต",
        Values   = names,
        Value    = "",
        Callback = function(val)
            selectedWaypointName = (val ~= "ไม่มีจุดเซฟ") and val or ""
        end
    })

    task.delay(0.2, function() isRebuildingWaypoint = false end)
end

-- สร้างครั้งแรก
rebuildWPDrop()

WaypointSection:Button({ Title="Save Current Position", Callback=function()
    local trimmed = currentInputName:match("^%s*(.-)%s*$")
    if trimmed == "" then notify("Error", "พิมพ์ชื่อก่อน!"); return end
    local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if root then
        waypointsData[trimmed] = { root.CFrame:GetComponents() }
        saveWaypointsToFile()
        rebuildWPDrop()          -- ไม่ต้อง task.delay — สร้างใหม่เลย
        notify("Saved!", "เซฟ: " .. trimmed)
    else notify("Error", "ไม่พบตัวละคร!") end
end })
WaypointSection:Button({ Title="Teleport to Selected", Callback=function()
    if selectedWaypointName == "" or not waypointsData[selectedWaypointName] then
        notify("Error", "เลือกจุดก่อน!"); return
    end
    local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(table.unpack(waypointsData[selectedWaypointName]))
    else notify("Error", "ไม่พบตัวละคร!") end
end })
WaypointSection:Button({ Title="Delete Selected", Callback=function()
    if selectedWaypointName == "" or not waypointsData[selectedWaypointName] then
        notify("Error", "เลือกจุดก่อน!"); return
    end
    local d = selectedWaypointName
    waypointsData[d] = nil
    saveWaypointsToFile()
    rebuildWPDrop()
    notify("Deleted", "ลบ: " .. d)
end })
WaypointSection:Button({ Title="🔄 Refresh List", Callback=function()
    rebuildWPDrop()
    notify("Refreshed", "รีเฟรชรายชื่อแล้ว", 1.5)
end })

-- Drag Player
local DragSection = TPTab:Section({ Title = "Drag Player", Icon = "link" })
local dragDropdown = DragSection:Dropdown({ Title="Select Target", Values=getPlayerList(), Value="", Callback=function(v) dragTargetName=(v~="None") and v or "" end })
DragSection:Button({ Title="Refresh", Callback=function() safeRefresh(dragDropdown) end })
DragSection:Toggle({ Title="Drag Player", Value=false, Callback=function(state)
    if dragTargetName=="" then notify("Error","เลือกผู้เล่นก่อน!"); return end
    dragActive = state
    if state then startDrag(dragTargetName); notify("Drag ON","กำลังลาก "..dragTargetName)
    else stopDrag(dragTargetName); notify("Drag OFF","ปล่อย "..dragTargetName) end
end })

-- ==================== UI: LOCAL PLAYER TAB ====================
-- [1] Movement: Noclip + InfJump + Fly + FlySpeed — อยู่ด้วยกันทั้งหมด
local noclipToggleRef, infJumpToggleRef, flyToggleRef, flySpeedSliderRef

local MovementSection = LocalPlayerTab:Section({ Title = "Movement", Icon = "move" })
noclipToggleRef = MovementSection:Toggle({ Title="Noclip",         Desc="เดินทะลุกำแพง",   Value=false, Flag="NoclipToggle", Callback=function(s) setNoclip(s) end })
infJumpToggleRef = MovementSection:Toggle({ Title="Infinite Jump", Desc="กระโดดไม่จำกัด", Value=false, Flag="InfJumpToggle", Callback=function(s) setInfiniteJump(s) end })
flyToggleRef = MovementSection:Toggle({ Title="Fly",               Desc="บินอย่างอิสระ",   Value=false, Flag="FlyToggle",    Callback=function(s) if s then startFly() else stopFly() end end })
flySpeedSliderRef = MovementSection:Slider({
    Title="Fly Speed", Desc="ความเร็วการบิน", Step=1, Flag="FlySpeedValue",
    Value={Min=10, Max=500, Default=50},
    Callback=function(val) flySpeed = tonumber(val) or 50 end
})

-- [2] Speed Lock: Custom Speed + Lock อยู่ด้วยกัน
local SpeedSection = LocalPlayerTab:Section({ Title = "Speed Lock", Icon = "gauge" })
SpeedSection:Input({ Title="Custom Speed", Placeholder="เช่น 30, 50...", Callback=function(input)
    local num = tonumber(input); customSpeed = num or nil
    if speedConnection then setSpeedLock(customSpeed or defaultSpeed) end
end })
SpeedSection:Toggle({ Title="Lock Speed", Default=false, Callback=function(State)
    if State then setSpeedLock(customSpeed or defaultSpeed)
    else if speedConnection then speedConnection:Disconnect(); speedConnection = nil end end
end })
SpeedSection:Button({ Title="Reset to Default", Callback=function()
    local hum = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
    if hum then if speedConnection then speedConnection:Disconnect(); speedConnection=nil end; hum.WalkSpeed=defaultSpeed end
end })

-- [3] Auto-Save — อยู่หลัง Speed Lock
local autoSaveIntervalMin = 5
local autoSaveEnabled = false
local autoSaveThread = nil

local SaveSection = LocalPlayerTab:Section({ Title = "Auto-Save", Icon = "save" })
local ConfigManagerLocal = Window.ConfigManager
local localConfig = ConfigManagerLocal:CreateConfig("settings")
localConfig:Register("FlySpeedValue", flySpeedSliderRef)
localConfig:Register("NoclipToggle",  noclipToggleRef)
localConfig:Register("InfJumpToggle", infJumpToggleRef)
localConfig:Register("FlyToggle",     flyToggleRef)

SaveSection:Slider({ Title="Auto-Save Interval (min)", Desc="บันทึกทุก N นาที", Step=1, Value={Min=1,Max=30,Default=5}, Callback=function(val) autoSaveIntervalMin=tonumber(val) or 5 end })
SaveSection:Toggle({ Title="Enable Auto-Save", Desc="บันทึกอัตโนมัติตามเวลา", Value=false, Callback=function(state)
    autoSaveEnabled = state
    if autoSaveThread then task.cancel(autoSaveThread); autoSaveThread=nil end
    if autoSaveEnabled then
        autoSaveThread = task.spawn(function()
            while autoSaveEnabled do
                task.wait(autoSaveIntervalMin*60)
                if autoSaveEnabled then pcall(function() localConfig:Save() end); notify("Auto-Save","บันทึกแล้ว ✅", 2) end
            end
        end)
    end
end })
SaveSection:Button({ Title="Save Now",           Callback=function() pcall(function() localConfig:Save() end); notify("Saved","บันทึกแล้ว ✅", 2) end })
SaveSection:Button({ Title="Load Saved Settings", Callback=function() pcall(function() localConfig:Load(); notify("Loaded","โหลดสำเร็จ ✅", 2) end) end })

-- ==================== UI: MISC TAB ====================
-- ลำดับใหม่: Emote → Speed → Tools → Safety (ท้ายสุด)
local EmoteSection = MiscTab:Section({ Title = "Emote & Animation", Icon = "smile" })
local emotePlayerDropdown = EmoteSection:Dropdown({ Title="Select Target", Values=getPlayerList(), Value="", Callback=function(v) emoteTargetPlayerName=v end })
EmoteSection:Button({ Title="Refresh",  Callback=function() safeRefresh(emotePlayerDropdown) end })
EmoteSection:Toggle({ Title="Copy Player Movement", Default=false, Callback=function(state)
    isCopyingPlayerEmote = state
    if not state then stopMirroring(); stopCustomEmotes()
    else if emoteTargetPlayerName ~= "" then stopCustomEmotes(); startMirroringTarget(emoteTargetPlayerName) end end
end })
EmoteSection:Input({ Title="Custom Emote ID", Placeholder="ใส่หมายเลข ID เช่น 369675713...", Callback=function(val) customEmoteIdInput=val end })
EmoteSection:Toggle({ Title="Play Custom ID Emote", Default=false, Callback=function(state)
    isPlayingCustomEmote = state
    if state then stopCustomEmotes(); customTrack=playEmoteById(customEmoteIdInput) else stopCustomEmotes() end
end })

local MiscSpeedSection = MiscTab:Section({ Title = "Speed Controls", Icon = "gauge" })
MiscSpeedSection:Input({  Title="Custom Speed", Placeholder="เช่น 30, 50...", Callback=function(input)
    local num=tonumber(input); customSpeed=num or nil
    if speedConnection then setSpeedLock(customSpeed or defaultSpeed) end
end })
MiscSpeedSection:Toggle({ Title="Lock Speed", Default=false, Callback=function(State)
    if State then setSpeedLock(customSpeed or defaultSpeed)
    else if speedConnection then speedConnection:Disconnect(); speedConnection=nil end end
end })
MiscSpeedSection:Button({ Title="Reset to Default", Callback=function()
    local hum=localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
    if hum then if speedConnection then speedConnection:Disconnect(); speedConnection=nil end; hum.WalkSpeed=defaultSpeed end
end })

local ToolsSection = MiscTab:Section({ Title = "Tools", Icon = "wrench" })
ToolsSection:Button({ Title="Get TP Tool", Desc="เครื่องมือคลิกเพื่อวาร์ป", Callback=function()
    local plr = localPlayer
    if plr then
        local mouse = plr:GetMouse()
        local tptool = Instance.new("Tool")
        tptool.Name = "Click TP"; tptool.RequiresHandle = false; tptool.CanBeDropped = false
        tptool.Parent = plr:FindFirstChildOfClass("Backpack") or plr:WaitForChild("Backpack")
        tptool.Activated:Connect(function()
            local hr = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hr and mouse.Target then hr.CFrame = CFrame.new(mouse.Hit.X, mouse.Hit.Y+3, mouse.Hit.Z) end
        end)
    end
end })

-- Safety อยู่ท้ายสุดของ Misc
local SafetySection = MiscTab:Section({ Title = "Safety", Icon = "shield" })
SafetySection:Toggle({ Title="Safe Mode (< 50% HP TP)", Default=false, Callback=function(state)
    safeModeEnabled = state
    if safeModeEnabled then
        task.spawn(function()
            while safeModeEnabled do
                local myChar = localPlayer.Character
                if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
                    local hum = myChar.Humanoid
                    if hum.Health > 0 and (hum.Health/hum.MaxHealth) <= 0.5 then
                        myChar.HumanoidRootPart.CFrame = CFrame.new(safeModeLocation)
                        task.wait(2)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end })
SafetySection:Toggle({ Title="Anti-Fling", Default=false, Callback=function(state)
    AntiFling.Enabled = state; if state then AntiFling.Start() end
end })

-- ==================== CALLBACK MAP สำหรับ QB + Action Bar ====================
-- กำหนด callback ที่ใช้ร่วมกันทั้งสองระบบ
local TOGGLE_CALLBACKS = {
    ["Noclip"] = function(state)
        setNoclip(state)
        if noclipToggleRef and noclipToggleRef.Set then pcall(function() noclipToggleRef:Set(state) end) end
    end,
    ["Infinite Jump"] = function(state)
        setInfiniteJump(state)
        if infJumpToggleRef and infJumpToggleRef.Set then pcall(function() infJumpToggleRef:Set(state) end) end
    end,
    ["Fly"] = function(state)
        if state then startFly() else stopFly() end
        if flyToggleRef and flyToggleRef.Set then pcall(function() flyToggleRef:Set(state) end) end
    end,
    ["Anti-Fling"] = function(state)
        AntiFling.Enabled = state; if state then AntiFling.Start() end
    end,
    ["Safe Mode"] = function(state)
        safeModeEnabled = state
    end,
    ["Tween Track"] = function(state)
        isTweeningRelative = state
    end,
}

local AB_FUNC_LIST = {}
for k in pairs(TOGGLE_CALLBACKS) do table.insert(AB_FUNC_LIST, k) end
table.sort(AB_FUNC_LIST)

-- ==================== UI: SETTINGS TAB ====================
-- [A] Quick Buttons (Draggable)
local QBSection = SettingsTab:Section({ Title = "Quick Buttons (Draggable)", Icon = "layout-grid" })

local qbFuncList = {}
for k in pairs(TOGGLE_CALLBACKS) do table.insert(qbFuncList, k) end
table.sort(qbFuncList)
local selectedQBFunc = qbFuncList[1]

QBSection:Dropdown({ Title="Function", Desc="ฟังก์ชันสำหรับปุ่ม", Values=qbFuncList, Value=selectedQBFunc, Callback=function(v) selectedQBFunc=v end })
QBSection:Button({ Title="Add Button", Desc="สร้างปุ่มลอยบนหน้าจอ (ลากได้)", Callback=function()
    for _, btn in ipairs(QuickButtons) do
        if btn.funcName == selectedQBFunc then notify("มีอยู่แล้ว", selectedQBFunc.." มีปุ่มแล้ว"); return end
    end
    createQuickButton(selectedQBFunc, 80 + #QuickButtons*75, 200, 65, false, TOGGLE_CALLBACKS[selectedQBFunc])
    notify("เพิ่มแล้ว", "ปุ่ม "..selectedQBFunc.." บนหน้าจอ")
end })
QBSection:Button({ Title="Remove Selected Button", Callback=function()
    removeQuickButton(selectedQBFunc); notify("ลบแล้ว", "ลบ "..selectedQBFunc)
end })
QBSection:Toggle({ Title="Lock Button Positions", Desc="ป้องกันลากโดยไม่ตั้งใจ", Value=false, Callback=function(state) quickButtonsLocked=state end })
QBSection:Button({ Title="Remove All Buttons", Callback=function()
    removeAllQuickButtons(); notify("ลบแล้ว","ลบปุ่มทั้งหมดแล้ว")
end })

-- [B] Action Bottom Bar (Fixed, ไม่ลาก)
local ABSection = SettingsTab:Section({ Title = "Action Bottom Bar (มือถือ)", Icon = "smartphone" })
local selectedABFunc = AB_FUNC_LIST[1]

ABSection:Paragraph({ Title="Action Bottom Bar", Desc="ปุ่ม fixed ล่างจอ กดเพื่อ toggle ฟังก์ชัน เหมาะสำหรับมือถือ — ลากไม่ได้ แต่เพิ่ม/ลบได้" })
ABSection:Dropdown({ Title="Function", Desc="ฟังก์ชันสำหรับ Action Bar", Values=AB_FUNC_LIST, Value=selectedABFunc, Callback=function(v) selectedABFunc=v end })
ABSection:Button({ Title="Add to Action Bar", Desc="เพิ่มปุ่มที่ล่างจอ", Callback=function()
    if not TOGGLE_CALLBACKS[selectedABFunc] then notify("Error","ไม่พบฟังก์ชัน"); return end
    addActionBarButton(selectedABFunc, false, TOGGLE_CALLBACKS[selectedABFunc])
    notify("เพิ่มแล้ว", "เพิ่ม "..selectedABFunc.." ที่ Action Bar")
end })
ABSection:Button({ Title="Remove from Action Bar", Callback=function()
    removeActionBarButton(selectedABFunc); notify("ลบแล้ว","ลบ "..selectedABFunc.." ออกจาก Action Bar")
end })
ABSection:Button({ Title="Clear All Action Bar", Callback=function()
    removeAllActionBar(); notify("ลบแล้ว","ล้าง Action Bar ทั้งหมด")
end })
ABSection:Slider({ Title="Bottom Offset (px)", Desc="ระยะห่างจากขอบล่างจอ", Step=4, Value={Min=8,Max=120,Default=24}, Callback=function(v) ACTION_BAR_BOTTOM_OFFSET=v; rebuildActionBarLayout() end })
ABSection:Slider({ Title="Button Size (px)",   Desc="ขนาดปุ่ม Action Bar", Step=4, Value={Min=48,Max=100,Default=64}, Callback=function(v) ACTION_BTN_SIZE=v; rebuildActionBarLayout() end })

-- [C] Keybinds
local KeybindSection = SettingsTab:Section({ Title = "Keybinds", Icon = "keyboard" })
KeybindSection:Keybind({ Title="Noclip",        Value="V", Callback=function()
    noclipEnabled = not noclipEnabled; setNoclip(noclipEnabled)
    if noclipToggleRef and noclipToggleRef.Set then pcall(function() noclipToggleRef:Set(noclipEnabled) end) end
    notify("Noclip", noclipEnabled and "เปิด" or "ปิด", 1.5)
end })
KeybindSection:Keybind({ Title="Infinite Jump",  Value="T", Callback=function()
    infiniteJumpEnabled = not infiniteJumpEnabled; setInfiniteJump(infiniteJumpEnabled)
    if infJumpToggleRef and infJumpToggleRef.Set then pcall(function() infJumpToggleRef:Set(infiniteJumpEnabled) end) end
    notify("Infinite Jump", infiniteJumpEnabled and "เปิด" or "ปิด", 1.5)
end })
KeybindSection:Keybind({ Title="Fly",             Value="F", Callback=function()
    if isFlying then
        stopFly()
        if flyToggleRef and flyToggleRef.Set then pcall(function() flyToggleRef:Set(false) end) end
        notify("Fly","ปิด", 1.5)
    else
        startFly()
        if flyToggleRef and flyToggleRef.Set then pcall(function() flyToggleRef:Set(true) end) end
        notify("Fly","เปิด", 1.5)
    end
end })

-- [D] Load Action Bar จาก JSON
local function loadActionBar()
    pcall(function()
        if not isfile or not isfile("BlackCrown-X/actionbar.json") then return end
        local raw = readfile("BlackCrown-X/actionbar.json")
        if not raw or #raw < 3 then return end
        local ok, data = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), raw)
        if not ok or type(data) ~= "table" then return end
        for _, btn in ipairs(ActionBar) do pcall(function() btn.BtnFrame:Destroy() end) end
        ActionBar = {}
        for _, d in ipairs(data) do
            if d.func and TOGGLE_CALLBACKS[d.func] then
                addActionBarButton(d.func, d.state or false, TOGGLE_CALLBACKS[d.func])
                if d.state then pcall(TOGGLE_CALLBACKS[d.func], d.state) end
            end
        end
    end)
end

-- ==================== LOAD CONFIGS & QUICK BUTTONS ====================
task.delay(0.5, function()
    pcall(function()
        localConfig:Load()
        notify("BlackCrown-X","โหลดการตั้งค่าก่อนหน้าแล้ว ✅", 3)
    end)
end)

task.delay(1.5, function()
    loadQuickButtons(TOGGLE_CALLBACKS)
    loadActionBar()
end)

-- ==================== FINAL ====================
print("BlackCrown-X v2 (UI Reorganized + Action Bottom Bar) loaded")
Window:SetToggleKey(Enum.KeyCode.LeftAlt)
-- ==================== FREE MOUSE (กด Y สลับ เปิด/ปิด) ====================
task.spawn(function()
    local FM = { on = false }

    -- ระหว่างเปิดโหมด: บังคับ Default ทับทุกเฟรมเพื่อชนะกล้องของ Roblox
    local function force()
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end

    -- ตอนปิดโหมด: เขี่ย CameraType ไปมา บังคับให้ Roblox
    -- รีเซ็ตสถานะล็อกเมาส์ใหม่ทั้งหมดให้ตรงกับมุมมองปัจจุบันจริงๆ
    -- (แก้ปัญหาเมาส์ค้างล็อกตอนซูมเป็น Third Person)
    local function resyncCamera()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local original = cam.CameraType
        pcall(function() cam.CameraType = Enum.CameraType.Scriptable end)
        task.wait()
        pcall(function()
            cam.CameraType = (original == Enum.CameraType.Scriptable)
                and Enum.CameraType.Custom or original
        end)
    end

    local function setFree(state)
        if state == FM.on then return end
        FM.on = state

        if state then
            RunService:BindToRenderStep("BCX_FreeMouse", Enum.RenderPriority.Last.Value, force)
            force()
        else
            pcall(function() RunService:UnbindFromRenderStep("BCX_FreeMouse") end)
            resyncCamera()
        end

        pcall(function()
            WindUI:Notify({
                Title = "Free Mouse",
                Content = state and "เปิด — เมาส์อิสระ" or "ปิด — คืนสภาพเดิม",
                Duration = 2,
            })
        end)
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode ~= Enum.KeyCode.Y then return end
        if UserInputService:GetFocusedTextBox() then return end
        setFree(not FM.on)
    end)
end)
