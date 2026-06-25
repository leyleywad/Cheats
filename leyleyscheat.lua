--[[ 
    Leyley's Premium Cheat V6.6 - THE DEFINITIVE EDITION
    - Fix: Cash/sec Estimation (Sci-format limits fixed)
    - Fix: Global Audio Mute (Forces 0 volume on new sounds)
    - Add: Moon Dex Explorer Loadstring
    - Add: Custom Music Volume Control
    - Add: Save/Load Config System (JSON)
    - Architecture: Ultra-Aérée (1 instruction par ligne) + Scoped Limits
]]--

print("Leyley's Premium Cheat V6.6 loaded")

-------------------------------------------------------------------------------
-- 1. SERVICES GLOBAUX
-------------------------------------------------------------------------------
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-------------------------------------------------------------------------------
-- 2. DÉFINITION DES THÈMES
-------------------------------------------------------------------------------
local Themes = {
    Default = { 
        MainBg = Color3.fromRGB(20, 20, 25), 
        PanelBg = Color3.fromRGB(30, 30, 38), 
        Text = Color3.fromRGB(240, 240, 240), 
        Accent = Color3.fromRGB(90, 130, 255), 
        Success = Color3.fromRGB(60, 180, 90), 
        Danger = Color3.fromRGB(220, 70, 70), 
        Warning = Color3.fromRGB(220, 160, 50), 
        Stroke = Color3.fromRGB(60, 60, 75), 
        Group = "Color" 
    },
    Cyberpunk = { 
        MainBg = Color3.fromRGB(15, 10, 25), 
        PanelBg = Color3.fromRGB(25, 15, 40), 
        Text = Color3.fromRGB(255, 255, 0), 
        Accent = Color3.fromRGB(255, 0, 255), 
        Success = Color3.fromRGB(0, 255, 255), 
        Danger = Color3.fromRGB(255, 50, 50), 
        Warning = Color3.fromRGB(255, 150, 0), 
        Stroke = Color3.fromRGB(100, 0, 150), 
        Group = "Color" 
    },
    Ruby = { 
        MainBg = Color3.fromRGB(25, 10, 10), 
        PanelBg = Color3.fromRGB(40, 15, 15), 
        Text = Color3.fromRGB(255, 200, 200), 
        Accent = Color3.fromRGB(220, 50, 50), 
        Success = Color3.fromRGB(50, 200, 100), 
        Danger = Color3.fromRGB(180, 30, 30), 
        Warning = Color3.fromRGB(200, 100, 30), 
        Stroke = Color3.fromRGB(150, 40, 40), 
        Group = "Color" 
    },
    Synthwave = { 
        MainBg = Color3.fromRGB(30, 15, 45), 
        PanelBg = Color3.fromRGB(45, 25, 70), 
        Text = Color3.fromRGB(255, 150, 220), 
        Accent = Color3.fromRGB(0, 255, 255), 
        Success = Color3.fromRGB(50, 255, 150), 
        Danger = Color3.fromRGB(255, 50, 100), 
        Warning = Color3.fromRGB(255, 180, 0), 
        Stroke = Color3.fromRGB(150, 0, 150), 
        Group = "Color" 
    },
    Matrix = { 
        MainBg = Color3.fromRGB(10, 15, 10), 
        PanelBg = Color3.fromRGB(15, 25, 15), 
        Text = Color3.fromRGB(100, 255, 100), 
        Accent = Color3.fromRGB(50, 200, 50), 
        Success = Color3.fromRGB(0, 255, 0), 
        Danger = Color3.fromRGB(200, 50, 50), 
        Warning = Color3.fromRGB(200, 200, 50), 
        Stroke = Color3.fromRGB(30, 100, 30), 
        Group = "Color" 
    },
    RoyalGold = { 
        MainBg = Color3.fromRGB(25, 20, 10), 
        PanelBg = Color3.fromRGB(40, 35, 15), 
        Text = Color3.fromRGB(255, 240, 180), 
        Accent = Color3.fromRGB(160, 110, 30), 
        Success = Color3.fromRGB(100, 255, 100), 
        Danger = Color3.fromRGB(255, 80, 80), 
        Warning = Color3.fromRGB(255, 150, 50), 
        Stroke = Color3.fromRGB(150, 120, 40), 
        Group = "Color" 
    },
    Amethyst = { 
        MainBg = Color3.fromRGB(20, 10, 30), 
        PanelBg = Color3.fromRGB(35, 15, 50), 
        Text = Color3.fromRGB(230, 200, 255), 
        Accent = Color3.fromRGB(150, 80, 255), 
        Success = Color3.fromRGB(80, 255, 180), 
        Danger = Color3.fromRGB(255, 70, 120), 
        Warning = Color3.fromRGB(255, 170, 50), 
        Stroke = Color3.fromRGB(100, 40, 150), 
        Group = "Color" 
    },
    Mario = { 
        MainBg = Color3.fromRGB(20, 120, 255), 
        PanelBg = Color3.fromRGB(220, 40, 40), 
        Text = Color3.fromRGB(255, 255, 255), 
        Accent = Color3.fromRGB(255, 210, 0), 
        Success = Color3.fromRGB(50, 200, 50), 
        Danger = Color3.fromRGB(150, 0, 0), 
        Warning = Color3.fromRGB(255, 150, 0), 
        Stroke = Color3.fromRGB(0, 50, 150), 
        Group = "Game" 
    },
    Fallout = { 
        MainBg = Color3.fromRGB(15, 20, 15), 
        PanelBg = Color3.fromRGB(25, 35, 25), 
        Text = Color3.fromRGB(100, 255, 100), 
        Accent = Color3.fromRGB(30, 90, 30), 
        Success = Color3.fromRGB(0, 200, 0), 
        Danger = Color3.fromRGB(200, 50, 50), 
        Warning = Color3.fromRGB(200, 200, 50), 
        Stroke = Color3.fromRGB(30, 150, 30), 
        Group = "Game" 
    },
    CP2077 = { 
        MainBg = Color3.fromRGB(250, 230, 50), 
        PanelBg = Color3.fromRGB(20, 20, 20), 
        Text = Color3.fromRGB(0, 255, 255), 
        Accent = Color3.fromRGB(255, 0, 60), 
        Success = Color3.fromRGB(0, 255, 150), 
        Danger = Color3.fromRGB(200, 0, 0), 
        Warning = Color3.fromRGB(255, 100, 0), 
        Stroke = Color3.fromRGB(20, 20, 20), 
        Group = "Game" 
    }
}

-------------------------------------------------------------------------------
-- 3. GESTIONNAIRE D'ÉTATS (MANAGER)
-------------------------------------------------------------------------------
local SolaraManager = {
    GuiName = "LeyleysCheat_V6_6",
    CurrentTheme = Themes.Default,
    CurrentThemeName = "Default",
    ActiveTab = "Player",
    
    ThemeObjects = { 
        Backgrounds = {}, 
        Panels = {}, 
        Accents = {}, 
        Strokes = {}, 
        Texts = {}, 
        Dividers = {} 
    },
    
    UI = {
        FarmStatusLbl = nil,
        TycoonStatusLbl = nil,
        CashStatusLbl = nil,
        CashRateLbl = nil,
        MusicStatusLbl = nil,
        MainFrameStroke = nil,
        TabButtons = {},
        Pages = {}
    },
    
    IsClicking = false, 
    IsAntiAfk = false, 
    SpeedOverride = nil, 
    JumpOverride = nil, 
    SelectedTarget = nil,
    
    ActiveGameConfig = "SellLemons", 
    ActiveBuyState = "Off", 
    BuySpeed = 2, 
    MyTycoon = nil, 
    
    ActiveFarmState = "Off", 
    FarmSpeed = 2, 
    FarmCache = {}, 
    SpecialCount = 0, 
    LastCacheUpdate = 0,
    
    HasSafetyRespawned = false, 
    ClickDelay = 0.1,
    
    LastCashValue = 0,
    CashHistory = {},
    
    CustomMusicInstance = nil,
    CustomMusicName = "Unknown Audio",
    CustomMusicId = "",
    CustomMusicVolume = 100,
    MuteGameAudio = false,
    LastMuteCheck = 0,
    
    ConfigFilename = "LeyleysCheat_Config.json"
}

-------------------------------------------------------------------------------
-- 4. PARSER ET FORMATAGE DE PRIX
-------------------------------------------------------------------------------
local SuffixDict = {}

local function GenerateSuffixes()
    local order = { 
        "thousand", "million", "billion", "trillion", "quadrillion", 
        "quintillion", "sextillion", "septillion", "octillion", "nonillion" 
    }
    
    for i, name in ipairs(order) do 
        SuffixDict[name] = i
        local pluralName = name .. "s"
        SuffixDict[pluralName] = i 
    end
    
    local tensDict = { 
        ["decillion"] = 11, ["vigintillion"] = 21, ["trigintillion"] = 31, 
        ["quadragintillion"] = 41, ["quinquagintillion"] = 51, 
        ["sexagintillion"] = 61, ["septuagintillion"] = 71, 
        ["octogintillion"] = 81, ["nonagintillion"] = 91 
    }
    
    local unitsPrefix = { 
        ["un"] = 1, ["duo"] = 2, ["tre"] = 3, ["tres"] = 3, 
        ["quattuor"] = 4, ["quattuo"] = 4, ["quin"] = 5, ["quinqua"] = 5, 
        ["sex"] = 6, ["ses"] = 6, ["septen"] = 7, ["septem"] = 7, 
        ["sept"] = 7, ["octo"] = 8, ["novem"] = 9, ["noven"] = 9 
    }
    
    for tName, tVal in pairs(tensDict) do
        SuffixDict[tName] = tVal
        local tNamePlural = tName .. "s"
        SuffixDict[tNamePlural] = tVal
        
        for uName, uVal in pairs(unitsPrefix) do 
            local combinedName = uName .. tName
            local combinedVal = tVal + uVal
            SuffixDict[combinedName] = combinedVal
            
            local combinedNamePlural = combinedName .. "s"
            SuffixDict[combinedNamePlural] = combinedVal 
        end
    end
    
    SuffixDict["centillion"] = 101
    SuffixDict["centillions"] = 101
    SuffixDict["k"] = 1
    SuffixDict["m"] = 2
    SuffixDict["b"] = 3
    SuffixDict["t"] = 4
end

GenerateSuffixes()

local function ParsePrice(str)
    if not str then 
        return math.huge 
    end
    
    local lowerStr = string.lower(tostring(str))
    
    local isFree = string.match(lowerStr, "free")
    local isGratuit = string.match(lowerStr, "gratuit")
    
    if isFree then return 0 end
    if isGratuit then return 0 end
    
    local sciNum = tonumber(lowerStr)
    if sciNum then 
        return sciNum 
    end
    
    local cleanedStr = string.gsub(lowerStr, "[^%d%.%a]", "") 
    local numStr, suffix = string.match(cleanedStr, "^([%d%.]+)(%a*)$")
    
    if not numStr then 
        return math.huge 
    end
    
    local num = tonumber(numStr)
    if not num then 
        return math.huge 
    end
    
    if suffix then
        local isEmpty = (suffix == "")
        if not isEmpty then
            local powerIndex = SuffixDict[suffix]
            
            if powerIndex then 
                local power = powerIndex * 3
                local multiplier = 10 ^ power
                num = num * multiplier
            else 
                return math.huge 
            end
        end
    end
    
    return num
end

local function FormatNumber(num)
    local isTypeNum = (type(num) == "number")
    if not isTypeNum then return "0" end
    
    local isNaN = (num ~= num)
    if isNaN then return "0" end
    
    local isInf = (num == math.huge)
    if isInf then return "0" end
    
    if num < 1000 then 
        local floored = math.floor(num)
        local strNum = tostring(floored)
        return strNum 
    end
    
    local suffixes = {
        "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", 
        "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd"
    }
    
    local maxLimit = 10 ^ (#suffixes * 3)
    if num >= maxLimit then
        local sciFormat = string.format("%.2e", num)
        return sciFormat
    end
    
    local suffixIndex = 0
    local tempNum = num
    
    while tempNum >= 1000 do
        local maxSuffix = #suffixes
        if suffixIndex >= maxSuffix then break end
        
        tempNum = tempNum / 1000
        suffixIndex = suffixIndex + 1
    end
    
    local targetSuffix = suffixes[suffixIndex]
    local formattedStr = string.format("%.2f%s", tempNum, targetSuffix)
    return formattedStr
end

-------------------------------------------------------------------------------
-- 5. FONCTIONS DE CRÉATION D'INTERFACE
-------------------------------------------------------------------------------
do
    local existingGuiCore = CoreGui:FindFirstChild(SolaraManager.GuiName)
    if existingGuiCore then
        existingGuiCore:Destroy()
    else
        local playerGui = LocalPlayer:WaitForChild("PlayerGui")
        local existingGuiPlayer = playerGui:FindFirstChild(SolaraManager.GuiName)
        if existingGuiPlayer then
            existingGuiPlayer:Destroy()
        end
    end
end

local function ApplyTween(obj, properties, duration)
    local safeDuration = duration or 0.2
    local easingStyle = Enum.EasingStyle.Quad
    local easingDirection = Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(safeDuration, easingStyle, easingDirection)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    
    tween:Play()
    
    return tween
end

local function TrackTheme(object, themeCategory)
    if themeCategory then 
        local categoryTable = SolaraManager.ThemeObjects[themeCategory]
        table.insert(categoryTable, object) 
    end
end

local function CreateUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    
    local safeRadius = radius or 6
    local uDimRad = UDim.new(0, safeRadius)
    
    corner.CornerRadius = uDimRad
    corner.Parent = parent
    
    return corner
end

local function CreateUIStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    
    local safeColor = color or SolaraManager.CurrentTheme.Stroke
    local safeThickness = thickness or 1
    
    stroke.Color = safeColor
    stroke.Thickness = safeThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    
    TrackTheme(stroke, "Strokes")
    
    return stroke
end

local function CreateFrame(parent, name, size, pos, bgColor, themeGroup)
    local frame = Instance.new("Frame")
    
    frame.Name = name
    frame.Size = size
    frame.Position = pos
    
    local safeColor = bgColor or SolaraManager.CurrentTheme.MainBg
    frame.BackgroundColor3 = safeColor
    
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    TrackTheme(frame, themeGroup)
    
    return frame
end

local function CreateLabel(parent, name, text, size, pos, alignment)
    local label = Instance.new("TextLabel")
    
    label.Name = name
    label.Size = size
    label.Position = pos
    label.BackgroundTransparency = 1
    
    local txtColor = SolaraManager.CurrentTheme.Text
    label.TextColor3 = txtColor
    
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    
    local safeAlignment = alignment or Enum.TextXAlignment.Center
    label.TextXAlignment = safeAlignment
    
    label.TextWrapped = true
    label.Text = text
    label.Parent = parent
    
    TrackTheme(label, "Texts")
    
    return label
end

local function CreateButton(parent, name, text, size, pos, bgColor, themeGroup)
    local btn = Instance.new("TextButton")
    
    btn.Name = name
    btn.Size = size
    btn.Position = pos
    
    local safeBgColor = bgColor or SolaraManager.CurrentTheme.PanelBg
    btn.BackgroundColor3 = safeBgColor
    
    local txtColor = SolaraManager.CurrentTheme.Text
    btn.TextColor3 = txtColor
    
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = text
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    CreateUICorner(btn, 6)
    
    local strokeColor = SolaraManager.CurrentTheme.Stroke
    local stroke = CreateUIStroke(btn, strokeColor, 1)
    
    local safeThemeGroup = themeGroup or "Panels"
    TrackTheme(btn, safeThemeGroup)
    TrackTheme(btn, "Texts")
    
    btn.MouseEnter:Connect(function()
        local hoverProps = {}
        hoverProps.BackgroundTransparency = 0.1
        ApplyTween(btn, hoverProps, 0.2)
        
        local strokeProps = {}
        strokeProps.Color = SolaraManager.CurrentTheme.Text
        ApplyTween(stroke, strokeProps, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        local leaveProps = {}
        leaveProps.BackgroundTransparency = 0
        ApplyTween(btn, leaveProps, 0.2)
        
        local strokeProps = {}
        strokeProps.Color = SolaraManager.CurrentTheme.Stroke
        ApplyTween(stroke, strokeProps, 0.2)
    end)
    
    return btn
end

local function CreateInput(parent, name, placeholder, size, pos)
    local box = Instance.new("TextBox")
    
    box.Name = name
    box.Size = size
    box.Position = pos
    
    local pnlColor = SolaraManager.CurrentTheme.PanelBg
    box.BackgroundColor3 = pnlColor
    
    local txtColor = SolaraManager.CurrentTheme.Text
    box.TextColor3 = txtColor
    
    box.PlaceholderText = placeholder
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Text = ""
    box.Parent = parent
    
    CreateUICorner(box, 6)
    
    local strokeColor = SolaraManager.CurrentTheme.Stroke
    CreateUIStroke(box, strokeColor, 1)
    
    local padding = Instance.new("UIPadding")
    
    local pad10 = UDim.new(0, 10)
    padding.PaddingLeft = pad10
    padding.PaddingRight = pad10
    padding.Parent = box
    
    TrackTheme(box, "Panels")
    TrackTheme(box, "Texts")
    
    return box
end

local function EnableDragging(frame, dragHandle)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    dragHandle.InputBegan:Connect(function(input)
        local isMouse = (input.UserInputType == Enum.UserInputType.MouseButton1)
        local isTouch = (input.UserInputType == Enum.UserInputType.Touch)
        
        if isMouse or isTouch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                local isEnd = (input.UserInputState == Enum.UserInputState.End)
                if isEnd then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        local isMouseMove = (input.UserInputType == Enum.UserInputType.MouseMovement)
        local isTouchMove = (input.UserInputType == Enum.UserInputType.Touch)
        
        if isMouseMove or isTouchMove then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        local isSameInput = (input == dragInput)
        
        if isSameInput and dragging then
            local currentPos = input.Position
            local delta = currentPos - dragStart
            
            local newXScale = startPos.X.Scale
            local newXOffset = startPos.X.Offset + delta.X
            
            local newYScale = startPos.Y.Scale
            local newYOffset = startPos.Y.Offset + delta.Y
            
            local newPosition = UDim2.new(newXScale, newXOffset, newYScale, newYOffset)
            frame.Position = newPosition
        end
    end)
end

-------------------------------------------------------------------------------
-- 6. CONSTRUCTION DE LA FENÊTRE PRINCIPALE & ONGLETS
-------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SolaraManager.GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local isCoreGuiReady = pcall(function() return CoreGui.Name end)
if isCoreGuiReady then
    ScreenGui.Parent = CoreGui
else
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = playerGui
end

local RestoreBtn
local MainFrame
local ContentArea
local SidebarButtonsFrame

do
    local restoreSize = UDim2.new(0, 80, 0, 40)
    local restorePos = UDim2.new(0, 20, 1, -60)
    local restoreColor = SolaraManager.CurrentTheme.Accent
    
    RestoreBtn = CreateButton(ScreenGui, "RestoreBtn", "➕ Open", restoreSize, restorePos, restoreColor, "Accents")
    RestoreBtn.Visible = false
    RestoreBtn.ZIndex = 10
    
    local mainSize = UDim2.new(0, 650, 0, 420)
    local mainPos = UDim2.new(0.5, -325, 0.5, -210)
    local mainBg = SolaraManager.CurrentTheme.MainBg
    
    MainFrame = CreateFrame(ScreenGui, "MainFrame", mainSize, mainPos, mainBg, "Backgrounds")
    MainFrame.ClipsDescendants = true
    CreateUICorner(MainFrame, 8)
    
    local mainStrokeColor = SolaraManager.CurrentTheme.Accent
    local mainStroke = CreateUIStroke(MainFrame, mainStrokeColor, 2)
    SolaraManager.UI.MainFrameStroke = mainStroke
    
    local titleSize = UDim2.new(1, 0, 0, 40)
    local titlePos = UDim2.new(0, 0, 0, 0)
    local titleBg = SolaraManager.CurrentTheme.PanelBg
    
    local TitleBar = CreateFrame(MainFrame, "TitleBar", titleSize, titlePos, titleBg, "Panels")
    EnableDragging(MainFrame, TitleBar)
    
    local lblSize = UDim2.new(1, -100, 1, 0)
    local lblPos = UDim2.new(0, 0, 0, 0)
    local TitleLabel = CreateLabel(TitleBar, "TitleLabel", "  ✨ Leyley's Premium Cheat V6.6", lblSize, lblPos, Enum.TextXAlignment.Left)
    TitleLabel.Font = Enum.Font.GothamBold
    
    local closeSize = UDim2.new(0, 30, 0, 30)
    local closePos = UDim2.new(1, -35, 0, 5)
    local closeColor = SolaraManager.CurrentTheme.Danger
    local CloseBtn = CreateButton(TitleBar, "CloseBtn", "X", closeSize, closePos, closeColor, nil)
    
    local minSize = UDim2.new(0, 30, 0, 30)
    local minPos = UDim2.new(1, -70, 0, 5)
    local minColor = SolaraManager.CurrentTheme.Warning
    local MinBtn = CreateButton(TitleBar, "MinBtn", "-", minSize, minPos, minColor, nil)
    
    CloseBtn.MouseButton1Click:Connect(function() 
        ScreenGui:Destroy()
        SolaraManager.IsClicking = false 
    end)
    
    MinBtn.MouseButton1Click:Connect(function() 
        local minProps = {}
        minProps.Size = UDim2.new(0, 650, 0, 0)
        local t = ApplyTween(MainFrame, minProps, 0.3)
        t.Completed:Connect(function() 
            MainFrame.Visible = false
            RestoreBtn.Visible = true
            
            local resetSize = UDim2.new(0, 650, 0, 420)
            MainFrame.Size = resetSize 
        end) 
    end)
    
    RestoreBtn.MouseButton1Click:Connect(function() 
        RestoreBtn.Visible = false
        
        local startSize = UDim2.new(0, 650, 0, 0)
        MainFrame.Size = startSize
        MainFrame.Visible = true
        
        local endProps = {}
        endProps.Size = UDim2.new(0, 650, 0, 420)
        ApplyTween(MainFrame, endProps, 0.4) 
    end)
    
    local sideSize = UDim2.new(0, 150, 1, -40)
    local sidePos = UDim2.new(0, 0, 0, 40)
    local sideBg = SolaraManager.CurrentTheme.PanelBg
    local SidebarContainer = CreateFrame(MainFrame, "SidebarContainer", sideSize, sidePos, sideBg, "Panels")
    
    local lineSize = UDim2.new(0, 1, 1, 0)
    local linePos = UDim2.new(1, -1, 0, 0)
    local lineColor = SolaraManager.CurrentTheme.Stroke
    local SidebarLine = CreateFrame(SidebarContainer, "SidebarLine", lineSize, linePos, lineColor, "Dividers")
    
    SidebarButtonsFrame = Instance.new("Frame")
    SidebarButtonsFrame.Name = "SidebarButtons"
    
    local sbSize = UDim2.new(1, -1, 1, 0)
    SidebarButtonsFrame.Size = sbSize
    SidebarButtonsFrame.BackgroundTransparency = 1
    SidebarButtonsFrame.Parent = SidebarContainer
    
    local sbLayout = Instance.new("UIListLayout")
    sbLayout.Parent = SidebarButtonsFrame
    sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad5 = UDim.new(0, 5)
    sbLayout.Padding = pad5
    
    local sbPad = Instance.new("UIPadding")
    sbPad.Parent = SidebarButtonsFrame
    
    local pad10 = UDim.new(0, 10)
    sbPad.PaddingTop = pad10
    sbPad.PaddingBottom = pad10
    sbPad.PaddingLeft = pad10
    sbPad.PaddingRight = pad10
    
    local contSize = UDim2.new(1, -150, 1, -40)
    local contPos = UDim2.new(0, 150, 0, 40)
    local contBg = SolaraManager.CurrentTheme.MainBg
    ContentArea = CreateFrame(MainFrame, "ContentArea", contSize, contPos, contBg, "Backgrounds")
    
    local cPad = Instance.new("UIPadding")
    cPad.Parent = ContentArea
    
    local pad15 = UDim.new(0, 15)
    cPad.PaddingTop = pad15
    cPad.PaddingBottom = pad15
    cPad.PaddingLeft = pad15
    cPad.PaddingRight = pad15
end

local function SwitchTab(tabName)
    local pagesTbl = SolaraManager.UI.Pages
    local btnsTbl = SolaraManager.UI.TabButtons
    
    for name, page in pairs(pagesTbl) do 
        local isVis = (name == tabName)
        page.Visible = isVis
    end
    
    for name, btn in pairs(btnsTbl) do
        local isTarget = (name == tabName)
        local cColor
        
        if isTarget then
            cColor = SolaraManager.CurrentTheme.Accent
        else
            cColor = SolaraManager.CurrentTheme.PanelBg
        end
        
        local props = {}
        props.BackgroundColor3 = cColor
        ApplyTween(btn, props, 0.2)
    end
    
    SolaraManager.ActiveTab = tabName
end

local function BuildPage(name, icon, order)
    local btnName = name .. "Tab"
    local btnText = icon .. " " .. name
    local btnSize = UDim2.new(1, 0, 0, 35)
    local btnPos = UDim2.new()
    
    local btn = CreateButton(SidebarButtonsFrame, btnName, btnText, btnSize, btnPos, nil, "Panels")
    btn.LayoutOrder = order
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local btnPad = Instance.new("UIPadding", btn)
    local uD10 = UDim.new(0, 10)
    btnPad.PaddingLeft = uD10
    
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    
    local pSize = UDim2.new(1, 0, 1, 0)
    page.Size = pSize
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.Parent = ContentArea
    
    SolaraManager.UI.TabButtons[name] = btn
    SolaraManager.UI.Pages[name] = page
    
    btn.MouseButton1Click:Connect(function() 
        SwitchTab(name) 
    end)
    
    return page
end

-------------------------------------------------------------------------------
-- PAGE 1 : PLAYER
-------------------------------------------------------------------------------
do
    local PlayerPage = BuildPage("Player", "👤", 1)
    
    local pLayout = Instance.new("UIListLayout")
    pLayout.Parent = PlayerPage
    pLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad10 = UDim.new(0, 10)
    pLayout.Padding = pad10
    
    local titleSize = UDim2.new(1, 0, 0, 25)
    local titlePos = UDim2.new()
    local pTitle = CreateLabel(PlayerPage, "PlayerTitle", "PLAYER MODIFIERS", titleSize, titlePos, Enum.TextXAlignment.Left)
    pTitle.LayoutOrder = 1
    
    local cRowSize = UDim2.new(1, 0, 0, 40)
    local cRowPos = UDim2.new()
    local ClickRow = CreateFrame(PlayerPage, "ClickRow", cRowSize, cRowPos, nil, "Backgrounds")
    ClickRow.BackgroundTransparency = 1
    ClickRow.LayoutOrder = 2
    
    local cTogSize = UDim2.new(0.48, -2, 1, 0)
    local cTogPos = UDim2.new(0, 0, 0, 0)
    local cTogCol = SolaraManager.CurrentTheme.Danger
    local ClickToggle = CreateButton(ClickRow, "ClickToggle", "Auto Clicker: OFF", cTogSize, cTogPos, cTogCol)
    
    local aTogSize = UDim2.new(0.48, -2, 1, 0)
    local aTogPos = UDim2.new(0.52, 2, 0, 0)
    local aTogCol = SolaraManager.CurrentTheme.Danger
    local AfkToggle = CreateButton(ClickRow, "AfkToggle", "Anti-AFK: OFF", aTogSize, aTogPos, aTogCol)
    
    ClickToggle.MouseButton1Click:Connect(function() 
        local cState = SolaraManager.IsClicking
        local nState = not cState
        SolaraManager.IsClicking = nState
        
        local nText
        if nState then nText = "Auto Clicker: ON" else nText = "Auto Clicker: OFF" end
        ClickToggle.Text = nText
        
        local tCol
        if nState then tCol = SolaraManager.CurrentTheme.Success else tCol = SolaraManager.CurrentTheme.Danger end
        local p = {}
        p.BackgroundColor3 = tCol
        ApplyTween(ClickToggle, p) 
    end)
    
    AfkToggle.MouseButton1Click:Connect(function() 
        local cState = SolaraManager.IsAntiAfk
        local nState = not cState
        SolaraManager.IsAntiAfk = nState
        
        local nText
        if nState then nText = "Anti-AFK: ON" else nText = "Anti-AFK: OFF" end
        AfkToggle.Text = nText
        
        local tCol
        if nState then tCol = SolaraManager.CurrentTheme.Success else tCol = SolaraManager.CurrentTheme.Danger end
        local p = {}
        p.BackgroundColor3 = tCol
        ApplyTween(AfkToggle, p) 
    end)
    
    local sTitleSize = UDim2.new(1, 0, 0, 25)
    local sTitlePos = UDim2.new()
    local sTitle = CreateLabel(PlayerPage, "StatsTitle", "STAT OVERRIDES", sTitleSize, sTitlePos, Enum.TextXAlignment.Left)
    sTitle.LayoutOrder = 3
    
    local spRowSize = UDim2.new(1, 0, 0, 35)
    local spRowPos = UDim2.new()
    local SpeedRow = CreateFrame(PlayerPage, "SpeedRow", spRowSize, spRowPos, nil, "Backgrounds")
    SpeedRow.BackgroundTransparency = 1
    SpeedRow.LayoutOrder = 4
    
    local spInpSize = UDim2.new(0.65, -5, 1, 0)
    local spInpPos = UDim2.new(0, 0, 0, 0)
    local SpeedInput = CreateInput(SpeedRow, "SpeedInput", "WalkSpeed (e.g. 50)", spInpSize, spInpPos)
    
    local spBtnSize = UDim2.new(0.35, -5, 1, 0)
    local spBtnPos = UDim2.new(0.65, 5, 0, 0)
    local spBtnCol = SolaraManager.CurrentTheme.Accent
    local SpeedBtn = CreateButton(SpeedRow, "SpeedBtn", "Apply", spBtnSize, spBtnPos, spBtnCol)
    
    SpeedBtn.MouseButton1Click:Connect(function() 
        local rText = SpeedInput.Text
        local val = tonumber(rText)
        if val then 
            SolaraManager.SpeedOverride = val
            SpeedBtn.Text = "Applied" 
        else 
            SolaraManager.SpeedOverride = nil
            SpeedBtn.Text = "Reset" 
        end 
    end)
    
    local jRowSize = UDim2.new(1, 0, 0, 35)
    local jRowPos = UDim2.new()
    local JumpRow = CreateFrame(PlayerPage, "JumpRow", jRowSize, jRowPos, nil, "Backgrounds")
    JumpRow.BackgroundTransparency = 1
    JumpRow.LayoutOrder = 5
    
    local jInpSize = UDim2.new(0.65, -5, 1, 0)
    local jInpPos = UDim2.new(0, 0, 0, 0)
    local JumpInput = CreateInput(JumpRow, "JumpInput", "JumpPower (e.g. 100)", jInpSize, jInpPos)
    
    local jBtnSize = UDim2.new(0.35, -5, 1, 0)
    local jBtnPos = UDim2.new(0.65, 5, 0, 0)
    local jBtnCol = SolaraManager.CurrentTheme.Accent
    local JumpBtn = CreateButton(JumpRow, "JumpBtn", "Apply", jBtnSize, jBtnPos, jBtnCol)
    
    JumpBtn.MouseButton1Click:Connect(function() 
        local rText = JumpInput.Text
        local val = tonumber(rText)
        if val then 
            SolaraManager.JumpOverride = val
            JumpBtn.Text = "Applied" 
        else 
            SolaraManager.JumpOverride = nil
            JumpBtn.Text = "Reset" 
        end 
    end)
end

-------------------------------------------------------------------------------
-- PAGE 2 : TELEPORT
-------------------------------------------------------------------------------
do
    local TeleportPage = BuildPage("Teleport", "🌍", 2)
    
    local tLayout = Instance.new("UIListLayout")
    tLayout.Parent = TeleportPage
    tLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad10 = UDim.new(0, 10)
    tLayout.Padding = pad10
    
    local sLblSize = UDim2.new(1, 0, 0, 25)
    local sLblPos = UDim2.new()
    local SelectedLabel = CreateLabel(TeleportPage, "SelectedLabel", "Selected: None", sLblSize, sLblPos, Enum.TextXAlignment.Left)
    SelectedLabel.LayoutOrder = 1
    
    local tpBtnSize = UDim2.new(1, -4, 0, 40)
    local tpBtnPos = UDim2.new()
    local tpBtnCol = SolaraManager.CurrentTheme.Accent
    local TpBtn = CreateButton(TeleportPage, "TpBtn", "TELEPORT TO PLAYER", tpBtnSize, tpBtnPos, tpBtnCol)
    TpBtn.LayoutOrder = 2
    
    TpBtn.MouseButton1Click:Connect(function() 
        local target = SolaraManager.SelectedTarget
        if target then
            local tChar = target.Character
            if tChar then
                local lChar = LocalPlayer.Character
                if lChar then
                    local pivot = tChar:GetPivot()
                    lChar:PivotTo(pivot)
                end
            end
        end 
    end)
    
    local pLFSize = UDim2.new(1, -4, 1, -85)
    local pLFPos = UDim2.new()
    local pLFBg = SolaraManager.CurrentTheme.PanelBg
    local PlayerListFrame = CreateFrame(TeleportPage, "PlayerListFrame", pLFSize, pLFPos, pLFBg, "Panels")
    PlayerListFrame.LayoutOrder = 3
    CreateUICorner(PlayerListFrame, 6)
    
    local strCol = SolaraManager.CurrentTheme.Stroke
    CreateUIStroke(PlayerListFrame, strCol, 1)
    
    local PList = Instance.new("ScrollingFrame")
    local plSize = UDim2.new(1, -10, 1, -10)
    PList.Size = plSize
    
    local plPos = UDim2.new(0, 5, 0, 5)
    PList.Position = plPos
    PList.BackgroundTransparency = 1
    PList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PList.ScrollBarThickness = 4
    PList.Parent = PlayerListFrame
    
    local plLayout = Instance.new("UIListLayout")
    plLayout.Parent = PList
    
    local pad5 = UDim.new(0, 5)
    plLayout.Padding = pad5
    
    local function UpdatePlayers()
        local children = PList:GetChildren()
        for _, child in ipairs(children) do 
            local isBtn = child:IsA("TextButton")
            if isBtn then child:Destroy() end 
        end
        
        local allP = Players:GetPlayers()
        table.sort(allP, function(a, b) 
            local nA = a.Name:lower()
            local nB = b.Name:lower()
            return nA < nB 
        end)
        
        for _, pObj in ipairs(allP) do
            local isNotMe = (pObj ~= LocalPlayer)
            if isNotMe then
                local bSize = UDim2.new(1, -5, 0, 30)
                local bPos = UDim2.new()
                local bBg = SolaraManager.CurrentTheme.MainBg
                local btn = CreateButton(PList, "PBtn", pObj.Name, bSize, bPos, bBg, "Backgrounds")
                
                btn.MouseButton1Click:Connect(function() 
                    SolaraManager.SelectedTarget = pObj
                    local sText = "Selected: " .. pObj.Name
                    SelectedLabel.Text = sText 
                end)
            end
        end
    end
    
    Players.PlayerAdded:Connect(UpdatePlayers)
    Players.PlayerRemoving:Connect(UpdatePlayers)
    UpdatePlayers()
end

-------------------------------------------------------------------------------
-- PAGE 3 : EXPLORER
-------------------------------------------------------------------------------
do
    local ExplorerPage = BuildPage("Explorer", "🔍", 3)
    
    local eLayout = Instance.new("UIListLayout")
    eLayout.Parent = ExplorerPage
    eLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad10 = UDim.new(0, 10)
    eLayout.Padding = pad10
    
    local dDescSize = UDim2.new(1, 0, 0, 40)
    local dDescPos = UDim2.new()
    local dText = "Load Moon Dex Explorer to view the game's file structure. Bypasses most anti-cheats."
    local DexDesc = CreateLabel(ExplorerPage, "DexDesc", dText, dDescSize, dDescPos, Enum.TextXAlignment.Left)
    DexDesc.LayoutOrder = 1
    
    local dBtnSize = UDim2.new(1, -4, 0, 50)
    local dBtnPos = UDim2.new()
    local dBtnCol = Color3.fromRGB(130, 50, 200)
    local DexBtn = CreateButton(ExplorerPage, "DexBtn", "Launch Moon Dex", dBtnSize, dBtnPos, dBtnCol)
    DexBtn.LayoutOrder = 2
    
    DexBtn.MouseButton1Click:Connect(function()
        DexBtn.Text = "Loading Moon Dex..."
        
        task.spawn(function()
            local function exec()
                local url = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"
                local code = game:HttpGet(url)
                local func = loadstring(code)
                func()
            end
            
            local s, e = pcall(exec)
            
            if s then 
                DexBtn.Text = "Moon Dex Launched!"
                local p = {}
                p.BackgroundColor3 = SolaraManager.CurrentTheme.Success
                ApplyTween(DexBtn, p)
            else 
                DexBtn.Text = "Failed to load!"
                local p = {}
                p.BackgroundColor3 = SolaraManager.CurrentTheme.Danger
                ApplyTween(DexBtn, p) 
            end
            
            task.wait(2)
            
            DexBtn.Text = "Launch Moon Dex"
            local p2 = {}
            p2.BackgroundColor3 = dBtnCol
            ApplyTween(DexBtn, p2)
        end)
    end)
end

-------------------------------------------------------------------------------
-- PAGE 4 : GAME (FARM & BUY)
-------------------------------------------------------------------------------
do
    local GamePage = BuildPage("Game", "🎮", 4)
    
    local GameContainer = Instance.new("Frame")
    local gcSize = UDim2.new(1, 0, 1, 0)
    GameContainer.Size = gcSize
    GameContainer.BackgroundTransparency = 1
    GameContainer.Parent = GamePage
    
    local gsSize = UDim2.new(0.35, 0, 1, 0)
    local gsPos = UDim2.new(0, 0, 0, 0)
    local gsBg = SolaraManager.CurrentTheme.PanelBg
    local GameSelector = CreateFrame(GameContainer, "GameSelector", gsSize, gsPos, gsBg, "Panels")
    
    CreateUICorner(GameSelector, 6)
    local strCol = SolaraManager.CurrentTheme.Stroke
    CreateUIStroke(GameSelector, strCol, 1)
    
    local slLayout = Instance.new("UIListLayout")
    slLayout.Parent = GameSelector
    local pad5 = UDim.new(0, 5)
    slLayout.Padding = pad5
    
    local slPad = Instance.new("UIPadding")
    slPad.Parent = GameSelector
    slPad.PaddingTop = pad5
    slPad.PaddingLeft = pad5
    slPad.PaddingRight = pad5
    
    local GameContentFrame = Instance.new("Frame")
    local gcfSize = UDim2.new(0.65, -10, 1, 0)
    GameContentFrame.Size = gcfSize
    
    local gcfPos = UDim2.new(0.35, 10, 0, 0)
    GameContentFrame.Position = gcfPos
    GameContentFrame.BackgroundTransparency = 1
    GameContentFrame.Parent = GameContainer
    
    local SellLemonsScroll = Instance.new("ScrollingFrame")
    local slsSize = UDim2.new(1, 0, 1, 0)
    SellLemonsScroll.Size = slsSize
    SellLemonsScroll.BackgroundTransparency = 1
    SellLemonsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SellLemonsScroll.ScrollBarThickness = 4
    SellLemonsScroll.Parent = GameContentFrame
    
    local lemLayout = Instance.new("UIListLayout")
    lemLayout.Parent = SellLemonsScroll
    local pad8 = UDim.new(0, 8)
    lemLayout.Padding = pad8
    lemLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- ECO STATS
    local cTitleSize = UDim2.new(1, 0, 0, 20)
    local cTitlePos = UDim2.new()
    local CashTitle = CreateLabel(SellLemonsScroll, "CashTitle", "💰 ECONOMY STATS", cTitleSize, cTitlePos, Enum.TextXAlignment.Left)
    CashTitle.LayoutOrder = 1
    
    local cStatSize = UDim2.new(1, 0, 0, 15)
    local cStatPos = UDim2.new()
    local CashStatusLbl = CreateLabel(SellLemonsScroll, "CashStatus", "Cash: $0", cStatSize, cStatPos, Enum.TextXAlignment.Left)
    CashStatusLbl.TextSize = 12
    
    local sucCol = SolaraManager.CurrentTheme.Success
    CashStatusLbl.TextColor3 = sucCol
    CashStatusLbl.LayoutOrder = 2
    SolaraManager.UI.CashStatusLbl = CashStatusLbl
    
    local cRateSize = UDim2.new(1, 0, 0, 15)
    local cRatePos = UDim2.new()
    local CashRateLbl = CreateLabel(SellLemonsScroll, "CashRate", "Est: $0/sec | $0/hr", cRateSize, cRatePos, Enum.TextXAlignment.Left)
    CashRateLbl.TextSize = 11
    
    local grayCol = Color3.fromRGB(150, 150, 150)
    CashRateLbl.TextColor3 = grayCol
    CashRateLbl.LayoutOrder = 3
    SolaraManager.UI.CashRateLbl = CashRateLbl
    
    local d0Size = UDim2.new(1, -10, 0, 2)
    local d0Pos = UDim2.new()
    local d0Col = SolaraManager.CurrentTheme.Stroke
    local div0 = CreateFrame(SellLemonsScroll, "Div0", d0Size, d0Pos, d0Col, "Dividers")
    div0.LayoutOrder = 4
    
    -- FARM
    local fTitleSize = UDim2.new(1, 0, 0, 20)
    local fTitlePos = UDim2.new()
    local FarmTitle = CreateLabel(SellLemonsScroll, "FarmTitle", "🍋 AUTO FARM", fTitleSize, fTitlePos, Enum.TextXAlignment.Left)
    FarmTitle.LayoutOrder = 5
    
    local fStatSize = UDim2.new(1, 0, 0, 15)
    local fStatPos = UDim2.new()
    local FarmStatusLbl = CreateLabel(SellLemonsScroll, "FarmStatus", "Status: Idle", fStatSize, fStatPos, Enum.TextXAlignment.Left)
    FarmStatusLbl.TextSize = 12
    FarmStatusLbl.LayoutOrder = 6
    SolaraManager.UI.FarmStatusLbl = FarmStatusLbl
    
    local FarmSpeedRow = Instance.new("Frame")
    local fsrSize = UDim2.new(1, 0, 0, 30)
    FarmSpeedRow.Size = fsrSize
    FarmSpeedRow.BackgroundTransparency = 1
    FarmSpeedRow.LayoutOrder = 7
    FarmSpeedRow.Parent = SellLemonsScroll
    
    local fsInpSize = UDim2.new(0.6, -5, 1, 0)
    local fsInpPos = UDim2.new()
    local FarmSpeedInput = CreateInput(FarmSpeedRow, "FarmSpeed", "Speed (1-4)", fsInpSize, fsInpPos)
    
    local fsBtnSize = UDim2.new(0.4, -5, 1, 0)
    local fsBtnPos = UDim2.new(0.6, 5, 0, 0)
    local fsBtnCol = SolaraManager.CurrentTheme.Accent
    local FarmSpeedBtn = CreateButton(FarmSpeedRow, "FarmSet", "Set", fsBtnSize, fsBtnPos, fsBtnCol)
    
    local FarmActionRow = Instance.new("Frame")
    local farSize = UDim2.new(1, 0, 0, 35)
    FarmActionRow.Size = farSize
    FarmActionRow.BackgroundTransparency = 1
    FarmActionRow.LayoutOrder = 8
    FarmActionRow.Parent = SellLemonsScroll
    
    local fBSize = UDim2.new(0.5, -5, 1, 0)
    local fBPos = UDim2.new()
    local fBCol = SolaraManager.CurrentTheme.Danger
    local FarmBtn = CreateButton(FarmActionRow, "FarmBtn", "Normal Farm", fBSize, fBPos, fBCol)
    
    local sfBSize = UDim2.new(0.5, -5, 1, 0)
    local sfBPos = UDim2.new(0.5, 5, 0, 0)
    local sfBCol = SolaraManager.CurrentTheme.Danger
    local SafeFarmBtn = CreateButton(FarmActionRow, "SafeFarmBtn", "Safe Farm", sfBSize, sfBPos, sfBCol)
    
    local d1Size = UDim2.new(1, -10, 0, 2)
    local d1Pos = UDim2.new()
    local d1Col = SolaraManager.CurrentTheme.Stroke
    local div1 = CreateFrame(SellLemonsScroll, "Div1", d1Size, d1Pos, d1Col, "Dividers")
    div1.LayoutOrder = 9
    
    -- BUY
    local tTitleSize = UDim2.new(1, 0, 0, 20)
    local tTitlePos = UDim2.new()
    local TycoonTitle = CreateLabel(SellLemonsScroll, "TycoonTitle", "🏭 TYCOON BUY", tTitleSize, tTitlePos, Enum.TextXAlignment.Left)
    TycoonTitle.LayoutOrder = 10
    
    local tStatSize = UDim2.new(1, 0, 0, 15)
    local tStatPos = UDim2.new()
    local TycoonStatusLbl = CreateLabel(SellLemonsScroll, "TycoonStatus", "Status: Idle", tStatSize, tStatPos, Enum.TextXAlignment.Left)
    TycoonStatusLbl.TextSize = 12
    TycoonStatusLbl.LayoutOrder = 11
    SolaraManager.UI.TycoonStatusLbl = TycoonStatusLbl
    
    local BuySpeedRow = Instance.new("Frame")
    local bsRowSize = UDim2.new(1, 0, 0, 30)
    BuySpeedRow.Size = bsRowSize
    BuySpeedRow.BackgroundTransparency = 1
    BuySpeedRow.LayoutOrder = 12
    BuySpeedRow.Parent = SellLemonsScroll
    
    local bsInpSize = UDim2.new(0.6, -5, 1, 0)
    local bsInpPos = UDim2.new()
    local BuySpeedInput = CreateInput(BuySpeedRow, "BuySpeed", "Speed (1-10)", bsInpSize, bsInpPos)
    
    local bsBtnSize = UDim2.new(0.4, -5, 1, 0)
    local bsBtnPos = UDim2.new(0.6, 5, 0, 0)
    local bsBtnCol = SolaraManager.CurrentTheme.Accent
    local BuySpeedBtn = CreateButton(BuySpeedRow, "BuySet", "Set", bsBtnSize, bsBtnPos, bsBtnCol)
    
    local BuyActionRow = Instance.new("Frame")
    local baRowSize = UDim2.new(1, 0, 0, 35)
    BuyActionRow.Size = baRowSize
    BuyActionRow.BackgroundTransparency = 1
    BuyActionRow.LayoutOrder = 13
    BuyActionRow.Parent = SellLemonsScroll
    
    local abBtnSize = UDim2.new(0.5, -5, 1, 0)
    local abBtnPos = UDim2.new()
    local abBtnCol = SolaraManager.CurrentTheme.Danger
    local AutoBuyBtn = CreateButton(BuyActionRow, "AutoBuyBtn", "Auto Buy", abBtnSize, abBtnPos, abBtnCol)
    
    local sbBtnSize = UDim2.new(0.5, -5, 1, 0)
    local sbBtnPos = UDim2.new(0.5, 5, 0, 0)
    local sbBtnCol = SolaraManager.CurrentTheme.Danger
    local SafeBuyBtn = CreateButton(BuyActionRow, "SafeBuyBtn", "Safe Buy", sbBtnSize, sbBtnPos, sbBtnCol)
    
    -- COMING SOON
    local ComingSoonFrame = Instance.new("Frame")
    local csfSize = UDim2.new(1, 0, 1, 0)
    ComingSoonFrame.Size = csfSize
    ComingSoonFrame.BackgroundTransparency = 1
    ComingSoonFrame.Visible = false
    ComingSoonFrame.Parent = GameContentFrame
    
    local csTSize = UDim2.new(1, 0, 0, 30)
    local csTPos = UDim2.new(0, 0, 0.3, 0)
    local CS_Title = CreateLabel(ComingSoonFrame, "CS_Title", "🚧 COMING SOON", csTSize, csTPos, Enum.TextXAlignment.Center)
    
    local csdSize = UDim2.new(1, 0, 0, 30)
    local csdPos = UDim2.new(0, 0, 0.4, 0)
    local CS_Desc = CreateLabel(ComingSoonFrame, "CS_Desc", "New games will be added here.", csdSize, csdPos, Enum.TextXAlignment.Center)
    
    -- SELECTORS
    local g1Size = UDim2.new(1, 0, 0, 35)
    local g1Pos = UDim2.new()
    local g1Col = SolaraManager.CurrentTheme.Accent
    local Game1Btn = CreateButton(GameSelector, "Game1Btn", "Sell Lemons", g1Size, g1Pos, g1Col, "Panels")
    
    local g2Size = UDim2.new(1, 0, 0, 35)
    local g2Pos = UDim2.new()
    local g2Col = SolaraManager.CurrentTheme.PanelBg
    local Game2Btn = CreateButton(GameSelector, "Game2Btn", "Coming Soon", g2Size, g2Pos, g2Col, "Panels")
    
    Game1Btn.MouseButton1Click:Connect(function() 
        SellLemonsScroll.Visible = true
        ComingSoonFrame.Visible = false
        
        local p1 = {}
        p1.BackgroundColor3 = SolaraManager.CurrentTheme.Accent
        ApplyTween(Game1Btn, p1)
        
        local p2 = {}
        p2.BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg
        ApplyTween(Game2Btn, p2) 
    end)
    
    Game2Btn.MouseButton1Click:Connect(function() 
        SellLemonsScroll.Visible = false
        ComingSoonFrame.Visible = true
        
        local p2 = {}
        p2.BackgroundColor3 = SolaraManager.CurrentTheme.Accent
        ApplyTween(Game2Btn, p2)
        
        local p1 = {}
        p1.BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg
        ApplyTween(Game1Btn, p1) 
    end)
    
    local function UpdateGameUI()
        local isNF = (SolaraManager.ActiveFarmState == "Normal")
        local isSF = (SolaraManager.ActiveFarmState == "Safe")
        
        local fCol
        if isNF then fCol = SolaraManager.CurrentTheme.Success else fCol = SolaraManager.CurrentTheme.Danger end
        FarmBtn.BackgroundColor3 = fCol
        
        local sfCol
        if isSF then sfCol = SolaraManager.CurrentTheme.Success else sfCol = SolaraManager.CurrentTheme.Danger end
        SafeFarmBtn.BackgroundColor3 = sfCol
        
        local isNB = (SolaraManager.ActiveBuyState == "Normal")
        local isSB = (SolaraManager.ActiveBuyState == "Safe")
        
        local bCol
        if isNB then bCol = SolaraManager.CurrentTheme.Success else bCol = SolaraManager.CurrentTheme.Danger end
        AutoBuyBtn.BackgroundColor3 = bCol
        
        local sbCol
        if isSB then sbCol = SolaraManager.CurrentTheme.Success else sbCol = SolaraManager.CurrentTheme.Danger end
        SafeBuyBtn.BackgroundColor3 = sbCol
        
        local isFOff = (SolaraManager.ActiveFarmState == "Off")
        if isFOff then 
            local cam = workspace.CurrentCamera
            cam.CameraType = Enum.CameraType.Custom
            FarmStatusLbl.Text = "Status: Idle" 
        end
        
        local isBOff = (SolaraManager.ActiveBuyState == "Off")
        if isBOff then 
            TycoonStatusLbl.Text = "Status: Idle" 
        end
    end
    
    FarmSpeedBtn.MouseButton1Click:Connect(function() 
        local rT = FarmSpeedInput.Text
        local v = tonumber(rT)
        if v then
            local isPos = (v > 0)
            if isPos then 
                local fV = math.min(v, 4)
                SolaraManager.FarmSpeed = fV
                local fS = tostring(fV)
                FarmSpeedBtn.Text = fS 
            end
        end 
    end)
    
    BuySpeedBtn.MouseButton1Click:Connect(function() 
        local rT = BuySpeedInput.Text
        local v = tonumber(rT)
        if v then
            local isPos = (v > 0)
            if isPos then 
                local fV = math.min(v, 10)
                SolaraManager.BuySpeed = fV
                local fS = tostring(fV)
                BuySpeedBtn.Text = fS 
            end
        end 
    end)
    
    FarmBtn.MouseButton1Click:Connect(function() 
        local cS = SolaraManager.ActiveFarmState
        local isN = (cS == "Normal")
        if isN then SolaraManager.ActiveFarmState = "Off" else SolaraManager.ActiveFarmState = "Normal" end
        
        local check = SolaraManager.ActiveFarmState
        local isCheckN = (check == "Normal")
        if isCheckN then SolaraManager.ActiveBuyState = "Off" end
        UpdateGameUI() 
    end)
    
    SafeFarmBtn.MouseButton1Click:Connect(function() 
        local cS = SolaraManager.ActiveFarmState
        local isS = (cS == "Safe")
        if isS then SolaraManager.ActiveFarmState = "Off" else SolaraManager.ActiveFarmState = "Safe" end
        
        local check = SolaraManager.ActiveFarmState
        local isCheckS = (check == "Safe")
        if isCheckS then SolaraManager.ActiveBuyState = "Off" end
        
        SolaraManager.HasSafetyRespawned = false
        UpdateGameUI() 
    end)
    
    AutoBuyBtn.MouseButton1Click:Connect(function() 
        local cS = SolaraManager.ActiveBuyState
        local isN = (cS == "Normal")
        if isN then SolaraManager.ActiveBuyState = "Off" else SolaraManager.ActiveBuyState = "Normal" end
        
        local check = SolaraManager.ActiveBuyState
        local isCheckN = (check == "Normal")
        if isCheckN then SolaraManager.ActiveFarmState = "Off" end
        UpdateGameUI() 
    end)
    
    SafeBuyBtn.MouseButton1Click:Connect(function() 
        local cS = SolaraManager.ActiveBuyState
        local isS = (cS == "Safe")
        if isS then SolaraManager.ActiveBuyState = "Off" else SolaraManager.ActiveBuyState = "Safe" end
        
        local check = SolaraManager.ActiveBuyState
        local isCheckS = (check == "Safe")
        if isCheckS then SolaraManager.ActiveFarmState = "Off" end
        
        SolaraManager.HasSafetyRespawned = false
        UpdateGameUI() 
    end)
end

-------------------------------------------------------------------------------
-- PAGE 5 : SETTINGS
-------------------------------------------------------------------------------
do
    local SettingsPage = BuildPage("Settings", "⚙️", 5)
    
    local SetScroll = Instance.new("ScrollingFrame")
    local ssSize = UDim2.new(1, 0, 1, 0)
    SetScroll.Size = ssSize
    SetScroll.BackgroundTransparency = 1
    SetScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SetScroll.ScrollBarThickness = 4
    SetScroll.Parent = SettingsPage
    
    local sLayout = Instance.new("UIListLayout")
    sLayout.Parent = SetScroll
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad5 = UDim.new(0, 5)
    sLayout.Padding = pad5
    
    -- SAVE LOAD CONFIG
    local cfgTSize = UDim2.new(1, 0, 0, 20)
    local cfgTPos = UDim2.new()
    local CfgTitle = CreateLabel(SetScroll, "CfgTitle", "💾 SCRIPT CONFIG", cfgTSize, cfgTPos, Enum.TextXAlignment.Left)
    CfgTitle.LayoutOrder = 1
    
    local cfgRow = Instance.new("Frame")
    local crSize = UDim2.new(1, 0, 0, 35)
    cfgRow.Size = crSize
    cfgRow.BackgroundTransparency = 1
    cfgRow.LayoutOrder = 2
    cfgRow.Parent = SetScroll
    
    local svBtnSize = UDim2.new(0.48, 0, 1, 0)
    local svBtnPos = UDim2.new(0, 0, 0, 0)
    local svCol = SolaraManager.CurrentTheme.Success
    local SaveCfgBtn = CreateButton(cfgRow, "SaveCfgBtn", "Save Config", svBtnSize, svBtnPos, svCol)
    
    local ldBtnSize = UDim2.new(0.48, 0, 1, 0)
    local ldBtnPos = UDim2.new(0.52, 0, 0, 0)
    local ldCol = SolaraManager.CurrentTheme.Warning
    local LoadCfgBtn = CreateButton(cfgRow, "LoadCfgBtn", "Load Config", ldBtnSize, ldBtnPos, ldCol)
    
    local divCfgSize = UDim2.new(1, -10, 0, 2)
    local divCfgPos = UDim2.new()
    local divCfgCol = SolaraManager.CurrentTheme.Stroke
    local dCfg = CreateFrame(SetScroll, "dCfg", divCfgSize, divCfgPos, divCfgCol, "Dividers")
    dCfg.LayoutOrder = 3
    
    -- A. CUSTOM MUSIC
    local mTitleSize = UDim2.new(1, 0, 0, 20)
    local mTitlePos = UDim2.new()
    local MusicTitle = CreateLabel(SetScroll, "MusicTitle", "🎵 CUSTOM MUSIC PLAYER", mTitleSize, mTitlePos, Enum.TextXAlignment.Left)
    MusicTitle.LayoutOrder = 4
    
    local mRow1Size = UDim2.new(1, 0, 0, 30)
    local mRow1Pos = UDim2.new()
    local MusicRow1 = CreateFrame(SetScroll, "MusicRow1", mRow1Size, mRow1Pos, nil, "Backgrounds")
    MusicRow1.BackgroundTransparency = 1
    MusicRow1.LayoutOrder = 5
    
    local mtBtnSize = UDim2.new(1, -6, 1, 0)
    local mtBtnPos = UDim2.new()
    local mtBtnCol = SolaraManager.CurrentTheme.Danger
    local MuteBtn = CreateButton(MusicRow1, "MuteBtn", "Mute Game Audio: OFF", mtBtnSize, mtBtnPos, mtBtnCol)
    
    local mRow2Size = UDim2.new(1, 0, 0, 30)
    local mRow2Pos = UDim2.new()
    local MusicRow2 = CreateFrame(SetScroll, "MusicRow2", mRow2Size, mRow2Pos, nil, "Backgrounds")
    MusicRow2.BackgroundTransparency = 1
    MusicRow2.LayoutOrder = 6
    
    local mInpSize = UDim2.new(0.45, -5, 1, 0)
    local mInpPos = UDim2.new()
    local MusicInput = CreateInput(MusicRow2, "MusicInput", "Audio ID", mInpSize, mInpPos)
    
    local vInpSize = UDim2.new(0.20, -5, 1, 0)
    local vInpPos = UDim2.new(0.45, 5, 0, 0)
    local VolInput = CreateInput(MusicRow2, "VolInput", "Vol: 100", vInpSize, vInpPos)
    
    local pBtnSize = UDim2.new(0.35, -5, 1, 0)
    local pBtnPos = UDim2.new(0.65, 5, 0, 0)
    local pBtnCol = SolaraManager.CurrentTheme.Accent
    local PlayMusicBtn = CreateButton(MusicRow2, "PlayMusicBtn", "Load", pBtnSize, pBtnPos, pBtnCol)
    
    local mRow3Size = UDim2.new(1, 0, 0, 30)
    local mRow3Pos = UDim2.new()
    local MusicRow3 = CreateFrame(SetScroll, "MusicRow3", mRow3Size, mRow3Pos, nil, "Backgrounds")
    MusicRow3.BackgroundTransparency = 1
    MusicRow3.LayoutOrder = 7
    
    local psBtnSize = UDim2.new(0.48, 0, 1, 0)
    local psBtnPos = UDim2.new(0, 0, 0, 0)
    local psBtnCol = SolaraManager.CurrentTheme.Warning
    local PauseMusicBtn = CreateButton(MusicRow3, "PauseMusicBtn", "Pause", psBtnSize, psBtnPos, psBtnCol)
    
    local stBtnSize = UDim2.new(0.48, -6, 1, 0)
    local stBtnPos = UDim2.new(0.52, 0, 0, 0)
    local stBtnCol = SolaraManager.CurrentTheme.Danger
    local StopMusicBtn = CreateButton(MusicRow3, "StopMusicBtn", "Stop", stBtnSize, stBtnPos, stBtnCol)
    
    local mStatSize = UDim2.new(1, 0, 0, 20)
    local mStatPos = UDim2.new()
    local MusicStatusLbl = CreateLabel(SetScroll, "MusicStatusLbl", "Status: No music playing", mStatSize, mStatPos, Enum.TextXAlignment.Left)
    MusicStatusLbl.LayoutOrder = 8
    MusicStatusLbl.TextSize = 12
    local grayC = Color3.fromRGB(150, 150, 150)
    MusicStatusLbl.TextColor3 = grayC
    SolaraManager.UI.MusicStatusLbl = MusicStatusLbl
    
    local sdSize = UDim2.new(1, -10, 0, 2)
    local sdPos = UDim2.new()
    local sdCol = SolaraManager.CurrentTheme.Stroke
    local sDiv = CreateFrame(SetScroll, "sDiv", sdSize, sdPos, sdCol, "Dividers")
    sDiv.LayoutOrder = 9
    
    SaveCfgBtn.MouseButton1Click:Connect(function()
        local cData = {}
        cData.Theme = SolaraManager.CurrentThemeName
        cData.Speed = SolaraManager.SpeedOverride
        cData.Jump = SolaraManager.JumpOverride
        cData.FarmSpeed = SolaraManager.FarmSpeed
        cData.BuySpeed = SolaraManager.BuySpeed
        cData.MuteAudio = SolaraManager.MuteGameAudio
        cData.CustomMusicId = SolaraManager.CustomMusicId
        cData.CustomMusicVolume = SolaraManager.CustomMusicVolume
        
        local jsonStr = HttpService:JSONEncode(cData)
        if writefile then
            writefile(SolaraManager.ConfigFilename, jsonStr)
            SaveCfgBtn.Text = "Saved!"
            task.wait(1)
            SaveCfgBtn.Text = "Save Config"
        end
    end)
    
    LoadCfgBtn.MouseButton1Click:Connect(function()
        if readfile and isfile then
            local fileExists = isfile(SolaraManager.ConfigFilename)
            if fileExists then
                local jsonStr = readfile(SolaraManager.ConfigFilename)
                local cData = HttpService:JSONDecode(jsonStr)
                if cData then
                    if cData.Theme then 
                        local tgtTheme = cData.Theme .. "Btn"
                        local pT = SetScroll:FindFirstChild(tgtTheme, true)
                        if pT then 
                            local cx = pT.Name
                        end 
                    end
                    SolaraManager.SpeedOverride = cData.Speed
                    SolaraManager.JumpOverride = cData.Jump
                    if cData.FarmSpeed then SolaraManager.FarmSpeed = cData.FarmSpeed end
                    if cData.BuySpeed then SolaraManager.BuySpeed = cData.BuySpeed end
                    if cData.MuteAudio ~= nil then SolaraManager.MuteGameAudio = cData.MuteAudio end
                    if cData.CustomMusicId then SolaraManager.CustomMusicId = cData.CustomMusicId end
                    if cData.CustomMusicVolume then SolaraManager.CustomMusicVolume = cData.CustomMusicVolume end
                    
                    LoadCfgBtn.Text = "Loaded!"
                    task.wait(1)
                    LoadCfgBtn.Text = "Load Config"
                end
            end
        end
    end)
    
    MuteBtn.MouseButton1Click:Connect(function()
        local cMute = SolaraManager.MuteGameAudio
        local nMute = not cMute
        SolaraManager.MuteGameAudio = nMute
        
        local nText
        if nMute then nText = "Mute Game Audio: ON" else nText = "Mute Game Audio: OFF" end
        MuteBtn.Text = nText
        
        local nCol
        if nMute then nCol = SolaraManager.CurrentTheme.Success else nCol = SolaraManager.CurrentTheme.Danger end
        local p = {}
        p.BackgroundColor3 = nCol
        ApplyTween(MuteBtn, p)
        
        if not nMute then
            local wsDesc = workspace:GetDescendants()
            for _, s in ipairs(wsDesc) do 
                local isS = s:IsA("Sound")
                if isS then s.Volume = 0.5 end 
            end
            
            local ssDesc = SoundService:GetDescendants()
            for _, s in ipairs(ssDesc) do 
                local isS = s:IsA("Sound")
                if isS then s.Volume = 0.5 end 
            end
        end
    end)
    
    PlayMusicBtn.MouseButton1Click:Connect(function()
        local rT = MusicInput.Text
        local id = tonumber(rT)
        if not id then return end
        
        SolaraManager.CustomMusicId = tostring(id)
        
        local rV = VolInput.Text
        local vN = tonumber(string.match(rV, "%d+"))
        if vN then
            local mxV = math.min(100, vN)
            local fnV = math.max(0, mxV)
            SolaraManager.CustomMusicVolume = fnV
        end
        
        local cInst = SolaraManager.CustomMusicInstance
        if cInst then cInst:Destroy() end
        
        SolaraManager.CustomMusicName = "Loading..."
        
        local nS = Instance.new("Sound")
        local fId = "rbxassetid://" .. id
        nS.SoundId = fId
        nS.Looped = true
        
        local tVol = SolaraManager.CustomMusicVolume / 100
        nS.Volume = tVol
        nS.Parent = CoreGui
        
        SolaraManager.CustomMusicInstance = nS
        nS:Play()
        PauseMusicBtn.Text = "Pause"
        
        task.spawn(function()
            local function gInfo()
                local i = MarketplaceService:GetProductInfo(id)
                return i
            end
            local s, pI = pcall(gInfo)
            if s then
                if pI then 
                    SolaraManager.CustomMusicName = pI.Name 
                else
                    SolaraManager.CustomMusicName = "Audio ID: " .. id
                end
            else 
                SolaraManager.CustomMusicName = "Audio ID: " .. id 
            end
        end)
    end)
    
    VolInput.FocusLost:Connect(function()
        local rV = VolInput.Text
        local vN = tonumber(string.match(rV, "%d+"))
        if vN then
            local mxV = math.min(100, vN)
            local fnV = math.max(0, mxV)
            SolaraManager.CustomMusicVolume = fnV
            VolInput.Text = "Vol: " .. tostring(fnV)
            
            local cInst = SolaraManager.CustomMusicInstance
            if cInst then
                local tVol = fnV / 100
                cInst.Volume = tVol
            end
        end
    end)
    
    PauseMusicBtn.MouseButton1Click:Connect(function()
        local cInst = SolaraManager.CustomMusicInstance
        if cInst then
            local isP = cInst.IsPlaying
            if isP then
                cInst:Pause()
                PauseMusicBtn.Text = "Resume"
            else
                cInst:Resume()
                PauseMusicBtn.Text = "Pause"
            end
        end
    end)
    
    StopMusicBtn.MouseButton1Click:Connect(function()
        local cInst = SolaraManager.CustomMusicInstance
        if cInst then
            cInst:Stop()
            cInst.TimePosition = 0
            PauseMusicBtn.Text = "Pause"
        end
    end)
    
    -- B. THEMES
    local function BuildThemeGroup(title, groupName, startOrder)
        local tSize = UDim2.new(1, 0, 0, 20)
        local tPos = UDim2.new()
        local tLbl = CreateLabel(SetScroll, title .. "Lbl", title, tSize, tPos, Enum.TextXAlignment.Left)
        tLbl.LayoutOrder = startOrder
        
        local TGrid = Instance.new("Frame")
        TGrid.BackgroundTransparency = 1
        TGrid.LayoutOrder = startOrder + 1
        TGrid.Parent = SetScroll
        
        local GLayout = Instance.new("UIGridLayout")
        GLayout.Parent = TGrid
        
        local cSize = UDim2.new(0.31, 0, 0, 30)
        GLayout.CellSize = cSize
        
        local cPad = UDim2.new(0.02, 0, 0, 5)
        GLayout.CellPadding = cPad
        GLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local count = 0
        
        for tName, tData in pairs(Themes) do
            local isMatch = (tData.Group == groupName)
            if isMatch then
                count = count + 1
                
                local bSize = UDim2.new()
                local bPos = UDim2.new()
                local bBg = SolaraManager.CurrentTheme.PanelBg
                local btn = CreateButton(TGrid, tName .. "Btn", tName, bSize, bPos, bBg, "Panels")
                
                btn.MouseButton1Click:Connect(function()
                    local sT = Themes[tName]
                    SolaraManager.CurrentTheme = sT
                    SolaraManager.CurrentThemeName = tName
                    
                    local bgA = SolaraManager.ThemeObjects.Backgrounds
                    for _, bObj in ipairs(bgA) do 
                        if bObj.Parent then 
                            local p = {}
                            p.BackgroundColor3 = sT.MainBg
                            ApplyTween(bObj, p, 0.5) 
                        end 
                    end
                    
                    local pnlA = SolaraManager.ThemeObjects.Panels
                    for _, pObj in ipairs(pnlA) do 
                        if pObj.Parent then 
                            local p = {}
                            p.BackgroundColor3 = sT.PanelBg
                            ApplyTween(pObj, p, 0.5) 
                        end 
                    end
                    
                    local accA = SolaraManager.ThemeObjects.Accents
                    for _, aObj in ipairs(accA) do 
                        if aObj.Parent then 
                            local p = {}
                            p.BackgroundColor3 = sT.Accent
                            ApplyTween(aObj, p, 0.5) 
                        end 
                    end
                    
                    local strA = SolaraManager.ThemeObjects.Strokes
                    for _, sObj in ipairs(strA) do 
                        if sObj.Parent then 
                            local p = {}
                            p.Color = sT.Stroke
                            ApplyTween(sObj, p, 0.5) 
                        end 
                    end
                    
                    local divA = SolaraManager.ThemeObjects.Dividers
                    for _, dObj in ipairs(divA) do 
                        if dObj.Parent then 
                            local p = {}
                            p.BackgroundColor3 = sT.Stroke
                            ApplyTween(dObj, p, 0.5) 
                        end 
                    end
                    
                    local txtA = SolaraManager.ThemeObjects.Texts
                    for _, tObj in ipairs(txtA) do 
                        if tObj.Parent then 
                            local p = {}
                            p.TextColor3 = sT.Text
                            ApplyTween(tObj, p, 0.5) 
                        end 
                    end
                    
                    local tbTbl = SolaraManager.UI.TabButtons
                    for lTN, tBtn in pairs(tbTbl) do 
                        local isA = (lTN == SolaraManager.ActiveTab)
                        local tC
                        if isA then tC = sT.Accent else tC = sT.PanelBg end
                        local p = {}
                        p.BackgroundColor3 = tC
                        ApplyTween(tBtn, p, 0.5) 
                    end
                    
                    local mS = SolaraManager.UI.MainFrameStroke
                    if mS then 
                        local p = {}
                        p.Color = sT.Accent
                        ApplyTween(mS, p, 0.5) 
                    end
                end)
            end
        end
        
        local r = math.ceil(count / 3)
        local h = r * 35
        local fSize = UDim2.new(1, -6, 0, h)
        TGrid.Size = fSize
        
        local nOrd = startOrder + 2
        return nOrd
    end
    
    local gcS = 10
    local ggS = BuildThemeGroup("🎨 COLOR THEMES", "Color", gcS)
    BuildThemeGroup("🕹️ VIDEO GAMES THEMES", "Game", ggS)
end

-------------------------------------------------------------------------------
-- 13. ÉCOUTEURS D'ÉVÉNEMENTS (MUTE AUDIO GLOBAL)
-------------------------------------------------------------------------------
local function TryMuteSound(obj)
    local isS = obj:IsA("Sound")
    if isS then
        local cMute = SolaraManager.MuteGameAudio
        if cMute then
            obj.Volume = 0
        end
    end
end

workspace.DescendantAdded:Connect(TryMuteSound)
SoundService.DescendantAdded:Connect(TryMuteSound)
CoreGui.DescendantAdded:Connect(function(obj)
    local isC = (obj ~= SolaraManager.CustomMusicInstance)
    if isC then TryMuteSound(obj) end
end)

SwitchTab("Player")

-------------------------------------------------------------------------------
-- 14. BOUCLE PRINCIPALE
-------------------------------------------------------------------------------
task.spawn(function()
    while ScreenGui.Parent do
        local char = LocalPlayer.Character
        
        local hrp = nil
        if char then
            hrp = char:FindFirstChild("HumanoidRootPart")
        end
        
        local hum = nil
        if char then
            hum = char:FindFirstChild("Humanoid")
        end
        
        if hum then
            local spO = SolaraManager.SpeedOverride
            if spO then 
                hum.WalkSpeed = spO 
            end
            
            local jpO = SolaraManager.JumpOverride
            if jpO then 
                hum.UseJumpPower = true
                hum.JumpPower = jpO 
            end
        end
        
        local isC = SolaraManager.IsClicking
        if isC then 
            pcall(function() 
                local t = nil
                if char then
                    t = char:FindFirstChildOfClass("Tool")
                end
                if t then 
                    t:Activate() 
                end 
            end) 
        end
        
        local cMus = SolaraManager.CustomMusicInstance
        local mStatLbl = SolaraManager.UI.MusicStatusLbl
        
        if cMus then
            local isL = cMus.IsLoaded
            if isL then
                local p = cMus.TimePosition
                local l = cMus.TimeLength
                local mN = SolaraManager.CustomMusicName
                
                local pM = math.floor(p / 60)
                local pS = math.floor(p % 60)
                
                local lM = math.floor(l / 60)
                local lS = math.floor(l % 60)
                
                local sStr = string.format("Now Playing: %s | %02d:%02d / %02d:%02d", mN, pM, pS, lM, lS)
                if mStatLbl then
                    mStatLbl.Text = sStr
                end
            end
        else
            if mStatLbl then
                local cTxt = mStatLbl.Text
                local dTxt = "Status: No music playing"
                local isDiff = (cTxt ~= dTxt)
                if isDiff then
                    mStatLbl.Text = dTxt
                end
            end
        end
        
        local cT = tick()
        local lMC = SolaraManager.LastMuteCheck
        local tD = cT - lMC
        local isO1 = (tD > 1)
        
        if isO1 then
            SolaraManager.LastMuteCheck = cT
            local isM = SolaraManager.MuteGameAudio
            
            if isM then
                local wD = workspace:GetDescendants()
                for _, sO in ipairs(wD) do 
                    local isS = sO:IsA("Sound")
                    if isS then sO.Volume = 0 end 
                end
                
                local sD = SoundService:GetDescendants()
                for _, sO in ipairs(sD) do 
                    local isS = sO:IsA("Sound")
                    if isS then sO.Volume = 0 end 
                end
            end
        end
        
        pcall(function()
            local pG = LocalPlayer.PlayerGui
            local h = pG:FindFirstChild("HUD")
            
            if h then
                local b = h:FindFirstChild("Balance")
                if b then
                    local m = b:FindFirstChild("Main")
                    if m then
                        local cL = m:FindFirstChild("Cash")
                        if cL then
                            local isTxt = cL:IsA("TextLabel")
                            if isTxt then
                                local tStr = cL.Text
                                local fStr = "Cash: " .. tStr
                                
                                local cStLbl = SolaraManager.UI.CashStatusLbl
                                if cStLbl then
                                    cStLbl.Text = fStr
                                end
                                
                                local pNum = ParsePrice(tStr)
                                local isNotI = (pNum ~= math.huge)
                                
                                if isNotI then 
                                    local lCV = SolaraManager.LastCashValue
                                    local isDiff = (pNum ~= lCV)
                                    
                                    if isDiff then
                                        SolaraManager.LastCashValue = pNum
                                        local tN = tick()
                                        local hE = {}
                                        hE.time = tN
                                        hE.cash = pNum
                                        
                                        local hTbl = SolaraManager.CashHistory
                                        table.insert(hTbl, hE)
                                        
                                        local hLen = #hTbl
                                        
                                        while hLen > 0 do
                                            local oE = hTbl[1]
                                            local tDiff15 = tN - oE.time
                                            local isO15 = (tDiff15 > 15)
                                            
                                            if isO15 then
                                                table.remove(hTbl, 1)
                                                hLen = #hTbl
                                            else
                                                break
                                            end
                                        end
                                    end
                                    
                                    local chTbl = SolaraManager.CashHistory
                                    local chLen = #chTbl
                                    local isG1 = (chLen > 1)
                                    
                                    local cRLbl = SolaraManager.UI.CashRateLbl
                                    
                                    if isG1 then
                                        local fR = chTbl[1]
                                        local lR = chTbl[chLen]
                                        
                                        local dTm = lR.time - fR.time
                                        local dCs = lR.cash - fR.cash
                                        
                                        local isVT = (dTm > 0)
                                        local isVC = (dCs >= 0)
                                        
                                        if isVT and isVC then
                                            local cps = dCs / dTm
                                            local cph = cps * 3600
                                            
                                            local fCps = FormatNumber(cps)
                                            local fCph = FormatNumber(cph)
                                            
                                            local fnStr = string.format("Est: $%s/sec | $%s/hr", fCps, fCph)
                                            
                                            if cRLbl then
                                                cRLbl.Text = fnStr
                                            end
                                        end
                                    else
                                        if cRLbl then
                                            cRLbl.Text = "Est: $0/sec | $0/hr"
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        local aP = Players:GetPlayers()
        local pC = #aP
        local oPP = (pC > 1)
        local sMP = false
        
        local aFS = SolaraManager.ActiveFarmState
        local aBS = SolaraManager.ActiveBuyState
        
        local iFS = (aFS == "Safe")
        local iBS = (aBS == "Safe")
        local iAS = (iFS or iBS)
        
        local cFSLbl = SolaraManager.UI.FarmStatusLbl
        local cTSLbl = SolaraManager.UI.TycoonStatusLbl
        
        if oPP and iAS then
            sMP = true
            local hR = SolaraManager.HasSafetyRespawned
            
            if not hR then
                local iCR = (char and hrp)
                if iCR then 
                    local sCF = CFrame.new(0, 103, 0)
                    char:PivotTo(sCF)
                    local zV = Vector3.zero
                    hrp.Velocity = zV
                    hrp.RotVelocity = zV 
                end
                SolaraManager.HasSafetyRespawned = true
            end
            
            if iFS then 
                if cFSLbl then cFSLbl.Text = "Status: PAUSED (Player in server)" end
            end
            
            if iBS then 
                if cTSLbl then cTSLbl.Text = "Status: PAUSED (Player in server)" end
            end
        else 
            SolaraManager.HasSafetyRespawned = false 
        end
        
        if not sMP then
            local isBA = (aBS ~= "Off")
            local isCV = (char and hrp)
            
            if isBA and isCV then
                pcall(function()
                    local tT = SolaraManager.MyTycoon
                    if not tT then
                        if cTSLbl then cTSLbl.Text = "Status: Searching Tycoon..." end
                        local wC = workspace:GetChildren()
                        
                        for _, fol in ipairs(wC) do
                            local oV = fol:FindFirstChild("Owner")
                            if oV then
                                local iOV = oV:IsA("ObjectValue")
                                local iSV = oV:IsA("StringValue")
                                local cON = ""
                                
                                if iOV then
                                    local oR = oV.Value
                                    if oR then cON = oR.Name end
                                elseif iSV then
                                    local oS = oV.Value
                                    if oS then cON = oS end
                                end
                                
                                local lO = string.lower(cON)
                                local lL = string.lower(LocalPlayer.Name)
                                local isM = (lO == lL)
                                
                                if isM then 
                                    SolaraManager.MyTycoon = fol
                                    break 
                                end
                            end
                        end
                    end
                    
                    local tF = SolaraManager.MyTycoon
                    if tF then
                        if cTSLbl then cTSLbl.Text = "Status: Scanning buttons..." end
                        local pFol = tF:FindFirstChild("Purchases")
                        local bL = {}
                        local tC = {}
                        tC.Structure = true
                        tC.Other = true
                        tC.Multiplier = true
                        tC.Multipliers = true
                        
                        local function SMFB(bM)
                            if not bM then return end
                            local bP = bM:FindFirstChild("Button")
                            if bP then
                                local iBP = bP:IsA("BasePart")
                                if iBP then
                                    local pG = bP:FindFirstChild("Gui")
                                    local mG = bM:FindFirstChild("Gui")
                                    local gF = pG or mG
                                    if gF then
                                        local pO = gF:FindFirstChild("Price")
                                        if pO then
                                            local iVB = pO:IsA("ValueBase")
                                            local rPS = ""
                                            if iVB then
                                                rPS = tostring(pO.Value)
                                            else
                                                rPS = pO.Text
                                            end
                                            
                                            local pMO = gF:FindFirstChild("PriceMag")
                                            if pMO then 
                                                local iMVB = pMO:IsA("ValueBase")
                                                local mS = ""
                                                if iMVB then
                                                    mS = tostring(pMO.Value)
                                                else
                                                    mS = pMO.Text
                                                end
                                                rPS = rPS .. mS 
                                            end
                                            
                                            local nPV = ParsePrice(rPS)
                                            local iPV = (nPV >= 0)
                                            local iPF = (nPV ~= math.huge)
                                            if iPV and iPF then 
                                                local bD = {}
                                                bD.Part = bP
                                                bD.Price = nPV
                                                bD.Raw = rPS
                                                table.insert(bL, bD) 
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        if pFol then
                            local sFols = pFol:GetChildren()
                            for _, sF in ipairs(sFols) do
                                local bF = sF:FindFirstChild("Buttons")
                                if bF then 
                                    local cs = bF:GetChildren()
                                    for _, cFol in ipairs(cs) do 
                                        local n = cFol.Name
                                        local iTC = tC[n]
                                        local iM = cFol:IsA("Model")
                                        if iTC then 
                                            local bMs = cFol:GetChildren()
                                            for _, bM in ipairs(bMs) do 
                                                SMFB(bM) 
                                            end 
                                        elseif iM then 
                                            SMFB(cFol) 
                                        end 
                                    end 
                                end
                                
                                local nH = sF.Name
                                local iH = (nH == "Hills")
                                if iH then 
                                    local dL = sF:GetDescendants()
                                    for _, dO in ipairs(dL) do 
                                        local oIM = dO:IsA("Model")
                                        if oIM then
                                            local hB = dO:FindFirstChild("Button")
                                            if hB then
                                                SMFB(dO) 
                                            end
                                        end
                                    end 
                                end
                            end
                        end
                        
                        local lL = #bL
                        local isG0 = (lL > 0)
                        if isG0 then
                            table.sort(bL, function(a, b) 
                                local pA = a.Price
                                local pB = b.Price
                                return pA < pB 
                            end)
                            
                            local cB = bL[1]
                            local bR = cB.Raw
                            local bT = "Status: Buying (" .. bR .. ")"
                            
                            if cTSLbl then cTSLbl.Text = bT end
                            
                            local tP = cB.Part
                            local tCF = tP.CFrame
                            local oCF = CFrame.new(0, 1, 0)
                            local fCF = tCF * oCF
                            
                            char:PivotTo(fCF)
                            local zV = Vector3.zero
                            hrp.Velocity = zV
                            hrp.RotVelocity = zV
                            
                            local bSp = SolaraManager.BuySpeed
                            local wT = 1 / bSp
                            task.wait(wT)
                        else 
                            if cTSLbl then cTSLbl.Text = "Status: No buttons found." end
                            task.wait(1) 
                        end
                    end
                end)
            end
            
            local iFA = (aFS ~= "Off")
            if iFA and isCV then
                local cTF = tick()
                local lCU = SolaraManager.LastCacheUpdate
                local tSC = cTF - lCU
                local isO10 = (tSC >= 10)
                
                if isO10 then
                    SolaraManager.FarmCache = {}
                    SolaraManager.SpecialCount = 0
                    
                    local wD = workspace:GetDescendants()
                    for _, wO in ipairs(wD) do
                        local fSC = SolaraManager.ActiveFarmState
                        local isOff = (fSC == "Off")
                        if isOff then break end
                        
                        local wN = wO.Name
                        local isT = (wN == "LemonTree")
                        if isT then
                            local tD = wO:GetDescendants()
                            for _, fO in ipairs(tD) do
                                local fN = fO.Name
                                local isF = (fN == "Fruit")
                                if isF then
                                    local cP = fO:FindFirstChild("ClickPart")
                                    if cP then
                                        local iBP = cP:IsA("BasePart")
                                        if iBP then
                                            local cD = cP:FindFirstChildOfClass("ClickDetector")
                                            if cD then
                                                local a1 = fO:FindFirstChild("SpecialAttachment")
                                                local a2 = cP:FindFirstChild("SpecialAttachment")
                                                local hA1 = (a1 ~= nil)
                                                local hA2 = (a2 ~= nil)
                                                local iSF = (hA1 or hA2)
                                                
                                                if iSF then 
                                                    local cSC = SolaraManager.SpecialCount
                                                    SolaraManager.SpecialCount = cSC + 1 
                                                end
                                                
                                                local fD = {}
                                                fD.Part = cP
                                                fD.Detector = cD
                                                fD.Special = iSF
                                                
                                                local fCT = SolaraManager.FarmCache
                                                table.insert(fCT, fD)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    local fTb = SolaraManager.FarmCache
                    table.sort(fTb, function(a, b) 
                        local sa = a.Special
                        local sb = b.Special
                        local nsb = not sb
                        return sa and nsb 
                    end)
                    
                    SolaraManager.LastCacheUpdate = tick()
                end
                
                local cCL = #SolaraManager.FarmCache
                local isCG0 = (cCL > 0)
                
                if isCG0 then
                    local fCT = SolaraManager.FarmCache
                    local tFD = table.remove(fCT, 1)
                    local nCL = #fCT
                    local sC = SolaraManager.SpecialCount
                    
                    local fStr = string.format("Status: Harvesting (%d left, %d Special)", nCL, sC)
                    if cFSLbl then cFSLbl.Text = fStr end
                    
                    local fP = tFD.Part
                    if fP then
                        local pP = fP.Parent
                        if pP then
                            local isS = tFD.Special
                            if isS then 
                                local tC = SolaraManager.SpecialCount - 1
                                local mx = math.max(0, tC)
                                SolaraManager.SpecialCount = mx 
                            end
                            
                            pcall(function()
                                local cFS = SolaraManager.FarmSpeed
                                local tCy = 1 / cFS
                                
                                local fCF = fP.CFrame
                                local oCF = CFrame.new(0, 0, 2.5)
                                local pCF = fCF * oCF
                                
                                char:PivotTo(pCF)
                                local zV = Vector3.zero
                                hrp.Velocity = zV
                                
                                local m1 = tCy * 0.4
                                local w1 = math.max(0.15, m1)
                                task.wait(w1)
                                
                                local tD = tFD.Detector
                                local fc = fireclickdetector
                                if fc then 
                                    fc(tD) 
                                end
                                
                                local cam = workspace.CurrentCamera
                                local scT = Enum.CameraType.Scriptable
                                cam.CameraType = scT
                                
                                local cP = cam.CFrame.Position
                                local fPos = fP.Position
                                local lCF = CFrame.lookAt(cP, fPos)
                                cam.CFrame = lCF
                                
                                local m2 = tCy * 0.4
                                local w2 = math.max(0.05, m2)
                                task.wait(w2)
                                
                                local vS = cam.ViewportSize
                                local sCen = vS / 2
                                
                                VirtualUser:Button1Down(sCen)
                                task.wait(0.05)
                                VirtualUser:Button1Up(sCen)
                                
                                local cuT = Enum.CameraType.Custom
                                cam.CameraType = cuT
                                
                                local cH = hrp
                                if cH then 
                                    local cPos = cam.CFrame.Position
                                    local cL = cH.CFrame.LookVector
                                    local oV = cL * 10
                                    local tLP = cPos + oV
                                    local fnCF = CFrame.lookAt(cPos, tLP)
                                    cam.CFrame = fnCF 
                                end
                                
                                local m3 = tCy * 0.2
                                local w3 = math.max(0.1, m3)
                                task.wait(w3)
                            end)
                        end
                    end
                else 
                    if cFSLbl then cFSLbl.Text = "Status: Waiting for respawns..." end
                end
            end
        end
        
        local lD = SolaraManager.ClickDelay
        task.wait(lD)
    end
end)

-------------------------------------------------------------------------------
-- 15. ANTI-AFK SYSTÈME
-------------------------------------------------------------------------------
LocalPlayer.Idled:Connect(function() 
    local iAO = SolaraManager.IsAntiAfk
    local iGA = ScreenGui.Parent
    local iOn = (iAO and iGA)
    
    if iOn then 
        VirtualUser:CaptureController()
        local bV = Vector2.new()
        VirtualUser:ClickButton2(bV) 
    end 
end)
