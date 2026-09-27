-- ==================== FIXED SCRIPT ====================

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

-- Variables
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
            if hum.WalkSpeed ~= speed then
                hum.WalkSpeed = speed
            end
        end)
    end
end

local function getPlayerList()
    local list = {}
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= localPlayer then
            table.insert(list, plr.Name)
        end
    end
    if #list == 0 then table.insert(list, "None") end
    return list
end

-- ==================== FULL MOVEMENT & EMOTE MIRROR SYSTEM ====================
local emoteTargetPlayerName = ""
local isCopyingPlayerEmote = false
local mirrorConnection = nil
local customEmoteIdInput = ""
local customTrack = nil
local isPlayingCustomEmote = false

local jointNames = {
    "RootJoint", "Neck", "Left Shoulder", "Right Shoulder", "Left Hip", "Right Hip",
    "Waist", "Spine", "LeftShoulder", "RightShoulder", "LeftUpperArm", "RightUpperArm",
    "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "LeftHip", "RightHip",
    "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"
}

local function stopMirroring()
    if mirrorConnection then
        mirrorConnection:Disconnect()
        mirrorConnection = nil
    end
end

local function getMotors(character)
    local motors = {}
    if not character then return motors end
    for _, desc in ipairs(character:GetDescendants()) do
        if desc:IsA("Motor6D") then
            motors[desc.Name] = desc
        end
    end
    return motors
end

local function startMirroringTarget(targetPlayerName)
    stopMirroring()
    mirrorConnection = rs.RenderStepped:Connect(function()
        if not isCopyingPlayerEmote then
            stopMirroring()
            return
        end
        local targetPlayer = players:FindFirstChild(targetPlayerName)
        local myChar = localPlayer.Character
        if targetPlayer and targetPlayer.Character and myChar then
            local targetMotors = getMotors(targetPlayer.Character)
            local myMotors = getMotors(myChar)
            for name, targetMotor in pairs(targetMotors) do
                local myMotor = myMotors[name]
                if myMotor then
                    myMotor.Transform = targetMotor.Transform
                end
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
    local success, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    if success and track then
        track:Play()
        return track
    end
    return nil
end

local function stopCustomEmotes()
    if customTrack then
        customTrack:Stop()
        customTrack = nil
    end
end

-- ==================== TWEEN WITH BODYVELOCITY SYSTEM ====================
local tweenDirection = "Behind"
local tweenDistance = 5
local isTweeningRelative = false
local isAutoLooking = false
local createPlatform = true
local tempPlatform = nil

local function getTargetOffsetPosition(targetHRP, direction, distance)
    local targetCF = targetHRP.CFrame
    if direction == "Front" then
        return (targetCF * CFrame.new(0, 0, -distance)).Position
    elseif direction == "Behind" then
        return (targetCF * CFrame.new(0, 0, distance)).Position
    elseif direction == "Above" then
        return (targetCF * CFrame.new(0, distance, 0)).Position
    elseif direction == "Below" then
        return (targetCF * CFrame.new(0, -distance, 0)).Position
    elseif direction == "Left" then
        return (targetCF * CFrame.new(-distance, 0, 0)).Position
    elseif direction == "Right" then
        return (targetCF * CFrame.new(distance, 0, 0)).Position
    end
    return (targetCF * CFrame.new(0, 0, distance)).Position
end

local function updatePlatform(targetPosition)
    if not createPlatform then
        if tempPlatform then
            tempPlatform:Destroy()
            tempPlatform = nil
        end
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
    local direction = (targetPos - hrp.Position)
    bv.Velocity = direction * 5
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
        local speed = hrp.AssemblyLinearVelocity.Magnitude
        if speed > MAX_VELOCITY then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

function AntiFling.Stop()
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end
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
                        if part:IsA('BasePart') then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipSteppedConn then
            noclipSteppedConn:Disconnect()
            noclipSteppedConn = nil
        end
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
            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJumpEnabled and p and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        end
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end

-- ==================== FLY SYSTEM ====================
local flySpeed = 50
local bodyGyro = nil
local bodyVelocity = nil
local flyConnection = nil
local flyControls = nil

local function startFly()
    local character = p.Character
    if not character or not character:FindFirstChild('HumanoidRootPart') then return end
    local rootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    if humanoid then humanoid.PlatformStand = true end
    bodyGyro = Instance.new('BodyGyro', rootPart)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyVelocity = Instance.new('BodyVelocity', rootPart)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    if not flyControls then
        local ok, result = pcall(function()
            local playerModule = require(p.PlayerScripts:WaitForChild('PlayerModule', 5))
            return playerModule:GetControls()
        end)
        if ok then flyControls = result end
    end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not rootPart or not rootPart.Parent then return end
        local cam = workspace.CurrentCamera
        bodyGyro.CFrame = cam.CFrame
        if flyControls then
            local moveVector = flyControls:GetMoveVector()
            local moveDirection = (cam.CFrame.LookVector * -moveVector.Z) + (cam.CFrame.RightVector * moveVector.X)
            if moveDirection.Magnitude > 0 then
                bodyVelocity.Velocity = moveDirection.Unit * flySpeed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

local function stopFly()
    local character = p.Character
    if character then
        local humanoid = character:FindFirstChildOfClass('Humanoid')
        if humanoid then humanoid.PlatformStand = false end
    end
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
end

-- ==================== UI INITIALIZATION ====================
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("Failed to load WindUI Library")
    return
end

local Window = WindUI:CreateWindow({
    Title = "BlackCrown-X",
    Icon = "door-open",
    Author = "by wdashsuicnsc and timxq_n.",
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

local MainTab = Window:Tab({ Title = "Main", Icon = "bird", Locked = false })
local AimbotTab = Window:Tab({ Title = "Aimbot", Icon = "crosshair", Locked = false })
local ESPTab = Window:Tab({ Title = "ESP", Icon = "eye", Locked = false })
local TPTab = Window:Tab({ Title = "Teleport", Icon = "map-pin", Locked = false })
local LocalPlayerTab = Window:Tab({ Title = "Local Player", Icon = "user" })
local KeybindTab = Window:Tab({ Title = "Keybinds", Icon = "keyboard" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "ellipsis", Locked = false })

-- ==================== ESP SYSTEM ====================
local espNameEnabled = false
local espBoxEnabled = false
local espTracerEnabled = false
local espHighlightEnabled = false
-- FIX: ค่าเริ่มต้นเป็น false ทั้งคู่ ป้องกันแสดงผลก่อนเปิด toggle
local espHealthBarEnabled = false
local espHealthTextEnabled = false
local espMicEnabled = false

local espColor = Color3.fromRGB(255, 0, 0)
local friendColor = Color3.fromRGB(0, 255, 128)

local espObjects = {}
local friendCache = {}

local hasDrawingAPI = (typeof(Drawing) == "table" and typeof(Drawing.new) == "function")

local function checkIsFriend(plr)
    if friendCache[plr.UserId] ~= nil then
        return friendCache[plr.UserId]
    end
    local isFriend = false
    pcall(function()
        isFriend = localPlayer:IsFriendsWith(plr.UserId)
    end)
    friendCache[plr.UserId] = isFriend
    return isFriend
end

local function removeESP(plr)
    if espObjects[plr] then
        if espObjects[plr].connection then espObjects[plr].connection:Disconnect() end
        if espObjects[plr].highlight then espObjects[plr].highlight:Destroy() end
        if espObjects[plr].boxOutline then pcall(function() espObjects[plr].boxOutline:Remove() end) end
        if espObjects[plr].boxInline then pcall(function() espObjects[plr].boxInline:Remove() end) end
        if espObjects[plr].healthBarOutline then pcall(function() espObjects[plr].healthBarOutline:Remove() end) end
        if espObjects[plr].healthBarBG then pcall(function() espObjects[plr].healthBarBG:Remove() end) end
        if espObjects[plr].healthBarFill then pcall(function() espObjects[plr].healthBarFill:Remove() end) end
        if espObjects[plr].healthText then pcall(function() espObjects[plr].healthText:Remove() end) end
        if espObjects[plr].nameText then pcall(function() espObjects[plr].nameText:Remove() end) end
        if espObjects[plr].micText then pcall(function() espObjects[plr].micText:Remove() end) end
        if espObjects[plr].tracer then pcall(function() espObjects[plr].tracer:Remove() end) end
        espObjects[plr] = nil
    end
end

local function applyESPToCharacter(plr, charModel)
    removeESP(plr)
    if not charModel then return end
    local hrpTarget = charModel:WaitForChild("HumanoidRootPart", 5)
    local humanoidTarget = charModel:WaitForChild("Humanoid", 5)
    if not hrpTarget or not humanoidTarget then return end

    local isFriend = checkIsFriend(plr)
    local activeColor = isFriend and friendColor or espColor

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = activeColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Enabled = false -- FIX: เริ่มต้น false เสมอ ให้ toggle เป็นคนเปิด
    highlight.Parent = charModel

    local boxOutline, boxInline, healthBarOutline, healthBarBG, healthBarFill, healthText, nameText, micText, tracer
    if hasDrawingAPI then
        pcall(function()
            boxOutline = Drawing.new("Square")
            boxOutline.Visible = false
            boxOutline.Color = Color3.new(0, 0, 0)
            boxOutline.Thickness = 3

            boxInline = Drawing.new("Square")
            boxInline.Visible = false
            boxInline.Color = activeColor
            boxInline.Thickness = 1

            healthBarOutline = Drawing.new("Square")
            healthBarOutline.Visible = false
            healthBarOutline.Color = Color3.new(0, 0, 0)
            healthBarOutline.Thickness = 1
            healthBarOutline.Filled = false

            healthBarBG = Drawing.new("Square")
            healthBarBG.Visible = false
            healthBarBG.Color = Color3.fromRGB(30, 30, 30)
            healthBarBG.Filled = true

            healthBarFill = Drawing.new("Square")
            healthBarFill.Visible = false
            healthBarFill.Color = Color3.fromRGB(0, 255, 0)
            healthBarFill.Filled = true

            healthText = Drawing.new("Text")
            healthText.Visible = false
            healthText.Color = Color3.fromRGB(255, 255, 255)
            healthText.Size = 12
            healthText.Center = false
            healthText.Outline = true

            nameText = Drawing.new("Text")
            nameText.Visible = false
            nameText.Color = activeColor
            nameText.Size = 14
            nameText.Center = true
            nameText.Outline = true

            micText = Drawing.new("Text")
            micText.Visible = false
            micText.Color = Color3.fromRGB(255, 255, 255)
            micText.Size = 16
            micText.Center = false
            micText.Outline = true

            tracer = Drawing.new("Line")
            tracer.Visible = false
            tracer.Color = activeColor
            tracer.Thickness = 1.5
        end)
    end

    local conn = rs.RenderStepped:Connect(function()
        if not charModel.Parent or humanoidTarget.Health <= 0 then
            if highlight then highlight.Enabled = false end
            if boxOutline then boxOutline.Visible = false end
            if boxInline then boxInline.Visible = false end
            if healthBarOutline then healthBarOutline.Visible = false end
            if healthBarBG then healthBarBG.Visible = false end
            if healthBarFill then healthBarFill.Visible = false end
            if healthText then healthText.Visible = false end
            if nameText then nameText.Visible = false end
            if micText then micText.Visible = false end
            if tracer then tracer.Visible = false end
            return
        end

        local currentColor = checkIsFriend(plr) and friendColor or espColor
        highlight.FillColor = currentColor
        highlight.Enabled = espHighlightEnabled

        if boxInline then boxInline.Color = currentColor end
        if nameText then nameText.Color = currentColor end
        if tracer then tracer.Color = currentColor end

        if hasDrawingAPI then
            local pos, onScreen = camera:WorldToViewportPoint(hrpTarget.Position)
            if onScreen then
                local topPos = hrpTarget.Position + Vector3.new(0, 2.5, 0)
                local bottomPos = hrpTarget.Position - Vector3.new(0, 3, 0)
                local top, tOn = camera:WorldToViewportPoint(topPos)
                local bottom, bOn = camera:WorldToViewportPoint(bottomPos)

                if tOn and bOn then
                    local boxHeight = math.abs(bottom.Y - top.Y)
                    local boxWidth = boxHeight * 0.65
                    local minX = pos.X - (boxWidth / 2)
                    local minY = top.Y

                    -- Box ESP
                    if espBoxEnabled and boxOutline and boxInline then
                        boxOutline.Size = Vector2.new(boxWidth, boxHeight)
                        boxOutline.Position = Vector2.new(minX, minY)
                        boxOutline.Visible = true
                        boxInline.Size = Vector2.new(boxWidth, boxHeight)
                        boxInline.Position = Vector2.new(minX, minY)
                        boxInline.Visible = true
                    else
                        if boxOutline then boxOutline.Visible = false end
                        if boxInline then boxInline.Visible = false end
                    end

                    -- FIX: Health Bar — แสดงเฉพาะเมื่อ espHealthBarEnabled = true
                    if espHealthBarEnabled and healthBarOutline and healthBarBG and healthBarFill then
                        local healthPercent = math.clamp(humanoidTarget.Health / humanoidTarget.MaxHealth, 0, 1)
                        local barWidth = 3
                        local barOffset = 6
                        local barX = minX - barOffset - barWidth

                        local barColor = Color3.fromRGB(0, 255, 0)
                        if healthPercent <= 0.2 then
                            barColor = Color3.fromRGB(255, 0, 0)
                        elseif healthPercent <= 0.5 then
                            barColor = Color3.fromRGB(255, 200, 0)
                        end

                        local fillHeight = math.floor(boxHeight * healthPercent)
                        local fillY = minY + (boxHeight - fillHeight)

                        healthBarBG.Size = Vector2.new(barWidth, boxHeight)
                        healthBarBG.Position = Vector2.new(barX, minY)
                        healthBarBG.Visible = true

                        healthBarFill.Size = Vector2.new(barWidth, fillHeight)
                        healthBarFill.Position = Vector2.new(barX, fillY)
                        healthBarFill.Color = barColor
                        healthBarFill.Visible = true

                        healthBarOutline.Size = Vector2.new(barWidth + 2, boxHeight + 2)
                        healthBarOutline.Position = Vector2.new(barX - 1, minY - 1)
                        healthBarOutline.Visible = true

                        -- FIX: HP% แสดงเฉพาะเมื่อ espHealthTextEnabled = true
                        if espHealthTextEnabled and healthText then
                            healthText.Text = string.format("%d%%", math.floor(healthPercent * 100))
                            healthText.Position = Vector2.new(barX - 25, fillY - 4)
                            healthText.Color = barColor
                            healthText.Visible = true
                        else
                            if healthText then healthText.Visible = false end
                        end
                    else
                        if healthBarOutline then healthBarOutline.Visible = false end
                        if healthBarBG then healthBarBG.Visible = false end
                        if healthBarFill then healthBarFill.Visible = false end
                        if healthText then healthText.Visible = false end
                    end

                    -- Mic Indicator
                    if espMicEnabled and micText then
                        local voiceInst = charModel:FindFirstChild("VoiceSource", true) or charModel:FindFirstChildWhichIsA("AudioEmitter", true)
                        if voiceInst then
                            local isTalking = false
                            if voiceInst:IsA("Sound") and voiceInst.PlaybackLoudness > 5 then
                                isTalking = true
                            end
                            micText.Text = "🎤"
                            micText.Color = isTalking and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                            micText.Position = Vector2.new(minX + boxWidth + 4, minY)
                            micText.Visible = true
                        else
                            micText.Visible = false
                        end
                    else
                        if micText then micText.Visible = false end
                    end

                    -- Name ESP
                    if espNameEnabled and nameText then
                        local myChar = localPlayer.Character
                        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        local distance = myHRP and math.floor((hrpTarget.Position - myHRP.Position).Magnitude) or 0
                        nameText.Text = string.format("%s [%dm]", plr.Name, distance)
                        nameText.Position = Vector2.new(pos.X, minY - 18)
                        nameText.Visible = true
                    else
                        if nameText then nameText.Visible = false end
                    end
                end

                -- Tracer ESP
                if espTracerEnabled and tracer then
                    tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    tracer.To = Vector2.new(pos.X, pos.Y)
                    tracer.Visible = true
                else
                    if tracer then tracer.Visible = false end
                end
            else
                if boxOutline then boxOutline.Visible = false end
                if boxInline then boxInline.Visible = false end
                if healthBarOutline then healthBarOutline.Visible = false end
                if healthBarBG then healthBarBG.Visible = false end
                if healthBarFill then healthBarFill.Visible = false end
                if healthText then healthText.Visible = false end
                if nameText then nameText.Visible = false end
                if micText then micText.Visible = false end
                if tracer then tracer.Visible = false end
            end
        end
    end)

    espObjects[plr] = {
        highlight = highlight,
        boxOutline = boxOutline,
        boxInline = boxInline,
        healthBarOutline = healthBarOutline,
        healthBarBG = healthBarBG,
        healthBarFill = healthBarFill,
        healthText = healthText,
        nameText = nameText,
        micText = micText,
        tracer = tracer,
        connection = conn
    }
end

for _, plr in ipairs(players:GetPlayers()) do
    if plr ~= localPlayer then
        plr.CharacterAdded:Connect(function(c) applyESPToCharacter(plr, c) end)
        if plr.Character then task.spawn(function() applyESPToCharacter(plr, plr.Character) end) end
    end
end

players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(c) applyESPToCharacter(plr, c) end)
end)

players.PlayerRemoving:Connect(function(plr)
    friendCache[plr.UserId] = nil
    removeESP(plr)
end)

-- ==================== OBJECT SEARCH ESP SYSTEM ====================
local searchTargetText = ""
local exactMatchEnabled = false
local partialMatchEnabled = false
local objectEspColor = Color3.fromRGB(255, 255, 0)
local searchedObjects = {}

local function clearObjectESP()
    for obj, data in pairs(searchedObjects) do
        if data.highlight then pcall(function() data.highlight:Destroy() end) end
        if data.boxOutline then pcall(function() data.boxOutline:Remove() end) end
        if data.boxInline then pcall(function() data.boxInline:Remove() end) end
        if data.nameText then pcall(function() data.nameText:Remove() end) end
        if data.tracer then pcall(function() data.tracer:Remove() end) end
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
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.Parent = obj

    local boxOutline, boxInline, nameText, tracer
    if hasDrawingAPI then
        pcall(function()
            boxOutline = Drawing.new("Square")
            boxOutline.Visible = false
            boxOutline.Color = Color3.new(0, 0, 0)
            boxOutline.Thickness = 3

            boxInline = Drawing.new("Square")
            boxInline.Visible = false
            boxInline.Color = objectEspColor
            boxInline.Thickness = 1

            nameText = Drawing.new("Text")
            nameText.Visible = false
            nameText.Color = objectEspColor
            nameText.Size = 14
            nameText.Center = true
            nameText.Outline = true

            tracer = Drawing.new("Line")
            tracer.Visible = false
            tracer.Color = objectEspColor
            tracer.Thickness = 1.5
        end)
    end

    searchedObjects[obj] = {
        highlight = highlight,
        boxOutline = boxOutline,
        boxInline = boxInline,
        nameText = nameText,
        tracer = tracer,
        part = primaryPart
    }
end

local function updateObjectESP()
    clearObjectESP()
    if searchTargetText == "" or (not exactMatchEnabled and not partialMatchEnabled) then return end
    local targetLower = string.lower(searchTargetText)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if localPlayer.Character and obj:IsDescendantOf(localPlayer.Character) then
                continue
            end
            local objName = obj.Name
            local isMatch = false
            if exactMatchEnabled then
                if objName == searchTargetText then isMatch = true end
            elseif partialMatchEnabled then
                if string.find(string.lower(objName), targetLower, 1, true) then isMatch = true end
            end
            if isMatch then applyESPToObject(obj) end
        end
    end
end

rs.RenderStepped:Connect(function()
    if not (exactMatchEnabled or partialMatchEnabled) then return end
    for obj, data in pairs(searchedObjects) do
        if not obj or not obj.Parent or not data.part or not data.part.Parent then
            if data.highlight then pcall(function() data.highlight:Destroy() end) end
            if data.boxOutline then pcall(function() data.boxOutline:Remove() end) end
            if data.boxInline then pcall(function() data.boxInline:Remove() end) end
            if data.nameText then pcall(function() data.nameText:Remove() end) end
            if data.tracer then pcall(function() data.tracer:Remove() end) end
            searchedObjects[obj] = nil
            continue
        end
        if hasDrawingAPI then
            local pos, onScreen = camera:WorldToViewportPoint(data.part.Position)
            if onScreen then
                local myChar = localPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local distance = myHRP and math.floor((data.part.Position - myHRP.Position).Magnitude) or 0
                local extents = obj:IsA("Model") and obj:GetExtentsSize() or data.part.Size
                local top, tOn = camera:WorldToViewportPoint(data.part.Position + Vector3.new(0, extents.Y / 2, 0))
                local bottom, bOn = camera:WorldToViewportPoint(data.part.Position - Vector3.new(0, extents.Y / 2, 0))
                if tOn and bOn and data.boxOutline and data.boxInline then
                    local height = math.abs(top.Y - bottom.Y)
                    local width = math.max(height * 0.8, 15)
                    local topLeft = Vector2.new(pos.X - width / 2, top.Y)
                    data.boxOutline.Size = Vector2.new(width, height)
                    data.boxOutline.Position = topLeft
                    data.boxOutline.Visible = true
                    data.boxInline.Size = Vector2.new(width, height)
                    data.boxInline.Position = topLeft
                    data.boxInline.Visible = true
                end
                if data.nameText then
                    data.nameText.Text = string.format("%s [%dm]", obj.Name, distance)
                    data.nameText.Position = Vector2.new(pos.X, top.Y - 18)
                    data.nameText.Visible = true
                end
                if data.tracer then
                    data.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    data.tracer.To = Vector2.new(pos.X, pos.Y)
                    data.tracer.Visible = true
                end
            else
                if data.boxOutline then data.boxOutline.Visible = false end
                if data.boxInline then data.boxInline.Visible = false end
                if data.nameText then data.nameText.Visible = false end
                if data.tracer then data.tracer.Visible = false end
            end
        end
    end
end)

-- ==================== AIMBOT SYSTEM ====================
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
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = false
        fovCircle.Thickness = 1.5
        fovCircle.NumSides = 64
        fovCircle.Filled = false
        fovCircle.Color = fovColor
        fovCircle.Transparency = 0.8
    end)
end

local function isVisible(targetPart, targetCharacter)
    if not wallCheckEnabled then return true end
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {localPlayer.Character, camera}
    raycastParams.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
        return hitModel == targetCharacter
    end
    return true
end

local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mouseLocation = UserInputService:GetMouseLocation()
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character then
            local targetPart = plr.Character:FindFirstChild(aimbotTargetPart)
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local screenPos2D = Vector2.new(screenPoint.X, screenPoint.Y)
                    local dist = (screenPos2D - mouseLocation).Magnitude
                    local withinFov = not fovEnabled or (dist <= fovRadius)
                    local visible = isVisible(targetPart, plr.Character)
                    if withinFov and visible and dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = plr
                    end
                end
            end
        end
    end
    return closestPlayer
end

rs.RenderStepped:Connect(function()
    local mouseLocation = UserInputService:GetMouseLocation()
    if fovCircle then
        fovCircle.Position = mouseLocation
        fovCircle.Radius = fovRadius
        fovCircle.Color = fovColor
        fovCircle.Visible = aimbotEnabled and fovEnabled
    end
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerToCursor()
        if target and target.Character then
            local part = target.Character:FindFirstChild(aimbotTargetPart)
            if part then
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, part.Position)
                camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / math.max(aimbotSmoothness, 1))
            end
        end
    end
end)

-- ==================== AIMBOT TAB UI ====================
local AimbotSection = AimbotTab:Section({ Title = "Aimbot Core", Icon = "target" })
AimbotSection:Toggle({
    Title = "Enable Aimbot",
    Desc = "เปิดใช้งานระบบช่วยเล็งเป้าหมายอัตโนมัติ (คลิกขวาค้าง)",
    Default = false,
    Callback = function(state) aimbotEnabled = state end
})

AimbotSection:Toggle({
    Title = "Wallcheck",
    Desc = "ไม่ล็อกเป้าหมายหากมีสิ่งกีดขวาง/กำแพงบัง",
    Default = false,
    Callback = function(state) wallCheckEnabled = state end
})

AimbotSection:Dropdown({
    Title = "Target Part",
    Desc = "เลือกส่วนของร่างกายที่ต้องการให้ล็อกเป้า",
    Values = {"Head", "HumanoidRootPart"},
    Value = "Head",
    Callback = function(v) aimbotTargetPart = v end
})

AimbotSection:Input({
    Title = "Smoothness",
    Desc = "ปรับความนุ่มนวลในการหัน (1 = ล็อกทันที)",
    Value = "1",
    Placeholder = "เช่น 1, 2, 5...",
    Callback = function(val)
        local num = tonumber(val)
        if num and num > 0 then aimbotSmoothness = num end
    end
})

local FOVSection = AimbotTab:Section({ Title = "FOV Customization", Icon = "disc" })
FOVSection:Toggle({
    Title = "Enable FOV Circle",
    Desc = "แสดงวงกลมกำหนดระยะการล็อกเป้า",
    Default = false,
    Callback = function(state) fovEnabled = state end
})

FOVSection:Input({
    Title = "FOV Radius",
    Desc = "ปรับขนาดรัศมีวงกลม FOV (ค่าเริ่มต้น: 150)",
    Value = "150",
    Placeholder = "เช่น 100, 150...",
    Callback = function(val)
        local num = tonumber(val)
        if num and num > 0 then fovRadius = num end
    end
})

FOVSection:Colorpicker({
    Title = "FOV Circle Color",
    Desc = "เลือกสีสำหรับวงกลม FOV",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color) fovColor = color end
})

-- ==================== ESP TAB UI ====================
local ESPSettingsSection = ESPTab:Section({ Title = "Visual Toggles", Icon = "eye" })
ESPSettingsSection:Toggle({
    Title = "Enable Name & Distance",
    Desc = "แสดงชื่อและระยะทางบนหัวผู้เล่น",
    Default = false,
    Callback = function(state) espNameEnabled = state end
})

ESPSettingsSection:Toggle({
    Title = "Enable Box ESP",
    Desc = "แสดงกล่องสี่เหลี่ยมล้อมรอบตัวผู้เล่น",
    Default = false,
    Callback = function(state) espBoxEnabled = state end
})

-- FIX: Default = false ให้ตรงกับค่าตัวแปรที่ตั้งไว้
ESPSettingsSection:Toggle({
    Title = "Enable Health Bar",
    Desc = "แสดงแถบเลือดข้างกล่อง ESP",
    Default = false,
    Callback = function(state) espHealthBarEnabled = state end
})

ESPSettingsSection:Toggle({
    Title = "Enable Health Percent Text",
    Desc = "แสดงตัวเลข % เลือดข้างแถบเลือด",
    Default = false,
    Callback = function(state) espHealthTextEnabled = state end
})

ESPSettingsSection:Toggle({
    Title = "Enable Tracer Line",
    Desc = "แสดงเส้นลากจากล่างหน้าจอไปยังเป้าหมาย",
    Default = false,
    Callback = function(state) espTracerEnabled = state end
})

ESPSettingsSection:Toggle({
    Title = "Enable Highlight ESP",
    Desc = "แสดงแสงออร่าเรืองแสงครอบตัวผู้เล่น",
    Default = false,
    Callback = function(state) espHighlightEnabled = state end
})

ESPSettingsSection:Toggle({
    Title = "Enable Mic Indicator",
    Desc = "แสดงไอคอนไมค์ข้างกล่อง ESP หากผู้เล่นมีไมค์ (สีเขียว=กำลังพูด)",
    Default = false,
    Callback = function(state) espMicEnabled = state end
})

local ESPColorSection = ESPTab:Section({ Title = "Color Customization", Icon = "palette" })
ESPColorSection:Colorpicker({
    Title = "Enemy / Default Color",
    Desc = "เลือกสี ESP สำหรับผู้เล่นทั่วไป/ศัตรู",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color) espColor = color end
})

ESPColorSection:Colorpicker({
    Title = "Friend Color",
    Desc = "เลือกสี ESP สำหรับเพื่อนในเกม Roblox",
    Default = Color3.fromRGB(0, 255, 128),
    Callback = function(color) friendColor = color end
})

local ObjectSearchSection = ESPTab:Section({ Title = "Item / Object Search ESP", Icon = "search" })
ObjectSearchSection:Input({
    Title = "Search Object Name",
    Desc = "พิมพ์ชื่อไอเทม/วัตถุที่ต้องการแสดง ESP",
    Value = "",
    Placeholder = "เช่น Door, Chest, Coin...",
    Callback = function(val)
        searchTargetText = val
        updateObjectESP()
    end
})

local exactToggle, partialToggle
exactToggle = ObjectSearchSection:Toggle({
    Title = "Exact Match ESP (ชื่อตรงเป๊ะๆ)",
    Desc = "เปิด ESP เฉพาะออบเจกต์ที่ชื่อตรงเป๊ะทุกตัวอักษร",
    Default = false,
    Callback = function(state)
        exactMatchEnabled = state
        if state and partialMatchEnabled then
            partialMatchEnabled = false
            if partialToggle and partialToggle.SetValue then partialToggle:SetValue(false) end
        end
        updateObjectESP()
    end
})

partialToggle = ObjectSearchSection:Toggle({
    Title = "Partial Match ESP (ตรวจเฉพาะมีคำนี้ผสม)",
    Desc = "เปิด ESP หากชื่อวัตถุมีคำนี้ประกอบอยู่",
    Default = false,
    Callback = function(state)
        partialMatchEnabled = state
        if state and exactMatchEnabled then
            exactMatchEnabled = false
            if exactToggle and exactToggle.SetValue then exactToggle:SetValue(false) end
        end
        updateObjectESP()
    end
})

ObjectSearchSection:Colorpicker({
    Title = "Search ESP Color",
    Desc = "เลือกสีสำหรับไฮไลท์และข้อความไอเทมค้นหา",
    Default = Color3.fromRGB(255, 255, 0),
    Callback = function(color)
        objectEspColor = color
        updateObjectESP()
    end
})

-- ==================== TELEPORT TAB UI ====================
local TPSection = TPTab:Section({ Title = "Player Teleportation", Icon = "navigation" })
local tpPlayerDropdown = TPSection:Dropdown({
    Title = "Select Target Player",
    Desc = "เลือกผู้เล่นที่ต้องการวาร์ปไปหาทันที",
    Values = getPlayerList(),
    Value = "",
    Callback = function(v) selectedPlayerName = v end
})

TPSection:Button({
    Title = "Refresh Player List",
    Desc = "อัปเดตรายชื่อผู้เล่นล่าสุด",
    Callback = function()
        local updatedList = getPlayerList()
        if tpPlayerDropdown then
            pcall(function() tpPlayerDropdown:Set(updatedList) end)
        end
    end
})

TPSection:Button({
    Title = "Teleport to Player",
    Desc = "วาร์ปตัวละครของคุณไปหาผู้เล่นที่เลือกทันที",
    Callback = function()
        local targetPlayer = players:FindFirstChild(selectedPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = localPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

-- ==================== TWEEN SECTION ====================
local TrackingSection = TPTab:Section({ Title = "Tween", Icon = "crosshair" })

local mainPlayerDropdown = TrackingSection:Dropdown({
    Title = "Select Player",
    Desc = "เลือกผู้เล่นที่ต้องการติดตาม",
    Values = getPlayerList(),
    Value = "",
    Callback = function(v) selectedPlayerName = v end
})

TrackingSection:Button({
    Title = "Refresh Player List",
    Desc = "อัปเดตรายชื่อผู้เล่นล่าสุด",
    Callback = function()
        local updatedList = getPlayerList()
        if mainPlayerDropdown then
            pcall(function() mainPlayerDropdown:Set(updatedList) end)
        end
    end
})

TrackingSection:Dropdown({
    Title = "Tween Direction",
    Desc = "เลือกทิศทางที่จะ Tween ไปหาเป้าหมาย",
    Values = {"Behind", "Front", "Above", "Below", "Left", "Right"},
    Value = "Behind",
    Callback = function(v) tweenDirection = v end
})

TrackingSection:Input({
    Title = "Tween Distance",
    Desc = "ใส่ระยะห่างจากเป้าหมาย (ค่าเริ่มต้น: 5)",
    Value = "5",
    Placeholder = "เช่น 3, 5, 10...",
    Callback = function(val)
        local num = tonumber(val)
        if num then tweenDistance = num end
    end
})

TrackingSection:Toggle({
    Title = "Auto Look at Target",
    Desc = "เปิด/ปิด หันหน้าหาเป้าหมาย",
    Default = false,
    Callback = function(state) isAutoLooking = state end
})

TrackingSection:Toggle({
    Title = "Create Platform Under Feet",
    Desc = "สร้างพาร์ทรองใต้เท้าขณะ Tween",
    Default = true,
    Callback = function(state)
        createPlatform = state
        if not state and tempPlatform then
            tempPlatform:Destroy()
            tempPlatform = nil
        end
    end
})

TrackingSection:Toggle({
    Title = "Enable Relative Tween + BodyVelocity",
    Desc = "พุ่งตัวไปยังทิศทางที่เลือกอย่างลื่นไหล",
    Default = false,
    Callback = function(state)
        isTweeningRelative = state

        local myChar = localPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if not isTweeningRelative then
            if tempPlatform then tempPlatform:Destroy(); tempPlatform = nil end
            if myHRP then removeBodyVelocity(myHRP) end
        end

        if isTweeningRelative then
            task.spawn(function()
                while isTweeningRelative do
                    local targetPlayer = players:FindFirstChild(selectedPlayerName)
                    local currentChar = localPlayer.Character
                    local currentHRP = currentChar and currentChar:FindFirstChild("HumanoidRootPart")

                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and currentHRP then
                        local targetHRP = targetPlayer.Character.HumanoidRootPart
                        local targetPos = getTargetOffsetPosition(targetHRP, tweenDirection, tweenDistance)

                        local finalCF

                        if isAutoLooking then
                            -- FIX: Above/Below — ใช้ตำแหน่ง target จริงๆ ไม่ตัด Y ออก
                            -- ทำให้หันหน้าหาผู้เล่นได้ถูกต้องทุกทิศทาง
                            local lookTarget = targetHRP.Position

                            -- ป้องกัน edge case ตำแหน่งซ้อนกันพอดี
                            if (lookTarget - targetPos).Magnitude > 0.001 then
                                -- หันหน้าหา target แต่ล็อก roll ให้ตัวตั้งตรง
                                local forward = (lookTarget - targetPos).Unit
                                local right = Vector3.new(0, 1, 0):Cross(forward)
                                if right.Magnitude < 0.001 then
                                    -- กรณีมองตรงขึ้น/ลง ให้ใช้ worldRight แทน
                                    right = Vector3.new(1, 0, 0)
                                else
                                    right = right.Unit
                                end
                                local up = forward:Cross(right).Unit
                                finalCF = CFrame.fromMatrix(targetPos, right, up, -forward)
                            else
                                finalCF = CFrame.new(targetPos)
                            end
                        else
                            finalCF = CFrame.new(targetPos) * (targetHRP.CFrame - targetHRP.CFrame.Position)
                        end

                        updatePlatform(targetPos)
                        applyBodyVelocity(currentHRP, targetPos)

                        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
                        local tween = TweenService:Create(currentHRP, tweenInfo, {CFrame = finalCF})
                        tween:Play()
                    else
                        if currentHRP then removeBodyVelocity(currentHRP) end
                    end
                    task.wait(0.15)
                end
            end)
        end
    end
})

-- ==================== WAYPOINT SYSTEM ====================
local HttpService = game:GetService("HttpService")
local PlaceId = tostring(game.PlaceId)
local FolderName = "Script_Waypoints"
local FilePath = FolderName .. "/" .. PlaceId .. ".json"

local waypointsData = {}
local currentInputName = ""
local selectedWaypointName = ""
local waypointDropdown = nil

local function ensureFolder()
    if isfolder and not isfolder(FolderName) then
        pcall(makefolder, FolderName)
    end
end

local function saveWaypointsToFile()
    ensureFolder()
    if writefile then
        pcall(function()
            writefile(FilePath, HttpService:JSONEncode(waypointsData))
        end)
    end
end

local function loadWaypointsFromFile()
    ensureFolder()
    if isfile and readfile and isfile(FilePath) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(FilePath))
            if type(decoded) == "table" then
                waypointsData = decoded
            end
        end)
    end
end

local function getWaypointNamesList()
    local names = {}
    for name in pairs(waypointsData) do
        table.insert(names, name)
    end
    table.sort(names)
    if #names == 0 then
        table.insert(names, "ไม่มีจุดเซฟ")
    end
    return names
end

local function notify(title, desc, duration)
    if type(Notify) == "function" then
        Notify({ Title = title, Desc = desc, Duration = duration or 2 })
    end
end

loadWaypointsFromFile()

local WaypointSection = LocalPlayerTab:Section({ Title = "Saved Waypoints (Map Specific)", Icon = "map-pin" })

WaypointSection:Input({
    Title = "Waypoint Name",
    Desc = "พิมพ์ชื่อตำแหน่งที่ต้องการเซฟ",
    Placeholder = "พิมพ์ชื่อจุด...",
    Callback = function(text)
        currentInputName = text
    end
})

-- FIX: rebuildDropdown ที่ถูกต้อง ใช้ :Set() สำหรับ WindUI
local function rebuildDropdown()
    selectedWaypointName = ""
    local names = getWaypointNamesList()
    if waypointDropdown then
        pcall(function()
            waypointDropdown:Set(names)
        end)
    else
        waypointDropdown = WaypointSection:Dropdown({
            Title = "Select Waypoint",
            Desc = "เลือกจุดที่ต้องการเทเลพอร์ต",
            Values = names,
            Value = "",
            Callback = function(val)
                if val ~= "ไม่มีจุดเซฟ" then
                    selectedWaypointName = val
                else
                    selectedWaypointName = ""
                end
            end
        })
    end
end

rebuildDropdown()

WaypointSection:Button({
    Title = "Save Current Position",
    Desc = "เซฟจุดปัจจุบันด้วยชื่อที่พิมพ์ไว้ข้างบน",
    Callback = function()
        local trimmed = currentInputName:match("^%s*(.-)%s*$")
        if trimmed == "" then
            notify("Error", "กรุณาพิมพ์ชื่อจุดก่อน!")
            return
        end
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            waypointsData[trimmed] = { root.CFrame:GetComponents() }
            saveWaypointsToFile()
            rebuildDropdown()
            notify("Saved!", "เซฟจุด: " .. trimmed)
        else
            notify("Error", "ไม่พบตัวละคร!")
        end
    end
})

WaypointSection:Button({
    Title = "Refresh Waypoints",
    Desc = "กดเพื่อรีเฟรช Dropdown ใหม่",
    Callback = function()
        rebuildDropdown()
        notify("Refreshed", "รีเฟรชรายชื่อจุดเรียบร้อย", 1.5)
    end
})

WaypointSection:Button({
    Title = "Teleport to Selected",
    Desc = "วาร์ปไปจุดที่เลือก",
    Callback = function()
        if selectedWaypointName == "" or not waypointsData[selectedWaypointName] then
            notify("Error", "กรุณาเลือกจุดก่อน!")
            return
        end
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(table.unpack(waypointsData[selectedWaypointName]))
        else
            notify("Error", "ไม่พบตัวละคร!")
        end
    end
})

WaypointSection:Button({
    Title = "Delete Selected Waypoint",
    Desc = "ลบจุดที่เลือก",
    Callback = function()
        if selectedWaypointName == "" or not waypointsData[selectedWaypointName] then
            notify("Error", "กรุณาเลือกจุดก่อน!")
            return
        end
        local deleted = selectedWaypointName
        waypointsData[deleted] = nil
        saveWaypointsToFile()
        rebuildDropdown()
        notify("Deleted", "ลบจุด: " .. deleted)
    end
})

-- ==================== LOCAL PLAYER TAB ====================
local MovementSection = LocalPlayerTab:Section({ Title = "Movement System", Icon = "move" })

MovementSection:Toggle({
    Title = "Noclip",
    Desc = "เดินทะลุกำแพงและสิ่งกีดขวางได้",
    Value = false,
    Callback = function(state) setNoclip(state) end
})

MovementSection:Toggle({
    Title = "Infinite Jump",
    Desc = "กระโดดบนอากาศได้อย่างต่อเนื่องไม่จำกัด",
    Value = false,
    Callback = function(state) setInfiniteJump(state) end
})

MovementSection:Slider({
    Title = "Fly Speed",
    Desc = "ปรับความเร็วในการบิน",
    Value = {
        Min = 10,
        Max = 200,
        Default = 50,
    },
    Step = 1,
    Callback = function(val)
        flySpeed = tonumber(val) or 50
    end
})

MovementSection:Toggle({
    Title = "Fly",
    Desc = "บินอย่างอิสระ (รองรับ WASD บน PC และ Joystick บนมือถือ)",
    Value = false,
    Callback = function(state)
        if state then startFly() else stopFly() end
    end
})

-- ==================== KEYBIND TAB UI ====================
local MovementKeybindSection = KeybindTab:Section({ Title = "Movement Keybinds", Icon = "command" })

local keybindNoclipState = false
local keybindInfJumpState = false
local keybindFlyState = false

MovementKeybindSection:Keybind({
    Title = "Noclip Keybind",
    Desc = "กดเพื่อเปิด/ปิด เดินทะลุกำแพง",
    Value = "V",
    Callback = function()
        keybindNoclipState = not keybindNoclipState
        setNoclip(keybindNoclipState)
        if type(Notify) == "function" then
            Notify({ Title = 'Noclip', Desc = keybindNoclipState and 'เปิดใช้งาน' or 'ปิดใช้งาน', Duration = 1.5 })
        end
    end,
})

MovementKeybindSection:Keybind({
    Title = "Infinite Jump Keybind",
    Desc = "กดเพื่อเปิด/ปิด กระโดดรัวบนอากาศ",
    Value = "T",
    Callback = function()
        keybindInfJumpState = not keybindInfJumpState
        setInfiniteJump(keybindInfJumpState)
        if type(Notify) == "function" then
            Notify({ Title = 'Infinite Jump', Desc = keybindInfJumpState and 'เปิดใช้งาน' or 'ปิดใช้งาน', Duration = 1.5 })
        end
    end,
})

MovementKeybindSection:Keybind({
    Title = "Fly Keybind",
    Desc = "กดเพื่อเปิด/ปิด บิน",
    Value = "F",
    Callback = function()
        keybindFlyState = not keybindFlyState
        if keybindFlyState then startFly() else stopFly() end
        if type(Notify) == "function" then
            Notify({ Title = 'Fly', Desc = keybindFlyState and 'เปิดใช้งาน' or 'ปิดใช้งาน', Duration = 1.5 })
        end
    end,
})

-- ==================== MISC TAB UI ====================
local SpeedSection = MiscTab:Section({ Title = "Speed Controls", Icon = "gauge" })
SpeedSection:Input({
    Title = "Custom Speed Input",
    Desc = "ใส่เลขความเร็วที่ต้องการ",
    Value = "",
    Placeholder = "เช่น 30, 50...",
    Callback = function(input)
        local num = tonumber(input)
        customSpeed = num or nil
        if speedConnection then setSpeedLock(customSpeed or defaultSpeed) end
    end
})

SpeedSection:Toggle({
    Title = "Lock Speed",
    Desc = "ล็อคความเร็วการเดินไว้ตามค่าที่ตั้ง",
    Default = false,
    Callback = function(State)
        if State then
            setSpeedLock(customSpeed or defaultSpeed)
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
        end
    end
})

SpeedSection:Button({
    Title = "Reset to Default Speed",
    Desc = "ปรับความเร็วกลับเป็นค่าดั้งเดิม",
    Callback = function()
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            if speedConnection then speedConnection:Disconnect(); speedConnection = nil end
            hum.WalkSpeed = defaultSpeed
        end
    end
})

local EmoteSection = MiscTab:Section({ Title = "Emote & Animation Copier", Icon = "smile" })

local emotePlayerDropdown = EmoteSection:Dropdown({
    Title = "Select Target Player",
    Desc = "เลือกผู้เล่นที่ต้องการคัดลอกท่าทาง (Emote)",
    Values = getPlayerList(),
    Value = "",
    Callback = function(v) emoteTargetPlayerName = v end
})

EmoteSection:Button({
    Title = "Refresh Player List",
    Desc = "อัปเดตรายชื่อผู้เล่นล่าสุด",
    Callback = function()
        local updatedList = getPlayerList()
        if emotePlayerDropdown then
            pcall(function() emotePlayerDropdown:Set(updatedList) end)
        end
    end
})

EmoteSection:Toggle({
    Title = "Copy Player Emote & Movement",
    Desc = "ก็อปปี้ท่าทาง/Emote/สคริปต์ดัดท่า ของผู้เล่นทันทีแบบ Real-time",
    Default = false,
    Callback = function(state)
        isCopyingPlayerEmote = state
        if not state then
            stopMirroring()
            stopCustomEmotes()
        else
            if emoteTargetPlayerName ~= "" then
                stopCustomEmotes()
                startMirroringTarget(emoteTargetPlayerName)
            end
        end
    end
})

EmoteSection:Input({
    Title = "Custom Emote / Anim ID",
    Desc = "ใส่ ID ของ Emote หรือ Animation ที่ต้องการเล่น",
    Value = "",
    Placeholder = "ใส่หมายเลข ID เช่น 369675713...",
    Callback = function(val) customEmoteIdInput = val end
})

EmoteSection:Toggle({
    Title = "Play Custom ID Emote",
    Desc = "เปิดเพื่อเล่น Emote จาก ID / ปิดเพื่อหยุดเล่น",
    Default = false,
    Callback = function(state)
        isPlayingCustomEmote = state
        if state then
            stopCustomEmotes()
            customTrack = playEmoteById(customEmoteIdInput)
        else
            stopCustomEmotes()
        end
    end
})

local SafetySection = MiscTab:Section({ Title = "Safety", Icon = "shield" })
SafetySection:Toggle({
    Title = "Safe Mode (< 50% HP TP)",
    Desc = "วาร์ปหนีอัตโนมัติเมื่อเลือดต่ำกว่า 50%",
    Default = false,
    Callback = function(state)
        safeModeEnabled = state
        if safeModeEnabled then
            task.spawn(function()
                while safeModeEnabled do
                    local myChar = localPlayer.Character
                    if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
                        local humanoid = myChar.Humanoid
                        local myHRP = myChar.HumanoidRootPart
                        if humanoid.Health > 0 and (humanoid.Health / humanoid.MaxHealth) <= 0.5 then
                            myHRP.CFrame = CFrame.new(safeModeLocation)
                            task.wait(2)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

SafetySection:Toggle({
    Title = "Anti-Fling (Auto)",
    Default = false,
    Callback = function(state)
        AntiFling.Enabled = state
        if state then AntiFling.Start() end
    end
})

local ToolsSection = MiscTab:Section({ Title = "Tools", Icon = "wrench" })
ToolsSection:Button({
    Title = "Get TP Tool",
    Desc = "ให้เครื่องมือคลิกเพื่อวาร์ปในกระเป๋าเป้",
    Callback = function()
        local plr = localPlayer
        if plr then
            local mouse = plr:GetMouse()
            local tptool = Instance.new("Tool")
            tptool.Name = "Click TP"
            tptool.RequiresHandle = false
            tptool.CanBeDropped = false
            tptool.Parent = plr:FindFirstChildOfClass("Backpack") or plr:WaitForChild("Backpack")
            tptool.Activated:Connect(function()
                local character = plr.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart and mouse.Target then
                        humanoidRootPart.CFrame = CFrame.new(mouse.Hit.X, mouse.Hit.Y + 3, mouse.Hit.Z)
                    end
                end
            end)
        end
    end
})

print("BlackCrown-X loaded")
Window:SetToggleKey(Enum.KeyCode.LeftAlt)
