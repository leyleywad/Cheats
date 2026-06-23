--[[ Leyley's cheat V5.1 ]]--

print("Leyley's cheat V5.1 loaded")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Themes = {
    Default = { MainBg = Color3.fromRGB(20, 20, 25), PanelBg = Color3.fromRGB(30, 30, 38), Text = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(90, 130, 255), Success = Color3.fromRGB(60, 180, 90), Danger = Color3.fromRGB(220, 70, 70), Warning = Color3.fromRGB(220, 160, 50), Stroke = Color3.fromRGB(50, 50, 60) },
    Cyberpunk = { MainBg = Color3.fromRGB(15, 10, 25), PanelBg = Color3.fromRGB(25, 15, 40), Text = Color3.fromRGB(255, 255, 0), Accent = Color3.fromRGB(255, 0, 255), Success = Color3.fromRGB(0, 255, 255), Danger = Color3.fromRGB(255, 50, 50), Warning = Color3.fromRGB(255, 150, 0), Stroke = Color3.fromRGB(0, 255, 255) },
    Ruby = { MainBg = Color3.fromRGB(25, 10, 10), PanelBg = Color3.fromRGB(40, 15, 15), Text = Color3.fromRGB(255, 200, 200), Accent = Color3.fromRGB(220, 50, 50), Success = Color3.fromRGB(50, 200, 100), Danger = Color3.fromRGB(180, 30, 30), Warning = Color3.fromRGB(200, 100, 30), Stroke = Color3.fromRGB(150, 40, 40) }
}

local SuffixDict = {}

local function GenerateSuffixes()
    local order = {"thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion", "octillion", "nonillion"}
    for i, name in ipairs(order) do
        SuffixDict[name] = i 
        SuffixDict[name.."s"] = i -- Gère les pluriels
    end
    
    -- Assignation directe et précise des dizaines
    local tensDict = {
        ["decillion"] = 11, ["vigintillion"] = 21, ["trigintillion"] = 31, 
        ["quadragintillion"] = 41, ["quinquagintillion"] = 51, 
        ["sexagintillion"] = 61, ["septuagintillion"] = 71, 
        ["octogintillion"] = 81, ["nonagintillion"] = 91
    }
    
    -- Toutes les variantes orthographiques possibles pour les unités
    local unitsPrefix = {
        ["un"] = 1, ["duo"] = 2, ["tre"] = 3, ["tres"] = 3, 
        ["quattuor"] = 4, ["quattuo"] = 4, ["quin"] = 5, ["quinqua"] = 5,
        ["sex"] = 6, ["ses"] = 6, ["septen"] = 7, ["septem"] = 7, ["sept"] = 7, 
        ["octo"] = 8, ["novem"] = 9, ["noven"] = 9
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
    
    -- Raccourcis classiques
    SuffixDict["k"] = 1; SuffixDict["m"] = 2; SuffixDict["b"] = 3; SuffixDict["t"] = 4
end

GenerateSuffixes()

local function ParsePrice(str)
    if not str then return math.huge end
    str = string.lower(tostring(str))
    
    if string.match(str, "free") or string.match(str, "gratuit") then 
        return 0 
    end
    
    -- Test si le jeu utilise la vraie notation scientifique (ex: 1.5e24)
    local sciNum = tonumber(str)
    if sciNum then return sciNum end
    
    -- Nettoyage absolu : on retire tout ce qui n'est pas chiffre, point ou lettre
    str = string.gsub(str, "[^%d%.%a]", "") 
    
    -- Extraction stricte du chiffre et du suffixe
    local numStr, suffix = string.match(str, "^([%d%.]+)(%a*)$")
    
    if not numStr then 
        warn("[AutoBuy] PRIX IGNORE (Aucun chiffre détecté) : '" .. tostring(str) .. "'")
        return math.huge
    end
    
    local num = tonumber(numStr)
    if not num then return math.huge end
    
    if suffix and suffix ~= "" then
        local powerIndex = SuffixDict[suffix]
        if powerIndex then
            num = num * (10 ^ (powerIndex * 3))
        else
            warn("[AutoBuy] SUFFIXE INCONNU (Prix ignoré) : '" .. suffix .. "' détecté dans : " .. tostring(str))
            return math.huge
        end
    end
    
    return num
end

local SolaraManager = {
    GuiName = "LeyleysCheat_V25",
    ActiveTab = "Game",
    CurrentTheme = Themes.Default,
    
    ClickDelay = 0.1,
    IsClicking = false,
    IsAntiAfk = false,
    SpeedOverride = nil,
    JumpOverride = nil,
    SelectedTarget = nil,
    
    ActiveGameConfig = "TycoonLemon",
    
    IsAutoBuying = false,
    MyTycoon = nil,
    TargetTycoonOwner = "",
    
    IsFarmingLemons = false,
    FarmSpeed = 2,
    FarmCache = {}, 
    SpecialCount = 0,
    LastCacheUpdate = 0, 
    
    ThemeObjects = { Backgrounds = {}, Panels = {}, Accents = {}, Strokes = {}, Texts = {} }
}

if CoreGui:FindFirstChild(SolaraManager.GuiName) then
    CoreGui[SolaraManager.GuiName]:Destroy()
elseif LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(SolaraManager.GuiName) then
    LocalPlayer.PlayerGui[SolaraManager.GuiName]:Destroy()
end

local function ApplyTween(obj, properties, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local function CreateButton(parent, name, text, size, pos, bgColor, themeGroup)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = bgColor or SolaraManager.CurrentTheme.PanelBg
    btn.TextColor3 = SolaraManager.CurrentTheme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text
    btn.Parent = parent
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0.2, 0)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = SolaraManager.CurrentTheme.Stroke
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    if themeGroup == "Panel" then 
        table.insert(SolaraManager.ThemeObjects.Panels, btn)
    elseif themeGroup == "Accent" then 
        table.insert(SolaraManager.ThemeObjects.Accents, btn) 
    end
    
    table.insert(SolaraManager.ThemeObjects.Strokes, stroke)
    table.insert(SolaraManager.ThemeObjects.Texts, btn)
    
    btn.MouseEnter:Connect(function() ApplyTween(stroke, {Color = SolaraManager.CurrentTheme.Text}, 0.2) end)
    btn.MouseLeave:Connect(function() ApplyTween(stroke, {Color = SolaraManager.CurrentTheme.Stroke}, 0.2) end)
    
    return btn, stroke
end

local function CreateLabel(parent, name, text, size, pos)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Size = size
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = SolaraManager.CurrentTheme.Text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextScaled = true
    lbl.Text = text
    lbl.Parent = parent
    
    table.insert(SolaraManager.ThemeObjects.Texts, lbl)
    
    return lbl
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
    box.TextScaled = true
    box.Text = ""
    box.Parent = parent
    
    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0.2, 0)
    
    local stroke = Instance.new("UIStroke", box)
    stroke.Color = SolaraManager.CurrentTheme.Stroke
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    table.insert(SolaraManager.ThemeObjects.Panels, box)
    table.insert(SolaraManager.ThemeObjects.Texts, box)
    table.insert(SolaraManager.ThemeObjects.Strokes, stroke)
    
    return box
end

local function UpdateTheme(themeName)
    local newTheme = Themes[themeName]
    if not newTheme then return end
    SolaraManager.CurrentTheme = newTheme
    
    for _, bg in ipairs(SolaraManager.ThemeObjects.Backgrounds) do ApplyTween(bg, {BackgroundColor3 = newTheme.MainBg}, 0.5) end
    for _, pnl in ipairs(SolaraManager.ThemeObjects.Panels) do ApplyTween(pnl, {BackgroundColor3 = newTheme.PanelBg}, 0.5) end
    for _, acc in ipairs(SolaraManager.ThemeObjects.Accents) do ApplyTween(acc, {BackgroundColor3 = newTheme.Accent}, 0.5) end
    for _, strk in ipairs(SolaraManager.ThemeObjects.Strokes) do ApplyTween(strk, {Color = newTheme.Stroke}, 0.5) end
    for _, txt in ipairs(SolaraManager.ThemeObjects.Texts) do ApplyTween(txt, {TextColor3 = newTheme.Text}, 0.5) end
    
    for tabName, btn in pairs(Tabs) do
        local isTarget = (tabName == SolaraManager.ActiveTab)
        ApplyTween(btn, {BackgroundColor3 = isTarget and newTheme.Accent or newTheme.PanelBg}, 0.5)
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SolaraManager.GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local RestoreBtn, _ = CreateButton(ScreenGui, "RestoreBtn", "➕", UDim2.new(0.05,0,0.05,0), UDim2.new(0.02,0,0.95,0), SolaraManager.CurrentTheme.Accent, "Accent")
RestoreBtn.SizeConstraint = Enum.SizeConstraint.RelativeXX
RestoreBtn.AnchorPoint = Vector2.new(0, 1)
RestoreBtn.Visible = false
RestoreBtn.ZIndex = 10

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.45, 0, 0.45, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = SolaraManager.CurrentTheme.MainBg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui
table.insert(SolaraManager.ThemeObjects.Backgrounds, MainFrame)

local constraint = Instance.new("UIAspectRatioConstraint", MainFrame)
constraint.AspectRatio = 1.8

local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0.03, 0)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = SolaraManager.CurrentTheme.Accent
MainStroke.Thickness = 2
table.insert(SolaraManager.ThemeObjects.Strokes, MainStroke)

local CloseBtn, _ = CreateButton(MainFrame, "CloseBtn", "X", UDim2.new(0.05,0,0.08,0), UDim2.new(0.93,0,0.02,0), SolaraManager.CurrentTheme.Danger)
local MinBtn, _ = CreateButton(MainFrame, "MinBtn", "-", UDim2.new(0.05,0,0.08,0), UDim2.new(0.86,0,0.02,0), SolaraManager.CurrentTheme.Warning)

CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy()
    SolaraManager.IsClicking = false 
end)

MinBtn.MouseButton1Click:Connect(function() 
    ApplyTween(MainFrame, {Size = UDim2.new(0,0,0,0)}, 0.2).Completed:Connect(function() 
        MainFrame.Visible = false
        RestoreBtn.Visible = true
        MainFrame.Size = UDim2.new(0.45, 0, 0.45, 0) 
    end) 
end)

RestoreBtn.MouseButton1Click:Connect(function() 
    RestoreBtn.Visible = false
    MainFrame.Size = UDim2.new(0,0,0,0)
    MainFrame.Visible = true
    ApplyTween(MainFrame, {Size = UDim2.new(0.45, 0, 0.45, 0)}, 0.3) 
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0.85, 0, 0.1, 0)
TabBar.Position = UDim2.new(0.02, 0, 0.02, 0)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout", TabBar)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0.015, 0)

local Pages = Instance.new("Folder", MainFrame)
Tabs = {}
local PageFrames = {}

local function SwitchTab(tabName)
    for name, frame in pairs(PageFrames) do 
        frame.Visible = (name == tabName) 
    end
    for name, btn in pairs(Tabs) do 
        ApplyTween(btn, {BackgroundColor3 = (name == tabName) and SolaraManager.CurrentTheme.Accent or SolaraManager.CurrentTheme.PanelBg}, 0.2) 
    end
    SolaraManager.ActiveTab = tabName
end

local function BuildTab(name, order)
    local TabBtn, _ = CreateButton(TabBar, name.."Tab", name, UDim2.new(0.185, 0, 1, 0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg)
    TabBtn.LayoutOrder = order
    
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(0.96, 0, 0.82, 0)
    Page.Position = UDim2.new(0.02, 0, 0.15, 0)
    Page.BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg
    Page.Visible = false
    Page.Parent = Pages
    
    local corner = Instance.new("UICorner", Page)
    corner.CornerRadius = UDim.new(0.03, 0)
    
    table.insert(SolaraManager.ThemeObjects.Panels, Page)
    Tabs[name] = TabBtn
    PageFrames[name] = Page
    
    TabBtn.MouseButton1Click:Connect(function() SwitchTab(name) end)
    return Page
end

local PlayerPage = BuildTab("Player", 1)
local TeleportPage = BuildTab("Teleport", 2)
local ExplorerPage = BuildTab("Explorer", 3)
local GamePage = BuildTab("Game", 4)
local SettingsPage = BuildTab("Settings", 5)

CreateLabel(PlayerPage, "PlayerTitle", "PLAYER SETTINGS", UDim2.new(0.9,0,0.15,0), UDim2.new(0.05,0,0.02,0))

local ClickToggle, _ = CreateButton(PlayerPage, "ClickToggle", "Clicker: OFF", UDim2.new(0.45,0,0.15,0), UDim2.new(0.025,0,0.18,0), SolaraManager.CurrentTheme.Danger)
ClickToggle.MouseButton1Click:Connect(function() 
    SolaraManager.IsClicking = not SolaraManager.IsClicking
    ClickToggle.Text = SolaraManager.IsClicking and "Clicker: RUNNING" or "Clicker: OFF"
    ApplyTween(ClickToggle, {BackgroundColor3 = SolaraManager.IsClicking and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger}) 
end)

local AfkToggle, _ = CreateButton(PlayerPage, "AfkToggle", "Anti-AFK: OFF", UDim2.new(0.45,0,0.15,0), UDim2.new(0.525,0,0.18,0), SolaraManager.CurrentTheme.Danger)
AfkToggle.MouseButton1Click:Connect(function() 
    SolaraManager.IsAntiAfk = not SolaraManager.IsAntiAfk
    AfkToggle.Text = SolaraManager.IsAntiAfk and "Anti-AFK: ON" or "Anti-AFK: OFF"
    ApplyTween(AfkToggle, {BackgroundColor3 = SolaraManager.IsAntiAfk and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger}) 
end)

CreateLabel(PlayerPage, "ModsLbl", "-- STAT MODIFIERS --", UDim2.new(0.9,0,0.1,0), UDim2.new(0.05,0,0.40,0))

local SpeedInput = CreateInput(PlayerPage, "SpeedInput", "WalkSpeed (Ex: 50)", UDim2.new(0.45,0,0.15,0), UDim2.new(0.025,0,0.55,0))
local SpeedBtn, _ = CreateButton(PlayerPage, "SpeedBtn", "Apply Speed", UDim2.new(0.45,0,0.15,0), UDim2.new(0.525,0,0.55,0), SolaraManager.CurrentTheme.Accent)
SpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then 
        SolaraManager.SpeedOverride = val
        SpeedBtn.Text = "Speed: " .. val 
    else 
        SolaraManager.SpeedOverride = nil
        SpeedBtn.Text = "Speed Reset" 
    end
end)

local JumpInput = CreateInput(PlayerPage, "JumpInput", "JumpPower (Ex: 100)", UDim2.new(0.45,0,0.15,0), UDim2.new(0.025,0,0.75,0))
local JumpBtn, _ = CreateButton(PlayerPage, "JumpBtn", "Apply Jump", UDim2.new(0.45,0,0.15,0), UDim2.new(0.525,0,0.75,0), SolaraManager.CurrentTheme.Accent)
JumpBtn.MouseButton1Click:Connect(function()
    local val = tonumber(JumpInput.Text)
    if val then 
        SolaraManager.JumpOverride = val
        JumpBtn.Text = "Jump: " .. val 
    else 
        SolaraManager.JumpOverride = nil
        JumpBtn.Text = "Jump Reset" 
    end
end)

local SelectedLabel = CreateLabel(TeleportPage, "SelectedLabel", "No Target Selected", UDim2.new(0.5,0,0.15,0), UDim2.new(0.45,0,0.05,0))
local PList = Instance.new("ScrollingFrame", TeleportPage)
PList.Size = UDim2.new(0.35, 0, 0.85, 0)
PList.Position = UDim2.new(0.05, 0, 0.05, 0)
PList.BackgroundColor3 = SolaraManager.CurrentTheme.MainBg
PList.ScrollBarThickness = 4
table.insert(SolaraManager.ThemeObjects.Backgrounds, PList)

local PListLayout = Instance.new("UIListLayout", PList)
PListLayout.Padding = UDim.new(0.02, 0)

local function UpdatePlayers()
    for _, c in ipairs(PList:GetChildren()) do 
        if c:IsA("TextButton") then c:Destroy() end 
    end
    
    local players = Players:GetPlayers()
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    for _, p in ipairs(players) do
        if p ~= LocalPlayer then
            local btn, _ = CreateButton(PList, "PBtn", p.Name, UDim2.new(0.95,0,0,30), UDim2.new(), nil, "Panel")
            btn.Font = Enum.Font.Gotham
            btn.MouseButton1Click:Connect(function() 
                SolaraManager.SelectedTarget = p
                SelectedLabel.Text = "Target: " .. p.Name 
            end)
        end
    end
    
    PList.CanvasSize = UDim2.new(0, 0, 0, PListLayout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)
UpdatePlayers()

local TpBtn, _ = CreateButton(TeleportPage, "TpBtn", "TELEPORT TO TARGET", UDim2.new(0.5,0,0.2,0), UDim2.new(0.45,0,0.25,0), nil, "Accent")
TpBtn.MouseButton1Click:Connect(function() 
    if SolaraManager.SelectedTarget and SolaraManager.SelectedTarget.Character and LocalPlayer.Character then 
        LocalPlayer.Character:PivotTo(SolaraManager.SelectedTarget.Character:GetPivot()) 
    end 
end)

local DexBtn, _ = CreateButton(ExplorerPage, "DexBtn", "Launch Dex Explorer", UDim2.new(0.6,0,0.25,0), UDim2.new(0.2,0,0.2,0), Color3.fromRGB(130, 50, 200))
DexBtn.MouseButton1Click:Connect(function()
    DexBtn.Text = "Loading Dex..."
    task.spawn(function()
        local s, _ = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
        if s then 
            DexBtn.Text = "Dex Launched!"
            ApplyTween(DexBtn, {BackgroundColor3 = SolaraManager.CurrentTheme.Success})
        else 
            DexBtn.Text = "Failed to load"
            ApplyTween(DexBtn, {BackgroundColor3 = SolaraManager.CurrentTheme.Danger}) 
        end
        task.wait(2)
        DexBtn.Text = "Launch Dex Explorer"
        ApplyTween(DexBtn, {BackgroundColor3 = Color3.fromRGB(130, 50, 200)})
    end)
end)

CreateLabel(SettingsPage, "SettingsTitle", "UI THEME", UDim2.new(0.9,0,0.15,0), UDim2.new(0.05,0,0.05,0))
local ThemeList = Instance.new("Frame", SettingsPage)
ThemeList.Size = UDim2.new(0.9, 0, 0.6, 0)
ThemeList.Position = UDim2.new(0.05, 0, 0.25, 0)
ThemeList.BackgroundTransparency = 1

local ThemeLayout = Instance.new("UIGridLayout", ThemeList)
ThemeLayout.CellSize = UDim2.new(0.3, 0, 0.3, 0)
ThemeLayout.CellPadding = UDim2.new(0.03, 0, 0.05, 0)
ThemeLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function MakeThemeButton(name, order)
    local btn, _ = CreateButton(ThemeList, name.."ThemeBtn", name, UDim2.new(), UDim2.new(), nil, "Panel")
    btn.LayoutOrder = order
    btn.MouseButton1Click:Connect(function() UpdateTheme(name) end)
end

MakeThemeButton("Default", 1)
MakeThemeButton("Cyberpunk", 2)
MakeThemeButton("Ruby", 3)

local GameSidebar = Instance.new("ScrollingFrame", GamePage)
GameSidebar.Size = UDim2.new(0.3, 0, 0.9, 0)
GameSidebar.Position = UDim2.new(0.02, 0, 0.05, 0)
GameSidebar.BackgroundColor3 = SolaraManager.CurrentTheme.MainBg
GameSidebar.ScrollBarThickness = 2
table.insert(SolaraManager.ThemeObjects.Backgrounds, GameSidebar)

local GameLayout = Instance.new("UIListLayout", GameSidebar)
GameLayout.Padding = UDim.new(0.02, 0)

local GameContentFrame = Instance.new("Frame", GamePage)
GameContentFrame.Size = UDim2.new(0.63, 0, 0.9, 0)
GameContentFrame.Position = UDim2.new(0.35, 0, 0.05, 0)
GameContentFrame.BackgroundTransparency = 1

local GameConfigs = {}

local function SwitchGameConfig(gameName)
    for name, frame in pairs(GameConfigs) do 
        frame.Visible = (name == gameName) 
    end
    SolaraManager.ActiveGameConfig = gameName
end

local TycoonLemonScroll = Instance.new("ScrollingFrame", GameContentFrame)
TycoonLemonScroll.Size = UDim2.new(1, 0, 1, 0)
TycoonLemonScroll.BackgroundTransparency = 1
TycoonLemonScroll.ScrollBarThickness = 4
GameConfigs["TycoonLemon"] = TycoonLemonScroll

local TL_Layout = Instance.new("UIListLayout", TycoonLemonScroll)
TL_Layout.Padding = UDim.new(0, 10)
TL_Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TL_Layout.SortOrder = Enum.SortOrder.LayoutOrder

TL_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TycoonLemonScroll.CanvasSize = UDim2.new(0, 0, 0, TL_Layout.AbsoluteContentSize.Y + 20)
end)

local LemonTitle = CreateLabel(TycoonLemonScroll, "LemonTitle", "🍋 LEMON FARM", UDim2.new(1,0,0,30), UDim2.new())
LemonTitle.LayoutOrder = 1
local FarmStatusLbl = CreateLabel(TycoonLemonScroll, "FarmStatusLbl", "Status: Idle", UDim2.new(1,0,0,20), UDim2.new())
FarmStatusLbl.Font = Enum.Font.Gotham
FarmStatusLbl.LayoutOrder = 2
local ScanTimerLbl = CreateLabel(TycoonLemonScroll, "ScanTimerLbl", "Next Scan: --", UDim2.new(1,0,0,20), UDim2.new())
ScanTimerLbl.Font = Enum.Font.Gotham
ScanTimerLbl.TextColor3 = Color3.fromRGB(150,150,150)
ScanTimerLbl.LayoutOrder = 3

local SpeedFrame = Instance.new("Frame", TycoonLemonScroll)
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 35)
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.LayoutOrder = 4

local FarmSpeedInput = CreateInput(SpeedFrame, "FarmSpeedInput", "Fruits/sec (Max 4)", UDim2.new(0.5,0,1,0), UDim2.new(0,0,0,0))
local FarmSpeedBtn, _ = CreateButton(SpeedFrame, "FarmSpeedBtn", "Apply Speed", UDim2.new(0.45,0,1,0), UDim2.new(0.55,0,0,0), SolaraManager.CurrentTheme.Accent)
FarmSpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FarmSpeedInput.Text)
    if val and val > 0 then
        if val > 4 then val = 4 end
        SolaraManager.FarmSpeed = val
        FarmSpeedBtn.Text = val .. " Fruits/s"
        FarmSpeedInput.Text = tostring(val)
    else
        SolaraManager.FarmSpeed = 2
        FarmSpeedBtn.Text = "Default (2/s)"
    end
end)

local FarmBtn, _ = CreateButton(TycoonLemonScroll, "FarmBtn", "Auto Farm: OFF", UDim2.new(0.9,0,0,40), UDim2.new(), SolaraManager.CurrentTheme.Danger)
FarmBtn.LayoutOrder = 5
FarmBtn.MouseButton1Click:Connect(function()
    SolaraManager.IsFarmingLemons = not SolaraManager.IsFarmingLemons
    FarmBtn.Text = SolaraManager.IsFarmingLemons and "Auto Farm: ON" or "Auto Farm: OFF"
    ApplyTween(FarmBtn, {BackgroundColor3 = SolaraManager.IsFarmingLemons and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger})
    
    if not SolaraManager.IsFarmingLemons then
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        FarmStatusLbl.Text = "Status: Idle"
        ScanTimerLbl.Text = "Next Scan: --"
    end
end)

local Divider = Instance.new("Frame", TycoonLemonScroll)
Divider.Size = UDim2.new(0.8, 0, 0, 2)
Divider.BackgroundColor3 = SolaraManager.CurrentTheme.Stroke
Divider.BorderSizePixel = 0
Divider.LayoutOrder = 6
table.insert(SolaraManager.ThemeObjects.Strokes, Divider)

local TycoonTitle = CreateLabel(TycoonLemonScroll, "TycoonTitle", "🏭 TYCOON AUTO BUY", UDim2.new(1,0,0,30), UDim2.new())
TycoonTitle.LayoutOrder = 7
local TycoonStatusLbl = CreateLabel(TycoonLemonScroll, "TycoonStatusLbl", "Status: Idle", UDim2.new(1,0,0,20), UDim2.new())
TycoonStatusLbl.Font = Enum.Font.Gotham
TycoonStatusLbl.LayoutOrder = 8

local TycoonOwnerInput = CreateInput(TycoonLemonScroll, "TycoonOwnerInput", "Tycoon Owner (Empty = You)", UDim2.new(0.9,0,0,35), UDim2.new())
TycoonOwnerInput.LayoutOrder = 9

local AutoBuyBtn, _ = CreateButton(TycoonLemonScroll, "AutoBuyBtn", "Auto Buy: OFF", UDim2.new(0.9,0,0,40), UDim2.new(), SolaraManager.CurrentTheme.Danger)
AutoBuyBtn.LayoutOrder = 10
AutoBuyBtn.MouseButton1Click:Connect(function()
    SolaraManager.TargetTycoonOwner = TycoonOwnerInput.Text
    SolaraManager.IsAutoBuying = not SolaraManager.IsAutoBuying
    AutoBuyBtn.Text = SolaraManager.IsAutoBuying and "Auto Buy: ON" or "Auto Buy: OFF"
    ApplyTween(AutoBuyBtn, {BackgroundColor3 = SolaraManager.IsAutoBuying and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger})
    
    if not SolaraManager.IsAutoBuying then 
        TycoonStatusLbl.Text = "Status: Idle" 
    end
end)

local SoonConfig = Instance.new("Frame", GameContentFrame)
SoonConfig.Size = UDim2.new(1, 0, 1, 0)
SoonConfig.BackgroundTransparency = 1
SoonConfig.Visible = false
GameConfigs["ComingSoon"] = SoonConfig

CreateLabel(SoonConfig, "SoonTitle", "🚧 COMING SOON", UDim2.new(1,0,0.15,0), UDim2.new(0,0,0,0))
CreateLabel(SoonConfig, "SoonDesc", "Next game script will go here.", UDim2.new(1,0,0.15,0), UDim2.new(0,0,0.2,0)).Font = Enum.Font.Gotham

local TycoonLemonBtn, _ = CreateButton(GameSidebar, "TycoonLemonBtn", "Tycoon & Farm", UDim2.new(0.95,0,0,30), UDim2.new(), nil, "Panel")
TycoonLemonBtn.MouseButton1Click:Connect(function() SwitchGameConfig("TycoonLemon") end)

local SoonBtn, _ = CreateButton(GameSidebar, "SoonBtn", "Coming Soon", UDim2.new(0.95,0,0,30), UDim2.new(), nil, "Panel")
SoonBtn.MouseButton1Click:Connect(function() SwitchGameConfig("ComingSoon") end)

SwitchTab("Game")
SwitchGameConfig("TycoonLemon")

task.spawn(function()
    while ScreenGui.Parent do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hum then
            if SolaraManager.SpeedOverride then hum.WalkSpeed = SolaraManager.SpeedOverride end
            if SolaraManager.JumpOverride then hum.UseJumpPower = true; hum.JumpPower = SolaraManager.JumpOverride end
        end
        
        if SolaraManager.IsClicking then
            pcall(function() 
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end 
            end)
        end
        
        if SolaraManager.IsAutoBuying and char and hrp then
            pcall(function()
                local targetOwnerName = SolaraManager.TargetTycoonOwner
                if targetOwnerName == "" then 
                    targetOwnerName = LocalPlayer.Name 
                end
                
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
                            
                            if string.lower(currentOwner) == string.lower(targetOwnerName) then
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
                    local targetCategories = {Structure = true, Other = true, Multiplier = true}
                    
                    local function ProcessButtonModel(buttonModel)
                        if not buttonModel then return end
                        local buttonPart = buttonModel:FindFirstChild("Button")
                        if buttonPart and buttonPart:IsA("BasePart") then
                            local guiFolder = buttonPart:FindFirstChild("Gui") or buttonModel:FindFirstChild("Gui")
                            
                            if guiFolder then
                                local priceObj = guiFolder:FindFirstChild("Price")
                                if priceObj then
                                    local rawPrice = ""
                                    if priceObj:IsA("TextLabel") or priceObj:IsA("TextBox") or priceObj:IsA("TextButton") then
                                        rawPrice = priceObj.Text
                                    elseif priceObj:IsA("ValueBase") then
                                        rawPrice = tostring(priceObj.Value)
                                    end
                                    
                                    local priceMagObj = guiFolder:FindFirstChild("PriceMag")
                                    if priceMagObj then
                                        local magText = ""
                                        if priceMagObj:IsA("TextLabel") or priceMagObj:IsA("TextBox") or priceMagObj:IsA("TextButton") then
                                            magText = priceMagObj.Text
                                        elseif priceMagObj:IsA("ValueBase") then
                                            magText = tostring(priceMagObj.Value)
                                        end
                                        rawPrice = rawPrice .. magText
                                    end
                                    
                                    local numPrice = ParsePrice(rawPrice)
                                    
                                    if numPrice >= 0 and numPrice ~= math.huge then
                                        table.insert(buttonsToBuy, {
                                            Part = buttonPart,
                                            Price = numPrice,
                                            RawText = rawPrice
                                        })
                                    end
                                end
                            end
                        end
                    end

                    if purchasesFolder then
                        for _, structureFolder in ipairs(purchasesFolder:GetChildren()) do
                            
                            -- 1. Cas classique (Dossier contenant "Buttons")
                            local buttonsFolder = structureFolder:FindFirstChild("Buttons")
                            if buttonsFolder then
                                for _, child in ipairs(buttonsFolder:GetChildren()) do
                                    if targetCategories[child.Name] then
                                        for _, buttonModel in ipairs(child:GetChildren()) do
                                            ProcessButtonModel(buttonModel)
                                        end
                                    elseif child:IsA("Model") then
                                        ProcessButtonModel(child)
                                    end
                                end
                            end
                            
                            -- 2. Cas spécifique : Dossier "Hills"
                            if structureFolder.Name == "Hills" then
                                -- Recherche récursive profonde pour ne louper AUCUN bouton
                                for _, desc in ipairs(structureFolder:GetDescendants()) do
                                    if desc:IsA("Model") and desc:FindFirstChild("Button") then
                                        ProcessButtonModel(desc)
                                    end
                                end
                            end
                            
                        end
                    end
                    
                    if #buttonsToBuy > 0 then
                        table.sort(buttonsToBuy, function(a, b) return a.Price < b.Price end)
                        
                        local targetButton = buttonsToBuy[1]
                        TycoonStatusLbl.Text = string.format("Status: Buying item (%s)", targetButton.RawText)
                        
                        char:PivotTo(targetButton.Part.CFrame * CFrame.new(0, 1, 0))
                        hrp.Velocity = Vector3.zero
                        hrp.RotVelocity = Vector3.zero
                        
                        task.wait(0.5) 
                    else
                        TycoonStatusLbl.Text = "Status: No buttons found."
                        task.wait(1)
                    end
                end
            end)
        else
            SolaraManager.MyTycoon = nil 
        end
        
        if SolaraManager.IsFarmingLemons and char and hrp then
            if tick() - SolaraManager.LastCacheUpdate >= 10 then
                SolaraManager.FarmCache = {}
                SolaraManager.SpecialCount = 0
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not SolaraManager.IsFarmingLemons then break end
                    if obj.Name == "LemonTree" then
                        for _, fruit in ipairs(obj:GetDescendants()) do
                            if fruit.Name == "Fruit" then
                                local clickPart = fruit:FindFirstChild("ClickPart")
                                if clickPart and clickPart:IsA("BasePart") then
                                    local cd = clickPart:FindFirstChildOfClass("ClickDetector")
                                    if cd then
                                        local isSpecial = (fruit:FindFirstChild("SpecialAttachment") ~= nil) or (clickPart:FindFirstChild("SpecialAttachment") ~= nil)
                                        if isSpecial then 
                                            SolaraManager.SpecialCount = SolaraManager.SpecialCount + 1 
                                        end
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
            
            local timeLeft = math.max(0, math.ceil(10 - (tick() - SolaraManager.LastCacheUpdate)))
            ScanTimerLbl.Text = string.format("Next Scan: %d s", timeLeft)
            
            if #SolaraManager.FarmCache > 0 then
                local currentFruit = table.remove(SolaraManager.FarmCache, 1) 
                FarmStatusLbl.Text = string.format("Status: Harvesting (%d left, %d Special)", #SolaraManager.FarmCache, SolaraManager.SpecialCount)
                
                if currentFruit.Part and currentFruit.Part.Parent then
                    if currentFruit.Special then 
                        SolaraManager.SpecialCount = math.max(0, SolaraManager.SpecialCount - 1) 
                    end
                    pcall(function()
                        local totalCycleTime = 1 / SolaraManager.FarmSpeed
                        local waitTime1 = math.max(0.15, totalCycleTime * 0.4) 
                        local waitTime2 = math.max(0.05, totalCycleTime * 0.4)
                        local waitTime3 = math.max(0.1, totalCycleTime * 0.2)
                        
                        char:PivotTo(currentFruit.Part.CFrame * CFrame.new(0, 0, 2.5))
                        hrp.Velocity = Vector3.zero
                        task.wait(waitTime1) 
                        
                        if fireclickdetector then 
                            fireclickdetector(currentFruit.Detector) 
                        end
                        
                        local cam = workspace.CurrentCamera
                        cam.CameraType = Enum.CameraType.Scriptable
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, currentFruit.Part.Position)
                        task.wait(waitTime2)
                        
                        local screenCenter = cam.ViewportSize / 2
                        VirtualUser:Button1Down(screenCenter)
                        task.wait(0.05)
                        VirtualUser:Button1Up(screenCenter)
                        
                        cam.CameraType = Enum.CameraType.Custom
                        task.wait(waitTime3)
                    end)
                end
            else
                FarmStatusLbl.Text = "Status: Waiting for respawns..."
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
