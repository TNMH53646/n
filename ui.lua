
-- ==================== FIXED SCRIPT ====================ใหม่

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local rs = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ProximityService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

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
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= localPlayer then
            table.insert(list, p.Name)
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

-- รายชื่อข้อต่อหลักในตัวละคร (ทั้ง R6 และ R15)
local jointNames = {
    "RootJoint", "Neck", "Left Shoulder", "Right Shoulder", "Left Hip", "Right Hip", -- R6
    "Waist", "Spine", "LeftShoulder", "RightShoulder", "LeftUpperArm", "RightUpperArm", -- R15
    "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "LeftHip", "RightHip",
    "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"
}

-- ฟังก์ชันหยุดการซิงค์ท่าทาง
local function stopMirroring()
    if mirrorConnection then
        mirrorConnection:Disconnect()
        mirrorConnection = nil
    end
end

-- ฟังก์ชันดึง Motor6D ทั้งหมดในตัวละคร
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

-- ฟังก์ชันเริ่มคัดลอกการเคลื่อนไหวแบบ Real-time (Mirroring)
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

            -- คัดลอกค่า C6/Transform ของทุกข้อต่อตรงๆ (รองรับทั้ง Emote ปกติ และสคริปต์ดัดข้อต่อ)
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
local selectedPlayerName = ""

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local TweenService = game:GetService("TweenService")

local function getPlayerList()
    local list = {}
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= localPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- คำนวณหาตำแหน่งพุ่งไป (Position เท่านั้น)
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
        if bv then
            bv:Destroy()
        end
    end
end

local AntiFling = {}
AntiFling.Enabled = false

local RunService = game:GetService("RunService")

local MAX_VELOCITY = 90 -- ปรับตาม threshold ที่เหมาะกับเกม
local connection

local function getHRP()
    local char = localPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function AntiFling.Start()
    if connection then return end
    connection = RunService.Heartbeat:Connect(function()
        if not AntiFling.Enabled then return end
        local hrp = getHRP()
        if not hrp then return end

        local vel = hrp.AssemblyLinearVelocity
        local speed = vel.Magnitude

        if speed > MAX_VELOCITY then
            -- ตัดความเร็วที่ผิดปกติทิ้ง กัน fling
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

function AntiFling.Stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- ==================== UI INITIALIZATION ====================
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("❌ Failed to load WindUI Library")
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
local MiscTab = Window:Tab({ Title = "Misc", Icon = "ellipsis", Locked = false })

-- ==================== MAIN TAB UI ====================


-- ==================== ESP SYSTEM ====================
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

local espNameEnabled = false
local espBoxEnabled = false
local espTracerEnabled = false
local espHighlightEnabled = false
local espHealthBarEnabled = true
local espHealthTextEnabled = true -- เปิดการแสดงตัวเลข % HP

local espColor = Color3.fromRGB(255, 0, 0)
local friendColor = Color3.fromRGB(0, 255, 128) -- สีเพื่อน (ตั้งค่าผ่าน UI ได้)

local espObjects = {}
local friendCache = {}

local hasDrawingAPI = (typeof(Drawing) == "table" and typeof(Drawing.new) == "function")

-- ฟังก์ชันเช็กว่าผู้เล่นคนนั้นเป็นเพื่อนเราหรือไม่
local function checkIsFriend(p)
    if friendCache[p.UserId] ~= nil then
        return friendCache[p.UserId]
    end
    local isFriend = false
    pcall(function()
        isFriend = localPlayer:IsFriendsWith(p.UserId)
    end)
    friendCache[p.UserId] = isFriend
    return isFriend
end

local function removeESP(p)
    if espObjects[p] then
        if espObjects[p].connection then espObjects[p].connection:Disconnect() end
        if espObjects[p].highlight then espObjects[p].highlight:Destroy() end
        if espObjects[p].boxOutline then pcall(function() espObjects[p].boxOutline:Remove() end) end
        if espObjects[p].boxInline then pcall(function() espObjects[p].boxInline:Remove() end) end
        if espObjects[p].healthBarOutline then pcall(function() espObjects[p].healthBarOutline:Remove() end) end
        if espObjects[p].healthBarBG then pcall(function() espObjects[p].healthBarBG:Remove() end) end
        if espObjects[p].healthBarFill then pcall(function() espObjects[p].healthBarFill:Remove() end) end
        if espObjects[p].healthText then pcall(function() espObjects[p].healthText:Remove() end) end
        if espObjects[p].nameText then pcall(function() espObjects[p].nameText:Remove() end) end
        if espObjects[p].tracer then pcall(function() espObjects[p].tracer:Remove() end) end
        espObjects[p] = nil
    end
end

local function applyESPToCharacter(p, charModel)
    removeESP(p)
    if not charModel then return end

    local hrpTarget = charModel:WaitForChild("HumanoidRootPart", 5)
    local humanoidTarget = charModel:WaitForChild("Humanoid", 5)
    if not hrpTarget or not humanoidTarget then return end

    local isFriend = checkIsFriend(p)
    local activeColor = isFriend and friendColor or espColor

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = activeColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Enabled = espHighlightEnabled
    highlight.Parent = charModel

    local boxOutline, boxInline, healthBarOutline, healthBarBG, healthBarFill, healthText, nameText, tracer
    if hasDrawingAPI then
        pcall(function()
            -- Box ESP
            boxOutline = Drawing.new("Square")
            boxOutline.Visible = false
            boxOutline.Color = Color3.new(0, 0, 0)
            boxOutline.Thickness = 3

            boxInline = Drawing.new("Square")
            boxInline.Visible = false
            boxInline.Color = activeColor
            boxInline.Thickness = 1

            -- Health Bar Elements
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

            -- Health Text (%)
            healthText = Drawing.new("Text")
            healthText.Visible = false
            healthText.Color = Color3.fromRGB(255, 255, 255)
            healthText.Size = 12
            healthText.Center = false
            healthText.Outline = true

            -- Name & Tracer
            nameText = Drawing.new("Text")
            nameText.Visible = false
            nameText.Color = activeColor
            nameText.Size = 14
            nameText.Center = true
            nameText.Outline = true

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
            if tracer then tracer.Visible = false end
            return
        end

        local currentColor = checkIsFriend(p) and friendColor or espColor

        highlight.FillColor = currentColor
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Enabled = espHighlightEnabled

        if boxInline then boxInline.Color = currentColor end
        if nameText then nameText.Color = currentColor end
        if tracer then tracer.Color = currentColor end

        if hasDrawingAPI then
            -- ค้นหาจุดกึ่งกลางของเป้าหมาย
            local pos, onScreen = camera:WorldToViewportPoint(hrpTarget.Position)
            if onScreen then
                -- FIX: สร้างจุดสมมติด้านบนและล่างจาก HRP โดยไม่อิงกับขนาดกล่องหรือการเอียงของโมเดล
                -- วิธีนี้ทำให้กล่องไม่บิดเบี้ยวตาม Shift Lock และป้องกันบั๊กกล่องยักษ์เวลาไอเทมหลุด
                local topPos = hrpTarget.Position + Vector3.new(0, 2.5, 0)
                local bottomPos = hrpTarget.Position - Vector3.new(0, 3, 0)
                
                local top, tOn = camera:WorldToViewportPoint(topPos)
                local bottom, bOn = camera:WorldToViewportPoint(bottomPos)

                if tOn and bOn then
                    local boxHeight = math.abs(bottom.Y - top.Y)
                    local boxWidth = boxHeight * 0.65 -- อัตราส่วนมาตรฐานตัวละคร Roblox
                    
                    local minX = pos.X - (boxWidth / 2)
                    local minY = top.Y

                    -- Box ESP Logic
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

                    -- Health Bar & Text ESP Logic
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

                        -- BG
                        healthBarBG.Size = Vector2.new(barWidth, boxHeight)
                        healthBarBG.Position = Vector2.new(barX, minY)
                        healthBarBG.Visible = true

                        -- Fill
                        healthBarFill.Size = Vector2.new(barWidth, fillHeight)
                        healthBarFill.Position = Vector2.new(barX, fillY)
                        healthBarFill.Color = barColor
                        healthBarFill.Visible = true

                        -- Outline
                        healthBarOutline.Size = Vector2.new(barWidth + 2, boxHeight + 2)
                        healthBarOutline.Position = Vector2.new(barX - 1, minY - 1)
                        healthBarOutline.Visible = true

                        -- Health Text (%)
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

                    -- Name & Distance ESP Logic
                    if espNameEnabled and nameText then
                        local myChar = localPlayer.Character
                        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        local distance = myHRP and math.floor((hrpTarget.Position - myHRP.Position).Magnitude) or 0

                        nameText.Text = string.format("%s [%dm]", p.Name, distance)
                        nameText.Position = Vector2.new(pos.X, minY - 18)
                        nameText.Visible = true
                    else
                        if nameText then nameText.Visible = false end
                    end
                end

                -- Tracer ESP Logic
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
                if tracer then tracer.Visible = false end
            end
        end
    end)

    espObjects[p] = {
        highlight = highlight,
        boxOutline = boxOutline,
        boxInline = boxInline,
        healthBarOutline = healthBarOutline,
        healthBarBG = healthBarBG,
        healthBarFill = healthBarFill,
        healthText = healthText,
        nameText = nameText,
        tracer = tracer,
        connection = conn
    }
end

for _, p in ipairs(players:GetPlayers()) do
    if p ~= localPlayer then
        p.CharacterAdded:Connect(function(c) applyESPToCharacter(p, c) end)
        if p.Character then task.spawn(function() applyESPToCharacter(p, p.Character) end) end
    end
end

players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c) applyESPToCharacter(p, c) end)
end)

players.PlayerRemoving:Connect(function(p)
    friendCache[p.UserId] = nil
    removeESP(p)
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
    
    if searchTargetText == "" or (not exactMatchEnabled and not partialMatchEnabled) then
        return
    end

    local targetLower = string.lower(searchTargetText)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if localPlayer.Character and obj:IsDescendantOf(localPlayer.Character) then
                continue
            end

            local objName = obj.Name
            local isMatch = false

            if exactMatchEnabled then
                if objName == searchTargetText then
                    isMatch = true
                end
            elseif partialMatchEnabled then
                if string.find(string.lower(objName), targetLower, 1, true) then
                    isMatch = true
                end
            end

            if isMatch then
                applyESPToObject(obj)
            end
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

    for _, p in ipairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local targetPart = p.Character:FindFirstChild(aimbotTargetPart)
            local humanoid = p.Character:FindFirstChild("Humanoid")

            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local screenPos2D = Vector2.new(screenPoint.X, screenPoint.Y)
                    local dist = (screenPos2D - mouseLocation).Magnitude

                    local withinFov = not fovEnabled or (dist <= fovRadius)
                    local visible = isVisible(targetPart, p.Character)

                    if withinFov and visible and dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = p
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

ESPSettingsSection:Toggle({
    Title = "Enable Health Bar",
    Desc = "แสดงแถบเลือดข้างกล่อง ESP",
    Default = true,
    Callback = function(state) espHealthBarEnabled = state end
})

ESPSettingsSection:Toggle({
    Title = "Enable Health Percent Text",
    Desc = "แสดงตัวเลข % เลือดข้างแถบเลือด",
    Default = true,
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
            if partialToggle and partialToggle.SetValue then
                partialToggle:SetValue(false)
            end
        end
        updateObjectESP()
    end
})

partialToggle = ObjectSearchSection:Toggle({
    Title = "Partial Match ESP (ตรวจเฉพาะมีคำนี้ผสม)",
    Desc = "เปิด ESP หากชื่อวัตถุมีคำนี้ประกอบอยู่ (ไม่จำเป็นต้องตรงเป๊ะ)",
    Default = false,
    Callback = function(state)
        partialMatchEnabled = state
        if state and exactMatchEnabled then
            exactMatchEnabled = false
            if exactToggle and exactToggle.SetValue then
                exactToggle:SetValue(false)
            end
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
            if typeof(tpPlayerDropdown.SetValues) == "function" then
                tpPlayerDropdown:SetValues(updatedList)
            elseif typeof(tpPlayerDropdown.Refresh) == "function" then
                tpPlayerDropdown:Refresh(updatedList, true)
            elseif tpPlayerDropdown.Values then
                tpPlayerDropdown.Values = updatedList
            end
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
            if typeof(mainPlayerDropdown.SetValues) == "function" then
                mainPlayerDropdown:SetValues(updatedList)
            elseif typeof(mainPlayerDropdown.Refresh) == "function" then
                mainPlayerDropdown:Refresh(updatedList, true)
            elseif mainPlayerDropdown.Values then
                mainPlayerDropdown.Values = updatedList
            end
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
    Desc = "เปิด/ปิด หันหน้าหาเป้าหมาย (ล็อคตัวตรง ไม่เอียงกระดาน)",
    Default = false,
    Callback = function(state)
        isAutoLooking = state
    end
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
            if tempPlatform then
                tempPlatform:Destroy()
                tempPlatform = nil
            end
            if myHRP then
                removeBodyVelocity(myHRP)
            end
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
                            -- คำนวณจุดมองให้อยู่ในแนวราบ (ตัดแกน Y ออกเฉพาะตอนคำนวณการหมุน)
                            -- เพื่อให้ตัวละคร "หันหน้าไปหาเป้าหมาย" โดยที่ตัวยังตั้งตรง ไม่ลอยเอียง 45 องศา
                            local lookAtHorizontal = Vector3.new(targetHRP.Position.X, targetPos.Y, targetHRP.Position.Z)
                            
                            -- ป้องกัน Error กรณีตัวละครอยู่ตรงหัวเป้าหมายพอดีเป๊ะ
                            if (lookAtHorizontal - targetPos).Magnitude > 0.001 then
                                finalCF = CFrame.lookAt(targetPos, lookAtHorizontal)
                            else
                                finalCF = CFrame.new(targetPos)
                            end
                        else
                            -- ปิด Auto Look: หันหน้าทิศเดียวกับเป้าหมายแบบปกติ
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
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
            hum.WalkSpeed = defaultSpeed
        end
    end
})

local EmoteSection = MiscTab:Section({ Title = "Emote & Animation Copier", Icon = "smile" })

-- 1. ระบบ Copy Emote จากผู้เล่น
local emotePlayerDropdown = EmoteSection:Dropdown({
    Title = "Select Target Player",
    Desc = "เลือกผู้เล่นที่ต้องการคัดลอกท่าทาง (Emote)",
    Values = getPlayerList(),
    Value = "",
    Callback = function(v)
        emoteTargetPlayerName = v
    end
})

EmoteSection:Button({
    Title = "Refresh Player List",
    Desc = "อัปเดตรายชื่อผู้เล่นล่าสุด",
    Callback = function()
        local updatedList = getPlayerList()
        if emotePlayerDropdown then
            if typeof(emotePlayerDropdown.SetValues) == "function" then
                emotePlayerDropdown:SetValues(updatedList)
            elseif typeof(emotePlayerDropdown.Refresh) == "function" then
                emotePlayerDropdown:Refresh(updatedList, true)
            elseif emotePlayerDropdown.Values then
                emotePlayerDropdown.Values = updatedList
            end
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

EmoteSection:Toggle({
    Title = "Copy Player Emote",
    Desc = "เปิด/ปิด การลอกเลียนแบบท่าทางของผู้เล่นที่เลือกทันที",
    Default = false,
    Callback = function(state)
        isCopyingPlayerEmote = state

        if not state then
            if copyEmoteLoopConnection then
                copyEmoteLoopConnection:Disconnect()
                copyEmoteLoopConnection = nil
            end
            stopCustomEmotes()
        else
            task.spawn(function()
                local lastAnimId = ""
                while isCopyingPlayerEmote do
                    local targetPlayer = players:FindFirstChild(emoteTargetPlayerName)
                    if targetPlayer and targetPlayer.Character then
                        local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                        local currentAnimId = getActiveAnimationId(targetHum)

                        if currentAnimId and currentAnimId ~= lastAnimId then
                            lastAnimId = currentAnimId
                            stopCustomEmotes()
                            customTrack = playEmoteById(currentAnimId)
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

-- 2. ระบบ Play Emote จาก Animation ID
EmoteSection:Input({
    Title = "Custom Emote / Anim ID",
    Desc = "ใส่ ID ของ Emote หรือ Animation ที่ต้องการเล่น",
    Value = "",
    Placeholder = "ใส่หมายเลข ID เช่น 369675713...",
    Callback = function(val)
        customEmoteIdInput = val
    end
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
        if state then
            AntiFling.Start()
        end
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

print("load")

Window:SetToggleKey(Enum.KeyCode.LeftAlt)
