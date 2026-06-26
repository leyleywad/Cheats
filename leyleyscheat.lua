--[[ 
    Leyley's Premium Cheat V6.15 - THE ULTIMATE UPDATE
    - Added: Aimbot (Shift+A), Fly, Inf Jump, Click TP, Waypoints, Distance ESP, Tracers, ESP Settings, Default WS/JP.
    - Removed: AutoClicker, ScrollingFrames from Settings & Music.
    - Fixed: UI borders clipping.
]]--

print("Leyley's Premium Cheat V6.15 loaded")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [ 1. THEMES ]
local Themes = {
    Default = { MainBg = Color3.fromRGB(20,20,25), PanelBg = Color3.fromRGB(30,30,38), Text = Color3.fromRGB(240,240,240), Accent = Color3.fromRGB(90,130,255), Success = Color3.fromRGB(60,180,90), Danger = Color3.fromRGB(220,70,70), Warning = Color3.fromRGB(220,160,50), Stroke = Color3.fromRGB(60,60,75), Group = "Color" },
    Dracula = { MainBg = Color3.fromRGB(40,42,54), PanelBg = Color3.fromRGB(68,71,90), Text = Color3.fromRGB(248,248,242), Accent = Color3.fromRGB(255,121,198), Success = Color3.fromRGB(80,250,123), Danger = Color3.fromRGB(255,85,85), Warning = Color3.fromRGB(241,250,140), Stroke = Color3.fromRGB(98,114,164), Group = "Color" },
    Ocean = { MainBg = Color3.fromRGB(10,25,47), PanelBg = Color3.fromRGB(17,34,64), Text = Color3.fromRGB(204,214,246), Accent = Color3.fromRGB(100,255,218), Success = Color3.fromRGB(0,200,150), Danger = Color3.fromRGB(255,100,100), Warning = Color3.fromRGB(255,200,0), Stroke = Color3.fromRGB(45,55,72), Group = "Color" },
    Midnight = { MainBg = Color3.fromRGB(10,10,15), PanelBg = Color3.fromRGB(20,20,25), Text = Color3.fromRGB(220,220,230), Accent = Color3.fromRGB(120,120,255), Success = Color3.fromRGB(50,255,100), Danger = Color3.fromRGB(255,50,50), Warning = Color3.fromRGB(255,255,50), Stroke = Color3.fromRGB(40,40,50), Group = "Color" },
    Matrix = { MainBg = Color3.fromRGB(10,15,10), PanelBg = Color3.fromRGB(15,25,15), Text = Color3.fromRGB(100,255,100), Accent = Color3.fromRGB(50,200,50), Success = Color3.fromRGB(0,255,0), Danger = Color3.fromRGB(200,50,50), Warning = Color3.fromRGB(200,200,50), Stroke = Color3.fromRGB(30,100,30), Group = "Color" },
    Mario = { MainBg = Color3.fromRGB(20,120,255), PanelBg = Color3.fromRGB(220,40,40), Text = Color3.fromRGB(255,255,255), Accent = Color3.fromRGB(255,210,0), Success = Color3.fromRGB(50,200,50), Danger = Color3.fromRGB(150,0,0), Warning = Color3.fromRGB(255,150,0), Stroke = Color3.fromRGB(0,50,150), Group = "Game" },
    CP2077 = { MainBg = Color3.fromRGB(250,230,50), PanelBg = Color3.fromRGB(20,20,20), Text = Color3.fromRGB(0,255,255), Accent = Color3.fromRGB(255,0,60), Success = Color3.fromRGB(0,255,150), Danger = Color3.fromRGB(200,0,0), Warning = Color3.fromRGB(255,100,0), Stroke = Color3.fromRGB(20,20,20), Group = "Game" }
}
local ColorsList = { {Color3.new(1,0,0),"Red"}, {Color3.new(0,1,0),"Green"}, {Color3.new(0,0,1),"Blue"}, {Color3.new(1,1,1),"White"}, {Color3.new(1,1,0),"Yellow"}, {Color3.new(1,0,1),"Purple"} }

-- [ 2. SUFFIX GENERATOR ]
local SuffixDict = {k=1, m=2, b=3, t=4}; local ord={"thousand","million","billion","trillion","quadrillion","quintillion","sextillion"}
for i,v in ipairs(ord) do SuffixDict[v]=i; SuffixDict[v.."s"]=i end
local function ParsePrice(s) if not s then return math.huge end local l=string.lower(tostring(s)); if l:match("free") then return 0 end; if tonumber(l) then return tonumber(l) end; local n, sf=l:gsub("[^%d%.%a]",""):match("^([%d%.]+)(%a*)$"); if not n then return math.huge end; n=tonumber(n); if sf and sf~="" then if SuffixDict[sf] then n=n*(10^(SuffixDict[sf]*3)) else return math.huge end end; return n end
local function FormatNumber(n) return (type(n)~="number" or n~=n or n==math.huge) and "0" or (n<1000 and tostring(math.floor(n)) or string.format("%.2e", n)) end

-- [ 3. STATE MANAGER ]
local SolaraManager = {
    GuiName = "LeyleysCheat_V6_15", CurrentTheme = Themes.Default, CurrentThemeName = "Default",
    ThemeObjects = { Backgrounds={}, Panels={}, Accents={}, Strokes={}, Texts={}, Dividers={} }, UI = { TabButtons={}, Pages={}, Toggles={}, Inputs={} },
    IsAntiAfk=false, IsNoclip=false, IsESP=false, IsFly=false, IsInfJump=false, IsAimbot=false, IsClickTP=false,
    SpeedOverride=nil, JumpOverride=nil, SelectedTarget=nil, Waypoints={},
    ActiveFarmState="Off", FarmSpeed=2, ActiveBuyState="Off", BuySpeed=2, ActiveSmartState="Off", MyTycoon=nil, FarmCache={}, LastCacheUpdate=0, LastCashValue=0,
    CustomMusicInstance=nil, CustomMusicName="None", CustomMusicId="", CustomMusicVolume=100, Playlists={{Id="",Name=""},{Id="",Name=""},{Id="",Name=""},{Id="",Name=""},{Id="",Name=""}},
    ESP_Settings = { ShowName=true, ShowHealth=true, HealthFormat="Exact", Tracers=false, TracerColorIdx=4, OutlineColorIdx=1 }
}

-- [ 4. HELPERS ]
do local g=CoreGui:FindFirstChild(SolaraManager.GuiName) or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(SolaraManager.GuiName); if g then g:Destroy() end end
local function ApplyTween(o, p, d) local tw = TweenService:Create(o, TweenInfo.new(d or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p); tw:Play(); return tw end
local function TrackTheme(o, c) if c then table.insert(SolaraManager.ThemeObjects[c], o) end end
local function UICorner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, r or 6); return c end
local function UIStroke(p, c, t) local s = Instance.new("UIStroke", p); s.Color = c or SolaraManager.CurrentTheme.Stroke; s.Thickness = t or 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; TrackTheme(s, "Strokes"); return s end
local function Frame(p, n, sz, pos, bg, tg) local f = Instance.new("Frame", p); f.Name=n; f.Size=sz; f.Position=pos; f.BackgroundColor3=bg or SolaraManager.CurrentTheme.MainBg; f.BorderSizePixel=0; TrackTheme(f, tg); return f end
local function Label(p, n, tx, sz, pos, al) local l = Instance.new("TextLabel", p); l.Name=n; l.Size=sz; l.Position=pos; l.BackgroundTransparency=1; l.TextColor3=SolaraManager.CurrentTheme.Text; l.Font=Enum.Font.GothamMedium; l.TextSize=14; l.TextXAlignment=al or Enum.TextXAlignment.Center; l.TextWrapped=true; l.Text=tx; TrackTheme(l, "Texts"); return l end
local function Button(p, n, tx, sz, pos, bg, tg) local b = Instance.new("TextButton", p); b.Name=n; b.Size=sz; b.Position=pos; b.BackgroundColor3=bg or SolaraManager.CurrentTheme.PanelBg; b.TextColor3=SolaraManager.CurrentTheme.Text; b.Font=Enum.Font.GothamBold; b.TextSize=13; b.Text=tx; b.AutoButtonColor=false; UICorner(b); local s = UIStroke(b); TrackTheme(b, tg or "Panels"); TrackTheme(b, "Texts"); b.MouseEnter:Connect(function() ApplyTween(b, {BackgroundTransparency=0.1}) end); b.MouseLeave:Connect(function() ApplyTween(b, {BackgroundTransparency=0}) end); return b end
local function Input(p, n, ph, sz, pos) local i = Instance.new("TextBox", p); i.Name=n; i.Size=sz; i.Position=pos; i.BackgroundColor3=SolaraManager.CurrentTheme.PanelBg; i.TextColor3=SolaraManager.CurrentTheme.Text; i.PlaceholderText=ph; i.Font=Enum.Font.Gotham; i.TextSize=13; i.Text=""; UICorner(i); UIStroke(i); local pad=Instance.new("UIPadding", i); pad.PaddingLeft=UDim.new(0,10); TrackTheme(i, "Panels"); TrackTheme(i, "Texts"); return i end
local function Drag(f, h) local dr, ds, sp = false, nil, nil; h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=true; ds=i.Position; sp=f.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dr=false end end) end end); UserInputService.InputChanged:Connect(function(i) if dr and i.UserInputType==Enum.UserInputType.MouseMovement then f.Position = UDim2.new(sp.X.Scale, sp.X.Offset+(i.Position-ds).X, sp.Y.Scale, sp.Y.Offset+(i.Position-ds).Y) end end) end

-- [ 5. THEMES & SYNC ]
SolaraManager.SyncVisuals = function()
    local d = (SolaraManager.CurrentThemeName == "Default"); local t = SolaraManager.CurrentTheme; local tl = SolaraManager.UI.Toggles; local function gc(s) return s and (d and t.Success or t.Accent) or (d and t.Danger or t.PanelBg) end
    if tl.Afk then tl.Afk.BackgroundColor3=gc(SolaraManager.IsAntiAfk) end; if tl.Noclip then tl.Noclip.BackgroundColor3=gc(SolaraManager.IsNoclip) end; if tl.Esp then tl.Esp.BackgroundColor3=gc(SolaraManager.IsESP) end
    if tl.Fly then tl.Fly.BackgroundColor3=gc(SolaraManager.IsFly) end; if tl.InfJump then tl.InfJump.BackgroundColor3=gc(SolaraManager.IsInfJump) end; if tl.Aimbot then tl.Aimbot.BackgroundColor3=gc(SolaraManager.IsAimbot) end
    if tl.Farm then tl.Farm.BackgroundColor3=gc(SolaraManager.ActiveFarmState=="Normal") end; if tl.SafeFarm then tl.SafeFarm.BackgroundColor3=gc(SolaraManager.ActiveFarmState=="Safe") end
    if tl.Buy then tl.Buy.BackgroundColor3=gc(SolaraManager.ActiveBuyState=="Normal") end; if tl.SafeBuy then tl.SafeBuy.BackgroundColor3=gc(SolaraManager.ActiveBuyState=="Safe") end
    if tl.Smart then tl.Smart.BackgroundColor3=gc(SolaraManager.ActiveSmartState=="Normal") end; if tl.SafeSmart then tl.SafeSmart.BackgroundColor3=gc(SolaraManager.ActiveSmartState=="Safe") end
    if tl.ClickTP then tl.ClickTP.BackgroundColor3=gc(SolaraManager.IsClickTP) end; if tl.Name then tl.Name.BackgroundColor3=gc(SolaraManager.ESP_Settings.ShowName) end; if tl.Health then tl.Health.BackgroundColor3=gc(SolaraManager.ESP_Settings.ShowHealth) end; if tl.Tracer then tl.Tracer.BackgroundColor3=gc(SolaraManager.ESP_Settings.Tracers) end
end
SolaraManager.ApplyTheme = function(tn) if not Themes[tn] then return end; SolaraManager.CurrentTheme=Themes[tn]; SolaraManager.CurrentThemeName=tn; local t=Themes[tn]
    for _,o in ipairs(SolaraManager.ThemeObjects.Backgrounds) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.MainBg},0.3) end end; for _,o in ipairs(SolaraManager.ThemeObjects.Panels) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.PanelBg},0.3) end end; for _,o in ipairs(SolaraManager.ThemeObjects.Accents) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.Accent},0.3) end end; for _,o in ipairs(SolaraManager.ThemeObjects.Strokes) do if o.Parent then ApplyTween(o,{Color=t.Stroke},0.3) end end; for _,o in ipairs(SolaraManager.ThemeObjects.Dividers) do if o.Parent then ApplyTween(o,{BackgroundColor3=t.Stroke},0.3) end end; for _,o in ipairs(SolaraManager.ThemeObjects.Texts) do if o.Parent then ApplyTween(o,{TextColor3=t.Text},0.3) end end
    for n,b in pairs(SolaraManager.UI.TabButtons) do ApplyTween(b,{BackgroundColor3=(n==SolaraManager.ActiveTab) and t.Accent or t.PanelBg},0.3) end; SolaraManager.SyncVisuals()
end

-- [ 6. UI CONSTRUCTION ]
local SG = Instance.new("ScreenGui"); SG.Name=SolaraManager.GuiName; SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true; SG.Parent=pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
local Main = Frame(SG, "Main", UDim2.new(0,800,0,480), UDim2.new(0.5,-400,0.5,-240)); Main.ClipsDescendants=false; UICorner(Main,8); UIStroke(Main, SolaraManager.CurrentTheme.Accent, 2)
local TBar = Frame(Main, "TBar", UDim2.new(1,0,0,40), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); Drag(Main, TBar)
Label(TBar, "TLbl", "  ✨ Leyley's Premium Cheat V6.15", UDim2.new(1,-100,1,0), UDim2.new(), Enum.TextXAlignment.Left).Font=Enum.Font.GothamBold
local ClsB = Button(TBar, "ClsB", "X", UDim2.new(0,30,0,30), UDim2.new(1,-35,0,5), SolaraManager.CurrentTheme.Danger, nil); ClsB.MouseButton1Click:Connect(function() SG:Destroy() end)

local Side = Frame(Main, "Side", UDim2.new(0,160,1,-40), UDim2.new(0,0,0,40), SolaraManager.CurrentTheme.PanelBg, "Panels"); Frame(Side, "Line", UDim2.new(0,1,1,0), UDim2.new(1,-1,0,0), SolaraManager.CurrentTheme.Stroke, "Dividers")
local SBtns = Instance.new("Frame", Side); SBtns.Size=UDim2.new(1,-1,1,0); SBtns.BackgroundTransparency=1; local sLyt=Instance.new("UIListLayout",SBtns); sLyt.Padding=UDim.new(0,5); sLyt.SortOrder=Enum.SortOrder.LayoutOrder; Instance.new("UIPadding",SBtns).PaddingTop=UDim.new(0,10); Instance.new("UIPadding",SBtns).PaddingLeft=UDim.new(0,10); Instance.new("UIPadding",SBtns).PaddingRight=UDim.new(0,10)
local Cont = Frame(Main, "Cont", UDim2.new(1,-160,1,-40), UDim2.new(0,160,0,40)); local cPad=Instance.new("UIPadding",Cont); cPad.PaddingTop=UDim.new(0,15); cPad.PaddingBottom=UDim.new(0,15); cPad.PaddingLeft=UDim.new(0,15); cPad.PaddingRight=UDim.new(0,15)

local function SwitchTab(tn) for n,p in pairs(SolaraManager.UI.Pages) do p.Visible=(n==tn) end; for n,b in pairs(SolaraManager.UI.TabButtons) do ApplyTween(b,{BackgroundColor3=(n==tn) and SolaraManager.CurrentTheme.Accent or SolaraManager.CurrentTheme.PanelBg},0.2) end; SolaraManager.ActiveTab=tn end
local function BuildPage(n, i, o) local b=Button(SBtns, n.."Tb", i.." "..n, UDim2.new(1,0,0,35), UDim2.new(), nil, "Panels"); b.LayoutOrder=o; b.TextXAlignment=Enum.TextXAlignment.Left; Instance.new("UIPadding",b).PaddingLeft=UDim.new(0,10); local p=Instance.new("Frame", Cont); p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.Visible=false; SolaraManager.UI.TabButtons[n]=b; SolaraManager.UI.Pages[n]=p; b.MouseButton1Click:Connect(function() SwitchTab(n) end); return p end

-- PAGE 1: PLAYER
do
    local pP = BuildPage("Player", "👤", 1); local lyt=Instance.new("UIListLayout",pP); lyt.Padding=UDim.new(0,10); lyt.SortOrder=Enum.SortOrder.LayoutOrder
    Label(pP, "pT", "PLAYER MODIFIERS", UDim2.new(1,0,0,25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    local cR = Frame(pP, "cR", UDim2.new(1,0,0,40), UDim2.new(), nil, "Backgrounds"); cR.BackgroundTransparency=1; cR.LayoutOrder=2
    local aTg = Button(cR, "aTg", "Anti-AFK", UDim2.new(0.31,0,1,0), UDim2.new()); local fTg = Button(cR, "fTg", "Fly", UDim2.new(0.31,0,1,0), UDim2.new(0.34,0,0,0)); local ijTg = Button(cR, "ijTg", "Infinite Jump", UDim2.new(0.31,0,1,0), UDim2.new(0.68,0,0,0))
    SolaraManager.UI.Toggles.Afk=aTg; SolaraManager.UI.Toggles.Fly=fTg; SolaraManager.UI.Toggles.InfJump=ijTg
    aTg.MouseButton1Click:Connect(function() SolaraManager.IsAntiAfk=not SolaraManager.IsAntiAfk; SolaraManager.SyncVisuals() end); fTg.MouseButton1Click:Connect(function() SolaraManager.IsFly=not SolaraManager.IsFly; SolaraManager.SyncVisuals() end); ijTg.MouseButton1Click:Connect(function() SolaraManager.IsInfJump=not SolaraManager.IsInfJump; SolaraManager.SyncVisuals() end)
    
    local nR = Frame(pP, "nR", UDim2.new(1,0,0,40), UDim2.new(), nil, "Backgrounds"); nR.BackgroundTransparency=1; nR.LayoutOrder=3
    local nTg = Button(nR, "nTg", "Noclip", UDim2.new(0.48,0,1,0), UDim2.new()); local aimTg = Button(nR, "aimTg", "Aimbot (Shift+A)", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0))
    SolaraManager.UI.Toggles.Noclip=nTg; SolaraManager.UI.Toggles.Aimbot=aimTg
    nTg.MouseButton1Click:Connect(function() SolaraManager.IsNoclip=not SolaraManager.IsNoclip; SolaraManager.SyncVisuals() end); aimTg.MouseButton1Click:Connect(function() SolaraManager.IsAimbot=not SolaraManager.IsAimbot; SolaraManager.SyncVisuals() end)
    
    Label(pP, "sT", "STAT OVERRIDES", UDim2.new(1,0,0,25), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=4
    local function mkStat(n, ph, lo, def) local R=Frame(pP, n.."R", UDim2.new(1,0,0,35), UDim2.new(), nil, "Backgrounds"); R.BackgroundTransparency=1; R.LayoutOrder=lo; local I=Input(R, "I", ph, UDim2.new(0.48,0,1,0), UDim2.new()); local B=Button(R, "B", "Apply", UDim2.new(0.24,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Accent); local D=Button(R, "D", "Default", UDim2.new(0.20,0,1,0), UDim2.new(0.80,0,0,0), SolaraManager.CurrentTheme.Warning); return I,B,D end
    local spI, spB, spD = mkStat("sp", "WalkSpeed (e.g. 50)", 5, 16); local jI, jB, jD = mkStat("j", "JumpPower (e.g. 100)", 6, 50)
    spB.MouseButton1Click:Connect(function() SolaraManager.SpeedOverride=tonumber(spI.Text); spB.Text=SolaraManager.SpeedOverride and "Applied" or "Reset" end); spD.MouseButton1Click:Connect(function() SolaraManager.SpeedOverride=16; spB.Text="Apply" end)
    jB.MouseButton1Click:Connect(function() SolaraManager.JumpOverride=tonumber(jI.Text); jB.Text=SolaraManager.JumpOverride and "Applied" or "Reset" end); jD.MouseButton1Click:Connect(function() SolaraManager.JumpOverride=50; jB.Text="Apply" end)
end

-- PAGE 2: TELEPORT
do
    local tP = BuildPage("Teleport", "🌍", 2); 
    local tL = Frame(tP, "tL", UDim2.new(0.48,0,1,0), UDim2.new(), nil, "Backgrounds"); tL.BackgroundTransparency=1; local tR = Frame(tP, "tR", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), nil, "Backgrounds"); tR.BackgroundTransparency=1
    local lytL = Instance.new("UIListLayout", tL); lytL.Padding=UDim.new(0,10); local lytR = Instance.new("UIListLayout", tR); lytR.Padding=UDim.new(0,10)
    
    -- Players TP
    Label(tL, "plT", "PLAYERS", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left)
    local tpB = Button(tL, "tpB", "TP TO SELECTED", UDim2.new(1,0,0,35), UDim2.new(), SolaraManager.CurrentTheme.Accent)
    tpB.MouseButton1Click:Connect(function() if SolaraManager.SelectedTarget and SolaraManager.SelectedTarget.Character then LocalPlayer.Character:PivotTo(SolaraManager.SelectedTarget.Character:GetPivot()) end end)
    local pLF = Frame(tL, "pLF", UDim2.new(1,0,1,-75), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); UICorner(pLF); UIStroke(pLF)
    local pS = Instance.new("ScrollingFrame", pLF); pS.Size=UDim2.new(1,-10,1,-10); pS.Position=UDim2.new(0,5,0,5); pS.BackgroundTransparency=1; pS.AutomaticCanvasSize=Enum.AutomaticSize.Y; pS.ScrollBarThickness=4; local pSLyt=Instance.new("UIListLayout",pS); pSLyt.Padding=UDim.new(0,5)
    local function Upd() for _,c in ipairs(pS:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end local ps=Players:GetPlayers(); table.sort(ps, function(a,b) return a.Name:lower()<b.Name:lower() end); for _,p in ipairs(ps) do if p~=LocalPlayer then local b=Button(pS, "pb", p.Name, UDim2.new(1,0,0,30), UDim2.new(), SolaraManager.CurrentTheme.MainBg, "Backgrounds"); b.MouseButton1Click:Connect(function() SolaraManager.SelectedTarget=p; tpB.Text="TP TO: "..p.Name end) end end end
    Players.PlayerAdded:Connect(Upd); Players.PlayerRemoving:Connect(Upd); Upd()

    -- Waypoints & Click TP
    local cTP = Button(tR, "cTP", "Click TP (Ctrl+Click)", UDim2.new(1,0,0,35), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.ClickTP=cTP
    cTP.MouseButton1Click:Connect(function() SolaraManager.IsClickTP=not SolaraManager.IsClickTP; SolaraManager.SyncVisuals() end)
    Label(tR, "wpT", "WAYPOINTS", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left)
    local wR = Frame(tR, "wR", UDim2.new(1,0,0,35), UDim2.new(), nil, "Backgrounds"); wR.BackgroundTransparency=1
    local wI = Input(wR, "wI", "Waypoint Name", UDim2.new(0.68,0,1,0), UDim2.new()); local wB = Button(wR, "wB", "Save", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent)
    local wLF = Frame(tR, "wLF", UDim2.new(1,0,1,-120), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); UICorner(wLF); UIStroke(wLF)
    local wS = Instance.new("ScrollingFrame", wLF); wS.Size=UDim2.new(1,-10,1,-10); wS.Position=UDim2.new(0,5,0,5); wS.BackgroundTransparency=1; wS.AutomaticCanvasSize=Enum.AutomaticSize.Y; wS.ScrollBarThickness=4; local wSLyt=Instance.new("UIListLayout",wS); wSLyt.Padding=UDim.new(0,5)
    
    local function RebuildW()
        for _,c in ipairs(wS:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for i,w in ipairs(SolaraManager.Waypoints) do
            local rf = Instance.new("Frame", wS); rf.Size=UDim2.new(1,0,0,30); rf.BackgroundTransparency=1
            local tb = Button(rf, "tb", w.Name, UDim2.new(0.75,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.MainBg, "Backgrounds")
            local db = Button(rf, "db", "X", UDim2.new(0.20,0,1,0), UDim2.new(0.80,0,0,0), SolaraManager.CurrentTheme.Danger)
            tb.MouseButton1Click:Connect(function() if LocalPlayer.Character then LocalPlayer.Character:PivotTo(w.CFrame) end end)
            db.MouseButton1Click:Connect(function() table.remove(SolaraManager.Waypoints, i); RebuildW() end)
        end
    end
    wB.MouseButton1Click:Connect(function() if wI.Text~="" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then table.insert(SolaraManager.Waypoints, {Name=wI.Text, CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame}); wI.Text=""; RebuildW() end end)
end

-- PAGE 3: EXPLORER
do
    local eP = BuildPage("Explorer", "🔍", 3); local eLyt=Instance.new("UIListLayout",eP); eLyt.Padding=UDim.new(0,10)
    Label(eP, "dDesc", "Load Moon Dex Explorer to view the game's file structure. Bypasses most anti-cheats.", UDim2.new(1,0,0,40), UDim2.new(), Enum.TextXAlignment.Left)
    local dB = Button(eP, "dB", "Launch Moon Dex", UDim2.new(1,0,0,50), UDim2.new(), Color3.fromRGB(130,50,200))
    dB.MouseButton1Click:Connect(function() dB.Text="Loading Moon Dex..."; task.spawn(function() local s = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end); dB.Text=s and "Moon Dex Launched!" or "Failed to load!"; ApplyTween(dB,{BackgroundColor3=s and SolaraManager.CurrentTheme.Success or SolaraManager.CurrentTheme.Danger}); task.wait(2); dB.Text="Launch Moon Dex"; ApplyTween(dB,{BackgroundColor3=Color3.fromRGB(130,50,200)}) end) end)
end

-- PAGE 4: GAME
do
    local gP = BuildPage("Game", "🎮", 4); local gC = Instance.new("Frame", gP); gC.Size=UDim2.new(1,0,1,0); gC.BackgroundTransparency=1
    local gSel = Frame(gC, "gSel", UDim2.new(0.3,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); UICorner(gSel); UIStroke(gSel); local slLyt=Instance.new("UIListLayout",gSel); slLyt.Padding=UDim.new(0,5); Instance.new("UIPadding",gSel).PaddingTop=UDim.new(0,5); Instance.new("UIPadding",gSel).PaddingLeft=UDim.new(0,5); Instance.new("UIPadding",gSel).PaddingRight=UDim.new(0,5)
    local gCF = Instance.new("Frame", gC); gCF.Size=UDim2.new(0.68,0,1,0); gCF.Position=UDim2.new(0.32,0,0,0); gCF.BackgroundTransparency=1
    local scr = Instance.new("ScrollingFrame", gCF); scr.Size=UDim2.new(1,0,1,0); scr.BackgroundTransparency=1; scr.AutomaticCanvasSize=Enum.AutomaticSize.Y; scr.ScrollBarThickness=4; local lemLyt=Instance.new("UIListLayout",scr); lemLyt.Padding=UDim.new(0,8); lemLyt.SortOrder=Enum.SortOrder.LayoutOrder
    
    Label(scr, "cT", "💰 ECONOMY STATS", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=1
    SolaraManager.UI.CashStatusLbl = Label(scr, "cS", "Cash: $0", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.CashStatusLbl.LayoutOrder=2; SolaraManager.UI.CashStatusLbl.TextColor3=SolaraManager.CurrentTheme.Success
    SolaraManager.UI.CashRateLbl = Label(scr, "cR", "Est: $0/sec | $0/hr", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.CashRateLbl.LayoutOrder=3; SolaraManager.UI.CashRateLbl.TextColor3=Color3.fromRGB(150,150,150)
    Frame(scr, "d0", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=4
    
    Label(scr, "fT", "🍋 AUTO FARM", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=5
    SolaraManager.UI.FarmStatusLbl = Label(scr, "fS", "Status: Idle", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.FarmStatusLbl.LayoutOrder=6
    local fSR = Instance.new("Frame",scr); fSR.Size=UDim2.new(1,0,0,30); fSR.BackgroundTransparency=1; fSR.LayoutOrder=7
    local fSI = Input(fSR, "fSI", "Speed (1-4)", UDim2.new(0.68,0,1,0), UDim2.new()); local fSB = Button(fSR, "fSB", "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent)
    local fAR = Instance.new("Frame",scr); fAR.Size=UDim2.new(1,0,0,35); fAR.BackgroundTransparency=1; fAR.LayoutOrder=8
    local fB = Button(fAR, "fB", "Normal Farm", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); local sfB = Button(fAR, "sfB", "Safe Farm", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.Farm=fB; SolaraManager.UI.Toggles.SafeFarm=sfB
    Frame(scr, "d1", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=9
    
    Label(scr, "tT", "🏭 TYCOON BUY", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=10
    SolaraManager.UI.TycoonStatusLbl = Label(scr, "tS", "Status: Idle", UDim2.new(1,0,0,15), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.TycoonStatusLbl.LayoutOrder=11
    local bSR = Instance.new("Frame",scr); bSR.Size=UDim2.new(1,0,0,30); bSR.BackgroundTransparency=1; bSR.LayoutOrder=12
    local bSI = Input(bSR, "bSI", "Speed (1-10)", UDim2.new(0.68,0,1,0), UDim2.new()); local bSB = Button(bSR, "bSB", "Set", UDim2.new(0.28,0,1,0), UDim2.new(0.72,0,0,0), SolaraManager.CurrentTheme.Accent)
    local bAR = Instance.new("Frame",scr); bAR.Size=UDim2.new(1,0,0,35); bAR.BackgroundTransparency=1; bAR.LayoutOrder=13
    local aB = Button(bAR, "aB", "Auto Buy", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); local saB = Button(bAR, "saB", "Safe Buy", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.Buy=aB; SolaraManager.UI.Toggles.SafeBuy=saB
    Frame(scr, "d2", UDim2.new(1,0,0,2), UDim2.new(), SolaraManager.CurrentTheme.Stroke, "Dividers").LayoutOrder=14
    
    Label(scr, "smT", "🤖 SMART HYBRID", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left).LayoutOrder=15
    local smAR = Instance.new("Frame",scr); smAR.Size=UDim2.new(1,0,0,35); smAR.BackgroundTransparency=1; smAR.LayoutOrder=16
    local smB = Button(smAR, "smB", "Smart Mix", UDim2.new(0.48,0,1,0), UDim2.new(), SolaraManager.CurrentTheme.PanelBg); local ssmB = Button(smAR, "ssmB", "Safe Smart", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.PanelBg); SolaraManager.UI.Toggles.Smart=smB; SolaraManager.UI.Toggles.SafeSmart=ssmB
    Label(scr, "csL", "🚀 More Coming soon...", UDim2.new(1,0,0,30), UDim2.new(), Enum.TextXAlignment.Center).LayoutOrder=17
    
    Button(gSel, "g1B", "Sell Lemons", UDim2.new(1,0,0,35), UDim2.new(), SolaraManager.CurrentTheme.Accent, "Panels")
    local function UpdG() SolaraManager.SyncVisuals(); if SolaraManager.ActiveFarmState=="Off" and SolaraManager.ActiveSmartState=="Off" then workspace.CurrentCamera.CameraType=Enum.CameraType.Custom; SolaraManager.UI.FarmStatusLbl.Text="Status: Idle" end; if SolaraManager.ActiveBuyState=="Off" and SolaraManager.ActiveSmartState=="Off" then SolaraManager.UI.TycoonStatusLbl.Text="Status: Idle" end end
    fSB.MouseButton1Click:Connect(function() local v=tonumber(fSI.Text); if v and v>0 then SolaraManager.FarmSpeed=math.min(v,4); fSB.Text=tostring(SolaraManager.FarmSpeed) end end); bSB.MouseButton1Click:Connect(function() local v=tonumber(bSI.Text); if v and v>0 then SolaraManager.BuySpeed=math.min(v,10); bSB.Text=tostring(SolaraManager.BuySpeed) end end)
    fB.MouseButton1Click:Connect(function() SolaraManager.ActiveFarmState=(SolaraManager.ActiveFarmState=="Normal") and "Off" or "Normal"; if SolaraManager.ActiveFarmState=="Normal" then SolaraManager.ActiveBuyState="Off"; SolaraManager.ActiveSmartState="Off" end; UpdG() end)
    sfB.MouseButton1Click:Connect(function() SolaraManager.ActiveFarmState=(SolaraManager.ActiveFarmState=="Safe") and "Off" or "Safe"; if SolaraManager.ActiveFarmState=="Safe" then SolaraManager.ActiveBuyState="Off"; SolaraManager.ActiveSmartState="Off" end; SolaraManager.HasSafetyRespawned=false; UpdG() end)
    aB.MouseButton1Click:Connect(function() SolaraManager.ActiveBuyState=(SolaraManager.ActiveBuyState=="Normal") and "Off" or "Normal"; if SolaraManager.ActiveBuyState=="Normal" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveSmartState="Off" end; UpdG() end)
    saB.MouseButton1Click:Connect(function() SolaraManager.ActiveBuyState=(SolaraManager.ActiveBuyState=="Safe") and "Off" or "Safe"; if SolaraManager.ActiveBuyState=="Safe" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveSmartState="Off" end; SolaraManager.HasSafetyRespawned=false; UpdG() end)
    smB.MouseButton1Click:Connect(function() SolaraManager.ActiveSmartState=(SolaraManager.ActiveSmartState=="Normal") and "Off" or "Normal"; if SolaraManager.ActiveSmartState=="Normal" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveBuyState="Off" end; UpdG() end)
    ssmB.MouseButton1Click:Connect(function() SolaraManager.ActiveSmartState=(SolaraManager.ActiveSmartState=="Safe") and "Off" or "Safe"; if SolaraManager.ActiveSmartState=="Safe" then SolaraManager.ActiveFarmState="Off"; SolaraManager.ActiveBuyState="Off" end; SolaraManager.HasSafetyRespawned=false; UpdG() end)
end

-- PAGE 5: MUSIC (No Scroll, Grid)
do
    local mP = BuildPage("Music", "🎵", 5)
    local mL = Frame(mP, "mL", UDim2.new(0.48,0,1,0), UDim2.new(), nil, "Backgrounds"); mL.BackgroundTransparency=1; local mR = Frame(mP, "mR", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), nil, "Backgrounds"); mR.BackgroundTransparency=1
    local lytL = Instance.new("UIListLayout", mL); lytL.Padding=UDim.new(0,10); local lytR = Instance.new("UIListLayout", mR); lytR.Padding=UDim.new(0,10)
    
    Label(mL, "mT", "🎵 PLAYER", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left)
    local mR2 = Frame(mL, "mR2", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); mR2.BackgroundTransparency=1
    local mI = Input(mR2, "mI", "Audio ID", UDim2.new(0.48,0,1,0), UDim2.new()); local vI = Input(mR2, "vI", "Vol: 100", UDim2.new(0.20,0,1,0), UDim2.new(0.52,0,0,0)); local pB = Button(mR2, "pB", "Load", UDim2.new(0.24,0,1,0), UDim2.new(0.76,0,0,0), SolaraManager.CurrentTheme.Accent)
    local mR3 = Frame(mL, "mR3", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); mR3.BackgroundTransparency=1
    local psB = Button(mR3, "psB", "Pause", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.Warning); local stB = Button(mR3, "stB", "Stop", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Danger)
    SolaraManager.UI.MusicStatusLbl = Label(mL, "mSL", "Status: No music playing", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left); SolaraManager.UI.MusicStatusLbl.TextColor3=Color3.fromRGB(150,150,150)
    
    Label(mR, "pT", "📂 PLAYLIST (Max 5)", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left)
    for i=1,5 do
        local r = Frame(mR, "pr"..i, UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); r.BackgroundTransparency=1
        local iI = Input(r, "iI", "ID", UDim2.new(0.23,0,1,0), UDim2.new()); local nI = Input(r, "nI", "Name", UDim2.new(0.43,0,1,0), UDim2.new(0.25,0,0,0))
        local plB = Button(r, "plB", "▶", UDim2.new(0.14,0,1,0), UDim2.new(0.70,0,0,0), SolaraManager.CurrentTheme.Success); local svB = Button(r, "svB", "Save", UDim2.new(0.14,0,1,0), UDim2.new(0.86,0,0,0), SolaraManager.CurrentTheme.Accent)
        table.insert(SolaraManager.UI.PlaylistInputs, {IdInput=iI, NameInput=nI}); svB.MouseButton1Click:Connect(function() SolaraManager.Playlists[i].Id=iI.Text; SolaraManager.Playlists[i].Name=nI.Text; svB.Text="Saved!"; task.wait(1); svB.Text="Save" end)
        plB.MouseButton1Click:Connect(function() if iI.Text~="" then mI.Text=iI.Text; local nid=tonumber(iI.Text); if nid then SolaraManager.CustomMusicId=tostring(nid); if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance:Destroy() end; SolaraManager.CustomMusicName=nI.Text~="" and nI.Text or "Loading..."; local nS=Instance.new("Sound"); nS.SoundId="rbxassetid://"..nid; nS.Looped=true; nS.Volume=SolaraManager.CustomMusicVolume/100; nS.Parent=CoreGui; SolaraManager.CustomMusicInstance=nS; nS:Play(); psB.Text="Pause" end end end)
    end
    pB.MouseButton1Click:Connect(function() local id=tonumber(mI.Text); if not id then return end; SolaraManager.CustomMusicId=tostring(id); local vN=tonumber(string.match(vI.Text,"%d+")); if vN then SolaraManager.CustomMusicVolume=math.max(0,math.min(100,vN)) end; if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance:Destroy() end; SolaraManager.CustomMusicName="Loading..."; local nS=Instance.new("Sound"); nS.SoundId="rbxassetid://"..id; nS.Looped=true; nS.Volume=SolaraManager.CustomMusicVolume/100; nS.Parent=CoreGui; SolaraManager.CustomMusicInstance=nS; nS:Play(); psB.Text="Pause"; task.spawn(function() local s,pI=pcall(function() return MarketplaceService:GetProductInfo(id) end); SolaraManager.CustomMusicName=(s and pI) and pI.Name or "Audio ID: "..id end) end)
    vI.FocusLost:Connect(function() local vN=tonumber(string.match(vI.Text,"%d+")); if vN then SolaraManager.CustomMusicVolume=math.max(0,math.min(100,vN)); vI.Text="Vol: "..SolaraManager.CustomMusicVolume; if SolaraManager.CustomMusicInstance then SolaraManager.CustomMusicInstance.Volume=SolaraManager.CustomMusicVolume/100 end end end)
    psB.MouseButton1Click:Connect(function() local ci=SolaraManager.CustomMusicInstance; if ci then if ci.IsPlaying then ci:Pause(); psB.Text="Resume" else ci:Resume(); psB.Text="Pause" end end end)
    stB.MouseButton1Click:Connect(function() local ci=SolaraManager.CustomMusicInstance; if ci then ci:Stop(); ci.TimePosition=0; psB.Text="Pause" end end)
end

-- PAGE 6: SETTINGS (No Scroll, split 2 columns)
do
    local sP = BuildPage("Settings", "⚙️", 6)
    local sL = Frame(sP, "sL", UDim2.new(0.48,0,1,0), UDim2.new(), nil, "Backgrounds"); sL.BackgroundTransparency=1; local sR = Frame(sP, "sR", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), nil, "Backgrounds"); sR.BackgroundTransparency=1
    local lytL = Instance.new("UIListLayout", sL); lytL.Padding=UDim.new(0,10); local lytR = Instance.new("UIListLayout", sR); lytR.Padding=UDim.new(0,10)
    
    Label(sL, "cT", "💾 CONFIG", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left)
    local cR = Frame(sL, "cR", UDim2.new(1,0,0,35), UDim2.new(), nil, "Backgrounds"); cR.BackgroundTransparency=1
    Button(cR, "svB", "Save", UDim2.new(0.48,0,1,0), UDim2.new(0,0,0,0), SolaraManager.CurrentTheme.Success); Button(cR, "ldB", "Load", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0), SolaraManager.CurrentTheme.Warning)
    
    Label(sL, "esT", "👁️ PLAYER SETTINGS (ESP)", UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left)
    local eTg = Button(sL, "eTg", "Global ESP: OFF", UDim2.new(1,0,0,35), UDim2.new()); SolaraManager.UI.Toggles.Esp=eTg
    eTg.MouseButton1Click:Connect(function() SolaraManager.IsESP=not SolaraManager.IsESP; SolaraManager.SyncVisuals() end)
    
    local r1=Frame(sL, "r1", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); r1.BackgroundTransparency=1
    local bn=Button(r1, "bn", "Show Name: ON", UDim2.new(0.48,0,1,0), UDim2.new()); local bh=Button(r1, "bh", "Show Health: ON", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0)); SolaraManager.UI.Toggles.Name=bn; SolaraManager.UI.Toggles.Health=bh
    bn.MouseButton1Click:Connect(function() SolaraManager.ESP_Settings.ShowName=not SolaraManager.ESP_Settings.ShowName; SolaraManager.SyncVisuals() end); bh.MouseButton1Click:Connect(function() SolaraManager.ESP_Settings.ShowHealth=not SolaraManager.ESP_Settings.ShowHealth; SolaraManager.SyncVisuals() end)
    
    local r2=Frame(sL, "r2", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); r2.BackgroundTransparency=1
    local hf=Button(r2, "hf", "Health: Exact", UDim2.new(0.48,0,1,0), UDim2.new()); local bt=Button(r2, "bt", "Tracers: OFF", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0)); SolaraManager.UI.Toggles.Tracer=bt
    hf.MouseButton1Click:Connect(function() SolaraManager.ESP_Settings.HealthFormat=(SolaraManager.ESP_Settings.HealthFormat=="Exact" and "Percentage" or "Exact"); hf.Text="Health: "..SolaraManager.ESP_Settings.HealthFormat end)
    bt.MouseButton1Click:Connect(function() SolaraManager.ESP_Settings.Tracers=not SolaraManager.ESP_Settings.Tracers; SolaraManager.SyncVisuals() end)

    local r3=Frame(sL, "r3", UDim2.new(1,0,0,30), UDim2.new(), nil, "Backgrounds"); r3.BackgroundTransparency=1
    local tc=Button(r3, "tc", "Tracer C: White", UDim2.new(0.48,0,1,0), UDim2.new()); local oc=Button(r3, "oc", "Outline C: Red", UDim2.new(0.48,0,1,0), UDim2.new(0.52,0,0,0))
    tc.MouseButton1Click:Connect(function() SolaraManager.ESP_Settings.TracerColorIdx=(SolaraManager.ESP_Settings.TracerColorIdx%#ColorsList)+1; tc.Text="Tracer C: "..ColorsList[SolaraManager.ESP_Settings.TracerColorIdx][2] end)
    oc.MouseButton1Click:Connect(function() SolaraManager.ESP_Settings.OutlineColorIdx=(SolaraManager.ESP_Settings.OutlineColorIdx%#ColorsList)+1; oc.Text="Outline C: "..ColorsList[SolaraManager.ESP_Settings.OutlineColorIdx][2] end)

    local function BGrp(t, g) Label(sR, t.."L", t, UDim2.new(1,0,0,20), UDim2.new(), Enum.TextXAlignment.Left); local tg=Instance.new("Frame",sR); tg.BackgroundTransparency=1; local gl=Instance.new("UIGridLayout",tg); gl.CellSize=UDim2.new(0.48,0,0,30); gl.CellPadding=UDim2.new(0.04,0,0,5); local c=0; for tn,td in pairs(Themes) do if td.Group==g then c=c+1; local b=Button(tg, tn.."B", tn, UDim2.new(), UDim2.new(), SolaraManager.CurrentTheme.PanelBg, "Panels"); b.MouseButton1Click:Connect(function() SolaraManager.ApplyTheme(tn) end) end end tg.Size=UDim2.new(1,0,0,math.ceil(c/2)*35) end
    BGrp("🎨 COLOR THEMES", "Color"); BGrp("🕹️ VIDEO GAMES", "Game")
end

SwitchTab("Player"); SolaraManager.SyncVisuals()

-- [ 7. LOOPS & LOGIC ENGINE ]
local ESP_Lines = {}
local flyBV, flyBG

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp then
        if input.KeyCode == Enum.KeyCode.Q and (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) then
            SolaraManager.IsAimbot = not SolaraManager.IsAimbot; SolaraManager.SyncVisuals()
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if SolaraManager.IsInfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Mouse.Button1Down:Connect(function()
    if SolaraManager.IsClickTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and Mouse.Hit then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:PivotTo(CFrame.new(Mouse.Hit.p + Vector3.new(0, 3, 0)))
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if SolaraManager.IsNoclip and LocalPlayer.Character then for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end
    
    local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if SolaraManager.IsFly and c and hrp then
        if not flyBV then flyBV=Instance.new("BodyVelocity",hrp); flyBV.MaxForce=Vector3.new(9e9,9e9,9e9); flyBG=Instance.new("BodyGyro",hrp); flyBG.MaxTorque=Vector3.new(9e9,9e9,9e9); flyBG.P=9e4 end
        local cam = workspace.CurrentCamera; local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir=moveDir+cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir=moveDir-cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir=moveDir-cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir=moveDir+cam.CFrame.RightVector end
        if moveDir.Magnitude>0 then moveDir=moveDir.Unit end
        flyBV.Velocity = moveDir * 50; flyBG.CFrame = cam.CFrame
    else
        if flyBV then flyBV:Destroy(); flyBG:Destroy(); flyBV=nil; flyBG=nil end
    end

    if SolaraManager.IsAimbot and hrp then
        local closest, dist = nil, math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health>0 then
                local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist then dist = d; closest = p.Character.HumanoidRootPart end
            end
        end
        if closest then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closest.Position) end
    end
end)

task.spawn(function()
    while SG.Parent do
        local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); local hum = c and c:FindFirstChild("Humanoid")
        if hum then if SolaraManager.SpeedOverride then hum.WalkSpeed=SolaraManager.SpeedOverride end; if SolaraManager.JumpOverride then hum.UseJumpPower=true; hum.JumpPower=SolaraManager.JumpOverride end end
        
        -- ESP Loop (Includes Box/Outline, Name, Health, Distance, Tracers)
        pcall(function()
            local eF=CoreGui:FindFirstChild("LeyleyESP"); if not eF then eF=Instance.new("Folder", CoreGui); eF.Name="LeyleyESP" end
            if SolaraManager.IsESP then 
                for _,p in ipairs(Players:GetPlayers()) do 
                    if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then 
                        local ph=p.Character.Humanoid; local p_hrp=p.Character.HumanoidRootPart
                        local dist = hrp and math.floor((hrp.Position - p_hrp.Position).Magnitude) or 0
                        local hl = eF:FindFirstChild(p.Name.."_ESP"); if not hl then hl=Instance.new("Highlight", eF); hl.Name=p.Name.."_ESP" end
                        hl.Adornee=p.Character; hl.FillColor=Color3.new(1,0,0); hl.FillTransparency=0.8; hl.OutlineColor=ColorsList[SolaraManager.ESP_Settings.OutlineColorIdx][1]
                        
                        local bg=eF:FindFirstChild(p.Name.."_BG"); if not bg then bg=Instance.new("BillboardGui", eF); bg.Name=p.Name.."_BG"; bg.AlwaysOnTop=true; bg.Size=UDim2.new(0,200,0,50); bg.ExtentsOffset=Vector3.new(0,3,0); local tl=Instance.new("TextLabel", bg); tl.Name="Txt"; tl.Size=UDim2.new(1,0,1,0); tl.BackgroundTransparency=1; tl.Font=Enum.Font.GothamBold; tl.TextSize=14; tl.TextColor3=Color3.new(1,1,1); tl.TextStrokeTransparency=0 end
                        bg.Adornee=p_hrp
                        
                        local txt = ""
                        if SolaraManager.ESP_Settings.ShowName then txt = txt .. p.Name .. "\n" end
                        txt = txt .. "[" .. dist .. " studs]"
                        if SolaraManager.ESP_Settings.ShowHealth then 
                            local hForm = SolaraManager.ESP_Settings.HealthFormat=="Percentage" and math.floor((ph.Health/ph.MaxHealth)*100).."%" or math.floor(ph.Health).."/"..math.floor(ph.MaxHealth)
                            txt = txt .. "\n❤ " .. hForm 
                        end
                        bg.Txt.Text = txt

                        -- Tracers
                        if SolaraManager.ESP_Settings.Tracers then
                            local line = ESP_Lines[p.Name] or Drawing.new("Line")
                            local pos, vis = Camera:WorldToViewportPoint(p_hrp.Position)
                            if vis then line.From=Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To=Vector2.new(pos.X, pos.Y); line.Color=ColorsList[SolaraManager.ESP_Settings.TracerColorIdx][1]; line.Thickness=1; line.Visible=true else line.Visible=false end
                            ESP_Lines[p.Name] = line
                        else
                            if ESP_Lines[p.Name] then ESP_Lines[p.Name].Visible=false end
                        end
                    else
                        if ESP_Lines[p.Name] then ESP_Lines[p.Name].Visible=false end
                    end 
                end 
            else 
                eF:ClearAllChildren(); for _,l in pairs(ESP_Lines) do l.Visible=false end 
            end 
        end)
        
        -- Smart Logic & Farm Logic... (Same as before to save characters, ensures everything works)
        pcall(function() local cl=LocalPlayer.PlayerGui:FindFirstChild("HUD") and LocalPlayer.PlayerGui.HUD:FindFirstChild("Balance") and LocalPlayer.PlayerGui.HUD.Balance:FindFirstChild("Main") and LocalPlayer.PlayerGui.HUD.Balance.Main:FindFirstChild("Cash"); if cl and cl:IsA("TextLabel") then local pNum=ParsePrice(cl.Text); if pNum~=math.huge then SolaraManager.LastCashValue=pNum; if SolaraManager.UI.CashStatusLbl then SolaraManager.UI.CashStatusLbl.Text="Cash: $"..FormatNumber(pNum) end end end end)
        
        local sMP=false; local aFS=SolaraManager.ActiveFarmState; local aBS=SolaraManager.ActiveBuyState; local aSS=SolaraManager.ActiveSmartState
        if #Players:GetPlayers()>1 and (aFS=="Safe" or aBS=="Safe" or aSS=="Safe") then sMP=true; if not SolaraManager.HasSafetyRespawned and hrp then c:PivotTo(CFrame.new(0,93,0)); hrp.Velocity=Vector3.zero; SolaraManager.HasSafetyRespawned=true end else SolaraManager.HasSafetyRespawned=false end
        
        if not sMP then
            local cb=nil
            if (aBS~="Off" or aSS~="Off") and c and hrp then pcall(function() if not SolaraManager.MyTycoon then for _,fol in ipairs(workspace:GetChildren()) do local oV=fol:FindFirstChild("Owner"); if oV and string.lower(oV:IsA("ObjectValue") and oV.Value and oV.Value.Name or oV:IsA("StringValue") and oV.Value or "")==string.lower(LocalPlayer.Name) then SolaraManager.MyTycoon=fol; break end end end if SolaraManager.MyTycoon then local bL={}; local function sB(m) if m and m:FindFirstChild("Button") and m.Button:IsA("BasePart") then local g=m.Button:FindFirstChild("Gui") or m:FindFirstChild("Gui"); if g and g:FindFirstChild("Price") then local pT=(g.Price:IsA("ValueBase") and tostring(g.Price.Value) or g.Price.Text); local mT=(g:FindFirstChild("PriceMag") and (g.PriceMag:IsA("ValueBase") and tostring(g.PriceMag.Value) or g.PriceMag.Text) or ""); local rT=pT..mT; local p=ParsePrice(rT); if p>=0 and p~=math.huge then table.insert(bL, {Part=m.Button, Price=p, Raw=rT}) end end end end if SolaraManager.MyTycoon:FindFirstChild("Purchases") then local cats={Structure=true, Other=true, Multiplier=true, Multipliers=true}; for _,sf in ipairs(SolaraManager.MyTycoon.Purchases:GetChildren()) do if sf:FindFirstChild("Buttons") then for _,cfol in ipairs(sf.Buttons:GetChildren()) do if cats[cfol.Name] then for _,b in ipairs(cfol:GetChildren()) do sB(b) end elseif cfol:IsA("Model") then sB(cfol) end end end if sf.Name=="Hills" then for _,d in ipairs(sf:GetDescendants()) do if d:IsA("Model") and d:FindFirstChild("Button") then sB(d) end end end end end if #bL>0 then table.sort(bL, function(a,b) return a.Price<b.Price end); cb=bL[1] end end end) end
            if aSS~="Off" then if cb and SolaraManager.LastCashValue >= cb.Price then aBS=aSS; aFS="Off" else aFS=aSS; aBS="Off" end end
            if aBS~="Off" and c and hrp and cb then c:PivotTo(cb.Part.CFrame*CFrame.new(0,1,0)); hrp.Velocity=Vector3.zero; hrp.RotVelocity=Vector3.zero; task.wait(1/SolaraManager.BuySpeed) end
            if aFS~="Off" and c and hrp then
                if tick()-SolaraManager.LastCacheUpdate>=10 then SolaraManager.FarmCache={}; for _,wO in ipairs(workspace:GetDescendants()) do if wO.Name=="LemonTree" then for _,fO in ipairs(wO:GetDescendants()) do if fO.Name=="Fruit" and fO:FindFirstChild("ClickPart") and fO.ClickPart:IsA("BasePart") and fO.ClickPart:FindFirstChildOfClass("ClickDetector") then table.insert(SolaraManager.FarmCache, {Part=fO.ClickPart, Detector=fO.ClickPart:FindFirstChildOfClass("ClickDetector")}) end end end end SolaraManager.LastCacheUpdate=tick() end
                if #SolaraManager.FarmCache>0 then local tFD=table.remove(SolaraManager.FarmCache, 1); if tFD.Part and tFD.Part.Parent then pcall(function() c:PivotTo(tFD.Part.CFrame*CFrame.new(0,0,2.5)); hrp.Velocity=Vector3.zero; task.wait(math.max(0.15,(1/SolaraManager.FarmSpeed)*0.4)); if fireclickdetector then fireclickdetector(tFD.Detector) end; task.wait(math.max(0.1,(1/SolaraManager.FarmSpeed)*0.2)) end) end end
            end
        end
        task.wait(SolaraManager.ClickDelay)
    end
end)

LocalPlayer.Idled:Connect(function() if SolaraManager.IsAntiAfk and SG.Parent then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)
