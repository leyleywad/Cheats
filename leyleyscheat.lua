--[[ 
    Leyley's Premium Cheat V6.8
    - Fix: Removed broken forced Game Audio Mute system
    - Fix: Full 100% Config Save/Load (AutoClicker, ESP, Noclip, States, etc.)
    - Fix: UI completely responsive (No more cropped buttons, using strict scales)
    - Architecture: Scoped do...end limits
]]--

print("Leyley's Premium Cheat V6.8 loaded")

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

local Themes = {
    Default = { MainBg = Color3.fromRGB(20, 20, 25), PanelBg = Color3.fromRGB(30, 30, 38), Text = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(90, 130, 255), Success = Color3.fromRGB(60, 180, 90), Danger = Color3.fromRGB(220, 70, 70), Warning = Color3.fromRGB(220, 160, 50), Stroke = Color3.fromRGB(60, 60, 75), Group = "Color" },
    Dracula = { MainBg = Color3.fromRGB(40, 42, 54), PanelBg = Color3.fromRGB(68, 71, 90), Text = Color3.fromRGB(248, 248, 242), Accent = Color3.fromRGB(255, 121, 198), Success = Color3.fromRGB(80, 250, 123), Danger = Color3.fromRGB(255, 85, 85), Warning = Color3.fromRGB(241, 250, 140), Stroke = Color3.fromRGB(98, 114, 164), Group = "Color" },
    Ocean = { MainBg = Color3.fromRGB(10, 25, 47), PanelBg = Color3.fromRGB(17, 34, 64), Text = Color3.fromRGB(204, 214, 246), Accent = Color3.fromRGB(100, 255, 218), Success = Color3.fromRGB(0, 200, 150), Danger = Color3.fromRGB(255, 100, 100), Warning = Color3.fromRGB(255, 200, 0), Stroke = Color3.fromRGB(45, 55, 72), Group = "Color" },
    Midnight = { MainBg = Color3.fromRGB(10, 10, 15), PanelBg = Color3.fromRGB(20, 20, 25), Text = Color3.fromRGB(220, 220, 230), Accent = Color3.fromRGB(120, 120, 255), Success = Color3.fromRGB(50, 255, 100), Danger = Color3.fromRGB(255, 50, 50), Warning = Color3.fromRGB(255, 255, 50), Stroke = Color3.fromRGB(40, 40, 50), Group = "Color" },
    Hacker = { MainBg = Color3.fromRGB(0, 5, 0), PanelBg = Color3.fromRGB(5, 15, 5), Text = Color3.fromRGB(50, 255, 50), Accent = Color3.fromRGB(0, 200, 0), Success = Color3.fromRGB(100, 255, 100), Danger = Color3.fromRGB(200, 0, 0), Warning = Color3.fromRGB(200, 200, 0), Stroke = Color3.fromRGB(0, 50, 0), Group = "Color" }
}

local SolaraManager = {
    GuiName = "LeyleysCheat_V6_8",
    CurrentTheme = Themes.Default,
    CurrentThemeName = "Default",
    ActiveTab = "Player",
    
    ThemeObjects = { Backgrounds = {}, Panels = {}, Accents = {}, Strokes = {}, Texts = {}, Dividers = {} },
    UI = { TabButtons = {}, Pages = {}, PlaylistInputs = {}, Toggles = {}, Inputs = {}, Texts = {} },
    
    IsClicking = false, IsAntiAfk = false, IsNoclip = false, IsESP = false,
    SpeedOverride = nil, JumpOverride = nil, SelectedTarget = nil,
    
    ActiveGameConfig = "SellLemons", ActiveBuyState = "Off", BuySpeed = 2, MyTycoon = nil,
    ActiveFarmState = "Off", FarmSpeed = 2, FarmCache = {}, SpecialCount = 0, LastCacheUpdate = 0,
    HasSafetyRespawned = false, ClickDelay = 0.1, LastCashValue = 0, CashHistory = {},
    
    CustomMusicInstance = nil, CustomMusicName = "Unknown Audio", CustomMusicId = "", CustomMusicVolume = 100,
    
    Playlists = { {Id="", Name=""}, {Id="", Name=""}, {Id="", Name=""}, {Id="", Name=""}, {Id="", Name=""} },
    ConfigFilename = "LeyleysCheat_Config.json"
}

-- [ SUFFIX SYSTEM ]
local SuffixDict = {}
do
    local order = { "thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion", "octillion", "nonillion" }
    for i, name in ipairs(order) do SuffixDict[name] = i; SuffixDict[name.."s"] = i end
    SuffixDict["k"] = 1; SuffixDict["m"] = 2; SuffixDict["b"] = 3; SuffixDict["t"] = 4
end

local function ParsePrice(str)
    if not str then return math.huge end
    local lowerStr = string.lower(tostring(str))
    if string.match(lowerStr, "free") or string.match(lowerStr, "gratuit") then return 0 end
    
    local sciNum = tonumber(lowerStr)
    if sciNum then return sciNum end
    
    local cleanedStr = string.gsub(lowerStr, "[^%d%.%a]", "") 
    local numStr, suffix = string.match(cleanedStr, "^([%d%.]+)(%a*)$")
    
    if not numStr then return math.huge end
    local num = tonumber(numStr)
    if not num then return math.huge end
    
    if suffix and suffix ~= "" then
        local powerIndex = SuffixDict[suffix]
        if powerIndex then 
            num = num * (10 ^ (powerIndex * 3))
        else return math.huge end
    end
    return num
end

local function FormatNumber(num)
    if type(num) ~= "number" or num ~= num or num == math.huge then return "0" end
    if num < 1000 then return tostring(math.floor(num)) end
    return string.format("%.2e", num)
end

-- [ UI BUILDER FUNCS ]
do
    local eGui = CoreGui:FindFirstChild(SolaraManager.GuiName) or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(SolaraManager.GuiName)
    if eGui then eGui:Destroy() end
end

local function ApplyTween(obj, props, dur)
    local tw = TweenService:Create(obj, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function TrackTheme(obj, cat)
    if cat then table.insert(SolaraManager.ThemeObjects[cat], obj) end
end

local function CreateUICorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = p
    return c
end

local function CreateUIStroke(p, col, t)
    local s = Instance.new("UIStroke")
    s.Color = col or SolaraManager.CurrentTheme.Stroke
    s.Thickness = t or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    TrackTheme(s, "Strokes")
    return s
end

local function CreateFrame(p, n, sz, pos, bg, tg)
    local f = Instance.new("Frame")
    f.Name = n; f.Size = sz; f.Position = pos; f.BackgroundColor3 = bg or SolaraManager.CurrentTheme.MainBg
    f.BorderSizePixel = 0; f.Parent = p
    TrackTheme(f, tg)
    return f
end

local function CreateLabel(p, n, txt, sz, pos, alg)
    local l = Instance.new("TextLabel")
    l.Name = n; l.Size = sz; l.Position = pos; l.BackgroundTransparency = 1
    l.TextColor3 = SolaraManager.CurrentTheme.Text; l.Font = Enum.Font.GothamMedium
    l.TextSize = 14; l.TextXAlignment = alg or Enum.TextXAlignment.Center
    l.TextWrapped = true; l.Text = txt; l.Parent = p
    TrackTheme(l, "Texts")
    return l
end

local function CreateButton(p, n, txt, sz, pos, bg, tg)
    local b = Instance.new("TextButton")
    b.Name = n; b.Size = sz; b.Position = pos; b.BackgroundColor3 = bg or SolaraManager.CurrentTheme.PanelBg
    b.TextColor3 = SolaraManager.CurrentTheme.Text; b.Font = Enum.Font.GothamBold; b.TextSize = 13
    b.Text = txt; b.AutoButtonColor = false; b.Parent = p
    CreateUICorner(b, 6)
    local s = CreateUIStroke(b, SolaraManager.CurrentTheme.Stroke, 1)
    TrackTheme(b, tg or "Panels"); TrackTheme(b, "Texts")
    
    b.MouseEnter:Connect(function() ApplyTween(b, {BackgroundTransparency=0.1}); ApplyTween(s, {Color=SolaraManager.CurrentTheme.Text}) end)
    b.MouseLeave:Connect(function() ApplyTween(b, {BackgroundTransparency=0}); ApplyTween(s, {Color=SolaraManager.CurrentTheme.Stroke}) end)
    return b
end

local function CreateInput(p, n, ph, sz, pos)
    local b = Instance.new("TextBox")
    b.Name = n; b.Size = sz; b.Position = pos; b.BackgroundColor3 = SolaraManager.CurrentTheme.PanelBg
    b.TextColor3 = SolaraManager.CurrentTheme.Text; b.PlaceholderText = ph; b.Font = Enum.Font.Gotham
    b.TextSize = 13; b.Text = ""; b.Parent = p
    CreateUICorner(b, 6); CreateUIStroke(b, SolaraManager.CurrentTheme.Stroke, 1)
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0,10); pad.PaddingRight = UDim.new(0,10); pad.Parent = b
    TrackTheme(b, "Panels"); TrackTheme(b, "Texts")
    return b
end

local function EnableDragging(f, dh)
    local dr, di, ds, sp = false, nil, nil, nil
    dh.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dr = true; ds = i.Position; sp = f.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dr = false end end)
        end
    end)
    dh.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
    UserInputService.InputChanged:Connect(function(i)
        if i == di and dr then
            local del = i.Position - ds
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
        end
    end)
end

-- [ VISUAL MANAGER ENGINE ]
SolaraManager.SyncVisuals = function()
    local isD = (SolaraManager.CurrentThemeName == "Default")
    local sT = SolaraManager.CurrentTheme
    local tl = SolaraManager.UI.Toggles
    local il = SolaraManager.UI.Inputs
    
    local function GetCol(s)
        if s then return isD and sT.Success or sT.Accent else return isD and sT.Danger or sT.PanelBg end
    end
    
    if tl.Click then tl.Click.BackgroundColor3 = GetCol(SolaraManager.IsClicking); tl.Click.Text = SolaraManager.IsClicking and "Auto Clicker: ON" or "Auto Clicker: OFF" end
    if tl.Afk then tl.Afk.BackgroundColor3 = GetCol(SolaraManager.IsAntiAfk); tl.Afk.Text = SolaraManager.IsAntiAfk and "Anti-AFK: ON" or "Anti-AFK: OFF" end
    if tl.Noclip then tl.Noclip.BackgroundColor3 = GetCol(SolaraManager.IsNoclip); tl.Noclip.Text = SolaraManager.IsNoclip and "Noclip: ON" or "Noclip: OFF" end
    if tl.Esp then tl.Esp.BackgroundColor3 = GetCol(SolaraManager.IsESP); tl.Esp.Text = SolaraManager.IsESP and "Player ESP: ON" or "Player ESP: OFF" end
    if tl.Farm then tl.Farm.BackgroundColor3 = GetCol(SolaraManager.ActiveFarmState == "Normal") end
    if tl.SafeFarm then tl.SafeFarm.BackgroundColor3 = GetCol(SolaraManager.ActiveFarmState == "Safe") end
    if tl.Buy then tl.Buy.BackgroundColor3 = GetCol(SolaraManager.ActiveBuyState == "Normal") end
    if tl.SafeBuy then tl.SafeBuy.BackgroundColor3 = GetCol(SolaraManager.ActiveBuyState == "Safe") end
    
    if il.Speed then il.Speed.Text = SolaraManager.SpeedOverride and tostring(SolaraManager.SpeedOverride) or "" end
    if il.Jump then il.Jump.Text = SolaraManager.JumpOverride and tostring(SolaraManager.JumpOverride) or "" end
    if il.FarmS then il.FarmS.Text = tostring(SolaraManager.FarmSpeed) end
    if il.BuyS then il.BuyS.Text = tostring(SolaraManager.BuySpeed) end
    
    if il.Vol then il.Vol.Text = "Vol: " .. tostring(SolaraManager.CustomMusicVolume) end
    
    local uiP = SolaraManager.UI.PlaylistInputs
    for idx, ref in ipairs(uiP) do
        local dt = SolaraManager.Playlists[idx]
        if dt then
            ref.IdInput.Text = dt.Id
            ref.NameInput.Text = dt.Name
        end
    end
end

SolaraManager.ApplyTheme = function(tName)
    local sT = Themes[tName]
    if not sT then return end
    SolaraManager.CurrentTheme = sT
    SolaraManager.CurrentThemeName = tName
    
    for _, bObj in ipairs(SolaraManager.ThemeObjects.Backgrounds) do if bObj.Parent then ApplyTween(bObj, {BackgroundColor3 = sT.MainBg}, 0.5) end end
    for _, pObj in ipairs(SolaraManager.ThemeObjects.Panels) do if pObj.Parent then ApplyTween(pObj, {BackgroundColor3 = sT.PanelBg}, 0.5) end end
    for _, aObj in ipairs(SolaraManager.ThemeObjects.Accents) do if aObj.Parent then ApplyTween(aObj, {BackgroundColor3 = sT.Accent}, 0.5) end end
    for _, sObj in ipairs(SolaraManager.ThemeObjects.Strokes) do if sObj.Parent then ApplyTween(sObj, {Color = sT.Stroke}, 0.5) end end
    for _, dObj in ipairs(SolaraManager.ThemeObjects.Dividers) do if dObj.Parent then ApplyTween(dObj, {BackgroundColor3 = sT.Stroke}, 0.5) end end
    for _, tObj in ipairs(SolaraManager.ThemeObjects.Texts) do if tObj.Parent then ApplyTween(tObj, {TextColor3 = sT.Text}, 0.5) end end
    
    if SolaraManager.UI.MainFrameStroke then ApplyTween(SolaraManager.UI.MainFrameStroke, {Color = sT.Accent}, 0.5) end
    
    for lTN, tBtn in pairs(SolaraManager.UI.TabButtons) do 
        local tC = (lTN == SolaraManager.ActiveTab) and sT.Accent or sT.PanelBg
        ApplyTween(tBtn, {BackgroundColor3 = tC}, 0.5) 
    end
    SolaraManager.SyncVisuals()
end

-- [ UI BUILD ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SolaraManager.GuiName; ScreenGui.ResetOnSpawn = false; ScreenGui.IgnoreGuiInset = true; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local RestoreBtn = CreateButton(ScreenGui, "RestoreBtn", "➕ Open", UDim2.new(0,80,0,40), UDim2.new(0,20,1,-60), SolaraManager.CurrentTheme.Accent, "Accents")
RestoreBtn.Visible = false; RestoreBtn.ZIndex = 10

local MainFrame = CreateFrame(ScreenGui, "MainFrame", UDim2.new(0,800,0,480), UDim2.new(0.5,-400,0.5,-240), SolaraManager.CurrentTheme.MainBg, "Backgrounds")
MainFrame.ClipsDescendants = true; CreateUICorner(MainFrame, 8)
SolaraManager.UI.MainFrameStroke = CreateUIStroke(MainFrame, SolaraManager.CurrentTheme.Accent, 2)

local TitleBar = CreateFrame(MainFrame, "TitleBar", UDim2.new(1,0,0,40), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.PanelBg, "Panels")
EnableDragging(MainFrame, TitleBar)
local TitleLabel = CreateLabel(TitleBar, "TitleLabel", "  ✨ Leyley's Premium Cheat V6.8", UDim2.new(1,-100,1,0), UDim2.new(), Enum.TextXAlignment.Left)
TitleLabel.Font = Enum.Font.GothamBold

local CloseBtn = CreateButton(TitleBar, "CloseBtn", "X", UDim2.new(0,30,0,30), UDim2.new(1,-35,0,5), SolaraManager.CurrentTheme.Danger, nil)
local MinBtn = CreateButton(TitleBar, "MinBtn", "-", UDim2.new(0,30,0,30), UDim2.new(1,-70,0,5), SolaraManager.CurrentTheme.Warning, nil)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy(); SolaraManager.IsClicking = false end)
MinBtn.MouseButton1Click:Connect(function() 
    ApplyTween(MainFrame, {Size=UDim2.new(0,800,0,0)}, 0.3).Completed:Connect(function() 
        MainFrame.Visible = false; RestoreBtn.Visible = true; MainFrame.Size = UDim2.new(0,800,0,480) 
    end) 
end)
RestoreBtn.MouseButton1Click:Connect(function() 
    RestoreBtn.Visible = false; MainFrame.Size = UDim2.new(0,800,0,0); MainFrame.Visible = true
    ApplyTween(MainFrame, {Size=UDim2.new(0,800,0,480)}, 0.4) 
end)

local SidebarContainer = CreateFrame(MainFrame, "SidebarContainer", UDim2.new(0,160,1,-40), UDim2.new(0,0,0,40), SolaraManager.CurrentTheme.PanelBg, "Panels")
CreateFrame(SidebarContainer, "SidebarLine", UDim2.new(0,1,1,0), UDim2.new(1,-1,0,0), SolaraManager.CurrentTheme.Stroke, "Dividers")
local SidebarButtonsFrame = Instance.new("Frame", SidebarContainer); SidebarButtonsFrame.Size = UDim2.new(1,-1,1,0); SidebarButtonsFrame.BackgroundTransparency = 1
local sbLayout = Instance.new("UIListLayout", SidebarButtonsFrame); sbLayout.Padding = UDim.new(0,5); sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
local sbPad = Instance.new("UIPadding", SidebarButtonsFrame); sbPad.PaddingTop = UDim.new(0,10); sbPad.PaddingBottom = UDim.new(0,10); sbPad.PaddingLeft = UDim.new(0,10); sbPad.PaddingRight = UDim.new(0,10)

local ContentArea = CreateFrame(MainFrame, "ContentArea", UDim2.new(1,-160,1,-40), UDim2.new(0,160,0,40), SolaraManager.CurrentTheme.MainBg, "Backgrounds")
local cPad = Instance.new("UIPadding", ContentArea); cPad.PaddingTop = UDim.new(0,15); cPad.PaddingBottom = UDim.new(0,15); cPad.PaddingLeft = UDim.new(0,15); cPad.PaddingRight = UDim.new(0,15)

local function SwitchTab(tN)
    for n, p in pairs(SolaraManager.UI.Pages) do p.Visible = (n == tN) end
    for n, b in pairs(SolaraManager.UI.TabButtons) do ApplyTween(b, {BackgroundColor3 = (n == tN) and SolaraManager.CurrentTheme.Accent or SolaraManager.CurrentTheme.PanelBg}, 0.2) end
    SolaraManager.ActiveTab = tN
end

local function BuildPage(n, i, o)
    local btn = CreateButton(SidebarButtonsFrame, n.."Tab", i.." "..n, UDim2.new(1,0,0,35), UDim2.new(), nil, "Panels")
    btn.LayoutOrder = o; btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0,10)
    local pg = Instance.new("Frame", ContentArea); pg.Size = UDim2.new(1,0,1,0); pg.BackgroundTransparency = 1; pg.Visible = false
    SolaraManager.UI.TabButtons[n] = btn; SolaraManager.UI.Pages[n] = pg
    btn.MouseButton1Click:Connect(function() SwitchTab(n) end)
    return pg
end

-- [ PAGE 1: PLAYER ]
do
    local pPage = BuildPage("Player", "👤", 1)
    local lyt = Instance.new("UIListLayout", pPage); lyt.Padding = UDim.new(0,10); lyt.SortOrder = Enum.SortOrder.LayoutOrder
    
    CreateLabel(pPage, "pTitle", "PLAYER MODIFIERS", UDim2.new(1,0,0,25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1
    local cRow = CreateFrame(pPage, "cRow", UDim2.new(1,0,0,40), UDim2.new(), nil, "Backgrounds"); cRow.BackgroundTransparency = 1; cRow.LayoutOrder = 2
    local cTog = CreateButton(cRow, "cTog", "Auto Clicker: OFF", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.PanelBg)
    local aTog = CreateButton(cRow, "aTog", "Anti-AFK: OFF", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg)
    SolaraManager.UI.Toggles.Click = cTog; SolaraManager.UI.Toggles.Afk = aTog
    
    cTog.MouseButton1Click:Connect(function() SolaraManager.IsClicking = not SolaraManager.IsClicking; SolaraManager.SyncVisuals() end)
    aTog.MouseButton1Click:Connect(function() SolaraManager.IsAntiAfk = not SolaraManager.IsAntiAfk; SolaraManager.SyncVisuals() end)
    
    local nRow = CreateFrame(pPage, "nRow", UDim2.new(1,0,0,40), UDim2.new(), nil, "Backgrounds"); nRow.BackgroundTransparency = 1; nRow.LayoutOrder = 3
    local nTog = CreateButton(nRow, "nTog", "Noclip: OFF", UDim2.new(1,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg)
    SolaraManager.UI.Toggles.Noclip = nTog
    nTog.MouseButton1Click:Connect(function() SolaraManager.IsNoclip = not SolaraManager.IsNoclip; SolaraManager.SyncVisuals() end)
    
    CreateLabel(pPage, "sTitle", "STAT OVERRIDES", UDim2.new(1,0,0,25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 4
    local spRow = CreateFrame(pPage, "spRow", UDim2.new(1,0,0,35), UDim2.new(), nil, "Backgrounds"); spRow.BackgroundTransparency = 1; spRow.LayoutOrder = 5
    local spInp = CreateInput(spRow, "spInp", "WalkSpeed (e.g. 50)", UDim2.new(0.68,0,1,0), UDim2.new(0,0,0,0))
    local spBtn = CreateButton(spRow, "spBtn", "Apply", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent)
    SolaraManager.UI.Inputs.Speed = spInp
    spBtn.MouseButton1Click:Connect(function() local v = tonumber(spInp.Text); SolaraManager.SpeedOverride = v; spBtn.Text = v and "Applied" or "Reset" end)
    
    local jRow = CreateFrame(pPage, "jRow", UDim2.new(1,0,0,35), UDim2.new(), nil, "Backgrounds"); jRow.BackgroundTransparency = 1; jRow.LayoutOrder = 6
    local jInp = CreateInput(jRow, "jInp", "JumpPower (e.g. 100)", UDim2.new(0.68,0,1,0), UDim2.new(0,0,0,0))
    local jBtn = CreateButton(jRow, "jBtn", "Apply", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent)
    SolaraManager.UI.Inputs.Jump = jInp
    jBtn.MouseButton1Click:Connect(function() local v = tonumber(jInp.Text); SolaraManager.JumpOverride = v; jBtn.Text = v and "Applied" or "Reset" end)
    
    CreateLabel(pPage, "oTitle", "OTHER PLAYERS", UDim2.new(1,0,0,25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 7
    local eRow = CreateFrame(pPage, "eRow", UDim2.new(1,0,0,40), UDim2.new(), nil, "Backgrounds"); eRow.BackgroundTransparency = 1; eRow.LayoutOrder = 8
    local eTog = CreateButton(eRow, "eTog", "Player ESP: OFF", UDim2.new(1,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg)
    SolaraManager.UI.Toggles.Esp = eTog
    eTog.MouseButton1Click:Connect(function() SolaraManager.IsESP = not SolaraManager.IsESP; SolaraManager.SyncVisuals() end)
end

-- [ PAGE 2: TELEPORT ]
do
    local tPage = BuildPage("Teleport", "🌍", 2)
    local tLyt = Instance.new("UIListLayout", tPage); tLyt.Padding = UDim.new(0,10); tLyt.SortOrder = Enum.SortOrder.LayoutOrder
    local sLbl = CreateLabel(tPage, "sLbl", "Selected: None", UDim2.new(1,0,0,25), UDim2.new(), Enum.TextXAlignment.Left); sLbl.LayoutOrder = 1
    local tpB = CreateButton(tPage, "tpB", "TELEPORT TO PLAYER", UDim2.new(1,0,0,40), UDim2.new(), SolaraManager.CurrentTheme.Accent); tpB.LayoutOrder = 2
    tpB.MouseButton1Click:Connect(function() if SolaraManager.SelectedTarget and SolaraManager.SelectedTarget.Character and LocalPlayer.Character then LocalPlayer.Character:PivotTo(SolaraManager.SelectedTarget.Character:GetPivot()) end end)
    
    local pLF = CreateFrame(tPage, "pLF", UDim2.new(1,0,1,-85), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); pLF.LayoutOrder = 3; CreateUICorner(pLF,6); CreateUIStroke(pLF, nil, 1)
    local pS = Instance.new("ScrollingFrame", pLF); pS.Size = UDim2.new(1,-10,1,-10); pS.Position = UDim2.new(0,5,0,5); pS.BackgroundTransparency = 1; pS.AutomaticCanvasSize = Enum.AutomaticSize.Y; pS.ScrollBarThickness = 4
    local pSLyt = Instance.new("UIListLayout", pS); pSLyt.Padding = UDim.new(0,5)
    
    local function Upd()
        for _, c in ipairs(pS:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local ps = Players:GetPlayers(); table.sort(ps, function(a,b) return a.Name:lower() < b.Name:lower() end)
        for _, p in ipairs(ps) do
            if p ~= LocalPlayer then
                local b = CreateButton(pS, "pb", p.Name, UDim2.new(1,0,0,30), UDim2.new(), SolaraManager.CurrentTheme.MainBg, "Backgrounds")
                b.MouseButton1Click:Connect(function() SolaraManager.SelectedTarget = p; sLbl.Text = "Selected: " .. p.Name end)
            end
        end
    end
    Players.PlayerAdded:Connect(Upd); Players.PlayerRemoving:Connect(Upd); Upd()
end

-- [ PAGE 3: EXPLORER ]
do
    local ePage = BuildPage("Explorer", "🔍", 3)
    local eLyt = Instance.new("UIListLayout", ePage); eLyt.Padding = UDim.new(0,10); eLyt.SortOrder = Enum.SortOrder.LayoutOrder
    CreateLabel(ePage, "dDesc", "Load Moon Dex Explorer to view the game's file structure. Bypasses most anti-cheats.", UDim2.new(1,0,0,40), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1
    local dBtn = CreateButton(ePage, "dBtn", "Launch Moon Dex", UDim2.new(1,0,0,50), UDim2.new(), Color3.fromRGB(130,50,200)); dBtn.LayoutOrder = 2
    dBtn.MouseButton1Click:Connect(function()
        dBtn.Text = "Loading Moon Dex..."
        task.spawn(function()
            local s = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
            dBtn.Text = s and "Moon Dex Launched!" or "Failed to load!"; ApplyTween(dBtn, {BackgroundColor3 = s and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger})
            task.wait(2); dBtn.Text = "Launch Moon Dex"; ApplyTween(dBtn, {BackgroundColor3 = Color3.fromRGB(130,50,200)})
        end)
    end)
end

-- [ PAGE 4: GAME ]
do
    local gPage = BuildPage("Game", "🎮", 4)
    local gC = Instance.new("Frame", gPage); gC.Size = UDim2.new(1,0,1,0); gC.BackgroundTransparency = 1
    local gSel = CreateFrame(gC, "gSel", UDim2.new(0.3,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); CreateUICorner(gSel,6); CreateUIStroke(gSel, nil, 1)
    local slLyt = Instance.new("UIListLayout", gSel); slLyt.Padding = UDim.new(0,5)
    local slPad = Instance.new("UIPadding", gSel); slPad.PaddingTop = UDim.new(0,5); slPad.PaddingLeft = UDim.new(0,5); slPad.PaddingRight = UDim.new(0,5)
    
    local gCF = Instance.new("Frame", gC); gCF.Size = UDim2.new(0.68,0,1,0); gCF.Position = UDim2.new(0.32,0,0,0); gCF.BackgroundTransparency = 1
    local scr = Instance.new("ScrollingFrame", gCF); scr.Size = UDim2.new(1,0,1,0); scr.BackgroundTransparency = 1; scr.AutomaticCanvasSize = Enum.AutomaticSize.Y; scr.ScrollBarThickness = 4
    local lemLyt = Instance.new("UIListLayout", scr); lemLyt.Padding = UDim.new(0,8); lemLyt.SortOrder = Enum.SortOrder.LayoutOrder
    
    CreateLabel(scr, "cT", "💰 ECONOMY STATS", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1
    SolaraManager.UI.CashStatusLbl = CreateLabel(scr, "cS", "Cash: $0", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.CashStatusLbl.LayoutOrder = 2; SolaraManager.UI.CashStatusLbl.TextColor3 = SolaraManager.CurrentTheme.Success
    SolaraManager.UI.CashRateLbl = CreateLabel(scr, "cR", "Est: $0/sec | $0/hr", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.CashRateLbl.LayoutOrder = 3; SolaraManager.UI.CashRateLbl.TextColor3 = Color3.fromRGB(150,150,150)
    CreateFrame(scr, "d0", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder = 4
    
    CreateLabel(scr, "fT", "🍋 AUTO FARM", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 5
    SolaraManager.UI.FarmStatusLbl = CreateLabel(scr, "fS", "Status: Idle", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.FarmStatusLbl.LayoutOrder = 6
    local fSRow = Instance.new("Frame", scr); fSRow.Size = UDim2.new(1,0,0,30); fSRow.BackgroundTransparency = 1; fSRow.LayoutOrder = 7
    local fSInp = CreateInput(fSRow, "fSInp", "Speed (1-4)", UDim2.new(0.68,0,1,0), UDim2.new())
    local fSBtn = CreateButton(fSRow, "fSBtn", "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent)
    SolaraManager.UI.Inputs.FarmS = fSBtn
    
    local fARow = Instance.new("Frame", scr); fARow.Size = UDim2.new(1,0,0,35); fARow.BackgroundTransparency = 1; fARow.LayoutOrder = 8
    local fB = CreateButton(fARow, "fB", "Normal Farm", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg)
    local sfB = CreateButton(fARow, "sfB", "Safe Farm", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg)
    SolaraManager.UI.Toggles.Farm = fB; SolaraManager.UI.Toggles.SafeFarm = sfB
    CreateFrame(scr, "d1", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder = 9
    
    CreateLabel(scr, "tT", "🏭 TYCOON BUY", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 10
    SolaraManager.UI.TycoonStatusLbl = CreateLabel(scr, "tS", "Status: Idle", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.TycoonStatusLbl.LayoutOrder = 11
    local bSRow = Instance.new("Frame", scr); bSRow.Size = UDim2.new(1,0,0,30); bSRow.BackgroundTransparency = 1; bSRow.LayoutOrder = 12
    local bSInp = CreateInput(bSRow, "bSInp", "Speed (1-10)", UDim2.new(0.68,0,1,0), UDim2.new())
    local bSBtn = CreateButton(bSRow, "bSBtn", "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent)
    SolaraManager.UI.Inputs.BuyS = bSBtn
    
    local bARow = Instance.new("Frame", scr); bARow.Size = UDim2.new(1,0,0,35); bARow.BackgroundTransparency = 1; bARow.LayoutOrder = 13
    local aB = CreateButton(bARow, "aB", "Auto Buy", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg)
    local saB = CreateButton(bARow, "saB", "Safe Buy", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg)
    SolaraManager.UI.Toggles.Buy = aB; SolaraManager.UI.Toggles.SafeBuy = saB
    
    local g1B = CreateButton(gSel, "g1B", "Sell Lemons", UDim2.new(1,0,0,35), UDim2.new(), SolaraManager.CurrentTheme.Accent, "Panels")
    
    local function UpdG()
        SolaraManager.SyncVisuals()
        if SolaraManager.ActiveFarmState == "Off" then workspace.CurrentCamera.CameraType = Enum.CameraType.Custom; SolaraManager.UI.FarmStatusLbl.Text = "Status: Idle" end
        if SolaraManager.ActiveBuyState == "Off" then SolaraManager.UI.TycoonStatusLbl.Text = "Status: Idle" end
    end
    
    fSBtn.MouseButton1Click:Connect(function() local v = tonumber(fSInp.Text); if v and v>0 then SolaraManager.FarmSpeed = math.min(v,4); fSBtn.Text = tostring(SolaraManager.FarmSpeed) end end)
    bSBtn.MouseButton1Click:Connect(function() local v = tonumber(bSInp.Text); if v and v>0 then SolaraManager.BuySpeed = math.min(v,10); bSBtn.Text = tostring(SolaraManager.BuySpeed) end end)
    fB.MouseButton1Click:Connect(function() SolaraManager.ActiveFarmState = (SolaraManager.ActiveFarmState == "Normal") and "Off" or "Normal"; if SolaraManager.ActiveFarmState == "Normal" then SolaraManager.ActiveBuyState = "Off" end; UpdG() end)
    sfB.MouseButton1Click:Connect(function() SolaraManager.ActiveFarmState = (SolaraManager.ActiveFarmState == "Safe") and "Off" or "Safe"; if SolaraManager.ActiveFarmState == "Safe" then SolaraManager.ActiveBuyState = "Off" end; SolaraManager.HasSafetyRespawned = false; UpdG() end)
    aB.MouseButton1Click:Connect(function() SolaraManager.ActiveBuyState = (SolaraManager.ActiveBuyState == "Normal") and "Off" or "Normal"; if SolaraManager.ActiveBuyState == "Normal" then SolaraManager.ActiveFarmState = "Off" end; UpdG() end)
    saB.MouseButton1Click:Connect(function() SolaraManager.ActiveBuyState = (SolaraManager.ActiveBuyState == "Safe") and "Off" or "Safe"; if SolaraManager.ActiveBuyState == "Safe" then SolaraManager.ActiveFarmState = "Off" end; SolaraManager.HasSafetyRespawned = false; UpdG() end)
end

-- [ PAGE 5: MUSIC ]
do
    local mPage = BuildPage("Music", "🎵", 5)
    local mScr = Instance.new("ScrollingFrame", mPage); mScr.Size = UDim2.new(1,0,1,0); mScr.BackgroundTransparency = 1; mScr.AutomaticCanvasSize = Enum.AutomaticSize.Y; mScr.ScrollBarThickness = 4
    local mLyt = Instance.new("UIListLayout", mScr); mLyt.Padding = UDim.new(0,5); mLyt.SortOrder = Enum.SortOrder.LayoutOrder
    
    CreateLabel(mScr, "mT", "🎵 CUSTOM MUSIC PLAYER", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1
    local mR2 = CreateFrame(mScr, "mR2", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); mR2.BackgroundTransparency = 1; mR2.LayoutOrder = 2
    local mI = CreateInput(mR2, "mI", "Audio ID", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0))
    local vI = CreateInput(mR2, "vI", "Vol: 100", UDim2.new(0.20,0,1,0), UDim2.new(0.52,0,0,0)); SolaraManager.UI.Inputs.Vol = vI
    local pB = CreateButton(mR2, "pB", "Load", UDim2.new(0.24,0,1,0), UDim2.new(0.76,0,0,0), SolaraManager.CurrentTheme.Accent)
    
    local mR3 = CreateFrame(mScr, "mR3", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); mR3.BackgroundTransparency = 1; mR3.LayoutOrder = 3
    local psB = CreateButton(mR3, "psB", "Pause", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.Warning)
    local stB = CreateButton(mR3, "stB", "Stop", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Danger)
    
    SolaraManager.UI.MusicStatusLbl = CreateLabel(mScr, "mSL", "Status: No music playing", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.MusicStatusLbl.LayoutOrder = 4; SolaraManager.UI.MusicStatusLbl.TextColor3 = Color3.fromRGB(150,150,150)
    CreateFrame(mScr, "sD", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder = 5
    
    CreateLabel(mScr, "pT", "📂 PLAYLIST MANAGER (Max 5)", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 6
    
    for i=1,5 do
        local r = CreateFrame(mScr, "pr"..i, UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); r.BackgroundTransparency = 1; r.LayoutOrder = 6 + i
        local iI = CreateInput(r, "iI", "ID", UDim2.new(0.23,0,1,0), UDim2.new(0,0,0,0))
        local nI = CreateInput(r, "nI", "Name", UDim2.new(0.43,0,1,0), UDim2.new(0.25,0,0,0))
        local plB = CreateButton(r, "plB", "▶", UDim2.new(0.14,0,1,0), UDim2.new(0.70,0,0,0), SolaraManager.CurrentTheme.Success)
        local svB = CreateButton(r, "svB", "Save", UDim2.new(0.14,0,1,0), UDim2.new(0.86,0,0,0), SolaraManager.CurrentTheme.Accent)
        
        table.insert(SolaraManager.UI.PlaylistInputs, {IdInput=iI, NameInput=nI})
        
        svB.MouseButton1Click:Connect(function() SolaraManager.Playlists[i].Id = iI.Text; SolaraManager.Playlists[i].Name = nI.Text; svB.Text="Saved!"; task.wait(1); svB.Text="Save" end)
        plB.MouseButton1Click:Connect(function()
            if iI.Text~="" then
                mI.Text = iI.Text; local nid = tonumber(iI.Text)
                if nid then
                    SolaraManager.CustomMusicId = tostring(nid); if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance:Destroy() end
                    SolaraManager.CustomMusicName = nI.Text~="" and nI.Text or "Loading..."
                    local nS = Instance.new("Sound"); nS.SoundId = "rbxassetid://"..nid; nS.Looped = true; nS.Volume = SolaraManager.CustomMusicVolume/100; nS.Parent = CoreGui
                    SolaraManager.CustomMusicInstance = nS; nS:Play(); psB.Text = "Pause"
                end
            end
        end)
    end
    
    pB.MouseButton1Click:Connect(function()
        local id = tonumber(mI.Text); if not id then return end
        SolaraManager.CustomMusicId = tostring(id)
        local vN = tonumber(string.match(vI.Text, "%d+")); if vN then SolaraManager.CustomMusicVolume = math.max(0, math.min(100, vN)) end
        if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance:Destroy() end
        SolaraManager.CustomMusicName = "Loading..."
        local nS = Instance.new("Sound"); nS.SoundId = "rbxassetid://"..id; nS.Looped = true; nS.Volume = SolaraManager.CustomMusicVolume/100; nS.Parent = CoreGui
        SolaraManager.CustomMusicInstance = nS; nS:Play(); psB.Text = "Pause"
        task.spawn(function() local s, pI = pcall(function() return MarketplaceService:GetProductInfo(id) end); SolaraManager.CustomMusicName = (s and pI) and pI.Name or "Audio ID: "..id end)
    end)
    
    vI.FocusLost:Connect(function() local vN = tonumber(string.match(vI.Text, "%d+")); if vN then SolaraManager.CustomMusicVolume = math.max(0, math.min(100, vN)); vI.Text = "Vol: "..SolaraManager.CustomMusicVolume; if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance.Volume = SolaraManager.CustomMusicVolume/100 end end end)
    psB.MouseButton1Click:Connect(function() local ci = SolaraManager.CustomMusicInstance; if ci then if ci.IsPlaying then ci:Pause(); psB.Text="Resume" else ci:Resume(); psB.Text="Pause" end end end)
    stB.MouseButton1Click:Connect(function() local ci = SolaraManager.CustomMusicInstance; if ci then ci:Stop(); ci.TimePosition=0; psB.Text="Pause" end end)
end

-- [ PAGE 6: SETTINGS ]
do
    local sPage = BuildPage("Settings", "⚙️", 6)
    local sScr = Instance.new("ScrollingFrame", sPage); sScr.Size = UDim2.new(1,0,1,0); sScr.BackgroundTransparency = 1; sScr.AutomaticCanvasSize = Enum.AutomaticSize.Y; sScr.ScrollBarThickness = 4
    local sLyt = Instance.new("UIListLayout", sScr); sLyt.Padding = UDim.new(0,5); sLyt.SortOrder = Enum.SortOrder.LayoutOrder
    
    CreateLabel(sScr, "cT", "💾 SCRIPT CONFIG", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = 1
    local cR = CreateFrame(sScr, "cR", UDim2.new(1,0,0,35), UDim2.new(), nil, "Backgrounds"); cR.BackgroundTransparency = 1; cR.LayoutOrder = 2
    local svB = CreateButton(cR, "svB", "Save Config", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.Success)
    local ldB = CreateButton(cR, "ldB", "Load Config", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Warning)
    CreateFrame(sScr, "dC", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder = 3
    
    svB.MouseButton1Click:Connect(function()
        local cD = {
            Theme = SolaraManager.CurrentThemeName, IsClicking = SolaraManager.IsClicking, IsAntiAfk = SolaraManager.IsAntiAfk,
            IsNoclip = SolaraManager.IsNoclip, IsESP = SolaraManager.IsESP, Speed = SolaraManager.SpeedOverride, Jump = SolaraManager.JumpOverride,
            FarmSpeed = SolaraManager.FarmSpeed, BuySpeed = SolaraManager.BuySpeed, ActiveFarmState = SolaraManager.ActiveFarmState, ActiveBuyState = SolaraManager.ActiveBuyState,
            CustomMusicId = SolaraManager.CustomMusicId, CustomMusicVolume = SolaraManager.CustomMusicVolume, Playlists = SolaraManager.Playlists
        }
        if writefile then writefile(SolaraManager.ConfigFilename, HttpService:JSONEncode(cD)); svB.Text="Saved!"; task.wait(1); svB.Text="Save Config" end
    end)
    
    ldB.MouseButton1Click:Connect(function()
        if readfile and isfile and isfile(SolaraManager.ConfigFilename) then
            local cD = HttpService:JSONDecode(readfile(SolaraManager.ConfigFilename))
            if cD then
                if cD.IsClicking~=nil then SolaraManager.IsClicking = cD.IsClicking end
                if cD.IsAntiAfk~=nil then SolaraManager.IsAntiAfk = cD.IsAntiAfk end
                if cD.IsNoclip~=nil then SolaraManager.IsNoclip = cD.IsNoclip end
                if cD.IsESP~=nil then SolaraManager.IsESP = cD.IsESP end
                SolaraManager.SpeedOverride = cD.Speed; SolaraManager.JumpOverride = cD.Jump
                if cD.FarmSpeed then SolaraManager.FarmSpeed = cD.FarmSpeed end
                if cD.BuySpeed then SolaraManager.BuySpeed = cD.BuySpeed end
                if cD.ActiveFarmState then SolaraManager.ActiveFarmState = cD.ActiveFarmState end
                if cD.ActiveBuyState then SolaraManager.ActiveBuyState = cD.ActiveBuyState end
                if cD.CustomMusicId then SolaraManager.CustomMusicId = cD.CustomMusicId end
                if cD.CustomMusicVolume then SolaraManager.CustomMusicVolume = cD.CustomMusicVolume end
                if cD.Playlists then SolaraManager.Playlists = cD.Playlists end
                if cD.Theme then SolaraManager.ApplyTheme(cD.Theme) else SolaraManager.SyncVisuals() end
                ldB.Text="Loaded!"; task.wait(1); ldB.Text="Load Config"
            end
        end
    end)
    
    local function BGrp(t, g, o)
        CreateLabel(sScr, t.."L", t, UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder = o
        local tg = Instance.new("Frame", sScr); tg.BackgroundTransparency = 1; tg.LayoutOrder = o+1
        local gl = Instance.new("UIGridLayout", tg); gl.CellSize = UDim2.new(0.31,0,0,30); gl.CellPadding = UDim2.new(0.035,0,0,5); gl.SortOrder = Enum.SortOrder.LayoutOrder
        local c = 0
        for tn, td in pairs(Themes) do
            if td.Group == g then
                c = c + 1; local b = CreateButton(tg, tn.."B", tn, UDim2.new(), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels")
                b.MouseButton1Click:Connect(function() SolaraManager.ApplyTheme(tn) end)
            end
        end
        tg.Size = UDim2.new(1,0,0, math.ceil(c/3)*35); return o+2
    end
    BGrp("🕹️ VIDEO GAMES THEMES", "Game", BGrp("🎨 COLOR THEMES", "Color", 4))
end

SwitchTab("Player"); SolaraManager.SyncVisuals()

-- [ LOOPS & LOGIC ]
RunService.Stepped:Connect(function()
    if SolaraManager.IsNoclip and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); local hum = c and c:FindFirstChild("Humanoid")
        if hum then
            if SolaraManager.SpeedOverride then hum.WalkSpeed = SolaraManager.SpeedOverride end
            if SolaraManager.JumpOverride then hum.UseJumpPower = true; hum.JumpPower = SolaraManager.JumpOverride end
        end
        
        if SolaraManager.IsClicking then pcall(function() local t = c and c:FindFirstChildOfClass("Tool"); if t then t:Activate() end end) end
        
        local cm = SolaraManager.CustomMusicInstance; local msl = SolaraManager.UI.MusicStatusLbl
        if cm and cm.IsLoaded then
            local p = cm.TimePosition; local l = cm.TimeLength
            if msl then msl.Text = string.format("Now Playing: %s | %02d:%02d / %02d:%02d", SolaraManager.CustomMusicName, p/60, p%60, l/60, l%60) end
        else
            if msl and msl.Text ~= "Status: No music playing" then msl.Text = "Status: No music playing" end
        end
        
        pcall(function()
            local eF = CoreGui:FindFirstChild("LeyleyESP")
            if not eF then eF = Instance.new("Folder"); eF.Name = "LeyleyESP"; eF.Parent = CoreGui end
            if SolaraManager.IsESP then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local h = eF:FindFirstChild(p.Name.."_ESP")
                        if not h then h = Instance.new("Highlight"); h.Name = p.Name.."_ESP"; h.FillColor = Color3.new(1,0,0); h.OutlineColor = Color3.new(1,1,1); h.Parent = eF end
                        h.Adornee = p.Character
                    end
                end
            else eF:ClearAllChildren() end
        end)
        
        pcall(function()
            local cl = LocalPlayer.PlayerGui:FindFirstChild("HUD") and LocalPlayer.PlayerGui.HUD:FindFirstChild("Balance") and LocalPlayer.PlayerGui.HUD.Balance:FindFirstChild("Main") and LocalPlayer.PlayerGui.HUD.Balance.Main:FindFirstChild("Cash")
            if cl and cl:IsA("TextLabel") then
                local pNum = ParsePrice(cl.Text)
                if pNum ~= math.huge then
                    if SolaraManager.UI.CashStatusLbl then SolaraManager.UI.CashStatusLbl.Text = "Cash: $" .. FormatNumber(pNum) end
                    if pNum ~= SolaraManager.LastCashValue then
                        SolaraManager.LastCashValue = pNum; table.insert(SolaraManager.CashHistory, {time = tick(), cash = pNum})
                        while #SolaraManager.CashHistory > 0 and (tick() - SolaraManager.CashHistory[1].time > 15) do table.remove(SolaraManager.CashHistory, 1) end
                    end
                    local ch = SolaraManager.CashHistory
                    if #ch > 1 then
                        local dt = ch[#ch].time - ch[1].time; local dc = ch[#ch].cash - ch[1].cash
                        if dt > 0 and dc >= 0 and SolaraManager.UI.CashRateLbl then
                            SolaraManager.UI.CashRateLbl.Text = string.format("Est: $%s/sec | $%s/hr", FormatNumber(dc/dt), FormatNumber((dc/dt)*3600))
                        end
                    else if SolaraManager.UI.CashRateLbl then SolaraManager.UI.CashRateLbl.Text = "Est: $0/sec | $0/hr" end end
                end
            end
        end)
        
        local sMP = false; local aFS = SolaraManager.ActiveFarmState; local aBS = SolaraManager.ActiveBuyState
        if #Players:GetPlayers() > 1 and (aFS == "Safe" or aBS == "Safe") then
            sMP = true
            if not SolaraManager.HasSafetyRespawned and c and hrp then c:PivotTo(CFrame.new(0,103,0)); hrp.Velocity = Vector3.zero; hrp.RotVelocity = Vector3.zero; SolaraManager.HasSafetyRespawned = true end
            if aFS == "Safe" and SolaraManager.UI.FarmStatusLbl then SolaraManager.UI.FarmStatusLbl.Text = "Status: PAUSED (Player in server)" end
            if aBS == "Safe" and SolaraManager.UI.TycoonStatusLbl then SolaraManager.UI.TycoonStatusLbl.Text = "Status: PAUSED (Player in server)" end
        else SolaraManager.HasSafetyRespawned = false end
        
        if not sMP then
            if aBS ~= "Off" and c and hrp then
                pcall(function()
                    if not SolaraManager.MyTycoon then
                        for _, fol in ipairs(workspace:GetChildren()) do
                            local oV = fol:FindFirstChild("Owner")
                            if oV and string.lower(oV:IsA("ObjectValue") and oV.Value and oV.Value.Name or oV:IsA("StringValue") and oV.Value or "") == string.lower(LocalPlayer.Name) then SolaraManager.MyTycoon = fol; break end
                        end
                    end
                    if SolaraManager.MyTycoon then
                        local bL = {}; local function sB(m)
                            if m and m:FindFirstChild("Button") and m.Button:IsA("BasePart") then
                                local g = m.Button:FindFirstChild("Gui") or m:FindFirstChild("Gui")
                                if g and g:FindFirstChild("Price") then
                                    local p = ParsePrice((g.Price:IsA("ValueBase") and tostring(g.Price.Value) or g.Price.Text) .. (g:FindFirstChild("PriceMag") and (g.PriceMag:IsA("ValueBase") and tostring(g.PriceMag.Value) or g.PriceMag.Text) or ""))
                                    if p >= 0 and p ~= math.huge then table.insert(bL, {Part=m.Button, Price=p, Raw=g.Price.Text}) end
                                end
                            end
                        end
                        if SolaraManager.MyTycoon:FindFirstChild("Purchases") then for _, sf in ipairs(SolaraManager.MyTycoon.Purchases:GetChildren()) do if sf:FindFirstChild("Buttons") then for _, cfol in ipairs(sf.Buttons:GetChildren()) do sB(cfol) end end if sf.Name=="Hills" then for _, d in ipairs(sf:GetDescendants()) do if d:IsA("Model") and d:FindFirstChild("Button") then sB(d) end end end end end
                        if #bL > 0 then
                            table.sort(bL, function(a,b) return a.Price < b.Price end); local cb = bL[1]
                            if SolaraManager.UI.TycoonStatusLbl then SolaraManager.UI.TycoonStatusLbl.Text = "Status: Buying ("..cb.Raw..")" end
                            c:PivotTo(cb.Part.CFrame * CFrame.new(0,1,0)); hrp.Velocity = Vector3.zero; hrp.RotVelocity = Vector3.zero
                            task.wait(1/SolaraManager.BuySpeed)
                        else if SolaraManager.UI.TycoonStatusLbl then SolaraManager.UI.TycoonStatusLbl.Text = "Status: No buttons found." end; task.wait(1) end
                    end
                end)
            end
            
            if aFS ~= "Off" and c and hrp then
                if tick() - SolaraManager.LastCacheUpdate >= 10 then
                    SolaraManager.FarmCache = {}; SolaraManager.SpecialCount = 0
                    for _, wO in ipairs(workspace:GetDescendants()) do
                        if wO.Name == "LemonTree" then
                            for _, fO in ipairs(wO:GetDescendants()) do
                                if fO.Name == "Fruit" and fO:FindFirstChild("ClickPart") and fO.ClickPart:IsA("BasePart") and fO.ClickPart:FindFirstChildOfClass("ClickDetector") then
                                    local isS = fO:FindFirstChild("SpecialAttachment") or fO.ClickPart:FindFirstChild("SpecialAttachment")
                                    if isS then SolaraManager.SpecialCount = SolaraManager.SpecialCount + 1 end
                                    table.insert(SolaraManager.FarmCache, {Part=fO.ClickPart, Detector=fO.ClickPart:FindFirstChildOfClass("ClickDetector"), Special=isS~=nil})
                                end
                            end
                        end
                    end
                    table.sort(SolaraManager.FarmCache, function(a,b) return a.Special and not b.Special end); SolaraManager.LastCacheUpdate = tick()
                end
                
                if #SolaraManager.FarmCache > 0 then
                    local tFD = table.remove(SolaraManager.FarmCache, 1)
                    if SolaraManager.UI.FarmStatusLbl then SolaraManager.UI.FarmStatusLbl.Text = string.format("Status: Harvesting (%d left, %d Special)", #SolaraManager.FarmCache, SolaraManager.SpecialCount) end
                    if tFD.Part and tFD.Part.Parent then
                        if tFD.Special then SolaraManager.SpecialCount = math.max(0, SolaraManager.SpecialCount - 1) end
                        pcall(function()
                            c:PivotTo(tFD.Part.CFrame * CFrame.new(0,0,2.5)); hrp.Velocity = Vector3.zero; task.wait(math.max(0.15, (1/SolaraManager.FarmSpeed)*0.4))
                            if fireclickdetector then fireclickdetector(tFD.Detector) end
                            local cam = workspace.CurrentCamera; cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = CFrame.lookAt(cam.CFrame.Position, tFD.Part.Position)
                            task.wait(math.max(0.05, (1/SolaraManager.FarmSpeed)*0.4))
                            local sc = cam.ViewportSize / 2; VirtualUser:Button1Down(sc); task.wait(0.05); VirtualUser:Button1Up(sc)
                            cam.CameraType = Enum.CameraType.Custom; cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + hrp.CFrame.LookVector*10)
                            task.wait(math.max(0.1, (1/SolaraManager.FarmSpeed)*0.2))
                        end)
                    end
                else if SolaraManager.UI.FarmStatusLbl then SolaraManager.UI.FarmStatusLbl.Text = "Status: Waiting for respawns..." end end
            end
        end
        task.wait(SolaraManager.ClickDelay)
    end
end)

LocalPlayer.Idled:Connect(function() if SolaraManager.IsAntiAfk and ScreenGui.Parent then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)
