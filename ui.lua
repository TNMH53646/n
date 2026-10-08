-- ==================== BlackCrown-X v3.7.0 ====================
-- Changes (จาก v3.6.4):
--   * Quick Button / ปุ่มวาร์ป เล็กลง (ขนาดคงที่ BCX.QB_SIZE) และชื่อยาวๆ ย่อตัวอักษรเองไม่ล้นปุ่ม
--   * ปุ่มวาร์ป (Waypoint Button) ย้ายไปอยู่ฝั่งขวาของจอ (ปุ่มเก่าที่เคยเซฟไว้ฝั่งซ้ายจะถูกย้ายมาขวาให้เอง)
--   * ปุ่มวาร์ปเลือกโหมดได้ตอนสร้าง: Teleport (สีฟ้า) = วาร์ปทันที / Tween (สีม่วง) = ไหลไปที่จุดด้วยความเร็วที่ตั้งได้
--   * ล็อกตำแหน่งปุ่มใช้ได้จริงทั้ง Quick Button และปุ่มวาร์ป + มีไอคอน 🔒 บนปุ่มตอนล็อก
--       - ล็อกเป็นฟังก์ชัน "Lock Buttons" ใช้ผ่าน Quick Button / คีย์ลัดได้
--       - ปุ่มวาร์ปติดตามเฉพาะนิ้วที่แตะปุ่ม (เดิมนิ้วอื่น เช่น จอยเดิน ทำให้ปุ่มขยับได้) และต้องลากเกิน 14px ถึงจะนับว่าลาก
--   * Hotkey Binder ย้ายไปอยู่เหนือ Keybinds + ทุกปุ่มวาร์ปจะมี Keybind ของตัวเองใน Settings > Waypoint Keys ("Waypoint: ชื่อจุด")
--       แสดงปุ่มที่ใช้อยู่ในช่อง Keybind นั้นเลย (ตั้งผ่าน Hotkey Binder ก็ซิงก์กัน)
--   * NPC ESP: ไฮไลต์ + ชื่อ + ระยะ ของทุกตัวที่มี Humanoid และไม่ใช่ผู้เล่น (ไม่ GetDescendants ทุกเฟรม ใช้ DescendantAdded + สแกนครั้งเดียวแบบแบ่งเฟรม)
--       เปิด/ปิดผ่าน Quick Button / คีย์ลัดได้ ("NPC ESP")
-- Changes (จาก v3.6.3):
--   * แก้ CPU สไปค์ 1-3 วินาทีที่เกิดจากรายชื่อผู้เล่นใน Dropdown:
--       - BCX.refreshDD: รวมเหตุการณ์คนเข้า/ออกเป็นครั้งเดียว (debounce 3 วิ)
--       - ไม่รีเฟรชถ้ารายชื่อไม่เปลี่ยน / ไม่รีเฟรชตอนเมนูปิด (ไปทำตอนเปิดเมนู)
--       - รีเฟรชทีละ Dropdown เฟรมละอัน ไม่ทำ 5 อันพร้อมกันในเฟรมเดียว
--   * Object Search ESP: debounce, สแกนแบบแบ่งเฟรม, เปลี่ยนสีไม่สแกนใหม่
--   * Mic Indicator: แคชผลค้นหา VoiceSource (เดิมค้นแบบ recursive ทุกเฟรมทุกคน)
-- Changes (จาก v3.6):
--   * แก้ CPU สไปค์ตอนเปิดแค่ Crosshair:
--       - Crosshair: หน่วงการสร้างใหม่ (debounce) ไม่สร้างใหม่ทุกครั้งที่ลาก Slider / Colorpicker
--       - Free Mouse: เขียนค่า MouseBehavior / MouseIconEnabled / Visible เฉพาะตอนค่าไม่ตรง (ไม่เขียนทับทุกเฟรม)
--       - Free Mouse: สแกน PlayerGui เพื่อซ่อนเมาส์เกมแบบแบ่งเฟรม (ไม่ค้างก้อนเดียวตอนเปิดเมนู)
-- Changes (จาก v3.5):
--   * ระบบ Fling ถูกเปลี่ยนเป็นแบบ SkidFling (ย้ายมาจากสคริปต์ MM2): พุ่งหมุนชนเป้าหมายด้วยความเร็วสูงมาก
--     รองรับ Selected Player / All Players, กดปิดแล้วกลับที่เดิมทันที, คืนค่า FallenPartsDestroyHeight และกล้องให้เอง
--     (ยังใช้ผ่าน BCX.feat("Fling") เหมือนเดิม จึงซิงก์ UI / คีย์ลัด / Quick Button ครบ)
--   * แก้บั๊กเมาส์ค้างกลางจอตอนปิดเมนูในมุมมองบุคคลที่ 3 (เคยเปิดชิปล็อกมาก่อน)
-- Changes (จาก v3.4):
--   * Auto Free Mouse: เปิดเมนู UI = เมาส์อิสระเปิดเอง / ปิดเมนู UI = เมาส์อิสระปิดเอง
--     (เปิด/ปิดฟีเจอร์นี้ได้ที่ Settings > Keybinds > Auto Free Mouse, กด Y สลับเองระหว่างนั้นได้ตามปกติ)
-- Changes (จาก v3.3):
--   * Crosshair เลือกสไตล์ได้ 9 แบบ + ความหนา + ขอบดำ
--   * สีของ Colorpicker ทุกตัวเซฟลงไฟล์ colors.json เองทันทีที่เปลี่ยน
-- Changes (จาก v3.2):
--   * คีย์ลัดทุกตัวมาอยู่หน้า Keybinds และเปลี่ยนปุ่มได้
--   * Click TP: กดปุ่มค้างไว้ แล้วคลิกตรงจุดไหนก็วาร์ปไปจุดนั้น + Quick Button / สวิตช์ "Click TP"
-- Changes (จาก v3.1):
--   * ระบบสถานะกลาง BCX.F / BCX.feat(): UI / คีย์ลัด / Quick Button ซิงก์กันเสมอ

local genv = (getgenv and getgenv()) or _G
if genv.BCX_Instance and genv.BCX_Instance.destroy then
    pcall(genv.BCX_Instance.destroy)
    genv.BCX_Instance = nil
end
genv.BCX_Reloading = false

local launch
launch = function()

-- ==================== JANITOR (เก็บทุกอย่างที่ต้องทำลายตอน reload) ====================
local J = { conns = {}, objs = {}, extra = {}, dead = false }
function J.track(c) if c then table.insert(J.conns, c) end return c end
function J.obj(o) if o then table.insert(J.objs, o) end return o end
function J.onClean(fn) table.insert(J.extra, fn) end
function J.destroy()
    if J.dead then return end
    J.dead = true
    for i = #J.extra, 1, -1 do pcall(J.extra[i]) end
    for _, c in ipairs(J.conns) do pcall(function() c:Disconnect() end) end
    for _, o in ipairs(J.objs) do pcall(function() o:Destroy() end) end
    J.conns, J.objs, J.extra = {}, {}, {}
    if genv.BCX_Instance and genv.BCX_Instance.destroy == J.destroy then genv.BCX_Instance = nil end
end
genv.BCX_Instance = { destroy = J.destroy }

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

J.track(rs.RenderStepped:Connect(function()
    local c = workspace.CurrentCamera
    if c and c ~= camera then camera = c end
end))

-- Anti AFK
J.track(localPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
end))

-- Instant Proximity Prompt
J.track(ProximityService.PromptShown:Connect(function(prompt)
    prompt.HoldDuration = 0
end))

-- ==================== VARIABLES ====================
local selectedPlayerName = ""
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

local BCX = {
    Lang = "English", Registry = {}, TabReg = {}, dead = false,
    afOn = false, afConn = nil, maxVel = 90,
    flinging = false, flingAllOn = false, flingTarget = "", flingConn = nil, flingOrigCF = nil,
    UI = {},   -- อ้างอิงสวิตช์ใน UI ของแต่ละฟังก์ชัน (ใช้ซิงก์)
    F = {},    -- ตารางฟังก์ชันกลาง (สถานะจริง)
}

-- จำค่า FallenPartsDestroyHeight เดิมของเกม (ใช้คืนค่าหลัง Fling) ถ้าเป็น NaN จากรอบก่อนให้ใช้ค่ามาตรฐาน
BCX.FPDH = workspace.FallenPartsDestroyHeight
if BCX.FPDH ~= BCX.FPDH then BCX.FPDH = -500 end

-- ==================== KEYBIND REGISTRY (ปรับปุ่มได้จากหน้า Keybinds) ====================
-- ค่าเริ่มต้นของแต่ละปุ่ม; ค่าจริงอ่านจากสวิตช์ Keybind ใน UI (BCX.KB) ทุกครั้งที่กด
BCX.KB = {}
BCX.keys = {
    ["Free Mouse"] = "Y", ["Click TP Key"] = "R", ["Toggle UI"] = "LeftAlt",
    ["Fly Up"] = "Space", ["Fly Down"] = "LeftControl",
    ["Emergency Reset Key"] = "Delete", ["Force Mouse Lock Key"] = "K",
}
function BCX.keyName(name)
    local el = BCX.KB[name]
    local v = el and el.Value
    if typeof(v) == "EnumItem" then v = v.Name end
    if type(v) == "string" and v ~= "" then return v end
    return BCX.keys[name]
end
function BCX.keyCode(name)
    local ok, kc = pcall(function() return Enum.KeyCode[BCX.keyName(name)] end)
    if ok and kc then return kc end
    return Enum.KeyCode[BCX.keys[name]]
end
function BCX.keyIs(name, input)
    return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == BCX.keyName(name)
end
-- callback ของ Keybind ที่ใช้แค่จำชื่อปุ่ม (ตัวจัดการจริงอยู่ที่ InputBegan ของเรา)
function BCX.kbRec(name, extra)
    return function(v)
        if type(v) == "string" and v ~= "" then
            BCX.keys[name] = v
            if extra then pcall(extra, v) end
        end
    end
end

-- โหมด UI: Auto = ตรวจอุปกรณ์เอง, PC = หัวข้อบรรทัดเดียว, Mobile = กล่อง Section
BCX.UIPref = "Auto"
pcall(function()
    if isfile and isfile("BlackCrown-X/uimode.txt") then
        local m = readfile("BlackCrown-X/uimode.txt")
        if m == "Auto" or m == "PC" or m == "Mobile" then BCX.UIPref = m end
    end
end)
local detectedMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
BCX.isMobile = (BCX.UIPref == "Mobile") or (BCX.UIPref == "Auto" and detectedMobile)

pcall(function()
    if isfile and isfile("BlackCrown-X/lang.txt") then
        local l = readfile("BlackCrown-X/lang.txt")
        if l == "Thai" or l == "English" then BCX.Lang = l end
    end
end)

-- คำอธิบาย: เปิดเป็นค่าเริ่มต้น ปิดได้ที่ Settings
BCX.ShowDesc = true
pcall(function()
    if isfile and isfile("BlackCrown-X/showdesc.txt") then
        BCX.ShowDesc = (readfile("BlackCrown-X/showdesc.txt") == "1")
    end
end)

-- เก็บสีของ Colorpicker ทุกตัวไว้ในไฟล์เอง (เซฟทันทีที่เปลี่ยน)
BCX.colors = {}
pcall(function()
    if isfile and isfile("BlackCrown-X/colors.json") then
        local d = game:GetService("HttpService"):JSONDecode(readfile("BlackCrown-X/colors.json"))
        if type(d) == "table" then BCX.colors = d end
    end
end)
BCX.fmFake = false -- Free Mouse: false = ใช้เมาส์จริง (ไม่หน่วง), true = เมาส์ปลอม
BCX.autoFM = true  -- Free Mouse เปิด/ปิดตาม UI อัตโนมัติ (เปิดเมนู = เปิด, ปิดเมนู = ปิด)
BCX.colorSaveTick = 0
function BCX.saveColors()
    BCX.colorSaveTick = BCX.colorSaveTick + 1
    local tick = BCX.colorSaveTick
    task.delay(0.4, function() -- รอให้หยุดลากสีก่อนค่อยเขียนไฟล์
        if tick ~= BCX.colorSaveTick then return end
        pcall(function()
            if makefolder and isfolder and not isfolder("BlackCrown-X") then makefolder("BlackCrown-X") end
            if writefile then
                writefile("BlackCrown-X/colors.json", game:GetService("HttpService"):JSONEncode(BCX.colors))
            end
        end)
    end)
end

-- เซฟค่า -> ทำลายทุกอย่าง -> รันใหม่ (ใช้ตอนสลับ UI Layout Mode)
function BCX.reload()
    if genv.BCX_Reloading then return end
    genv.BCX_Reloading = true
    task.spawn(function()
        pcall(function() BCX.cfg:Save() end)
        J.destroy()
        task.wait(0.3)
        genv.BCX_Reloading = false
        launch()
    end)
end

-- ============================================================
-- ANTI FLING COLLISION SETUP
-- ============================================================
local function setupCharacterCollision(a)
    local function disableCollide(b)
        if BCX.afOn and b:IsA('BasePart') then b.CanCollide = false end
    end
    for b, c in ipairs(a:GetChildren()) do disableCollide(c) end
    local b, c = a.ChildAdded:Connect(disableCollide), RunService.Stepped:Connect(function()
        if BCX.afOn and a:IsDescendantOf(workspace) then
            for b, c in ipairs(a:GetChildren()) do
                if c:IsA('BasePart') and c.CanCollide then c.CanCollide = false end
            end
        end
    end)
    J.track(b); J.track(c)
    a.Destroying:Connect(function() b:Disconnect(); c:Disconnect() end)
end

local function trackPlayer(a)
    if a == p then return end
    J.track(a.CharacterAdded:Connect(setupCharacterCollision))
    if a.Character then setupCharacterCollision(a.Character) end
end

for a, b in ipairs(players:GetPlayers()) do trackPlayer(b) end
J.track(players.PlayerAdded:Connect(trackPlayer))

-- ==================== EMOTE MIRROR SYSTEM ====================
local emoteTargetPlayerName = ""
local isCopyingPlayerEmote = false
local mirrorConnection = nil
local customEmoteIdInput = ""
local customTrack = nil
local isPlayingCustomEmote = false

BCX.emoteTracks = {}
BCX.emoteAnimator = nil

function BCX.getAnimator(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    return hum:FindFirstChildOfClass("Animator") or hum
end

function BCX.clearCopiedTracks()
    for _, tr in pairs(BCX.emoteTracks) do
        pcall(function() tr:Stop(0.1); tr:Destroy() end)
    end
    BCX.emoteTracks = {}
    BCX.emoteAnimator = nil
end

local function stopMirroring()
    if mirrorConnection then mirrorConnection:Disconnect(); mirrorConnection = nil end
    BCX.clearCopiedTracks()
end

-- ก๊อปท่าทาง: เล่นแอนิเมชันเดียวกับที่เป้าหมายกำลังเล่นอยู่ แล้วซิงก์เวลาให้ตรงกัน
local function startMirroringTarget(targetPlayerName)
    stopMirroring()
    mirrorConnection = rs.Heartbeat:Connect(function()
        if not isCopyingPlayerEmote then stopMirroring(); return end
        local tp = players:FindFirstChild(targetPlayerName)
        local tAnim = tp and BCX.getAnimator(tp.Character)
        local myAnim = BCX.getAnimator(localPlayer.Character)
        if not tAnim or not myAnim then return end
        if BCX.emoteAnimator ~= myAnim then
            BCX.clearCopiedTracks() -- เกิดใหม่ / ตัวละครเปลี่ยน
            BCX.emoteAnimator = myAnim
        end
        local okP, playing = pcall(function() return tAnim:GetPlayingAnimationTracks() end)
        if not okP or type(playing) ~= "table" then return end
        local seen = {}
        for _, t in ipairs(playing) do
            local id = t.Animation and t.Animation.AnimationId
            if id and id ~= "" then
                seen[id] = true
                local mine = BCX.emoteTracks[id]
                if not mine then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = id
                    local okL, tr = pcall(function() return myAnim:LoadAnimation(anim) end)
                    if okL and tr then
                        tr.Priority = Enum.AnimationPriority.Action4
                        tr.Looped = t.Looped
                        tr:Play(0.1, 1, t.Speed ~= 0 and t.Speed or 1)
                        pcall(function() tr.TimePosition = t.TimePosition end)
                        BCX.emoteTracks[id] = tr
                    end
                else
                    if not mine.IsPlaying then mine:Play(0.1, 1, t.Speed ~= 0 and t.Speed or 1) end
                    if math.abs(mine.TimePosition - t.TimePosition) > 0.3 then
                        pcall(function() mine.TimePosition = t.TimePosition end)
                    end
                end
            end
        end
        for id, tr in pairs(BCX.emoteTracks) do
            if not seen[id] then
                pcall(function() tr:Stop(0.15); tr:Destroy() end)
                BCX.emoteTracks[id] = nil
            end
        end
    end)
end

local function playEmoteById(animId)
    local animator = BCX.getAnimator(localPlayer.Character)
    if not animator then return nil end
    local cleanId = tostring(animId):gsub("%D", "")
    if cleanId == "" then return nil end
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. cleanId
    local success, track = pcall(function() return animator:LoadAnimation(anim) end)
    if success and track then
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play()
        return track
    end
    return nil
end

local function stopCustomEmotes()
    if customTrack then pcall(function() customTrack:Stop(); customTrack:Destroy() end); customTrack = nil end
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
local function getHRP()
    local char = localPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function BCX.setAF(state)
    BCX.afOn = state and true or false
    if BCX.afOn then
        if not BCX.afConn then
            BCX.afConn = RunService.Heartbeat:Connect(function()
                if not BCX.afOn or BCX.flinging then return end
                local char = localPlayer.Character
                local hrp = getHRP()
                if not hrp then return end
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.PlatformStand then return end -- กำลังบิน ไม่ตัดความเร็ว
                if hrp.AssemblyLinearVelocity.Magnitude > BCX.maxVel or hrp.AssemblyAngularVelocity.Magnitude > 60 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        end
    else
        if BCX.afConn then BCX.afConn:Disconnect(); BCX.afConn = nil end
    end
end

-- ==================== FLING (SkidFling) ====================
-- วิธีทำงาน: วาร์ปตัวเองไปทับเป้าหมายแล้วหมุน/สลับตำแหน่งขึ้น-ลงด้วยความเร็วสูงมากทุกเฟรม
-- (ติด BodyVelocity กันตกเอง + ตั้ง FallenPartsDestroyHeight = NaN กันตายตอนตกแมพ)
-- จบแต่ละเป้าหมาย = วาร์ปกลับจุดเดิม, จบทั้งหมด/กดปิด = flingStop() คืนค่าทุกอย่าง
BCX.flingMode = "Selected Player"
BCX.flingSession = 0

function BCX.flingCleanup()
    pcall(function() workspace.FallenPartsDestroyHeight = BCX.FPDH end)
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = getHRP()
    if hrp then
        local bv = hrp:FindFirstChild("BCX_FlingBV")
        if bv then bv:Destroy() end
    end
    if hum then
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)
        local cam = workspace.CurrentCamera
        if cam then pcall(function() cam.CameraSubject = hum end) end
    end
end

function BCX.flingStop()
    local wasOn = BCX.flinging
    BCX.flinging = false
    BCX.flingAllOn = false
    BCX.flingSession = BCX.flingSession + 1
    if BCX.flingConn then BCX.flingConn:Disconnect(); BCX.flingConn = nil end
    BCX.flingCleanup()
    local hrp = getHRP()
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if BCX.flingOrigCF then hrp.CFrame = BCX.flingOrigCF end
    end
    BCX.flingOrigCF = nil
end

-- Fling ผู้เล่น 1 คน (บล็อกจนจบ) คืน true ถ้าได้ลงมือ
function BCX.skidFling(target, sid)
    local function active() return BCX.flinging and sid == BCX.flingSession end
    local char = localPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = hum and hum.RootPart
    local tChar = target and target.Character
    if not (char and hum and root and tChar) then return false end

    local tHum = tChar:FindFirstChildOfClass("Humanoid")
    local tRoot = tHum and tHum.RootPart
    local tHead = tChar:FindFirstChild("Head")
    local acc = tChar:FindFirstChildOfClass("Accessory")
    local handle = acc and acc:FindFirstChild("Handle")
    if tHum and tHum.Sit then return false end -- เป้าหมายนั่งอยู่ ข้าม
    if not tChar:FindFirstChildWhichIsA("BasePart") then return false end

    local home = BCX.flingOrigCF
    local cam = workspace.CurrentCamera
    if cam then
        if tHead then cam.CameraSubject = tHead
        elseif handle then cam.CameraSubject = handle
        elseif tHum and tRoot then cam.CameraSubject = tHum end
    end

    local function fPos(base, pos, ang)
        if not root.Parent or not base.Parent then return end
        root.CFrame = CFrame.new(base.Position) * pos * ang
        root.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
        root.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local function hitPart(base)
        local timeout, t0, angle = 2, os.clock(), 0
        repeat
            if root.Parent and base.Parent and tHum then
                if base.AssemblyLinearVelocity.Magnitude < 50 then
                    angle = angle + 100
                    local mv = tHum.MoveDirection * base.AssemblyLinearVelocity.Magnitude / 1.25
                    fPos(base, CFrame.new(0, 1.5, 0) + mv, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                    fPos(base, CFrame.new(0, -1.5, 0) + mv, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                    fPos(base, CFrame.new(0, 1.5, 0) + tHum.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                    fPos(base, CFrame.new(0, -1.5, 0) + tHum.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                else
                    fPos(base, CFrame.new(0, 1.5, tHum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    fPos(base, CFrame.new(0, -1.5, -tHum.WalkSpeed), CFrame.Angles(0, 0, 0)); task.wait()
                    fPos(base, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    fPos(base, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
                end
            else
                task.wait()
            end
        until os.clock() - t0 > timeout or not active() or not base.Parent
    end

    workspace.FallenPartsDestroyHeight = 0 / 0
    local bv = Instance.new("BodyVelocity")
    bv.Name = "BCX_FlingBV"
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = root
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)

    if tRoot then hitPart(tRoot)
    elseif tHead then hitPart(tHead)
    elseif handle then hitPart(handle) end

    pcall(function() bv:Destroy() end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)
    if cam then pcall(function() cam.CameraSubject = hum end) end

    if not active() then return true end -- ถูกสั่งหยุด: flingStop จัดการคืนค่าเอง

    -- วาร์ปกลับที่เดิม (กันตกแมพ/ติดค้าง: ลองไม่เกิน 2 วิ)
    if home then
        local t0 = os.clock()
        repeat
            if not root.Parent then break end
            root.CFrame = home * CFrame.new(0, 0.5, 0)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.AssemblyLinearVelocity = Vector3.zero
                    v.AssemblyAngularVelocity = Vector3.zero
                end
            end
            task.wait()
        until (root.Position - home.Position).Magnitude < 25 or os.clock() - t0 > 2 or not active()
    end
    pcall(function() workspace.FallenPartsDestroyHeight = BCX.FPDH end)
    return true
end

-- mode: "Selected" หรือ "All"
function BCX.flingRun(mode, onDone)
    BCX.flingStop()
    local hrp = getHRP()
    if not hrp then return false end
    local list = {}
    if mode == "All" then
        for _, plr in ipairs(players:GetPlayers()) do
            if plr ~= localPlayer then table.insert(list, plr) end
        end
    else
        local t = players:FindFirstChild(BCX.flingTarget or "")
        if t and t ~= localPlayer and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            list[1] = t
        end
    end
    if #list == 0 then return false end

    -- Fling ใช้ฟิสิกส์ของตัวละครเต็มๆ ปิดโหมดบินก่อนกันตีกัน
    if BCX.flyOff then
        pcall(BCX.flyOff, "Normal")
        pcall(BCX.flyOff, "Vehicle")
    end

    BCX.flingOrigCF = hrp.CFrame
    BCX.flinging = true
    BCX.flingAllOn = (mode == "All")
    local sid = BCX.flingSession
    task.spawn(function()
        for _, plr in ipairs(list) do
            if sid ~= BCX.flingSession then return end
            local ok, err = pcall(BCX.skidFling, plr, sid)
            if not ok then warn("[BCX] fling: " .. tostring(err)) end
        end
        if sid == BCX.flingSession then
            BCX.flingStop()
            if onDone then onDone() end
        end
    end)
    return true
end

-- ==================== NOCLIP ====================
local noclipEnabled = false
local noclipSteppedConn = nil

local function setNoclip(state)
    noclipEnabled = state and true or false
    if noclipEnabled then
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
    infiniteJumpEnabled = state and true or false
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

-- ==================== FLY SYSTEM (แยก 2 โหมด: Fly / Vehicle Fly) ====================
--  • "Normal"  → บินตัวละครเท่านั้น (HumanoidRootPart)
--  • "Vehicle" → ต้องนั่งที่นั่งอยู่ ยกยานทั้งคัน ไปตามทิศกล้อง (ถ้ายังไม่นั่งจะรอ)
--  • เกมที่ลบ BodyVelocity/ล็อกตัวละคร → สลับเป็นโหมด CFrame อัตโนมัติ
--  • เปิดโหมดหนึ่ง อีกโหมดจะถูกปิดเสมอ (BCX.flySwitch) และ UI/ปุ่มลัดซิงก์ตามสถานะจริง
local flySpeed = 50
local bodyGyro = nil
local bodyVelocity = nil
local flyConnection = nil
local flyControls = nil
local isFlying = false
local flyTarget = nil
local flyMode = "Normal"        -- "Normal" | "Vehicle"
local flyUseCFrame = false      -- สลับอัตโนมัติเมื่อ BodyVelocity ไม่ทำงาน
local flyForceCFrame = false    -- บังคับโหมด CFrame ด้วยมือ (Toggle ใน Movement)
local flyCollideBackup = {}
local flyMonitor = { t = 0, exp = 0, act = 0, last = nil }

local function flyDetach()
    if bodyGyro then pcall(function() bodyGyro:Destroy() end); bodyGyro = nil end
    if bodyVelocity then pcall(function() bodyVelocity:Destroy() end); bodyVelocity = nil end
    for part in pairs(flyCollideBackup) do
        if part and part.Parent then pcall(function() part.CanCollide = true end) end
    end
    flyCollideBackup = {}
    flyTarget = nil
end

local function flyAttach(part, isVehicle)
    flyDetach()
    flyTarget = part

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = part.CFrame
    bodyGyro.Parent = part

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = part

    -- ยานพาหนะ: ปิดการชนทั้งคัน จะได้ไม่ติดพื้น/กำแพงตอนบิน (คืนค่าตอนหยุดบิน)
    if isVehicle then
        local ok, parts = pcall(function() return part:GetConnectedParts(true) end)
        if ok and parts then
            for _, bp in ipairs(parts) do
                if bp:IsA("BasePart") and bp.CanCollide then
                    flyCollideBackup[bp] = true
                    pcall(function() bp.CanCollide = false end)
                end
            end
        end
    end
end

-- อ่านทิศทางที่ผู้เล่นกด: PlayerModule → คีย์ WASD → MoveDirection ของ Humanoid
local function getFlyInput(cam, humanoid)
    local f, r = 0, 0
    if flyControls then
        local ok, mv = pcall(function() return flyControls:GetMoveVector() end)
        if ok and mv then r = mv.X; f = -mv.Z end
    end
    if f == 0 and r == 0 then
        if UserInputService:GetFocusedTextBox() == nil then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then f = f + 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then f = f - 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then r = r + 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then r = r - 1 end
        end
    end
    if f == 0 and r == 0 and humanoid then
        local md = humanoid.MoveDirection
        if md.Magnitude > 0.05 then
            local look = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
            local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
            if look.Magnitude > 0.001 and right.Magnitude > 0.001 then
                f = md:Dot(look.Unit); r = md:Dot(right.Unit)
            end
        end
    end
    local up = 0
    if UserInputService:GetFocusedTextBox() == nil then
        if UserInputService:IsKeyDown(BCX.keyCode("Fly Up")) then up = up + 1 end
        if UserInputService:IsKeyDown(BCX.keyCode("Fly Down")) then up = up - 1 end
    end
    return f, r, up
end

local function stopFly()
    if not isFlying then return end
    isFlying = false
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    local target = flyTarget
    flyDetach()
    pcall(function()
        if target and target.Parent then
            target.AssemblyLinearVelocity = Vector3.zero
            target.AssemblyAngularVelocity = Vector3.zero
        end
    end)
    local character = p.Character
    local humanoid = character and character:FindFirstChildOfClass('Humanoid')
    if humanoid then humanoid.PlatformStand = false end
end

local function startFly(mode)
    if isFlying then return end
    local character = p.Character
    local hrp = character and character:FindFirstChild('HumanoidRootPart')
    local humanoid = character and character:FindFirstChildOfClass('Humanoid')
    if not hrp or not humanoid then return end

    flyMode = mode or "Normal"
    isFlying = true
    flyUseCFrame = false
    flyMonitor = { t = 0, exp = 0, act = 0, last = nil }

    -- โหลด controls เบื้องหลัง ไม่บล็อกการเริ่มบิน (ถ้ายังไม่พร้อมจะใช้ WASD / MoveDirection แทน)
    if not flyControls then
        task.spawn(function()
            local ok, result = pcall(function()
                return require(p.PlayerScripts:WaitForChild('PlayerModule', 5)):GetControls()
            end)
            if ok then flyControls = result end
        end)
    end

    -- ติดระบบบินทันทีในเฟรมเดียวกับที่กด
    if flyMode == "Normal" then
        humanoid.PlatformStand = true
        flyAttach(hrp, false)
    else
        local seat = humanoid.SeatPart
        if seat then flyAttach(seat.AssemblyRootPart or seat, true) end
    end

    flyConnection = RunService.RenderStepped:Connect(function(dt)
        local char = p.Character
        local humanoid = char and char:FindFirstChildOfClass('Humanoid')
        local hrp = char and char:FindFirstChild('HumanoidRootPart')
        if not humanoid or not hrp then return end

        local seat = humanoid.SeatPart
        local vRoot = seat and (seat.AssemblyRootPart or seat) or nil
        local isVehicleMode = (flyMode == "Vehicle")
        local target

        if isVehicleMode then
            -- โหมดยานพาหนะ: ต้องนั่งอยู่ ถ้าไม่ได้นั่งก็รอ (ไม่บินตัวละคร)
            if not vRoot then
                if flyTarget then flyDetach(); flyMonitor.last = nil end
                if humanoid.PlatformStand then humanoid.PlatformStand = false end
                return
            end
            target = vRoot
        else
            target = hrp
        end

        if target ~= flyTarget or not flyTarget or not flyTarget.Parent
            or not bodyGyro or not bodyGyro.Parent
            or not bodyVelocity or not bodyVelocity.Parent then
            flyAttach(target, isVehicleMode)
            flyMonitor.last = nil
        end

        -- โหมดปกติต้อง PlatformStand, โหมดยานห้ามเปิด (ไม่งั้นตัวละครหลุดจากที่นั่ง)
        local wantStand = not isVehicleMode
        if humanoid.PlatformStand ~= wantStand then humanoid.PlatformStand = wantStand end

        local cam = workspace.CurrentCamera
        local f, r, up = getFlyInput(cam, humanoid)
        local dir = (cam.CFrame.LookVector * f) + (cam.CFrame.RightVector * r) + Vector3.new(0, up, 0)
        local vel = dir.Magnitude > 0.001 and dir.Unit * flySpeed or Vector3.zero

        bodyGyro.CFrame = cam.CFrame

        if flyUseCFrame or flyForceCFrame then
            -- โหมดสำรอง: ขยับด้วย CFrame ตรงๆ (ใช้ได้ในเกมที่บล็อก BodyVelocity)
            bodyVelocity.Velocity = Vector3.zero
            pcall(function()
                target.AssemblyLinearVelocity = Vector3.zero
                target.AssemblyAngularVelocity = Vector3.zero
            end)
            local rot = cam.CFrame - cam.CFrame.Position
            target.CFrame = CFrame.new(target.Position + vel * dt) * rot
        else
            bodyVelocity.Velocity = vel
            -- ตรวจว่าขยับจริงไหม ถ้าสั่งไปแต่แทบไม่ขยับ → สลับเป็นโหมด CFrame
            local pos = target.Position
            if flyMonitor.last and vel.Magnitude > 0 then
                flyMonitor.exp = flyMonitor.exp + vel.Magnitude * dt
                flyMonitor.act = flyMonitor.act + (pos - flyMonitor.last).Magnitude
            end
            flyMonitor.last = pos
            flyMonitor.t = flyMonitor.t + dt
            if flyMonitor.t >= 0.6 then
                if flyMonitor.exp > 5 and flyMonitor.act < flyMonitor.exp * 0.3 then
                    flyUseCFrame = true
                end
                flyMonitor.t, flyMonitor.exp, flyMonitor.act = 0, 0, 0
            end
        end
    end)
end

-- ซิงก์ UI + Quick Button ของทั้ง 2 โหมดบินให้ตรงกับสถานะจริง
function BCX.flyRefreshQB()
    if BCX.sync then
        BCX.sync("Fly")
        BCX.sync("Vehicle Fly")
    end
end

-- เปิดโหมดที่ต้องการ: ถ้าอีกโหมดกำลังบินอยู่ ปิดมันก่อนเสมอ (แล้วซิงก์ให้ดับตาม)
function BCX.flySwitch(mode)
    if isFlying and flyMode == mode then return end
    if isFlying then stopFly() end
    startFly(mode)
    BCX.flyRefreshQB()
end

-- ปิดเฉพาะเมื่อโหมดที่สั่งปิดคือโหมดที่กำลังบินอยู่
function BCX.flyOff(mode)
    if isFlying and flyMode == mode then stopFly() end
    BCX.flyRefreshQB()
end

-- ==================== UI LOAD ====================
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then warn("Failed to load WindUI Library"); return end
pcall(function()
    WindUI:AddTheme({
        Name = 'BlackCrown', Accent = Color3.fromHex('#1a1a1a'), Background = Color3.fromHex('#0a0a0a'),
        Outline = Color3.fromHex('#333333'), Text = Color3.fromHex('#ffffff'), Placeholder = Color3.fromHex('#666666'),
        Button = Color3.fromHex('#22CE00'), Icon = Color3.fromHex('#aaaaaa'),
    })
end)

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

-- config เดียวสำหรับทั้งสคริปต์
BCX.cfg = Window.ConfigManager:CreateConfig("settings")

-- ถ้า UI ถูกทำลาย (ปุ่ม X / Destroy) -> ทำลายทุกอย่างของสคริปต์ทิ้งทั้งหมด
-- (J.destroy ปิดทุกฟังก์ชัน ลบ ESP/Drawing/ปุ่มลัด/ครอสแฮร์/เมาส์ปลอม/connection ทั้งหมด)
do
    local function onUIDestroyed()
        if J.dead then return end -- กำลังทำลายอยู่แล้ว (เช่น reload หรือรันซ้ำ)
        task.spawn(J.destroy)
    end
    pcall(function() Window:OnDestroy(onUIDestroyed) end)
    pcall(function()
        local g = Window.UIElements.Main:FindFirstAncestorOfClass("ScreenGui")
        if g then
            J.track(g.AncestryChanged:Connect(function(_, parent)
                if not parent then onUIDestroyed() end
            end))
        end
    end)
end

-- ==================== LANGUAGE SYSTEM (English / ไทย) ====================
BCX.I18N = {}
local function E(key, th, d, dt, ph, pt)
    BCX.I18N[key] = { t = th, d = d, dt = dt, p = ph, pt = pt }
end

-- Tabs
E("Main", "เมนูหลัก")
E("Aimbot", "ล็อคเป้า")
E("ESP", "มองทะลุ")
E("Teleport", "เทเลพอร์ต")
E("Local Player", "ตัวละคร")
E("Misc", "อื่นๆ")
E("Settings", "ตั้งค่า")

-- Sections
E("Aimbot Core", "เล็งอัตโนมัติ")
E("FOV Circle", "วงกลม FOV")
E("Visual Toggles", "ตัวเลือกการแสดงผล")
E("Object Search ESP", "ค้นหาวัตถุ (ESP)")
E("Player Teleport & Tween", "วาร์ปไปหาผู้เล่น")
E("Tween Tracking", "ติดตามผู้เล่น")
E("Saved Waypoints", "จุดที่บันทึกไว้")
E("Movement", "การเคลื่อนที่")
E("Speed Lock", "ล็อกความเร็ว")
E("Auto-Save", "บันทึกอัตโนมัติ")
E("Emote & Animation", "ท่าทางและแอนิเมชัน")
E("Speed Controls", "ควบคุมความเร็ว")
E("Tools", "เครื่องมือ")
E("Safety", "ความปลอดภัย")
E("Fling", "ดีดผู้เล่น")
E("Language", "ภาษา")
E("Quick Buttons (Draggable)", "ปุ่มลัดบนจอ (ลากได้)")
E("Keybinds", "ปุ่มคีย์ลัด")
E("Free Mouse", "เมาส์อิสระ",
  "Key that turns the free mouse on/off.", "ปุ่มเปิด/ปิดเมาส์อิสระ")
E("Free Mouse Cursor", "เมาส์ตอนใช้เมาส์อิสระ",
  "Real = your normal system mouse (no lag, recommended). Fake = a drawn cursor, use only if you can't see the real one in a game.",
  "Real = เมาส์จริงของระบบ (ไม่หน่วง แนะนำ) / Fake = เมาส์ปลอมที่วาดเอง ใช้เมื่อบางเกมมองไม่เห็นเมาส์จริง")
E("Auto Free Mouse", "เมาส์อิสระอัตโนมัติ",
  "Free mouse turns ON when the menu opens and OFF when it closes.",
  "เปิดเมนูแล้วเมาส์อิสระเปิดเอง ปิดเมนูแล้วเมาส์อิสระปิดเอง")
E("Click TP Key", "ปุ่มวาร์ปคลิก",
  "Hold this key, then click anywhere to teleport to that spot. Release the key to stop.",
  "กดปุ่มนี้ค้างไว้ แล้วคลิกตรงจุดไหนก็วาร์ปไปจุดนั้น ปล่อยปุ่มก็หยุด")
E("Toggle UI", "ปุ่มเปิด/ปิดเมนู",
  "Key that shows or hides this menu.", "ปุ่มแสดง/ซ่อนเมนูนี้")
E("Fly Up", "บินขึ้น",
  "Key to fly up.", "ปุ่มบินขึ้น")
E("Fly Down", "บินลง",
  "Key to fly down.", "ปุ่มบินลง")
E("Click TP Mode", "โหมดวาร์ปคลิก",
  "While ON, tap/click anywhere on the screen to teleport there. No tool needed.",
  "ตอนเปิด แตะ/คลิกตรงไหนของจอก็วาร์ปไปตรงนั้น ไม่ต้องใช้ไอเทม")

-- Language
E("Language", "ภาษา",
  "Choose the menu language.", "เลือกภาษาของเมนู")
E("Show Descriptions", "แสดงคำอธิบาย",
  "Show a short description under each option.", "แสดงคำอธิบายสั้นๆ ใต้แต่ละตัวเลือก")
E("UI Layout Mode", "รูปแบบ UI",
  "Auto = detect device. PC = one-line headings. Mobile = boxed sections. The UI is rebuilt instantly when you change it.",
  "Auto = ตรวจอุปกรณ์เอง, PC = หัวข้อบรรทัดเดียว, Mobile = กล่องแยกหมวด (เลือกแล้ว UI จะถูกสร้างใหม่ทันที)")

-- Aimbot
E("Enable Aimbot", "เปิดล็อคเป้า",
  "Auto-aims at the nearest player while you hold right-click.",
  "ล็อคไปที่ผู้เล่นที่ใกล้ที่สุดอัตโนมัติ ขณะกดคลิกขวาค้างไว้")
E("Wallcheck", "เช็คกำแพง",
  "Won't lock onto players hiding behind walls.",
  "ไม่ล็อกเป้าผู้เล่นที่อยู่หลังกำแพง")
E("Target Part", "ส่วนที่เล็ง",
  "Which body part to aim at: Head or HumanoidRootPart (body).",
  "เลือกส่วนที่จะเล็ง: Head = หัว, HumanoidRootPart = ลำตัว")
E("Smoothness", "ความนุ่มของการเล็ง",
  "1 = snaps instantly. Bigger number = slower, smoother aim.",
  "1 = ล็อกทันที ยิ่งเลขมากยิ่งนุ่มและช้าลง",
  "1 = instant, 5 = smooth...", "1 = ล็อกทันที, 5 = นุ่ม...")
E("Crosshair", "เป้ากลางจอ",
  "Draws a crosshair at the center of the screen.", "วาดเครื่องหมายเล็งกลางหน้าจอ")
E("Crosshair Size", "ขนาดเป้าเล็ง",
  "Size of the crosshair.", "ขนาดของเป้าเล็ง")
E("Crosshair Color", "สีเป้าเล็ง",
  "Color of the crosshair.", "สีของเป้าเล็ง")
E("Crosshair Style", "สไตล์เป้าเล็ง",
  "Pick the crosshair shape: plus, dot, circle, square, X and more.",
  "เลือกรูปแบบเป้าเล็ง: กากบาท, จุด, วงกลม, สี่เหลี่ยม, X และอื่นๆ")
E("Crosshair Thickness", "ความหนาเป้าเล็ง",
  "Thickness of the crosshair lines.", "ความหนาของเส้นเป้าเล็ง")
E("Crosshair Outline", "ขอบดำเป้าเล็ง",
  "Adds a black outline so the crosshair is visible on any background.",
  "เพิ่มขอบดำ ให้เห็นเป้าชัดทุกพื้นหลัง")
E("Enable FOV", "เปิดวงกลม FOV",
  "Shows a circle on screen. Aimbot only targets players inside it.",
  "แสดงวงกลมบนจอ และเล็งเฉพาะผู้เล่นที่อยู่ในวงกลม")
E("FOV Radius", "ขนาดวง FOV",
  "Size of the FOV circle in pixels.",
  "ขนาดของวง FOV (พิกเซล)",
  "e.g. 100, 150...", "เช่น 100, 150...")
E("FOV Color", "สีวง FOV",
  "Color of the FOV circle.", "สีของวงกลม FOV")

-- ESP
E("Name & Distance", "ชื่อและระยะทาง",
  "Shows each player's name and how far away they are.",
  "แสดงชื่อผู้เล่นและระยะห่างจากคุณ")
E("Box ESP", "กรอบตัวผู้เล่น",
  "Draws a box around players so you can see them through walls.",
  "วาดกรอบรอบตัวผู้เล่น มองเห็นทะลุกำแพง")
E("Health Bar", "แถบเลือด",
  "Shows a health bar beside each player.",
  "แสดงแถบเลือดข้างผู้เล่น")
E("Health % Text", "เลือดเป็น %",
  "Shows the player's health as a percentage.",
  "แสดงเลือดของผู้เล่นเป็นเปอร์เซ็นต์")
E("Tracer Line", "เส้นนำทาง",
  "Draws a line from the screen to each player.",
  "ลากเส้นจากหน้าจอไปหาผู้เล่นแต่ละคน")
E("Highlight", "ไฮไลต์ตัวผู้เล่น",
  "Makes players glow so they stand out.",
  "ทำให้ตัวผู้เล่นเรืองแสง")
E("Mic Indicator", "ไอคอนไมค์",
  "Shows a mic icon by players; it turns green when they talk. (dont use it not fix)",
  "แสดงไอคอนไมค์ข้างผู้เล่น เป็นสีเขียวตอนกำลังพูด (อย่าใช้ไม่ได้แก้)")
E("Enemy / Default Color", "สีศัตรู / สีปกติ",
  "Color used for normal players.", "สีที่ใช้กับผู้เล่นทั่วไป")
E("Friend Color", "สีเพื่อน",
  "Color used for your friends.", "สีที่ใช้กับเพื่อนของคุณ")

-- Object search
E("Search Name", "ชื่อที่ค้นหา",
  "Type an object name (door, chest...) to highlight it in the world.",
  "พิมพ์ชื่อวัตถุ (ประตู, หีบ...) เพื่อไฮไลต์ในแมพ",
  "e.g. Door, Chest, Coin...", "เช่น Door, Chest, Coin...")
E("Exact Match", "ตรงทั้งชื่อ",
  "Only finds objects whose name is exactly what you typed.",
  "หาเฉพาะวัตถุที่ชื่อตรงกับที่พิมพ์ทุกตัวอักษร")
E("Partial Match", "ตรงบางส่วน",
  "Finds any object whose name contains what you typed.",
  "หาวัตถุที่ชื่อมีคำที่พิมพ์อยู่ข้างใน")
E("Search ESP Color", "สีของวัตถุที่ค้นหา",
  "Highlight color for found objects.", "สีไฮไลต์ของวัตถุที่หาเจอ")

-- Teleport
E("Select Target Player", "เลือกผู้เล่นเป้าหมาย",
  "Pick the player you want to teleport to.",
  "เลือกผู้เล่นที่ต้องการวาร์ปไปหา")
E("Refresh Player List", "รีเฟรชรายชื่อผู้เล่น",
  "Updates the list after players join or leave.",
  "อัปเดตรายชื่อเมื่อมีคนเข้า/ออกเกม")
E("Teleport to Player", "วาร์ปไปหาผู้เล่น",
  "Instantly teleports you next to the selected player.",
  "วาร์ปไปอยู่ข้างผู้เล่นที่เลือกทันที")
E("Select Player to Track", "เลือกผู้เล่นที่จะตาม",
  "Pick the player you want to follow around.",
  "เลือกผู้เล่นที่ต้องการตามติด")
E("Refresh", "รีเฟรช",
  "Updates the player list.", "อัปเดตรายชื่อผู้เล่น")
E("Direction", "ทิศทาง",
  "Where to stay relative to the player (behind, front, above...).",
  "ตำแหน่งที่จะอยู่เทียบกับผู้เล่น (หลัง, หน้า, บน...)")
E("Distance", "ระยะห่าง",
  "How far from the player you stay.",
  "ระยะห่างจากผู้เล่นที่จะตามไป",
  "e.g. 3, 5, 10...", "เช่น 3, 5, 10...")
E("Auto Look", "หันหน้าหาอัตโนมัติ",
  "Your character always faces the tracked player.",
  "ตัวละครหันหน้าไปหาผู้เล่นที่ตามอยู่ตลอด")
E("Create Platform Under Feet", "สร้างพื้นใต้เท้า",
  "Makes a floor under you so you don't fall while following.",
  "สร้างพื้นรองใต้เท้า ไม่ให้ตกขณะตามผู้เล่น")
E("Enable Relative Tween", "เปิดตามติดผู้เล่น",
  "Turn ON to start following the selected player. Turn OFF to stop.",
  "เปิดเพื่อเริ่มตามผู้เล่นที่เลือก ปิดเพื่อหยุด")

-- Waypoints
E("Waypoint Name", "ชื่อจุด",
  "Type a name for the spot you want to save.",
  "พิมพ์ชื่อให้จุดที่จะบันทึก",
  "Type a name...", "พิมพ์ชื่อจุด...")
E("Select Waypoint", "เลือกจุด",
  "Pick a saved spot to teleport to or delete.",
  "เลือกจุดที่บันทึกไว้ เพื่อวาร์ปหรือลบ")
E("Save Current Position", "บันทึกตำแหน่งตอนนี้",
  "Saves where you are standing under the name above.",
  "บันทึกตำแหน่งที่ยืนอยู่ตอนนี้ ตามชื่อด้านบน")
E("Teleport to Selected", "วาร์ปไปจุดที่เลือก",
  "Teleports you to the selected saved spot.",
  "วาร์ปไปยังจุดที่เลือกไว้")
E("Delete Selected", "ลบจุดที่เลือก",
  "Deletes the selected saved spot.",
  "ลบจุดที่เลือกทิ้ง")
E("🔄 Refresh List", "🔄 รีเฟรชรายการ",
  "Reloads the list of saved spots.",
  "โหลดรายการจุดที่บันทึกใหม่")

-- Drag
E("Drag Player", "ลากผู้เล่น",
  "Pulls the selected player along with you wherever you fly. Toggle OFF to release.",
  "ลากผู้เล่นที่เลือกให้ตามคุณไปทุกที่ ปิดเพื่อปล่อย")
E("Select Target", "เลือกเป้าหมาย",
  "Pick which player to use this feature on.",
  "เลือกผู้เล่นที่จะใช้ฟังก์ชันนี้")

-- Local player
E("Noclip", "ทะลุกำแพง (Noclip)",
  "Walk through walls and objects.",
  "เดินทะลุกำแพงและสิ่งของได้")
E("Infinite Jump", "กระโดดไม่จำกัด",
  "Jump again and again in mid-air.",
  "กระโดดซ้ำกลางอากาศได้เรื่อยๆ")
E("Fly", "บิน",
  "Fly freely with your character. Move with your normal controls and camera direction. Turning this on turns Vehicle Fly off.",
  "บินตัวละครอิสระ ควบคุมด้วยปุ่มเดินปกติและทิศทางกล้อง (เปิดอันนี้แล้ว Vehicle Fly จะปิดเอง)")
E("Vehicle Fly", "บินพร้อมยานพาหนะ",
  "Sit in a car/boat/object first, then fly and carry it along, moving with your camera direction. Friends sitting on it come along too. Turning this on turns normal Fly off.",
  "นั่งบนรถ/เรือ/วัตถุก่อน แล้วยกไปด้วย ขยับตามทิศกล้องเหมือนบินปกติ เพื่อนที่นั่งอยู่บนนั้นก็ไปด้วย (เปิดอันนี้แล้ว Fly ปกติจะปิดเอง)")
E("Fly CFrame Mode", "บินแบบ CFrame",
  "Use if Fly doesn't move in some games. Moves you directly instead of using physics. Also turns on automatically when needed. Applies to both Fly and Vehicle Fly.",
  "เปิดถ้าบินไม่ขยับในบางเกม ขยับตัวตรงๆ แทนฟิสิกส์ (และสลับให้เองอัตโนมัติเมื่อจำเป็น) ใช้ได้ทั้ง Fly และ Vehicle Fly")
E("Fly Speed", "ความเร็วบิน",
  "How fast you fly (both Fly and Vehicle Fly).", "ความเร็วในการบิน (ใช้ร่วมกันทั้งสองโหมด)")
E("Custom Speed", "ความเร็วที่กำหนดเอง",
  "Type the walk speed you want (normal is 16).",
  "พิมพ์ความเร็วเดินที่ต้องการ (ปกติ 16)",
  "e.g. 30, 50...", "เช่น 30, 50...")
E("Lock Speed", "ล็อกความเร็ว",
  "Keeps your speed at the value above so the game can't change it.",
  "ล็อกความเร็วไว้ที่ค่าด้านบน เกมจะเปลี่ยนไม่ได้")
E("Reset to Default", "คืนค่าเดิม",
  "Puts your walk speed back to normal.",
  "คืนความเร็วเดินกลับเป็นปกติ")
E("Auto-Save Interval (min)", "ช่วงเวลาบันทึก (นาที)",
  "How often settings are saved automatically.",
  "บันทึกการตั้งค่าอัตโนมัติทุกกี่นาที")
E("Enable Auto-Save", "เปิดบันทึกอัตโนมัติ",
  "Saves your settings automatically on a timer.",
  "บันทึกการตั้งค่าให้เองตามเวลาที่ตั้งไว้")
E("Save", "บันทึก",
  "Saves your current settings right now.",
  "บันทึกการตั้งค่าตอนนี้ทันที")
E("Load Saved Settings", "โหลดค่าที่บันทึก",
  "Loads the settings you saved before.",
  "โหลดการตั้งค่าที่เคยบันทึกไว้")

-- Misc: emotes
E("Copy Player Movement", "ก๊อปท่าทางผู้เล่น",
  "Your character copies the selected player's movements and emotes.",
  "ตัวละครทำท่าทางเลียนแบบผู้เล่นที่เลือก")
E("Custom Emote ID", "ไอดีท่าทางที่กำหนดเอง",
  "Paste an animation ID number here.",
  "ใส่หมายเลขไอดีของแอนิเมชันที่นี่",
  "e.g. 369675713...", "เช่น 369675713...")
E("Play Custom ID Emote", "เล่นท่าทางจากไอดี",
  "Plays the animation from the ID above. Toggle OFF to stop.",
  "เล่นแอนิเมชันจากไอดีด้านบน ปิดเพื่อหยุด")

-- Misc: tools
E("Get TP Tool", "รับไอเทมวาร์ป",
  "Gives you a tool: equip it and tap anywhere to teleport there.",
  "ได้ไอเทมหนึ่งชิ้น ถือแล้วแตะจุดไหนก็วาร์ปไปจุดนั้น")

-- Misc: fling
E("Select Fling Target", "เลือกเป้าหมาย Fling",
  "Pick the player you want to fling.",
  "เลือกผู้เล่นที่ต้องการดีดให้ลอย")
E("Fling Mode", "โหมด Fling",
  "Selected Player = fling the chosen player. All Players = fling everyone one by one.",
  "Selected Player = ดีดคนที่เลือก, All Players = ดีดทุกคนทีละคน")
E("Start Fling", "เริ่ม Fling",
  "Turn ON to start. Turn OFF to stop right away and return to your spot. (Your screen follows the target while flinging.)",
  "เปิดเพื่อเริ่ม ปิดเพื่อหยุดทันทีและกลับที่เดิม (ระหว่าง Fling กล้องจะตามเป้าหมาย)")

-- Misc: safety
E("Safe Mode (< 50% HP TP)", "โหมดปลอดภัย (เลือด < 50% วาร์ปหนี)",
  "When your health drops below 50%, you are teleported to a safe spot.",
  "เมื่อเลือดต่ำกว่า 50% จะวาร์ปไปที่ปลอดภัยทันที")
E("Anti-Fling", "กันโดน Fling",
  "Protects you from being flung: other players can't push you, and sudden huge speed is cancelled.",
  "กันไม่ให้ถูกดีด: ผู้เล่นอื่นดันคุณไม่ได้ และความเร็วที่พุ่งผิดปกติจะถูกตัดทิ้ง")

-- Settings: quick buttons
E("Function", "ฟังก์ชัน",
  "Choose which feature this button will control.",
  "เลือกว่าปุ่มนี้จะควบคุมฟังก์ชันอะไร")
E("Add Button", "เพิ่มปุ่ม",
  "Creates a floating button on screen. Drag it anywhere.",
  "สร้างปุ่มลอยบนจอ ลากไปวางที่ไหนก็ได้")
E("Remove Selected Button", "ลบปุ่มที่เลือก",
  "Removes the floating button of the selected function.",
  "ลบปุ่มลอยของฟังก์ชันที่เลือก")
E("Lock Button Positions", "ล็อกตำแหน่งปุ่ม",
  "Locks ALL floating buttons (including waypoint buttons) so they can't be dragged by accident. Taps still work. A 🔒 shows on each button.",
  "ล็อกปุ่มลอยทั้งหมด (รวมปุ่มวาร์ป) ไม่ให้ลากโดยไม่ตั้งใจ แตะใช้งานได้ตามปกติ และจะมีไอคอน 🔒 บนปุ่ม")
E("Remove All Buttons", "ลบปุ่มทั้งหมด",
  "Removes every floating button.",
  "ลบปุ่มลอยทั้งหมด")

E("Button Size", "ขนาดปุ่ม",
  "Resize all floating buttons (width and height together). 100 = default.",
  "ปรับขนาดปุ่มลอยทั้งหมด (กว้างและสูงพร้อมกัน) 100 = ค่าเริ่มต้น")


function BCX.title(key)
    local e = BCX.I18N[key]
    if BCX.Lang == "Thai" and e and e.t then return e.t end
    return key
end
function BCX.desc(key)
    if not BCX.ShowDesc then return nil end
    local e = BCX.I18N[key]
    if not e then return nil end
    if BCX.Lang == "Thai" then return e.dt or e.d end
    return e.d
end
function BCX.ph(key)
    local e = BCX.I18N[key]
    if not e then return nil end
    if BCX.Lang == "Thai" then return e.pt or e.p end
    return e.p
end

-- ---------- ข้อความแจ้งเตือน (notify) ----------
BCX.MSG = {
    {"Type a name first!", "พิมพ์ชื่อก่อน!"},
    {"Character not found!", "ไม่พบตัวละคร!"},
    {"Select a waypoint first!", "เลือกจุดก่อน!"},
    {"Select a player first!", "เลือกผู้เล่นก่อน!"},
    {"Player list refreshed", "รีเฟรชรายชื่อแล้ว"},
    {"Previous settings loaded ✅", "โหลดการตั้งค่าก่อนหน้าแล้ว ✅"},
    {"All buttons removed", "ลบปุ่มทั้งหมดแล้ว"},
    {"ON — free mouse", "เปิด — เมาส์อิสระ"},
    {"OFF — back to normal", "ปิด — คืนสภาพเดิม"},
    {"Saved ✅", "บันทึกแล้ว ✅"},
    {"Loaded ✅", "โหลดสำเร็จ ✅"},
    {"Saved!", "บันทึกแล้ว!"},
    {"Saved: ", "เซฟ: "},
    {"Deleted: ", "ลบ: "},
    {"Deleted", "ลบแล้ว"},
    {"Refreshed", "รีเฟรชแล้ว"},
    {"Dragging ", "กำลังลาก "},
    {"Released ", "ปล่อย "},
    {" already has a button", " มีปุ่มแล้ว"},
    {"Added", "เพิ่มแล้ว"},
    {"Added ", "เพิ่ม "},
    {"Removed ", "ลบ "},
    {"Button ", "ปุ่ม "},
    {" on screen", " บนหน้าจอ"},
    {"Flinging ", "กำลัง Fling "},
    {"Flinging everyone", "กำลัง Fling ทุกคน"},
    {"Fling stopped", "หยุด Fling แล้ว"},
    {"Fling finished", "Fling เสร็จแล้ว"},
    {"Language changed", "เปลี่ยนภาษาแล้ว"},
    {"Drag ON", "เปิดลากผู้เล่น"},
    {"Drag OFF", "ปิดลากผู้เล่น"},
    {"Auto-Save", "บันทึกอัตโนมัติ"},
    {"Free Mouse", "เมาส์อิสระ"},
    {"Error", "ผิดพลาด"},
    {"Saved", "บันทึกแล้ว"},
    {"Loaded", "โหลดแล้ว"},
    {"ON", "เปิด", true},
    {"OFF", "ปิด", true},
}

local function plainReplace(s, from, to)
    local out, i = {}, 1
    while true do
        local a, b = string.find(s, from, i, true)
        if not a then break end
        table.insert(out, string.sub(s, i, a - 1))
        table.insert(out, to)
        i = b + 1
    end
    table.insert(out, string.sub(s, i))
    return table.concat(out)
end

function BCX.msg(s)
    if type(s) ~= "string" then return s end
    local toThai = (BCX.Lang == "Thai")
    local list = {}
    for _, pr in ipairs(BCX.MSG) do
        if toThai then
            if not pr[3] then table.insert(list, { pr[1], pr[2] }) end
        else
            table.insert(list, { pr[2], pr[1] })
        end
    end
    table.sort(list, function(a, b) return #a[1] > #b[1] end)
    local marks, result = {}, s
    for idx, pr in ipairs(list) do
        local token = "\0" .. idx .. "\0"
        if string.find(result, pr[1], 1, true) then
            result = plainReplace(result, pr[1], token)
            marks[token] = pr[2]
        end
    end
    for token, val in pairs(marks) do result = plainReplace(result, token, val) end
    return result
end

function BCX.noWaypoint()
    return (BCX.Lang == "Thai") and "ไม่มีจุดเซฟ" or "No saved waypoints"
end

-- ---------- ห่อ Tab / Section / Element เพื่อแปลภาษา + เซฟอัตโนมัติ ----------
local ELEMENT_METHODS = { "Toggle", "Button", "Input", "Dropdown", "Slider", "Colorpicker", "Keybind", "Paragraph" }

BCX.flagUsed = {}
-- element ที่ไม่ควรเซฟ (เป้าหมายผู้เล่น / ฟังก์ชันที่ทำงานทันที)
BCX.NOSAVE = {
    ["Select Target Player"]=true, ["Select Player to Track"]=true, ["Select Target"]=true,
    ["Select Fling Target"]=true, ["Select Waypoint"]=true, ["Waypoint Name"]=true,
    ["Search Name"]=true, ["Function"]=true, ["Language"]=true, ["Show Descriptions"]=true,
    ["UI Layout Mode"]=true, ["Click TP Mode"]=true,
    ["Drag Player"]=true, ["Start Fling"]=true, ["Copy Player Movement"]=true,
    ["Play Custom ID Emote"]=true, ["Enable Relative Tween"]=true, ["Button Size"]=true,
}
local SAVABLE = { Toggle=true, Input=true, Dropdown=true, Slider=true, Colorpicker=true, Keybind=true }

function BCX.wrapSection(sec)
    for _, m in ipairs(ELEMENT_METHODS) do
        local orig = sec[m]
        if type(orig) == "function" then
            pcall(function()
                sec[m] = function(self, o)
                    o = o or {}
                    local key = o.Title
                    if key and BCX.I18N[key] then
                        o.Title = BCX.title(key)
                        local d = BCX.desc(key)
                        if d then o.Desc = d end
                        if m == "Input" then
                            local ph = BCX.ph(key)
                            if ph then o.Placeholder = ph end
                        end
                    end
                    if not BCX.ShowDesc then o.Desc = nil end

                    -- ทำให้ Toggle ใช้ Value เสมอ (บางโค้ดใช้ Default)
                    if m == "Toggle" and o.Value == nil and o.Default ~= nil then o.Value = o.Default end

                    -- ตั้ง Flag อัตโนมัติ เพื่อให้เซฟได้
                    local flag = o.Flag
                    if SAVABLE[m] and key and not BCX.NOSAVE[key] and not flag then
                        local base = (m .. "_" .. key):gsub("[^%w]", "_")
                        local n = (BCX.flagUsed[base] or 0) + 1
                        BCX.flagUsed[base] = n
                        flag = (n == 1) and base or (base .. n)
                        o.Flag = flag
                    end
                    if key and BCX.NOSAVE[key] then flag = nil; o.Flag = nil end

                    -- Colorpicker: ใช้ระบบเซฟสีของเราเอง (ไม่ผ่าน config ของ WindUI)
                    local colorKey, userCb
                    if m == "Colorpicker" and key then
                        colorKey = key
                        flag = nil; o.Flag = nil
                        userCb = o.Callback
                        local saved = BCX.colors[colorKey]
                        if type(saved) == "table" and #saved == 3 then
                            o.Default = Color3.fromRGB(saved[1], saved[2], saved[3])
                        end
                        o.Callback = function(col, ...)
                            if typeof(col) == "Color3" then
                                BCX.colors[colorKey] = {
                                    math.floor(col.R * 255 + 0.5),
                                    math.floor(col.G * 255 + 0.5),
                                    math.floor(col.B * 255 + 0.5),
                                }
                                BCX.saveColors()
                            end
                            if userCb then return userCb(col, ...) end
                        end
                    end

                    local el = orig(self, o)

                    -- ใช้สีที่เซฟไว้กับตัวแปรของสคริปต์ทันที (ไม่ต้องรอ UI เรียก callback)
                    if colorKey and userCb then
                        local saved = BCX.colors[colorKey]
                        if type(saved) == "table" and #saved == 3 then
                            pcall(userCb, Color3.fromRGB(saved[1], saved[2], saved[3]))
                        end
                    end

                    if flag and el then pcall(function() BCX.cfg:Register(flag, el) end) end
                    table.insert(BCX.Registry, { el = el, key = key, kind = m })
                    return el
                end
            end)
        end
    end
end

function BCX.head(t) return "── " .. tostring(t) .. " ──" end

function BCX.NewTab(opts)
    local key = opts.Title
    if BCX.I18N[key] then opts.Title = BCX.title(key) end
    local tab = Window:Tab(opts)
    table.insert(BCX.TabReg, { obj = tab, key = key })
    if BCX.isMobile then
        -- มือถือ: ใช้ Section แบบเดิม (กล่องแยกหมวด)
        pcall(function()
            local origSection = tab.Section
            tab.Section = function(self, so)
                so = so or {}
                local skey = so.Title
                if skey and BCX.I18N[skey] then so.Title = BCX.title(skey) end
                local sec = origSection(self, so)
                table.insert(BCX.TabReg, { obj = sec, key = skey })
                BCX.wrapSection(sec)
                return sec
            end
        end)
        return tab
    end
    -- คอม: ไม่มีกล่อง Section
    local origParagraph = tab.Paragraph
    BCX.wrapSection(tab)
    tab.Section = function(self, so)
        so = so or {}
        local skey = so.Title
        local shown = (skey and BCX.I18N[skey]) and BCX.title(skey) or skey
        local ok, el = pcall(origParagraph, tab, { Title = BCX.head(shown) })
        if ok and el then table.insert(BCX.Registry, { el = el, key = skey, kind = "Heading" }) end
        return tab
    end
    return tab
end

-- ถ้า SetTitle ของ WindUI ไม่เปลี่ยนข้อความบนจอ ให้แก้ข้อความบน GUI ตรงๆ
function BCX.guiRoots()
    local roots = {}
    pcall(function()
        local g = Window.UIElements.Main:FindFirstAncestorOfClass("ScreenGui")
        if g then table.insert(roots, g) end
    end)
    if #roots == 0 then
        pcall(function() local g = game:GetService("CoreGui"):FindFirstChild("WindUI"); if g then table.insert(roots, g) end end)
        pcall(function() local g = gethui and gethui():FindFirstChild("WindUI"); if g then table.insert(roots, g) end end)
        pcall(function() local g = localPlayer.PlayerGui:FindFirstChild("WindUI"); if g then table.insert(roots, g) end end)
    end
    return roots
end

function BCX.swapGuiText(map)
    for _, root in ipairs(BCX.guiRoots()) do
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local to = map[d.Text]
                if to and d.Text ~= to then pcall(function() d.Text = to end) end
            end
        end
    end
end

function BCX.apply()
    local thai = (BCX.Lang == "Thai")
    local map = {}
    for _, r in ipairs(BCX.TabReg) do
        local e = r.key and BCX.I18N[r.key]
        if e then
            pcall(function() r.obj:SetTitle(BCX.title(r.key)) end)
            if e.t then map[thai and r.key or e.t] = BCX.title(r.key) end
        end
    end
    for _, r in ipairs(BCX.Registry) do
        local e = r.key and BCX.I18N[r.key]
        if e and r.el then
            local el = r.el
            if r.kind == "Heading" then
                pcall(function() el:SetTitle(BCX.head(BCX.title(r.key))) end)
                if e.t then map[BCX.head(thai and r.key or e.t)] = BCX.head(BCX.title(r.key)) end
            else
                pcall(function() el:SetTitle(BCX.title(r.key)) end)
                local d = BCX.desc(r.key)
                if d then pcall(function() el:SetDesc(d) end)
                elseif not BCX.ShowDesc then pcall(function() el:SetDesc("") end) end
                if r.kind == "Input" then
                    local ph = BCX.ph(r.key)
                    if ph then pcall(function() el:SetPlaceholder(ph) end) end
                end
            end
        end
    end
    BCX.swapGuiText(map)
    if BCX.onLang then pcall(BCX.onLang) end
end

function BCX.setLang(lang)
    BCX.Lang = lang
    pcall(function()
        if makefolder and isfolder and not isfolder("BlackCrown-X") then makefolder("BlackCrown-X") end
        if writefile then writefile("BlackCrown-X/lang.txt", lang) end
    end)
    BCX.apply()
end

-- ==================== TABS ====================
local MainTab       = BCX.NewTab({ Title = "Main",         Icon = "bird",       Locked = false })
local AimbotTab     = BCX.NewTab({ Title = "Aimbot",       Icon = "crosshair",  Locked = false })
local ESPTab        = BCX.NewTab({ Title = "ESP",          Icon = "eye",        Locked = false })
local TPTab         = BCX.NewTab({ Title = "Teleport",     Icon = "map-pin",    Locked = false })
local LocalPlayerTab = BCX.NewTab({ Title = "Local Player", Icon = "user" })
local MiscTab       = BCX.NewTab({ Title = "Misc",         Icon = "ellipsis",   Locked = false })
local SettingsTab   = BCX.NewTab({ Title = "Settings",     Icon = "settings" })

-- ==================== QUICK BUTTONS SYSTEM (DRAGGABLE) ====================
local QuickButtons = {}
local QuickButtonGui = nil
local quickButtonsLocked = false

BCX.BTN_SCALE = 1
pcall(function()
    if isfile and isfile("BlackCrown-X/btnscale.txt") then
        local n = tonumber(readfile("BlackCrown-X/btnscale.txt"))
        if n then BCX.BTN_SCALE = math.clamp(n, 0.5, 2) end
    end
end)
BCX.QB_SIZE = math.floor(46 * BCX.BTN_SCALE + 0.5)

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
        if makefolder and isfolder and not isfolder("BlackCrown-X") then makefolder("BlackCrown-X") end
        if writefile then writefile("BlackCrown-X/quickbuttons.json", game:GetService("HttpService"):JSONEncode(data)) end
    end)
end

local function createQuickButton(funcName, posX, posY, size, initState, onToggle, opts)
    opts = opts or {}
    posX = posX or 100; posY = posY or 100; size = BCX.QB_SIZE; initState = initState or false
    -- กันปุ่มที่เซฟไว้หลุดขอบจอ (เช่น เปลี่ยนอุปกรณ์/ความละเอียด)
    local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800, 600)
    posX = math.clamp(posX, 0, math.max(0, vp.X - size))
    posY = math.clamp(posY, 0, math.max(0, vp.Y - size))

    if not QuickButtonGui then
        QuickButtonGui = Instance.new("ScreenGui")
        QuickButtonGui.Name = "BCX_QuickButtons"
        QuickButtonGui.ResetOnSpawn = false
        QuickButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        QuickButtonGui.DisplayOrder = 999
        pcall(function() QuickButtonGui.Parent = game:GetService("CoreGui") end)
        if not QuickButtonGui.Parent then QuickButtonGui.Parent = p.PlayerGui end
        J.obj(QuickButtonGui)
    end

    local btnState = initState
    local btnData  = { funcName = funcName, state = btnState, permanent = opts.permanent }

    local frame = Instance.new("Frame")
    frame.Name = "QB_" .. funcName
    frame.Size = UDim2.fromOffset(size, size)
    frame.Position = UDim2.fromOffset(posX, posY)
    frame.BackgroundColor3 = btnState and Color3.fromRGB(0,200,80) or Color3.fromRGB(35,35,45)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = QuickButtonGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 11)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = btnState and Color3.fromRGB(0,220,80) or Color3.fromRGB(80,80,100)
    stroke.Transparency = 0.5; stroke.Thickness = 1.5

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,-4, 0.72, 0)
    label.Position = UDim2.new(0, 2, 0.14, 0)
    label.BackgroundTransparency = 1
    label.Text = opts.label or funcName
    label.TextColor3 = Color3.fromRGB(230,230,240)
    label.TextScaled = true
    label.TextWrapped = true
    label.Font = Enum.Font.GothamBold
    -- ชื่อยาวๆ (เช่น Vehicle Fly) ย่อตัวอักษรลงเอง ไม่ล้นปุ่ม
    local qlim = Instance.new("UITextSizeConstraint", label)
    qlim.MinTextSize = 7; qlim.MaxTextSize = 28

    local dot = Instance.new("Frame", frame)
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.new(1,-9, 0, 3)
    dot.BackgroundColor3 = btnState and Color3.fromRGB(0,255,100) or Color3.fromRGB(100,100,120)
    dot.BorderSizePixel = 0
    dot.Visible = not opts.momentary
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    -- ทาสีปุ่มตามสถานะ (ให้ระบบอื่นสั่งเปลี่ยนได้ผ่าน btnData.set)
    local function paint()
        frame.BackgroundColor3 = btnState and Color3.fromRGB(0,200,80) or Color3.fromRGB(35,35,45)
        stroke.Color = btnState and Color3.fromRGB(0,220,80) or Color3.fromRGB(80,80,100)
        dot.BackgroundColor3 = btnState and Color3.fromRGB(0,255,100) or Color3.fromRGB(100,100,120)
    end
    btnData.set = function(v) btnState = v and true or false; btnData.state = btnState; paint() end

    local dragging, dragStart, startPos = false, nil, nil

    J.track(frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos  = frame.Position
            dragging  = false
        end
    end))

    J.track(frame.InputChanged:Connect(function(input)
        -- [v3.7.0] ล็อกอยู่ = ไม่มีทางลากได้ (แตะยังใช้งานได้ปกติ)
        if quickButtonsLocked then dragging = false; return end
        if (input.UserInputType == Enum.UserInputType.MouseMovement
        or  input.UserInputType == Enum.UserInputType.Touch) and startPos and dragStart then
            local delta = input.Position - dragStart
            if dragging or delta.Magnitude > 14 then -- ต้องลากเกิน 14px ถึงนับว่าลาก (กันนิ้วสั่น/เผลอแตะ)
                dragging = true
                frame.Position = UDim2.fromOffset(
                    startPos.X.Offset + delta.X,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end))

    J.track(frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false; startPos = nil
                saveQuickButtons()
            elseif opts.momentary then
                -- ปุ่มกดครั้งเดียว (เช่น Save): ไม่สลับสถานะ แค่กะพริบแล้วทำงาน
                local old = frame.BackgroundColor3
                frame.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                task.delay(0.25, function() if frame.Parent then frame.BackgroundColor3 = old end end)
                if onToggle then pcall(onToggle) end
            else
                -- แตะ = สลับจาก "สถานะจริง" ของฟังก์ชัน (ไม่ใช่สถานะที่ปุ่มจำไว้เอง)
                local f = BCX.F and BCX.F[funcName]
                local want
                if f then want = not f.get() else want = not btnState end
                if onToggle then pcall(onToggle, want) end
                -- ทาสีตามสถานะจริงหลังสั่งเสร็จ (ถ้าสั่งไม่สำเร็จ ปุ่มจะไม่เขียวหลอก)
                if f then btnData.set(f.get()) else btnData.set(want) end
                saveQuickButtons()
            end
            dragging = false; startPos = nil
        end
    end))

    btnData.Frame = frame
    btnData.Label = label
    table.insert(QuickButtons, btnData)
    if BCX.applyLockVisual then BCX.applyLockVisual() end
    return btnData
end

local function removeQuickButton(funcName)
    for i, btn in ipairs(QuickButtons) do
        if btn.funcName == funcName and not btn.permanent then
            pcall(function() btn.Frame:Destroy() end)
            table.remove(QuickButtons, i)
            saveQuickButtons(); return
        end
    end
end

local function removeAllQuickButtons()
    local keep = {}
    for _, btn in ipairs(QuickButtons) do
        if btn.permanent then table.insert(keep, btn) else pcall(function() btn.Frame:Destroy() end) end
    end
    QuickButtons = keep
    saveQuickButtons()
end

-- ซิงก์สีปุ่มกับสถานะจริง
function BCX.qbSync(name, state)
    for _, b in ipairs(QuickButtons) do
        if b.funcName == name and b.set and b.state ~= state then b.set(state) end
    end
end

-- [v3.7.0] ไอคอน 🔒 มุมซ้ายล่างของปุ่มลัด + ปุ่มวาร์ปทุกปุ่ม ตอนล็อกตำแหน่งอยู่
function BCX.applyLockVisual()
    local function mark(frame)
        if not (frame and frame.Parent) then return end
        local m = frame:FindFirstChild("LockMark")
        if quickButtonsLocked and not m then
            m = Instance.new("TextLabel")
            m.Name = "LockMark"
            m.BackgroundTransparency = 1
            m.Size = UDim2.fromOffset(12, 12)
            m.Position = UDim2.new(0, 2, 1, -13)
            m.Text = "🔒"
            m.TextSize = 10
            m.TextColor3 = Color3.new(1, 1, 1)
            m.Parent = frame
        elseif not quickButtonsLocked and m then
            m:Destroy()
        end
    end
    for _, b in ipairs(QuickButtons) do mark(b.Frame) end
    for _, b in pairs(BCX.WPB or {}) do mark(b.Frame) end
end

local function loadQuickButtons(callbackMap)
    pcall(function()
        if not isfile or not isfile("BlackCrown-X/quickbuttons.json") then return end
        local raw = readfile("BlackCrown-X/quickbuttons.json")
        if not raw or #raw < 3 then return end
        local ok, data = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), raw)
        if not ok or type(data) ~= "table" then return end
        local keep = {}
        for _, btn in ipairs(QuickButtons) do
            if btn.permanent then table.insert(keep, btn) else pcall(function() btn.Frame:Destroy() end) end
        end
        QuickButtons = keep
        for _, d in ipairs(data) do
            if d.func == "Save" then
                -- ปุ่ม Save ถาวร: คืนตำแหน่งที่เคยลากไว้
                for _, btn in ipairs(QuickButtons) do
                    if btn.permanent and btn.Frame then
                        local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800, 600)
                        btn.Frame.Position = UDim2.fromOffset(
                            math.clamp(d.x or 80, 0, math.max(0, vp.X - BCX.QB_SIZE)),
                            math.clamp(d.y or 200, 0, math.max(0, vp.Y - BCX.QB_SIZE)))
                    end
                end
            elseif d.func and callbackMap[d.func] then
                -- เริ่มจากสถานะจริงตอนนี้ แล้วค่อยสั่งตามที่เคยเซฟไว้
                local f = BCX.F[d.func]
                local real = f and f.get() or false
                createQuickButton(d.func, d.x or 100, d.y or 100, d.size or 65, real, callbackMap[d.func])
                if d.state and not real then pcall(callbackMap[d.func], true) end
            end
        end
    end)
end

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

pcall(function()
    local t = Drawing.new("Text")
    t.Text = "BCX Drawing TEST"; t.Size = 24; t.Color = Color3.new(1,1,0)
    t.Position = Vector2.new(200, 200); t.Outline = true; t.Visible = true
    task.delay(8, function() pcall(function() t:Remove() end) end)
end)

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
    local micCache, micNext = nil, 0 -- [v3.6.4] แคชผลค้นหา VoiceSource (ไม่ค้น recursive ทุกเฟรม)

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

    local idleHidden = false
        local function step()
        if not (espNameEnabled or espBoxEnabled or espTracerEnabled or espHighlightEnabled
            or espHealthBarEnabled or espHealthTextEnabled or espMicEnabled) then
            if not idleHidden then idleHidden = true; hideAll() end
            return
        end
        idleHidden = false
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
                        -- [v3.6.4] ค้นหา VoiceSource แค่วินาทีละครั้ง แล้วใช้ค่าที่แคชไว้
                        local nowT = os.clock()
                        if nowT >= micNext or (micCache and not micCache:IsDescendantOf(charModel)) then
                            micNext = nowT + 1
                            micCache = charModel:FindFirstChild("VoiceSource", true) or charModel:FindFirstChildWhichIsA("AudioEmitter", true)
                        end
                        local voiceInst = micCache
                        if voiceInst and voiceInst.Parent then
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
    end
    local conn = rs.RenderStepped:Connect(function()
        local ok, err = pcall(step)
        if not ok and not BCX.espErrShown then
            BCX.espErrShown = true
            pcall(function()
                WindUI:Notify({ Title = "ESP ERROR", Content = tostring(err), Duration = 20 })
            end)
        end
    end)
    
    espObjects[plr] = {
        highlight=highlight, boxOutline=boxOutline, boxInline=boxInline,
        healthBarOutline=healthBarOutline, healthBarBG=healthBarBG, healthBarFill=healthBarFill,
        healthText=healthText, nameText=nameText, micText=micText, tracer=tracer, connection=conn
    }
end

for _, plr in ipairs(players:GetPlayers()) do
    if plr ~= localPlayer then createESP(plr) end
end
J.track(players.PlayerAdded:Connect(function(plr)
    if plr ~= localPlayer then createESP(plr) end
end))
J.track(players.PlayerRemoving:Connect(function(plr)
    friendCache[plr.UserId] = nil
    removeESP(plr)
end))

-- ==================== OBJECT SEARCH ESP ====================
local searchTargetText = ""
local exactMatchEnabled = false
local partialMatchEnabled = false
local objectEspColor = Color3.fromRGB(255, 255, 0)
local searchedObjects = {}
local objSearchTick = 0 -- [v3.6.4] ตัวนับคำสั่งค้นหา (debounce + ยกเลิกสแกนเก่า)

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
    objSearchTick = objSearchTick + 1
    local myTick = objSearchTick
    clearObjectESP()
    if searchTargetText == "" or (not exactMatchEnabled and not partialMatchEnabled) then return end
    local targetLower = string.lower(searchTargetText)
    local i = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- [v3.6.4] แบ่งเฟรมทุก 1500 ตัว กัน workspace ใหญ่ๆ (หลายหมื่น instance) ค้างก้อนเดียว
        i = i + 1
        if i % 1500 == 0 then
            task.wait()
            if myTick ~= objSearchTick or J.dead then return end -- มีคำสั่งใหม่เข้ามา ยกเลิกรอบนี้
        end
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if localPlayer.Character and obj:IsDescendantOf(localPlayer.Character) then continue end
            local isMatch = false
            if exactMatchEnabled   then isMatch = obj.Name == searchTargetText
            elseif partialMatchEnabled then isMatch = string.find(string.lower(obj.Name), targetLower, 1, true) ~= nil end
            if isMatch then applyESPToObject(obj) end
        end
    end
end

-- [v3.6.4] หน่วงการค้นหา: รวมคำสั่งที่ยิงถี่ๆ (พิมพ์ชื่อ / สลับสวิตช์) เป็นรอบเดียวหลังหยุด 0.4 วิ
function BCX.queueObjectESP()
    objSearchTick = objSearchTick + 1
    local t = objSearchTick
    task.delay(0.4, function()
        if t == objSearchTick and not J.dead then task.spawn(updateObjectESP) end
    end)
end

J.track(rs.RenderStepped:Connect(function()
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
end))

-- ==================== NPC ESP (ทุกตัวที่มี Humanoid และไม่ใช่ผู้เล่น) ====================
-- [v3.7.0] ไม่ใช้ GetDescendants ทุกเฟรม:
--   • ตอนเปิด: สแกน workspace ครั้งเดียวแบบแบ่งเฟรม (หา Humanoid อย่างเดียว)
--   • หลังจากนั้น: ฟัง workspace.DescendantAdded เฉพาะที่เป็น Humanoid (รองรับ NPC เกิดใหม่ / StreamingEnabled)
--   • ตอนวาดเฟรมละครั้ง วนเฉพาะ NPC ที่เจอแล้ว (ไม่ค้นหาอะไรในแมพ)
-- หมายเหตุ: Roblox แสดง Highlight พร้อมกันได้จำกัด (~31 อัน) ถ้า NPC เยอะ ชื่อ+ระยะ (Drawing) ยังขึ้นครบทุกตัว
BCX.npc = { on = false, color = Color3.fromRGB(255, 140, 0), objs = {}, rConn = nil, aConn = nil, scanId = 0 }

function BCX.npcRemove(model)
    local d = BCX.npc.objs[model]
    if not d then return end
    if d.hl then pcall(function() d.hl:Destroy() end) end
    if d.text then pcall(function() d.text:Remove() end) end
    BCX.npc.objs[model] = nil
end

function BCX.npcAdd(hum)
    local N = BCX.npc
    if not N.on or not hum or not hum.Parent then return end
    local model = hum.Parent
    if not model:IsA("Model") or N.objs[model] then return end
    if players:GetPlayerFromCharacter(model) then return end          -- ผู้เล่น ไม่เอา
    if model == localPlayer.Character then return end
    local hl = Instance.new("Highlight")
    hl.Name = "BCX_NPC_Highlight"
    hl.FillColor = N.color
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = model
    local txt
    if hasDrawingAPI then
        pcall(function()
            txt = Drawing.new("Text")
            txt.Visible = false; txt.Color = N.color; txt.Size = 14; txt.Center = true; txt.Outline = true
        end)
    end
    N.objs[model] = { hum = hum, hl = hl, text = txt }
end

function BCX.npcStep()
    local N = BCX.npc
    local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    for model, d in pairs(N.objs) do
        if not model.Parent or d.hum.Parent ~= model or players:GetPlayerFromCharacter(model) then
            BCX.npcRemove(model)
        else
            local alive = d.hum.Health > 0
            if d.hl then
                if d.hl.Parent ~= model then d.hl.Parent = model end
                d.hl.Enabled = alive
            end
            if d.text then
                local shown = false
                if alive then
                    if not d.root or not d.root.Parent then
                        d.root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
                            or model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
                    end
                    if d.root then
                        local pos, on = camera:WorldToViewportPoint(d.root.Position + Vector3.new(0, 3, 0))
                        if on then
                            local dist = myHRP and math.floor((d.root.Position - myHRP.Position).Magnitude) or 0
                            d.text.Text = string.format("%s [%dm]", model.Name, dist)
                            d.text.Position = Vector2.new(pos.X, pos.Y - 14)
                            d.text.Visible = true
                            shown = true
                        end
                    end
                end
                if not shown then d.text.Visible = false end
            end
        end
    end
end

function BCX.npcSet(state)
    local N = BCX.npc
    N.on = state and true or false
    N.scanId = N.scanId + 1
    if N.on then
        if not N.aConn then
            N.aConn = workspace.DescendantAdded:Connect(function(d)
                if d:IsA("Humanoid") then task.defer(BCX.npcAdd, d) end -- defer: รอให้ Parent นิ่งก่อน
            end)
        end
        if not N.rConn then N.rConn = rs.RenderStepped:Connect(BCX.npcStep) end
        local sid = N.scanId
        task.spawn(function()
            local i = 0
            for _, d in ipairs(workspace:GetDescendants()) do
                i = i + 1
                if i % 2000 == 0 then
                    task.wait()
                    if sid ~= N.scanId or J.dead then return end
                end
                if d:IsA("Humanoid") then BCX.npcAdd(d) end
            end
        end)
    else
        if N.aConn then N.aConn:Disconnect(); N.aConn = nil end
        if N.rConn then N.rConn:Disconnect(); N.rConn = nil end
        local list = {}
        for model in pairs(N.objs) do table.insert(list, model) end
        for _, model in ipairs(list) do BCX.npcRemove(model) end
    end
end

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

J.track(rs.RenderStepped:Connect(function()
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
end))

-- ==================== CROSSHAIR (กลางจอ) ====================
BCX.xhair = { on = false, size = 12, thick = 2, gap = 4, color = Color3.new(1, 1, 1), style = "Plus", outline = true }
BCX.XHAIR_STYLES = { "Plus", "Plus (No Gap)", "T-Shape", "Dot", "Circle", "Circle + Dot", "Square", "Diamond", "X Cross" }

-- [v3.6.3] หน่วงการสร้างใหม่: callback จาก Slider / Colorpicker ยิงถี่มาก
-- รวมเป็นการสร้างใหม่ครั้งเดียวหลังหยุดขยับ ~0.08 วิ (แทนที่จะลบ-สร้าง Frame ทุกครั้งที่ลาก)
BCX.xhairTick = 0
function BCX.xhairUpdate()
    BCX.xhairTick = BCX.xhairTick + 1
    local t = BCX.xhairTick
    task.delay(0.08, function()
        if t == BCX.xhairTick and not J.dead then BCX.xhairBuild() end
    end)
end

function BCX.xhairBuild()
    local x = BCX.xhair
    if not (BCX.xhairGui and BCX.xhairGui.Parent) then
        local g = Instance.new("ScreenGui")
        g.Name = "BCX_Crosshair"; g.ResetOnSpawn = false; g.IgnoreGuiInset = true; g.DisplayOrder = 998
        pcall(function() g.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
        if not g.Parent then g.Parent = p:WaitForChild("PlayerGui") end
        J.obj(g)
        local h = Instance.new("Frame")
        h.BackgroundTransparency = 1
        h.AnchorPoint = Vector2.new(0.5, 0.5)
        h.Position = UDim2.fromScale(0.5, 0.5)
        h.Size = UDim2.fromOffset(0, 0)
        h.Parent = g
        BCX.xhairGui, BCX.xhairHolder = g, h
    end
    local holder = BCX.xhairHolder
    holder:ClearAllChildren()

    local s, t, gp = x.size, x.thick, x.gap

    local function mk(w, h, ox, oy, opt)
        opt = opt or {}
        local function frame()
            local f = Instance.new("Frame")
            f.BorderSizePixel = 0
            f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.Size = UDim2.fromOffset(w, h)
            f.Position = UDim2.fromOffset(ox, oy)
            f.Rotation = opt.rot or 0
            if opt.round then Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0) end
            f.Parent = holder
            return f
        end
        if opt.hollow then
            if x.outline then -- วงดำรอบนอก
                local o = frame(); o.BackgroundTransparency = 1
                local so = Instance.new("UIStroke"); so.Color = Color3.new(0, 0, 0); so.Thickness = t + 2; so.Parent = o
            end
            local f = frame(); f.BackgroundTransparency = 1
            local st = Instance.new("UIStroke"); st.Color = x.color; st.Thickness = t; st.Parent = f
        else
            local f = frame(); f.BackgroundColor3 = x.color
            if x.outline then
                local st = Instance.new("UIStroke"); st.Color = Color3.new(0, 0, 0); st.Thickness = 1; st.Parent = f
            end
        end
    end

    local style = x.style
    if style == "Plus" then
        mk(t, s, 0, -(gp + s / 2)); mk(t, s, 0, (gp + s / 2))
        mk(s, t, -(gp + s / 2), 0); mk(s, t, (gp + s / 2), 0)
    elseif style == "Plus (No Gap)" then
        mk(t, s * 2, 0, 0); mk(s * 2, t, 0, 0)
    elseif style == "T-Shape" then
        mk(t, s, 0, (gp + s / 2))
        mk(s, t, -(gp + s / 2), 0); mk(s, t, (gp + s / 2), 0)
    elseif style == "Dot" then
        local d = math.max(t * 2, 4); mk(d, d, 0, 0, { round = true })
    elseif style == "Circle" then
        local r = (s + gp) * 2; mk(r, r, 0, 0, { hollow = true, round = true })
    elseif style == "Circle + Dot" then
        local r = (s + gp) * 2; mk(r, r, 0, 0, { hollow = true, round = true })
        local d = math.max(t * 2, 4); mk(d, d, 0, 0, { round = true })
    elseif style == "Square" then
        local side = s + gp * 2; mk(side, side, 0, 0, { hollow = true })
    elseif style == "Diamond" then
        local side = (s + gp * 2) * 0.75; mk(side, side, 0, 0, { hollow = true, rot = 45 })
    elseif style == "X Cross" then
        local d = (gp + s / 2) * 0.7071
        mk(t, s, d, -d, { rot = 45 });  mk(t, s, -d, d, { rot = 45 })
        mk(t, s, -d, -d, { rot = -45 }); mk(t, s, d, d, { rot = -45 })
    end

    BCX.xhairGui.Enabled = x.on
end

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
    if BCX.sync then BCX.sync("Noclip") end
    if dragConn then dragConn:Disconnect(); dragConn = nil end
    dragConn = rs.Heartbeat:Connect(function()
        if not dragActive then return end
        local curHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local curTgt = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not curHRP or not curTgt then return end
        curTgt.CFrame = curHRP.CFrame * CFrame.new(0, 0, 2)
        setTargetNoclip(targetName, true)
    end)
    task.wait(0.1); BCX.flySwitch("Normal")
end

local function stopDrag(targetName)
    dragActive = false
    if dragConn then dragConn:Disconnect(); dragConn = nil end
    stopFly(); cleanTargetPhysics(targetName); setTargetNoclip(targetName, false); setNoclip(false)
    BCX.flyRefreshQB()
    if BCX.sync then BCX.sync("Noclip") end
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

local function notify(title, desc, duration)
    pcall(function()
        WindUI:Notify({ Title = BCX.msg(title), Content = BCX.msg(desc or ""), Duration = duration or 2 })
    end)
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
    if #names == 0 then table.insert(names, BCX.noWaypoint()) end
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

-- ============================================================
-- ==================== ระบบสถานะกลาง (SYNC) ====================
-- ทุกฟังก์ชันแบบเปิด/ปิดมี get() = สถานะจริง, apply(state) = สั่งทำงานจริง
-- ช่องทางทั้ง 3 (UI / คีย์ลัด / Quick Button) เรียก BCX.feat(name, state) เหมือนกันหมด
-- แล้ว BCX.sync(name) จะดันสถานะจริงไปที่สวิตช์ UI + สีปุ่ม Quick Button
-- ============================================================

-- Tween Track (ตามติดผู้เล่น)
BCX.tweenSession = 0
function BCX.setTween(state)
    isTweeningRelative = state and true or false
    BCX.tweenSession = BCX.tweenSession + 1
    local sid = BCX.tweenSession
    if not isTweeningRelative then
        if tempPlatform then pcall(function() tempPlatform:Destroy() end); tempPlatform = nil end
        local h = getHRP()
        if h then removeBodyVelocity(h) end
        return
    end
    task.spawn(function()
        while isTweeningRelative and sid == BCX.tweenSession do
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

-- Safe Mode (เลือด < 50% วาร์ปหนี)
BCX.safeSession = 0
function BCX.setSafe(state)
    safeModeEnabled = state and true or false
    BCX.safeSession = BCX.safeSession + 1
    local sid = BCX.safeSession
    if not safeModeEnabled then return end
    task.spawn(function()
        while safeModeEnabled and sid == BCX.safeSession do
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

-- ==================== CLICK TP (ไม่ต้องใช้ไอเทม) ====================
-- • คีย์ลัด (ค่าเริ่มต้น R): กดค้างไว้แล้วคลิกตรงจุดไหนก็วาร์ปไปจุดนั้น
-- • โหมดวาร์ปคลิก (Quick Button / สวิตช์ "Click TP"): เปิดแล้วแตะ/คลิกตรงไหนของจอก็วาร์ปไปตรงนั้น
BCX.ctpOn = false
BCX.ctpHold = false
BCX.ctpSession = 0

function BCX.clickTPTo(ray)
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.SeatPart or not ray then return end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = { char }
    rp.IgnoreWater = true
    local res = workspace:Raycast(ray.Origin, ray.Direction * 5000, rp)
    if res then
        local rot = hrp.CFrame - hrp.CFrame.Position
        hrp.CFrame = CFrame.new(res.Position + Vector3.new(0, 3, 0)) * rot
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
    end
end

local function ctpAtMouse()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local m = UserInputService:GetMouseLocation()
    BCX.clickTPTo(cam:ViewportPointToRay(m.X, m.Y))
end

J.track(UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if UserInputService:GetFocusedTextBox() then return end
        if BCX.keyIs("Click TP Key", input) then
            BCX.ctpHold = true -- กดค้างไว้ = เข้าโหมดวาร์ปคลิก (ยังไม่วาร์ปจนกว่าจะคลิก)
        end
    elseif (BCX.ctpOn or BCX.ctpHold) and not gp
        and (input.UserInputType == Enum.UserInputType.MouseButton1
          or input.UserInputType == Enum.UserInputType.Touch) then
        local cam = workspace.CurrentCamera
        if cam then BCX.clickTPTo(cam:ScreenPointToRay(input.Position.X, input.Position.Y)) end
    end
end))
J.track(UserInputService.InputEnded:Connect(function(input)
    if BCX.keyIs("Click TP Key", input) then
        BCX.ctpHold = false
        BCX.ctpSession = BCX.ctpSession + 1
    end
end))

BCX.F = {
    ["Noclip"] = {
        get = function() return noclipEnabled end,
        apply = function(s) setNoclip(s) end,
        label = "Noclip",
    },
    ["Infinite Jump"] = {
        get = function() return infiniteJumpEnabled end,
        apply = function(s) setInfiniteJump(s) end,
        label = "Infinite Jump",
    },
    ["Fly"] = {
        get = function() return isFlying and flyMode == "Normal" end,
        apply = function(s) if s then BCX.flySwitch("Normal") else BCX.flyOff("Normal") end end,
        label = "Fly",
    },
    ["Vehicle Fly"] = {
        get = function() return isFlying and flyMode == "Vehicle" end,
        apply = function(s) if s then BCX.flySwitch("Vehicle") else BCX.flyOff("Vehicle") end end,
        label = "Vehicle Fly",
    },
    ["Anti-Fling"] = {
        get = function() return BCX.afOn end,
        apply = function(s) BCX.setAF(s) end,
        label = "Anti-Fling",
    },
    ["Fling"] = {
        get = function() return BCX.flinging end,
        apply = function(s)
            if not s then BCX.flingStop(); return end
            local mode = (BCX.flingMode == "All Players") and "All" or "Selected"
            if mode == "Selected" and (not BCX.flingTarget or BCX.flingTarget == "") then
                notify("Error", "Select a player first!"); return
            end
            local ok = BCX.flingRun(mode, function()
                BCX.sync("Fling")
                BCX.flyRefreshQB()
                notify("Fling", "Fling finished", 2)
            end)
            if not ok then notify("Error", "Character not found!") end
        end,
        label = "Fling",
    },
    ["Safe Mode"] = {
        get = function() return safeModeEnabled end,
        apply = function(s) BCX.setSafe(s) end,
        label = "Safe Mode",
    },
    ["Tween Track"] = {
        get = function() return isTweeningRelative end,
        apply = function(s) BCX.setTween(s) end,
        label = "Tween Track",
    },
}

BCX.F["Click TP"] = {
    get = function() return BCX.ctpOn end,
    apply = function(s) BCX.ctpOn = s and true or false end,
    label = "Click TP",
}

-- [v3.7.0] NPC ESP ใช้ผ่าน UI / คีย์ลัด / Quick Button ได้เหมือนฟังก์ชันอื่น
BCX.F["NPC ESP"] = {
    get = function() return BCX.npc.on end,
    apply = function(s) BCX.npcSet(s) end,
    label = "NPC ESP",
}

-- [v3.7.0] ล็อกตำแหน่งปุ่มลอยทั้งหมด (Quick Button + ปุ่มวาร์ป) ใช้ผ่าน Quick Button / คีย์ลัดได้
BCX.F["Lock Buttons"] = {
    get = function() return quickButtonsLocked end,
    apply = function(s)
        quickButtonsLocked = s and true or false
        if BCX.applyLockVisual then BCX.applyLockVisual() end
    end,
    label = "Lock Buttons",
}

-- ดันสถานะจริงไปที่ UI + Quick Button
function BCX.sync(name)
    local f = BCX.F[name]
    if not f then return end
    local s = f.get() and true or false
    if BCX.qbSync then BCX.qbSync(name, s) end
    local ui = BCX.UI[name]
    if ui and ui.Set then pcall(function() ui:Set(s) end) end
end

-- จุดเดียวที่ทุกช่องทางเรียก: สั่งเปลี่ยนสถานะ (ถ้าตรงกับสถานะจริงอยู่แล้วจะไม่ทำซ้ำ) แล้วซิงก์ทั้งหมด
-- src = "ui" เมื่อมาจาก callback ของสวิตช์ (กันวนลูปตอนซิงก์กลับ)
function BCX.feat(name, state, src)
    local f = BCX.F[name]
    if not f then return end
    state = state and true or false
    if f.get() == state then
        if src ~= "ui" then BCX.sync(name) end
        return
    end
    local ok, err = pcall(f.apply, state)
    if not ok then warn("[BCX] " .. tostring(name) .. ": " .. tostring(err)) end
    BCX.sync(name)
end

-- กดสลับจากคีย์ลัด: พลิกจากสถานะจริง
function BCX.kbToggle(name)
    local f = BCX.F[name]
    if not f then return end
    local on = not f.get()
    BCX.feat(name, on)
    notify(name, f.get() and "เปิด" or "ปิด", 1.5)
end

E("Hotkey Binder", "ตั้งคีย์ลัดเอง")
E("Hotkey Target", "เลือกสิ่งที่จะตั้งปุ่ม",
  "Pick a function, Save Now, or a waypoint. Then set its key below.",
  "เลือกฟังก์ชัน / บันทึกเดี๋ยวนี้ / จุดเซฟ แล้วตั้งปุ่มด้านล่าง")
E("Hotkey", "ปุ่มคีย์ลัด",
  "Click this, then press the key you want for the selected target.",
  "กดช่องนี้ แล้วกดปุ่มที่ต้องการให้เป็นคีย์ลัดของสิ่งที่เลือก")
E("Clear Hotkey", "ลบคีย์ลัด", "Removes the hotkey of the selected target.", "ลบคีย์ลัดของสิ่งที่เลือก")
E("Auto Waypoint Button", "สร้างปุ่มวาร์ปอัตโนมัติ",
  "Creates a button on the RIGHT side of the screen every time you save a waypoint (uses the Waypoint Button Mode below).",
  "สร้างปุ่มฝั่งขวาของจอให้เองทุกครั้งที่เซฟจุด (ใช้โหมดตาม Waypoint Button Mode ด้านล่าง)")
E("Add Waypoint Button", "เพิ่มปุ่มวาร์ป",
  "Creates a right-side button for the selected waypoint. If it already has one, this switches its mode.",
  "สร้างปุ่มฝั่งขวาให้จุดที่เลือก ถ้ามีปุ่มอยู่แล้วจะเปลี่ยนโหมดของปุ่มนั้นแทน")
E("Remove Waypoint Button", "ลบปุ่มวาร์ป",
  "Removes the button of the selected waypoint (the waypoint itself stays).", "ลบปุ่มของจุดที่เลือก (ตัวจุดยังอยู่)")
E("Waypoint Button Mode", "โหมดปุ่มวาร์ป",
  "Teleport = jump instantly (blue button). Tween = glide to the spot (purple button). Used when a button is created or added.",
  "Teleport = วาร์ปทันที (ปุ่มสีฟ้า) / Tween = ไหลไปที่จุด (ปุ่มสีม่วง) ใช้ตอนสร้าง/เพิ่มปุ่ม")
E("Waypoint Tween Speed", "ความเร็ว Tween ของปุ่มวาร์ป",
  "How fast Tween buttons move you (studs per second).",
  "ความเร็วที่ปุ่ม Tween พาคุณไป (studs ต่อวินาที)")
E("Waypoint Keys", "คีย์ของปุ่มวาร์ป")
E("NPC ESP", "ESP NPC / ม็อบ",
  "Highlights every NPC / mob (anything with a Humanoid that isn't a player) and shows its name and distance.",
  "ไฮไลต์ NPC / ม็อบทุกตัว (ทุกอย่างที่มี Humanoid และไม่ใช่ผู้เล่น) พร้อมชื่อและระยะ")
E("NPC Color", "สี NPC",
  "Color of the NPC highlight and name.", "สีไฮไลต์และชื่อของ NPC")
BCX.NOSAVE["Hotkey Target"] = true
BCX.NOSAVE["Hotkey"] = true

-- ---------- ไฟล์ ----------
local WPB_FILE = "BlackCrown-X/wpbuttons.json"   -- { [PlaceId] = { [ชื่อจุด] = {x=,y=,mode=,v=2} } }
local HK_FILE  = "BlackCrown-X/hotkeys.json"     -- { [id] = "KeyName" }

local function readJSON(path)
    local ok, d = pcall(function()
        if isfile and isfile(path) then return HttpService:JSONDecode(readfile(path)) end
    end)
    if ok and type(d) == "table" then return d end
    return {}
end
local function writeJSON(path, data)
    pcall(function()
        if makefolder and isfolder and not isfolder("BlackCrown-X") then makefolder("BlackCrown-X") end
        if writefile then writefile(path, HttpService:JSONEncode(data)) end
    end)
end

-- ---------- Hotkey ----------
-- id:  "F:<ชื่อฟังก์ชัน>"  |  "S:Save"  |  "W:<PlaceId>:<ชื่อจุด>"  (จุดเซฟแยกตามแมพ)
BCX.hotkeys = readJSON(HK_FILE)
BCX.hkTarget, BCX.hkMap, BCX.hkDD, BCX.hkKB = nil, {}, nil, nil

function BCX.wpId(name) return "W:" .. PlaceId .. ":" .. name end

function BCX.setHotkey(id, key)
    BCX.hotkeys[id] = key
    writeJSON(HK_FILE, BCX.hotkeys)
    if BCX.hkRefreshTags then BCX.hkRefreshTags() end
    if BCX.wpKeySync then BCX.wpKeySync(id, key) end -- [v3.7.0] อัปเดตช่อง Keybind ของปุ่มวาร์ปนั้นให้ตรงกัน
end

function BCX.tpWaypoint(name)
    if BCX.wpTweenStop then BCX.wpTweenStop() end -- วาร์ปทันที = ยกเลิก Tween ที่กำลังไหลอยู่
    local d = waypointsData[name]
    if not d then return end
    local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not root then notify("Error", "Character not found!"); return end
    root.CFrame = CFrame.new(table.unpack(d))
    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
end

function BCX.runHotkeyTarget(id)
    local kind, rest = id:match("^(%a):(.+)$")
    if kind == "F" then
        BCX.kbToggle(rest)
    elseif kind == "S" then
        BCX.saveNow()
    elseif kind == "W" then
        local pid, name = rest:match("^(%d+):(.+)$")
        if pid == PlaceId and name then BCX.goWaypoint(name) end -- [v3.7.0] ทำตามโหมดของปุ่ม (Teleport/Tween)
    end
end

J.track(UserInputService.InputBegan:Connect(function(input)
    if BCX.dead or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if UserInputService:GetFocusedTextBox() then return end
    local k = input.KeyCode.Name
    for id, key in pairs(BCX.hotkeys) do
        if key == k then task.spawn(BCX.runHotkeyTarget, id) end
    end
end))

-- รายการเป้าหมายทั้งหมดที่ตั้งคีย์ลัดได้ (แสดงปุ่มที่ตั้งไว้ต่อท้ายชื่อ)
function BCX.hkTargets()
    local labels, map = {}, {}
    local function add(label, id)
        local k = BCX.hotkeys[id]
        local l = k and (label .. "  [" .. k .. "]") or label
        table.insert(labels, l); map[l] = id
    end
    local names = {}
    for n in pairs(BCX.F) do table.insert(names, n) end
    table.sort(names)
    for _, n in ipairs(names) do add(n, "F:" .. n) end
    add("Save Now", "S:Save")
    local wn = {}
    for n in pairs(waypointsData) do table.insert(wn, n) end
    table.sort(wn)
    for _, n in ipairs(wn) do add("📍 " .. n, BCX.wpId(n)) end
    return labels, map
end

function BCX.hkRefresh(selectId)
    local labels, map = BCX.hkTargets()
    BCX.hkMap = map
    local dd = BCX.hkDD
    if not dd then return end
    pcall(function() dd:Refresh(labels) end)
    local want = selectId or BCX.hkTarget
    local found = false
    if want then
        for l, id in pairs(map) do
            if id == want then found = true; pcall(function() dd:Select(l) end); break end
        end
    end
    if not found then BCX.hkTarget = nil end
end

-- ---------- Waypoint QAB (ฝั่งขวาของจอ) ----------
-- [v3.7.0] ปุ่มวาร์ปมี 2 โหมด: Teleport (สีฟ้า) วาร์ปทันที / Tween (สีม่วง) ไหลไปที่จุดด้วยความเร็วที่ตั้งได้
BCX.WPB = {}            -- [ชื่อจุด] = { Frame=, Tag=, mode=, paint= }
BCX.wpbAuto = true
BCX.wpbMode = "Teleport" -- โหมดของปุ่มที่จะสร้างใหม่
BCX.wpbSpeed = 80        -- ความเร็ว Tween (studs/วินาที)
BCX.WPB_W = math.floor(54 * BCX.BTN_SCALE + 0.5)
BCX.WPB_H = math.floor(42 * BCX.BTN_SCALE + 0.5)
BCX.WPB_COL = {
    Teleport = { bg = Color3.fromRGB(30, 45, 70), stroke = Color3.fromRGB(0, 150, 255),
                 flash = Color3.fromRGB(0, 170, 255), tag = Color3.fromRGB(120, 200, 255) },
    Tween    = { bg = Color3.fromRGB(65, 35, 85), stroke = Color3.fromRGB(200, 100, 255),
                 flash = Color3.fromRGB(200, 100, 255), tag = Color3.fromRGB(225, 170, 255) },
}
BCX.WPKB = {}            -- [ชื่อจุด] = Keybind element ใน Settings > Waypoint Keys
BCX.WPKeySec = nil       -- ตั้งค่าตอนสร้างหน้า Settings
BCX.wpCollide = {}
BCX.wpTweenSession = 0
local wpbGui

local function wpbEnsureGui()
    if wpbGui and wpbGui.Parent then return wpbGui end
    local g = Instance.new("ScreenGui")
    g.Name = "BCX_WaypointButtons"
    g.ResetOnSpawn = false
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.DisplayOrder = 999
    pcall(function() g.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not g.Parent then g.Parent = p:WaitForChild("PlayerGui") end
    J.obj(g)
    wpbGui = g
    return g
end

function BCX.saveWPB()
    local all = readJSON(WPB_FILE)
    local mine = {}
    for name, b in pairs(BCX.WPB) do
        if b.Frame and b.Frame.Parent then
            mine[name] = { x = b.Frame.Position.X.Offset, y = b.Frame.Position.Y.Offset, mode = b.mode, v = 2 }
        end
    end
    all[PlaceId] = mine
    writeJSON(WPB_FILE, all)
end

function BCX.hkRefreshTags()
    for name, b in pairs(BCX.WPB) do
        if b.Tag then b.Tag.Text = BCX.hotkeys[BCX.wpId(name)] or "" end
    end
end

-- ---------- Keybind element ของปุ่มวาร์ปแต่ละปุ่ม (Settings > Waypoint Keys) ----------
function BCX.wpKeyAdd(name)
    local sec = BCX.WPKeySec
    if not sec or BCX.WPKB[name] then return end
    local id = BCX.wpId(name)
    local title = "Waypoint: " .. name
    BCX.NOSAVE[title] = true -- ปุ่มที่ตั้งเก็บใน hotkeys.json อยู่แล้ว ไม่ต้องให้ config เซฟซ้ำ
    local ok, el = pcall(function()
        return sec:Keybind({ Title = title, Value = BCX.hotkeys[id] or "None",
            Callback = function(v)
                -- ถูกเรียกทั้งตอนเปลี่ยนปุ่มและตอนกดปุ่ม: ข้ามถ้าเป็นค่าเดิม / None
                if type(v) ~= "string" or v == "" or v == "None" or v == "Unknown" then return end
                if BCX.hotkeys[id] == v then return end
                BCX.setHotkey(id, v)
                BCX.hkRefresh()
                notify("Saved", "Hotkey = " .. v, 1.5)
            end })
    end)
    if ok and el then BCX.WPKB[name] = el end
end

function BCX.wpKeyRemove(name)
    local el = BCX.WPKB[name]
    if el then pcall(function() el:Destroy() end) end
    BCX.WPKB[name] = nil
end

function BCX.wpKeySync(id, key)
    local n = id:match("^W:" .. PlaceId .. ":(.+)$")
    local el = n and BCX.WPKB[n]
    if el then pcall(function() el:Set(key or "None") end) end
end

-- ---------- Tween ไปที่จุดเซฟ ----------
-- ขยับ HRP ตรงๆ ทุกเฟรมด้วยความเร็ว BCX.wpbSpeed (ทะลุสิ่งกีดขวางระหว่างทาง) แตะปุ่มอื่น/ปุ่ม Teleport = เปลี่ยนเป้าหมายทันที
function BCX.wpTweenRestore()
    for part in pairs(BCX.wpCollide) do
        if part and part.Parent then pcall(function() part.CanCollide = true end) end
    end
    BCX.wpCollide = {}
end

function BCX.wpTweenStop()
    BCX.wpTweenSession = BCX.wpTweenSession + 1
    BCX.wpTweenRestore()
end

function BCX.tweenWaypoint(name)
    local d = waypointsData[name]
    if not d then return end
    local char = p.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then notify("Error", "Character not found!"); return end
    BCX.wpTweenSession = BCX.wpTweenSession + 1
    local sid = BCX.wpTweenSession
    local goal = CFrame.new(table.unpack(d))
    local goalPos, rot = goal.Position, goal - goal.Position

    local hconn, sconn
    local function stop(restore)
        if hconn then hconn:Disconnect() end
        if sconn then sconn:Disconnect() end
        if restore then BCX.wpTweenRestore() end
    end

    -- ปิดการชนของตัวละครระหว่างไหล (Humanoid เปิดกลับทุกเฟรม จึงต้องปิดซ้ำใน Stepped)
    sconn = RunService.Stepped:Connect(function()
        if sid ~= BCX.wpTweenSession or not char.Parent then stop(false); return end
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                BCX.wpCollide[part] = true
                part.CanCollide = false
            end
        end
    end)
    hconn = RunService.Heartbeat:Connect(function(dt)
        if sid ~= BCX.wpTweenSession then stop(false); return end -- มี Tween/Teleport ใหม่มารับช่วงแล้ว
        if J.dead or not hrp.Parent then stop(true); return end
        local diff = goalPos - hrp.Position
        local step = math.max(BCX.wpbSpeed, 1) * dt
        if diff.Magnitude <= step then
            hrp.CFrame = CFrame.new(goalPos) * rot
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            stop(true)
            return
        end
        hrp.CFrame = CFrame.new(hrp.Position + diff.Unit * step) * rot
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    J.track(hconn); J.track(sconn)
end

-- ไปที่จุดเซฟตามโหมดของปุ่ม (ไม่มีปุ่ม = Teleport)
function BCX.goWaypoint(name, mode)
    local b = BCX.WPB[name]
    mode = mode or (b and b.mode) or "Teleport"
    if mode == "Tween" then BCX.tweenWaypoint(name) else BCX.tpWaypoint(name) end
end

function BCX.addWPButton(name, x, y, mode)
    mode = (mode == "Tween" or mode == "Teleport") and mode or BCX.wpbMode
    local ex = BCX.WPB[name]
    if ex and ex.Frame and ex.Frame.Parent then
        -- มีปุ่มอยู่แล้ว: แค่สลับโหมด/สี
        if ex.mode ~= mode then ex.mode = mode; ex.paint() end
        BCX.wpKeyAdd(name)
        return ex
    end
    local gui = wpbEnsureGui()
    local W, H = BCX.WPB_W, BCX.WPB_H
    local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800, 600)
    local count = 0
    for _ in pairs(BCX.WPB) do count = count + 1 end
    if not x or not y then
        -- ตำแหน่งเริ่มต้น: ฝั่งขวา เป็นคอลัมน์ติดกับ Quick Button เรียงลงมา เต็มจอแล้วขึ้นคอลัมน์ใหม่ทางซ้าย
        local rows = math.max(1, math.floor((vp.Y - 140) / (H + 8)))
        local col, row = math.floor(count / rows), count % rows
        x = vp.X - (BCX.QB_SIZE + 12) - W - 10 - col * (W + 8)
        y = 120 + row * (H + 8)
    end
    x = math.clamp(x, 0, math.max(0, vp.X - W))
    y = math.clamp(y, 0, math.max(0, vp.Y - H))

    local col = BCX.WPB_COL[mode]
    local frame = Instance.new("Frame")
    frame.Name = "WPB_" .. name
    frame.Size = UDim2.fromOffset(W, H)
    frame.Position = UDim2.fromOffset(x, y)
    frame.BackgroundColor3 = col.bg
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = col.stroke; stroke.Transparency = 0.4; stroke.Thickness = 1.5

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -6, 0.62, 0)
    label.Position = UDim2.new(0, 3, 0.06, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(235, 240, 255)
    label.TextScaled = true
    label.TextWrapped = true
    label.Font = Enum.Font.GothamBold
    local lim = Instance.new("UITextSizeConstraint", label)
    lim.MinTextSize = 7; lim.MaxTextSize = 28

    local tag = Instance.new("TextLabel", frame)
    tag.Size = UDim2.new(1, -6, 0.26, 0)
    tag.Position = UDim2.new(0, 3, 0.72, 0)
    tag.BackgroundTransparency = 1
    tag.Text = BCX.hotkeys[BCX.wpId(name)] or ""
    tag.TextColor3 = col.tag
    tag.TextScaled = true
    tag.Font = Enum.Font.Gotham
    local lim2 = Instance.new("UITextSizeConstraint", tag)
    lim2.MinTextSize = 6; lim2.MaxTextSize = 20

    local b = { Frame = frame, Tag = tag, mode = mode }
    b.paint = function()
        local c = BCX.WPB_COL[b.mode]
        frame.BackgroundColor3 = c.bg
        stroke.Color = c.stroke
        tag.TextColor3 = c.tag
    end

    -- [v3.7.0] ติดตามเฉพาะ "นิ้ว/เมาส์ที่แตะปุ่มนี้" (เดิมฟังทุกนิ้ว เช่น นิ้วที่กดจอยเดิน ทำให้ปุ่มขยับเอง)
    local dragging, dragStart, startPos, trackInput, moveConn, endConn = false, nil, nil, nil, nil, nil
    local function isMine(i)
        if i.UserInputType == Enum.UserInputType.Touch then return i == trackInput end
        return i.UserInputType == Enum.UserInputType.MouseMovement or i == trackInput
    end
    local function finish(input)
        if input.UserInputType == Enum.UserInputType.Touch and input ~= trackInput then return end -- นิ้วอื่นปล่อย ไม่เกี่ยว
        if moveConn then moveConn:Disconnect(); moveConn = nil end
        if endConn then endConn:Disconnect(); endConn = nil end
        if not startPos then return end
        if dragging then
            BCX.saveWPB()
        else
            frame.BackgroundColor3 = BCX.WPB_COL[b.mode].flash
            task.delay(0.25, function() if frame.Parent then b.paint() end end)
            BCX.goWaypoint(name)
        end
        dragging = false; startPos = nil; trackInput = nil
    end
    J.track(frame.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if t ~= Enum.UserInputType.Touch and t ~= Enum.UserInputType.MouseButton1 then return end
        trackInput, dragStart, startPos, dragging = input, input.Position, frame.Position, false
        if moveConn then moveConn:Disconnect() end
        if endConn then endConn:Disconnect() end
        moveConn = UserInputService.InputChanged:Connect(function(i)
            if quickButtonsLocked then dragging = false; return end -- ล็อกอยู่ = ไม่ลาก (แตะยังใช้ได้)
            if not startPos or not isMine(i) then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = i.Position - dragStart
            if dragging or d.Magnitude > 14 then
                dragging = true
                frame.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
            end
        end)
        endConn = UserInputService.InputEnded:Connect(finish)
    end))

    BCX.WPB[name] = b
    BCX.wpKeyAdd(name)
    if BCX.applyLockVisual then BCX.applyLockVisual() end
    return b
end

function BCX.removeWPButton(name)
    local b = BCX.WPB[name]
    if b then
        pcall(function() b.Frame:Destroy() end)
        BCX.WPB[name] = nil
        BCX.wpKeyRemove(name)
        BCX.saveWPB()
    end
end

-- โหลดปุ่มของแมพนี้ (เรียกจาก PART D)
function BCX.loadWPButtons()
    local mine = readJSON(WPB_FILE)[PlaceId]
    if type(mine) ~= "table" then return end
    local migrated = false
    for name, pos in pairs(mine) do
        if waypointsData[name] and type(pos) == "table" then
            if pos.v == 2 then
                BCX.addWPButton(name, pos.x, pos.y, pos.mode)
            else
                -- ปุ่มเก่า (v3.6.x) เคยอยู่ฝั่งซ้าย: ย้ายมาฝั่งขวาให้เองเป็นโหมด Teleport
                BCX.addWPButton(name, nil, nil, "Teleport")
                migrated = true
            end
        end
    end
    if migrated then BCX.saveWPB() end
end

-- ==================== UI: AIMBOT TAB ====================
local AimbotSection = AimbotTab:Section({ Title = "Aimbot Core", Icon = "target" })
AimbotSection:Toggle({ Title="Enable Aimbot",    Desc="เปิดใช้งาน (คลิกขวาค้าง)", Default=false, Callback=function(s) aimbotEnabled=s end })
AimbotSection:Toggle({ Title="Wallcheck",        Desc="ไม่ล็อกเป้าถ้ามีกำแพงบัง",  Default=false, Callback=function(s) wallCheckEnabled=s end })
AimbotSection:Dropdown({ Title="Target Part",    Values={"Head","HumanoidRootPart"}, Value="Head", Callback=function(v) aimbotTargetPart=v end })
AimbotSection:Input({ Title="Smoothness",        Value="1", Placeholder="1=ล็อกทันที, 5=นุ่ม...", Callback=function(v) local n=tonumber(v); if n and n>0 then aimbotSmoothness=n end end })
AimbotSection:Toggle({ Title="Crosshair", Default=false, Callback=function(s) BCX.xhair.on=s; BCX.xhairUpdate() end })
AimbotSection:Dropdown({ Title="Crosshair Style", Values=BCX.XHAIR_STYLES, Value="Plus", Callback=function(v) BCX.xhair.style=v; BCX.xhairUpdate() end })
AimbotSection:Slider({ Title="Crosshair Size", Step=1, Value={Min=4,Max=40,Default=12}, Callback=function(v) BCX.xhair.size=tonumber(v) or 12; BCX.xhairUpdate() end })
AimbotSection:Slider({ Title="Crosshair Thickness", Step=1, Value={Min=1,Max=8,Default=2}, Callback=function(v) BCX.xhair.thick=tonumber(v) or 2; BCX.xhairUpdate() end })
AimbotSection:Toggle({ Title="Crosshair Outline", Default=true, Callback=function(s) BCX.xhair.outline=s; BCX.xhairUpdate() end })
AimbotSection:Colorpicker({ Title="Crosshair Color", Default=Color3.new(1,1,1), Callback=function(c) BCX.xhair.color=c; BCX.xhairUpdate() end })

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
-- [v3.7.0] NPC ESP: ไฮไลต์ + ชื่อ + ระยะ ของทุกตัวที่มี Humanoid และไม่ใช่ผู้เล่น
BCX.UI["NPC ESP"] = ESPSettingsSection:Toggle({ Title="NPC ESP", Default=false, Callback=function(s)
    BCX.feat("NPC ESP", s, "ui")
end })
ESPSettingsSection:Colorpicker({ Title="Enemy / Default Color", Default=Color3.fromRGB(255,0,0),   Callback=function(c) espColor=c end })
ESPSettingsSection:Colorpicker({ Title="Friend Color",          Default=Color3.fromRGB(0,255,128), Callback=function(c) friendColor=c end })
ESPSettingsSection:Colorpicker({ Title="NPC Color", Default=Color3.fromRGB(255,140,0), Callback=function(c)
    BCX.npc.color = c
    for _, d in pairs(BCX.npc.objs) do
        if d.hl then d.hl.FillColor = c end
        if d.text then d.text.Color = c end
    end
end })

local ObjectSearchSection = ESPTab:Section({ Title = "Object Search ESP", Icon = "search" })
ObjectSearchSection:Input({ Title="Search Name", Placeholder="เช่น Door, Chest, Coin...", Callback=function(v) searchTargetText=v; BCX.queueObjectESP() end })
local exactToggle, partialToggle
exactToggle   = ObjectSearchSection:Toggle({ Title="Exact Match",   Default=false, Callback=function(s) exactMatchEnabled=s; if s and partialMatchEnabled then partialMatchEnabled=false; if partialToggle and partialToggle.SetValue then partialToggle:SetValue(false) end end; BCX.queueObjectESP() end })
partialToggle = ObjectSearchSection:Toggle({ Title="Partial Match", Default=false, Callback=function(s) partialMatchEnabled=s; if s and exactMatchEnabled then exactMatchEnabled=false; if exactToggle and exactToggle.SetValue then exactToggle:SetValue(false) end end; BCX.queueObjectESP() end })
-- [v3.6.4] เปลี่ยนสีแล้วอัปเดตของที่หาเจอแล้วเลย ไม่สแกน workspace ใหม่ทุกครั้งที่ลาก Colorpicker
ObjectSearchSection:Colorpicker({ Title="Search ESP Color", Default=Color3.fromRGB(255,255,0), Callback=function(c)
    objectEspColor = c
    for _, d in pairs(searchedObjects) do
        if d.highlight then d.highlight.FillColor = c end
        if d.boxInline then d.boxInline.Color = c end
        if d.nameText then d.nameText.Color = c end
        if d.tracer then d.tracer.Color = c end
    end
end })

-- ==================== UI: TELEPORT TAB ====================
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

local TweenSection = TPTab:Section({ Title = "Tween Tracking", Icon = "crosshair" })
local tweenPlayerDropdown = TweenSection:Dropdown({ Title="Select Player to Track", Values=getPlayerList(), Value="", Callback=function(v) selectedPlayerName=v end })
TweenSection:Button({ Title="Refresh",  Callback=function() safeRefresh(tweenPlayerDropdown) end })
TweenSection:Dropdown({ Title="Direction",    Values={"Behind","Front","Above","Below","Left","Right"}, Value="Behind", Callback=function(v) tweenDirection=v end })
TweenSection:Input({   Title="Distance",      Value="5",    Placeholder="เช่น 3, 5, 10...",  Callback=function(v) local n=tonumber(v); if n then tweenDistance=n end end })
TweenSection:Toggle({  Title="Auto Look",     Default=false, Callback=function(s) isAutoLooking=s end })
TweenSection:Toggle({  Title="Create Platform Under Feet", Default=true, Callback=function(s) createPlatform=s; if not s and tempPlatform then tempPlatform:Destroy(); tempPlatform=nil end end })
BCX.UI["Tween Track"] = TweenSection:Toggle({ Title="Enable Relative Tween", Default=false, Callback=function(state)
    BCX.feat("Tween Track", state, "ui")
end })

-- Waypoints
local WaypointSection = TPTab:Section({ Title = "Saved Waypoints", Icon = "bookmark" })
WaypointSection:Input({ Title="Waypoint Name", Placeholder="พิมพ์ชื่อจุด...", Callback=function(text) currentInputName=text end })

waypointDropdown = nil

function BCX.createWPDropdown(names)
    waypointDropdown = WaypointSection:Dropdown({
        Title    = "Select Waypoint",
        Values   = names,
        Value    = "",
        Callback = function(val)
            selectedWaypointName = (waypointsData[val] ~= nil) and val or ""
        end
    })
end

local function rebuildWPDrop(selectName)
    local names = getWaypointNamesList()
    local pick = (selectName and waypointsData[selectName] ~= nil) and selectName or nil
    selectedWaypointName = pick or ""

    local done = false
    if waypointDropdown then
        local okR = pcall(function() waypointDropdown:Refresh(names) end)
        if okR then
            done = true
            if pick then pcall(function() waypointDropdown:Select(pick) end) end
        end
    end
    if not done then
        if waypointDropdown then
            pcall(function() waypointDropdown:Destroy() end)
            pcall(function() if waypointDropdown.Frame then waypointDropdown.Frame:Destroy() end end)
            waypointDropdown = nil
        end
        BCX.createWPDropdown(names)
        if pick then pcall(function() waypointDropdown:Select(pick) end) end
    end
end

BCX.createWPDropdown(getWaypointNamesList())

WaypointSection:Button({ Title="Save Current Position", Callback=function()
    local trimmed = currentInputName:match("^%s*(.-)%s*$")
    if trimmed == "" then notify("Error", "พิมพ์ชื่อก่อน!"); return end
    local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if root then
        waypointsData[trimmed] = { root.CFrame:GetComponents() }
        saveWaypointsToFile()
        rebuildWPDrop(trimmed)
        if BCX.wpbAuto then BCX.addWPButton(trimmed, nil, nil, BCX.wpbMode); BCX.saveWPB() end
        BCX.hkRefresh()
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
    BCX.removeWPButton(d); BCX.setHotkey(BCX.wpId(d), nil); BCX.hkRefresh()
    notify("Deleted", "ลบ: " .. d)
end })
WaypointSection:Button({ Title="🔄 Refresh List", Callback=function()
    rebuildWPDrop()
    notify("Refreshed", "รีเฟรชรายชื่อแล้ว", 1.5)
end })

-- [v3.7.0] โหมดของปุ่มวาร์ปที่จะสร้าง: Teleport (ฟ้า) / Tween (ม่วง)
WaypointSection:Dropdown({ Title="Waypoint Button Mode", Values={"Teleport","Tween"}, Value="Teleport",
    Callback=function(v) BCX.wpbMode = (v == "Tween") and "Tween" or "Teleport" end })
WaypointSection:Slider({ Title="Waypoint Tween Speed", Step=1, Value={Min=10,Max=300,Default=80},
    Callback=function(v) BCX.wpbSpeed = tonumber(v) or 80 end })
WaypointSection:Toggle({ Title="Auto Waypoint Button", Value=true, Callback=function(s) BCX.wpbAuto = s end })
WaypointSection:Button({ Title="Add Waypoint Button", Callback=function()
    if selectedWaypointName == "" or not waypointsData[selectedWaypointName] then
        notify("Error", "Select a waypoint first!"); return
    end
    BCX.addWPButton(selectedWaypointName, nil, nil, BCX.wpbMode); BCX.saveWPB()
    notify("Added", "Added " .. selectedWaypointName .. " (" .. BCX.wpbMode .. ")")
end })
WaypointSection:Button({ Title="Remove Waypoint Button", Callback=function()
    if selectedWaypointName == "" then notify("Error", "Select a waypoint first!"); return end
    BCX.removeWPButton(selectedWaypointName)
    notify("Removed", "Removed " .. selectedWaypointName)
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
local flySpeedSliderRef

local MovementSection = LocalPlayerTab:Section({ Title = "Movement", Icon = "move" })
BCX.UI["Noclip"] = MovementSection:Toggle({ Title="Noclip", Desc="เดินทะลุกำแพง", Value=false, Flag="NoclipToggle", Callback=function(s)
    BCX.feat("Noclip", s, "ui")
end })
BCX.UI["Infinite Jump"] = MovementSection:Toggle({ Title="Infinite Jump", Desc="กระโดดไม่จำกัด", Value=false, Flag="InfJumpToggle", Callback=function(s)
    BCX.feat("Infinite Jump", s, "ui")
end })

-- Fly (ตัวละคร) — เปิดแล้ว Vehicle Fly จะถูกปิดเสมอ
BCX.UI["Fly"] = MovementSection:Toggle({ Title="Fly", Desc="บินอย่างอิสระ", Value=false, Flag="FlyToggle", Callback=function(s)
    BCX.feat("Fly", s, "ui")
end })

-- Vehicle Fly (ยกรถ/วัตถุที่นั่งไปด้วย) — เปิดแล้ว Fly ปกติจะปิดเสมอ
BCX.UI["Vehicle Fly"] = MovementSection:Toggle({ Title="Vehicle Fly", Desc="บินพร้อมยานพาหนะ", Value=false, Flag="VehFlyToggle", Callback=function(s)
    BCX.feat("Vehicle Fly", s, "ui")
end })

flySpeedSliderRef = MovementSection:Slider({
    Title="Fly Speed", Desc="ความเร็วการบิน", Step=1, Flag="FlySpeedValue",
    Value={Min=10, Max=500, Default=50},
    Callback=function(val) flySpeed = tonumber(val) or 50 end
})
MovementSection:Toggle({ Title="Fly CFrame Mode", Default=false, Callback=function(s) flyForceCFrame = s end })

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

-- [3] Auto-Save
local autoSaveIntervalMin = 5
local autoSaveEnabled = false
local autoSaveThread = nil

local SaveSection = LocalPlayerTab:Section({ Title = "Auto-Save", Icon = "save" })

function BCX.saveNow()
    local ok, err = pcall(function() return BCX.cfg:Save() end)
    if ok then notify("Saved", "บันทึกแล้ว ✅", 2)
    else notify("Error", tostring(err), 4) end
end

SaveSection:Slider({ Title="Auto-Save Interval (min)", Desc="บันทึกทุก N นาที", Step=1, Value={Min=1,Max=30,Default=5}, Callback=function(val) autoSaveIntervalMin=tonumber(val) or 5 end })
SaveSection:Toggle({ Title="Enable Auto-Save", Desc="บันทึกอัตโนมัติตามเวลา", Value=false, Callback=function(state)
    autoSaveEnabled = state
    if autoSaveThread then task.cancel(autoSaveThread); autoSaveThread=nil end
    if autoSaveEnabled then
        autoSaveThread = task.spawn(function()
            while autoSaveEnabled do
                task.wait(autoSaveIntervalMin*60)
                if autoSaveEnabled then BCX.saveNow() end
            end
        end)
    end
end })
SaveSection:Button({ Title="Save Now", Callback=function() BCX.saveNow() end })
SaveSection:Button({ Title="Load Saved Settings", Callback=function()
    local ok, err = pcall(function() BCX.cfg:Load() end)
    if ok then notify("Loaded","โหลดสำเร็จ ✅", 2) else notify("Error", tostring(err), 4) end
end })

-- ==================== UI: MISC TAB ====================
local EmoteSection = MiscTab:Section({ Title = "Emote & Animation", Icon = "smile" })
local emotePlayerDropdown = EmoteSection:Dropdown({ Title="Select Target", Values=getPlayerList(), Value="", Callback=function(v)
    emoteTargetPlayerName = (v ~= "None") and v or ""
    if isCopyingPlayerEmote and emoteTargetPlayerName ~= "" then startMirroringTarget(emoteTargetPlayerName) end
end })
EmoteSection:Button({ Title="Refresh",  Callback=function() safeRefresh(emotePlayerDropdown) end })
BCX.copyToggle = EmoteSection:Toggle({ Title="Copy Player Movement", Default=false, Callback=function(state)
    isCopyingPlayerEmote = state
    if not state then
        stopMirroring()
    else
        if emoteTargetPlayerName == "" then
            notify("Error", "Select a player first!")
            isCopyingPlayerEmote = false
            pcall(function() BCX.copyToggle:Set(false) end)
            return
        end
        stopCustomEmotes(); startMirroringTarget(emoteTargetPlayerName)
    end
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
BCX.UI["Click TP"] = ToolsSection:Toggle({ Title="Click TP Mode", Value=false, Callback=function(s)
    BCX.feat("Click TP", s, "ui")
end })
ToolsSection:Button({ Title="Get TP Tool", Desc="เครื่องมือคลิกเพื่อวาร์ป", Callback=function()
    local plr = localPlayer
    if plr then
        local mouse = plr:GetMouse()
        local tptool = Instance.new("Tool")
        tptool.Name = "Click TP"; tptool.RequiresHandle = false; tptool.CanBeDropped = false
        tptool.Parent = plr:FindFirstChildOfClass("Backpack") or plr:WaitForChild("Backpack")
        J.obj(tptool)
        tptool.Activated:Connect(function()
            local hr = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hr and mouse.Target then hr.CFrame = CFrame.new(mouse.Hit.X, mouse.Hit.Y+3, mouse.Hit.Z) end
        end)
    end
end })

-- ==================== FLING UI ====================
do
    local FlingSection = MiscTab:Section({ Title = "Fling", Icon = "wind" })
    BCX.flingDD = FlingSection:Dropdown({ Title="Select Fling Target", Values=getPlayerList(), Value="",
        Callback=function(v) BCX.flingTarget = (v ~= "None") and v or "" end })
    FlingSection:Button({ Title="Refresh", Callback=function() safeRefresh(BCX.flingDD) end })
    FlingSection:Dropdown({ Title="Fling Mode", Values={"Selected Player","All Players"}, Value="Selected Player",
        Callback=function(v) BCX.flingMode = v end })
    BCX.UI["Fling"] = FlingSection:Toggle({ Title="Start Fling", Default=false, Callback=function(s)
        BCX.feat("Fling", s, "ui")
    end })
    BCX.flingToggle = BCX.UI["Fling"]
end

-- ==================== รายชื่อผู้เล่นใน Dropdown (อัปเดตเองเมื่อมีคนเข้า/ออก) ====================
-- [v3.6.4] ตัวการสไปค์ 1-3 วินาทีในล็อก: Dropdown:Refresh() ของ WindUI ลบ+สร้างทุกแถวใหม่
-- (Frame + TextLabel + UIListLayout ต่อแถว) และเดิมถูกยิงทุกครั้งที่มีคนเข้า/ออก ×5 Dropdown
-- แก้โดย: debounce 3 วิ / ข้ามถ้ารายชื่อไม่เปลี่ยน / ไม่ทำตอนเมนูปิด (รอไปทำตอนเปิด) / ทำทีละอัน เฟรมละอัน
BCX.PlayerDD = { tpPlayerDropdown, tweenPlayerDropdown, dragDropdown, emotePlayerDropdown, BCX.flingDD }
BCX.ddLast, BCX.ddTick, BCX.ddDirty, BCX.ddBusy = "", 0, false, false

local function uiOpenNow()
    local ok, v = pcall(function()
        if Window.Closed ~= nil then return not Window.Closed end
        return Window.UIElements.Main.Visible
    end)
    if ok and v ~= nil then return v end
    return true
end

function BCX.refreshDD(force)
    if BCX.dead or BCX.ddBusy then return end
    -- เมนูปิดอยู่ = ยังไม่ต้องสร้างอะไร แค่จดไว้ว่าต้องรีเฟรชตอนเปิดเมนู
    if not force and not uiOpenNow() then BCX.ddDirty = true; return end
    local list = getPlayerList()
    local sig = table.concat(list, "|")
    if sig == BCX.ddLast then BCX.ddDirty = false; return end -- รายชื่อไม่เปลี่ยน ไม่ต้องทำ
    BCX.ddLast, BCX.ddDirty, BCX.ddBusy = sig, false, true
    task.spawn(function()
        for _, dd in ipairs(BCX.PlayerDD) do
            if BCX.dead then break end
            if dd then pcall(function() dd:Refresh(list) end) end
            task.wait() -- เฟรมละ 1 Dropdown ไม่ให้ก้อนเดียวหนัก
        end
        BCX.ddBusy = false
    end)
end

-- รวมเหตุการณ์เข้า/ออกที่ติดกันเป็นการรีเฟรชครั้งเดียว หลังเงียบไป 3 วิ
local function queueDD()
    BCX.ddTick = BCX.ddTick + 1
    local t = BCX.ddTick
    task.delay(3, function() if t == BCX.ddTick then BCX.refreshDD() end end)
end
J.track(players.PlayerAdded:Connect(queueDD))
J.track(players.PlayerRemoving:Connect(queueDD))
task.delay(1, function() BCX.refreshDD(true) end)

-- ตอนเมนูเปิด ถ้ามีรายชื่อค้างรออัปเดต ค่อยทำทีเดียว (เช็กทุก 0.5 วิ ไม่ใช่ทุกเฟรม)
task.spawn(function()
    while not BCX.dead do
        task.wait(0.5)
        if BCX.ddDirty and uiOpenNow() then BCX.refreshDD() end
    end
end)

-- Safety อยู่ท้ายสุดของ Misc
local SafetySection = MiscTab:Section({ Title = "Safety", Icon = "shield" })
BCX.UI["Safe Mode"] = SafetySection:Toggle({ Title="Safe Mode (< 50% HP TP)", Default=false, Callback=function(state)
    BCX.feat("Safe Mode", state, "ui")
end })
BCX.UI["Anti-Fling"] = SafetySection:Toggle({ Title="Anti-Fling", Default=false, Callback=function(state)
    BCX.feat("Anti-Fling", state, "ui")
end })
BCX.afToggle = BCX.UI["Anti-Fling"]

-- ==================== CALLBACK MAP สำหรับ Quick Buttons ====================
-- ทุกปุ่มเรียก BCX.feat เหมือนกับ UI และคีย์ลัด (สถานะจริงที่เดียว)
local TOGGLE_CALLBACKS = {}
for name in pairs(BCX.F) do
    TOGGLE_CALLBACKS[name] = function(state) BCX.feat(name, state) end
end

-- ==================== UI: SETTINGS TAB ====================
-- [0] Language + Show Descriptions + UI Layout Mode
do
    local LangSection = SettingsTab:Section({ Title = "Language", Icon = "languages" })
    LangSection:Dropdown({ Title = "Language", Values = { "English", "ไทย" },
        Value = (BCX.Lang == "Thai") and "ไทย" or "English",
        Callback = function(v)
            BCX.setLang(v == "ไทย" and "Thai" or "English")
            notify("Language", "Language changed", 2)
        end })
    LangSection:Toggle({ Title = "Show Descriptions", Value = BCX.ShowDesc, Callback = function(s)
        BCX.ShowDesc = s
        pcall(function()
            if makefolder and isfolder and not isfolder("BlackCrown-X") then makefolder("BlackCrown-X") end
            if writefile then writefile("BlackCrown-X/showdesc.txt", s and "1" or "0") end
        end)
        BCX.apply()
    end })
    -- สลับ UI: เซฟโหมด -> เซฟค่า -> ทำลายทุกอย่าง -> รันใหม่ตามโหมดที่เลือก
    LangSection:Dropdown({ Title = "UI Layout Mode", Values = { "Auto", "PC", "Mobile" },
        Value = BCX.UIPref,
        Callback = function(v)
            if v == BCX.UIPref then return end
            BCX.UIPref = v
            pcall(function()
                if makefolder and isfolder and not isfolder("BlackCrown-X") then makefolder("BlackCrown-X") end
                if writefile then writefile("BlackCrown-X/uimode.txt", v) end
            end)
            BCX.reload()
        end })
end

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
    local f = BCX.F[selectedQBFunc]
    local real = f and f.get() or false   -- ปุ่มใหม่เริ่มจากสถานะจริง
    local vw = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X) or 800
    createQuickButton(selectedQBFunc, vw - (BCX.QB_SIZE + 12), 120 + #QuickButtons*(BCX.QB_SIZE + 8), BCX.QB_SIZE, real, TOGGLE_CALLBACKS[selectedQBFunc])
    saveQuickButtons()
    notify("เพิ่มแล้ว", "ปุ่ม "..selectedQBFunc.." บนหน้าจอ")
end })
QBSection:Button({ Title="Remove Selected Button", Callback=function()
    removeQuickButton(selectedQBFunc); notify("ลบแล้ว", "ลบ "..selectedQBFunc)
end })
-- [v3.7.0] ล็อกเป็นฟังก์ชันกลาง "Lock Buttons" (ซิงก์ UI / Quick Button / คีย์ลัด) ล็อกทั้ง Quick Button และปุ่มวาร์ป
BCX.UI["Lock Buttons"] = QBSection:Toggle({ Title="Lock Button Positions", Value=false, Callback=function(state)
    BCX.feat("Lock Buttons", state, "ui")
end })
QBSection:Button({ Title="Remove All Buttons", Callback=function()
    removeAllQuickButtons(); notify("ลบแล้ว","ลบปุ่มทั้งหมดแล้ว")
end })

BCX.btnScaleTick = 0
function BCX.applyBtnScale(s)
    s = math.clamp(s, 0.5, 2)
    BCX.BTN_SCALE = s
    BCX.QB_SIZE = math.floor(46 * s + 0.5)
    BCX.WPB_W = math.floor(54 * s + 0.5)
    BCX.WPB_H = math.floor(42 * s + 0.5)
    for _, b in ipairs(QuickButtons) do
        if b.Frame and b.Frame.Parent then
            b.Frame.Size = UDim2.fromOffset(BCX.QB_SIZE, BCX.QB_SIZE)
        end
    end
    for _, b in pairs(BCX.WPB) do
        if b.Frame and b.Frame.Parent then
            b.Frame.Size = UDim2.fromOffset(BCX.WPB_W, BCX.WPB_H)
        end
    end
    -- เขียนไฟล์หลังหยุดลากสไลด์
    BCX.btnScaleTick = BCX.btnScaleTick + 1
    local t = BCX.btnScaleTick
    task.delay(0.4, function()
        if t ~= BCX.btnScaleTick then return end
        pcall(function()
            if makefolder and isfolder and not isfolder("BlackCrown-X") then makefolder("BlackCrown-X") end
            if writefile then writefile("BlackCrown-X/btnscale.txt", tostring(s)) end
        end)
        saveQuickButtons()
        if BCX.saveWPB then BCX.saveWPB() end
    end)
end

QBSection:Slider({ Title="Button Size", Step=5,
    Value={ Min=50, Max=200, Default=math.floor(BCX.BTN_SCALE * 100 + 0.5) },
    Callback=function(v) BCX.applyBtnScale((tonumber(v) or 100) / 100) end })

-- [B] Hotkey Binder (ย้ายมาอยู่เหนือ Keybinds)
do
    local HK = SettingsTab:Section({ Title = "Hotkey Binder", Icon = "keyboard" })
    local labels, map = BCX.hkTargets()
    BCX.hkMap = map

    BCX.hkDD = HK:Dropdown({ Title = "Hotkey Target", Values = labels, Value = "",
        Callback = function(v)
            local id = BCX.hkMap[v]
            if not id then return end
            BCX.hkTarget = id
            local cur = BCX.hotkeys[id]
            if BCX.hkKB then pcall(function() BCX.hkKB:Set(cur or "None") end) end
        end })

    BCX.hkKB = HK:Keybind({ Title = "Hotkey", Value = "None",
        Callback = function(v)
            -- ถูกเรียกทั้งตอนเปลี่ยนปุ่มและตอนกดปุ่ม: ข้ามถ้าเป็นค่าเดิม / None
            if type(v) ~= "string" or v == "" or v == "None" or v == "Unknown" then return end
            local id = BCX.hkTarget
            if not id or BCX.hotkeys[id] == v then return end
            for other, key in pairs(BCX.hotkeys) do
                if key == v and other ~= id then
                    notify("Hotkey", v .. " ถูกใช้กับอย่างอื่นอยู่แล้ว (จะทำงานทั้งคู่)", 3)
                    break
                end
            end
            BCX.setHotkey(id, v)
            BCX.hkRefresh(id)
            notify("Saved", "Hotkey = " .. v, 1.5)
        end })

    HK:Button({ Title = "Clear Hotkey", Callback = function()
        local id = BCX.hkTarget
        if not id then notify("Error", "Select a player first!"); return end
        BCX.setHotkey(id, nil)
        if BCX.hkKB then pcall(function() BCX.hkKB:Set("None") end) end
        BCX.hkRefresh(id)
        notify("Deleted", "Hotkey cleared", 1.5)
    end })
end

-- [C] Keybinds (ทุกปุ่มพลิกจากสถานะจริง แล้วซิงก์ UI + Quick Button)
local KeybindSection = SettingsTab:Section({ Title = "Keybinds", Icon = "keyboard" })
KeybindSection:Keybind({ Title="Noclip",         Value="V", Callback=function() BCX.kbToggle("Noclip") end })
KeybindSection:Keybind({ Title="Infinite Jump",  Value="T", Callback=function() BCX.kbToggle("Infinite Jump") end })
KeybindSection:Keybind({ Title="Fly",            Value="F", Callback=function() BCX.kbToggle("Fly") end })
KeybindSection:Keybind({ Title="Vehicle Fly",    Value="G", Callback=function() BCX.kbToggle("Vehicle Fly") end })
-- คีย์ลัดที่จัดการเองผ่าน InputBegan (ปรับปุ่มได้ ค่าจริงอ่านจาก BCX.KB)
BCX.KB["Fly Up"]       = KeybindSection:Keybind({ Title="Fly Up",       Value="Space",       Callback=BCX.kbRec("Fly Up") })
BCX.KB["Fly Down"]     = KeybindSection:Keybind({ Title="Fly Down",     Value="LeftControl", Callback=BCX.kbRec("Fly Down") })
BCX.KB["Free Mouse"]   = KeybindSection:Keybind({ Title="Free Mouse",   Value="Y",           Callback=BCX.kbRec("Free Mouse") })
BCX.KB["Click TP Key"] = KeybindSection:Keybind({ Title="Click TP Key", Value="R",           Callback=BCX.kbRec("Click TP Key") })
BCX.KB["Toggle UI"]    = KeybindSection:Keybind({ Title="Toggle UI",    Value="LeftAlt",     Callback=BCX.kbRec("Toggle UI", function(v)
    local kc = Enum.KeyCode[v]
    if kc then Window:SetToggleKey(kc) end
end) })

KeybindSection:Dropdown({ Title="Free Mouse Cursor", Values={"Real (no lag)","Fake"}, Value="Real (no lag)",
    Callback=function(v) BCX.fmFake = (v == "Fake") end })
BCX.UI["Auto Free Mouse"] = KeybindSection:Toggle({ Title="Auto Free Mouse", Value=true, Callback=function(s)
    BCX.autoFM = s
end })
BCX.KB["Emergency Reset Key"]  = KeybindSection:Keybind({ Title="Emergency Reset Key",  Value="Delete", Callback=BCX.kbRec("Emergency Reset Key") })
BCX.KB["Force Mouse Lock Key"] = KeybindSection:Keybind({ Title="Force Mouse Lock Key", Value="K",      Callback=BCX.kbRec("Force Mouse Lock Key") })

local EmergencySection = SettingsTab:Section({ Title = "Emergency", Icon = "triangle-alert" })
EmergencySection:Button({ Title="Emergency Reset", Desc="ปิดทุกฟังก์ชัน + คืนเมาส์/กล้อง (คีย์ลัด: Delete)", Callback=function() if BCX.panic then BCX.panic() end end })
EmergencySection:Button({ Title="Unload Script", Desc="ลบสคริปต์ทิ้งทั้งหมด (กด Delete 2 ครั้งติดกันก็ได้)", Callback=function() if BCX.unload then BCX.unload() end end })

-- [v3.7.0] Keybind ของปุ่มวาร์ปแต่ละปุ่ม ("Waypoint: ชื่อจุด") จะถูกสร้างต่อท้ายหัวข้อนี้ตอนสร้างปุ่ม
-- (ต้องสร้างเป็นอันสุดท้ายของหน้า Settings เพื่อให้ element ที่เพิ่มทีหลังต่อท้ายหัวข้อนี้พอดี)
BCX.WPKeySec = SettingsTab:Section({ Title = "Waypoint Keys", Icon = "map-pin" })

-- ปุ่ม Save ถาวร: เป็นหนึ่งใน "ปุ่มลัดบนจอ (ลากได้)" ลบไม่ได้
function BCX.saveLabelText() return (BCX.Lang == "Thai") and "บันทึกเดี๋ยวนี้" or "Save Now" end
createQuickButton("Save", 80, 200, BCX.QB_SIZE, false, function() BCX.saveNow() end,
    { permanent = true, momentary = true, label = BCX.saveLabelText() })
BCX.onLang = function()
    for _, btn in ipairs(QuickButtons) do
        if btn.permanent and btn.Label then pcall(function() btn.Label.Text = BCX.saveLabelText() end) end
    end
end

-- ==================== LOAD CONFIGS & QUICK BUTTONS ====================
task.delay(1, function()
    if BCX.dead then return end
    local ok, err = pcall(function() BCX.cfg:Load() end)
    if ok then notify("BlackCrown-X","โหลดการตั้งค่าก่อนหน้าแล้ว ✅", 3)
    else warn("Load failed:", err) end
end)

task.delay(1.5, function()
    if BCX.dead then return end
    -- ใช้ปุ่มเปิด/ปิดเมนูที่เซฟไว้ (ถ้ามี)
    pcall(function()
        local kc = BCX.keyCode("Toggle UI")
        if kc then Window:SetToggleKey(kc) end
    end)
    loadQuickButtons(TOGGLE_CALLBACKS)
    BCX.loadWPButtons()
    -- ซิงก์ทุกฟังก์ชันอีกรอบหลังโหลดเสร็จ ให้ UI กับปุ่มตรงกับสถานะจริง
    for name in pairs(BCX.F) do pcall(BCX.sync, name) end
    if BCX.applyLockVisual then BCX.applyLockVisual() end
end)

-- ==================== FINAL ====================
print("BlackCrown-X v3.7.0 loaded (UI mode: " .. BCX.UIPref .. (BCX.isMobile and " -> Mobile" or " -> PC") .. ")")
Window:SetToggleKey(Enum.KeyCode.LeftAlt)

-- ==================== FREE MOUSE (กด Y สลับ เปิด/ปิด) ====================
-- เปิด: ซ่อนเมาส์/crosshair ของเกม + วาดเมาส์ของเราแทน | ปิด: คืนของเดิม
task.spawn(function()
    local FM = { on = false, hidden = {}, prevBehavior = nil, prevIcon = nil, prevFirst = false, prevMouseIcon = nil,
                 lastBehavior = nil, lastIcon = nil, restoreUntil = 0,
                 autoFake = false, conflicts = 0, prevUISIcon = nil }
    -- ตอนกดคลิกขวาค้างลากกล้อง Roblox จะตั้ง LockCurrentPosition เอง ห้ามสู้กับมัน (เป็นต้นเหตุกระตุก/เมาส์เลื่อนเอง)
    local function rmbDown()
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end
    local cursorGui, cursorImg, modalGui, modalBtn, stepConn

    -- ตอนนี้เป็นมุมมองบุคคลที่ 1 ไหม (กล้องอยู่ติดหัว หรือเกมบังคับ first person)
    local function isFirstPerson()
        local cam = workspace.CurrentCamera
        local head = localPlayer.Character and localPlayer.Character:FindFirstChild("Head")
        if cam and head and (cam.CFrame.Position - head.Position).Magnitude < 1.5 then return true end
        local ok, mode = pcall(function() return localPlayer.CameraMode end)
        return ok and mode == Enum.CameraMode.LockFirstPerson
    end

    local function makeCursor()
        if cursorGui and cursorGui.Parent then return end
        cursorGui = Instance.new("ScreenGui")
        cursorGui.Name = "BCX_FakeCursor"
        cursorGui.ResetOnSpawn = false
        cursorGui.IgnoreGuiInset = true
        cursorGui.DisplayOrder = 2147483647
        cursorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() cursorGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
        if not cursorGui.Parent then cursorGui.Parent = p:WaitForChild("PlayerGui") end
        J.obj(cursorGui)

        cursorImg = Instance.new("ImageLabel")
        cursorImg.BackgroundTransparency = 1
        cursorImg.Size = UDim2.fromOffset(64, 64)
        cursorImg.AnchorPoint = Vector2.new(0.5, 0.5)
        cursorImg.Image = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
        cursorImg.ZIndex = 10
        cursorImg.Parent = cursorGui

        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(10, 10)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.fromScale(0.5, 0.5)
        dot.BackgroundColor3 = Color3.new(1, 1, 1)
        dot.Visible = false
        dot.ZIndex = 11
        dot.Parent = cursorImg
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local st = Instance.new("UIStroke", dot); st.Color = Color3.new(0, 0, 0); st.Thickness = 2
        task.delay(2, function()
            if cursorImg and cursorImg.Parent and not cursorImg.IsLoaded then dot.Visible = true end
        end)
    end

    -- ปุ่ม Modal: วิธีมาตรฐานที่ Roblox ใช้ปลดล็อกเมาส์ (ต้องอยู่ใน PlayerGui)
    local function makeModal()
        if modalGui and modalGui.Parent then return end
        modalGui = Instance.new("ScreenGui")
        modalGui.Name = "BCX_ModalFree"
        modalGui.ResetOnSpawn = false
        modalGui.Parent = p:WaitForChild("PlayerGui")
        J.obj(modalGui)
        modalBtn = Instance.new("TextButton")
        modalBtn.Size = UDim2.fromOffset(0, 0)
        modalBtn.BackgroundTransparency = 1
        modalBtn.Text = ""
        modalBtn.Modal = false
        modalBtn.Parent = modalGui
    end

    -- ซ่อนเมาส์/crosshair ของเกม (GUI ที่ชื่อมี cursor / crosshair / mouseicon)
    -- [v3.6.3] สแกนแบบแบ่งเฟรม (พัก task.wait ทุก 300 ตัว) กัน PlayerGui ใหญ่ๆ ค้างก้อนเดียวตอนเปิดเมนู
    local function hideGameCursors()
        local pg = p:FindFirstChild("PlayerGui")
        if not pg then return end
        local i = 0
        for _, d in ipairs(pg:GetDescendants()) do
            i = i + 1
            if i % 300 == 0 then
                task.wait()
                if not FM.on or BCX.dead then return end
            end
            if d:IsA("GuiObject") and d.Visible then
                local gui = d:FindFirstAncestorOfClass("ScreenGui")
                if not (gui and gui.Name:sub(1, 4) == "BCX_") then
                    local n = d.Name:lower()
                    if n:find("cursor", 1, true) or n:find("crosshair", 1, true) or n:find("mouseicon", 1, true) then
                        FM.hidden[d] = true
                        d.Visible = false
                    end
                end
            end
        end
    end

    local function restoreGameCursors()
        for d in pairs(FM.hidden) do
            if d and d.Parent then pcall(function() d.Visible = true end) end
        end
        FM.hidden = {}
    end

    local function force()
        -- [v3.6.3] เขียนค่าเฉพาะตอนไม่ตรง ไม่เขียนทับทุกเฟรม
        if not rmbDown() and UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        -- เช็คว่ามีสคริปต์อื่นซ่อน/ลบเมาส์ทับเราอยู่ไหม (ไอคอนปิด / ไอคอนโปร่งใส)
        -- ถ้าโดนทับติดต่อกันหลายเฟรม = กำลังสู้กัน → สลับไปใช้เมาส์ปลอม (เป็น GUI ไม่โดนไอคอนซ่อน) อัตโนมัติ
        FM.frame = (FM.frame or 0) + 1
        local heavy = (FM.frame % 6 == 0) -- งานหนักทำทุก 6 เฟรม กัน GC สะดุด
        if heavy and not (BCX.fmFake or FM.autoFake) then
            local clash = (UserInputService.MouseIconEnabled == false)
            pcall(function()
                if UserInputService.MouseIcon ~= "" then clash = true end
                if localPlayer:GetMouse().Icon ~= "" then clash = true end
            end)
            if clash then
                FM.conflicts = FM.conflicts + 1
                if FM.conflicts >= 3 then
                    FM.autoFake = true
                    pcall(function()
                        WindUI:Notify({
                            Title = BCX.msg("Free Mouse"),
                            Content = (BCX.Lang == "Thai") and "มีสคริปต์อื่นซ่อนเมาส์ → สลับไปใช้เมาส์ปลอมให้อัตโนมัติ"
                                or "Another script is hiding the mouse → switched to fake cursor automatically",
                            Duration = 3,
                        })
                    end)
                end
            else
                FM.conflicts = 0
            end
        end
        local fake = BCX.fmFake or FM.autoFake

        if UserInputService.MouseIconEnabled == fake then -- ต้องการค่า = not fake
            UserInputService.MouseIconEnabled = not fake
        end
        if fake then makeCursor() end
        if cursorGui and cursorGui.Enabled ~= fake then cursorGui.Enabled = fake end
        if not fake and heavy then
            pcall(function()
                if UserInputService.MouseIcon ~= "" then UserInputService.MouseIcon = "" end
                local m = localPlayer:GetMouse()
                if m.Icon ~= "" then m.Icon = "" end
            end)
        end
        for d in pairs(FM.hidden) do
            if d.Parent and d.Visible then d.Visible = false end
        end
        if cursorImg and fake then
            local m = UserInputService:GetMouseLocation()
            cursorImg.Position = UDim2.fromOffset(m.X, m.Y)
        end
    end

    local function resyncCamera()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local original = cam.CameraType
        -- เกมที่คุมกล้องเอง (Scriptable) ห้ามแตะ: ถ้าเปลี่ยนเป็น Custom กล้อง/ล็อกเมาส์ของเกมจะพัง
        if original == Enum.CameraType.Scriptable then return end
        pcall(function() cam.CameraType = Enum.CameraType.Scriptable end)
        task.wait()
        pcall(function() cam.CameraType = original end)
    end

    -- silent = true: ไม่แจ้งเตือน (ใช้ตอน reload/ทำลาย UI)
    local function setFree(state, silent)
        if state == FM.on then return end
        FM.on = state
        if state then
            -- จำค่าเมาส์เดิมของเกมไว้ก่อนแตะอะไร (เช่น LockCenter ตอนเป็นมุมมองบุคคลที่ 1/ชิฟต์ล็อก)
            local cur = UserInputService.MouseBehavior
            if cur == Enum.MouseBehavior.LockCurrentPosition then cur = Enum.MouseBehavior.Default end
            FM.prevBehavior = FM.lastBehavior or cur
            if FM.lastIcon ~= nil then FM.prevIcon = FM.lastIcon else FM.prevIcon = UserInputService.MouseIconEnabled end
            FM.prevFirst = isFirstPerson()
            FM.autoFake = false; FM.conflicts = 0
            pcall(function() FM.prevUISIcon = UserInputService.MouseIcon end)
            makeModal()
            if BCX.fmFake then makeCursor() end
            if cursorGui then cursorGui.Enabled = BCX.fmFake end
            pcall(function()
                local m = localPlayer:GetMouse()
                FM.prevMouseIcon = m.Icon
                if not BCX.fmFake then m.Icon = "" end -- เกมบางเกมตั้งไอคอนโปร่งใส → คืนเป็นเมาส์ปกติ
            end)
            if modalBtn then modalBtn.Modal = true end
            task.spawn(hideGameCursors) -- [v3.6.3] สแกนแบบแบ่งเฟรม ไม่บล็อกตอนเปิดเมนู
            RunService:BindToRenderStep("BCX_FreeMouse", Enum.RenderPriority.Last.Value, force)
            stepConn = RunService.Stepped:Connect(function()
                -- [v3.6.3] เขียนเฉพาะตอนค่าไม่ตรง
                if not rmbDown() and UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end
            end)
            force()
        else
            pcall(function() RunService:UnbindFromRenderStep("BCX_FreeMouse") end)
            if stepConn then stepConn:Disconnect(); stepConn = nil end
            if modalBtn then modalBtn.Modal = false end
            if cursorGui then cursorGui.Enabled = false end
            restoreGameCursors()
            pcall(function() localPlayer:GetMouse().Icon = FM.prevMouseIcon or "" end)
            pcall(function() UserInputService.MouseIcon = FM.prevUISIcon or "" end)
            -- คืนค่าเมาส์เดิมของเกม และย้ำอีกช่วงสั้นๆ กันสคริปต์เกม/Modal ทับค่าเรา
            -- คืนเฉพาะค่าที่ "เกมใช้จริง" ที่จำไว้ตอนยังไม่ได้เปิดเมาส์อิสระ
            local wantBehavior = FM.prevBehavior or Enum.MouseBehavior.Default
            if wantBehavior == Enum.MouseBehavior.LockCurrentPosition then
                wantBehavior = Enum.MouseBehavior.Default
            end
            -- [แก้บั๊กเมาส์ค้างกลางจอ] LockCenter คืนเฉพาะตอนเป็นบุคคลที่ 1 เท่านั้น
            -- มุมมองบุคคลที่ 3 ให้ใช้ Default (ถ้าชิปล็อกเปิดอยู่จริง กล้องของเกมจะล็อกเองหลัง resyncCamera)
            -- กันค่าเก่าที่จำไว้ตอนยังเปิดชิปล็อกแล้วมาปิดระหว่างที่เมนูเปิดอยู่
            local hum0 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if wantBehavior == Enum.MouseBehavior.LockCenter and not isFirstPerson()
                and hum0 and hum0.AutoRotate == true then
                wantBehavior = Enum.MouseBehavior.Default
            end
            FM.restoreUntil = os.clock() + 1.2
            FM.unstickUntil = os.clock() + 3
            local wantIcon = FM.prevIcon
            if wantIcon == nil then wantIcon = true end
            UserInputService.MouseBehavior = wantBehavior
            UserInputService.MouseIconEnabled = wantIcon
            task.spawn(function()
                resyncCamera()
                local t0 = os.clock()
                while not FM.on and not BCX.dead and os.clock() - t0 < 1.2 do
                    if not rmbDown() then UserInputService.MouseBehavior = wantBehavior end
                    UserInputService.MouseIconEnabled = wantIcon
                    RunService.RenderStepped:Wait()
                end
            end)
        end
        if not silent then
            pcall(function()
                WindUI:Notify({
                    Title = BCX.msg("Free Mouse"),
                    Content = BCX.msg(state and "ON — free mouse" or "OFF — back to normal"),
                    Duration = 2,
                })
            end)
        end
    end
    BCX.setFree = setFree

    -- ==================== EMERGENCY RESET (ปุ่มฉุกเฉิน) ====================
    -- กด 1 ครั้ง = ปิดทุกฟังก์ชัน + คืนเมาส์/กล้อง/ไอคอนทั้งหมด (สคริปต์ยังอยู่)
    -- กด 2 ครั้งติดกันภายใน 1 วิ = ลบสคริปต์ทิ้งทั้งหมด (Unload)
    BCX.forceLock = false -- ล็อกเมาส์กลางจอเอง (ใช้ตอนเกมเป็นบุคคลที่ 1 แล้วเมาส์หลุด)

    local function hardRestoreMouse()
        pcall(function() RunService:UnbindFromRenderStep("BCX_FreeMouse") end)
        if stepConn then stepConn:Disconnect(); stepConn = nil end
        if modalBtn then modalBtn.Modal = false end
        if cursorGui then cursorGui.Enabled = false end
        pcall(restoreGameCursors)
        FM.on = false
        pcall(function() localPlayer:GetMouse().Icon = "" end)
        pcall(function() UserInputService.MouseIcon = "" end)
        local want = Enum.MouseBehavior.Default
        if BCX.forceLock or isFirstPerson() then want = Enum.MouseBehavior.LockCenter end
        FM.restoreUntil = os.clock() + 1.5
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = want
        task.spawn(function()
            resyncCamera()
            local t0 = os.clock()
            while not FM.on and not BCX.dead and os.clock() - t0 < 1 do
                if not rmbDown() then UserInputService.MouseBehavior = want end
                UserInputService.MouseIconEnabled = true
                RunService.RenderStepped:Wait()
            end
        end)
    end

    function BCX.panic()
        BCX.autoFM = false
        pcall(function() if BCX.UI["Auto Free Mouse"] and BCX.UI["Auto Free Mouse"].Set then BCX.UI["Auto Free Mouse"]:Set(false) end end)
        for name, fn in pairs(BCX.F) do
            if fn.get() then pcall(BCX.feat, name, false) end
        end
        pcall(BCX.flingStop)
        pcall(BCX.wpTweenStop)
        pcall(stopMirroring)
        pcall(stopCustomEmotes)
        if speedConnection then
            speedConnection:Disconnect(); speedConnection = nil
            local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = defaultSpeed end
        end
        hardRestoreMouse()
        pcall(function()
            WindUI:Notify({ Title = "BlackCrown-X",
                Content = (BCX.Lang == "Thai") and "รีเซ็ตฉุกเฉินแล้ว: ปิดทุกฟังก์ชัน + คืนเมาส์ (กดซ้ำเร็วๆ = ลบสคริปต์)"
                    or "Emergency reset done: all features off + mouse restored (press again quickly = unload)",
                Duration = 4 })
        end)
    end

    function BCX.unload()
        pcall(BCX.panic)
        task.delay(0.3, function() J.destroy() end)
    end

    local lastPanic = 0
    J.track(UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if BCX.keyIs("Emergency Reset Key", input) then
            local now = os.clock()
            if now - lastPanic < 1 then lastPanic = 0; BCX.unload(); return end
            lastPanic = now
            BCX.panic()
        elseif BCX.keyIs("Force Mouse Lock Key", input) and not UserInputService:GetFocusedTextBox() then
            BCX.forceLock = not BCX.forceLock
            if not BCX.forceLock and not FM.on then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
            pcall(function()
                WindUI:Notify({ Title = "BlackCrown-X",
                    Content = BCX.forceLock and "Force Mouse Lock: ON" or "Force Mouse Lock: OFF", Duration = 2 })
            end)
        end
    end))
    J.track(RunService.RenderStepped:Connect(function()
        if BCX.forceLock and not FM.on and not BCX.dead and not rmbDown() then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end))

    -- ==================== AUTO FREE MOUSE (ตาม UI เปิด/ปิด) ====================
    -- เช็คว่าหน้าต่าง UI เปิดอยู่ไหม (รองรับหลายเวอร์ชันของ WindUI)
    local function uiIsOpen()
        local ok, v = pcall(function()
            if Window.Closed ~= nil then return not Window.Closed end
            return Window.UIElements.Main.Visible
        end)
        if ok and v ~= nil then return v end
        return true
    end

    -- ทำงานเฉพาะตอนสถานะ UI "เปลี่ยน" (เปิด/ปิด) ไม่ได้บังคับตลอดเวลา
    -- ดังนั้นกด Y สลับเองระหว่างที่ UI เปิดอยู่ได้ตามปกติ
    local lastOpen = nil
    local function applyAuto(open)
        if BCX.dead or not BCX.autoFM then return end
        if open == lastOpen then return end
        lastOpen = open
        setFree(open, true) -- true = ไม่เด้งแจ้งเตือนทุกครั้งที่เปิด/ปิดเมนู
    end

    -- จำสถานะเมาส์ "ของเกมจริงๆ" ไว้ตลอดตอนที่ยังไม่ได้เปิดเมาส์อิสระ
    -- + กันค้าง: ถ้าเมาส์ติดล็อกผิดปกตินานเกิน 0.4 วิ ตอนเมาส์อิสระปิด ให้ปลดล็อกเอง
    do
        local b0 = UserInputService.MouseBehavior
        if b0 == Enum.MouseBehavior.LockCurrentPosition then b0 = Enum.MouseBehavior.Default end
        FM.lastBehavior = b0
        FM.lastIcon = UserInputService.MouseIconEnabled
        local stuckT = 0
        J.track(RunService.Heartbeat:Connect(function(dt)
            if BCX.dead or FM.on or os.clock() < FM.restoreUntil then stuckT = 0; return end
            local b = UserInputService.MouseBehavior
            -- [แก้บั๊กเมาส์ค้างกลางจอ] นอกจาก LockCurrentPosition แล้ว
            -- LockCenter ที่ไม่ใช่บุคคลที่ 1 และตัวละครยังหมุนตามกล้องปกติ (AutoRotate = true)
            -- = ไม่ใช่ชิปล็อกจริง (ชิปล็อกของ Roblox จะตั้ง AutoRotate = false) ถือว่าค้าง
            local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
            local inWin = os.clock() < (FM.unstickUntil or 0)
            local stuckLock =
                (b == Enum.MouseBehavior.LockCurrentPosition)
                or (inWin and b == Enum.MouseBehavior.LockCenter and not isFirstPerson()
                    and hum and hum.AutoRotate == true)
            if stuckLock then
                -- กำลังกดคลิกขวาลากกล้องอยู่ = ปกติ ไม่ใช่อาการค้าง
                if rmbDown() then stuckT = 0; return end
                stuckT = stuckT + dt
                if BCX.autoFM and stuckT > 0.4 then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    stuckT = 0
                    if b == Enum.MouseBehavior.LockCenter then FM.unstickUntil = 0 end -- ปลดครั้งเดียว ไม่สู้กับเกมซ้ำๆ
                end
            else
                stuckT = 0
                FM.lastBehavior = b
                FM.lastIcon = UserInputService.MouseIconEnabled
            end
        end))
    end

    -- ตัวหลัก: event ของ WindUI (ถ้าเวอร์ชันมี)
    pcall(function() Window:OnOpen(function() applyAuto(true) end) end)
    pcall(function() Window:OnClose(function() applyAuto(false) end) end)

    -- ตัวสำรอง: เช็คสถานะทุกเฟรม ทำงานเฉพาะตอนสถานะเปลี่ยน
    J.track(RunService.Heartbeat:Connect(function()
        if BCX.dead then return end
        if not BCX.autoFM then lastOpen = nil; return end
        applyAuto(uiIsOpen())
    end))

    -- อัปเดตตำแหน่งเมาส์ปลอมทันทีที่ขยับ (ไม่รอเฟรมถัดไป) ลดอาการกระตุก/หน่วง
    J.track(UserInputService.InputChanged:Connect(function(input)
        if FM.on and (BCX.fmFake or FM.autoFake) and cursorImg and input.UserInputType == Enum.UserInputType.MouseMovement then
            local m = UserInputService:GetMouseLocation()
            cursorImg.Position = UDim2.fromOffset(m.X, m.Y)
        end
    end))

    J.track(UserInputService.InputBegan:Connect(function(input)
        if not BCX.keyIs("Free Mouse", input) then return end
        if UserInputService:GetFocusedTextBox() then return end
        setFree(not FM.on)
    end))
end)

-- ==================== CLEANUP (ทำงานตอน reload / รันสคริปต์ซ้ำ) ====================
-- ปิดทุกฟังก์ชัน -> ล้าง ESP/Drawing -> ทำลายหน้าต่าง WindUI
-- (connection / GUI ที่ผ่าน J.track / J.obj จะถูกล้างต่อท้ายโดย J.destroy)
J.onClean(function()
    BCX.dead = true

    -- 1) ปิดสวิตช์ทั้งหมด
    aimbotEnabled = false; fovEnabled = false
    isTweeningRelative = false; safeModeEnabled = false; autoSaveEnabled = false
    exactMatchEnabled = false; partialMatchEnabled = false
    objSearchTick = objSearchTick + 1 -- ยกเลิกสแกนวัตถุที่ค้างอยู่
    isCopyingPlayerEmote = false; isPlayingCustomEmote = false
    if autoSaveThread then pcall(task.cancel, autoSaveThread); autoSaveThread = nil end

    -- 2) คืนสภาพระบบต่างๆ
    if BCX.setFree then pcall(BCX.setFree, false, true) end
    if dragActive then pcall(stopDrag, dragTargetName) end
    dragActive = false
    pcall(stopFly)
    if noclipEnabled then pcall(setNoclip, false) end
    if infiniteJumpEnabled then pcall(setInfiniteJump, false) end
    pcall(BCX.setAF, false)
    pcall(BCX.flingStop)
    pcall(BCX.flingCleanup)
    pcall(BCX.wpTweenStop)
    pcall(BCX.npcSet, false)
    pcall(stopMirroring)
    pcall(stopCustomEmotes)
    if speedConnection then
        speedConnection:Disconnect(); speedConnection = nil
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = defaultSpeed end
    end
    local hrp = getHRP()
    if hrp then pcall(removeBodyVelocity, hrp) end
    if tempPlatform then pcall(function() tempPlatform:Destroy() end); tempPlatform = nil end

    -- 2.5) หยุดลูปที่เหลือ + เก็บของตกค้างทั้งหมด
    BCX.ctpOn = false; BCX.ctpHold = false
    BCX.ctpSession = BCX.ctpSession + 1
    BCX.tweenSession = BCX.tweenSession + 1
    BCX.safeSession = BCX.safeSession + 1
    BCX.xhair.on = false
    if QuickButtonGui then pcall(function() QuickButtonGui:Destroy() end); QuickButtonGui = nil end
    QuickButtons = {}
    pcall(function()
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name == "ESP_Highlight" or d.Name == "ObjESP_Highlight" or d.Name == "BCX_NPC_Highlight"
            or d.Name == "TweenPlatform" or d.Name == "TweenBodyVelocity" or d.Name == "BCX_FlingBV" then
                pcall(function() d:Destroy() end)
            end
        end
    end)

    -- 3) ล้าง ESP / Drawing
    local plist = {}
    for plr in pairs(espObjects) do table.insert(plist, plr) end
    for _, plr in ipairs(plist) do pcall(removeESP, plr) end
    pcall(clearObjectESP)
    if fovCircle then pcall(function() fovCircle:Remove() end); fovCircle = nil end

    -- 4) ทำลายหน้าต่าง WindUI (+ ScreenGui ของมัน)
    local gui
    pcall(function() gui = Window.UIElements.Main:FindFirstAncestorOfClass("ScreenGui") end)
    pcall(function() Window:Destroy() end)
    pcall(function() WindUI:Destroy() end)
    task.wait(0.2)
    if gui and gui.Parent then pcall(function() gui:Destroy() end) end
end)

end -- launch

launch()
