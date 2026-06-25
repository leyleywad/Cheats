--[[ 
    Leyley's Premium Cheat V6.4
    - Suppression de l'Auto Upgrade
    - Architecture Ultra-Aérée (1 instruction par ligne)
    - 100% Modulable et Lisible
]]--

print("Leyley's Premium Cheat V6.4 loaded")

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

local LocalPlayer = Players.LocalPlayer

-------------------------------------------------------------------------------
-- 2. DÉFINITION DES THÈMES
-------------------------------------------------------------------------------
local Themes = {
    -- Catégorie : Color Themes
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
    
    -- Catégorie : Video Games Themes
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
    GuiName = "LeyleysCheat_V6_4",
    CurrentTheme = Themes.Default,
    ActiveTab = "Player",
    
    ThemeObjects = { 
        Backgrounds = {}, 
        Panels = {}, 
        Accents = {}, 
        Strokes = {}, 
        Texts = {}, 
        Dividers = {} 
    },
    
    -- Player
    IsClicking = false, 
    IsAntiAfk = false, 
    SpeedOverride = nil, 
    JumpOverride = nil, 
    SelectedTarget = nil,
    
    -- Game (Auto Upgrade retiré)
    ActiveGameConfig = "SellLemons", 
    ActiveBuyState = "Off", 
    BuySpeed = 2, 
    MyTycoon = nil, 
    
    -- Farm
    ActiveFarmState = "Off", 
    FarmSpeed = 2, 
    FarmCache = {}, 
    SpecialCount = 0, 
    LastCacheUpdate = 0,
    
    -- Tycoon Buy & Securite
    HasSafetyRespawned = false, 
    ClickDelay = 0.1,
    
    -- Stats Cash
    CashHistory = {},
    
    -- Musique
    CustomMusicInstance = nil,
    CustomMusicName = "Unknown Audio",
    MuteGameAudio = false,
    LastMuteCheck = 0
}

-------------------------------------------------------------------------------
-- 4. PARSER ET FORMATAGE DE PRIX
-------------------------------------------------------------------------------
local SuffixDict = {}

local function GenerateSuffixes()
    local order = { 
        "thousand", 
        "million", 
        "billion", 
        "trillion", 
        "quadrillion", 
        "quintillion", 
        "sextillion", 
        "septillion", 
        "octillion", 
        "nonillion" 
    }
    
    for i, name in ipairs(order) do 
        SuffixDict[name] = i
        SuffixDict[name.."s"] = i 
    end
    
    local tensDict = { 
        ["decillion"] = 11, 
        ["vigintillion"] = 21, 
        ["trigintillion"] = 31, 
        ["quadragintillion"] = 41, 
        ["quinquagintillion"] = 51, 
        ["sexagintillion"] = 61, 
        ["septuagintillion"] = 71, 
        ["octogintillion"] = 81, 
        ["nonagintillion"] = 91 
    }
    
    local unitsPrefix = { 
        ["un"] = 1, 
        ["duo"] = 2, 
        ["tre"] = 3, 
        ["tres"] = 3, 
        ["quattuor"] = 4, 
        ["quattuo"] = 4, 
        ["quin"] = 5, 
        ["quinqua"] = 5, 
        ["sex"] = 6, 
        ["ses"] = 6, 
        ["septen"] = 7, 
        ["septem"] = 7, 
        ["sept"] = 7, 
        ["octo"] = 8, 
        ["novem"] = 9, 
        ["noven"] = 9 
    }
    
    for tName, tVal in pairs(tensDict) do
        SuffixDict[tName] = tVal
        SuffixDict[tName.."s"] = tVal
        
        for uName, uVal in pairs(unitsPrefix) do 
            local combinedName = uName .. tName
            SuffixDict[combinedName] = tVal + uVal
            SuffixDict[combinedName.."s"] = tVal + uVal 
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
    
    str = string.lower(tostring(str))
    
    local isFree = string.match(str, "free")
    local isGratuit = string.match(str, "gratuit")
    
    if isFree or isGratuit then 
        return 0 
    end
    
    local sciNum = tonumber(str)
    if sciNum then 
        return sciNum 
    end
    
    str = string.gsub(str, "[^%d%.%a]", "") 
    
    local numStr, suffix = string.match(str, "^([%d%.]+)(%a*)$")
    
    if not numStr then 
        return math.huge 
    end
    
    local num = tonumber(numStr)
    if not num then 
        return math.huge 
    end
    
    if suffix and suffix ~= "" then
        local powerIndex = SuffixDict[suffix]
        
        if powerIndex then 
            local multiplier = 10 ^ (powerIndex * 3)
            num = num * multiplier
        else 
            return math.huge 
        end
    end
    
    return num
end

local function FormatNumber(num)
    local isNotNumber = (type(num) ~= "number")
    local isNaN = (num ~= num)
    local isInf = (num == math.huge)
    
    if isNotNumber or isNaN or isInf then 
        return "0" 
    end
    
    if num < 1000 then 
        local floored = math.floor(num)
        return tostring(floored) 
    end
    
    local suffixes = {
        "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", 
        "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd"
    }
    
    local suffixIndex = 0
    local tempNum = num
    
    while tempNum >= 1000 and suffixIndex < #suffixes do
        tempNum = tempNum / 1000
        suffixIndex = suffixIndex + 1
    end
    
    if suffixIndex <= #suffixes then
        return string.format("%.2f%s", tempNum, suffixes[suffixIndex])
    else
        return string.format("%.2e", num)
    end
end

-------------------------------------------------------------------------------
-- 5. FONCTIONS DE CRÉATION D'INTERFACE (MODULAIRE)
-------------------------------------------------------------------------------
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
    corner.CornerRadius = UDim.new(0, safeRadius)
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
    label.TextColor3 = SolaraManager.CurrentTheme.Text
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
    
    btn.TextColor3 = SolaraManager.CurrentTheme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Text = text
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    CreateUICorner(btn, 6)
    
    local stroke = CreateUIStroke(btn, SolaraManager.CurrentTheme.Stroke, 1)
    
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
    box.BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg
    box.TextColor3 = SolaraManager.CurrentTheme.Text
    box.PlaceholderText = placeholder
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Text = ""
    box.Parent = parent
    
    CreateUICorner(box, 6)
    CreateUIStroke(box, SolaraManager.CurrentTheme.Stroke, 1)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
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
                if input.UserInputState == Enum.UserInputState.End then
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
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            
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
-- 6. CONSTRUCTION DE LA FENÊTRE PRINCIPALE
-------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SolaraManager.GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local isCoreGuiAvailable = pcall(function() return CoreGui.Name end)

if isCoreGuiAvailable then
    ScreenGui.Parent = CoreGui
else
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = playerGui
end

local restoreBtnSize = UDim2.new(0, 80, 0, 40)
local restoreBtnPos = UDim2.new(0, 20, 1, -60)
local restoreBtnColor = SolaraManager.CurrentTheme.Accent

local RestoreBtn = CreateButton(
    ScreenGui, 
    "RestoreBtn", 
    "➕ Open", 
    restoreBtnSize, 
    restoreBtnPos, 
    restoreBtnColor, 
    "Accents"
)

RestoreBtn.Visible = false
RestoreBtn.ZIndex = 10

local mainFrameSize = UDim2.new(0, 650, 0, 420)
local mainFramePos = UDim2.new(0.5, -325, 0.5, -210)
local mainFrameBg = SolaraManager.CurrentTheme.MainBg

local MainFrame = CreateFrame(
    ScreenGui, 
    "MainFrame", 
    mainFrameSize, 
    mainFramePos, 
    mainFrameBg, 
    "Backgrounds"
)

MainFrame.ClipsDescendants = true
CreateUICorner(MainFrame, 8)
CreateUIStroke(MainFrame, SolaraManager.CurrentTheme.Accent, 2)

local titleBarSize = UDim2.new(1, 0, 0, 40)
local titleBarPos = UDim2.new(0, 0, 0, 0)
local titleBarBg = SolaraManager.CurrentTheme.PanelBg

local TitleBar = CreateFrame(
    MainFrame, 
    "TitleBar", 
    titleBarSize, 
    titleBarPos, 
    titleBarBg, 
    "Panels"
)

EnableDragging(MainFrame, TitleBar)

local titleLabelSize = UDim2.new(1, -100, 1, 0)
local titleLabelPos = UDim2.new(0, 0, 0, 0)

local TitleLabel = CreateLabel(
    TitleBar, 
    "TitleLabel", 
    "  ✨ Leyley's Premium Cheat V6.4", 
    titleLabelSize, 
    titleLabelPos, 
    Enum.TextXAlignment.Left
)

TitleLabel.Font = Enum.Font.GothamBold

local closeBtnSize = UDim2.new(0, 30, 0, 30)
local closeBtnPos = UDim2.new(1, -35, 0, 5)
local closeBtnColor = SolaraManager.CurrentTheme.Danger

local CloseBtn = CreateButton(
    TitleBar, 
    "CloseBtn", 
    "X", 
    closeBtnSize, 
    closeBtnPos, 
    closeBtnColor, 
    nil
)

local minBtnSize = UDim2.new(0, 30, 0, 30)
local minBtnPos = UDim2.new(1, -70, 0, 5)
local minBtnColor = SolaraManager.CurrentTheme.Warning

local MinBtn = CreateButton(
    TitleBar, 
    "MinBtn", 
    "-", 
    minBtnSize, 
    minBtnPos, 
    minBtnColor, 
    nil
)

CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy()
    SolaraManager.IsClicking = false 
end)

MinBtn.MouseButton1Click:Connect(function() 
    local minimizeProps = {}
    minimizeProps.Size = UDim2.new(0, 650, 0, 0)
    
    local tween = ApplyTween(MainFrame, minimizeProps, 0.3)
    
    tween.Completed:Connect(function() 
        MainFrame.Visible = false
        RestoreBtn.Visible = true
        MainFrame.Size = UDim2.new(0, 650, 0, 420) 
    end) 
end)

RestoreBtn.MouseButton1Click:Connect(function() 
    RestoreBtn.Visible = false
    MainFrame.Size = UDim2.new(0, 650, 0, 0)
    MainFrame.Visible = true
    
    local restoreProps = {}
    restoreProps.Size = UDim2.new(0, 650, 0, 420)
    
    ApplyTween(MainFrame, restoreProps, 0.4) 
end)

local sidebarContainerSize = UDim2.new(0, 150, 1, -40)
local sidebarContainerPos = UDim2.new(0, 0, 0, 40)
local sidebarContainerBg = SolaraManager.CurrentTheme.PanelBg

local SidebarContainer = CreateFrame(
    MainFrame, 
    "SidebarContainer", 
    sidebarContainerSize, 
    sidebarContainerPos, 
    sidebarContainerBg, 
    "Panels"
)

local sidebarLineSize = UDim2.new(0, 1, 1, 0)
local sidebarLinePos = UDim2.new(1, -1, 0, 0)
local sidebarLineColor = SolaraManager.CurrentTheme.Stroke

local SidebarLine = CreateFrame(
    SidebarContainer, 
    "SidebarLine", 
    sidebarLineSize, 
    sidebarLinePos, 
    sidebarLineColor, 
    "Dividers"
)

local SidebarButtonsFrame = Instance.new("Frame")
SidebarButtonsFrame.Name = "SidebarButtons"
SidebarButtonsFrame.Size = UDim2.new(1, -1, 1, 0)
SidebarButtonsFrame.BackgroundTransparency = 1
SidebarButtonsFrame.Parent = SidebarContainer

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = SidebarButtonsFrame
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = SidebarButtonsFrame
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingBottom = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)

local contentAreaSize = UDim2.new(1, -150, 1, -40)
local contentAreaPos = UDim2.new(0, 150, 0, 40)
local contentAreaBg = SolaraManager.CurrentTheme.MainBg

local ContentArea = CreateFrame(
    MainFrame, 
    "ContentArea", 
    contentAreaSize, 
    contentAreaPos, 
    contentAreaBg, 
    "Backgrounds"
)

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = ContentArea
ContentPadding.PaddingTop = UDim.new(0, 15)
ContentPadding.PaddingBottom = UDim.new(0, 15)
ContentPadding.PaddingLeft = UDim.new(0, 15)
ContentPadding.PaddingRight = UDim.new(0, 15)

-------------------------------------------------------------------------------
-- 7. GESTION DES ONGLETS (TABS)
-------------------------------------------------------------------------------
local TabButtons = {}
local Pages = {}

local function SwitchTab(tabName)
    for name, page in pairs(Pages) do 
        local isVisible = (name == tabName)
        page.Visible = isVisible
    end
    
    for name, btn in pairs(TabButtons) do
        local targetColor
        
        if name == tabName then 
            targetColor = SolaraManager.CurrentTheme.Accent
        else 
            targetColor = SolaraManager.CurrentTheme.PanelBg
        end
        
        local tweenProps = {}
        tweenProps.BackgroundColor3 = targetColor
        
        ApplyTween(btn, tweenProps, 0.2)
    end
    
    SolaraManager.ActiveTab = tabName
end

local function BuildPage(name, icon, order)
    local btnName = name .. "Tab"
    local btnText = icon .. " " .. name
    local btnSize = UDim2.new(1, 0, 0, 35)
    local btnPos = UDim2.new()
    
    local btn = CreateButton(
        SidebarButtonsFrame, 
        btnName, 
        btnText, 
        btnSize, 
        btnPos, 
        nil, 
        "Panels"
    )
    
    btn.LayoutOrder = order
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local btnPadding = Instance.new("UIPadding", btn)
    btnPadding.PaddingLeft = UDim.new(0, 10)
    
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.Parent = ContentArea
    
    TabButtons[name] = btn
    Pages[name] = page
    
    btn.MouseButton1Click:Connect(function() 
        SwitchTab(name) 
    end)
    
    return page
end

-------------------------------------------------------------------------------
-- 8. PAGE 1 : PLAYER (SANS SCROLL)
-------------------------------------------------------------------------------
local PlayerPage = BuildPage("Player", "👤", 1)

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerPage
PlayerLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerLayout.Padding = UDim.new(0, 10)

local playerTitleSize = UDim2.new(1, 0, 0, 25)
local playerTitlePos = UDim2.new()

local PlayerTitle = CreateLabel(
    PlayerPage, 
    "PlayerTitle", 
    "PLAYER MODIFIERS", 
    playerTitleSize, 
    playerTitlePos, 
    Enum.TextXAlignment.Left
)

PlayerTitle.LayoutOrder = 1

local clickRowSize = UDim2.new(1, 0, 0, 40)
local clickRowPos = UDim2.new()

local ClickRow = CreateFrame(
    PlayerPage, 
    "ClickRow", 
    clickRowSize, 
    clickRowPos, 
    nil, 
    "Backgrounds"
)

ClickRow.BackgroundTransparency = 1
ClickRow.LayoutOrder = 2

local clickToggleSize = UDim2.new(0.48, -2, 1, 0)
local clickTogglePos = UDim2.new(0, 0, 0, 0)
local clickToggleColor = SolaraManager.CurrentTheme.Danger

local ClickToggle = CreateButton(
    ClickRow, 
    "ClickToggle", 
    "Auto Clicker: OFF", 
    clickToggleSize, 
    clickTogglePos, 
    clickToggleColor
)

local afkToggleSize = UDim2.new(0.48, -2, 1, 0)
local afkTogglePos = UDim2.new(0.52, 2, 0, 0)
local afkToggleColor = SolaraManager.CurrentTheme.Danger

local AfkToggle = CreateButton(
    ClickRow, 
    "AfkToggle", 
    "Anti-AFK: OFF", 
    afkToggleSize, 
    afkTogglePos, 
    afkToggleColor
)

ClickToggle.MouseButton1Click:Connect(function() 
    local currentState = SolaraManager.IsClicking
    local newState = not currentState
    SolaraManager.IsClicking = newState
    
    local newText
    if newState then
        newText = "Auto Clicker: ON"
    else
        newText = "Auto Clicker: OFF"
    end
    
    ClickToggle.Text = newText
    
    local targetColor
    if newState then
        targetColor = SolaraManager.CurrentTheme.Success
    else
        targetColor = SolaraManager.CurrentTheme.Danger
    end
    
    local colorProps = {}
    colorProps.BackgroundColor3 = targetColor
    
    ApplyTween(ClickToggle, colorProps) 
end)

AfkToggle.MouseButton1Click:Connect(function() 
    local currentState = SolaraManager.IsAntiAfk
    local newState = not currentState
    SolaraManager.IsAntiAfk = newState
    
    local newText
    if newState then
        newText = "Anti-AFK: ON"
    else
        newText = "Anti-AFK: OFF"
    end
    
    AfkToggle.Text = newText
    
    local targetColor
    if newState then
        targetColor = SolaraManager.CurrentTheme.Success
    else
        targetColor = SolaraManager.CurrentTheme.Danger
    end
    
    local colorProps = {}
    colorProps.BackgroundColor3 = targetColor
    
    ApplyTween(AfkToggle, colorProps) 
end)

local statsTitleSize = UDim2.new(1, 0, 0, 25)
local statsTitlePos = UDim2.new()

local StatsTitle = CreateLabel(
    PlayerPage, 
    "StatsTitle", 
    "STAT OVERRIDES", 
    statsTitleSize, 
    statsTitlePos, 
    Enum.TextXAlignment.Left
)

StatsTitle.LayoutOrder = 3

local speedRowSize = UDim2.new(1, 0, 0, 35)
local speedRowPos = UDim2.new()

local SpeedRow = CreateFrame(
    PlayerPage, 
    "SpeedRow", 
    speedRowSize, 
    speedRowPos, 
    nil, 
    "Backgrounds"
)

SpeedRow.BackgroundTransparency = 1
SpeedRow.LayoutOrder = 4

local speedInputSize = UDim2.new(0.65, -5, 1, 0)
local speedInputPos = UDim2.new(0, 0, 0, 0)

local SpeedInput = CreateInput(
    SpeedRow, 
    "SpeedInput", 
    "WalkSpeed (e.g. 50)", 
    speedInputSize, 
    speedInputPos
)

local speedBtnSize = UDim2.new(0.35, -5, 1, 0)
local speedBtnPos = UDim2.new(0.65, 5, 0, 0)
local speedBtnColor = SolaraManager.CurrentTheme.Accent

local SpeedBtn = CreateButton(
    SpeedRow, 
    "SpeedBtn", 
    "Apply", 
    speedBtnSize, 
    speedBtnPos, 
    speedBtnColor
)

SpeedBtn.MouseButton1Click:Connect(function() 
    local rawText = SpeedInput.Text
    local val = tonumber(rawText)
    
    if val then 
        SolaraManager.SpeedOverride = val
        SpeedBtn.Text = "Applied" 
    else 
        SolaraManager.SpeedOverride = nil
        SpeedBtn.Text = "Reset" 
    end 
end)

local jumpRowSize = UDim2.new(1, 0, 0, 35)
local jumpRowPos = UDim2.new()

local JumpRow = CreateFrame(
    PlayerPage, 
    "JumpRow", 
    jumpRowSize, 
    jumpRowPos, 
    nil, 
    "Backgrounds"
)

JumpRow.BackgroundTransparency = 1
JumpRow.LayoutOrder = 5

local jumpInputSize = UDim2.new(0.65, -5, 1, 0)
local jumpInputPos = UDim2.new(0, 0, 0, 0)

local JumpInput = CreateInput(
    JumpRow, 
    "JumpInput", 
    "JumpPower (e.g. 100)", 
    jumpInputSize, 
    jumpInputPos
)

local jumpBtnSize = UDim2.new(0.35, -5, 1, 0)
local jumpBtnPos = UDim2.new(0.65, 5, 0, 0)
local jumpBtnColor = SolaraManager.CurrentTheme.Accent

local JumpBtn = CreateButton(
    JumpRow, 
    "JumpBtn", 
    "Apply", 
    jumpBtnSize, 
    jumpBtnPos, 
    jumpBtnColor
)

JumpBtn.MouseButton1Click:Connect(function() 
    local rawText = JumpInput.Text
    local val = tonumber(rawText)
    
    if val then 
        SolaraManager.JumpOverride = val
        JumpBtn.Text = "Applied" 
    else 
        SolaraManager.JumpOverride = nil
        JumpBtn.Text = "Reset" 
    end 
end)

-------------------------------------------------------------------------------
-- 9. PAGE 2 : TELEPORT
-------------------------------------------------------------------------------
local TeleportPage = BuildPage("Teleport", "🌍", 2)

local TeleportLayout = Instance.new("UIListLayout")
TeleportLayout.Parent = TeleportPage
TeleportLayout.SortOrder = Enum.SortOrder.LayoutOrder
TeleportLayout.Padding = UDim.new(0, 10)

local selectedLabelSize = UDim2.new(1, 0, 0, 25)
local selectedLabelPos = UDim2.new()

local SelectedLabel = CreateLabel(
    TeleportPage, 
    "SelectedLabel", 
    "Selected: None", 
    selectedLabelSize, 
    selectedLabelPos, 
    Enum.TextXAlignment.Left
)

SelectedLabel.LayoutOrder = 1

local tpBtnSize = UDim2.new(1, -4, 0, 40)
local tpBtnPos = UDim2.new()
local tpBtnColor = SolaraManager.CurrentTheme.Accent

local TpBtn = CreateButton(
    TeleportPage, 
    "TpBtn", 
    "TELEPORT TO PLAYER", 
    tpBtnSize, 
    tpBtnPos, 
    tpBtnColor
)

TpBtn.LayoutOrder = 2

TpBtn.MouseButton1Click:Connect(function() 
    local target = SolaraManager.SelectedTarget
    if target then
        local targetChar = target.Character
        if targetChar then
            local localChar = LocalPlayer.Character
            if localChar then
                local pivot = targetChar:GetPivot()
                localChar:PivotTo(pivot)
            end
        end
    end 
end)

local playerListFrameSize = UDim2.new(1, -4, 1, -85)
local playerListFramePos = UDim2.new()
local playerListFrameBg = SolaraManager.CurrentTheme.PanelBg

local PlayerListFrame = CreateFrame(
    TeleportPage, 
    "PlayerListFrame", 
    playerListFrameSize, 
    playerListFramePos, 
    playerListFrameBg, 
    "Panels"
)

PlayerListFrame.LayoutOrder = 3
CreateUICorner(PlayerListFrame, 6)
CreateUIStroke(PlayerListFrame, SolaraManager.CurrentTheme.Stroke, 1)

local PList = Instance.new("ScrollingFrame")
PList.Size = UDim2.new(1, -10, 1, -10)
PList.Position = UDim2.new(0, 5, 0, 5)
PList.BackgroundTransparency = 1
PList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PList.ScrollBarThickness = 4
PList.Parent = PlayerListFrame

local PListLayout = Instance.new("UIListLayout")
PListLayout.Parent = PList
PListLayout.Padding = UDim.new(0, 5)

local function UpdatePlayers()
    local pListChildren = PList:GetChildren()
    
    for _, child in ipairs(pListChildren) do 
        if child:IsA("TextButton") then 
            child:Destroy() 
        end 
    end
    
    local allPlayers = Players:GetPlayers()
    
    table.sort(allPlayers, function(a, b) 
        local nameA = a.Name:lower()
        local nameB = b.Name:lower()
        return nameA < nameB 
    end)
    
    for _, playerObj in ipairs(allPlayers) do
        if playerObj ~= LocalPlayer then
            local pBtnSize = UDim2.new(1, -5, 0, 30)
            local pBtnPos = UDim2.new()
            local pBtnBg = SolaraManager.CurrentTheme.MainBg
            
            local btn = CreateButton(
                PList, 
                "PBtn", 
                playerObj.Name, 
                pBtnSize, 
                pBtnPos, 
                pBtnBg, 
                "Backgrounds"
            )
            
            btn.MouseButton1Click:Connect(function() 
                SolaraManager.SelectedTarget = playerObj
                local selectedText = "Selected: " .. playerObj.Name
                SelectedLabel.Text = selectedText 
            end)
        end
    end
end

Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)

UpdatePlayers()

-------------------------------------------------------------------------------
-- 10. PAGE 3 : EXPLORER
-------------------------------------------------------------------------------
local ExplorerPage = BuildPage("Explorer", "🔍", 3)

local ExplorerLayout = Instance.new("UIListLayout")
ExplorerLayout.Parent = ExplorerPage
ExplorerLayout.SortOrder = Enum.SortOrder.LayoutOrder
ExplorerLayout.Padding = UDim.new(0, 10)

local dexDescSize = UDim2.new(1, 0, 0, 40)
local dexDescPos = UDim2.new()
local dexDescText = "Load Dark Dex V3 to view the game's file structure. Useful for finding hidden items."

local DexDesc = CreateLabel(
    ExplorerPage, 
    "DexDesc", 
    dexDescText, 
    dexDescSize, 
    dexDescPos, 
    Enum.TextXAlignment.Left
)

DexDesc.LayoutOrder = 1

local dexBtnSize = UDim2.new(1, -4, 0, 50)
local dexBtnPos = UDim2.new()
local dexBtnColor = Color3.fromRGB(130, 50, 200)

local DexBtn = CreateButton(
    ExplorerPage, 
    "DexBtn", 
    "Launch Dex Explorer", 
    dexBtnSize, 
    dexBtnPos, 
    dexBtnColor
)

DexBtn.LayoutOrder = 2

DexBtn.MouseButton1Click:Connect(function()
    DexBtn.Text = "Loading Dex..."
    
    task.spawn(function()
        local function executeDex()
            local dexUrl = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"
            local fetchedCode = game:HttpGet(dexUrl)
            local loadedFunc = loadstring(fetchedCode)
            loadedFunc()
        end
        
        local success, errorMsg = pcall(executeDex)
        
        if success then 
            DexBtn.Text = "Dex Launched!"
            
            local successColorProps = {}
            successColorProps.BackgroundColor3 = SolaraManager.CurrentTheme.Success
            
            ApplyTween(DexBtn, successColorProps)
        else 
            DexBtn.Text = "Failed to load!"
            
            local failColorProps = {}
            failColorProps.BackgroundColor3 = SolaraManager.CurrentTheme.Danger
            
            ApplyTween(DexBtn, failColorProps) 
        end
        
        task.wait(2)
        
        DexBtn.Text = "Launch Dex Explorer"
        
        local resetColorProps = {}
        resetColorProps.BackgroundColor3 = dexBtnColor
        
        ApplyTween(DexBtn, resetColorProps)
    end)
end)

-------------------------------------------------------------------------------
-- 11. PAGE 4 : GAME (SANS AUTO UPGRADE)
-------------------------------------------------------------------------------
local GamePage = BuildPage("Game", "🎮", 4)

local GameContainer = Instance.new("Frame")
GameContainer.Size = UDim2.new(1, 0, 1, 0)
GameContainer.BackgroundTransparency = 1
GameContainer.Parent = GamePage

local gameSelectorSize = UDim2.new(0.35, 0, 1, 0)
local gameSelectorPos = UDim2.new(0, 0, 0, 0)
local gameSelectorBg = SolaraManager.CurrentTheme.PanelBg

local GameSelector = CreateFrame(
    GameContainer, 
    "GameSelector", 
    gameSelectorSize, 
    gameSelectorPos, 
    gameSelectorBg, 
    "Panels"
)

CreateUICorner(GameSelector, 6)
CreateUIStroke(GameSelector, SolaraManager.CurrentTheme.Stroke, 1)

local SelectorLayout = Instance.new("UIListLayout")
SelectorLayout.Parent = GameSelector
SelectorLayout.Padding = UDim.new(0, 5)

local SelectorPadding = Instance.new("UIPadding")
SelectorPadding.Parent = GameSelector
SelectorPadding.PaddingTop = UDim.new(0, 5)
SelectorPadding.PaddingLeft = UDim.new(0, 5)
SelectorPadding.PaddingRight = UDim.new(0, 5)

local GameContentFrame = Instance.new("Frame")
GameContentFrame.Size = UDim2.new(0.65, -10, 1, 0)
GameContentFrame.Position = UDim2.new(0.35, 10, 0, 0)
GameContentFrame.BackgroundTransparency = 1
GameContentFrame.Parent = GameContainer

local SellLemonsScroll = Instance.new("ScrollingFrame")
SellLemonsScroll.Size = UDim2.new(1, 0, 1, 0)
SellLemonsScroll.BackgroundTransparency = 1
SellLemonsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SellLemonsScroll.ScrollBarThickness = 4
SellLemonsScroll.Parent = GameContentFrame

local LemonsLayout = Instance.new("UIListLayout")
LemonsLayout.Parent = SellLemonsScroll
LemonsLayout.Padding = UDim.new(0, 8)
LemonsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Section 1 : ECONOMY STATS
local statsTitleSize2 = UDim2.new(1, 0, 0, 20)
local statsTitlePos2 = UDim2.new()

local CashTitle = CreateLabel(
    SellLemonsScroll, 
    "CashTitle", 
    "💰 ECONOMY STATS", 
    statsTitleSize2, 
    statsTitlePos2, 
    Enum.TextXAlignment.Left
)

CashTitle.LayoutOrder = 1

local cashStatusLblSize = UDim2.new(1, 0, 0, 15)
local cashStatusLblPos = UDim2.new()

local CashStatusLbl = CreateLabel(
    SellLemonsScroll, 
    "CashStatus", 
    "Cash: $0", 
    cashStatusLblSize, 
    cashStatusLblPos, 
    Enum.TextXAlignment.Left
)

CashStatusLbl.TextSize = 12
CashStatusLbl.TextColor3 = SolaraManager.CurrentTheme.Success
CashStatusLbl.LayoutOrder = 2

local cashRateLblSize = UDim2.new(1, 0, 0, 15)
local cashRateLblPos = UDim2.new()

local CashRateLbl = CreateLabel(
    SellLemonsScroll, 
    "CashRate", 
    "Est: $0/sec | $0/hr", 
    cashRateLblSize, 
    cashRateLblPos, 
    Enum.TextXAlignment.Left
)

CashRateLbl.TextSize = 11
CashRateLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
CashRateLbl.LayoutOrder = 3

local div0Size = UDim2.new(1, -10, 0, 2)
local div0Pos = UDim2.new()
local div0Color = SolaraManager.CurrentTheme.Stroke

local div0 = CreateFrame(
    SellLemonsScroll, 
    "Div0", 
    div0Size, 
    div0Pos, 
    div0Color, 
    "Dividers"
)

div0.LayoutOrder = 4

-- Section 2 : AUTO FARM
local farmTitleSize = UDim2.new(1, 0, 0, 20)
local farmTitlePos = UDim2.new()

local FarmTitle = CreateLabel(
    SellLemonsScroll, 
    "FarmTitle", 
    "🍋 AUTO FARM", 
    farmTitleSize, 
    farmTitlePos, 
    Enum.TextXAlignment.Left
)

FarmTitle.LayoutOrder = 5

local farmStatusLblSize = UDim2.new(1, 0, 0, 15)
local farmStatusLblPos = UDim2.new()

local FarmStatusLbl = CreateLabel(
    SellLemonsScroll, 
    "FarmStatus", 
    "Status: Idle", 
    farmStatusLblSize, 
    farmStatusLblPos, 
    Enum.TextXAlignment.Left
)

FarmStatusLbl.TextSize = 12
FarmStatusLbl.LayoutOrder = 6

local FarmSpeedRow = Instance.new("Frame")
FarmSpeedRow.Size = UDim2.new(1, 0, 0, 30)
FarmSpeedRow.BackgroundTransparency = 1
FarmSpeedRow.LayoutOrder = 7
FarmSpeedRow.Parent = SellLemonsScroll

local farmSpeedInputSize = UDim2.new(0.6, -5, 1, 0)
local farmSpeedInputPos = UDim2.new()

local FarmSpeedInput = CreateInput(
    FarmSpeedRow, 
    "FarmSpeed", 
    "Speed (1-4)", 
    farmSpeedInputSize, 
    farmSpeedInputPos
)

local farmSpeedBtnSize = UDim2.new(0.4, -5, 1, 0)
local farmSpeedBtnPos = UDim2.new(0.6, 5, 0, 0)
local farmSpeedBtnColor = SolaraManager.CurrentTheme.Accent

local FarmSpeedBtn = CreateButton(
    FarmSpeedRow, 
    "FarmSet", 
    "Set", 
    farmSpeedBtnSize, 
    farmSpeedBtnPos, 
    farmSpeedBtnColor
)

local FarmActionRow = Instance.new("Frame")
FarmActionRow.Size = UDim2.new(1, 0, 0, 35)
FarmActionRow.BackgroundTransparency = 1
FarmActionRow.LayoutOrder = 8
FarmActionRow.Parent = SellLemonsScroll

local farmBtnSize = UDim2.new(0.5, -5, 1, 0)
local farmBtnPos = UDim2.new()
local farmBtnColor = SolaraManager.CurrentTheme.Danger

local FarmBtn = CreateButton(
    FarmActionRow, 
    "FarmBtn", 
    "Normal Farm", 
    farmBtnSize, 
    farmBtnPos, 
    farmBtnColor
)

local safeFarmBtnSize = UDim2.new(0.5, -5, 1, 0)
local safeFarmBtnPos = UDim2.new(0.5, 5, 0, 0)
local safeFarmBtnColor = SolaraManager.CurrentTheme.Danger

local SafeFarmBtn = CreateButton(
    FarmActionRow, 
    "SafeFarmBtn", 
    "Safe Farm", 
    safeFarmBtnSize, 
    safeFarmBtnPos, 
    safeFarmBtnColor
)

local div1Size = UDim2.new(1, -10, 0, 2)
local div1Pos = UDim2.new()
local div1Color = SolaraManager.CurrentTheme.Stroke

local div1 = CreateFrame(
    SellLemonsScroll, 
    "Div1", 
    div1Size, 
    div1Pos, 
    div1Color, 
    "Dividers"
)

div1.LayoutOrder = 9

-- Section 3 : TYCOON BUY
local tycoonTitleSize = UDim2.new(1, 0, 0, 20)
local tycoonTitlePos = UDim2.new()

local TycoonTitle = CreateLabel(
    SellLemonsScroll, 
    "TycoonTitle", 
    "🏭 TYCOON BUY", 
    tycoonTitleSize, 
    tycoonTitlePos, 
    Enum.TextXAlignment.Left
)

TycoonTitle.LayoutOrder = 10

local tycoonStatusLblSize = UDim2.new(1, 0, 0, 15)
local tycoonStatusLblPos = UDim2.new()

local TycoonStatusLbl = CreateLabel(
    SellLemonsScroll, 
    "TycoonStatus", 
    "Status: Idle", 
    tycoonStatusLblSize, 
    tycoonStatusLblPos, 
    Enum.TextXAlignment.Left
)

TycoonStatusLbl.TextSize = 12
TycoonStatusLbl.LayoutOrder = 11

local BuySpeedRow = Instance.new("Frame")
BuySpeedRow.Size = UDim2.new(1, 0, 0, 30)
BuySpeedRow.BackgroundTransparency = 1
BuySpeedRow.LayoutOrder = 12
BuySpeedRow.Parent = SellLemonsScroll

local buySpeedInputSize = UDim2.new(0.6, -5, 1, 0)
local buySpeedInputPos = UDim2.new()

local BuySpeedInput = CreateInput(
    BuySpeedRow, 
    "BuySpeed", 
    "Speed (1-10)", 
    buySpeedInputSize, 
    buySpeedInputPos
)

local buySpeedBtnSize = UDim2.new(0.4, -5, 1, 0)
local buySpeedBtnPos = UDim2.new(0.6, 5, 0, 0)
local buySpeedBtnColor = SolaraManager.CurrentTheme.Accent

local BuySpeedBtn = CreateButton(
    BuySpeedRow, 
    "BuySet", 
    "Set", 
    buySpeedBtnSize, 
    buySpeedBtnPos, 
    buySpeedBtnColor
)

local BuyActionRow = Instance.new("Frame")
BuyActionRow.Size = UDim2.new(1, 0, 0, 35)
BuyActionRow.BackgroundTransparency = 1
BuyActionRow.LayoutOrder = 13
BuyActionRow.Parent = SellLemonsScroll

local autoBuyBtnSize = UDim2.new(0.5, -5, 1, 0)
local autoBuyBtnPos = UDim2.new()
local autoBuyBtnColor = SolaraManager.CurrentTheme.Danger

local AutoBuyBtn = CreateButton(
    BuyActionRow, 
    "AutoBuyBtn", 
    "Auto Buy", 
    autoBuyBtnSize, 
    autoBuyBtnPos, 
    autoBuyBtnColor
)

local safeBuyBtnSize = UDim2.new(0.5, -5, 1, 0)
local safeBuyBtnPos = UDim2.new(0.5, 5, 0, 0)
local safeBuyBtnColor = SolaraManager.CurrentTheme.Danger

local SafeBuyBtn = CreateButton(
    BuyActionRow, 
    "SafeBuyBtn", 
    "Safe Buy", 
    safeBuyBtnSize, 
    safeBuyBtnPos, 
    safeBuyBtnColor
)

-- Page Coming Soon
local ComingSoonFrame = Instance.new("Frame")
ComingSoonFrame.Size = UDim2.new(1, 0, 1, 0)
ComingSoonFrame.BackgroundTransparency = 1
ComingSoonFrame.Visible = false
ComingSoonFrame.Parent = GameContentFrame

local csTitleSize = UDim2.new(1, 0, 0, 30)
local csTitlePos = UDim2.new(0, 0, 0.3, 0)

local CS_Title = CreateLabel(
    ComingSoonFrame, 
    "CS_Title", 
    "🚧 COMING SOON", 
    csTitleSize, 
    csTitlePos, 
    Enum.TextXAlignment.Center
)

local csDescSize = UDim2.new(1, 0, 0, 30)
local csDescPos = UDim2.new(0, 0, 0.4, 0)

local CS_Desc = CreateLabel(
    ComingSoonFrame, 
    "CS_Desc", 
    "New games will be added here.", 
    csDescSize, 
    csDescPos, 
    Enum.TextXAlignment.Center
)

local game1BtnSize = UDim2.new(1, 0, 0, 35)
local game1BtnPos = UDim2.new()
local game1BtnColor = SolaraManager.CurrentTheme.Accent

local Game1Btn = CreateButton(
    GameSelector, 
    "Game1Btn", 
    "Sell Lemons", 
    game1BtnSize, 
    game1BtnPos, 
    game1BtnColor, 
    "Panels"
)

local game2BtnSize = UDim2.new(1, 0, 0, 35)
local game2BtnPos = UDim2.new()
local game2BtnColor = SolaraManager.CurrentTheme.PanelBg

local Game2Btn = CreateButton(
    GameSelector, 
    "Game2Btn", 
    "Coming Soon", 
    game2BtnSize, 
    game2BtnPos, 
    game2BtnColor, 
    "Panels"
)

Game1Btn.MouseButton1Click:Connect(function() 
    SellLemonsScroll.Visible = true
    ComingSoonFrame.Visible = false
    
    local btn1Props = {}
    btn1Props.BackgroundColor3 = SolaraManager.CurrentTheme.Accent
    ApplyTween(Game1Btn, btn1Props)
    
    local btn2Props = {}
    btn2Props.BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg
    ApplyTween(Game2Btn, btn2Props) 
end)

Game2Btn.MouseButton1Click:Connect(function() 
    SellLemonsScroll.Visible = false
    ComingSoonFrame.Visible = true
    
    local btn2Props = {}
    btn2Props.BackgroundColor3 = SolaraManager.CurrentTheme.Accent
    ApplyTween(Game2Btn, btn2Props)
    
    local btn1Props = {}
    btn1Props.BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg
    ApplyTween(Game1Btn, btn1Props) 
end)

local function UpdateGameUI()
    local isNormalFarm = (SolaraManager.ActiveFarmState == "Normal")
    local isSafeFarm = (SolaraManager.ActiveFarmState == "Safe")
    
    local farmColor
    if isNormalFarm then
        farmColor = SolaraManager.CurrentTheme.Success
    else
        farmColor = SolaraManager.CurrentTheme.Danger
    end
    FarmBtn.BackgroundColor3 = farmColor
    
    local safeFarmColor
    if isSafeFarm then
        safeFarmColor = SolaraManager.CurrentTheme.Success
    else
        safeFarmColor = SolaraManager.CurrentTheme.Danger
    end
    SafeFarmBtn.BackgroundColor3 = safeFarmColor
    
    local isNormalBuy = (SolaraManager.ActiveBuyState == "Normal")
    local isSafeBuy = (SolaraManager.ActiveBuyState == "Safe")
    
    local buyColor
    if isNormalBuy then
        buyColor = SolaraManager.CurrentTheme.Success
    else
        buyColor = SolaraManager.CurrentTheme.Danger
    end
    AutoBuyBtn.BackgroundColor3 = buyColor
    
    local safeBuyColor
    if isSafeBuy then
        safeBuyColor = SolaraManager.CurrentTheme.Success
    else
        safeBuyColor = SolaraManager.CurrentTheme.Danger
    end
    SafeBuyBtn.BackgroundColor3 = safeBuyColor
    
    if SolaraManager.ActiveFarmState == "Off" then 
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Custom
        FarmStatusLbl.Text = "Status: Idle" 
    end
    
    if SolaraManager.ActiveBuyState == "Off" then 
        TycoonStatusLbl.Text = "Status: Idle" 
    end
end

FarmSpeedBtn.MouseButton1Click:Connect(function() 
    local rawText = FarmSpeedInput.Text
    local val = tonumber(rawText)
    
    if val then
        if val > 0 then 
            local finalVal = math.min(val, 4)
            SolaraManager.FarmSpeed = finalVal
            FarmSpeedBtn.Text = tostring(finalVal) 
        end
    end 
end)

BuySpeedBtn.MouseButton1Click:Connect(function() 
    local rawText = BuySpeedInput.Text
    local val = tonumber(rawText)
    
    if val then
        if val > 0 then 
            local finalVal = math.min(val, 10)
            SolaraManager.BuySpeed = finalVal
            BuySpeedBtn.Text = tostring(finalVal) 
        end
    end 
end)

FarmBtn.MouseButton1Click:Connect(function() 
    local currentState = SolaraManager.ActiveFarmState
    
    if currentState == "Normal" then
        SolaraManager.ActiveFarmState = "Off"
    else
        SolaraManager.ActiveFarmState = "Normal"
    end
    
    if SolaraManager.ActiveFarmState == "Normal" then 
        SolaraManager.ActiveBuyState = "Off" 
    end
    
    UpdateGameUI() 
end)

SafeFarmBtn.MouseButton1Click:Connect(function() 
    local currentState = SolaraManager.ActiveFarmState
    
    if currentState == "Safe" then
        SolaraManager.ActiveFarmState = "Off"
    else
        SolaraManager.ActiveFarmState = "Safe"
    end
    
    if SolaraManager.ActiveFarmState == "Safe" then 
        SolaraManager.ActiveBuyState = "Off" 
    end
    
    SolaraManager.HasSafetyRespawned = false
    
    UpdateGameUI() 
end)

AutoBuyBtn.MouseButton1Click:Connect(function() 
    local currentState = SolaraManager.ActiveBuyState
    
    if currentState == "Normal" then
        SolaraManager.ActiveBuyState = "Off"
    else
        SolaraManager.ActiveBuyState = "Normal"
    end
    
    if SolaraManager.ActiveBuyState == "Normal" then 
        SolaraManager.ActiveFarmState = "Off" 
    end
    
    UpdateGameUI() 
end)

SafeBuyBtn.MouseButton1Click:Connect(function() 
    local currentState = SolaraManager.ActiveBuyState
    
    if currentState == "Safe" then
        SolaraManager.ActiveBuyState = "Off"
    else
        SolaraManager.ActiveBuyState = "Safe"
    end
    
    if SolaraManager.ActiveBuyState == "Safe" then 
        SolaraManager.ActiveFarmState = "Off" 
    end
    
    SolaraManager.HasSafetyRespawned = false
    
    UpdateGameUI() 
end)

-------------------------------------------------------------------------------
-- 12. PAGE 5 : SETTINGS
-------------------------------------------------------------------------------
local SettingsPage = BuildPage("Settings", "⚙️", 5)

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Parent = SettingsPage
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0, 5)

local musicTitleSize = UDim2.new(1, 0, 0, 20)
local musicTitlePos = UDim2.new()

local MusicTitle = CreateLabel(
    SettingsPage, 
    "MusicTitle", 
    "🎵 CUSTOM MUSIC PLAYER", 
    musicTitleSize, 
    musicTitlePos, 
    Enum.TextXAlignment.Left
)

MusicTitle.LayoutOrder = 1

local musicRow1Size = UDim2.new(1, 0, 0, 30)
local musicRow1Pos = UDim2.new()

local MusicRow1 = CreateFrame(
    SettingsPage, 
    "MusicRow1", 
    musicRow1Size, 
    musicRow1Pos, 
    nil, 
    "Backgrounds"
)

MusicRow1.BackgroundTransparency = 1
MusicRow1.LayoutOrder = 2

local muteBtnSize = UDim2.new(1, -6, 1, 0)
local muteBtnPos = UDim2.new()
local muteBtnColor = SolaraManager.CurrentTheme.Danger

local MuteBtn = CreateButton(
    MusicRow1, 
    "MuteBtn", 
    "Mute Game Audio: OFF", 
    muteBtnSize, 
    muteBtnPos, 
    muteBtnColor
)

local musicRow2Size = UDim2.new(1, 0, 0, 30)
local musicRow2Pos = UDim2.new()

local MusicRow2 = CreateFrame(
    SettingsPage, 
    "MusicRow2", 
    musicRow2Size, 
    musicRow2Pos, 
    nil, 
    "Backgrounds"
)

MusicRow2.BackgroundTransparency = 1
MusicRow2.LayoutOrder = 3

local musicInputSize = UDim2.new(0.65, -5, 1, 0)
local musicInputPos = UDim2.new()

local MusicInput = CreateInput(
    MusicRow2, 
    "MusicInput", 
    "Audio ID (e.g. 1837879082)", 
    musicInputSize, 
    musicInputPos
)

local playMusicBtnSize = UDim2.new(0.35, -5, 1, 0)
local playMusicBtnPos = UDim2.new(0.65, 5, 0, 0)
local playMusicBtnColor = SolaraManager.CurrentTheme.Accent

local PlayMusicBtn = CreateButton(
    MusicRow2, 
    "PlayMusicBtn", 
    "Load & Play", 
    playMusicBtnSize, 
    playMusicBtnPos, 
    playMusicBtnColor
)

local musicRow3Size = UDim2.new(1, 0, 0, 30)
local musicRow3Pos = UDim2.new()

local MusicRow3 = CreateFrame(
    SettingsPage, 
    "MusicRow3", 
    musicRow3Size, 
    musicRow3Pos, 
    nil, 
    "Backgrounds"
)

MusicRow3.BackgroundTransparency = 1
MusicRow3.LayoutOrder = 4

local pauseMusicBtnSize = UDim2.new(0.48, 0, 1, 0)
local pauseMusicBtnPos = UDim2.new(0, 0, 0, 0)
local pauseMusicBtnColor = SolaraManager.CurrentTheme.Warning

local PauseMusicBtn = CreateButton(
    MusicRow3, 
    "PauseMusicBtn", 
    "Pause", 
    pauseMusicBtnSize, 
    pauseMusicBtnPos, 
    pauseMusicBtnColor
)

local stopMusicBtnSize = UDim2.new(0.48, -6, 1, 0)
local stopMusicBtnPos = UDim2.new(0.52, 0, 0, 0)
local stopMusicBtnColor = SolaraManager.CurrentTheme.Danger

local StopMusicBtn = CreateButton(
    MusicRow3, 
    "StopMusicBtn", 
    "Stop", 
    stopMusicBtnSize, 
    stopMusicBtnPos, 
    stopMusicBtnColor
)

local musicStatusLblSize = UDim2.new(1, 0, 0, 20)
local musicStatusLblPos = UDim2.new()

local MusicStatusLbl = CreateLabel(
    SettingsPage, 
    "MusicStatusLbl", 
    "Status: No music playing", 
    musicStatusLblSize, 
    musicStatusLblPos, 
    Enum.TextXAlignment.Left
)

MusicStatusLbl.LayoutOrder = 5
MusicStatusLbl.TextSize = 12
MusicStatusLbl.TextColor3 = Color3.fromRGB(150, 150, 150)

local sDivSize = UDim2.new(1, -10, 0, 2)
local sDivPos = UDim2.new()
local sDivColor = SolaraManager.CurrentTheme.Stroke

local sDiv = CreateFrame(
    SettingsPage, 
    "sDiv", 
    sDivSize, 
    sDivPos, 
    sDivColor, 
    "Dividers"
)

sDiv.LayoutOrder = 6

MuteBtn.MouseButton1Click:Connect(function()
    local currentState = SolaraManager.MuteGameAudio
    local newState = not currentState
    SolaraManager.MuteGameAudio = newState
    
    local newText
    if newState then
        newText = "Mute Game Audio: ON"
    else
        newText = "Mute Game Audio: OFF"
    end
    MuteBtn.Text = newText
    
    local targetColor
    if newState then
        targetColor = SolaraManager.CurrentTheme.Success
    else
        targetColor = SolaraManager.CurrentTheme.Danger
    end
    
    local colorProps = {}
    colorProps.BackgroundColor3 = targetColor
    ApplyTween(MuteBtn, colorProps)
    
    if not newState then
        local wsDescendants = workspace:GetDescendants()
        for _, soundObj in ipairs(wsDescendants) do 
            if soundObj:IsA("Sound") then 
                soundObj.Volume = 0.5 
            end 
        end
        
        local ssDescendants = SoundService:GetDescendants()
        for _, soundObj in ipairs(ssDescendants) do 
            if soundObj:IsA("Sound") then 
                soundObj.Volume = 0.5 
            end 
        end
    end
end)

PlayMusicBtn.MouseButton1Click:Connect(function()
    local rawText = MusicInput.Text
    local id = tonumber(rawText)
    
    if not id then 
        return 
    end
    
    local currentInstance = SolaraManager.CustomMusicInstance
    if currentInstance then 
        currentInstance:Destroy() 
    end
    
    SolaraManager.CustomMusicName = "Loading..."
    
    local newSound = Instance.new("Sound")
    local fullId = "rbxassetid://" .. id
    newSound.SoundId = fullId
    newSound.Looped = true
    newSound.Volume = 1
    newSound.Parent = CoreGui
    
    SolaraManager.CustomMusicInstance = newSound
    newSound:Play()
    PauseMusicBtn.Text = "Pause"
    
    task.spawn(function()
        local function getInfo()
            local info = MarketplaceService:GetProductInfo(id)
            return info
        end
        
        local success, productInfo = pcall(getInfo)
        
        if success then
            if productInfo then 
                SolaraManager.CustomMusicName = productInfo.Name 
            else
                SolaraManager.CustomMusicName = "Audio ID: " .. id
            end
        else 
            SolaraManager.CustomMusicName = "Audio ID: " .. id 
        end
    end)
end)

PauseMusicBtn.MouseButton1Click:Connect(function()
    local currentInstance = SolaraManager.CustomMusicInstance
    
    if currentInstance then
        local isPlaying = currentInstance.IsPlaying
        
        if isPlaying then
            currentInstance:Pause()
            PauseMusicBtn.Text = "Resume"
        else
            currentInstance:Resume()
            PauseMusicBtn.Text = "Pause"
        end
    end
end)

StopMusicBtn.MouseButton1Click:Connect(function()
    local currentInstance = SolaraManager.CustomMusicInstance
    
    if currentInstance then
        currentInstance:Stop()
        currentInstance.TimePosition = 0
        PauseMusicBtn.Text = "Pause"
    end
end)

local function BuildThemeGroup(title, groupName, startOrder)
    local titleSize = UDim2.new(1, 0, 0, 20)
    local titlePos = UDim2.new()
    
    local titleLbl = CreateLabel(
        SettingsPage, 
        title .. "Lbl", 
        title, 
        titleSize, 
        titlePos, 
        Enum.TextXAlignment.Left
    )
    
    titleLbl.LayoutOrder = startOrder
    
    local TGrid = Instance.new("Frame")
    TGrid.BackgroundTransparency = 1
    TGrid.LayoutOrder = startOrder + 1
    TGrid.Parent = SettingsPage
    
    local GLayout = Instance.new("UIGridLayout")
    GLayout.Parent = TGrid
    GLayout.CellSize = UDim2.new(0.31, 0, 0, 30)
    GLayout.CellPadding = UDim2.new(0.02, 0, 0, 5)
    GLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local count = 0
    
    for tName, tData in pairs(Themes) do
        local isMatch = (tData.Group == groupName)
        
        if isMatch then
            count = count + 1
            
            local btnSize = UDim2.new()
            local btnPos = UDim2.new()
            local btnBg = SolaraManager.CurrentTheme.PanelBg
            
            local btn = CreateButton(
                TGrid, 
                tName .. "Btn", 
                tName, 
                btnSize, 
                btnPos, 
                btnBg, 
                "Panels"
            )
            
            btn.MouseButton1Click:Connect(function()
                local selectedTheme = Themes[tName]
                SolaraManager.CurrentTheme = selectedTheme
                
                local bgArray = SolaraManager.ThemeObjects.Backgrounds
                for _, bgObj in ipairs(bgArray) do 
                    if bgObj.Parent then 
                        local props = {}
                        props.BackgroundColor3 = selectedTheme.MainBg
                        ApplyTween(bgObj, props, 0.5) 
                    end 
                end
                
                local panelArray = SolaraManager.ThemeObjects.Panels
                for _, pnlObj in ipairs(panelArray) do 
                    if pnlObj.Parent then 
                        local props = {}
                        props.BackgroundColor3 = selectedTheme.PanelBg
                        ApplyTween(pnlObj, props, 0.5) 
                    end 
                end
                
                local accentArray = SolaraManager.ThemeObjects.Accents
                for _, accObj in ipairs(accentArray) do 
                    if accObj.Parent then 
                        local props = {}
                        props.BackgroundColor3 = selectedTheme.Accent
                        ApplyTween(accObj, props, 0.5) 
                    end 
                end
                
                local strokeArray = SolaraManager.ThemeObjects.Strokes
                for _, strkObj in ipairs(strokeArray) do 
                    if strkObj.Parent then 
                        local props = {}
                        props.Color = selectedTheme.Stroke
                        ApplyTween(strkObj, props, 0.5) 
                    end 
                end
                
                local dividerArray = SolaraManager.ThemeObjects.Dividers
                for _, divObj in ipairs(dividerArray) do 
                    if divObj.Parent then 
                        local props = {}
                        props.BackgroundColor3 = selectedTheme.Stroke
                        ApplyTween(divObj, props, 0.5) 
                    end 
                end
                
                local textArray = SolaraManager.ThemeObjects.Texts
                for _, txtObj in ipairs(textArray) do 
                    if txtObj.Parent then 
                        local props = {}
                        props.TextColor3 = selectedTheme.Text
                        ApplyTween(txtObj, props, 0.5) 
                    end 
                end
                
                for loopTabName, tabBtn in pairs(TabButtons) do 
                    local isActive = (loopTabName == SolaraManager.ActiveTab)
                    local targetColor
                    
                    if isActive then
                        targetColor = selectedTheme.Accent
                    else
                        targetColor = selectedTheme.PanelBg
                    end
                    
                    local props = {}
                    props.BackgroundColor3 = targetColor
                    ApplyTween(tabBtn, props, 0.5) 
                end
                
                local mStroke = MainFrame:FindFirstChildOfClass("UIStroke")
                if mStroke then 
                    local strokeProps = {}
                    strokeProps.Color = selectedTheme.Accent
                    ApplyTween(mStroke, strokeProps, 0.5) 
                end
            end)
        end
    end
    
    local rows = math.ceil(count / 3)
    local height = rows * 35
    TGrid.Size = UDim2.new(1, -6, 0, height)
    
    local nextOrder = startOrder + 2
    return nextOrder
end

local groupColorStart = 5
local groupGameStart = BuildThemeGroup("🎨 COLOR THEMES", "Color", groupColorStart)
BuildThemeGroup("🕹️ VIDEO GAMES THEMES", "Game", groupGameStart)

-------------------------------------------------------------------------------
-- 13. INITIALISATION
-------------------------------------------------------------------------------
SwitchTab("Player")

-------------------------------------------------------------------------------
-- 14. BOUCLE PRINCIPALE (RUNSERVICE / TASK.SPAWN)
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
            local speedOv = SolaraManager.SpeedOverride
            if speedOv then 
                hum.WalkSpeed = speedOv 
            end
            
            local jumpOv = SolaraManager.JumpOverride
            if jumpOv then 
                hum.UseJumpPower = true
                hum.JumpPower = jumpOv 
            end
        end
        
        local isClicking = SolaraManager.IsClicking
        if isClicking then 
            pcall(function() 
                local tool = nil
                if char then
                    tool = char:FindFirstChildOfClass("Tool")
                end
                
                if tool then 
                    tool:Activate() 
                end 
            end) 
        end
        
        local currentMusic = SolaraManager.CustomMusicInstance
        
        if currentMusic then
            local isLoaded = currentMusic.IsLoaded
            if isLoaded then
                local pos = currentMusic.TimePosition
                local len = currentMusic.TimeLength
                local musicName = SolaraManager.CustomMusicName
                
                local posMin = math.floor(pos / 60)
                local posSec = math.floor(pos % 60)
                
                local lenMin = math.floor(len / 60)
                local lenSec = math.floor(len % 60)
                
                local statusString = string.format(
                    "Now Playing: %s | %02d:%02d / %02d:%02d", 
                    musicName, 
                    posMin, 
                    posSec, 
                    lenMin, 
                    lenSec
                )
                
                MusicStatusLbl.Text = statusString
            end
        else
            local currentText = MusicStatusLbl.Text
            local defaultText = "Status: No music playing"
            
            if currentText ~= defaultText then
                MusicStatusLbl.Text = defaultText
            end
        end
        
        local currentTick = tick()
        local lastMuteCheck = SolaraManager.LastMuteCheck
        local timeSinceCheck = currentTick - lastMuteCheck
        
        if timeSinceCheck > 1 then
            SolaraManager.LastMuteCheck = currentTick
            
            local isMuted = SolaraManager.MuteGameAudio
            if isMuted then
                local wsDescendants = workspace:GetDescendants()
                for _, sObj in ipairs(wsDescendants) do 
                    if sObj:IsA("Sound") then 
                        sObj.Volume = 0 
                    end 
                end
                
                local ssDescendants = SoundService:GetDescendants()
                for _, sObj in ipairs(ssDescendants) do 
                    if sObj:IsA("Sound") then 
                        sObj.Volume = 0 
                    end 
                end
            end
        end
        
        local currentCashNum = 0
        
        pcall(function()
            local playerGui = LocalPlayer.PlayerGui
            local hud = playerGui:FindFirstChild("HUD")
            
            if hud then
                local balance = hud:FindFirstChild("Balance")
                if balance then
                    local main = balance:FindFirstChild("Main")
                    if main then
                        local cashLbl = main:FindFirstChild("Cash")
                        if cashLbl then
                            if cashLbl:IsA("TextLabel") then
                                local txt = cashLbl.Text
                                local fullText = "Cash: " .. txt
                                CashStatusLbl.Text = fullText
                                
                                local parsedNum = ParsePrice(txt)
                                local isNotInf = (parsedNum ~= math.huge)
                                
                                if isNotInf then 
                                    currentCashNum = parsedNum 
                                    
                                    local timeNow = tick()
                                    local historyEntry = {time = timeNow, cash = parsedNum}
                                    
                                    local historyTable = SolaraManager.CashHistory
                                    table.insert(historyTable, historyEntry)
                                    
                                    local historyLength = #historyTable
                                    
                                    while historyLength > 0 do
                                        local oldestEntry = historyTable[1]
                                        local timeDiff = timeNow - oldestEntry.time
                                        
                                        if timeDiff > 15 then
                                            table.remove(historyTable, 1)
                                            historyLength = #historyTable
                                        else
                                            break
                                        end
                                    end
                                    
                                    if historyLength > 1 then
                                        local firstRecord = historyTable[1]
                                        local lastRecord = historyTable[historyLength]
                                        
                                        local dTime = lastRecord.time - firstRecord.time
                                        local dCash = lastRecord.cash - firstRecord.cash
                                        
                                        local isValidTime = (dTime > 0)
                                        local isValidCash = (dCash >= 0)
                                        
                                        if isValidTime and isValidCash then
                                            local cps = dCash / dTime
                                            local cph = cps * 3600
                                            
                                            local formatCps = FormatNumber(cps)
                                            local formatCph = FormatNumber(cph)
                                            
                                            local finalString = string.format("Est: $%s/sec | $%s/hr", formatCps, formatCph)
                                            CashRateLbl.Text = finalString
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        local allPlayers = Players:GetPlayers()
        local playerCount = #allPlayers
        local otherPlayersPresent = (playerCount > 1)
        
        local safeModePaused = false
        
        local isFarmSafe = (SolaraManager.ActiveFarmState == "Safe")
        local isBuySafe = (SolaraManager.ActiveBuyState == "Safe")
        local isAnySafeActive = (isFarmSafe or isBuySafe)
        
        if otherPlayersPresent and isAnySafeActive then
            safeModePaused = true
            local hasRespawned = SolaraManager.HasSafetyRespawned
            
            if not hasRespawned then
                local isCharReady = (char and hrp)
                if isCharReady then 
                    local safeCFrame = CFrame.new(0, 103, 0)
                    char:PivotTo(safeCFrame)
                    
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero 
                end
                
                SolaraManager.HasSafetyRespawned = true
            end
            
            if isFarmSafe then 
                FarmStatusLbl.Text = "Status: PAUSED (Player in server)" 
            end
            
            if isBuySafe then 
                TycoonStatusLbl.Text = "Status: PAUSED (Player in server)" 
            end
        else 
            SolaraManager.HasSafetyRespawned = false 
        end
        
        if not safeModePaused then
            local isBuyActive = (SolaraManager.ActiveBuyState ~= "Off")
            local isCharValid = (char and hrp)
            
            if isBuyActive and isCharValid then
                pcall(function()
                    local tycoonTracker = SolaraManager.MyTycoon
                    
                    if not tycoonTracker then
                        TycoonStatusLbl.Text = "Status: Searching Tycoon..."
                        local wsChildren = workspace:GetChildren()
                        
                        for _, folder in ipairs(wsChildren) do
                            local ownerVal = folder:FindFirstChild("Owner")
                            
                            if ownerVal then
                                local isObjVal = ownerVal:IsA("ObjectValue")
                                local isStrVal = ownerVal:IsA("StringValue")
                                local currentOwnerName = ""
                                
                                if isObjVal then
                                    local ownerRef = ownerVal.Value
                                    if ownerRef then
                                        currentOwnerName = ownerRef.Name
                                    end
                                elseif isStrVal then
                                    local ownerStr = ownerVal.Value
                                    if ownerStr then
                                        currentOwnerName = ownerStr
                                    end
                                end
                                
                                local lowerOwner = string.lower(currentOwnerName)
                                local lowerLocal = string.lower(LocalPlayer.Name)
                                
                                if lowerOwner == lowerLocal then 
                                    SolaraManager.MyTycoon = folder
                                    break 
                                end
                            end
                        end
                    end
                    
                    local tycoonFound = SolaraManager.MyTycoon
                    
                    if tycoonFound then
                        TycoonStatusLbl.Text = "Status: Scanning buttons..."
                        local purchasesFolder = tycoonFound:FindFirstChild("Purchases")
                        local btnsList = {}
                        
                        local targetCats = {}
                        targetCats.Structure = true
                        targetCats.Other = true
                        targetCats.Multiplier = true
                        targetCats.Multipliers = true
                        
                        local function ScanModelForButton(bModel)
                            if not bModel then return end
                            
                            local bPart = bModel:FindFirstChild("Button")
                            
                            if bPart then
                                local isBasePart = bPart:IsA("BasePart")
                                
                                if isBasePart then
                                    local partGui = bPart:FindFirstChild("Gui")
                                    local modelGui = bModel:FindFirstChild("Gui")
                                    local guiFolder = partGui or modelGui
                                    
                                    if guiFolder then
                                        local priceObj = guiFolder:FindFirstChild("Price")
                                        
                                        if priceObj then
                                            local isValBase = priceObj:IsA("ValueBase")
                                            local rawPriceStr = ""
                                            
                                            if isValBase then
                                                rawPriceStr = tostring(priceObj.Value)
                                            else
                                                rawPriceStr = priceObj.Text
                                            end
                                            
                                            local priceMagObj = guiFolder:FindFirstChild("PriceMag")
                                            
                                            if priceMagObj then 
                                                local isMagValBase = priceMagObj:IsA("ValueBase")
                                                local magStr = ""
                                                
                                                if isMagValBase then
                                                    magStr = tostring(priceMagObj.Value)
                                                else
                                                    magStr = priceMagObj.Text
                                                end
                                                
                                                rawPriceStr = rawPriceStr .. magStr 
                                            end
                                            
                                            local numPriceVal = ParsePrice(rawPriceStr)
                                            local isPriceValid = (numPriceVal >= 0)
                                            local isPriceFinite = (numPriceVal ~= math.huge)
                                            
                                            if isPriceValid and isPriceFinite then 
                                                local btnData = {}
                                                btnData.Part = bPart
                                                btnData.Price = numPriceVal
                                                btnData.Raw = rawPriceStr
                                                
                                                table.insert(btnsList, btnData) 
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        if purchasesFolder then
                            local sFolders = purchasesFolder:GetChildren()
                            
                            for _, sF in ipairs(sFolders) do
                                local bF = sF:FindFirstChild("Buttons")
                                
                                if bF then 
                                    local cats = bF:GetChildren()
                                    
                                    for _, cFolder in ipairs(cats) do 
                                        local isTargetCat = targetCats[cFolder.Name]
                                        local isModel = cFolder:IsA("Model")
                                        
                                        if isTargetCat then 
                                            local bModels = cFolder:GetChildren()
                                            for _, bM in ipairs(bModels) do 
                                                ScanModelForButton(bM) 
                                            end 
                                        elseif isModel then 
                                            ScanModelForButton(cFolder) 
                                        end 
                                    end 
                                end
                                
                                local isHills = (sF.Name == "Hills")
                                if isHills then 
                                    local descList = sF:GetDescendants()
                                    for _, dObj in ipairs(descList) do 
                                        local objIsModel = dObj:IsA("Model")
                                        
                                        if objIsModel then
                                            local hasButton = dObj:FindFirstChild("Button")
                                            if hasButton then
                                                ScanModelForButton(dObj) 
                                            end
                                        end
                                    end 
                                end
                            end
                        end
                        
                        local listLength = #btnsList
                        
                        if listLength > 0 then
                            table.sort(btnsList, function(a, b) 
                                return a.Price < b.Price 
                            end)
                            
                            local cheapestButton = btnsList[1]
                            local buyText = "Status: Buying (" .. cheapestButton.Raw .. ")"
                            TycoonStatusLbl.Text = buyText
                            
                            local targetPart = cheapestButton.Part
                            local targetCFrame = targetPart.CFrame
                            local offsetCFrame = CFrame.new(0, 1, 0)
                            local finalCFrame = targetCFrame * offsetCFrame
                            
                            char:PivotTo(finalCFrame)
                            hrp.Velocity = Vector3.zero
                            hrp.RotVelocity = Vector3.zero
                            
                            local waitTime = 1 / SolaraManager.BuySpeed
                            task.wait(waitTime)
                        else 
                            TycoonStatusLbl.Text = "Status: No buttons found."
                            task.wait(1) 
                        end
                    end
                end)
            end
            
            local isFarmActive = (SolaraManager.ActiveFarmState ~= "Off")
            
            if isFarmActive and isCharValid then
                local currentTickFarm = tick()
                local lastCacheUpdate = SolaraManager.LastCacheUpdate
                local timeSinceCache = currentTickFarm - lastCacheUpdate
                
                if timeSinceCache >= 10 then
                    SolaraManager.FarmCache = {}
                    SolaraManager.SpecialCount = 0
                    
                    local wsDescendants = workspace:GetDescendants()
                    
                    for _, wsObj in ipairs(wsDescendants) do
                        local farmStateCheck = SolaraManager.ActiveFarmState
                        if farmStateCheck == "Off" then 
                            break 
                        end
                        
                        local isTree = (wsObj.Name == "LemonTree")
                        if isTree then
                            local treeDescendants = wsObj:GetDescendants()
                            
                            for _, fruitObj in ipairs(treeDescendants) do
                                local isFruit = (fruitObj.Name == "Fruit")
                                
                                if isFruit then
                                    local cPart = fruitObj:FindFirstChild("ClickPart")
                                    
                                    if cPart then
                                        local isBasePart = cPart:IsA("BasePart")
                                        
                                        if isBasePart then
                                            local cDetector = cPart:FindFirstChildOfClass("ClickDetector")
                                            
                                            if cDetector then
                                                local att1 = fruitObj:FindFirstChild("SpecialAttachment")
                                                local att2 = cPart:FindFirstChild("SpecialAttachment")
                                                local isSpecialFruit = (att1 ~= nil) or (att2 ~= nil)
                                                
                                                if isSpecialFruit then 
                                                    local currentSCount = SolaraManager.SpecialCount
                                                    SolaraManager.SpecialCount = currentSCount + 1 
                                                end
                                                
                                                local fData = {}
                                                fData.Part = cPart
                                                fData.Detector = cDetector
                                                fData.Special = isSpecialFruit
                                                
                                                table.insert(SolaraManager.FarmCache, fData)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    local farmTable = SolaraManager.FarmCache
                    table.sort(farmTable, function(a, b) 
                        return a.Special and not b.Special 
                    end)
                    
                    SolaraManager.LastCacheUpdate = tick()
                end
                
                local currentCacheLen = #SolaraManager.FarmCache
                
                if currentCacheLen > 0 then
                    local targetFruitData = table.remove(SolaraManager.FarmCache, 1)
                    local newCacheLen = #SolaraManager.FarmCache
                    local sCount = SolaraManager.SpecialCount
                    
                    local farmString = string.format(
                        "Status: Harvesting (%d left, %d Special)", 
                        newCacheLen, 
                        sCount
                    )
                    
                    FarmStatusLbl.Text = farmString
                    
                    local fruitPart = targetFruitData.Part
                    if fruitPart then
                        local partParent = fruitPart.Parent
                        if partParent then
                            local isSpecial = targetFruitData.Special
                            
                            if isSpecial then 
                                local tempCount = SolaraManager.SpecialCount - 1
                                SolaraManager.SpecialCount = math.max(0, tempCount) 
                            end
                            
                            pcall(function()
                                local currentFarmSpeed = SolaraManager.FarmSpeed
                                local timeCycle = 1 / currentFarmSpeed
                                
                                local fCFrame = fruitPart.CFrame
                                local offsetCFrame = CFrame.new(0, 0, 2.5)
                                local pivotCFrame = fCFrame * offsetCFrame
                                
                                char:PivotTo(pivotCFrame)
                                hrp.Velocity = Vector3.zero
                                
                                local wait1 = math.max(0.15, timeCycle * 0.4)
                                task.wait(wait1)
                                
                                local targetDetector = targetFruitData.Detector
                                if fireclickdetector then 
                                    fireclickdetector(targetDetector) 
                                end
                                
                                local cam = workspace.CurrentCamera
                                cam.CameraType = Enum.CameraType.Scriptable
                                
                                local camPos = cam.CFrame.Position
                                local fruitPos = fruitPart.Position
                                local lookCFrame = CFrame.lookAt(camPos, fruitPos)
                                cam.CFrame = lookCFrame
                                
                                local wait2 = math.max(0.05, timeCycle * 0.4)
                                task.wait(wait2)
                                
                                local vSize = cam.ViewportSize
                                local screenCenter = vSize / 2
                                
                                VirtualUser:Button1Down(screenCenter)
                                task.wait(0.05)
                                VirtualUser:Button1Up(screenCenter)
                                
                                cam.CameraType = Enum.CameraType.Custom
                                
                                local checkHrp = hrp
                                if checkHrp then 
                                    local currentPos = cam.CFrame.Position
                                    local charLook = checkHrp.CFrame.LookVector
                                    local offsetVector = charLook * 10
                                    local targetLookPos = currentPos + offsetVector
                                    
                                    local finalCamCFrame = CFrame.lookAt(currentPos, targetLookPos)
                                    cam.CFrame = finalCamCFrame 
                                end
                                
                                local wait3 = math.max(0.1, timeCycle * 0.2)
                                task.wait(wait3)
                            end)
                        end
                    end
                else 
                    FarmStatusLbl.Text = "Status: Waiting for respawns..." 
                end
            end
        end
        
        local loopDelay = SolaraManager.ClickDelay
        task.wait(loopDelay)
    end
end)

-------------------------------------------------------------------------------
-- 15. ANTI-AFK SYSTÈME
-------------------------------------------------------------------------------
LocalPlayer.Idled:Connect(function() 
    local isAntiAfkOn = SolaraManager.IsAntiAfk
    local isGuiActive = ScreenGui.Parent
    
    if isAntiAfkOn and isGuiActive then 
        VirtualUser:CaptureController()
        
        local blankVector = Vector2.new()
        VirtualUser:ClickButton2(blankVector) 
    end 
end)
