--[[ 
    Leyley's Cheat V6.1 - Premium UI Overhaul Fix
    Complet, aéré, onglets corrigés et scroll Solara
]]--

print("Leyley's Cheat V6.1 loaded")

-------------------------------------------------------------------------------
-- SERVICES GLOBAUX
-------------------------------------------------------------------------------
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-------------------------------------------------------------------------------
-- THEMES ET CONFIGURATION
-------------------------------------------------------------------------------
local Themes = {
    Default = { 
        MainBg = Color3.fromRGB(20, 20, 25), PanelBg = Color3.fromRGB(30, 30, 38), 
        Text = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(90, 130, 255), 
        Success = Color3.fromRGB(60, 180, 90), Danger = Color3.fromRGB(220, 70, 70), 
        Warning = Color3.fromRGB(220, 160, 50), Stroke = Color3.fromRGB(60, 60, 75) 
    },
    Cyberpunk = { 
        MainBg = Color3.fromRGB(15, 10, 25), PanelBg = Color3.fromRGB(25, 15, 40), 
        Text = Color3.fromRGB(255, 255, 0), Accent = Color3.fromRGB(255, 0, 255), 
        Success = Color3.fromRGB(0, 255, 255), Danger = Color3.fromRGB(255, 50, 50), 
        Warning = Color3.fromRGB(255, 150, 0), Stroke = Color3.fromRGB(100, 0, 150) 
    },
    Ruby = { 
        MainBg = Color3.fromRGB(25, 10, 10), PanelBg = Color3.fromRGB(40, 15, 15), 
        Text = Color3.fromRGB(255, 200, 200), Accent = Color3.fromRGB(220, 50, 50), 
        Success = Color3.fromRGB(50, 200, 100), Danger = Color3.fromRGB(180, 30, 30), 
        Warning = Color3.fromRGB(200, 100, 30), Stroke = Color3.fromRGB(150, 40, 40) 
    },
    Synthwave = { 
        MainBg = Color3.fromRGB(30, 15, 45), PanelBg = Color3.fromRGB(45, 25, 70), 
        Text = Color3.fromRGB(255, 150, 220), Accent = Color3.fromRGB(0, 255, 255), 
        Success = Color3.fromRGB(50, 255, 150), Danger = Color3.fromRGB(255, 50, 100), 
        Warning = Color3.fromRGB(255, 180, 0), Stroke = Color3.fromRGB(150, 0, 150) 
    },
    Matrix = { 
        MainBg = Color3.fromRGB(10, 15, 10), PanelBg = Color3.fromRGB(15, 25, 15), 
        Text = Color3.fromRGB(100, 255, 100), Accent = Color3.fromRGB(50, 200, 50), 
        Success = Color3.fromRGB(0, 255, 0), Danger = Color3.fromRGB(200, 50, 50), 
        Warning = Color3.fromRGB(200, 200, 50), Stroke = Color3.fromRGB(30, 100, 30) 
    },
    RoyalGold = { 
        MainBg = Color3.fromRGB(25, 20, 10), PanelBg = Color3.fromRGB(40, 35, 15), 
        Text = Color3.fromRGB(255, 230, 150), Accent = Color3.fromRGB(255, 200, 50), 
        Success = Color3.fromRGB(100, 255, 100), Danger = Color3.fromRGB(255, 80, 80), 
        Warning = Color3.fromRGB(255, 150, 50), Stroke = Color3.fromRGB(150, 120, 40) 
    },
    Amethyst = { 
        MainBg = Color3.fromRGB(20, 10, 30), PanelBg = Color3.fromRGB(35, 15, 50), 
        Text = Color3.fromRGB(230, 200, 255), Accent = Color3.fromRGB(150, 80, 255), 
        Success = Color3.fromRGB(80, 255, 180), Danger = Color3.fromRGB(255, 70, 120), 
        Warning = Color3.fromRGB(255, 170, 50), Stroke = Color3.fromRGB(100, 40, 150) 
    }
}

local SolaraManager = {
    GuiName = "LeyleysCheat_V6",
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
    ActiveAutoUpgrade = false,
    LastUpgradeCheck = 0,
    ClickDelay = 0.1
}

-------------------------------------------------------------------------------
-- SYSTÈME DE PRIX ET SUFFIXES
-------------------------------------------------------------------------------
local SuffixDict = {}

local function GenerateSuffixes()
    local order = {
        "thousand", "million", "billion", "trillion", "quadrillion", 
        "quintillion", "sextillion", "septillion", "octillion", "nonillion"
    }
    
    for i, name in ipairs(order) do
        SuffixDict[name] = i
        SuffixDict[name.."s"] = i
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
        SuffixDict[tName.."s"] = tVal
        for uName, uVal in pairs(unitsPrefix) do
            SuffixDict[uName..tName] = tVal + uVal
            SuffixDict[uName..tName.."s"] = tVal + uVal
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
    if not str then return math.huge end
    str = string.lower(tostring(str))
    
    if string.match(str, "free") or string.match(str, "gratuit") then 
        return 0 
    end
    
    local sciNum = tonumber(str)
    if sciNum then return sciNum end
    
    str = string.gsub(str, "[^%d%.%a]", "") 
    local numStr, suffix = string.match(str, "^([%d%.]+)(%a*)$")
    
    if not numStr then return math.huge end
    
    local num = tonumber(numStr)
    if not num then return math.huge end
    
    if suffix and suffix ~= "" then
        local powerIndex = SuffixDict[suffix]
        if powerIndex then 
            num = num * (10 ^ (powerIndex * 3)) 
        else 
            return math.huge 
        end
    end
    
    return num
end

-------------------------------------------------------------------------------
-- UTILITAIRES D'INTERFACE (UI)
-------------------------------------------------------------------------------
if CoreGui:FindFirstChild(SolaraManager.GuiName) then
    CoreGui[SolaraManager.GuiName]:Destroy()
elseif LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(SolaraManager.GuiName) then
    LocalPlayer.PlayerGui[SolaraManager.GuiName]:Destroy()
end

local function ApplyTween(obj, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

local function TrackTheme(object, themeCategory)
    if themeCategory then 
        table.insert(SolaraManager.ThemeObjects[themeCategory], object) 
    end
end

local function CreateUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function CreateUIStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or SolaraManager.CurrentTheme.Stroke
    stroke.Thickness = thickness or 1
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
    frame.BackgroundColor3 = bgColor or SolaraManager.CurrentTheme.MainBg
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
    label.TextXAlignment = alignment or Enum.TextXAlignment.Center
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
    btn.BackgroundColor3 = bgColor or SolaraManager.CurrentTheme.PanelBg
    btn.TextColor3 = SolaraManager.CurrentTheme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    CreateUICorner(btn, 6)
    local stroke = CreateUIStroke(btn, SolaraManager.CurrentTheme.Stroke, 1)
    
    TrackTheme(btn, themeGroup or "Panels")
    TrackTheme(btn, "Texts")
    
    btn.MouseEnter:Connect(function()
        ApplyTween(btn, {BackgroundTransparency = 0.2}, 0.2)
        ApplyTween(stroke, {Color = SolaraManager.CurrentTheme.Text}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        ApplyTween(btn, {BackgroundTransparency = 0}, 0.2)
        ApplyTween(stroke, {Color = SolaraManager.CurrentTheme.Stroke}, 0.2)
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
    box.TextSize = 14
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
    local dragInput
    local dragStart
    local startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-------------------------------------------------------------------------------
-- CRÉATION DE L'INTERFACE PRINCIPALE
-------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SolaraManager.GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local guiParent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = guiParent

local RestoreBtn = CreateButton(
    ScreenGui, "RestoreBtn", "➕ Open", 
    UDim2.new(0, 80, 0, 40), 
    UDim2.new(0, 20, 1, -60), 
    SolaraManager.CurrentTheme.Accent, 
    "Accents"
)
RestoreBtn.Visible = false
RestoreBtn.ZIndex = 10

local MainFrame = CreateFrame(
    ScreenGui, "MainFrame", 
    UDim2.new(0, 650, 0, 420), 
    UDim2.new(0.5, -325, 0.5, -210), 
    SolaraManager.CurrentTheme.MainBg, 
    "Backgrounds"
)
MainFrame.ClipsDescendants = true
CreateUICorner(MainFrame, 8)
CreateUIStroke(MainFrame, SolaraManager.CurrentTheme.Accent, 2)

local TitleBar = CreateFrame(
    MainFrame, "TitleBar", 
    UDim2.new(1, 0, 0, 40), 
    UDim2.new(0, 0, 0, 0), 
    SolaraManager.CurrentTheme.PanelBg, 
    "Panels"
)
EnableDragging(MainFrame, TitleBar)

local TitleLabel = CreateLabel(
    TitleBar, "TitleLabel", 
    "  ✨ Leyley's Premium Cheat V6", 
    UDim2.new(1, -100, 1, 0), 
    UDim2.new(0, 0, 0, 0), 
    Enum.TextXAlignment.Left
)
TitleLabel.Font = Enum.Font.GothamBold

local CloseBtn = CreateButton(TitleBar, "CloseBtn", "X", UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 5), SolaraManager.CurrentTheme.Danger, nil)
local MinBtn = CreateButton(TitleBar, "MinBtn", "-", UDim2.new(0, 30, 0, 30), UDim2.new(1, -70, 0, 5), SolaraManager.CurrentTheme.Warning, nil)

CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy()
    SolaraManager.IsClicking = false 
end)

MinBtn.MouseButton1Click:Connect(function() 
    ApplyTween(MainFrame, {Size = UDim2.new(0, 650, 0, 0)}, 0.3).Completed:Connect(function()
        MainFrame.Visible = false
        RestoreBtn.Visible = true
        MainFrame.Size = UDim2.new(0, 650, 0, 420)
    end)
end)

RestoreBtn.MouseButton1Click:Connect(function() 
    RestoreBtn.Visible = false
    MainFrame.Size = UDim2.new(0, 650, 0, 0)
    MainFrame.Visible = true
    ApplyTween(MainFrame, {Size = UDim2.new(0, 650, 0, 420)}, 0.4)
end)

-- LE CORRECTIF DU SIDEBAR EST ICI : On sépare les boutons de la ligne verticale
local SidebarContainer = CreateFrame(
    MainFrame, "SidebarContainer", 
    UDim2.new(0, 150, 1, -40), 
    UDim2.new(0, 0, 0, 40), 
    SolaraManager.CurrentTheme.PanelBg, 
    "Panels"
)

local SidebarLine = CreateFrame(
    SidebarContainer, "SidebarLine", 
    UDim2.new(0, 1, 1, 0), 
    UDim2.new(1, -1, 0, 0), 
    SolaraManager.CurrentTheme.Stroke, 
    "Dividers"
)

local SidebarButtonsFrame = Instance.new("Frame")
SidebarButtonsFrame.Name = "SidebarButtons"
SidebarButtonsFrame.Size = UDim2.new(1, -1, 1, 0)
SidebarButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
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

local ContentArea = CreateFrame(
    MainFrame, "ContentArea", 
    UDim2.new(1, -150, 1, -40), 
    UDim2.new(0, 150, 0, 40), 
    SolaraManager.CurrentTheme.MainBg, 
    "Backgrounds"
)

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = ContentArea
ContentPadding.PaddingTop = UDim.new(0, 15)
ContentPadding.PaddingBottom = UDim.new(0, 15)
ContentPadding.PaddingLeft = UDim.new(0, 15)
ContentPadding.PaddingRight = UDim.new(0, 15)

-------------------------------------------------------------------------------
-- SYSTÈME D'ONGLETS
-------------------------------------------------------------------------------
local TabButtons = {}
local Pages = {}

local function SwitchTab(tabName)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
    
    for name, btn in pairs(TabButtons) do
        if name == tabName then
            ApplyTween(btn, {BackgroundColor3 = SolaraManager.CurrentTheme.Accent}, 0.2)
        else
            ApplyTween(btn, {BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg}, 0.2)
        end
    end
    
    SolaraManager.ActiveTab = tabName
end

local function BuildPage(name, icon, order)
    local btn = CreateButton(SidebarButtonsFrame, name.."Tab", icon .. " " .. name, UDim2.new(1, 0, 0, 35), UDim2.new(), nil, "Panels")
    btn.LayoutOrder = order
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local btnPadding = Instance.new("UIPadding", btn)
    btnPadding.PaddingLeft = UDim.new(0, 10)
    
    local page = Instance.new("ScrollingFrame")
    page.Name = name.."Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.BorderSizePixel = 0
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = ContentArea
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 10)
    
    TabButtons[name] = btn
    Pages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
    
    return page
end

-------------------------------------------------------------------------------
-- PAGE 1 : PLAYER
-------------------------------------------------------------------------------
local PlayerPage = BuildPage("Player", "👤", 1)

CreateLabel(PlayerPage, "PlayerTitle", "PLAYER MODIFIERS", UDim2.new(1, 0, 0, 25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1

local ClickRow = CreateFrame(PlayerPage, "ClickRow", UDim2.new(1, 0, 0, 45), UDim2.new(), nil, "Backgrounds")
ClickRow.BackgroundTransparency = 1
ClickRow.LayoutOrder = 2

local ClickToggle = CreateButton(ClickRow, "ClickToggle", "Auto Clicker: OFF", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0), SolaraManager.CurrentTheme.Danger)
local AfkToggle = CreateButton(ClickRow, "AfkToggle", "Anti-AFK: OFF", UDim2.new(0.48, 0, 1, 0), UDim2.new(0.52, 0, 0, 0), SolaraManager.CurrentTheme.Danger)

ClickToggle.MouseButton1Click:Connect(function() 
    SolaraManager.IsClicking = not SolaraManager.IsClicking
    ClickToggle.Text = SolaraManager.IsClicking and "Auto Clicker: ON" or "Auto Clicker: OFF"
    ApplyTween(ClickToggle, {BackgroundColor3 = SolaraManager.IsClicking and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger}) 
end)

AfkToggle.MouseButton1Click:Connect(function() 
    SolaraManager.IsAntiAfk = not SolaraManager.IsAntiAfk
    AfkToggle.Text = SolaraManager.IsAntiAfk and "Anti-AFK: ON" or "Anti-AFK: OFF"
    ApplyTween(AfkToggle, {BackgroundColor3 = SolaraManager.IsAntiAfk and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger}) 
end)

CreateLabel(PlayerPage, "StatsTitle", "STAT OVERRIDES", UDim2.new(1, 0, 0, 25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 3

local SpeedRow = CreateFrame(PlayerPage, "SpeedRow", UDim2.new(1, 0, 0, 40), UDim2.new(), nil, "Backgrounds")
SpeedRow.BackgroundTransparency = 1
SpeedRow.LayoutOrder = 4

local SpeedInput = CreateInput(SpeedRow, "SpeedInput", "WalkSpeed (e.g. 50)", UDim2.new(0.65, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local SpeedBtn = CreateButton(SpeedRow, "SpeedBtn", "Apply", UDim2.new(0.3, 0, 1, 0), UDim2.new(0.7, 0, 0, 0), SolaraManager.CurrentTheme.Accent)

SpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then 
        SolaraManager.SpeedOverride = val
        SpeedBtn.Text = "Applied" 
    else 
        SolaraManager.SpeedOverride = nil
        SpeedBtn.Text = "Reset" 
    end
end)

local JumpRow = CreateFrame(PlayerPage, "JumpRow", UDim2.new(1, 0, 0, 40), UDim2.new(), nil, "Backgrounds")
JumpRow.BackgroundTransparency = 1
JumpRow.LayoutOrder = 5

local JumpInput = CreateInput(JumpRow, "JumpInput", "JumpPower (e.g. 100)", UDim2.new(0.65, 0, 1, 0), UDim2.new(0, 0, 0, 0))
local JumpBtn = CreateButton(JumpRow, "JumpBtn", "Apply", UDim2.new(0.3, 0, 1, 0), UDim2.new(0.7, 0, 0, 0), SolaraManager.CurrentTheme.Accent)

JumpBtn.MouseButton1Click:Connect(function()
    local val = tonumber(JumpInput.Text)
    if val then 
        SolaraManager.JumpOverride = val
        JumpBtn.Text = "Applied" 
    else 
        SolaraManager.JumpOverride = nil
        JumpBtn.Text = "Reset" 
    end
end)

-------------------------------------------------------------------------------
-- PAGE 2 : TELEPORT
-------------------------------------------------------------------------------
local TeleportPage = BuildPage("Teleport", "🌍", 2)

local SelectedLabel = CreateLabel(TeleportPage, "SelectedLabel", "Selected: None", UDim2.new(1, 0, 0, 25), UDim2.new(), Enum.TextXAlignment.Left)
SelectedLabel.LayoutOrder = 1

local TpBtn = CreateButton(TeleportPage, "TpBtn", "TELEPORT TO PLAYER", UDim2.new(1, 0, 0, 40), UDim2.new(), SolaraManager.CurrentTheme.Accent)
TpBtn.LayoutOrder = 2

TpBtn.MouseButton1Click:Connect(function() 
    if SolaraManager.SelectedTarget and SolaraManager.SelectedTarget.Character and LocalPlayer.Character then 
        LocalPlayer.Character:PivotTo(SolaraManager.SelectedTarget.Character:GetPivot()) 
    end 
end)

local PlayerListFrame = CreateFrame(TeleportPage, "PlayerListFrame", UDim2.new(1, 0, 0, 200), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels")
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
    for _, c in ipairs(PList:GetChildren()) do 
        if c:IsA("TextButton") then c:Destroy() end 
    end
    
    local players = Players:GetPlayers()
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    for _, p in ipairs(players) do
        if p ~= LocalPlayer then
            local btn = CreateButton(PList, "PBtn", p.Name, UDim2.new(1, -5, 0, 30), UDim2.new(), SolaraManager.CurrentTheme.MainBg, "Backgrounds")
            btn.MouseButton1Click:Connect(function() 
                SolaraManager.SelectedTarget = p
                SelectedLabel.Text = "Selected: " .. p.Name 
            end)
        end
    end
end

Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)
UpdatePlayers()

-------------------------------------------------------------------------------
-- PAGE 3 : EXPLORER (DEX)
-------------------------------------------------------------------------------
local ExplorerPage = BuildPage("Explorer", "🔍", 3)

CreateLabel(ExplorerPage, "DexDesc", "Load Dark Dex V3 to view the game's file structure. Useful for finding hidden items.", UDim2.new(1, 0, 0, 40), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1

local DexBtn = CreateButton(ExplorerPage, "DexBtn", "Launch Dex Explorer", UDim2.new(1, 0, 0, 50), UDim2.new(), Color3.fromRGB(130, 50, 200))
DexBtn.LayoutOrder = 2

DexBtn.MouseButton1Click:Connect(function()
    DexBtn.Text = "Loading Dex..."
    task.spawn(function()
        local s, e = pcall(function() 
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() 
        end)
        if s then 
            DexBtn.Text = "Dex Launched!"
            ApplyTween(DexBtn, {BackgroundColor3 = SolaraManager.CurrentTheme.Success})
        else 
            DexBtn.Text = "Failed to load!"
            ApplyTween(DexBtn, {BackgroundColor3 = SolaraManager.CurrentTheme.Danger}) 
        end
        task.wait(2)
        DexBtn.Text = "Launch Dex Explorer"
        ApplyTween(DexBtn, {BackgroundColor3 = Color3.fromRGB(130, 50, 200)})
    end)
end)

-------------------------------------------------------------------------------
-- PAGE 4 : SETTINGS (THEMES)
-------------------------------------------------------------------------------
local SettingsPage = BuildPage("Settings", "⚙️", 4)

CreateLabel(SettingsPage, "ThemeTitle", "SELECT A THEME", UDim2.new(1, 0, 0, 25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1

local ThemeGrid = Instance.new("Frame")
ThemeGrid.Size = UDim2.new(1, 0, 0, 300)
ThemeGrid.BackgroundTransparency = 1
ThemeGrid.LayoutOrder = 2
ThemeGrid.Parent = SettingsPage

local GridLayout = Instance.new("UIGridLayout")
GridLayout.Parent = ThemeGrid
GridLayout.CellSize = UDim2.new(0.48, 0, 0, 40)
GridLayout.CellPadding = UDim2.new(0.04, 0, 0, 10)
GridLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function UpdateTheme(themeName)
    local newTheme = Themes[themeName]
    if not newTheme then return end
    SolaraManager.CurrentTheme = newTheme
    
    for _, bg in ipairs(SolaraManager.ThemeObjects.Backgrounds) do 
        if bg and bg.Parent then ApplyTween(bg, {BackgroundColor3 = newTheme.MainBg}, 0.5) end
    end
    for _, pnl in ipairs(SolaraManager.ThemeObjects.Panels) do 
        if pnl and pnl.Parent then ApplyTween(pnl, {BackgroundColor3 = newTheme.PanelBg}, 0.5) end
    end
    for _, acc in ipairs(SolaraManager.ThemeObjects.Accents) do 
        if acc and acc.Parent then ApplyTween(acc, {BackgroundColor3 = newTheme.Accent}, 0.5) end
    end
    for _, strk in ipairs(SolaraManager.ThemeObjects.Strokes) do 
        if strk and strk.Parent then ApplyTween(strk, {Color = newTheme.Stroke}, 0.5) end
    end
    for _, div in ipairs(SolaraManager.ThemeObjects.Dividers) do 
        if div and div.Parent then ApplyTween(div, {BackgroundColor3 = newTheme.Stroke}, 0.5) end
    end
    for _, txt in ipairs(SolaraManager.ThemeObjects.Texts) do 
        if txt and txt.Parent then ApplyTween(txt, {TextColor3 = newTheme.Text}, 0.5) end
    end
    
    for tabName, btn in pairs(TabButtons) do
        if tabName == SolaraManager.ActiveTab then
            ApplyTween(btn, {BackgroundColor3 = newTheme.Accent}, 0.5)
        else
            ApplyTween(btn, {BackgroundColor3 = newTheme.PanelBg}, 0.5)
        end
    end
    
    local mainFrameStroke = MainFrame:FindFirstChildOfClass("UIStroke")
    if mainFrameStroke then
        ApplyTween(mainFrameStroke, {Color = newTheme.Accent}, 0.5)
    end
end

local themeOrder = 1
for themeName, _ in pairs(Themes) do
    local btn = CreateButton(ThemeGrid, themeName.."ThemeBtn", themeName, UDim2.new(0, 100, 0, 40), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels")
    btn.LayoutOrder = themeOrder
    themeOrder = themeOrder + 1
    
    btn.MouseButton1Click:Connect(function()
        UpdateTheme(themeName)
    end)
end

-------------------------------------------------------------------------------
-- PAGE 5 : GAMES (SELL LEMONS)
-------------------------------------------------------------------------------
local GamePage = BuildPage("Game", "🎮", 5)

local GameContainer = Instance.new("Frame")
GameContainer.Size = UDim2.new(1, 0, 1, 0)
GameContainer.BackgroundTransparency = 1
GameContainer.Parent = GamePage

local GameTabsLayout = Instance.new("UIListLayout")
GameTabsLayout.Parent = GameContainer
GameTabsLayout.FillDirection = Enum.FillDirection.Horizontal
GameTabsLayout.Padding = UDim.new(0, 10)

local GameSelector = CreateFrame(GameContainer, "GameSelector", UDim2.new(0.35, 0, 0, 300), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels")
CreateUICorner(GameSelector, 6)
CreateUIStroke(GameSelector, SolaraManager.CurrentTheme.Stroke, 1)

local SelectorLayout = Instance.new("UIListLayout")
SelectorLayout.Parent = GameSelector
SelectorLayout.Padding = UDim.new(0, 5)

local GameContent = Instance.new("Frame")
GameContent.Size = UDim2.new(0.65, -10, 0, 300)
GameContent.BackgroundTransparency = 1
GameContent.Parent = GameContainer

local SellLemonsScroll = Instance.new("ScrollingFrame")
SellLemonsScroll.Size = UDim2.new(1, 0, 1, 0)
SellLemonsScroll.BackgroundTransparency = 1
SellLemonsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SellLemonsScroll.ScrollBarThickness = 4
SellLemonsScroll.Parent = GameContent

local LemonsLayout = Instance.new("UIListLayout")
LemonsLayout.Parent = SellLemonsScroll
LemonsLayout.Padding = UDim.new(0, 8)

CreateLabel(SellLemonsScroll, "FarmTitle", "🍋 AUTO FARM", UDim2.new(1, 0, 0, 25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1
local FarmStatusLbl = CreateLabel(SellLemonsScroll, "FarmStatus", "Status: Idle", UDim2.new(1, 0, 0, 15), UDim2.new(), Enum.TextXAlignment.Left)
FarmStatusLbl.TextSize = 12
FarmStatusLbl.LayoutOrder = 2

local FarmSpeedRow = Instance.new("Frame")
FarmSpeedRow.Size = UDim2.new(1, 0, 0, 35)
FarmSpeedRow.BackgroundTransparency = 1
FarmSpeedRow.LayoutOrder = 3
FarmSpeedRow.Parent = SellLemonsScroll

local FarmSpeedInput = CreateInput(FarmSpeedRow, "FarmSpeed", "Speed (1-4)", UDim2.new(0.6, 0, 1, 0), UDim2.new())
local FarmSpeedBtn = CreateButton(FarmSpeedRow, "FarmSet", "Set", UDim2.new(0.35, 0, 1, 0), UDim2.new(0.65, 0, 0, 0), SolaraManager.CurrentTheme.Accent)

local FarmActionRow = Instance.new("Frame")
FarmActionRow.Size = UDim2.new(1, 0, 0, 35)
FarmActionRow.BackgroundTransparency = 1
FarmActionRow.LayoutOrder = 4
FarmActionRow.Parent = SellLemonsScroll

local FarmBtn = CreateButton(FarmActionRow, "FarmBtn", "Normal Farm", UDim2.new(0.48, 0, 1, 0), UDim2.new(), SolaraManager.CurrentTheme.Danger)
local SafeFarmBtn = CreateButton(FarmActionRow, "SafeFarmBtn", "Safe Farm", UDim2.new(0.48, 0, 1, 0), UDim2.new(0.52, 0, 0, 0), SolaraManager.CurrentTheme.Danger)

local div1 = CreateFrame(SellLemonsScroll, "Div1", UDim2.new(1, 0, 0, 2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers")
div1.LayoutOrder = 5

CreateLabel(SellLemonsScroll, "TycoonTitle", "🏭 TYCOON BUY", UDim2.new(1, 0, 0, 25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 6
local TycoonStatusLbl = CreateLabel(SellLemonsScroll, "TycoonStatus", "Status: Idle", UDim2.new(1, 0, 0, 15), UDim2.new(), Enum.TextXAlignment.Left)
TycoonStatusLbl.TextSize = 12
TycoonStatusLbl.LayoutOrder = 7

local BuySpeedRow = Instance.new("Frame")
BuySpeedRow.Size = UDim2.new(1, 0, 0, 35)
BuySpeedRow.BackgroundTransparency = 1
BuySpeedRow.LayoutOrder = 8
BuySpeedRow.Parent = SellLemonsScroll

local BuySpeedInput = CreateInput(BuySpeedRow, "BuySpeed", "Speed (1-10)", UDim2.new(0.6, 0, 1, 0), UDim2.new())
local BuySpeedBtn = CreateButton(BuySpeedRow, "BuySet", "Set", UDim2.new(0.35, 0, 1, 0), UDim2.new(0.65, 0, 0, 0), SolaraManager.CurrentTheme.Accent)

local BuyActionRow = Instance.new("Frame")
BuyActionRow.Size = UDim2.new(1, 0, 0, 35)
BuyActionRow.BackgroundTransparency = 1
BuyActionRow.LayoutOrder = 9
BuyActionRow.Parent = SellLemonsScroll

local AutoBuyBtn = CreateButton(BuyActionRow, "AutoBuyBtn", "Auto Buy", UDim2.new(0.48, 0, 1, 0), UDim2.new(), SolaraManager.CurrentTheme.Danger)
local SafeBuyBtn = CreateButton(BuyActionRow, "SafeBuyBtn", "Safe Buy", UDim2.new(0.48, 0, 1, 0), UDim2.new(0.52, 0, 0, 0), SolaraManager.CurrentTheme.Danger)

local div2 = CreateFrame(SellLemonsScroll, "Div2", UDim2.new(1, 0, 0, 2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers")
div2.LayoutOrder = 10

CreateLabel(SellLemonsScroll, "UpgradeTitle", "📈 AUTO UPGRADE", UDim2.new(1, 0, 0, 25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 11
local CashStatusLbl = CreateLabel(SellLemonsScroll, "CashStatus", "Cash: $0", UDim2.new(1, 0, 0, 15), UDim2.new(), Enum.TextXAlignment.Left)
CashStatusLbl.TextSize = 12
CashStatusLbl.TextColor3 = SolaraManager.CurrentTheme.Success
CashStatusLbl.LayoutOrder = 12

local AutoUpgradeBtn = CreateButton(SellLemonsScroll, "AutoUpgradeBtn", "Auto Upgrade: OFF", UDim2.new(1, 0, 0, 40), UDim2.new(), SolaraManager.CurrentTheme.Danger)
AutoUpgradeBtn.LayoutOrder = 13

local function UpdateGameUI()
    FarmBtn.BackgroundColor3 = (SolaraManager.ActiveFarmState == "Normal") and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger
    SafeFarmBtn.BackgroundColor3 = (SolaraManager.ActiveFarmState == "Safe") and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger
    AutoBuyBtn.BackgroundColor3 = (SolaraManager.ActiveBuyState == "Normal") and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger
    SafeBuyBtn.BackgroundColor3 = (SolaraManager.ActiveBuyState == "Safe") and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger
    AutoUpgradeBtn.BackgroundColor3 = SolaraManager.ActiveAutoUpgrade and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger
    AutoUpgradeBtn.Text = SolaraManager.ActiveAutoUpgrade and "Auto Upgrade: ON" or "Auto Upgrade: OFF"
    
    if SolaraManager.ActiveFarmState == "Off" then
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        FarmStatusLbl.Text = "Status: Idle"
    end
    if SolaraManager.ActiveBuyState == "Off" then
        TycoonStatusLbl.Text = "Status: Idle"
    end
end

FarmSpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FarmSpeedInput.Text)
    if val and val > 0 then
        SolaraManager.FarmSpeed = math.min(val, 4)
        FarmSpeedBtn.Text = tostring(SolaraManager.FarmSpeed)
    end
end)

BuySpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(BuySpeedInput.Text)
    if val and val > 0 then
        SolaraManager.BuySpeed = math.min(val, 10)
        BuySpeedBtn.Text = tostring(SolaraManager.BuySpeed)
    end
end)

FarmBtn.MouseButton1Click:Connect(function()
    SolaraManager.ActiveFarmState = (SolaraManager.ActiveFarmState == "Normal") and "Off" or "Normal"
    if SolaraManager.ActiveFarmState == "Normal" then SolaraManager.ActiveBuyState = "Off" end
    UpdateGameUI()
end)

SafeFarmBtn.MouseButton1Click:Connect(function()
    SolaraManager.ActiveFarmState = (SolaraManager.ActiveFarmState == "Safe") and "Off" or "Safe"
    if SolaraManager.ActiveFarmState == "Safe" then SolaraManager.ActiveBuyState = "Off" end
    SolaraManager.HasSafetyRespawned = false
    UpdateGameUI()
end)

AutoBuyBtn.MouseButton1Click:Connect(function()
    SolaraManager.ActiveBuyState = (SolaraManager.ActiveBuyState == "Normal") and "Off" or "Normal"
    if SolaraManager.ActiveBuyState == "Normal" then SolaraManager.ActiveFarmState = "Off" end
    UpdateGameUI()
end)

SafeBuyBtn.MouseButton1Click:Connect(function()
    SolaraManager.ActiveBuyState = (SolaraManager.ActiveBuyState == "Safe") and "Off" or "Safe"
    if SolaraManager.ActiveBuyState == "Safe" then SolaraManager.ActiveFarmState = "Off" end
    SolaraManager.HasSafetyRespawned = false
    UpdateGameUI()
end)

AutoUpgradeBtn.MouseButton1Click:Connect(function()
    SolaraManager.ActiveAutoUpgrade = not SolaraManager.ActiveAutoUpgrade
    UpdateGameUI()
end)

local Game1Btn = CreateButton(GameSelector, "Game1Btn", "Sell Lemons", UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 5), nil, "Panels")
local Game2Btn = CreateButton(GameSelector, "Game2Btn", "Coming Soon", UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 45), nil, "Panels")

-------------------------------------------------------------------------------
-- INITIALISATION
-------------------------------------------------------------------------------
SwitchTab("Player")

-------------------------------------------------------------------------------
-- BOUCLE PRINCIPALE (RUNSERVICE)
-------------------------------------------------------------------------------
task.spawn(function()
    while ScreenGui.Parent do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hum then
            if SolaraManager.SpeedOverride then hum.WalkSpeed = SolaraManager.SpeedOverride end
            if SolaraManager.JumpOverride then 
                hum.UseJumpPower = true
                hum.JumpPower = SolaraManager.JumpOverride 
            end
        end
        
        if SolaraManager.IsClicking then
            pcall(function() 
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end 
            end)
        end
        
        local currentCashNum = 0
        pcall(function()
            local cashLbl = LocalPlayer.PlayerGui:FindFirstChild("HUD").Balance.Main.Cash
            if cashLbl and cashLbl:IsA("TextLabel") then
                local txt = cashLbl.Text
                CashStatusLbl.Text = "Cash: " .. txt
                local parsed = ParsePrice(txt)
                if parsed ~= math.huge then currentCashNum = parsed end
            end
        end)
        
        if SolaraManager.ActiveAutoUpgrade then
            local manageMenuVisible = false
            pcall(function()
                local manageMenu = LocalPlayer.PlayerGui:FindFirstChild("Manage")
                if manageMenu and manageMenu:FindFirstChild("ManageMenu") then 
                    manageMenuVisible = manageMenu.ManageMenu.Visible 
                end
            end)

            if not manageMenuVisible then
                SolaraManager.ActiveAutoUpgrade = false
                UpdateGameUI()
            else
                if tick() - SolaraManager.LastUpgradeCheck >= 1.5 then 
                    SolaraManager.LastUpgradeCheck = tick()
                    pcall(function()
                        local manageMenu = LocalPlayer.PlayerGui:FindFirstChild("Manage")
                        if manageMenu then
                            local manageFrame = manageMenu.ManageMenu.Body.Frame.Manage
                            for _, child in ipairs(manageFrame:GetChildren()) do
                                if string.match(child.Name, "^Lemon") then
                                    local upgradeBtn = child:FindFirstChild("Upgrade", true)
                                    
                                    if upgradeBtn and upgradeBtn:IsA("GuiButton") then
                                        local priceNum = math.huge
                                        local priceObj = upgradeBtn:FindFirstChild("Price")
                                        
                                        if priceObj and (priceObj:IsA("TextLabel") or priceObj:IsA("TextBox")) then
                                            local p = ParsePrice(priceObj.Text)
                                            if p ~= math.huge then priceNum = p end
                                        end
                                        
                                        if currentCashNum > 0 and currentCashNum >= priceNum then
                                            if manageFrame:IsA("ScrollingFrame") then
                                                local scrollTarget = child.AbsolutePosition.Y - manageFrame.AbsolutePosition.Y + manageFrame.CanvasPosition.Y - (manageFrame.AbsoluteSize.Y / 2) + (child.AbsoluteSize.Y / 2)
                                                manageFrame.CanvasPosition = Vector2.new(0, scrollTarget)
                                            end
                                            
                                            task.wait(0.1)
                                            
                                            local absPos = upgradeBtn.AbsolutePosition
                                            local absSize = upgradeBtn.AbsoluteSize
                                            
                                            if absPos.X > 0 and absPos.Y > 0 then
                                                local topBarOffset = 36
                                                local x = absPos.X + (absSize.X / 2)
                                                local y = absPos.Y + (absSize.Y / 2) + topBarOffset
                                                
                                                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
                                                task.wait(0.05)
                                                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
                                            end
                                            task.wait(0.2)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
        
        local otherPlayersPresent = #Players:GetPlayers() > 1
        local safeModePaused = false
        
        if otherPlayersPresent then
            if SolaraManager.ActiveFarmState == "Safe" or SolaraManager.ActiveBuyState == "Safe" then
                safeModePaused = true
                if not SolaraManager.HasSafetyRespawned then
                    if char and hrp then 
                        char:PivotTo(CFrame.new(0, 103.010009765625, 0))
                        hrp.Velocity = Vector3.zero
                        hrp.RotVelocity = Vector3.zero 
                    end
                    SolaraManager.HasSafetyRespawned = true
                end
                
                if SolaraManager.ActiveFarmState == "Safe" then FarmStatusLbl.Text = "Status: PAUSED (Player in server)" end
                if SolaraManager.ActiveBuyState == "Safe" then TycoonStatusLbl.Text = "Status: PAUSED (Player in server)" end
            end
        else 
            SolaraManager.HasSafetyRespawned = false 
        end
        
        if not safeModePaused then
            if SolaraManager.ActiveBuyState ~= "Off" and char and hrp then
                pcall(function()
                    if not SolaraManager.MyTycoon then
                        TycoonStatusLbl.Text = "Status: Searching for Tycoon..."
                        for _, folder in ipairs(workspace:GetChildren()) do
                            local ownerVal = folder:FindFirstChild("Owner")
                            if ownerVal then
                                local currentOwner = ""
                                if ownerVal:IsA("ObjectValue") and ownerVal.Value then 
                                    currentOwner = ownerVal.Value.Name 
                                elseif ownerVal:IsA("StringValue") then 
                                    currentOwner = ownerVal.Value 
                                end
                                
                                if string.lower(currentOwner) == string.lower(LocalPlayer.Name) then 
                                    SolaraManager.MyTycoon = folder
                                    break 
                                end
                            end
                        end
                    end
                    
                    if SolaraManager.MyTycoon then
                        TycoonStatusLbl.Text = "Status: Scanning buttons..."
                        local purchasesFolder = SolaraManager.MyTycoon:FindFirstChild("Purchases")
                        local buttonsToBuy = {}
                        local targetCats = {Structure = true, Other = true, Multiplier = true, Multipliers = true}
                        
                        local function ProcessButtonModel(bModel)
                            if not bModel then return end
                            local bPart = bModel:FindFirstChild("Button")
                            if bPart and bPart:IsA("BasePart") then
                                local guiFolder = bPart:FindFirstChild("Gui") or bModel:FindFirstChild("Gui")
                                if guiFolder then
                                    local priceObj = guiFolder:FindFirstChild("Price")
                                    if priceObj then
                                        local rawPrice = (priceObj:IsA("ValueBase")) and tostring(priceObj.Value) or priceObj.Text
                                        local magObj = guiFolder:FindFirstChild("PriceMag")
                                        if magObj then
                                            rawPrice = rawPrice .. ((magObj:IsA("ValueBase")) and tostring(magObj.Value) or magObj.Text)
                                        end
                                        local numPrice = ParsePrice(rawPrice)
                                        if numPrice >= 0 and numPrice ~= math.huge then 
                                            table.insert(buttonsToBuy, { Part = bPart, Price = numPrice, RawText = rawPrice }) 
                                        end
                                    end
                                end
                            end
                        end

                        if purchasesFolder then
                            for _, sFolder in ipairs(purchasesFolder:GetChildren()) do
                                local btnFolder = sFolder:FindFirstChild("Buttons")
                                if btnFolder then
                                    for _, child in ipairs(btnFolder:GetChildren()) do
                                        if targetCats[child.Name] then 
                                            for _, bModel in ipairs(child:GetChildren()) do ProcessButtonModel(bModel) end 
                                        elseif child:IsA("Model") then 
                                            ProcessButtonModel(child) 
                                        end
                                    end
                                end
                                if sFolder.Name == "Hills" then 
                                    for _, desc in ipairs(sFolder:GetDescendants()) do 
                                        if desc:IsA("Model") and desc:FindFirstChild("Button") then ProcessButtonModel(desc) end 
                                    end 
                                end
                            end
                        end
                        
                        if #buttonsToBuy > 0 then
                            table.sort(buttonsToBuy, function(a, b) return a.Price < b.Price end)
                            local targetButton = buttonsToBuy[1]
                            TycoonStatusLbl.Text = "Status: Buying (" .. targetButton.RawText .. ")"
                            
                            char:PivotTo(targetButton.Part.CFrame * CFrame.new(0, 1, 0))
                            hrp.Velocity = Vector3.zero
                            hrp.RotVelocity = Vector3.zero
                            task.wait(1 / SolaraManager.BuySpeed)
                        else 
                            TycoonStatusLbl.Text = "Status: No buttons found."
                            task.wait(1) 
                        end
                    end
                end)
            end
            
            if SolaraManager.ActiveFarmState ~= "Off" and char and hrp then
                if tick() - SolaraManager.LastCacheUpdate >= 10 then
                    SolaraManager.FarmCache = {}
                    SolaraManager.SpecialCount = 0
                    
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if SolaraManager.ActiveFarmState == "Off" then break end
                        if obj.Name == "LemonTree" then
                            for _, fruit in ipairs(obj:GetDescendants()) do
                                if fruit.Name == "Fruit" then
                                    local clickPart = fruit:FindFirstChild("ClickPart")
                                    if clickPart and clickPart:IsA("BasePart") then
                                        local cd = clickPart:FindFirstChildOfClass("ClickDetector")
                                        if cd then
                                            local isSpecial = (fruit:FindFirstChild("SpecialAttachment") ~= nil) or (clickPart:FindFirstChild("SpecialAttachment") ~= nil)
                                            if isSpecial then SolaraManager.SpecialCount = SolaraManager.SpecialCount + 1 end
                                            table.insert(SolaraManager.FarmCache, {Part = clickPart, Detector = cd, Special = isSpecial})
                                        end
                                    end
                                end
                            end
                        end
                    end
                    table.sort(SolaraManager.FarmCache, function(a, b) return a.Special and not b.Special end)
                    SolaraManager.LastCacheUpdate = tick()
                end
                
                if #SolaraManager.FarmCache > 0 then
                    local currentFruit = table.remove(SolaraManager.FarmCache, 1) 
                    FarmStatusLbl.Text = string.format("Status: Harvesting (%d left)", #SolaraManager.FarmCache)
                    
                    if currentFruit.Part and currentFruit.Part.Parent then
                        pcall(function()
                            local tCycle = 1 / SolaraManager.FarmSpeed
                            char:PivotTo(currentFruit.Part.CFrame * CFrame.new(0, 0, 2.5))
                            hrp.Velocity = Vector3.zero
                            task.wait(math.max(0.15, tCycle * 0.4)) 
                            
                            if fireclickdetector then fireclickdetector(currentFruit.Detector) end
                            
                            local cam = workspace.CurrentCamera
                            cam.CameraType = Enum.CameraType.Scriptable
                            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, currentFruit.Part.Position)
                            task.wait(math.max(0.05, tCycle * 0.4))
                            
                            local screenCenter = cam.ViewportSize / 2
                            VirtualUser:Button1Down(screenCenter)
                            task.wait(0.05)
                            VirtualUser:Button1Up(screenCenter)
                            
                            cam.CameraType = Enum.CameraType.Custom
                            if hrp then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + hrp.CFrame.LookVector * 10) end
                            task.wait(math.max(0.1, tCycle * 0.2))
                        end)
                    end
                else 
                    FarmStatusLbl.Text = "Status: Waiting for respawns..." 
                end
            end
        end
        
        task.wait(SolaraManager.ClickDelay)
    end
end)

LocalPlayer.Idled:Connect(function() 
    if SolaraManager.IsAntiAfk and ScreenGui.Parent then 
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new()) 
    end 
end)
